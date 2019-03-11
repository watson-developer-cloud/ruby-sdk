# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the configure_http_client customizations, such as proxies and timeouts
class HTTPConfigTest < Minitest::Test
  def test_proxy_address_port
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    service.configure_http_client(
      proxy: {
        address: "bogus_address.com",
        port: 9999
      }
    )
    proxy = service.conn.default_options.proxy
    assert_equal("bogus_address.com", proxy[:proxy_address])
    assert_equal(9999, proxy[:proxy_port])
  end

  def test_proxy_username_password
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    service.configure_http_client(
      proxy: {
        address: "bogus_address.com",
        port: 9999,
        username: "username",
        password: "password"
      }
    )
    proxy = service.conn.default_options.proxy
    assert_equal("bogus_address.com", proxy[:proxy_address])
    assert_equal(9999, proxy[:proxy_port])
    assert_equal("username", proxy[:proxy_username])
    assert_equal("password", proxy[:proxy_password])
  end

  def test_proxy_headers
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    service.configure_http_client(
      proxy: {
        address: "bogus_address.com",
        port: 9999,
        headers: {
          bogus_header: true
        }
      }
    )
    proxy = service.conn.default_options.proxy
    assert_equal("bogus_address.com", proxy[:proxy_address])
    assert_equal(9999, proxy[:proxy_port])
    assert_equal({ bogus_header: true }, proxy[:proxy_headers])
  end

  def test_proxy_username_password_headers
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    service.configure_http_client(
      proxy: {
        address: "bogus_address.com",
        port: 9999,
        username: "username",
        password: "password",
        headers: {
          bogus_header: true
        }
      }
    )
    proxy = service.conn.default_options.proxy
    assert_equal("bogus_address.com", proxy[:proxy_address])
    assert_equal(9999, proxy[:proxy_port])
    assert_equal("username", proxy[:proxy_username])
    assert_equal("password", proxy[:proxy_password])
    assert_equal({ bogus_header: true }, proxy[:proxy_headers])
  end

  def test_timeout_per_operation
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    service.configure_http_client(
      timeout: {
        per_operation: {
          read: 5,
          write: 7,
          connect: 10
        }
      }
    )
    timeout_class = service.conn.default_options.timeout_class
    assert_equal(HTTP::Timeout::PerOperation, timeout_class)

    expected_timeouts = {
      read_timeout: 5,
      write_timeout: 7,
      connect_timeout: 10
    }
    timeout = service.conn.default_options.timeout_options
    assert_equal(expected_timeouts, timeout)
  end

  def test_timeout_global
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    service.configure_http_client(
      timeout: {
        global: 20
      }
    )
    timeout_class = service.conn.default_options.timeout_class
    assert_equal(HTTP::Timeout::Global, timeout_class)

    expected_timeouts = {
      global_timeout: 20
    }
    timeout = service.conn.default_options.timeout_options
    assert_equal(expected_timeouts, timeout)
  end

  def test_disable_ssl
    service = IBMWatson::NaturalLanguageUnderstandingV1.new(
      version: "2018-03-16",
      username: "username",
      password: "password"
    )
    service.configure_http_client(disable_ssl: true)
    refute_nil(service.conn.default_options.ssl_context)
  end
end
