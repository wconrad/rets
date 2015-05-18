require_relative 'redis_store'

module Rets
  class CookieManager
    def initialize(opts={})
      @jar = HTTP::CookieJar.new({
        store: RedisStore.new(redis: opts[:redis])
      })
    end

    def cookies(uri = nil)
      cookies = @jar.cookies(uri)
      cookies.map { |cookie|
        WebAgent::Cookie.new(
          :name => cookie.name,
          :value => cookie.value,
          :domain => cookie.dot_domain,
          :path => cookie.path,
          :origin => cookie.origin,
          :for_domain => cookie.for_domain,
          :expires => cookie.expires,
          :httponly => cookie.httponly,
          :secure => cookie.secure
        )
      }
    end

    def cookie_value(uri)
      cookies = self.cookies(uri)
      unless cookies.empty?
        HTTP::Cookie.cookie_value(cookies)
      end
    end

    def parse(value, uri)
      @jar.parse(value, uri)
    end

    def cookies=(cookies)
      @jar.clear
      cookies.each do |cookie|
        add(cookie)
      end
    end

    def add(cookie)
      @jar.add(cookie)
    end
  end
end
