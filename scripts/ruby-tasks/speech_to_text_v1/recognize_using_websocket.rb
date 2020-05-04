
    ##
    # @!method recognize_using_websocket(content_type: nil,recognize_callback:,audio: nil,chunk_data: false,model: nil,customization_id: nil,acoustic_customization_id: nil,customization_weight: nil,base_model_version: nil,inactivity_timeout: nil,interim_results: nil,keywords: nil,keywords_threshold: nil,max_alternatives: nil,word_alternatives_threshold: nil,word_confidence: nil,timestamps: nil,profanity_filter: nil,smart_formatting: nil,speaker_labels: nil, end_of_phrase_silence_time: nil, split_transcript_at_phrase_end: nil, speech_detector_sensitivity: nil, background_audio_suppression: nil)
    # Sends audio for speech recognition using web sockets.
    # @param content_type [String] The type of the input: audio/basic, audio/flac, audio/l16, audio/mp3, audio/mpeg, audio/mulaw, audio/ogg, audio/ogg;codecs=opus, audio/ogg;codecs=vorbis, audio/wav, audio/webm, audio/webm;codecs=opus, audio/webm;codecs=vorbis, or multipart/form-data.
    # @param recognize_callback [RecognizeCallback] The instance handling events returned from the service.
    # @param audio [IO] Audio to transcribe in the format specified by the `Content-Type` header.
    # @param chunk_data [Boolean] If true, then the WebSocketClient will expect to receive data in chunks rather than as a single audio file
    # @param model [String] The identifier of the model to be used for the recognition request.
    # @param customization_id [String] The GUID of a custom language model that is to be used with the request. The base model of the specified custom language model must match the model specified with the `model` parameter. You must make the request with service credentials created for the instance of the service that owns the custom model. By default, no custom language model is used.
    # @param acoustic_customization_id [String] The GUID of a custom acoustic model that is to be used with the request. The base model of the specified custom acoustic model must match the model specified with the `model` parameter. You must make the request with service credentials created for the instance of the service that owns the custom model. By default, no custom acoustic model is used.
    # @param language_customization_id [String] The GUID of a custom language model that is to be used with the request. The base model of the specified custom language model must match the model specified with the `model` parameter. You must make the request with service credentials created for the instance of the service that owns the custom model. By default, no custom language model is used.
    # @param base_model_version [String] The version of the specified base `model` that is to be used for speech recognition. Multiple versions of a base model can exist when a model is updated for internal improvements. The parameter is intended primarily for use with custom models that have been upgraded for a new base model. The default value depends on whether the parameter is used with or without a custom model. For more information, see [Base model version](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-input#version).
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
    # @param speaker_labels [Boolean] Indicates whether labels that identify which words were spoken by which participants in a multi-person exchange are to be included in the response. The default is `false`; no speaker labels are returned. Setting `speaker_labels` to `true` forces the `timestamps` parameter to be `true`, regardless of whether you specify `false` for the parameter.   To determine whether a language model supports speaker labels, use the `GET /v1/models` method and check that the attribute `speaker_labels` is set to `true`. You can also refer to [Speaker labels](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-output#speaker_labels).
    # @param grammar_name [String] The name of a grammar that is to be used with the recognition request. If you
    #   specify a grammar, you must also use the `language_customization_id` parameter to
    #   specify the name of the custom language model for which the grammar is defined.
    #   The service recognizes only strings that are recognized by the specified grammar;
    #   it does not recognize other custom words from the model's words resource. See
    #   [Grammars](https://cloud.ibm.com/docs/speech-to-text/output.html).
    # @param redaction [Boolean] If `true`, the service redacts, or masks, numeric data from final transcripts. The
    #   feature redacts any number that has three or more consecutive digits by replacing
    #   each digit with an `X` character. It is intended to redact sensitive numeric data,
    #   such as credit card numbers. By default, the service performs no redaction.
    #
    #   When you enable redaction, the service automatically enables smart formatting,
    #   regardless of whether you explicitly disable that feature. To ensure maximum
    #   security, the service also disables keyword spotting (ignores the `keywords` and
    #   `keywords_threshold` parameters) and returns only a single final transcript
    #   (forces the `max_alternatives` parameter to be `1`).
    #
    #   **Note:** Applies to US English, Japanese, and Korean transcription only.
    #
    #   See [Numeric
    #   redaction](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-output#redaction).
    #
    # @param processing_metrics [Boolean] If `true`, requests processing metrics about the service's transcription of the
    #   input audio. The service returns processing metrics at the interval specified by
    #   the `processing_metrics_interval` parameter. It also returns processing metrics
    #   for transcription events, for example, for final and interim results. By default,
    #   the service returns no processing metrics.
    # @param processing_metrics_interval [Float] Specifies the interval in real wall-clock seconds at which the service is to
    #   return processing metrics. The parameter is ignored unless the
    #   `processing_metrics` parameter is set to `true`.    #   The parameter accepts a minimum value of 0.1 seconds. The level of precision is
    #   not restricted, so you can specify values such as 0.25 and 0.125.
    #
    #   The service does not impose a maximum value. If you want to receive processing
    #   metrics only for transcription events instead of at periodic intervals, set the
    #   value to a large number. If the value is larger than the duration of the audio,
    #   the service returns processing metrics only for transcription events.
    # @param audio_metrics [Boolean] If `true`, requests detailed information about the signal characteristics of the
    #   input audio. The service returns audio metrics with the final transcription
    #   results. By default, the service returns no audio metrics.
    # @return [WebSocketClient] Returns a new WebSocketClient object
    #
    #   See [Audio
    #   metrics](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-metrics#audio_metrics).
    # @param end_of_phrase_silence_time [Float] If `true`, specifies the duration of the pause interval at which the service
    #   splits a transcript into multiple final results. If the service detects pauses or
    #   extended silence before it reaches the end of the audio stream, its response can
    #   include multiple final results. Silence indicates a point at which the speaker
    #   pauses between spoken words or phrases.
    #
    #   Specify a value for the pause interval in the range of 0.0 to 120.0.
    #   * A value greater than 0 specifies the interval that the service is to use for
    #   speech recognition.
    #   * A value of 0 indicates that the service is to use the default interval. It is
    #   equivalent to omitting the parameter.
    #
    #   The default pause interval for most languages is 0.8 seconds; the default for
    #   Chinese is 0.6 seconds.
    #
    #   See [End of phrase silence
    #   time](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-output#silence_time).
    # @param split_transcript_at_phrase_end [Boolean] If `true`, directs the service to split the transcript into multiple final results
    #   based on semantic features of the input, for example, at the conclusion of
    #   meaningful phrases such as sentences. The service bases its understanding of
    #   semantic features on the base language model that you use with a request. Custom
    #   language models and grammars can also influence how and where the service splits a
    #   transcript. By default, the service splits transcripts based solely on the pause
    #   interval.
    #
    #   See [Split transcript at phrase
    #   end](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-output#split_transcript).
    # @param speech_detector_sensitivity [Float] The sensitivity of speech activity detection that the service is to perform. Use
    #   the parameter to suppress word insertions from music, coughing, and other
    #   non-speech events. The service biases the audio it passes for speech recognition
    #   by evaluating the input audio against prior models of speech and non-speech
    #   activity.
    #
    #   Specify a value between 0.0 and 1.0:
    #   * 0.0 suppresses all audio (no speech is transcribed).
    #   * 0.5 (the default) provides a reasonable compromise for the level of sensitivity.
    #   * 1.0 suppresses no audio (speech detection sensitivity is disabled).
    #
    #   The values increase on a monotonic curve. See [Speech Activity
    #   Detection](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-input#detection).
    # @param background_audio_suppression [Float] The level to which the service is to suppress background audio based on its volume
    #   to prevent it from being transcribed as speech. Use the parameter to suppress side
    #   conversations or background noise.
    #
    #   Specify a value in the range of 0.0 to 1.0:
    #   * 0.0 (the default) provides no suppression (background audio suppression is
    #   disabled).
    #   * 0.5 provides a reasonable level of audio suppression for general usage.
    #   * 1.0 suppresses all audio (no audio is transcribed).
    #
    #   The values increase on a monotonic curve. See [Speech Activity
    #   Detection](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-input#detection).
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def recognize_using_websocket(
      content_type: nil,
      recognize_callback:,
      audio: nil,
      chunk_data: false,
      model: nil,
      language_customization_id: nil,
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
      speaker_labels: nil,
      grammar_name: nil,
      redaction: nil,
      processing_metrics: nil,
      processing_metrics_interval: nil,
      audio_metrics: nil,
      end_of_phrase_silence_time: nil,
      split_transcript_at_phrase_end: nil,
      speech_detector_sensitivity: nil,
      background_audio_suppression: nil
    )
      raise ArgumentError("Audio must be provided") if audio.nil? && !chunk_data
      raise ArgumentError("Recognize callback must be provided") if recognize_callback.nil?
      raise TypeError("Callback is not a derived class of RecognizeCallback") unless recognize_callback.is_a?(IBMWatson::RecognizeCallback)

      require_relative("./websocket/speech_to_text_websocket_listener.rb")
      headers = {}
      headers = conn.default_options.headers.to_hash unless conn.default_options.headers.to_hash.empty?
      @authenticator.authenticate(headers)
      service_url = @service_url.gsub("https:", "wss:")
      params = {
        "model" => model,
        "customization_id" => customization_id,
        "language_customization_id" => language_customization_id,
        "acoustic_customization_id" => acoustic_customization_id,
        "customization_weight" => customization_weight,
        "base_model_version" => base_model_version
      }
      params.delete_if { |_, v| v.nil? }
      service_url += "/v1/recognize?" + HTTP::URI.form_encode(params)
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
        "speaker_labels" => speaker_labels,
        "grammar_name" => grammar_name,
        "redaction" => redaction,
        "processing_metrics" => processing_metrics,
        "processing_metrics_interval" => processing_metrics_interval,
        "audio_metrics" => audio_metrics,
        "end_of_phrase_silence_time" => end_of_phrase_silence_time,
        "split_transcript_at_phrase_end" => split_transcript_at_phrase_end,
        "speech_detector_sensitivity" => speech_detector_sensitivity,
        "background_audio_suppression" => background_audio_suppression
      }
      options.delete_if { |_, v| v.nil? }
      WebSocketClient.new(audio: audio, chunk_data: chunk_data, options: options, recognize_callback: recognize_callback, service_url: service_url, headers: headers, disable_ssl_verification: @disable_ssl_verification)
    end
