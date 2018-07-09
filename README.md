# IBM Watson Ruby SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/ruby-sdk.svg)](https://travis-ci.org/watson-developer-cloud/ruby-sdk)
[![Slack](https://wdc-slack-inviter.mybluemix.net/badge.svg)](https://wdc-slack-inviter.mybluemix.net)
[![codecov.io](https://codecov.io/github/watson-developer-cloud/ruby-sdk/coverage.svg)](https://codecov.io/github/watson-developer-cloud/ruby-sdk)
[![Gem Version](https://badge.fury.io/rb/ibm_watson.svg)](https://badge.fury.io/rb/ibm_watson)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

Ruby gem to quickly get started with the various [IBM Watson][wdc] services.

<details>
  <summary>Table of Contents</summary>

  * [Before you begin](#before-you-begin)
  * [Installation](#installation)
  * [Examples](#examples)
  * [Running in IBM Cloud](#running-in-ibm-cloud)
  * [Authentication](#authentication)
    * [Getting credentials](#getting-credentials)
    * [IAM](#iam)
    * [Username and password](#username-and-password)
  * [Sending requests asynchronously](#sending-requests-asynchronously)
  * [Sending request headers](#sending-request-headers)
  * [Parsing HTTP response info](#parsing-http-response-info)
  * [Using Websockets](#using-websockets)
  * [Ruby version](#ruby-version)
  * [Contributing](#contributing)
  * [License](#license)

</details>

## Before you begin
* You need an [IBM Cloud][ibm-cloud-onboarding] account.

## Installation

Install the gem:

```bash
gem install ibm_watson
```

Install with development dependencies:

```bash
gem install --dev ibm_watson
```

Inside of your Ruby program do:

```ruby
require "ibm_watson"
```

## Examples

The [examples][examples] folder has basic and advanced examples. The examples within each service assume that you already have [service credentials](#getting-credentials).

## Running in IBM Cloud

If you run your app in IBM Cloud, the SDK gets credentials from the [`VCAP_SERVICES`][vcap_services] environment variable. 

## Authentication

Watson services are migrating to token-based Identity and Access Management (IAM) authentication.

- With some service instances, you authenticate to the API by using **[IAM](#iam)**.
- In other instances, you authenticate by providing the **[username and password](#username-and-password)** for the service instance.

### Getting credentials
To find out which authentication to use, view the service credentials. You find the service credentials for authentication the same way for all Watson services:

1.  Go to the IBM Cloud **[Dashboard][watson-dashboard]** page.
1.  Either click an existing Watson service instance or click **Create**.
1.  Click **Show** to view your service credentials.
1.  Copy the `url` and either `apikey` or `username` and `password`.

### IAM

IBM Cloud is migrating to token-based Identity and Access Management (IAM) authentication. IAM authentication uses a service API key to get an access token that is passed with the call. Access tokens are valid for approximately one hour and must be regenerated.

You supply either an IAM service **API key** or an **access token**:

- Use the API key to have the SDK manage the lifecycle of the access token. The SDK requests an access token, ensures that the access token is valid, and refreshes it if necessary.
- Use the access token if you want to manage the lifecycle yourself. For details, see [Authenticating with IAM tokens](https://console.bluemix.net/docs/services/watson/getting-started-iam.html).

#### Supplying the IAM API key

```ruby
# In the constructor, letting the SDK manage the IAM token
discovery = IBMWatson::DiscoveryV1.new(
  version: "2017-10-16",
  iam_api_key: "<iam_api_key>",
  iam_url: "<iam_url>" # optional - the default value is https://iam.ng.bluemix.net/identity/token
)
```

```ruby
# after instantiation, letting the SDK manage the IAM token
discovery = IBMWatson::DiscoveryV1.new(version: "2017-10-16")
discovery._iam_api_key(iam_api_key: "<iam_api_key>")
```

#### Supplying the access token
```ruby
# in the constructor, assuming control of managing IAM token
discovery = IBMWatson::DiscoveryV1.new(
  version: "2017-10-16",
  iam_access_token: "<iam_access_token>"
)
```

```ruby
# after instantiation, assuming control of managing IAM token
discovery = IBMWatson::DiscoveryV1.new(version: "2017-10-16")
discovery._iam_access_token(iam_access_token: "<access_token>")
```

### Username and password
```ruby
require "ibm_watson"
include IBMWatson
# In the constructor
discovery = DiscoveryV1.new(version: "2017-10-16", username: "<username>", password: "<password>")
```

```ruby
# After instantiation
discovery = DiscoveryV1.new(version: "2017-10-16")
discovery.username = "<username>"
discovery.password = "<password>"
```

## Sending requests asynchronously
Requests can be sent asynchronously. There are two asynchronous methods available for the user, `async` & `await`. When used, these methods return an [Ivar][ivar] object.
* To call a method asynchronously, simply insert `.await` or `.async` into the call: `service.translate` would be `service.async.translate`
* To access the response from an [Ivar][ivar] object called `future`, simply call `future.value`

When `await` is used, the request is made synchronously.
```ruby
speech_to_text = IBMWatson::SpeechToTextV1.new(
  username: "username",
  password: "password"
)
audio_file = File.open(Dir.getwd + "/resources/speech.wav")
future = speech_to_text.await.recognize(
  audio: audio_file
)
p future.complete? # If the request is successful, then this will be true
output = future.value # The response is accessible at future.value
```

When `async` is used, the request is made asynchronously
```ruby
speech_to_text = IBMWatson::SpeechToTextV1.new(
  username: "username",
  password: "password"
)
audio_file = File.open(Dir.getwd + "/resources/speech.wav")
future = speech_to_text.async.recognize(
  audio: audio_file
)
p future.complete? # Can be false if the request is still running
future.wait # Wait for the asynchronous call to finish
p future.complete? # If the request is successful, then this will now be true
output = future.value
```

## Sending request headers
Custom headers can be passed in any request in the form of a `Hash` as a parameter to the `headers` chainable method. For example, to send a header called `Custom-Header` to a call in Watson Assistant, pass the headers as a parameter to the `headers` chainable method:
```ruby
require "ibm_watson"
include IBMWatson

assistant = AssistantV1.new(
  username: "xxx",
  password: "yyy",
  version: "2017-04-21"
)

response = assistant.headers(
  "Custom-Header" => "custom_value"
  ).list_workspaces
```

## Parsing HTTP response info
HTTP requests all return `DetailedResponse` objects that have a `result`, `status`, and `headers`
```ruby
require "ibm_watson"
include IBMWatson

assistant = AssistantV1.new(
  username: "xxx",
  password: "yyy",
  version: "2017-04-21"
)

response = assistant.headers(
  "Custom-Header" => "custom_value"
  ).list_workspaces

p "Status: #{response.status}"
p "Headers: #{response.headers}"
p "Result: #{response.result}"
```

This would give an output of `DetailedResponse` having the structure:
```ruby
Status: 200
Headers: <http response headers>
Result: <response returned by service>
```

## Using Websockets

The Speech-to-Text service supports websockets with the `recognize-with-websockets` method. The method accepts a custom callback class. The `eventmachine` loop that the websocket uses blocks the main thread by default. Here is an example of using the websockets method:

```ruby
require "ibm_watson"

callback = IBMWatson::RecognizeCallback.new
audio_file = "<Audio File for Analysis>"
speech_to_text = IBMWatson::SpeechToTextV1.new(
  username: "<username>",
  password: "<password>"
)
websocket = speech_to_text.recognize_with_websocket(
  audio: audio_file,
  recognize_callback: callback,
  interim_results: true
)
thr = Thread.new do # Start the websocket inside of a thread
  websocket.start # Starts the websocket and begins sending audio to the server.
  # The `callback` processes the data from the server
end
thr.join # Wait for the thread to finish before ending the program or running other code
```

## Ruby version

Tested on Ruby 2.3, 2.4, 2.5

## Contributing

See [CONTRIBUTING.md][CONTRIBUTING].

## License

This library is licensed under the [Apache 2.0 license][license].

[wdc]: http://www.ibm.com/watson/developercloud/
[ibm_cloud]: https://console.bluemix.net
[watson-dashboard]: https://console.bluemix.net/dashboard/apps?category=watson
[examples]: https://github.com/watson-developer-cloud/ruby-sdk/tree/master/examples
[CONTRIBUTING]: https://github.com/watson-developer-cloud/ruby-sdk/blob/master/CONTRIBUTING.md
[license]: http://www.apache.org/licenses/LICENSE-2.0
[vcap_services]: https://console.bluemix.net/docs/services/watson/getting-started-variables.html
[ibm-cloud-onboarding]: http://console.bluemix.net/registration?target=/developer/watson&cm_sp=WatsonPlatform-WatsonServices-_-OnPageNavLink-IBMWatson_SDKs-_-Ruby
[ivar]: http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/IVar.html
