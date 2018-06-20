# frozen_string_literal: true

require("http")
require("json")
require_relative("./version.rb")

DEFAULT_IAM_URL = "https://iam.bluemix.net/identity/token"
CONTENT_TYPE = "application/x-www-form-urlencoded"
ACCEPT = "application/json"
DEFAULT_AUTHORIZATION = "Basic Yng6Yng="
REQUEST_TOKEN_GRANT_TYPE = "urn:ibm:params:oauth:grant-type:apikey"
REQUEST_TOKEN_RESPONSE_TYPE = "cloud_iam"
REFRESH_TOKEN_GRANT_TYPE = "refresh_token"

# Class to manage IAM Token Authentication
class IAMTokenManager
  attr_accessor :token_info, :user_access_token
  def initialize(iam_api_key: nil, iam_access_token: nil, iam_url: nil)
    @iam_api_key = iam_api_key
    @user_access_token = iam_access_token
    @iam_url = iam_url.nil? ? DEFAULT_IAM_URL : iam_url
    @token_info = {
      "access_token" => nil,
      "refresh_token" => nil,
      "token_type" => nil,
      "expires_in" => nil,
      "expiration" => nil
    }
  end

  def request(method:, url:, headers: nil, params: nil, data: nil)
    user_agent_string = "watson-apis-ruby-sdk-" + WatsonDeveloperCloud::VERSION
    user_agent_string += " " + ENV["_system_name"]
    user_agent_string += " " + ENV["_system_version"]
    user_agent_string += " " + ENV["RUBY_VERSION"]
    headers["User-Agent"] = user_agent_string
    response = nil
    if headers.key?("Content-Type") && headers["Content-Type"] == CONTENT_TYPE
      response = HTTP.request(
        method,
        url,
        body: HTTP::URI.form_encode(data),
        headers: headers,
        params: params
      )
    else
      data = data.to_json if data.respond_to?(:to_json)
      response = HTTP.request(
        method,
        url,
        headers: headers,
        body: data,
        params: params
      )
    end
    return JSON.parse(response.body.to_s) if (200..299).cover?(response.code)
    require_relative("./watson_api_exception.rb")
    raise WatsonApiException.new(response: response)
  end

  # The source of the token is determined by the following logic:
  #   1. If user provides their own managed access token, assume it is valid and send it
  #   2. If this class is managing tokens and does not yet have one, make a request for one
  #   3. If this class is managing tokens and the token has expired refresh it. In case the refresh token is expired, get a new one
  # If this class is managing tokens and has a valid token stored, send it
  def _token
    return @user_access_token unless @user_access_token.nil? || (@user_access_token.respond_to?(:empty?) && @user_access_token.empty?)
    if @token_info.nil?
      token_info = _request_token
      _save_token_info(
        token_info: token_info
      )
      return @token_info["access_token"]
    elsif _is_token_expired?
      token_info = _is_refresh_token_expired? ? _request_token : _refresh_token
      _save_token_info(
        token_info: token_info
      )
      return @token_info["access_token"]
    else
      @token_info["access_token"]
    end
  end

  # Request an IAM token using an API key
  def _request_token
    headers = {
      "Content-Type" => CONTENT_TYPE,
      "Authorization" => DEFAULT_AUTHORIZATION,
      "Accept" => ACCEPT
    }
    data = {
      "grant_type" => REQUEST_TOKEN_GRANT_TYPE,
      "apikey" => @iam_api_key,
      "response_type" => REQUEST_TOKEN_RESPONSE_TYPE
    }
    response = request(
      method: "POST",
      url: @iam_url,
      headers: headers,
      data: data
    )
    response
  end

  # Refresh an IAM token using a refresh token
  def _refresh_token
    headers = {
      "Content-Type" => CONTENT_TYPE,
      "Authorization" => DEFAULT_AUTHORIZATION,
      "accept" => ACCEPT
    }
    data = {
      "grant_type" => REFRESH_TOKEN_GRANT_TYPE,
      "refresh_token" => @token_info["refresh_token"]
    }
    response = request(
      method: "POST",
      url: @iam_url,
      headers: headers,
      data: data
    )
    response
  end

  # Set a self-managed IAM access token.
  # The access token should be valid and not yet expired.
  def _access_token(iam_access_token:)
    @user_access_token = iam_access_token
  end

  # Set the IAM api key
  def _iam_api_key(iam_api_key:)
    @iam_api_key = iam_api_key
  end

  # Check if currently stored token is expired.
  # Using a buffer to prevent the edge case of the
  # token expiring before the request could be made.
  # The buffer will be a fraction of the total TTL. Using 80%.
  def _is_token_expired?
    fraction_of_ttl = 0.8
    time_to_live = @token_info["expires_in"].nil? ? 0 : @token_info["expires_in"]
    expire_time = @token_info["expiration"].nil? ? 0 : @token_info["expiration"]
    refresh_time = expire_time - (time_to_live * (1.0 - fraction_of_ttl))
    current_time = Time.now.to_i
    refresh_time < current_time
  end

  # Used as a fail-safe to prevent the condition of a refresh token expiring,
  # which could happen after around 30 days. This function will return true
  # if it has been at least 7 days and 1 hour since the last token was set
  def _is_refresh_token_expired?
    return true if @token_info["expiration"].nil?
    seven_days = 7 * 24 * 3600
    current_time = Time.now.to_i
    new_token_time = @token_info["expiration"] + seven_days
    new_token_time < current_time
  end

  # Save the response from the IAM service request to the object's state
  def _save_token_info(token_info:)
    @token_info = token_info
  end
end
