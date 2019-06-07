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

# The IBM&reg; Text to Speech service provides APIs that use IBM's speech-synthesis
# capabilities to synthesize text into natural-sounding speech in a variety of languages,
# dialects, and voices. The service supports at least one male or female voice, sometimes
# both, for each language. The audio is streamed back to the client with minimal delay.
#
# For speech synthesis, the service supports a synchronous HTTP Representational State
# Transfer (REST) interface. It also supports a WebSocket interface that provides both
# plain text and SSML input, including the SSML &lt;mark&gt; element and word timings.
# SSML is an XML-based markup language that provides text annotation for speech-synthesis
# applications.
#
# The service also offers a customization interface. You can use the interface to define
# sounds-like or phonetic translations for words. A sounds-like translation consists of
# one or more words that, when combined, sound like the word. A phonetic translation is
# based on the SSML phoneme format for representing a word. You can specify a phonetic
# translation in standard International Phonetic Alphabet (IPA) representation or in the
# proprietary IBM Symbolic Phonetic Representation (SPR).

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Text to Speech V1 service.
  class TextToSpeechV1 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Text to Speech service.
    #
    # @param args [Hash] The args to initialize with
    # @option args url [String] The base url to use when contacting the service (e.g.
    #   "https://stream.watsonplatform.net/text-to-speech/api").
    #   The base url may differ between IBM Cloud regions.
    # @option args username [String] The username used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of IBM Cloud. When running on
    #   IBM Cloud, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args password [String] The password used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of IBM Cloud. When running on
    #   IBM Cloud, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args iam_apikey [String] An API key that can be used to request IAM tokens. If
    #   this API key is provided, the SDK will manage the token and handle the
    #   refreshing.
    # @option args iam_access_token [String] An IAM access token is fully managed by the application.
    #   Responsibility falls on the application to refresh the token, either before
    #   it expires or reactively upon receiving a 401 from the service as any requests
    #   made with an expired token will fail.
    # @option args iam_url [String] An optional URL for the IAM service API. Defaults to
    #   'https://iam.cloud.ibm.com/identity/token'.
    # @option args iam_client_id [String] An optional client id for the IAM service API.
    # @option args iam_client_secret [String] An optional client secret for the IAM service API.
    # @option args icp4d_access_token [STRING]  A ICP4D(IBM Cloud Pak for Data) access token is
    #   fully managed by the application. Responsibility falls on the application to
    #   refresh the token, either before it expires or reactively upon receiving a 401
    #   from the service as any requests made with an expired token will fail.
    # @option args icp4d_url [STRING] In order to use an SDK-managed token with ICP4D authentication, this
    #   URL must be passed in.
    # @option args authentication_type [STRING] Specifies the authentication pattern to use. Values that it
    #   takes are basic, iam or icp4d.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:url] = "https://stream.watsonplatform.net/text-to-speech/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      defaults[:iam_client_id] = nil
      defaults[:iam_client_secret] = nil
      defaults[:icp4d_access_token] = nil
      defaults[:icp4d_url] = nil
      defaults[:authetication_type] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "text_to_speech"
      super
      args[:display_name] = "Text to Speech"
    end

    #########################
    # Voices
    #########################

    ##
    # @!method list_voices
    # List voices.
    # Lists all voices available for use with the service. The information includes the
    #   name, language, gender, and other details about the voice. To see information
    #   about a specific voice, use the **Get a voice** method.
    #
    #   **See also:** [Listing all available
    #   voices](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-voices#listVoices).
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_voices
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "list_voices")
      headers.merge!(sdk_headers)

      method_url = "/v1/voices"

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_voice(voice:, customization_id: nil)
    # Get a voice.
    # Gets information about the specified voice. The information includes the name,
    #   language, gender, and other details about the voice. Specify a customization ID to
    #   obtain information for that custom voice model of the specified voice. To list
    #   information about all available voices, use the **List voices** method.
    #
    #   **See also:** [Listing a specific
    #   voice](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-voices#listVoice).
    # @param voice [String] The voice for which information is to be returned.
    # @param customization_id [String] The customization ID (GUID) of a custom voice model for which information is to be
    #   returned. You must make the request with service credentials created for the
    #   instance of the service that owns the custom model. Omit the parameter to see
    #   information about the specified voice with no customization.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_voice(voice:, customization_id: nil)
      raise ArgumentError.new("voice must be provided") if voice.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "get_voice")
      headers.merge!(sdk_headers)

      params = {
        "customization_id" => customization_id
      }

      method_url = "/v1/voices/%s" % [ERB::Util.url_encode(voice)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Synthesis
    #########################

    ##
    # @!method synthesize(text:, voice: nil, customization_id: nil, accept: nil)
    # Synthesize audio.
    # Synthesizes text to audio that is spoken in the specified voice. The service bases
    #   its understanding of the language for the input text on the specified voice. Use a
    #   voice that matches the language of the input text.
    #
    #   The method accepts a maximum of 5 KB of input text in the body of the request, and
    #   8 KB for the URL and headers. The 5 KB limit includes any SSML tags that you
    #   specify. The service returns the synthesized audio stream as an array of bytes.
    #
    #   **See also:** [The HTTP
    #   interface](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-usingHTTP#usingHTTP).
    #
    #
    #   ### Audio formats (accept types)
    #
    #    The service can return audio in the following formats (MIME types).
    #   * Where indicated, you can optionally specify the sampling rate (`rate`) of the
    #   audio. You must specify a sampling rate for the `audio/l16` and `audio/mulaw`
    #   formats. A specified sampling rate must lie in the range of 8 kHz to 192 kHz.
    #   * For the `audio/l16` format, you can optionally specify the endianness
    #   (`endianness`) of the audio: `endianness=big-endian` or
    #   `endianness=little-endian`.
    #
    #   Use the `Accept` header or the `accept` parameter to specify the requested format
    #   of the response audio. If you omit an audio format altogether, the service returns
    #   the audio in Ogg format with the Opus codec (`audio/ogg;codecs=opus`). The service
    #   always returns single-channel audio.
    #   * `audio/basic`
    #
    #     The service returns audio with a sampling rate of 8000 Hz.
    #   * `audio/flac`
    #
    #     You can optionally specify the `rate` of the audio. The default sampling rate is
    #   22,050 Hz.
    #   * `audio/l16`
    #
    #     You must specify the `rate` of the audio. You can optionally specify the
    #   `endianness` of the audio. The default endianness is `little-endian`.
    #   * `audio/mp3`
    #
    #     You can optionally specify the `rate` of the audio. The default sampling rate is
    #   22,050 Hz.
    #   * `audio/mpeg`
    #
    #     You can optionally specify the `rate` of the audio. The default sampling rate is
    #   22,050 Hz.
    #   * `audio/mulaw`
    #
    #     You must specify the `rate` of the audio.
    #   * `audio/ogg`
    #
    #     The service returns the audio in the `vorbis` codec. You can optionally specify
    #   the `rate` of the audio. The default sampling rate is 22,050 Hz.
    #   * `audio/ogg;codecs=opus`
    #
    #     You can optionally specify the `rate` of the audio. The default sampling rate is
    #   22,050 Hz.
    #   * `audio/ogg;codecs=vorbis`
    #
    #     You can optionally specify the `rate` of the audio. The default sampling rate is
    #   22,050 Hz.
    #   * `audio/wav`
    #
    #     You can optionally specify the `rate` of the audio. The default sampling rate is
    #   22,050 Hz.
    #   * `audio/webm`
    #
    #     The service returns the audio in the `opus` codec. The service returns audio
    #   with a sampling rate of 48,000 Hz.
    #   * `audio/webm;codecs=opus`
    #
    #     The service returns audio with a sampling rate of 48,000 Hz.
    #   * `audio/webm;codecs=vorbis`
    #
    #     You can optionally specify the `rate` of the audio. The default sampling rate is
    #   22,050 Hz.
    #
    #   For more information about specifying an audio format, including additional
    #   details about some of the formats, see [Audio
    #   formats](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-audioFormats#audioFormats).
    #
    #
    #   ### Warning messages
    #
    #    If a request includes invalid query parameters, the service returns a `Warnings`
    #   response header that provides messages about the invalid parameters. The warning
    #   includes a descriptive message and a list of invalid argument strings. For
    #   example, a message such as `\"Unknown arguments:\"` or `\"Unknown url query
    #   arguments:\"` followed by a list of the form `\"{invalid_arg_1},
    #   {invalid_arg_2}.\"` The request succeeds despite the warnings.
    # @param text [String] The text to synthesize.
    # @param voice [String] The voice to use for synthesis.
    # @param customization_id [String] The customization ID (GUID) of a custom voice model to use for the synthesis. If a
    #   custom voice model is specified, it is guaranteed to work only if it matches the
    #   language of the indicated voice. You must make the request with service
    #   credentials created for the instance of the service that owns the custom model.
    #   Omit the parameter to use the specified voice with no customization.
    # @param accept [String] The requested format (MIME type) of the audio. You can use the `Accept` header or
    #   the `accept` parameter to specify the audio format. For more information about
    #   specifying an audio format, see **Audio formats (accept types)** in the method
    #   description.
    #
    #   Default: `audio/ogg;codecs=opus`.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def synthesize(text:, voice: nil, customization_id: nil, accept: nil)
      raise ArgumentError.new("text must be provided") if text.nil?

      headers = {
        "Accept" => accept
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "synthesize")
      headers.merge!(sdk_headers)

      params = {
        "voice" => voice,
        "customization_id" => customization_id
      }

      data = {
        "text" => text
      }

      method_url = "/v1/synthesize"

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: false
      )
      response
    end
    #########################
    # Pronunciation
    #########################

    ##
    # @!method get_pronunciation(text:, voice: nil, format: nil, customization_id: nil)
    # Get pronunciation.
    # Gets the phonetic pronunciation for the specified word. You can request the
    #   pronunciation for a specific format. You can also request the pronunciation for a
    #   specific voice to see the default translation for the language of that voice or
    #   for a specific custom voice model to see the translation for that voice model.
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:** [Querying a word from a
    #   language](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuWordsQueryLanguage).
    # @param text [String] The word for which the pronunciation is requested.
    # @param voice [String] A voice that specifies the language in which the pronunciation is to be returned.
    #   All voices for the same language (for example, `en-US`) return the same
    #   translation.
    # @param format [String] The phoneme format in which to return the pronunciation. Omit the parameter to
    #   obtain the pronunciation in the default format.
    # @param customization_id [String] The customization ID (GUID) of a custom voice model for which the pronunciation is
    #   to be returned. The language of a specified custom model must match the language
    #   of the specified voice. If the word is not defined in the specified custom model,
    #   the service returns the default translation for the custom model's language. You
    #   must make the request with service credentials created for the instance of the
    #   service that owns the custom model. Omit the parameter to see the translation for
    #   the specified voice with no customization.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_pronunciation(text:, voice: nil, format: nil, customization_id: nil)
      raise ArgumentError.new("text must be provided") if text.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "get_pronunciation")
      headers.merge!(sdk_headers)

      params = {
        "text" => text,
        "voice" => voice,
        "format" => format,
        "customization_id" => customization_id
      }

      method_url = "/v1/pronunciation"

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Custom models
    #########################

    ##
    # @!method create_voice_model(name:, language: nil, description: nil)
    # Create a custom model.
    # Creates a new empty custom voice model. You must specify a name for the new custom
    #   model. You can optionally specify the language and a description for the new
    #   model. The model is owned by the instance of the service whose credentials are
    #   used to create it.
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:** [Creating a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customModels#cuModelsCreate).
    # @param name [String] The name of the new custom voice model.
    # @param language [String] The language of the new custom voice model. Omit the parameter to use the the
    #   default language, `en-US`.
    # @param description [String] A description of the new custom voice model. Specifying a description is
    #   recommended.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_voice_model(name:, language: nil, description: nil)
      raise ArgumentError.new("name must be provided") if name.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "create_voice_model")
      headers.merge!(sdk_headers)

      data = {
        "name" => name,
        "language" => language,
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
    # @!method list_voice_models(language: nil)
    # List custom models.
    # Lists metadata such as the name and description for all custom voice models that
    #   are owned by an instance of the service. Specify a language to list the voice
    #   models for that language only. To see the words in addition to the metadata for a
    #   specific voice model, use the **List a custom model** method. You must use
    #   credentials for the instance of the service that owns a model to list information
    #   about it.
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:** [Querying all custom
    #   models](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customModels#cuModelsQueryAll).
    # @param language [String] The language for which custom voice models that are owned by the requesting
    #   service credentials are to be returned. Omit the parameter to see all custom voice
    #   models that are owned by the requester.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_voice_models(language: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "list_voice_models")
      headers.merge!(sdk_headers)

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
    # @!method update_voice_model(customization_id:, name: nil, description: nil, words: nil)
    # Update a custom model.
    # Updates information for the specified custom voice model. You can update metadata
    #   such as the name and description of the voice model. You can also update the words
    #   in the model and their translations. Adding a new translation for a word that
    #   already exists in a custom model overwrites the word's existing translation. A
    #   custom model can contain no more than 20,000 entries. You must use credentials for
    #   the instance of the service that owns a model to update it.
    #
    #   You can define sounds-like or phonetic translations for words. A sounds-like
    #   translation consists of one or more words that, when combined, sound like the
    #   word. Phonetic translations are based on the SSML phoneme format for representing
    #   a word. You can specify them in standard International Phonetic Alphabet (IPA)
    #   representation
    #
    #     <code>&lt;phoneme alphabet=\"ipa\"
    #   ph=\"t&#601;m&#712;&#593;to\"&gt;&lt;/phoneme&gt;</code>
    #
    #     or in the proprietary IBM Symbolic Phonetic Representation (SPR)
    #
    #     <code>&lt;phoneme alphabet=\"ibm\"
    #   ph=\"1gAstroEntxrYFXs\"&gt;&lt;/phoneme&gt;</code>
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:**
    #   * [Updating a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customModels#cuModelsUpdate)
    #   * [Adding words to a Japanese custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuJapaneseAdd)
    #   * [Understanding
    #   customization](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customIntro#customIntro).
    # @param customization_id [String] The customization ID (GUID) of the custom voice model. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model.
    # @param name [String] A new name for the custom voice model.
    # @param description [String] A new description for the custom voice model.
    # @param words [Array[Word]] An array of `Word` objects that provides the words and their translations that are
    #   to be added or updated for the custom voice model. Pass an empty array to make no
    #   additions or updates.
    # @return [nil]
    def update_voice_model(customization_id:, name: nil, description: nil, words: nil)
      raise ArgumentError.new("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "update_voice_model")
      headers.merge!(sdk_headers)

      data = {
        "name" => name,
        "description" => description,
        "words" => words
      }

      method_url = "/v1/customizations/%s" % [ERB::Util.url_encode(customization_id)]

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
    # @!method get_voice_model(customization_id:)
    # Get a custom model.
    # Gets all information about a specified custom voice model. In addition to metadata
    #   such as the name and description of the voice model, the output includes the words
    #   and their translations as defined in the model. To see just the metadata for a
    #   voice model, use the **List custom models** method.
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:** [Querying a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customModels#cuModelsQuery).
    # @param customization_id [String] The customization ID (GUID) of the custom voice model. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_voice_model(customization_id:)
      raise ArgumentError.new("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "get_voice_model")
      headers.merge!(sdk_headers)

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
    # @!method delete_voice_model(customization_id:)
    # Delete a custom model.
    # Deletes the specified custom voice model. You must use credentials for the
    #   instance of the service that owns a model to delete it.
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:** [Deleting a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customModels#cuModelsDelete).
    # @param customization_id [String] The customization ID (GUID) of the custom voice model. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model.
    # @return [nil]
    def delete_voice_model(customization_id:)
      raise ArgumentError.new("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "delete_voice_model")
      headers.merge!(sdk_headers)

      method_url = "/v1/customizations/%s" % [ERB::Util.url_encode(customization_id)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: false
      )
      nil
    end
    #########################
    # Custom words
    #########################

    ##
    # @!method add_words(customization_id:, words:)
    # Add custom words.
    # Adds one or more words and their translations to the specified custom voice model.
    #   Adding a new translation for a word that already exists in a custom model
    #   overwrites the word's existing translation. A custom model can contain no more
    #   than 20,000 entries. You must use credentials for the instance of the service that
    #   owns a model to add words to it.
    #
    #   You can define sounds-like or phonetic translations for words. A sounds-like
    #   translation consists of one or more words that, when combined, sound like the
    #   word. Phonetic translations are based on the SSML phoneme format for representing
    #   a word. You can specify them in standard International Phonetic Alphabet (IPA)
    #   representation
    #
    #     <code>&lt;phoneme alphabet=\"ipa\"
    #   ph=\"t&#601;m&#712;&#593;to\"&gt;&lt;/phoneme&gt;</code>
    #
    #     or in the proprietary IBM Symbolic Phonetic Representation (SPR)
    #
    #     <code>&lt;phoneme alphabet=\"ibm\"
    #   ph=\"1gAstroEntxrYFXs\"&gt;&lt;/phoneme&gt;</code>
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:**
    #   * [Adding multiple words to a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuWordsAdd)
    #   * [Adding words to a Japanese custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuJapaneseAdd)
    #   * [Understanding
    #   customization](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customIntro#customIntro).
    # @param customization_id [String] The customization ID (GUID) of the custom voice model. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model.
    # @param words [Array[Word]] The **Add custom words** method accepts an array of `Word` objects. Each object
    #   provides a word that is to be added or updated for the custom voice model and the
    #   word's translation.
    #
    #   The **List custom words** method returns an array of `Word` objects. Each object
    #   shows a word and its translation from the custom voice model. The words are listed
    #   in alphabetical order, with uppercase letters listed before lowercase letters. The
    #   array is empty if the custom model contains no words.
    # @return [nil]
    def add_words(customization_id:, words:)
      raise ArgumentError.new("customization_id must be provided") if customization_id.nil?

      raise ArgumentError.new("words must be provided") if words.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "add_words")
      headers.merge!(sdk_headers)

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
    # @!method list_words(customization_id:)
    # List custom words.
    # Lists all of the words and their translations for the specified custom voice
    #   model. The output shows the translations as they are defined in the model. You
    #   must use credentials for the instance of the service that owns a model to list its
    #   words.
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:** [Querying all words from a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuWordsQueryModel).
    # @param customization_id [String] The customization ID (GUID) of the custom voice model. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_words(customization_id:)
      raise ArgumentError.new("customization_id must be provided") if customization_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "list_words")
      headers.merge!(sdk_headers)

      method_url = "/v1/customizations/%s/words" % [ERB::Util.url_encode(customization_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method add_word(customization_id:, word:, translation:, part_of_speech: nil)
    # Add a custom word.
    # Adds a single word and its translation to the specified custom voice model. Adding
    #   a new translation for a word that already exists in a custom model overwrites the
    #   word's existing translation. A custom model can contain no more than 20,000
    #   entries. You must use credentials for the instance of the service that owns a
    #   model to add a word to it.
    #
    #   You can define sounds-like or phonetic translations for words. A sounds-like
    #   translation consists of one or more words that, when combined, sound like the
    #   word. Phonetic translations are based on the SSML phoneme format for representing
    #   a word. You can specify them in standard International Phonetic Alphabet (IPA)
    #   representation
    #
    #     <code>&lt;phoneme alphabet=\"ipa\"
    #   ph=\"t&#601;m&#712;&#593;to\"&gt;&lt;/phoneme&gt;</code>
    #
    #     or in the proprietary IBM Symbolic Phonetic Representation (SPR)
    #
    #     <code>&lt;phoneme alphabet=\"ibm\"
    #   ph=\"1gAstroEntxrYFXs\"&gt;&lt;/phoneme&gt;</code>
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:**
    #   * [Adding a single word to a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuWordAdd)
    #   * [Adding words to a Japanese custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuJapaneseAdd)
    #   * [Understanding
    #   customization](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customIntro#customIntro).
    # @param customization_id [String] The customization ID (GUID) of the custom voice model. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model.
    # @param word [String] The word that is to be added or updated for the custom voice model.
    # @param translation [String] The phonetic or sounds-like translation for the word. A phonetic translation is
    #   based on the SSML format for representing the phonetic string of a word either as
    #   an IPA translation or as an IBM SPR translation. A sounds-like is one or more
    #   words that, when combined, sound like the word.
    # @param part_of_speech [String] **Japanese only.** The part of speech for the word. The service uses the value to
    #   produce the correct intonation for the word. You can create only a single entry,
    #   with or without a single part of speech, for any word; you cannot create multiple
    #   entries with different parts of speech for the same word. For more information,
    #   see [Working with Japanese
    #   entries](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-rules#jaNotes).
    # @return [nil]
    def add_word(customization_id:, word:, translation:, part_of_speech: nil)
      raise ArgumentError.new("customization_id must be provided") if customization_id.nil?

      raise ArgumentError.new("word must be provided") if word.nil?

      raise ArgumentError.new("translation must be provided") if translation.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "add_word")
      headers.merge!(sdk_headers)

      data = {
        "translation" => translation,
        "part_of_speech" => part_of_speech
      }

      method_url = "/v1/customizations/%s/words/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(word)]

      request(
        method: "PUT",
        url: method_url,
        headers: headers,
        json: data,
        accept_json: false
      )
      nil
    end

    ##
    # @!method get_word(customization_id:, word:)
    # Get a custom word.
    # Gets the translation for a single word from the specified custom model. The output
    #   shows the translation as it is defined in the model. You must use credentials for
    #   the instance of the service that owns a model to list its words.
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:** [Querying a single word from a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuWordQueryModel).
    # @param customization_id [String] The customization ID (GUID) of the custom voice model. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model.
    # @param word [String] The word that is to be queried from the custom voice model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_word(customization_id:, word:)
      raise ArgumentError.new("customization_id must be provided") if customization_id.nil?

      raise ArgumentError.new("word must be provided") if word.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "get_word")
      headers.merge!(sdk_headers)

      method_url = "/v1/customizations/%s/words/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(word)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_word(customization_id:, word:)
    # Delete a custom word.
    # Deletes a single word from the specified custom voice model. You must use
    #   credentials for the instance of the service that owns a model to delete its words.
    #
    #
    #   **Note:** This method is currently a beta release.
    #
    #   **See also:** [Deleting a word from a custom
    #   model](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-customWords#cuWordDelete).
    # @param customization_id [String] The customization ID (GUID) of the custom voice model. You must make the request
    #   with service credentials created for the instance of the service that owns the
    #   custom model.
    # @param word [String] The word that is to be deleted from the custom voice model.
    # @return [nil]
    def delete_word(customization_id:, word:)
      raise ArgumentError.new("customization_id must be provided") if customization_id.nil?

      raise ArgumentError.new("word must be provided") if word.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "delete_word")
      headers.merge!(sdk_headers)

      method_url = "/v1/customizations/%s/words/%s" % [ERB::Util.url_encode(customization_id), ERB::Util.url_encode(word)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: false
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
    #   security](https://cloud.ibm.com/docs/services/text-to-speech?topic=text-to-speech-information-security#information-security).
    # @param customer_id [String] The customer ID for which all data is to be deleted.
    # @return [nil]
    def delete_user_data(customer_id:)
      raise ArgumentError.new("customer_id must be provided") if customer_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("text_to_speech", "V1", "delete_user_data")
      headers.merge!(sdk_headers)

      params = {
        "customer_id" => customer_id
      }

      method_url = "/v1/user_data"

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
      )
      nil
    end
  end
end
