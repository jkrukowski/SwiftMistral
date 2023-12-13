import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

open class MistralClient {
    private let client: Client

    public init(apiKey: String) throws {
        client = try Client(
            serverURL: Servers.server1(),
            transport: AsyncHTTPClientTransport(),
            middlewares: [AuthMiddelware(apiKey: apiKey)]
        )
    }

    /// List Available Models
    ///
    open func listModels() async throws -> [Model] {
        let response = try await client.listModels()
        let models = try response.ok.body.json.data
        return models.map { Model($0) }
    }

    /// Create Embeddings
    ///
    /// - Parameters:
    ///   - model: The ID of the model to use for this request.
    ///   - input: The list of strings to embed.
    open func createEmbedding(model: String, input: [String]) async throws -> [Embedding] {
        let embeddingRequest = Components.Schemas.EmbeddingRequest(model: model, input: input, encoding_format: .float)
        let body = Operations.createEmbedding.Input.Body.json(embeddingRequest)
        let response = try await client.createEmbedding(Operations.createEmbedding.Input(body: body))
        let embeddings = try response.ok.body.json.data
        return embeddings.map { Embedding($0) }
    }

    /// Create Chat Completions
    ///
    /// - Parameters:
    ///   - model: The ID of the model to use for this request.
    ///   - messages: The prompt(s) to generate completions for.
    ///   - temperature: What sampling temperature to use, between 0.0 and 2.0.
    ///   - topP: Nucleus sampling, where the model considers the results of the tokens with `top_p` probability mass.
    ///   - maxTokens: The maximum number of tokens to generate in the completion.
    ///   - stream: Whether to stream back partial progress.
    ///   - safeMode: Whether to inject a safety prompt before all conversations.
    ///   - randomSeed: The seed to use for random sampling.
    open func createChatCompletion(
        model: String,
        messages: [MessagePayload],
        temperature: Double?,
        topP: Double?,
        maxTokens: Int?,
        stream: Bool,
        safeMode: Bool,
        randomSeed: Int?
    ) async throws -> ChatCompletion {
        let chatCompletionRequest = Components.Schemas.ChatCompletionRequest(
            model: model,
            messages: messages.map(\.payload),
            temperature: temperature,
            top_p: topP,
            max_tokens: maxTokens,
            stream: stream,
            safe_mode: safeMode,
            random_seed: randomSeed
        )
        let body = Operations.createChatCompletion.Input.Body.json(chatCompletionRequest)
        let response = try await client.createChatCompletion(Operations.createChatCompletion.Input(body: body))
        let chatCompletion = try response.ok.body.json
        return ChatCompletion(chatCompletion)
    }
}
