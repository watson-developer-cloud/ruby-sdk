# frozen_string_literal: true

require("json")
# Custom exception class for errors returned from Watson APIs
class WatsonApiException < StandardError
  attr_reader :code, :error, :info, :transaction_id, :global_transaction_id
  # :param Excon::Response response: The response object from the Watson API
  def initialize(code: nil, error: nil, info: nil, transaction_id: nil, global_transaction_id: nil, response: nil)
    if code.nil? || error.nil?
      @code = response.status
      @error = response.reason_phrase
      unless response.body.empty?
        body_hash = JSON.parse(response.body)
        @code = body_hash["code"] || body_hash["error_code"]
        @error = body_hash["error"] || body_hash["error_message"]
        %w[code error_code error error_message].each { |k| body_hash.delete(k) }
        @info = body_hash
      end
      @transaction_id = response.headers["X-DP-Watson-Tran-ID"] if response.headers.key?("X-DP-Watson-Tran-ID")
      @global_transaction_id = response.headers["X-Global-Transaction-ID"] if response.headers.key?("X-Global-Transaction-ID")
    else
      @code = code
      @error = error
      @info = info
      @transaction_id = transaction_id
      @global_transaction_id = global_transaction_id
    end
  end

  def to_s
    msg = "Error: #{@error}, Code: #{@code}"
    msg += ", Information: #{@info}" unless @info.nil?
    msg += ", X-dp-watson-tran-id: #{@transaction_id}" unless @transaction_id.nil?
    msg += ", X-global-transaction-id: #{@global_transaction_id}" unless @global_transaction_id.nil?
    msg
  end
end
