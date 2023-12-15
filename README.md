# Mistral Swift Client

You can use the Mistral Swift client to interact with the Mistral AI API.

## Usage

Command line demo

```
$ swift run swift-mistral "<API_KEY>" 
```

In your own code

```swift
import SwiftMistral

let client = try MistralClient(apiKey: "<API_KEY>")
let chatCompletion = try await client.createChatCompletion(
    model: "<MODEL_ID>", 
    messages: [.init(role: .user, content: "<YOUR_MESSAGE>")]
)
for try await chat in chatCompletion {
    for choice in chat.choices {
        if let delta = choice.delta, let content = delta.content {
            // Do something with the response
        }
    }
}
```

## Tests

```
$ swift test
```
