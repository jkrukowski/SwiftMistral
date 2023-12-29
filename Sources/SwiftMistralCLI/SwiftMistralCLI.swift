import ArgumentParser
import Foundation
import SwiftMistral

@main
struct SwiftMistralCLI: AsyncParsableCommand {
    @Option(help: "Mistral API key, if `nil` the key will be taken from `MISTRAL_API_KEY` env variable.")
    var apiKey: String?
    @Option(help: "Mistral model to use.")
    var model: String = "mistral-tiny"
    @Option(help: "Input to send to the model.")
    var input: String
    @Flag(help: "Enable verbose logging.")
    var verbose = false

    mutating func run() async throws {
        let apiKey = apiKey ?? ProcessInfo.processInfo.environment["MISTRAL_API_KEY"]
        guard let apiKey else {
            throw ValidationError("Missing API key.")
        }
        var logger = defaultLogger
        logger.logLevel = verbose ? .debug : .info
        let client = try MistralClient(apiKey: apiKey, logger: logger)
        let chatCompletion = try await client.createChatCompletion(
            model: model,
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
