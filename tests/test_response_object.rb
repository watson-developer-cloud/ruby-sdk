class TestResponseObject
  attr_accessor :status, :headers, :body, :is_testing
  
  def initialize(status:, headers:, body:, is_testing:)
    @status = status
    @headers = headers
    @body = body
    @is_testing = is_testing
  end
end
