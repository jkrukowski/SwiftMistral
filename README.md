# Mistral Swift Client

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjkrukowski%2FSwiftMistral%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/jkrukowski/SwiftMistral)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjkrukowski%2FSwiftMistral%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/jkrukowski/SwiftMistral)

Use the Mistral Swift client to interact with the Mistral AI API.

## Usage

Command line demo

```
$ swift run swift-mistral --api-key "<API_KEY>" --input "Hello, how are you?"
```

Command line help

```
$ swift run swift-mistral --help
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

## Format code

```
$ swift package plugin --allow-writing-to-package-directory swiftformat
```

## Tests

```
$ swift test
```
