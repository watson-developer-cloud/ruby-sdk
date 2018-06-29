# frozen_string_literal: true

# Module for the Watson APIs
module WatsonAPIs
  require_relative("./watson_apis/personality_insights_v3.rb")
  require_relative("./watson_apis/tone_analyzer_v3.rb")
  require_relative("./watson_apis/watson_assistant_v1.rb")
  require_relative("./watson_apis/text_to_speech_v1.rb")
  require_relative("./watson_apis/discovery_v1.rb")
  require_relative("./watson_apis/natural_language_understanding_v1.rb")
  require_relative("./watson_apis/speech_to_text_v1.rb")
  require_relative("./watson_apis/visual_recognition_v3.rb")
  require_relative("./watson_apis/natural_language_classifier_v1.rb")
  require_relative("./watson_apis/language_translator_v3.rb")
  require_relative("./watson_apis/websocket/recognize_abstract_callback.rb")
end
