# frozen_string_literal: true

module IBMWatson
  # Abstract class for Recognize Callbacks
  class RecognizeCallback
    def initialize(*); end

    # Called when an interim result is received
    def on_transcription(transcript:); end

    # Called when a WebSocket connection is made
    def on_connected; end

    # Called when there is an error in the WebSocket connection
    def on_error(error:); end

    # Called when there is an inactivity timeout
    def on_inactivity_timeout(error:); end

    # Called when the service is listening for audio
    def on_listening; end

    # Called after the service returns the final result for the transcription
    def on_transcription_complete; end

    # Called when the service returns the final hypothesis
    def on_hypothesis(hypothesis:); end

    # Called when the service returns results. The data is returned unparsed
    def on_data(data:); end
  end
end
