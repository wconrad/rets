# rets

* http://github.com/estately/rets

## DESCRIPTION:

[![Build Status](https://secure.travis-ci.org/estately/rets.png?branch=master)](http://travis-ci.org/estately/rets)
A pure-ruby library for fetching data from [RETS] servers.

[RETS]: http://www.rets.org

## REQUIREMENTS:

* [httpclient]
* [nokogiri]

[httpclient]: https://github.com/nahi/httpclient
[nokogiri]: http://nokogiri.org

## INSTALLATION:
```
gem install rets

# or add it to your Gemfile if using Bundler then run bundle install
gem 'rets'
```

## EXAMPLE USAGE:

We need work in this area! There are currently a few guideline examples in the `example` folder on connecting, fetching a property's data, and fetching a property's photos.

## Metadata caching

Metadata, which is loaded when a client is first started, can be slow
to fetch.  To avoid the cost of fetching metadata every time the
client is started, metadata can be cached.

To cache metadata, pass the :metadata_cache option to the client when
you start it.  The library comes with a predefined metadata cache that
persists the metadata to a file.  It is created with the path to which
the cached metadata should be written:

    metadata_cache = Rets::Metadata::FileCache.new("/tmp/metadata")

When you create the RETS client, pass it the metadata cache:

    client = Rets::Client.new(
      login_url: @login_url,
      # ... etc
      metadata_cache: metadata_cache
    )

If you want to persist to something other than a file, create your own
metadata cache object and pass it in.  It should have the same interface
as the built-in FileCache:

    class MyMetadataCache

      # Save the metadata.
      def save(metadata)
      end

      # Load the metadata.  Return nil if it could not be loaded.
      def load
      end
      
    end

See the source for Rets::Metadata::FileCache for more.

## LICENSE:

(The MIT License)

Copyright (c) 2011 Estately, Inc. <opensource@estately.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
