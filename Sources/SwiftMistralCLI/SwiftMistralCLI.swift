import ArgumentParser
import Foundation
import SwiftMistral

@main
struct SwiftMistralCLI: AsyncParsableCommand {
    @Argument(help: "Mistral API key")
    var apiKey: String

    mutating func run() async throws {
        let client = try MistralClient(apiKey: apiKey)
        let models = try await client.listModels()
        print(models)
    }
}
