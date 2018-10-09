# frozen_string_literal: true

# Copyright 2018 IBM All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The IBM&reg; Speech to Text service provides APIs that use IBM's speech-recognition
# capabilities to produce transcripts of spoken audio. The service can transcribe speech
# from various languages and audio formats. It addition to basic transcription, the
# service can produce detailed information about many different aspects of the audio. For
# most languages, the service supports two sampling rates, broadband and narrowband. It
# returns all JSON response content in the UTF-8 character set.
#
# For speech recognition, the service supports synchronous and asynchronous HTTP
# Representational State Transfer (REST) interfaces. It also supports a WebSocket
# interface that provides a full-duplex, low-latency communication channel: Clients send
# requests and audio to the service and receive results over a single connection in an
# asynchronous fashion.
#
# The service also offers two customization interfaces. Use language model customization
# to expand the vocabulary of a base model with domain-specific terminology. Use acoustic
# model customization to adapt a base model for the acoustic characteristics of your
# audio. Language model customization is generally available for production use with most
# supported languages; acoustic model customization is beta functionality that is
# available for all supported languages.

require "concurrent"
require "erb"
require "json"
require_relative "./detailed_response"

require_relative "./watson_service"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Speech to Text V1 service.
  class SpeechToTextV1 < WatsonService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Speech to Text service.
    #
    # @param args [Hash] The args to initialize with
    # @option args url [String] The base url to use when contacting the service (e.g.
    #   "https://stream.watsonplatform.net/speech-to-text/api").
    #   The base url may differ between Bluemix regions.
    # @option args username [String] The username used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of Bluemix. When running on
    #   Bluemix, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args password [String] The password used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of Bluemix. When running on
    #   Bluemix, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args iam_apikey [String] An API key that can be used to request IAM tokens. If
    #   this API key is provided, the SDK will manage the token and handle the
    #   refreshing.
    # @option args iam_access_token [String] An IAM access token is fully managed by the application.
    #   Responsibility falls on the application to refresh the token, either before
    #   it expires or reactively upon receiving a 401 from the service as any requests
    #   made with an expired token will fail.
    # @option args iam_url [String] An optional URL for the IAM service API. Defaults to
    #   'https://iam.ng.bluemix.net/identity/token'.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:url] = "https://stream.watsonplatform.net/speech-to-text/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "speech_to_text"
      super
    end

    #########################
    # Models
    #########################

    ##
    # @!method list_models
    # List models.
    # Lists all language models that are available for use with the service. The
    #   information includes the name of the model and its minimum sampling rate in Hertz,
    #   among other things.
    #
    #   **See also:** [Languages and
    #   models](https://console.bluemix.net/docs/services/speech-to-text/input.html#models).
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_models
      headers = {
      }
      method_url = "/v1/models"
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_model(model_id:)
    # Get a model.
    # Gets information for a single specified language model that is available for use
    #   with the service. The information includes the name of the model and its minimum
    #   sampling rate in Hertz, among other things.
    #
    #   **See also:** [Languages and
    #   models](https://console.bluemix.net/docs/services/speech-to-text/input.html#models).
    # @param model_id [String] The identifier of the model in the form of its name from the output of the **Get
    #   models** method.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_model(model_id:)
      raise ArgumentError("model_id must be provided") if model_id.nil?

      headers = {
      }
      method_url = "/v1/models/%s" % [ERB::Util.url_encode(model_id)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end
    #########################
    # Synchronous
    #########################

    ##
    # @!method recognize(audio:, content_type:, model: nil, customization_id: nil, acoustic_customization_id: nil, base_model_version: nil, customization_weight: nil, inactivity_timeout: nil, keywords: nil, keywords_threshold: nil, max_alternatives: nil, word_alternatives_threshold: nil, word_confidence: nil, timestamps: nil, profanity_filter: nil, smart_formatting: nil, speaker_labels: nil)
    # Recognize audio.
    # Sends audio and returns transcription results for a recognition request. Returns
    #   only the final results; to enable interim results, use the WebSocket API. The
    #   service imposes a data size limit of 100 MB. It automatically detects the
    #   endianness of the incoming audio and, for audio that includes multiple channels,
    #   downmixes the audio to one-channel mono during transcoding. (For the `audio/l16`
    #   format, you can specify the endianness.)
    #
    #   **See also:** [Making a basic HTTP
    #   request](https://console.bluemix.net/docs/services/speech-to-text/http.html#HTTP-basic).
    #
    #
    #   ### Streaming mode
    #
    #    For requests to transcribe live audio as it becomes available, you must set the
    #   `Transfer-Encoding` header to `chunked` to use streaming mode. In streaming mode,
    #   the server closes the connection (status code 408) if the service receives no data
    #   chunk for 30 seconds and it has no audio to transcribe for 30 seconds. The server
    #   also closes the connection (status code 400) if no speech is detected for
    #   `inactivity_timeout` seconds of audio (not processing time); use the
    #   `inactivity_timeout` parameter to change the default of 30 seconds.
    #
    #   **See also:**
    #   * [Audio
    #   transmission](https://console.bluemix.net/docs/services/speech-to-text/input.html#transmission)
    #   *
    #   [Timeouts](https://console.bluemix.net/docs/services/speech-to-text/input.html#timeouts).
    #
    #
    #   ### Audio formats (content types)
    #
    #    Use the `Content-Type` header to specify the audio format (MIME type) of the
    #   audio. The service accepts the following formats, including specifying the
    #   sampling rate, channels, and endianness where indicated.
    #   * `audio/basic` (Use only with narrowband models.)
    #   * `audio/flac`
    #   * `audio/l16` (Specify the sampling rate (`rate`) and optionally the number of
    #   channels (`channels`) and endianness (`endianness`) of the audio.)
    #   * `audio/mp3`
    #   * `audio/mpeg`
    #   * `audio/mulaw` (Specify the sampling rate (`rate`) of the audio.)
    #   * `audio/ogg` (The service automatically detects the codec of the input audio.)
    #   * `audio/ogg;codecs=opus`
    #   * `audio/ogg;codecs=vorbis`
    #   * `audio/wav` (Provide audio with a maximum of nine channels.)
    #   * `audio/webm` (The service automatically detects the codec of the input audio.)
    #   * `audio/webm;codecs=opus`
    #   * `audio/webm;codecs=vorbis`
    #
    #   **See also:** [Audio
    #   formats](https://console.bluemix.net/docs/services/speech-to-text/audio-formats.html).
    #
    #
    #   ### Multipart speech recognition
    #
    #    The method also supports multipart recognition requests. With multipart requests,
    #   you pass all audio data as multipart form data. You specify some parameters as
    #   request headers and query parameters, but you pass JSON metadata as form data to
    #   control most aspects of the transcription.
    #
    #   The multipart approach is intended for use with browsers for which JavaScript is
    #   disabled or when the parameters used with the request are greater than the 8 KB
    #   limit imposed by most HTTP servers and proxies. You can encounter this limit, for
    #   example, if you want to spot a very large number of keywords.
    #
    #   **See also:** [Making a multipart HTTP
    #   request](https://console.bluemix.net/docs/services/speech-to-text/http.html#HTTP-multi).
    # @param audio [String] The audio to transcribe in the format specified by the `Content-Type` header.
    # @param content_type [String] The type of the input.
    # @param model [String] The identifier of the model that is to be used for the recognition request.
    # @param customization_id [String] The customization ID (GUID) of a custom language model that is to be used with the
    #   recognition request. The base model of the specified custom language model must
    #   match the model specified with the `model` parameter. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model. By default, no custom language model is used. See [Custom
    #   models](https://console.bluemix.net/docs/services/speech-to-text/input.html#custom).
    # @param acoustic_customization_id [String] The customization ID (GUID) of a custom acoustic model that is to be used with the
    #   recognition request. The base model of the specified custom acoustic model must
    #   match the model specified with the `model` parameter. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model. By default, no custom acoustic model is used. See [Custom
    #   models](https://console.bluemix.net/docs/services/speech-to-text/input.html#custom).
    # @param base_model_version [String] The version of the specified base model that is to be used with recognition
    #   request. Multiple versions of a base model can exist when a model is updated for
    #   internal improvements. The parameter is intended primarily for use with custom
    #   models that have been upgraded for a new base model. The default value depends on
    #   whether the parameter is used with or without a custom model. See [Base model
    #   version](https://console.bluemix.net/docs/services/speech-to-text/input.html#version).
    # @param customization_weight [Float] If you specify the customization ID (GUID) of a custom language model with the
    #   recognition request, the customization weight tells the service how much weight to
    #   give to words from the custom language model compared to those from the base model
    #   for the current request.
    #
    #   Specify a value between 0.0 and 1.0. Unless a different customization weight was
    #   specified for the custom model when it was trained, the default value is 0.3. A
    #   customization weight that you specify overrides a weight that was specified when
    #   the custom model was trained.
    #
    #   The default value yields the best performance in general. Assign a higher value if
    #   your audio makes frequent use of OOV words from the custom model. Use caution when
    #   setting the weight: a higher value can improve the accuracy of phrases from the
    #   custom model's domain, but it can negatively affect performance on non-domain
    #   phrases.
    #
    #   See [Custom
    #   models](https://console.bluemix.net/docs/services/speech-to-text/input.html#custom).
    # @param inactivity_timeout [Fixnum] The time in seconds after which, if only silence (no speech) is detected in
    #   submitted audio, the connection is closed with a 400 error. The parameter is
    #   useful for stopping audio submission from a live microphone when a user simply
    #   walks away. Use `-1` for infinity. See
    #   [Timeouts](https://console.bluemix.net/docs/services/speech-to-text/input.html#timeouts).
    # @param keywords [Array[String]] An array of keyword strings to spot in the audio. Each keyword string can include
    #   one or more string tokens. Keywords are spotted only in the final results, not in
    #   interim hypotheses. If you specify any keywords, you must also specify a keywords
    #   threshold. You can spot a maximum of 1000 keywords. Omit the parameter or specify
    #   an empty array if you do not need to spot keywords. See [Keyword
    #   spotting](https://console.bluemix.net/docs/services/speech-to-text/output.html#keyword_spotting).
    # @param keywords_threshold [Float] A confidence value that is the lower bound for spotting a keyword. A word is
    #   considered to match a keyword if its confidence is greater than or equal to the
    #   threshold. Specify a probability between 0.0 and 1.0. No keyword spotting is
    #   performed if you omit the parameter. If you specify a threshold, you must also
    #   specify one or more keywords. See [Keyword
    #   spotting](https://console.bluemix.net/docs/services/speech-to-text/output.html#keyword_spotting).
    # @param max_alternatives [Fixnum] The maximum number of alternative transcripts that the service is to return. By
    #   default, a single transcription is returned. See [Maximum
    #   alternatives](https://console.bluemix.net/docs/services/speech-to-text/output.html#max_alternatives).
    # @param word_alternatives_threshold [Float] A confidence value that is the lower bound for identifying a hypothesis as a
    #   possible word alternative (also known as \"Confusion Networks\"). An alternative
    #   word is considered if its confidence is greater than or equal to the threshold.
    #   Specify a probability between 0.0 and 1.0. No alternative words are computed if
    #   you omit the parameter. See [Word
    #   alternatives](https://console.bluemix.net/docs/services/speech-to-text/output.html#word_alternatives).
    # @param word_confidence [Boolean] If `true`, the service returns a confidence measure in the range of 0.0 to 1.0 for
    #   each word. By default, no word confidence measures are returned. See [Word
    #   confidence](https://console.bluemix.net/docs/services/speech-to-text/output.html#word_confidence).
    # @param timestamps [Boolean] If `true`, the service returns time alignment for each word. By default, no
    #   timestamps are returned. See [Word
    #   timestamps](https://console.bluemix.net/docs/services/speech-to-text/output.html#word_timestamps).
    # @param profanity_filter [Boolean] If `true`, the service filters profanity from all output except for keyword
    #   results by replacing inappropriate words with a series of asterisks. Set the
    #   parameter to `false` to return results with no censoring. Applies to US English
    #   transcription only. See [Profanity
    #   filtering](https://console.bluemix.net/docs/services/speech-to-text/output.html#profanity_filter).
    # @param smart_formatting [Boolean] If `true`, the service converts dates, times, series of digits and numbers, phone
    #   numbers, currency values, and internet addresses into more readable, conventional
    #   representations in the final transcript of a recognition request. For US English,
    #   the service also converts certain keyword strings to punctuation symbols. By
    #   default, no smart formatting is performed. Applies to US English and Spanish
    #   transcription only. See [Smart
    #   formatting](https://console.bluemix.net/docs/services/speech-to-text/output.html#smart_formatting).
    # @param speaker_labels [Boolean] If `true`, the response includes labels that identify which words were spoken by
    #   which participants in a multi-person exchange. By default, no speaker labels are
    #   returned. Setting `speaker_labels` to `true` forces the `timestamps` parameter to
    #   be `true`, regardless of whether you specify `false` for the parameter. To
    #   determine whether a language model supports speaker labels, use the **Get models**
    #   method and check that the attribute `speaker_labels` is set to `true`. See
    #   [Speaker
    #   labels](https://console.bluemix.net/docs/services/speech-to-text/output.html#speaker_labels).
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def recognize(audio:, content_type:, model: nil, customization_id: nil, acoustic_customization_id: nil, base_model_version: nil, customization_weight: nil, inactivity_timeout: nil, keywords: nil, keywords_threshold: nil, max_alternatives: nil, word_alternatives_threshold: nil, word_confidence: nil, timestamps: nil, profanity_filter: nil, smart_formatting: nil, speaker_labels: nil)
      raise ArgumentError("audio must be provided") if audio.nil?

      raise ArgumentError("content_type must be provided") if content_type.nil?

      headers = {
        "Content-Type" => content_type
      }
      params = {
        "model" => model,
        "customization_id" => customization_id,
        "acoustic_customization_id" => acoustic_customization_id,
        "base_model_version" => base_model_version,
        "customization_weight" => customization_weight,
        "inactivity_timeout" => inactivity_timeout,
        "keywords" => keywords.to_a,
        "keywords_threshold" => keywords_threshold,
        "max_alternatives" => max_alternatives,
        "word_alternatives_threshold" => word_alternatives_threshold,
        "word_confidence" => word_confidence,
        "timestamps" => timestamps,
        "profanity_filter" => profanity_filter,
        "smart_formatting" => smart_formatting,
        "speaker_labels" => speaker_labels
      }
      data = audio
      method_url = "/v1/recognize"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        data: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method recognize_using_websocket(content_type:,recognize_callback:,audio: nil,chunk_data: false,model: nil,customization_id: nil,acoustic_customization_id: nil,customization_weight: nil,base_model_version: nil,inactivity_timeout: nil,interim_results: nil,keywords: nil,keywords_threshold: nil,max_alternatives: nil,word_alternatives_threshold: nil,word_confidence: nil,timestamps: nil,profanity_filter: nil,smart_formatting: nil,speaker_labels: nil)
    # Sends audio for speech recognition using web sockets.
    # @param content_type [String] The type of the input: audio/basic, audio/flac, audio/l16, audio/mp3, audio/mpeg, audio/mulaw, audio/ogg, audio/ogg;codecs=opus, audio/ogg;codecs=vorbis, audio/wav, audio/webm, audio/webm;codecs=opus, audio/webm;codecs=vorbis, or multipart/form-data.
    # @param recognize_callback [RecognizeCallback] The instance handling events returned from the service.
    # @param audio [IO] Audio to transcribe in the format specified by the `Content-Type` header.
    # @param chunk_data [Boolean] If true, then the WebSocketClient will expect to receive data in chunks rather than as a single audio file
    # @param model [String] The identifier of the model to be used for the recognition request.
    # @param customization_id [String] The GUID of a custom language model that is to be used with the request. The base model of the specified custom language model must match the model specified with the `model` parameter. You must make the request with service credentials created for the instance of the service that owns the custom model. By default, no custom language model is used.
    # @param acoustic_customization_id [String] The GUID of a custom acoustic model that is to be used with the request. The base model of the specified custom acoustic model must match the model specified with the `model` parameter. You must make the request with service credentials created for the instance of the service that owns the custom model. By default, no custom acoustic model is used.
    # @param customization_weight [Float] If you specify a `customization_id` with the request, you can use the `customization_weight` parameter to tell the service how much weight to give to words from the custom language model compared to those from the base model for speech recognition.   Specify a value between 0.0 and 1.0. Unless a different customization weight was specified for the custom model when it was trained, the default value is 0.3. A customization weight that you specify overrides a weight that was specified when the custom model was trained.   The default value yields the best performance in general. Assign a higher value if your audio makes frequent use of OOV words from the custom model. Use caution when setting the weight: a higher value can improve the accuracy of phrases from the custom model's domain, but it can negatively affect performance on non-domain phrases.
    # @param base_model_version [String] The version of the specified base `model` that is to be used for speech recognition. Multiple versions of a base model can exist when a model is updated for internal improvements. The parameter is intended primarily for use with custom models that have been upgraded for a new base model. The default value depends on whether the parameter is used with or without a custom model. For more information, see [Base model version](https://console.bluemix.net/docs/services/speech-to-text/input.html#version).
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
    def recognize_using_websocket(
      content_type:,
      recognize_callback:,
      audio: nil,
      chunk_data: false,
      model: nil,
      customization_id: nil,
      acoustic_customization_id: nil,
      customization_weight: nil,
      base_model_version: nil,
      inactivity_timeout: nil,
      interim_results: nil,
      keywords: nil,
      keywords_threshold: nil,
      max_alternatives: nil,
      word_alternatives_threshold: nil,
      word_confidence: nil,
      timestamps: nil,
      profanity_filter: nil,
      smart_formatting: nil,
      speaker_labels: nil
    )
      raise ArgumentError("Audio must be provided") if audio.nil? && !chunk_data
      raise ArgumentError("Recognize callback must be provided") if recognize_callback.nil?
      raise TypeError("Callback is not a derived class of RecognizeCallback") unless recognize_callback.is_a?(IBMWatson::RecognizeCallback)

      require_relative("./websocket/speech_to_text_websocket_listener.rb")
      headers = {}
      headers = conn.default_options.headers.to_hash unless conn.default_options.headers.to_hash.empty?
      if !token_manager.nil?
        access_token = token_manager.token
        headers["Authorization"] = "Bearer #{access_token}"
      elsif !username.nil? && !password.nil?
        headers["Authorization"] = "Basic " + Base64.strict_encode64("#{username}:#{password}")
      end
      url = @url.gsub("https:", "wss:")
      params = {
        "model" => model,
        "customization_id" => customization_id,
        "acoustic_customization_id" => acoustic_customization_id,
        "customization_weight" => customization_weight,
        "base_model_version" => base_model_version
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

    # :nocov:
    # @deprecated This will method be removed in the next major release. Use {#recognize_using_websocket} instead.
    def recognize_with_websocket(
      content_type:,
      recognize_callback:,
      audio: nil,
      chunk_data: false,
      model: nil,
      customization_id: nil,
      acoustic_customization_id: nil,
      customization_weight: nil,
      base_model_version: nil,
      inactivity_timeout: nil,
      interim_results: nil,
      keywords: nil,
      keywords_threshold: nil,
      max_alternatives: nil,
      word_alternatives_threshold: nil,
      word_confidence: nil,
      timestamps: nil,
      profanity_filter: nil,
      smart_formatting: nil,
      speaker_labels: nil
    )
      Kernel.warn("[DEPRECATION] `recognize_with_websocket` is deprecated and will be removed in the next major release. Please use `recognize_using_websocket` instead.")
      recognize_using_websocket(
        audio: audio,
        chunk_data: chunk_data,
        content_type: content_type,
        model: model,
        recognize_callback: recognize_callback,
        customization_id: customization_id,
        acoustic_customization_id: acoustic_customization_id,
        customization_weight: customization_weight,
        base_model_version: base_model_version,
        inactivity_timeout: inactivity_timeout,
        interim_results: interim_results,
        keywords: keywords,
        keywords_threshold: keywords_threshold,
        max_alternatives: max_alternatives,
        word_alternatives_threshold: word_alternatives_threshold,
        word_confidence: word_confidence,
        timestamps: timestamps,
        profanity_filter: profanity_filter,
        smart_formatting: smart_formatting,
        speaker_labels: speaker_labels
      )
    end
    # :nocov:
    #########################
    # Asynchronous
    #########################

    ##
    # @!method register_callback(callback_url:, user_secret: nil)
    # Register a callback.
    # Registers a callback URL with the service for use with subsequent asynchronous
    #   recognition requests. The service attempts to register, or white-list, the
    #   callback URL if it is not already registered by sending a `GET` request to the
    #   callback URL. The service passes a random alphanumeric challenge string via the
    #   `challenge_string` parameter of the request. The request includes an `Accept`
    #   header that specifies `text/plain` as the required response type.
    #
    #   To be registered successfully, the callback URL must respond to the `GET` request
    #   from the service. The response must send status code 200 and must include the
    #   challenge string in its body. Set the `Content-Type` response header to
    #   `text/plain`. Upon receiving this response, the service responds to the original
    #   registration request with response code 201.
    #
    #   The service sends only a single `GET` request to the callback URL. If the service
    #   does not receive a reply with a response code of 200 and a body that echoes the
    #   challenge string sent by the service within five seconds, it does not white-list
    #   the URL; it instead sends status code 400 in response to the **Register a
    #   callback** request. If the requested callback URL is already white-listed, the
    #   service responds to the initial registration request with response code 200.
    #
    #   If you specify a user secret with the request, the service uses it as a key to
    #   calculate an HMAC-SHA1 signature of the challenge string in its response to the
    #   `POST` request. It sends this signature in the `X-Callback-Signature` header of
    #   its `GET` request to the URL during registration. It also uses the secret to
    #   calculate a signature over the payload of every callback notification that uses
    #   the URL. The signature provides authentication and data integrity for HTTP
    #   communications.
    #
    #   After you successfully register a callback URL, you can use it with an indefinite
    #   number of recognition requests. You can register a maximum of 20 callback URLS in
    #   a one-hour span of time.
    #
    #   **See also:** [Registering a callback
    #   URL](https://console.bluemix.net/docs/services/speech-to-text/async.html#register).
    # @param callback_url [String] An HTTP or HTTPS URL to which callback notifications are to be sent. To be
    #   white-listed, the URL must successfully echo the challenge string during URL
    #   verification. During verification, the client can also check the signature that
    #   the service sends in the `X-Callback-Signature` header to verify the origin of the
    #   request.
    # @param user_secret [String] A user-specified string that the service uses to generate the HMAC-SHA1 signature
    #   that it sends via the `X-Callback-Signature` header. The service includes the
    #   header during URL verification and with every notification sent to the callback
    #   URL. It calculates the signature over the payload of the notification. If you omit
    #   the parameter, the service does not send the header.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def register_callback(callback_url:, user_secret: nil)
      raise ArgumentError("callback_url must be provided") if callback_url.nil?

      headers = {
      }
      params = {
        "callback_url" => callback_url,
        "user_secret" => user_secret
      }
      method_url = "/v1/register_callback"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method unregister_callback(callback_url:)
    # Unregister a callback.
    # Unregisters a callback URL that was previously white-listed with a **Register a
    #   callback** request for use with the asynchronous interface. Once unregistered, the
    #   URL can no longer be used with asynchronous recognition requests.
    #
    #   **See also:** [Unregistering a callback
    #   URL](https://console.bluemix.net/docs/services/speech-to-text/async.html#unregister).
    # @param callback_url [String] The callback URL that is to be unregistered.
    # @return [nil]
    def unregister_callback(callback_url:)
      raise ArgumentError("callback_url must be provided") if callback_url.nil?

      headers = {
      }
      params = {
        "callback_url" => callback_url
      }
      method_url = "/v1/unregister_callback"
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end

    ##
    # @!method create_job(audio:, content_type:, model: nil, callback_url: nil, events: nil, user_token: nil, results_ttl: nil, customization_id: nil, acoustic_customization_id: nil, base_model_version: nil, customization_weight: nil, inactivity_timeout: nil, keywords: nil, keywords_threshold: nil, max_alternatives: nil, word_alternatives_threshold: nil, word_confidence: nil, timestamps: nil, profanity_filter: nil, smart_formatting: nil, speaker_labels: nil)
    # Create a job.
    # Creates a job for a new asynchronous recognition request. The job is owned by the
    #   user whose service credentials are used to create it. How you learn the status and
    #   results of a job depends on the parameters you include with the job creation
    #   request:
    #   * By callback notification: Include the `callback_url` parameter to specify a URL
    #   to which the service is to send callback notifications when the status of the job
    #   changes. Optionally, you can also include the `events` and `user_token` parameters
    #   to subscribe to specific events and to specify a string that is to be included
    #   with each notification for the job.
    #   * By polling the service: Omit the `callback_url`, `events`, and `user_token`
    #   parameters. You must then use the **Check jobs** or **Check a job** methods to
    #   check the status of the job, using the latter to retrieve the results when the job
    #   is complete.
    #
    #   The two approaches are not mutually exclusive. You can poll the service for job
    #   status or obtain results from the service manually even if you include a callback
    #   URL. In both cases, you can include the `results_ttl` parameter to specify how
    #   long the results are to remain available after the job is complete. Using the
    #   HTTPS **Check a job** method to retrieve results is more secure than receiving
    #   them via callback notification over HTTP because it provides confidentiality in
    #   addition to authentication and data integrity.
    #
    #   The method supports the same basic parameters as other HTTP and WebSocket
    #   recognition requests. It also supports the following parameters specific to the
    #   asynchronous interface:
    #   * `callback_url`
    #   * `events`
    #   * `user_token`
    #   * `results_ttl`
    #
    #   The service imposes a data size limit of 100 MB. It automatically detects the
    #   endianness of the incoming audio and, for audio that includes multiple channels,
    #   downmixes the audio to one-channel mono during transcoding.
    #
    #   **See also:** [Creating a
    #   job](https://console.bluemix.net/docs/services/speech-to-text/async.html#create).
    #
    #   ### Streaming mode
    #
    #    For requests to transcribe live audio as it becomes available, you must set the
    #   `Transfer-Encoding` header to `chunked` to use streaming mode. In streaming mode,
    #   the server closes the connection (status code 408) if the service receives no data
    #   chunk for 30 seconds and it has no audio to transcribe for 30 seconds. The server
    #   also closes the connection (status code 400) if no speech is detected for
    #   `inactivity_timeout` seconds of audio (not processing time); use the
    #   `inactivity_timeout` parameter to change the default of 30 seconds.
    #
    #   **See also:**
    #   * [Audio
    #   transmission](https://console.bluemix.net/docs/services/speech-to-text/input.html#transmission)
    #   *
    #   [Timeouts](https://console.bluemix.net/docs/services/speech-to-text/input.html#timeouts)
    #
    #
    #   ### Audio formats (content types)
    #
    #    Use the `Content-Type` header to specify the audio format (MIME type) of the
    #   audio. The service accepts the following formats, including specifying the
    #   sampling rate, channels, and endianness where indicated.
    #   * `audio/basic` (Use only with narrowband models.)
    #   * `audio/flac`
    #   * `audio/l16` (Specify the sampling rate (`rate`) and optionally the number of
    #   channels (`channels`) and endianness (`endianness`) of the audio.)
    #   * `audio/mp3`
    #   * `audio/mpeg`
    #   * `audio/mulaw` (Specify the sampling rate (`rate`) of the audio.)
    #   * `audio/ogg` (The service automatically detects the codec of the input audio.)
    #   * `audio/ogg;codecs=opus`
    #   * `audio/ogg;codecs=vorbis`
    #   * `audio/wav` (Provide audio with a maximum of nine channels.)
    #   * `audio/webm` (The service automatically detects the codec of the input audio.)
    #   * `audio/webm;codecs=opus`
    #   * `audio/webm;codecs=vorbis`
    #
    #   **See also:** [Audio
    #   formats](https://console.bluemix.net/docs/services/speech-to-text/audio-formats.html).
    # @param audio [String] The audio to transcribe in the format specified by the `Content-Type` header.
    # @param content_type [String] The type of the input.
    # @param model [String] The identifier of the model that is to be used for the recognition request.
    # @param callback_url [String] A URL to which callback notifications are to be sent. The URL must already be
    #   successfully white-listed by using the **Register a callback** method. You can
    #   include the same callback URL with any number of job creation requests. Omit the
    #   parameter to poll the service for job completion and results.
    #
    #   Use the `user_token` parameter to specify a unique user-specified string with each
    #   job to differentiate the callback notifications for the jobs.
    # @param events [String] If the job includes a callback URL, a comma-separated list of notification events
    #   to which to subscribe. Valid events are
    #   * `recognitions.started` generates a callback notification when the service begins
    #   to process the job.
    #   * `recognitions.completed` generates a callback notification when the job is
    #   complete. You must use the **Check a job** method to retrieve the results before
    #   they time out or are deleted.
    #   * `recognitions.completed_with_results` generates a callback notification when the
    #   job is complete. The notification includes the results of the request.
    #   * `recognitions.failed` generates a callback notification if the service
    #   experiences an error while processing the job.
    #
    #   The `recognitions.completed` and `recognitions.completed_with_results` events are
    #   incompatible. You can specify only of the two events.
    #
    #   If the job includes a callback URL, omit the parameter to subscribe to the default
    #   events: `recognitions.started`, `recognitions.completed`, and
    #   `recognitions.failed`. If the job does not include a callback URL, omit the
    #   parameter.
    # @param user_token [String] If the job includes a callback URL, a user-specified string that the service is to
    #   include with each callback notification for the job; the token allows the user to
    #   maintain an internal mapping between jobs and notification events. If the job does
    #   not include a callback URL, omit the parameter.
    # @param results_ttl [Fixnum] The number of minutes for which the results are to be available after the job has
    #   finished. If not delivered via a callback, the results must be retrieved within
    #   this time. Omit the parameter to use a time to live of one week. The parameter is
    #   valid with or without a callback URL.
    # @param customization_id [String] The customization ID (GUID) of a custom language model that is to be used with the
    #   recognition request. The base model of the specified custom language model must
    #   match the model specified with the `model` parameter. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model. By default, no custom language model is used. See [Custom
    #   models](https://console.bluemix.net/docs/services/speech-to-text/input.html#custom).
    # @param acoustic_customization_id [String] The customization ID (GUID) of a custom acoustic model that is to be used with the
    #   recognition request. The base model of the specified custom acoustic model must
    #   match the model specified with the `model` parameter. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model. By default, no custom acoustic model is used. See [Custom
    #   models](https://console.bluemix.net/docs/services/speech-to-text/input.html#custom).
    # @param base_model_version [String] The version of the specified base model that is to be used with recognition
    #   request. Multiple versions of a base model can exist when a model is updated for
    #   internal improvements. The parameter is intended primarily for use with custom
    #   models that have been upgraded for a new base model. The default value depends on
    #   whether the parameter is used with or without a custom model. See [Base model
    #   version](https://console.bluemix.net/docs/services/speech-to-text/input.html#version).
    # @param customization_weight [Float] If you specify the customization ID (GUID) of a custom language model with the
    #   recognition request, the customization weight tells the service how much weight to
    #   give to words from the custom language model compared to those from the base model
    #   for the current request.
    #
    #   Specify a value between 0.0 and 1.0. Unless a different customization weight was
    #   specified for the custom model when it was trained, the default value is 0.3. A
    #   customization weight that you specify overrides a weight that was specified when
    #   the custom model was trained.
    #
    #   The default value yields the best performance in general. Assign a higher value if
    #   your audio makes frequent use of OOV words from the custom model. Use caution when
    #   setting the weight: a higher value can improve the accuracy of phrases from the
    #   custom model's domain, but it can negatively affect performance on non-domain
    #   phrases.
    #
    #   See [Custom
    #   models](https://console.bluemix.net/docs/services/speech-to-text/input.html#custom).
    # @param inactivity_timeout [Fixnum] The time in seconds after which, if only silence (no speech) is detected in
    #   submitted audio, the connection is closed with a 400 error. The parameter is
    #   useful for stopping audio submission from a live microphone when a user simply
    #   walks away. Use `-1` for infinity. See
    #   [Timeouts](https://console.bluemix.net/docs/services/speech-to-text/input.html#timeouts).
    # @param keywords [Array[String]] An array of keyword strings to spot in the audio. Each keyword string can include
    #   one or more string tokens. Keywords are spotted only in the final results, not in
    #   interim hypotheses. If you specify any keywords, you must also specify a keywords
    #   threshold. You can spot a maximum of 1000 keywords. Omit the parameter or specify
    #   an empty array if you do not need to spot keywords. See [Keyword
    #   spotting](https://console.bluemix.net/docs/services/speech-to-text/output.html#keyword_spotting).
    # @param keywords_threshold [Float] A confidence value that is the lower bound for spotting a keyword. A word is
    #   considered to match a keyword if its confidence is greater than or equal to the
    #   threshold. Specify a probability between 0.0 and 1.0. No keyword spotting is
    #   performed if you omit the parameter. If you specify a threshold, you must also
    #   specify one or more keywords. See [Keyword
    #   spotting](https://console.bluemix.net/docs/services/speech-to-text/output.html#keyword_spotting).
    # @param max_alternatives [Fixnum] The maximum number of alternative transcripts that the service is to return. By
    #   default, a single transcription is returned. See [Maximum
    #   alternatives](https://console.bluemix.net/docs/services/speech-to-text/output.html#max_alternatives).
    # @param word_alternatives_threshold [Float] A confidence value that is the lower bound for identifying a hypothesis as a
    #   possible word alternative (also known as \"Confusion Networks\"). An alternative
    #   word is considered if its confidence is greater than or equal to the threshold.
    #   Specify a probability between 0.0 and 1.0. No alternative words are computed if
    #   you omit the parameter. See [Word
    #   alternatives](https://console.bluemix.net/docs/services/speech-to-text/output.html#word_alternatives).
    # @param word_confidence [Boolean] If `true`, the service returns a confidence measure in the range of 0.0 to 1.0 for
    #   each word. By default, no word confidence measures are returned. See [Word
    #   confidence](https://console.bluemix.net/docs/services/speech-to-text/output.html#word_confidence).
    # @param timestamps [Boolean] If `true`, the service returns time alignment for each word. By default, no
    #   timestamps are returned. See [Word
    #   timestamps](https://console.bluemix.net/docs/services/speech-to-text/output.html#word_timestamps).
    # @param profanity_filter [Boolean] If `true`, the service filters profanity from all output except for keyword
    #   results by replacing inappropriate words with a series of asterisks. Set the
    #   parameter to `false` to return results with no censoring. Applies to US English
    #   transcription only. See [Profanity
    #   filtering](https://console.bluemix.net/docs/services/speech-to-text/output.html#profanity_filter).
    # @param smart_formatting [Boolean] If `true`, the service converts dates, times, series of digits and numbers, phone
    #   numbers, currency values, and internet addresses into more readable, conventional
    #   representations in the final transcript of a recognition request. For US English,
    #   the service also converts certain keyword strings to punctuation symbols. By
    #   default, no smart formatting is performed. Applies to US English and Spanish
    #   transcription only. See [Smart
    #   formatting](https://console.bluemix.net/docs/services/speech-to-text/output.html#smart_formatting).
    # @param speaker_labels [Boolean] If `true`, the response includes labels that identify which words were spoken by
    #   which participants in a multi-person exchange. By default, no speaker labels are
    #   returned. Setting `speaker_labels` to `true` forces the `timestamps` parameter to
    #   be `true`, regardless of whether you specify `false` for the parameter. To
    #   determine whether a language model supports speaker labels, use the **Get models**
    #   method and check that the attribute `speaker_labels` is set to `true`. See
    #   [Speaker
    #   labels](https://console.bluemix.net/docs/services/speech-to-text/output.html#speaker_labels).
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_job(audio:, content_type:, model: nil, callback_url: nil, events: nil, user_token: nil, results_ttl: nil, customization_id: nil, acoustic_customization_id: nil, base_model_version: nil, customization_weight: nil, inactivity_timeout: nil, keywords: nil, keywords_threshold: nil, max_alternatives: nil, word_alternatives_threshold: nil, word_confidence: nil, timestamps: nil, profanity_filter: nil, smart_formatting: nil, speaker_labels: nil)
      raise ArgumentError("audio must be provided") if audio.nil?

      raise ArgumentError("content_type must be provided") if content_type.nil?

      headers = {
        "Content-Type" => content_type
      }
      params = {
        "model" => model,
        "callback_url" => callback_url,
        "events" => events,
        "user_token" => user_token,
        "results_ttl" => results_ttl,
        "customization_id" => customization_id,
        "acoustic_customization_id" => acoustic_customization_id,
        "base_model_version" => base_model_version,
        "customization_weight" => customization_weight,
        "inactivity_timeout" => inactivity_timeout,
        "keywords" => keywords.to_a,
        "keywords_threshold" => keywords_threshold,
        "max_alternatives" => max_alternatives,
        "word_alternatives_threshold" => word_alternatives_threshold,
        "word_confidence" => word_confidence,
        "timestamps" => timestamps,
        "profanity_filter" => profanity_filter,
        "smart_formatting" => smart_formatting,
        "speaker_labels" => speaker_labels
      }
      data = audio
      method_url = "/v1/recognitions"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        data: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method check_jobs
    # Check jobs.
    # Returns the ID and status of the latest 100 outstanding jobs associated with the
    #   service credentials with which it is called. The method also returns the creation
    #   and update times of each job, and, if a job was created with a callback URL and a
    #   user token, the user token for the job. To obtain the results for a job whose
    #   status is `completed` or not one of the latest 100 outstanding jobs, use the
    #   **Check a job** method. A job and its results remain available until you delete
    #   them with the **Delete a job** method or until the job's time to live expires,
    #   whichever comes first.
    #
    #   **See also:** [Checking the status of the latest
    #   jobs](https://console.bluemix.net/docs/services/speech-to-text/async.html#jobs).
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def check_jobs
      headers = {
      }
      method_url = "/v1/recognitions"
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method check_job(id:)
    # Check a job.
    # Returns information about the specified job. The response always includes the
    #   status of the job and its creation and update times. If the status is `completed`,
    #   the response includes the results of the recognition request. You must submit the
    #   request with the service credentials of the user who created the job.
    #
    #   You can use the method to retrieve the results of any job, regardless of whether
    #   it was submitted with a callback URL and the `recognitions.completed_with_results`
    #   event, and you can retrieve the results multiple times for as long as they remain
    #   available. Use the **Check jobs** method to request information about the most
    #   recent jobs associated with the caller.
    #
    #   **See also:** [Checking the status and retrieving the results of a
    #   job](https://console.bluemix.net/docs/services/speech-to-text/async.html#job).
    # @param id [String] The ID of the asynchronous job.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def check_job(id:)
      raise ArgumentError("id must be provided") if id.nil?

      headers = {
      }
      method_url = "/v1/recognitions/%s" % [ERB::Util.url_encode(id)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_job(id:)
    # Delete a job.
    # Deletes the specified job. You cannot delete a job that the service is actively
    #   processing. Once you delete a job, its results are no longer available. The
    #   service automatically deletes a job and its results when the time to live for the
    #   results expires. You must submit the request with the service credentials of the
    #   user who created the job.
    #
    #   **See also:** [Deleting a
    #   job](https://console.bluemix.net/docs/services/speech-to-text/async.html#delete).
    # @param id [String] The ID of the asynchronous job.
    # @return [nil]
    def delete_job(id:)
      raise ArgumentError("id must be provided") if id.nil?

      headers = {
      }
      method_url = "/v1/recognitions/%s" % [ERB::Util.url_encode(id)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end
    #########################
    # Custom language models
    #########################

    ##
    # @!method create_language_model(name:, base_model_name:, dialect: nil, description: nil)
    # Create a custom language model.
    # Creates a new custom language model for a specified base model. The custom
    #   language model can be used only with the base model for which it is created. The
    #   model is owned by the instance of the service whose credentials are used to create
    #   it.
    #
    #   **See also:** [Create a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-create.html#createModel).
    # @param name [String] A user-defined name for the new custom language model. Use a name that is unique
    #   among all custom language models that you own. Use a localized name that matches
    #   the language of the custom model. Use a name that describes the domain of the
    #   custom model, such as `Medical custom model` or `Legal custom model`.
    # @param base_model_name [String] The name of the base language model that is to be customized by the new custom
    #   language model. The new custom model can be used only with the base model that it
    #   customizes. To determine whether a base model supports language model
    #   customization, request information about the base model and check that the
    #   attribute `custom_language_model` is set to `true`, or refer to [Language support
    #   for
    #   customization](https://console.bluemix.net/docs/services/speech-to-text/custom.html#languageSupport).
    # @param dialect [String] The dialect of the specified language that is to be used with the custom language
    #   model. The parameter is meaningful only for Spanish models, for which the service
    #   creates a custom language model that is suited for speech in one of the following
    #   dialects:
    #   * `es-ES` for Castilian Spanish (the default)
    #   * `es-LA` for Latin American Spanish
    #   * `es-US` for North American (Mexican) Spanish
    #
    #   A specified dialect must be valid for the base model. By default, the dialect
    #   matches the language of the base model; for example, `en-US` for either of the US
    #   English language models.
    # @param description [String] A description of the new custom language model. Use a localized description that
    #   matches the language of the custom model.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_language_model(name:, base_model_name:, dialect: nil, description: nil)
      raise ArgumentError("name must be provided") if name.nil?

      raise ArgumentError("base_model_name must be provided") if base_model_name.nil?

      headers = {
      }
      data = {
        "name" => name,
        "base_model_name" => base_model_name,
        "dialect" => dialect,
        "description" => description
      }
      method_url = "/v1/customizations"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_language_models(language: nil)
    # List custom language models.
    # Lists information about all custom language models that are owned by an instance
    #   of the service. Use the `language` parameter to see all custom language models for
    #   the specified language. Omit the parameter to see all custom language models for
    #   all languages. You must use credentials for the instance of the service that owns
    #   a model to list information about it.
    #
    #   **See also:** [Listing custom language
    #   models](https://console.bluemix.net/docs/services/speech-to-text/language-models.html#listModels).
    # @param language [String] The identifier of the language for which custom language or custom acoustic models
    #   are to be returned (for example, `en-US`). Omit the parameter to see all custom
    #   language or custom acoustic models owned by the requesting service credentials.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_language_models(language: nil)
      headers = {
      }
      params = {
        "language" => language
      }
      method_url = "/v1/customizations"
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_language_model(customization_id:)
    # Get a custom language model.
    # Gets information about a specified custom language model. You must use credentials
    #   for the instance of the service that owns a model to list information about it.
    #
    #   **See also:** [Listing custom language
    #   models](https://console.bluemix.net/docs/services/speech-to-text/language-models.html#listModels).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_language_model(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s" % [ERB::Util.url_encode(customization_id)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_language_model(customization_id:)
    # Delete a custom language model.
    # Deletes an existing custom language model. The custom model cannot be deleted if
    #   another request, such as adding a corpus to the model, is currently being
    #   processed. You must use credentials for the instance of the service that owns a
    #   model to delete it.
    #
    #   **See also:** [Deleting a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-models.html#deleteModel).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [nil]
    def delete_language_model(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end

    ##
    # @!method train_language_model(customization_id:, word_type_to_add: nil, customization_weight: nil)
    # Train a custom language model.
    # Initiates the training of a custom language model with new corpora, custom words,
    #   or both. After adding, modifying, or deleting corpora or words for a custom
    #   language model, use this method to begin the actual training of the model on the
    #   latest data. You can specify whether the custom language model is to be trained
    #   with all words from its words resource or only with words that were added or
    #   modified by the user. You must use credentials for the instance of the service
    #   that owns a model to train it.
    #
    #   The training method is asynchronous. It can take on the order of minutes to
    #   complete depending on the amount of data on which the service is being trained and
    #   the current load on the service. The method returns an HTTP 200 response code to
    #   indicate that the training process has begun.
    #
    #   You can monitor the status of the training by using the **Get a custom language
    #   model** method to poll the model's status. Use a loop to check the status every 10
    #   seconds. The method returns a `LanguageModel` object that includes `status` and
    #   `progress` fields. A status of `available` means that the custom model is trained
    #   and ready to use. The service cannot accept subsequent training requests, or
    #   requests to add new corpora or words, until the existing request completes.
    #
    #   Training can fail to start for the following reasons:
    #   * The service is currently handling another request for the custom model, such as
    #   another training request or a request to add a corpus or words to the model.
    #   * No training data (corpora or words) have been added to the custom model.
    #   * One or more words that were added to the custom model have invalid sounds-like
    #   pronunciations that you must fix.
    #
    #   **See also:** [Train the custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-create.html#trainModel).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param word_type_to_add [String] The type of words from the custom language model's words resource on which to
    #   train the model:
    #   * `all` (the default) trains the model on all new words, regardless of whether
    #   they were extracted from corpora or were added or modified by the user.
    #   * `user` trains the model only on new words that were added or modified by the
    #   user; the model is not trained on new words extracted from corpora.
    # @param customization_weight [Float] Specifies a customization weight for the custom language model. The customization
    #   weight tells the service how much weight to give to words from the custom language
    #   model compared to those from the base model for speech recognition. Specify a
    #   value between 0.0 and 1.0; the default is 0.3.
    #
    #   The default value yields the best performance in general. Assign a higher value if
    #   your audio makes frequent use of OOV words from the custom model. Use caution when
    #   setting the weight: a higher value can improve the accuracy of phrases from the
    #   custom model's domain, but it can negatively affect performance on non-domain
    #   phrases.
    #
    #   The value that you assign is used for all recognition requests that use the model.
    #   You can override it for any recognition request by specifying a customization
    #   weight for that request.
    # @return [nil]
    def train_language_model(customization_id:, word_type_to_add: nil, customization_weight: nil)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      params = {
        "word_type_to_add" => word_type_to_add,
        "customization_weight" => customization_weight
      }
      method_url = "/v1/customizations/%s/train" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end

    ##
    # @!method reset_language_model(customization_id:)
    # Reset a custom language model.
    # Resets a custom language model by removing all corpora and words from the model.
    #   Resetting a custom language model initializes the model to its state when it was
    #   first created. Metadata such as the name and language of the model are preserved,
    #   but the model's words resource is removed and must be re-created. You must use
    #   credentials for the instance of the service that owns a model to reset it.
    #
    #   **See also:** [Resetting a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-models.html#resetModel).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [nil]
    def reset_language_model(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s/reset" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end

    ##
    # @!method upgrade_language_model(customization_id:)
    # Upgrade a custom language model.
    # Initiates the upgrade of a custom language model to the latest version of its base
    #   language model. The upgrade method is asynchronous. It can take on the order of
    #   minutes to complete depending on the amount of data in the custom model and the
    #   current load on the service. A custom model must be in the `ready` or `available`
    #   state to be upgraded. You must use credentials for the instance of the service
    #   that owns a model to upgrade it.
    #
    #   The method returns an HTTP 200 response code to indicate that the upgrade process
    #   has begun successfully. You can monitor the status of the upgrade by using the
    #   **Get a custom language model** method to poll the model's status. The method
    #   returns a `LanguageModel` object that includes `status` and `progress` fields. Use
    #   a loop to check the status every 10 seconds. While it is being upgraded, the
    #   custom model has the status `upgrading`. When the upgrade is complete, the model
    #   resumes the status that it had prior to upgrade. The service cannot accept
    #   subsequent requests for the model until the upgrade completes.
    #
    #   **See also:** [Upgrading a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/custom-upgrade.html#upgradeLanguage).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [nil]
    def upgrade_language_model(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s/upgrade_model" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end
    #########################
    # Custom corpora
    #########################

    ##
    # @!method list_corpora(customization_id:)
    # List corpora.
    # Lists information about all corpora from a custom language model. The information
    #   includes the total number of words and out-of-vocabulary (OOV) words, name, and
    #   status of each corpus. You must use credentials for the instance of the service
    #   that owns a model to list its corpora.
    #
    #   **See also:** [Listing corpora for a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-corpora.html#listCorpora).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_corpora(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s/corpora" % [ERB::Util.url_encode(customization_id)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method add_corpus(customization_id:, corpus_name:, corpus_file:, allow_overwrite: nil, corpus_filename: nil)
    # Add a corpus.
    # Adds a single corpus text file of new training data to a custom language model.
    #   Use multiple requests to submit multiple corpus text files. You must use
    #   credentials for the instance of the service that owns a model to add a corpus to
    #   it. Adding a corpus does not affect the custom language model until you train the
    #   model for the new data by using the **Train a custom language model** method.
    #
    #   Submit a plain text file that contains sample sentences from the domain of
    #   interest to enable the service to extract words in context. The more sentences you
    #   add that represent the context in which speakers use words from the domain, the
    #   better the service's recognition accuracy.
    #
    #   The call returns an HTTP 201 response code if the corpus is valid. The service
    #   then asynchronously processes the contents of the corpus and automatically
    #   extracts new words that it finds. This can take on the order of a minute or two to
    #   complete depending on the total number of words and the number of new words in the
    #   corpus, as well as the current load on the service. You cannot submit requests to
    #   add additional corpora or words to the custom model, or to train the model, until
    #   the service's analysis of the corpus for the current request completes. Use the
    #   **List a corpus** method to check the status of the analysis.
    #
    #   The service auto-populates the model's words resource with any word that is not
    #   found in its base vocabulary; these are referred to as out-of-vocabulary (OOV)
    #   words. You can use the **List custom words** method to examine the words resource,
    #   using other words method to eliminate typos and modify how words are pronounced as
    #   needed.
    #
    #   To add a corpus file that has the same name as an existing corpus, set the
    #   `allow_overwrite` parameter to `true`; otherwise, the request fails. Overwriting
    #   an existing corpus causes the service to process the corpus text file and extract
    #   OOV words anew. Before doing so, it removes any OOV words associated with the
    #   existing corpus from the model's words resource unless they were also added by
    #   another corpus or they have been modified in some way with the **Add custom
    #   words** or **Add a custom word** method.
    #
    #   The service limits the overall amount of data that you can add to a custom model
    #   to a maximum of 10 million total words from all corpora combined. Also, you can
    #   add no more than 30 thousand custom (OOV) words to a model; this includes words
    #   that the service extracts from corpora and words that you add directly.
    #
    #   **See also:**
    #   * [Working with
    #   corpora](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#workingCorpora)
    #   * [Add corpora to the custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-create.html#addCorpora).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param corpus_name [String] The name of the new corpus for the custom language model. Use a localized name
    #   that matches the language of the custom model and reflects the contents of the
    #   corpus.
    #   * Include a maximum of 128 characters in the name.
    #   * Do not include spaces, slashes, or backslashes in the name.
    #   * Do not use the name of a corpus that has already been added to the custom model.
    #   * Do not use the name `user`, which is reserved by the service to denote custom
    #   words that are added or modified by the user.
    # @param corpus_file [File] A plain text file that contains the training data for the corpus. Encode the file
    #   in UTF-8 if it contains non-ASCII characters; the service assumes UTF-8 encoding
    #   if it encounters non-ASCII characters. With cURL, use the `--data-binary` option
    #   to upload the file for the request.
    # @param allow_overwrite [Boolean] If `true`, the specified corpus or audio resource overwrites an existing corpus or
    #   audio resource with the same name. If `false`, the request fails if a corpus or
    #   audio resource with the same name already exists. The parameter has no effect if a
    #   corpus or audio resource with the same name does not already exist.
    # @param corpus_filename [String] The filename for corpus_file.
    # @return [nil]
    def add_corpus(customization_id:, corpus_name:, corpus_file:, allow_overwrite: nil, corpus_filename: nil)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("corpus_name must be provided") if corpus_name.nil?

      raise ArgumentError("corpus_file must be provided") if corpus_file.nil?

      headers = {
      }
      params = {
        "allow_overwrite" => allow_overwrite
      }
      mime_type = "text/plain"
      unless corpus_file.instance_of?(StringIO) || corpus_file.instance_of?(File)
        corpus_file = corpus_file.respond_to?(:to_json) ? StringIO.new(corpus_file.to_json) : StringIO.new(corpus_file)
      end
      if corpus_filename
        corpus_file = corpus_file.instance_of?(StringIO) ? HTTP::FormData::File.new(corpus_file, content_type: mime_type, filename: corpus_filename) : HTTP::FormData::File.new(corpus_file.path, content_type: mime_type, filename: corpus_filename)
      else
        corpus_file = corpus_file.instance_of?(StringIO) ? HTTP::FormData::File.new(corpus_file, content_type: mime_type) : HTTP::FormData::File.new(corpus_file.path, content_type: mime_type)
      end
      method_url = "/v1/customizations/%s/corpora/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(corpus_name)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: {
          corpus_file: corpus_file
        },
        accept_json: true
      )
      nil
    end

    ##
    # @!method get_corpus(customization_id:, corpus_name:)
    # Get a corpus.
    # Gets information about a corpus from a custom language model. The information
    #   includes the total number of words and out-of-vocabulary (OOV) words, name, and
    #   status of the corpus. You must use credentials for the instance of the service
    #   that owns a model to list its corpora.
    #
    #   **See also:** [Listing corpora for a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-corpora.html#listCorpora).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param corpus_name [String] The name of the corpus for the custom language model.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_corpus(customization_id:, corpus_name:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("corpus_name must be provided") if corpus_name.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s/corpora/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(corpus_name)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_corpus(customization_id:, corpus_name:)
    # Delete a corpus.
    # Deletes an existing corpus from a custom language model. The service removes any
    #   out-of-vocabulary (OOV) words associated with the corpus from the custom model's
    #   words resource unless they were also added by another corpus or they have been
    #   modified in some way with the **Add custom words** or **Add a custom word**
    #   method. Removing a corpus does not affect the custom model until you train the
    #   model with the **Train a custom language model** method. You must use credentials
    #   for the instance of the service that owns a model to delete its corpora.
    #
    #   **See also:** [Deleting a corpus from a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-corpora.html#deleteCorpus).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param corpus_name [String] The name of the corpus for the custom language model.
    # @return [nil]
    def delete_corpus(customization_id:, corpus_name:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("corpus_name must be provided") if corpus_name.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s/corpora/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(corpus_name)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end
    #########################
    # Custom words
    #########################

    ##
    # @!method list_words(customization_id:, word_type: nil, sort: nil)
    # List custom words.
    # Lists information about custom words from a custom language model. You can list
    #   all words from the custom model's words resource, only custom words that were
    #   added or modified by the user, or only out-of-vocabulary (OOV) words that were
    #   extracted from corpora. You can also indicate the order in which the service is to
    #   return words; by default, words are listed in ascending alphabetical order. You
    #   must use credentials for the instance of the service that owns a model to query
    #   information about its words.
    #
    #   **See also:** [Listing words from a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-words.html#listWords).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param word_type [String] The type of words to be listed from the custom language model's words resource:
    #   * `all` (the default) shows all words.
    #   * `user` shows only custom words that were added or modified by the user.
    #   * `corpora` shows only OOV that were extracted from corpora.
    # @param sort [String] Indicates the order in which the words are to be listed, `alphabetical` or by
    #   `count`. You can prepend an optional `+` or `-` to an argument to indicate whether
    #   the results are to be sorted in ascending or descending order. By default, words
    #   are sorted in ascending alphabetical order. For alphabetical ordering, the
    #   lexicographical precedence is numeric values, uppercase letters, and lowercase
    #   letters. For count ordering, values with the same count are ordered
    #   alphabetically. With cURL, URL encode the `+` symbol as `%2B`.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_words(customization_id:, word_type: nil, sort: nil)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      params = {
        "word_type" => word_type,
        "sort" => sort
      }
      method_url = "/v1/customizations/%s/words" % [ERB::Util.url_encode(customization_id)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method add_words(customization_id:, words:)
    # Add custom words.
    # Adds one or more custom words to a custom language model. The service populates
    #   the words resource for a custom model with out-of-vocabulary (OOV) words found in
    #   each corpus added to the model. You can use this method to add additional words or
    #   to modify existing words in the words resource. The words resource for a model can
    #   contain a maximum of 30 thousand custom (OOV) words, including words that the
    #   service extracts from corpora and words that you add directly.
    #
    #   You must use credentials for the instance of the service that owns a model to add
    #   or modify custom words for the model. Adding or modifying custom words does not
    #   affect the custom model until you train the model for the new data by using the
    #   **Train a custom language model** method.
    #
    #   You add custom words by providing a `CustomWords` object, which is an array of
    #   `CustomWord` objects, one per word. You must use the object's `word` parameter to
    #   identify the word that is to be added. You can also provide one or both of the
    #   optional `sounds_like` and `display_as` fields for each word.
    #   * The `sounds_like` field provides an array of one or more pronunciations for the
    #   word. Use the parameter to specify how the word can be pronounced by users. Use
    #   the parameter for words that are difficult to pronounce, foreign words, acronyms,
    #   and so on. For example, you might specify that the word `IEEE` can sound like `i
    #   triple e`. You can specify a maximum of five sounds-like pronunciations for a
    #   word.
    #   * The `display_as` field provides a different way of spelling the word in a
    #   transcript. Use the parameter when you want the word to appear different from its
    #   usual representation or from its spelling in corpora training data. For example,
    #   you might indicate that the word `IBM(trademark)` is to be displayed as
    #   `IBM&trade;`.
    #
    #
    #   If you add a custom word that already exists in the words resource for the custom
    #   model, the new definition overwrites the existing data for the word. If the
    #   service encounters an error with the input data, it returns a failure code and
    #   does not add any of the words to the words resource.
    #
    #   The call returns an HTTP 201 response code if the input data is valid. It then
    #   asynchronously processes the words to add them to the model's words resource. The
    #   time that it takes for the analysis to complete depends on the number of new words
    #   that you add but is generally faster than adding a corpus or training a model.
    #
    #   You can monitor the status of the request by using the **List a custom language
    #   model** method to poll the model's status. Use a loop to check the status every 10
    #   seconds. The method returns a `Customization` object that includes a `status`
    #   field. A status of `ready` means that the words have been added to the custom
    #   model. The service cannot accept requests to add new corpora or words or to train
    #   the model until the existing request completes.
    #
    #   You can use the **List custom words** or **List a custom word** method to review
    #   the words that you add. Words with an invalid `sounds_like` field include an
    #   `error` field that describes the problem. You can use other words-related methods
    #   to correct errors, eliminate typos, and modify how words are pronounced as needed.
    #
    #
    #   **See also:**
    #   * [Working with custom
    #   words](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#workingWords)
    #   * [Add words to the custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-create.html#addWords).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param words [Array[CustomWord]] An array of objects that provides information about each custom word that is to be
    #   added to or updated in the custom language model.
    # @return [nil]
    def add_words(customization_id:, words:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("words must be provided") if words.nil?

      headers = {
      }
      data = {
        "words" => words
      }
      method_url = "/v1/customizations/%s/words" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        json: data,
        accept_json: true
      )
      nil
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
    #   word.
    #   * The `display_as` field provides a different way of spelling the word in a
    #   transcript. Use the parameter when you want the word to appear different from its
    #   usual representation or from its spelling in corpora training data. For example,
    #   you might indicate that the word `IBM(trademark)` is to be displayed as
    #   `IBM&trade;`.
    #
    #
    #   If you add a custom word that already exists in the words resource for the custom
    #   model, the new definition overwrites the existing data for the word. If the
    #   service encounters an error, it does not add the word to the words resource. Use
    #   the **List a custom word** method to review the word that you add.
    #
    #   **See also:**
    #   * [Working with custom
    #   words](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#workingWords)
    #   * [Add words to the custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-create.html#addWords).
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
    #   by users.
    #   * For a word that is not in the service's base vocabulary, omit the parameter to
    #   have the service automatically generate a sounds-like pronunciation for the word.
    #   * For a word that is in the service's base vocabulary, use the parameter to
    #   specify additional pronunciations for the word. You cannot override the default
    #   pronunciation of a word; pronunciations you add augment the pronunciation from the
    #   base vocabulary.
    #
    #   A word can have at most five sounds-like pronunciations. A pronunciation can
    #   include at most 40 characters not including spaces.
    # @param display_as [String] An alternative spelling for the custom word when it appears in a transcript. Use
    #   the parameter when you want the word to have a spelling that is different from its
    #   usual representation or from its spelling in corpora training data.
    # @return [nil]
    def add_word(customization_id:, word_name:, word: nil, sounds_like: nil, display_as: nil)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("word_name must be provided") if word_name.nil?

      headers = {
      }
      data = {
        "word" => word,
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

    ##
    # @!method get_word(customization_id:, word_name:)
    # Get a custom word.
    # Gets information about a custom word from a custom language model. You must use
    #   credentials for the instance of the service that owns a model to query information
    #   about its words.
    #
    #   **See also:** [Listing words from a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-words.html#listWords).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param word_name [String] The custom word for the custom language model. When you add or update a custom
    #   word with the **Add a custom word** method, do not include spaces in the word. Use
    #   a `-` (dash) or `_` (underscore) to connect the tokens of compound words.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_word(customization_id:, word_name:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("word_name must be provided") if word_name.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s/words/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(word_name)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_word(customization_id:, word_name:)
    # Delete a custom word.
    # Deletes a custom word from a custom language model. You can remove any word that
    #   you added to the custom model's words resource via any means. However, if the word
    #   also exists in the service's base vocabulary, the service removes only the custom
    #   pronunciation for the word; the word remains in the base vocabulary. Removing a
    #   custom word does not affect the custom model until you train the model with the
    #   **Train a custom language model** method. You must use credentials for the
    #   instance of the service that owns a model to delete its words.
    #
    #   **See also:** [Deleting a word from a custom language
    #   model](https://console.bluemix.net/docs/services/speech-to-text/language-words.html#deleteWord).
    # @param customization_id [String] The customization ID (GUID) of the custom language model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param word_name [String] The custom word for the custom language model. When you add or update a custom
    #   word with the **Add a custom word** method, do not include spaces in the word. Use
    #   a `-` (dash) or `_` (underscore) to connect the tokens of compound words.
    # @return [nil]
    def delete_word(customization_id:, word_name:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("word_name must be provided") if word_name.nil?

      headers = {
      }
      method_url = "/v1/customizations/%s/words/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(word_name)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end
    #########################
    # Custom acoustic models
    #########################

    ##
    # @!method create_acoustic_model(name:, base_model_name:, description: nil)
    # Create a custom acoustic model.
    # Creates a new custom acoustic model for a specified base model. The custom
    #   acoustic model can be used only with the base model for which it is created. The
    #   model is owned by the instance of the service whose credentials are used to create
    #   it.
    #
    #   **See also:** [Create a custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/acoustic-create.html#createModel).
    # @param name [String] A user-defined name for the new custom acoustic model. Use a name that is unique
    #   among all custom acoustic models that you own. Use a localized name that matches
    #   the language of the custom model. Use a name that describes the acoustic
    #   environment of the custom model, such as `Mobile custom model` or `Noisy car
    #   custom model`.
    # @param base_model_name [String] The name of the base language model that is to be customized by the new custom
    #   acoustic model. The new custom model can be used only with the base model that it
    #   customizes. To determine whether a base model supports acoustic model
    #   customization, refer to [Language support for
    #   customization](https://console.bluemix.net/docs/services/speech-to-text/custom.html#languageSupport).
    # @param description [String] A description of the new custom acoustic model. Use a localized description that
    #   matches the language of the custom model.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_acoustic_model(name:, base_model_name:, description: nil)
      raise ArgumentError("name must be provided") if name.nil?

      raise ArgumentError("base_model_name must be provided") if base_model_name.nil?

      headers = {
      }
      data = {
        "name" => name,
        "base_model_name" => base_model_name,
        "description" => description
      }
      method_url = "/v1/acoustic_customizations"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_acoustic_models(language: nil)
    # List custom acoustic models.
    # Lists information about all custom acoustic models that are owned by an instance
    #   of the service. Use the `language` parameter to see all custom acoustic models for
    #   the specified language. Omit the parameter to see all custom acoustic models for
    #   all languages. You must use credentials for the instance of the service that owns
    #   a model to list information about it.
    #
    #   **See also:** [Listing custom acoustic
    #   models](https://console.bluemix.net/docs/services/speech-to-text/acoustic-models.html#listModels).
    # @param language [String] The identifier of the language for which custom language or custom acoustic models
    #   are to be returned (for example, `en-US`). Omit the parameter to see all custom
    #   language or custom acoustic models owned by the requesting service credentials.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_acoustic_models(language: nil)
      headers = {
      }
      params = {
        "language" => language
      }
      method_url = "/v1/acoustic_customizations"
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_acoustic_model(customization_id:)
    # Get a custom acoustic model.
    # Gets information about a specified custom acoustic model. You must use credentials
    #   for the instance of the service that owns a model to list information about it.
    #
    #   **See also:** [Listing custom acoustic
    #   models](https://console.bluemix.net/docs/services/speech-to-text/acoustic-models.html#listModels).
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_acoustic_model(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/acoustic_customizations/%s" % [ERB::Util.url_encode(customization_id)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_acoustic_model(customization_id:)
    # Delete a custom acoustic model.
    # Deletes an existing custom acoustic model. The custom model cannot be deleted if
    #   another request, such as adding an audio resource to the model, is currently being
    #   processed. You must use credentials for the instance of the service that owns a
    #   model to delete it.
    #
    #   **See also:** [Deleting a custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/acoustic-models.html#deleteModel).
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [nil]
    def delete_acoustic_model(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/acoustic_customizations/%s" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end

    ##
    # @!method train_acoustic_model(customization_id:, custom_language_model_id: nil)
    # Train a custom acoustic model.
    # Initiates the training of a custom acoustic model with new or changed audio
    #   resources. After adding or deleting audio resources for a custom acoustic model,
    #   use this method to begin the actual training of the model on the latest audio
    #   data. The custom acoustic model does not reflect its changed data until you train
    #   it. You must use credentials for the instance of the service that owns a model to
    #   train it.
    #
    #   The training method is asynchronous. It can take on the order of minutes or hours
    #   to complete depending on the total amount of audio data on which the custom
    #   acoustic model is being trained and the current load on the service. Typically,
    #   training a custom acoustic model takes approximately two to four times the length
    #   of its audio data. The range of time depends on the model being trained and the
    #   nature of the audio, such as whether the audio is clean or noisy. The method
    #   returns an HTTP 200 response code to indicate that the training process has begun.
    #
    #
    #   You can monitor the status of the training by using the **Get a custom acoustic
    #   model** method to poll the model's status. Use a loop to check the status once a
    #   minute. The method returns an `AcousticModel` object that includes `status` and
    #   `progress` fields. A status of `available` indicates that the custom model is
    #   trained and ready to use. The service cannot accept subsequent training requests,
    #   or requests to add new audio resources, until the existing request completes.
    #
    #   You can use the optional `custom_language_model_id` parameter to specify the GUID
    #   of a separately created custom language model that is to be used during training.
    #   Specify a custom language model if you have verbatim transcriptions of the audio
    #   files that you have added to the custom model or you have either corpora (text
    #   files) or a list of words that are relevant to the contents of the audio files.
    #   For more information, see the **Create a custom language model** method.
    #
    #   Training can fail to start for the following reasons:
    #   * The service is currently handling another request for the custom model, such as
    #   another training request or a request to add audio resources to the model.
    #   * The custom model contains less than 10 minutes or more than 50 hours of audio
    #   data.
    #   * One or more of the custom model's audio resources is invalid.
    #
    #   **See also:** [Train the custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/acoustic-create.html#trainModel).
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param custom_language_model_id [String] The customization ID (GUID) of a custom language model that is to be used during
    #   training of the custom acoustic model. Specify a custom language model that has
    #   been trained with verbatim transcriptions of the audio resources or that contains
    #   words that are relevant to the contents of the audio resources.
    # @return [nil]
    def train_acoustic_model(customization_id:, custom_language_model_id: nil)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      params = {
        "custom_language_model_id" => custom_language_model_id
      }
      method_url = "/v1/acoustic_customizations/%s/train" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end

    ##
    # @!method reset_acoustic_model(customization_id:)
    # Reset a custom acoustic model.
    # Resets a custom acoustic model by removing all audio resources from the model.
    #   Resetting a custom acoustic model initializes the model to its state when it was
    #   first created. Metadata such as the name and language of the model are preserved,
    #   but the model's audio resources are removed and must be re-created. You must use
    #   credentials for the instance of the service that owns a model to reset it.
    #
    #   **See also:** [Resetting a custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/acoustic-models.html#resetModel).
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [nil]
    def reset_acoustic_model(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/acoustic_customizations/%s/reset" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end

    ##
    # @!method upgrade_acoustic_model(customization_id:, custom_language_model_id: nil)
    # Upgrade a custom acoustic model.
    # Initiates the upgrade of a custom acoustic model to the latest version of its base
    #   language model. The upgrade method is asynchronous. It can take on the order of
    #   minutes or hours to complete depending on the amount of data in the custom model
    #   and the current load on the service; typically, upgrade takes approximately twice
    #   the length of the total audio contained in the custom model. A custom model must
    #   be in the `ready` or `available` state to be upgraded. You must use credentials
    #   for the instance of the service that owns a model to upgrade it.
    #
    #   The method returns an HTTP 200 response code to indicate that the upgrade process
    #   has begun successfully. You can monitor the status of the upgrade by using the
    #   **Get a custom acoustic model** method to poll the model's status. The method
    #   returns an `AcousticModel` object that includes `status` and `progress` fields.
    #   Use a loop to check the status once a minute. While it is being upgraded, the
    #   custom model has the status `upgrading`. When the upgrade is complete, the model
    #   resumes the status that it had prior to upgrade. The service cannot accept
    #   subsequent requests for the model until the upgrade completes.
    #
    #   If the custom acoustic model was trained with a separately created custom language
    #   model, you must use the `custom_language_model_id` parameter to specify the GUID
    #   of that custom language model. The custom language model must be upgraded before
    #   the custom acoustic model can be upgraded. Omit the parameter if the custom
    #   acoustic model was not trained with a custom language model.
    #
    #   **See also:** [Upgrading a custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/custom-upgrade.html#upgradeAcoustic).
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param custom_language_model_id [String] If the custom acoustic model was trained with a custom language model, the
    #   customization ID (GUID) of that custom language model. The custom language model
    #   must be upgraded before the custom acoustic model can be upgraded.
    # @return [nil]
    def upgrade_acoustic_model(customization_id:, custom_language_model_id: nil)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      params = {
        "custom_language_model_id" => custom_language_model_id
      }
      method_url = "/v1/acoustic_customizations/%s/upgrade_model" % [ERB::Util.url_encode(customization_id)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end
    #########################
    # Custom audio resources
    #########################

    ##
    # @!method list_audio(customization_id:)
    # List audio resources.
    # Lists information about all audio resources from a custom acoustic model. The
    #   information includes the name of the resource and information about its audio
    #   data, such as its duration. It also includes the status of the audio resource,
    #   which is important for checking the service's analysis of the resource in response
    #   to a request to add it to the custom acoustic model. You must use credentials for
    #   the instance of the service that owns a model to list its audio resources.
    #
    #   **See also:** [Listing audio resources for a custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/acoustic-audio.html#listAudio).
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_audio(customization_id:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      method_url = "/v1/acoustic_customizations/%s/audio" % [ERB::Util.url_encode(customization_id)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method add_audio(customization_id:, audio_name:, audio_resource:, content_type:, contained_content_type: nil, allow_overwrite: nil)
    # Add an audio resource.
    # Adds an audio resource to a custom acoustic model. Add audio content that reflects
    #   the acoustic characteristics of the audio that you plan to transcribe. You must
    #   use credentials for the instance of the service that owns a model to add an audio
    #   resource to it. Adding audio data does not affect the custom acoustic model until
    #   you train the model for the new data by using the **Train a custom acoustic
    #   model** method.
    #
    #   You can add individual audio files or an archive file that contains multiple audio
    #   files. Adding multiple audio files via a single archive file is significantly more
    #   efficient than adding each file individually. You can add audio resources in any
    #   format that the service supports for speech recognition.
    #
    #   You can use this method to add any number of audio resources to a custom model by
    #   calling the method once for each audio or archive file. But the addition of one
    #   audio resource must be fully complete before you can add another. You must add a
    #   minimum of 10 minutes and a maximum of 50 hours of audio that includes speech, not
    #   just silence, to a custom acoustic model before you can train it. No audio
    #   resource, audio- or archive-type, can be larger than 100 MB. To add an audio
    #   resource that has the same name as an existing audio resource, set the
    #   `allow_overwrite` parameter to `true`; otherwise, the request fails.
    #
    #   The method is asynchronous. It can take several seconds to complete depending on
    #   the duration of the audio and, in the case of an archive file, the total number of
    #   audio files being processed. The service returns a 201 response code if the audio
    #   is valid. It then asynchronously analyzes the contents of the audio file or files
    #   and automatically extracts information about the audio such as its length,
    #   sampling rate, and encoding. You cannot submit requests to add additional audio
    #   resources to a custom acoustic model, or to train the model, until the service's
    #   analysis of all audio files for the current request completes.
    #
    #   To determine the status of the service's analysis of the audio, use the **Get an
    #   audio resource** method to poll the status of the audio. The method accepts the
    #   customization ID of the custom model and the name of the audio resource, and it
    #   returns the status of the resource. Use a loop to check the status of the audio
    #   every few seconds until it becomes `ok`.
    #
    #   **See also:** [Add audio to the custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/acoustic-create.html#addAudio).
    #
    #
    #   ### Content types for audio-type resources
    #
    #    You can add an individual audio file in any format that the service supports for
    #   speech recognition. For an audio-type resource, use the `Content-Type` parameter
    #   to specify the audio format (MIME type) of the audio file, including specifying
    #   the sampling rate, channels, and endianness where indicated.
    #   * `audio/basic` (Use only with narrowband models.)
    #   * `audio/flac`
    #   * `audio/l16` (Specify the sampling rate (`rate`) and optionally the number of
    #   channels (`channels`) and endianness (`endianness`) of the audio.)
    #   * `audio/mp3`
    #   * `audio/mpeg`
    #   * `audio/mulaw` (Specify the sampling rate (`rate`) of the audio.)
    #   * `audio/ogg` (The service automatically detects the codec of the input audio.)
    #   * `audio/ogg;codecs=opus`
    #   * `audio/ogg;codecs=vorbis`
    #   * `audio/wav` (Provide audio with a maximum of nine channels.)
    #   * `audio/webm` (The service automatically detects the codec of the input audio.)
    #   * `audio/webm;codecs=opus`
    #   * `audio/webm;codecs=vorbis`
    #
    #   **See also:** [Audio
    #   formats](https://console.bluemix.net/docs/services/speech-to-text/audio-formats.html).
    #
    #
    #   **Note:** The sampling rate of an audio file must match the sampling rate of the
    #   base model for the custom model: for broadband models, at least 16 kHz; for
    #   narrowband models, at least 8 kHz. If the sampling rate of the audio is higher
    #   than the minimum required rate, the service down-samples the audio to the
    #   appropriate rate. If the sampling rate of the audio is lower than the minimum
    #   required rate, the service labels the audio file as `invalid`.
    #
    #   ### Content types for archive-type resources
    #
    #    You can add an archive file (**.zip** or **.tar.gz** file) that contains audio
    #   files in any format that the service supports for speech recognition. For an
    #   archive-type resource, use the `Content-Type` parameter to specify the media type
    #   of the archive file:
    #   * `application/zip` for a **.zip** file
    #   * `application/gzip` for a **.tar.gz** file.
    #
    #   All audio files contained in the archive must have the same audio format. Use the
    #   `Contained-Content-Type` parameter to specify the format of the contained audio
    #   files. The parameter accepts all of the audio formats supported for use with
    #   speech recognition and with the `Content-Type` header, including the `rate`,
    #   `channels`, and `endianness` parameters that are used with some formats. The
    #   default contained audio format is `audio/wav`.
    #
    #   ### Naming restrictions for embedded audio files
    #
    #    The name of an audio file that is embedded within an archive-type resource must
    #   meet the following restrictions:
    #   * Include a maximum of 128 characters in the file name; this includes the file
    #   extension.
    #   * Do not include spaces, slashes, or backslashes in the file name.
    #   * Do not use the name of an audio file that has already been added to the custom
    #   model as part of an archive-type resource.
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param audio_name [String] The name of the new audio resource for the custom acoustic model. Use a localized
    #   name that matches the language of the custom model and reflects the contents of
    #   the resource.
    #   * Include a maximum of 128 characters in the name.
    #   * Do not include spaces, slashes, or backslashes in the name.
    #   * Do not use the name of an audio resource that has already been added to the
    #   custom model.
    # @param audio_resource [String] The audio resource that is to be added to the custom acoustic model, an individual
    #   audio file or an archive file.
    # @param content_type [String] The type of the input.
    # @param contained_content_type [String] For an archive-type resource, specifies the format of the audio files contained in
    #   the archive file. The parameter accepts all of the audio formats supported for use
    #   with speech recognition, including the `rate`, `channels`, and `endianness`
    #   parameters that are used with some formats. For a complete list of supported audio
    #   formats, see [Audio formats](/docs/services/speech-to-text/input.html#formats).
    # @param allow_overwrite [Boolean] If `true`, the specified corpus or audio resource overwrites an existing corpus or
    #   audio resource with the same name. If `false`, the request fails if a corpus or
    #   audio resource with the same name already exists. The parameter has no effect if a
    #   corpus or audio resource with the same name does not already exist.
    # @return [nil]
    def add_audio(customization_id:, audio_name:, audio_resource:, content_type:, contained_content_type: nil, allow_overwrite: nil)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("audio_name must be provided") if audio_name.nil?

      raise ArgumentError("audio_resource must be provided") if audio_resource.nil?

      raise ArgumentError("content_type must be provided") if content_type.nil?

      headers = {
        "Content-Type" => content_type,
        "Contained-Content-Type" => contained_content_type
      }
      params = {
        "allow_overwrite" => allow_overwrite
      }
      data = audio_resource
      method_url = "/v1/acoustic_customizations/%s/audio/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(audio_name)]
      request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        data: data,
        accept_json: true
      )
      nil
    end

    ##
    # @!method get_audio(customization_id:, audio_name:)
    # Get an audio resource.
    # Gets information about an audio resource from a custom acoustic model. The method
    #   returns an `AudioListing` object whose fields depend on the type of audio resource
    #   that you specify with the method's `audio_name` parameter:
    #   * **For an audio-type resource,** the object's fields match those of an
    #   `AudioResource` object: `duration`, `name`, `details`, and `status`.
    #   * **For an archive-type resource,** the object includes a `container` field whose
    #   fields match those of an `AudioResource` object. It also includes an `audio`
    #   field, which contains an array of `AudioResource` objects that provides
    #   information about the audio files that are contained in the archive.
    #
    #   The information includes the status of the specified audio resource. The status is
    #   important for checking the service's analysis of a resource that you add to the
    #   custom model.
    #   * For an audio-type resource, the `status` field is located in the `AudioListing`
    #   object.
    #   * For an archive-type resource, the `status` field is located in the
    #   `AudioResource` object that is returned in the `container` field.
    #
    #   You must use credentials for the instance of the service that owns a model to list
    #   its audio resources.
    #
    #   **See also:** [Listing audio resources for a custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/acoustic-audio.html#listAudio).
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param audio_name [String] The name of the audio resource for the custom acoustic model.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_audio(customization_id:, audio_name:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("audio_name must be provided") if audio_name.nil?

      headers = {
      }
      method_url = "/v1/acoustic_customizations/%s/audio/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(audio_name)]
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_audio(customization_id:, audio_name:)
    # Delete an audio resource.
    # Deletes an existing audio resource from a custom acoustic model. Deleting an
    #   archive-type audio resource removes the entire archive of files; the current
    #   interface does not allow deletion of individual files from an archive resource.
    #   Removing an audio resource does not affect the custom model until you train the
    #   model on its updated data by using the **Train a custom acoustic model** method.
    #   You must use credentials for the instance of the service that owns a model to
    #   delete its audio resources.
    #
    #   **See also:** [Deleting an audio resource from a custom acoustic
    #   model](https://console.bluemix.net/docs/services/speech-to-text/acoustic-audio.html#deleteAudio).
    # @param customization_id [String] The customization ID (GUID) of the custom acoustic model. You must make the
    #   request with service credentials created for the instance of the service that owns
    #   the custom model.
    # @param audio_name [String] The name of the audio resource for the custom acoustic model.
    # @return [nil]
    def delete_audio(customization_id:, audio_name:)
      raise ArgumentError("customization_id must be provided") if customization_id.nil?

      raise ArgumentError("audio_name must be provided") if audio_name.nil?

      headers = {
      }
      method_url = "/v1/acoustic_customizations/%s/audio/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(audio_name)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end
    #########################
    # User data
    #########################

    ##
    # @!method delete_user_data(customer_id:)
    # Delete labeled data.
    # Deletes all data that is associated with a specified customer ID. The method
    #   deletes all data for the customer ID, regardless of the method by which the
    #   information was added. The method has no effect if no data is associated with the
    #   customer ID. You must issue the request with credentials for the same instance of
    #   the service that was used to associate the customer ID with the data.
    #
    #   You associate a customer ID with data by passing the `X-Watson-Metadata` header
    #   with a request that passes the data.
    #
    #   **See also:** [Information
    #   security](https://console.bluemix.net/docs/services/speech-to-text/information-security.html).
    # @param customer_id [String] The customer ID for which all data is to be deleted.
    # @return [nil]
    def delete_user_data(customer_id:)
      raise ArgumentError("customer_id must be provided") if customer_id.nil?

      headers = {
      }
      params = {
        "customer_id" => customer_id
      }
      method_url = "/v1/user_data"
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end
  end
end
