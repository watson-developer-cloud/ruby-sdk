# frozen_string_literal: true

require("json")
# Custom exception class for errors returned from Watson APIs
class WatsonApiException < StandardError
  attr_reader :code, :message, :info, :transaction_id, :global_transaction_id
  # :param Faraday::Response response: The response object from the Watson API
  def initialize(response:)
    body_hash = JSON.parse(response.body)
    @code = body_hash["code"] || body_hash["error_code"]
    @message = body_hash["error"] || body_hash["error_message"]
    @info = body_hash["description"] if body_hash.key?("description")
    @transaction_id = response.headers["X-DP-Watson-Tran-ID"] if response.headers.key?("X-DP-Watson-Tran-ID")
    @global_transaction_id = response.headers["X-Global-Transaction-ID"] if response.headers.key?("X-Global-Transaction-ID")
  end

  def to_s
    msg = "Error: #{@message}, Code: #{@code}"
    msg += ", Information: #{@info}" unless @info.nil?
    msg += ", X-dp-watson-tran-id: #{@transaction_id}" unless @transaction_id.nil?
    msg += ", X-global-transaction-id: #{@global_transaction_id}" unless @global_transaction_id.nil?
    msg
  end
end
