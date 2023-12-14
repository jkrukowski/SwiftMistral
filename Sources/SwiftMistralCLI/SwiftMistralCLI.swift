import ArgumentParser
import Foundation
import SwiftMistral

@main
struct SwiftMistralCLI: AsyncParsableCommand {
    @Argument(help: "Mistral API key")
    var apiKey: String

    mutating func run() async throws {
        let client = try MistralClient(apiKey: apiKey)
        let chatCompletion = try await client.createChatCompletion(
            model: "mistral-tiny", 
            messages: [.init(role: .user, content: "Hi, tell me a joke!")]
        )
        print(chatCompletion)
    }
}
