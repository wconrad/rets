require_relative "helper"

class TestHttpClient < MiniTest::Test
  def setup
    @fake_http = stub('fake_client')
    @logger = stub('logger')
    @logger.stubs(:debug? => false)
    @login_url = 'login_url'

    @client = Rets::HttpClient.new(@fake_http, {}, @logger, @login_url)
  end

  def test_timeout_errors
    @fake_http.stubs(:set_auth)
    @fake_http.stubs(:get).raises(HTTPClient::ReceiveTimeoutError)

    assert_raises Rets::HttpClient::TimeoutError do
      @client.http_get('some url')
    end

    assert_raises Rets::HttpClient::TimeoutError do
      @client.http_post('some url')
    end
  end
end
