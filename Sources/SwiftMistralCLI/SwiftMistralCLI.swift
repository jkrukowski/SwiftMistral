import ArgumentParser
import Foundation
import SwiftMistral

enum MistralError: Error {
    case missingAPIKey
}

@main
struct SwiftMistralCLI: AsyncParsableCommand {
    @Argument(help: "Mistral API key, if `nil` the key will be taken from `MISTRAL_API_KEY` variable.")
    var apiKey: String?

    mutating func run() async throws {
        let apiKey = apiKey ?? ProcessInfo.processInfo.environment["MISTRAL_API_KEY"]
        guard let apiKey else {
            throw MistralError.missingAPIKey
        }
        let client = try MistralClient(apiKey: apiKey)
        let input = "Hi, tell me a joke!"
        let chatCompletion = try await client.createChatCompletion(
            model: "mistral-tiny",
            messages: [.init(role: .user, content: input)]
        )
        print(input)
        for try await chat in chatCompletion {
            for choice in chat.choices {
                if let delta = choice.delta, let content = delta.content {
                    print(content, terminator: "")
                }
            }
        }
    }
}
