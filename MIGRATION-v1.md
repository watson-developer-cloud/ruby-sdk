### Ruby SDK V1 Migration guide

#### Authentication

##### v0.x.x

Previously different parameters were passed into the service constructor for authentication.

```ruby
def example
  service = IBMWatson::AssistantV1.new(
    iam_apikey: "{iam_apikey}",
    url: "{service_endpoint}",
    version: "{version_date}"
  );
  service.url = "{service_endpoint}";
end
```

##### v1.x.x

Now we use an `Authenticator` to authenticate the service. Available authentication schemes include `IamAuthenticator`, `BasicAuthenticator`, `CloudPakForDataAuthenticator` and `BearerTokenAuthenticator`

###### IamAuthenticator

```ruby
def example
  authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
    apikey: "{apikey}"
  )
  service = IBMWatson::AssistantV1.new(
    authenticator: authenticator,
    version: "{version_date}"
  );
  service.service_url = "{serviceUrl}";
end
```

##### BasicAuthenticator

```ruby
def example
  authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
    username: "{username}",
    password: "{password}"
  )
  service = IBMWatson::AssistantV1.new(
    authenticator: authenticator,
    version: "{version_date}"
  );
  service.service_url = "{serviceUrl}";
end
```

###### BearerTokenAuthenticator

```ruby
  authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
    bearer_token: "{bearerToken}"
  )
  service = IBMWatson::AssistantV1.new(
    authenticator: authenticator,
    version: "{version_date}"
  );
  service.service_url = "{serviceUrl}";
```

###### CloudPakForDataAuthenticator

```ruby
  authenticator = IBMWatson::Authenticators::CloudPakForDataAuthenticator.new(
    url: "https://{cp4d_cluster_host}{:port}",
    username: "{username}",
    password: "{password}"
  )
  service = IBMWatson::AssistantV1.new(
    authenticator: authenticator,
    version: "{version_date}"
  );
  service.service_url = "{serviceUrl}";
```

#### Supplying credentials

You can supply credentials to your service using external `ibm-credentials.env` files.

```ruby
  service = IBMWatson::AssistantV1.new(
    version: "{version_date}"
  );
  response = service.list_workspaces.result
  puts JSON.pretty_generate(response)
```

##### v0.x.x

Previously we would look for these files first in the system `home` directory, followed by the current project directory.

##### v1.x.x
Now in order to allow developers to have different configurations for each project we look first in the current project directory, followed by the home directory.

#### Setting the service url

##### v0.x.x

Previously we set the service url by setting url.

```ruby
def example
  service = IBMWatson::AssistantV1.new(
    iam_apikey: "{iam_apikey}",
    url: "{service_endpoint}",
    version: "{version_date}"
  );
  service.url = "{service_endpoint}";
end
```

##### v1.x.x

Now we set the service url by calling the `service_url` setter.

```ruby
def example
  authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
    apikey: "{apikey}"
  )
  service = IBMWatson::AssistantV1.new(
    authenticator: authenticator,
    version: "{version_date}"
  );
  service.service_url = "{serviceUrl}";
end
```

#### Service changes

##### Assistant v1

* `include_count` is no longer a parameter of the `list_workspaces()` method
* `include_count` is no longer a parameter of the `list_intents()` method
* `include_count` is no longer a parameter of the `list_examples()` method
* `include_count` is no longer a parameter of the `list_counterexamples()` method
* `include_count` is no longer a parameter of the `list_entities()` method
* `include_count` is no longer a parameter of the `list_values()` method
* `include_count` is no longer a parameter of the `list_synonyms()` method
* `include_count` is no longer a parameter of the `list_dialogNodes()` method
* `value_type` was renamed to `type` in the `calue()` method
* `new_value_type` was renamed to `newType` in the `update_value()` method
* `node_type` was renamed to `type` in the `create_dialog_node()` method
* `node_type` was renamed to `type` in the `create_dialog_node()` method
* `new_node_type` was renamed to `new_type` in the `update_dialog_node()` method

##### Compare Comply v1

* `convert_to_html()` method does not require a `filename` parameter

##### Discovery v1

* `return_fields` was renamed to `_return` in the `query()` method
* `logging_optOut` was renamed to `x_watson_logging_optOut` in the `query()` method
* `spelling_suggestions` was added to the `query()` method
* `collection_ids` is no longer a parameter of the `query()` method
* `return_fields` was renamed to `_return` in the `QueryNotices()` method
* `logging_optOut` was renamed to `x_watson_logging_optOut` in the `federated_query()` method
* `collection_ids` is now required in the `federated_query()` method
* `collection_ids` changed position in the `federated_query()` method
* `return_fields` was renamed to `_return` in the `federated_query()` method
* `return_fields` was renamed to `_return` in the `federated_query_notices()` method
* `test_configuration_in_environment()` method was removed
* `query_entities()` method was removed
* `query_relations()` method was removed

##### Language Translator v3

* `default_models` was renamed to `_default` in the `list_models()` method

##### Natural Language Classifier v1

* `metadata` was renamed to `training_metadata` in the `create_classifier()` method

##### Speech to Text v1

* `strict` is no longer a parameter of the `train_acoustic_model()` method
* `recognize_with_websocket()` method was removed

##### Visual Recognition v3

* `detect_faces()` method was removed

##### Visual Recognition v4

* New service!