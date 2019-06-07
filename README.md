# IBM Watson Ruby SDK

[![Build Status](https://travis-ci.org/watson-developer-cloud/ruby-sdk.svg)](https://travis-ci.org/watson-developer-cloud/ruby-sdk)
[![Build status](https://ci.appveyor.com/api/projects/status/ir3k0ue138o4u67e?svg=true)](https://ci.appveyor.com/project/maxnussbaum/ruby-sdk)
[![Slack](https://wdc-slack-inviter.mybluemix.net/badge.svg)](https://wdc-slack-inviter.mybluemix.net)
[![codecov.io](https://codecov.io/github/watson-developer-cloud/ruby-sdk/coverage.svg)](https://codecov.io/github/watson-developer-cloud/ruby-sdk)
[![Gem Version](https://badge.fury.io/rb/ibm_watson.svg)](https://badge.fury.io/rb/ibm_watson)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![CLA assistant](https://cla-assistant.io/readme/badge/watson-developer-cloud/ruby-sdk)](https://cla-assistant.io/watson-developer-cloud/ruby-sdk)

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
  * [Configuring the HTTP client](#configuring-the-http-client)
  * [Using Websockets](#using-websockets)
  * [Ruby version](#ruby-version)
  * [Contributing](#contributing)
  * [License](#license)
  * [Featured Projects](#featured-projects)

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

1. Go to the IBM Cloud [Dashboard](https://cloud.ibm.com/) page.
1. Either click an existing Watson service instance in your [resource list](https://cloud.ibm.com/resources) or click [**Create resource > AI**](https://cloud.ibm.com/catalog?category=ai) and create a service instance.
1. Click on the **Manage** item in the left nav bar of your service instance.

 On this page, you should be able to see your credentials for accessing your service instance.

### Supplying credentials

 There are two ways to supply the credentials you found above to the SDK for authentication.

#### Credential file (easier!)

With a credential file, you just need to put the file in the right place and the SDK will do the work of parsing and authenticating. You can get this file by clicking the **Download** button for the credentials in the **Manage** tab of your service instance.

The file downloaded will be called `ibm-credentials.env`. This is the name the SDK will search for and **must** be preserved unless you want to configure the file path (more on that later). The SDK will look for your `ibm-credentials.env` file in the following places (in order):

- Your system's home directory
- The top-level directory of the project you're using the SDK in

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

- Use the API key to have the SDK manage the lifecycle of the access token. The SDK requests an access token, ensures that the access token is valid, and refreshes it if necessary.
- Use the access token if you want to manage the lifecycle yourself. For details, see [Authenticating with IAM tokens](https://cloud.ibm.com/docs/services/watson?topic=watson-iam).

#### Supplying the IAM API key

```ruby
# In the constructor, letting the SDK manage the IAM token
discovery = IBMWatson::DiscoveryV1.new(
  version: "2017-10-16",
  iam_apikey: "<iam_apikey>",
  iam_url: "<iam_url>" # optional - the default value is https://iam.cloud.ibm.com/identity/token
)
```

```ruby
# after instantiation, letting the SDK manage the IAM token
discovery = IBMWatson::DiscoveryV1.new(version: "2017-10-16")
discovery.iam_apikey(iam_apikey: "<iam_apikey>")
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
discovery.iam_access_token(iam_access_token: "<access_token>")
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
Headers: "<http response headers>"
Result: "<response returned by service>"
```

## Configuring the HTTP client
To set client configs like timeout or proxy use the `configure_http_client` function and pass in the configurations.

```ruby
require "ibm_watson/assistant_v1"
include IBMWatson

assistant = AssistantV1.new(
  username: "{username}",
  password: "{password}",
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
  username: "<username>",
  password: "<password>",
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

## IBM Cloud Pak for Data(ICP4D)
If your service instance is of ICP4D, below are two ways of initializing the assistant service.

#### 1) Supplying the `username`, `password`, `icp4d_url` and `authentication_type`

The SDK will manage the token for the user

```ruby
  assistant = IBMWatson::AssistantV1.new(
    version: "<version>",
    username: "<username>",
    password: "<password>",
    url: "<service url>",
    icp4d_url: "<authentication url>",
    authentication_type: "icp4d"
  )
  assistant.configure_http_client(disable_ssl_verification: true) # MAKE SURE SSL VERIFICATION IS DISABLED
```

#### 2) Supplying the access token

```ruby
  assistant = IBMWatson::AssistantV1.new(
    version: "<version>",
    url: "<service url>",
    icp4d_token: "<your managed access token>",
    authentication_type: "icp4d"
  )
  assistant.configure_http_client(disable_ssl_verification: true) # MAKE SURE SSL VERIFICATION IS DISABLED
```

## Ruby version

Tested on:
* MRI Ruby (RVM): 2.3.7, 2.4.4, 2.5.1
* RubyInstaller (Windows x64): 2.3.3, 2.4.4, 2.5.1

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
[vcap_services]: https://cloud.ibm.com/docs/services/watson?topic=watson-vcapServices
[ibm-cloud-onboarding]: http://cloud.ibm.com/registration?target=/developer/watson&cm_sp=WatsonPlatform-WatsonServices-_-OnPageNavLink-IBMWatson_SDKs-_-Ruby
[ivar]: http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/IVar.html
