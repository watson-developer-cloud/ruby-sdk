### Ruby SDK V2 Migration guide

#### Breaking Changes
* The Text To Speech changes

#### Service changes

##### Assistant v1

* Now Accepts `includeCount` Parameter: `listWorkspaces()`, `listIntents()`, `listExamples()`, `listCounterexamples()`, `listEntities()`, `listValues()`, `listSynonyms()`, `listDialogNodes()`, 
* `createWorkspace()`: function parameter reordering
* `updateWorkspace()`: function parameter reordering
* `createDialogNode()`: parameter `context` type change from `[Sting: JSON]?` to `DialogNodeContext?`
* `updateDialogNode()`: parameter `newContext` type change from `[Sting: JSON]?` to `DialogNodeContext?`
* `bulkClassify()`: function added - Identify intents and entities in multiple user utterances.

##### Assistant v2
* `bulkClassify()`: function added - Identify intents and entities in multiple user utterances.

##### Compare Comply v1
* `listFeedback()`: `before` and `after` parameters removed

##### Discovery v2
* `analyzeDocument()`: function added - Process a document using the specified collection's settings and return it for realtime use. - Currently CP4D only

##### Text To Speech V1
* `createVoiceModel()`: function changed to `createCustomModel()`
* `listVoiceModels()`: function changed to `listCustomModels()`
* `updateVoiceModel()`: function changed to `updateCustomModel()`
* `getVoiceModel()`: function changed to `getCustomModel()`
* `deleteVoiceModel()`: function changed to `deleteCustomModel()`

##### Tone Analyzer V3
* `tone()`: `tones` parameter added

##### Visual Recognition V4
* `createCollection()`: `trainingStatus` parameter added
* `updateCollection()`: `trainingStatus` parameter added
* `getTrainingUsage()`: `startTime` and `endTime` parameter types changed from `String?` to `Date?`
