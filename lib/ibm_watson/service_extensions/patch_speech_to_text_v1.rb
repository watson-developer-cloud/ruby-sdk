# frozen_string_literal: true

require_relative("./../websocket/recognize_callback.rb")
require_relative("./../watson_service.rb")
require "erb"
require "http"
require "json"

# Module for Speech to Text V1 patches
module SpeechToTextV1Patch
  # @!method recognize_with_websocket(audio: nil,chunk_data: false,content_type: "audio/l16; rate=44100",model: "en-US_BroadbandModel",recognize_callback: nil,customization_id: nil,acoustic_customization_id: nil,customization_weight: nil,version: nil,inactivity_timeout: 30,interim_results: false,keywords: nil,keywords_threshold: nil,max_alternatives: 1,word_alternatives_threshold: nil,word_confidence: false,timestamps: false,profanity_filter: nil,smart_formatting: false,speaker_labels: nil)
  # Sends audio for speech recognition using web sockets.
  # @param audio [IO] Audio to transcribe in the format specified by the `Content-Type` header.
  # @param chunk_data [Boolean] If true, then the WebSocketClient will expect to receive data in chunks rather than as a single audio file
  # @param content_type [String] The type of the input: audio/basic, audio/flac, audio/l16, audio/mp3, audio/mpeg, audio/mulaw, audio/ogg, audio/ogg;codecs=opus, audio/ogg;codecs=vorbis, audio/wav, audio/webm, audio/webm;codecs=opus, audio/webm;codecs=vorbis, or multipart/form-data.
  # @param model [String] The identifier of the model to be used for the recognition request.
  # @param recognize_callback [RecognizeCallback] The instance handling events returned from the service.
  # @param customization_id [String] The GUID of a custom language model that is to be used with the request. The base model of the specified custom language model must match the model specified with the `model` parameter. You must make the request with service credentials created for the instance of the service that owns the custom model. By default, no custom language model is used.
  # @param acoustic_customization_id [String] The GUID of a custom acoustic model that is to be used with the request. The base model of the specified custom acoustic model must match the model specified with the `model` parameter. You must make the request with service credentials created for the instance of the service that owns the custom model. By default, no custom acoustic model is used.
  # @param customization_weight [Float] If you specify a `customization_id` with the request, you can use the `customization_weight` parameter to tell the service how much weight to give to words from the custom language model compared to those from the base model for speech recognition.   Specify a value between 0.0 and 1.0. Unless a different customization weight was specified for the custom model when it was trained, the default value is 0.3. A customization weight that you specify overrides a weight that was specified when the custom model was trained.   The default value yields the best performance in general. Assign a higher value if your audio makes frequent use of OOV words from the custom model. Use caution when setting the weight: a higher value can improve the accuracy of phrases from the custom model's domain, but it can negatively affect performance on non-domain phrases.
  # @param version [String] The version of the specified base `model` that is to be used for speech recognition. Multiple versions of a base model can exist when a model is updated for internal improvements. The parameter is intended primarily for use with custom models that have been upgraded for a new base model. The default value depends on whether the parameter is used with or without a custom model. For more information, see [Base model version](https://console.bluemix.net/docs/services/speech-to-text/input.html#version).
  # @param inactivity_timeout [Integer] The time in seconds after which, if only silence (no speech) is detected in submitted audio, the connection is closed with a 400 error. Useful for stopping audio submission from a live microphone when a user simply walks away. Use `-1` for infinity.
  # @param interim_results [Boolean] Send back non-final previews of each "sentence" as it is being processed. These results are ignored in text mode.
  # @param keywords [Array<String>] Array of keyword strings to spot in the audio. Each keyword string can include one or more tokens. Keywords are spotted only in the final hypothesis, not in interim results. If you specify any keywords, you must also specify a keywords threshold. Omit the parameter or specify an empty array if you do not need to spot keywords.
  # @param keywords_threshold [Float] Confidence value that is the lower bound for spotting a keyword. A word is considered to match a keyword if its confidence is greater than or equal to the threshold. Specify a probability between 0 and 1 inclusive. No keyword spotting is performed if you omit the parameter. If you specify a threshold, you must also specify one or more keywords.
  # @param max_alternatives [Integer] Maximum number of alternative transcripts to be returned. By default, a single transcription is returned.
  # @param word_alternatives_threshold [Float] Confidence value that is the lower bound for identifying a hypothesis as a possible word alternative (also known as \"Confusion Networks\"). An alternative word is considered if its confidence is greater than or equal to the threshold. Specify a probability between 0 and 1 inclusive. No alternative words are computed if you omit the parameter.
  # @param word_confidence [Boolean] If `true`, confidence measure per word is returned.
  # @param timestamps [Boolean] If `true`, time alignment for each word is returned.
  # @param profanity_filter [Boolean] If `true` (the default), filters profanity from all output except for keyword results by replacing inappropriate words with a series of asterisks. Set the parameter to `false` to return results with no censoring. Applies to US English transcription only.
  # @param smart_formatting [Boolean] If `true`, converts dates, times, series of digits and numbers, phone numbers, currency values, and Internet addresses into more readable, conventional representations in the final transcript of a recognition request. If `false` (the default), no formatting is performed. Applies to US English transcription only.
  # @param speaker_labels [Boolean] Indicates whether labels that identify which words were spoken by which participants in a multi-person exchange are to be included in the response. The default is `false`; no speaker labels are returned. Setting `speaker_labels` to `true` forces the `timestamps` parameter to be `true`, regardless of whether you specify `false` for the parameter.   To determine whether a language model supports speaker labels, use the `GET /v1/models` method and check that the attribute `speaker_labels` is set to `true`. You can also refer to [Speaker labels](https://console.bluemix.net/docs/services/speech-to-text/output.html#speaker_labels).
  # @return [WebSocketClient] Returns a new WebSocketClient object
  def recognize_with_websocket(
    audio: nil,
    chunk_data: false,
    content_type: "audio/l16; rate=44100",
    model: "en-US_BroadbandModel",
    recognize_callback: nil,
    customization_id: nil,
    acoustic_customization_id: nil,
    customization_weight: nil,
    version: nil,
    inactivity_timeout: 30,
    interim_results: false,
    keywords: nil,
    keywords_threshold: nil,
    max_alternatives: 1,
    word_alternatives_threshold: nil,
    word_confidence: false,
    timestamps: false,
    profanity_filter: nil,
    smart_formatting: false,
    speaker_labels: nil
  )
    raise ArgumentError("Audio must be provided") if audio.nil? && !chunk_data
    raise ArgumentError("Recognize callback must be provided") if recognize_callback.nil?
    raise TypeError("Callback is not a derived class of RecognizeCallback") unless recognize_callback.is_a?(IBMWatson::RecognizeCallback)
    require_relative("./../websocket/speech_to_text_websocket_listener.rb")
    headers = {}
    headers = @watson_service.conn.default_options.headers.to_hash unless @watson_service.conn.default_options.headers.to_hash.empty?
    if !@watson_service.token_manager.nil?
      access_token = @watson_service.token_manager._token
      headers["Authorization"] = "Bearer #{access_token}"
    elsif !@watson_service.username.nil? && !@watson_service.password.nil?
      headers["Authorization"] = "Basic " + Base64.strict_encode64("#{@watson_service.username}:#{@watson_service.password}")
    end
    url = @watson_service.url.gsub("https:", "wss:")
    params = {
      "model" => model,
      "customization_id" => customization_id,
      "acoustic_customization_id" => acoustic_customization_id,
      "customization_weight" => customization_weight,
      "version" => version
    }
    params.delete_if { |_, v| v.nil? }
    url += "/v1/recognize?" + HTTP::URI.form_encode(params)
    options = {
      "content_type" => content_type,
      "inactivity_timeout" => inactivity_timeout,
      "interim_results" => interim_results,
      "keywords" => keywords,
      "keywords_threshold" => keywords_threshold,
      "max_alternatives" => max_alternatives,
      "word_alternatives_threshold" => word_alternatives_threshold,
      "word_confidence" => word_confidence,
      "timestamps" => timestamps,
      "profanity_filter" => profanity_filter,
      "smart_formatting" => smart_formatting,
      "speaker_labels" => speaker_labels
    }
    options.delete_if { |_, v| v.nil? }
    WebSocketClient.new(audio: audio, chunk_data: chunk_data, options: options, recognize_callback: recognize_callback, url: url, headers: headers)
  end

  ##
  # @!method add_word(customization_id:, word_name:, word: nil, sounds_like: nil, display_as: nil)
  # Add a custom word.
  # Adds a custom word to a custom language model. The service populates the words
  #   resource for a custom model with out-of-vocabulary (OOV) words found in each
  #   corpus added to the model. You can use this method to add a word or to modify an
  #   existing word in the words resource. The words resource for a model can contain a
  #   maximum of 30 thousand custom (OOV) words, including words that the service
  #   extracts from corpora and words that you add directly.
  #
  #   You must use credentials for the instance of the service that owns a model to add
  #   or modify a custom word for the model. Adding or modifying a custom word does not
  #   affect the custom model until you train the model for the new data by using the
  #   **Train a custom language model** method.
  #
  #   Use the `word_name` parameter to specify the custom word that is to be added or
  #   modified. Use the `CustomWord` object to provide one or both of the optional
  #   `sounds_like` and `display_as` fields for the word.
  #   * The `sounds_like` field provides an array of one or more pronunciations for the
  #   word. Use the parameter to specify how the word can be pronounced by users. Use
  #   the parameter for words that are difficult to pronounce, foreign words, acronyms,
  #   and so on. For example, you might specify that the word `IEEE` can sound like `i
  #   triple e`. You can specify a maximum of five sounds-like pronunciations for a
  #   word. For information about pronunciation rules, see [Using the sounds_like
  #   field](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#soundsLike).
  #   * The `display_as` field provides a different way of spelling the word in a
  #   transcript. Use the parameter when you want the word to appear different from its
  #   usual representation or from its spelling in corpora training data. For example,
  #   you might indicate that the word `IBM(trademark)` is to be displayed as
  #   `IBM&trade;`. For more information, see [Using the display_as
  #   field](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#displayAs).
  #
  #
  #   If you add a custom word that already exists in the words resource for the custom
  #   model, the new definition overwrites the existing data for the word. If the
  #   service encounters an error, it does not add the word to the words resource. Use
  #   the **List a custom word** method to review the word that you add.
  # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
  #   request with service credentials created for the instance of the service that owns
  #   the custom model.
  # @param word_name [String] The custom word for the custom language model. When you add or update a custom
  #   word with the **Add a custom word** method, do not include spaces in the word. Use
  #   a `-` (dash) or `_` (underscore) to connect the tokens of compound words.
  # @param word [String] For the **Add custom words** method, you must specify the custom word that is to
  #   be added to or updated in the custom model. Do not include spaces in the word. Use
  #   a `-` (dash) or `_` (underscore) to connect the tokens of compound words.
  #
  #   Omit this field for the **Add a custom word** method.
  # @param sounds_like [Array[String]] An array of sounds-like pronunciations for the custom word. Specify how words that
  #   are difficult to pronounce, foreign words, acronyms, and so on can be pronounced
  #   by users. For a word that is not in the service's base vocabulary, omit the
  #   parameter to have the service automatically generate a sounds-like pronunciation
  #   for the word. For a word that is in the service's base vocabulary, use the
  #   parameter to specify additional pronunciations for the word. You cannot override
  #   the default pronunciation of a word; pronunciations you add augment the
  #   pronunciation from the base vocabulary. A word can have at most five sounds-like
  #   pronunciations, and a pronunciation can include at most 40 characters not
  #   including spaces.
  # @param display_as [String] An alternative spelling for the custom word when it appears in a transcript. Use
  #   the parameter when you want the word to have a spelling that is different from its
  #   usual representation or from its spelling in corpora training data.
  # @return [nil]
  def add_word(customization_id:, word_name:, sounds_like: nil, display_as: nil)
    raise ArgumentError("customization_id must be provided") if customization_id.nil?
    raise ArgumentError("word_name must be provided") if word_name.nil?
    headers = {
    }
    data = {
      "word" => word_name,
      "sounds_like" => sounds_like,
      "display_as" => display_as
    }
    method_url = "/v1/customizations/%s/words/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(word_name)]
    request(
      method: "PUT",
      url: method_url,
      headers: headers,
      json: data,
      accept_json: true
    )
    nil
  end
end
