### Ruby SDK V2 Migration guide

#### Breaking Changes
* The Text To Speech changes listed below
* All services now require a version to be specified (except for stt, tts and nlu)

#### Service changes

##### Assistant v1

* `list_workspaces()`: `include_count` parameter added 
* `list_intents()`: `include_count` parameter added 
* `list_examples()`: `include_count` parameter added 
* `list_counterexamples()`: `include_count` parameter added 
* `list_entities()`: `include_count` parameter added 
* `list_values()`: `include_count` parameter added 
* `list_synonyms()`: `include_count` parameter added 
* `list_dialog_nodes()`: `include_count` parameter added 
* `create_workspace()`: reorder `dialog_nodes`, `counterexamples`, `webhooks` parameters 
* `update_workspace()`: reorder `dialog_nodes`, `counterexamples`, `webhooks` parameters 
* `bulk_classify()`: function added - Identify intents and entities in multiple user utterances.

##### Assistant v2
* `bulk_classify()`: function added - Identify intents and entities in multiple user utterances.

##### Compare Comply v1
* `list_feedback()`: `before` and `after` parameters removed

##### Discovery v2
* `analyze_document()`: function added - Process a document using the specified collection's settings and return it for realtime use. - Currently CP4D only

##### Personality Insights V3
* On 1 December 2021, Personality Insights will no longer be available

##### Text To Speech V1
* `create_voice_model()`: function changed to `create_custom_model()`
* `list_voice_models()`: function changed to `list_custom_models()`
* `update_voice_model()`: function changed to `update_custom_model()`
* `get_voice_model()`: function changed to `get_custom_model()`
* `delete_voice_model()`: function changed to `delete_custom_model()`

##### Visual Recognition V4
* `create_collection()`: `training_status` parameter added
* `update_collection()`: `training_status` parameter added
