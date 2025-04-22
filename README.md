# IBM Watson Ruby SDK

[![Build and Test](https://github.com/watson-developer-cloud/ruby-sdk/workflows/Build%20and%20Test/badge.svg?branch=master)](https://github.com/watson-developer-cloud/ruby-sdk/actions?query=workflow%3A"Build+and+Test")
[![Deploy and Publish](https://github.com/watson-developer-cloud/ruby-sdk/workflows/Deploy%20and%20Publish/badge.svg?branch=master)](https://github.com/watson-developer-cloud/ruby-sdk/actions?query=workflow%3A%22Deploy+and+Publish%22)
[![Slack](https://wdc-slack-inviter.mybluemix.net/badge.svg)](https://wdc-slack-inviter.mybluemix.net)
[![codecov.io](https://codecov.io/github/watson-developer-cloud/ruby-sdk/coverage.svg)](https://codecov.io/github/watson-developer-cloud/ruby-sdk)
[![Gem Version](https://badge.fury.io/rb/ibm_watson.svg)](https://badge.fury.io/rb/ibm_watson)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![CLA assistant](https://cla-assistant.io/readme/badge/watson-developer-cloud/ruby-sdk)](https://cla-assistant.io/watson-developer-cloud/ruby-sdk)

## Deprecation Notice
This repo and the gem package associated with it are being deprecated. While this repo will no longer see active support from the IBM team, contributions by the community via PRs are still welcomed and will be reviewed. Keep in mind, updates will no longer be published as gems and changes made after this update will need to be built independently.

Ruby gem to quickly get started with the various [IBM Watson][wdc] services.

## Announcements
### Tone Analyzer Deprecation
​
As of this major release, 3.0.0, the Tone Analyzer api has been removed in preparation for deprecation. If you wish to continue using this sdk to make calls to Tone Analyzer until its final deprecation, you will have to use a previous version.
​
On 24 February 2022, IBM announced the deprecation of the Tone Analyzer service. The service will no longer be available as of 24 February 2023. As of 24 February 2022, you will not be able to create new instances. Existing instances will be supported until 24 February 2023.
​
As an alternative, we encourage you to consider migrating to the Natural Language Understanding service on IBM Cloud. With Natural Language Understanding, tone analysis is done by using a pre-built classifications model, which provides an easy way to detect language tones in written text. For more information, see [Migrating from Watson Tone Analyzer Customer Engagement endpoint to Natural Language Understanding](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-tone_analytics).
​
### Natural Language Classifier Deprecation
​
As of this major release, 3.0.0, the NLC api has been removed in preparation for deprecation. If you wish to continue using this sdk to make calls to NLC until its final deprecation, you will have to use a previous version.
​
On 9 August 2021, IBM announced the deprecation of the Natural Language Classifier service. The service will no longer be available from 8 August 2022. As of 9 September 2021, you will not be able to create new instances. Existing instances will be supported until 8 August 2022. Any instance that still exists on that date will be deleted.
​
As an alternative, we encourage you to consider migrating to the Natural Language Understanding service on IBM Cloud that uses deep learning to extract data and insights from text such as keywords, categories, sentiment, emotion, and syntax, along with advanced multi-label text classification capabilities, to provide even richer insights for your business or industry. For more information, see [Migrating to Natural Language Understanding](https://cloud.ibm.com/docs/natural-language-classifier?topic=natural-language-classifier-migrating).

### Support for 2.7 ruby
To support 2.7 the http gem dependency is updated to 4.4.0. Since it conflicted with the dependency in the ruby-sdk-core that gem was also updated.  Using 2.0.2 or above ruby sdk will require a core of 1.1.3 or above.

### Updating endpoint URLs from watsonplatform.net
Watson API endpoint URLs at watsonplatform.net are changing and will not work after 26 May 2021. Update your calls to use the newer endpoint URLs. For more information, see https://cloud.ibm.com/docs/watson?topic=watson-endpoint-change.

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

* With some service instances, you authenticate to the API by using **[IAM](#iam)**.
* In other instances, you authenticate by providing the **[username and password](#username-and-password)** for the service instance.

### Getting credentials

To find out which authentication to use, view the service credentials. You find the service credentials for authentication the same way for all Watson services:

1. Go to the IBM Cloud [Dashboard](https://cloud.ibm.com/) page.
1. Either click an existing Watson service instance in your [resource list](https://cloud.ibm.com/resources) or click [**Create resource > AI**](https://cloud.ibm.com/catalog?category=ai) and create a service instance.
1. Click on the **Manage** item in the left nav bar of your service instance.

 On this page, you should be able to see your credentials for accessing your service instance.

### Supplying credentials

 There are two ways to supply the credentials you found above to the SDK for authentication.

#### Credential file (easier!)

With a credential file, you just need to put the file in the right place and the SDK will do the work of parsing and authenticating. You can get this file by clicking the **Download** button for the credentials in the **Manage** tab of your service instance.

The file downloaded will be called `ibm-credentials.env`. This is the name the SDK will search for and **must** be preserved unless you want to configure the file path (more on that later). The SDK will look for your `ibm-credentials.env` file in the following places (in order):

* The top-level directory of the project you're using the SDK in
* Your system's home directory

 As long as you set that up correctly, you don't have to worry about setting any authentication options in your code. So, for example, if you created and downloaded the credential file for your Discovery instance, you just need to do the following:

 ```ruby
discovery = DiscoveryV1(version: "2018-08-01")
```

 And that's it! 

 If you're using more than one service at a time in your code and get two different `ibm-credentials.env` files, just put the contents together in one `ibm-credentials.env` file and the SDK will handle assigning credentials to their appropriate services.

 If you would like to configure the location/name of your credential file, you can set an environment variable called `IBM_CREDENTIALS_FILE`. **This will take precedence over the locations specified above.** Here's how you can do that:

 ```bash
export IBM_CREDENTIALS_FILE="<path>"
```

 where `<path>` is something like `/home/user/Downloads/<file_name>.env`.

#### Manually

If you'd prefer to set authentication values manually in your code, the SDK supports that as well. The way you'll do this depends on what type of credentials your service instance gives you.

### IAM

IBM Cloud is migrating to token-based Identity and Access Management (IAM) authentication. IAM authentication uses a service API key to get an access token that is passed with the call. Access tokens are valid for approximately one hour and must be regenerated.

You supply either an IAM service **API key** or an **access token**:

* Use the API key to have the SDK manage the lifecycle of the access token. The SDK requests an access token, ensures that the access token is valid, and refreshes it if necessary.
* Use the access token if you want to manage the lifecycle yourself. For details, see [Authenticating with IAM tokens](https://cloud.ibm.com/docs/watson?topic=watson-iam).

#### Supplying the IAM API key

```ruby
# In the constructor, letting the SDK manage the IAM token
authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
  apikey: "<iam_apikey>",
  url: "<iam_url>" # optional - the default value is https://iam.cloud.ibm.com/identity/token
)
discovery = IBMWatson::DiscoveryV1.new(
  version: "2017-10-16",
  authenticator: authenticator
)
discover.service_url = "<service-url>" # setting service url
```

#### Supplying the access token

```ruby
authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
  bearer_token: "<access_token>"
)
discovery = IBMWatson::DiscoveryV1.new(version: "2017-10-16", authenticator)
```

### Username and password

```ruby
require "ibm_watson"
require "ibm_cloud_sdk_core"
include IBMWatson
# In the constructor
authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
  username: "<username>",
  password: "<password>"
)
discovery = DiscoveryV1.new(
  version: "2017-10-16",
  authenticator: authenticator
)
```

## Sending requests asynchronously

Requests can be sent asynchronously. There are two asynchronous methods available for the user, `async` & `await`. When used, these methods return an [Ivar][ivar] object.

* To call a method asynchronously, simply insert `.await` or `.async` into the call: `service.translate` would be `service.async.translate`
* To access the response from an [Ivar][ivar] object called `future`, simply call `future.value`

When `await` is used, the request is made synchronously.

```ruby
authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
  username: "<username>",
  password: "<password>"
)

speech_to_text = IBMWatson::SpeechToTextV1.new(
  authenticator: authenticator
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
authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
  username: "<username>",
  password: "<password>"
)

speech_to_text = IBMWatson::SpeechToTextV1.new(
  authenticator: authenticator
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
  authenticator: "<authenticator>"
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
  authenticator: "<authenticator>"
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
Headers: "<http response headers>"
Result: "<response returned by service>"
```

### Transaction IDs

Every SDK call returns a response with a transaction ID in the `X-Global-Transaction-Id` header. Together the service instance region, this ID helps support teams troubleshoot issues from relevant logs.

```ruby
require "ibm_watson"
include IBMWatson

assistant = AssistantV1.new(
  authenticator: "<authenticator>"
  version: "2017-04-21"
)

begin
  response = assistant.list_workspaces
  p "Global transaction id: #{response.headers["X-Global-Transaction-Id"]}"
rescue IBMCloudSdkCore::ApiException => e
  # Global transaction on failed api call is contained in the error message
  print "Error: ##{e}"
end
```

However, the transaction ID isn't available when the API doesn't return a response for some reason. In that case, you can set your own transaction ID in the request. For example, replace `<my-unique-transaction-id>` in the following example with a unique transaction ID.

```ruby
require "ibm_watson"
include IBMWatson

assistant = AssistantV1.new(
  authenticator: "<authenticator>"
  version: "2017-04-21"
)

response = assistant.headers(
  "X-Global-Transaction-Id" => "<my-unique-transaction-id>"
  ).list_workspaces
```

## Configuring the HTTP client

To set client configs like timeout or proxy use the `configure_http_client` function and pass in the configurations.

```ruby
require "ibm_watson/assistant_v1"
include IBMWatson

assistant = AssistantV1.new(
  authenticator: "<authenticator>"
  version: "2018-07-10"
)

assistant.configure_http_client(
  timeout: {
    # Accepts either :per_operation or :global
    per_operation: { # The individual timeouts for each operation
      read: 5,
      write: 7,
      connect: 10
    }
    # global: 30 # The total timeout time
  },
  proxy: {
    address: "bogus_address.com",
    port: 9999,
    username: "username",
    password: "password",
    headers: {
      bogus_header: true
    }
  }
)
```

The HTTP client can be configured to disable SSL verification. Note that this has serious security implications - only do this if you really mean to! ⚠️

To do this, pass `disable_ssl_verification` as `true` in `configure_http_client()`, like below:

```ruby
require "ibm_watson/assistant_v1"
include IBMWatson

service = AssistantV1.new(
  version: "<version>",
  authenticator: "<authenticator>"
)

service.configure_http_client(disable_ssl_verification: true)
```

## Using Websockets

The Speech-to-Text service supports websockets with the `recognize_using_websocket` method. The method accepts a custom callback class. The `eventmachine` loop that the websocket uses blocks the main thread by default. Here is an example of using the websockets method:

```ruby
require "ibm_watson"

callback = IBMWatson::RecognizeCallback.new
audio_file = "<Audio File for Analysis>"
speech_to_text = IBMWatson::SpeechToTextV1.new(
  username: "<username>",
  password: "<password>"
)
websocket = speech_to_text.recognize_using_websocket(
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

Note: `recognize_with_websocket` has been **deprecated** in favor of **`recognize_using_websocket`**

## IBM Cloud Pak for Data(CP4D)

If your service instance is of ICP4D, below are two ways of initializing the assistant service.

### Supplying the `username`, `password`, and `url`

The SDK will manage the token for the user

```ruby

authenticator = IBMWatson::Authenticators::CloudPakForDataAuthenticator.new(
  username: "<username>",
  password: "<password>",
  url: "<authentication url>",
  disable_ssl: true
)
assistant = IBMWatson::AssistantV1.new(
  version: "<version>",
  authenticator: authenticator
)

```

## Questions

If you have issues with the APIs or have a question about the Watson services, see [Stack Overflow](https://stackoverflow.com/questions/tagged/ibm-watson+ruby).

## Ruby version

Tested on:

* MRI Ruby (RVM): 2.5.1, 2.6.1
* RubyInstaller (Windows x64): 2.5.1, 2.6.1

2.3.7 and 2.4.4 should still work but support will be deprecated in next major release.

## Contributing

See [CONTRIBUTING.md][CONTRIBUTING].

## License

This library is licensed under the [Apache 2.0 license][license].

## Featured projects

Here are some projects that have been using the SDK:

* [GuardianCity](https://github.com/TalentoBogotaFedesoft/ULIBRE-061-grupo-2)

We'd love to highlight cool open-source projects that use this SDK! If you'd like to get your project added to the list, feel free to make an issue linking us to it.

[wdc]: http://www.ibm.com/watson/developercloud/
[ibm_cloud]: https://cloud.ibm.com/
[watson-dashboard]: https://cloud.ibm.com/catalog?category=ai
[examples]: https://github.com/watson-developer-cloud/ruby-sdk/tree/master/examples
[CONTRIBUTING]: https://github.com/watson-developer-cloud/ruby-sdk/blob/master/CONTRIBUTING.md
[license]: http://www.apache.org/licenses/LICENSE-2.0
[vcap_services]: https://cloud.ibm.com/docs/watson?topic=watson-vcapServices
[ibm-cloud-onboarding]: http://cloud.ibm.com/registration?target=/developer/watson&cm_sp=WatsonPlatform-WatsonServices-_-OnPageNavLink-IBMWatson_SDKs-_-Ruby
[ivar]: http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/IVar.html
