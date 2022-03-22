# frozen_string_literal: true

require("ibm_cloud_sdk_core")

# Module for the Watson APIs
module IBMWatson
  ApiException = IBMCloudSdkCore::ApiException
  DetailedResponse = IBMCloudSdkCore::DetailedResponse

  require_relative("./ibm_watson/assistant_v1.rb")
  require_relative("./ibm_watson/assistant_v2.rb")
  require_relative("./ibm_watson/text_to_speech_v1.rb")
  require_relative("./ibm_watson/discovery_v1.rb")
  require_relative("./ibm_watson/discovery_v2.rb")
  require_relative("./ibm_watson/natural_language_understanding_v1.rb")
  require_relative("./ibm_watson/speech_to_text_v1.rb")
  require_relative("./ibm_watson/language_translator_v3.rb")
  require_relative("./ibm_watson/websocket/recognize_callback.rb")
  require_relative("./ibm_watson/authenticators.rb")
  require_relative("./ibm_watson/common.rb")
end
