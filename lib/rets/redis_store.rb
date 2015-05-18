require 'http-cookie'
require 'json'

module Rets
  class RedisStore < HTTP::CookieJar::AbstractStore
    def default_options
      {}
    end
    private :default_options
    attr_reader :redis, :sjar

    def initialize(options={})
      @redis = options[:redis] or raise ArgumentError, ':redis option is missing'
      #@sjar = HTTP::CookieJar::HashStore.new
    end

    # This is an abstract method that each subclass must override.
    def initialize_copy(other)
      raise TypeError, 'can\'t clone %s' % self.class
    end

    def redis_add(cookie)
      baseDomain = cookie.domain_name.domain || cookie.domain
      json = JSON.dump({
        'baseDomain'   => baseDomain,
        'name'         => cookie.name,
        'value'        => cookie.value,
        'host'         => cookie.dot_domain,
        'path'         => cookie.path,
        'expiry'       => cookie.expires_at.to_i,
        'isSecure'     => cookie.secure? ? 1 : 0,
        'isHttpOnly'   => cookie.httponly? ? 1 : 0,
      })
      redis.hset(baseDomain, "#{cookie.path}:#{cookie.name}", json)
    end

    def redis_delete(cookie)
      redis.hdel(cookie.domain, "#{cookie.path}:#{cookie.name}")
    end

    # Implements HTTP::CookieJar#add().
    #
    # This is an abstract method that each subclass must override.
    def add(cookie)
      redis_add(cookie)
    end

    # Implements HTTP::CookieJar#delete().
    #
    # This is an abstract method that each subclass must override.
    def delete(cookie)
      redis_delete(cookie)
    end

    # Iterates over all cookies that are not expired.
    #
    # An optional argument +uri+ specifies a URI object indicating the
    # destination of the cookies being selected.  Every cookie yielded
    # should be good to send to the given URI,
    # i.e. cookie.valid_for_uri?(uri) evaluates to true.
    #
    # If (and only if) the +uri+ option is given, last access time of
    # each cookie is updated to the current time.
    #
    # This is an abstract method that each subclass must override.
    def each(uri = nil, &block) # :yield: cookie
      if uri
        thost = DomainName.new(uri.host)
        baseDomain = thost.domain || thost.hostname
        redis.hvals(baseDomain).each do |json_row|
          row = JSON.parse(json_row)
          if (row['isSecure'] == 1) != (URI::HTTPS === URI(uri))
            next;
          end

          cookie = HTTP::Cookie.new({
            :name        => row['name'],
            :value       => row['value'],
            :domain      => row['host'],
            :path        => row['path'],
            :expires_at  => Time.at(row['expiry']),
            :secure      => row['isSecure'] != 0,
            :httponly    => row['isHttpOnly'] != 0,
          })

          if cookie.valid_for_uri?(uri)
            cookie.accessed_at = Time.now
            yield cookie
          end
        end
      else
      end
    end
    include Enumerable

    # Implements HTTP::CookieJar#empty?().
    def empty?
      each { return false }
      true
    end

    # Implements HTTP::CookieJar#clear().
    #
    # This is an abstract method that each subclass must override.
    def clear
      redis.flushdb
    end

    # Implements HTTP::CookieJar#cleanup().
    #
    # This is an abstract method that each subclass must override.
    def cleanup(session = false)
    end
  end
end
