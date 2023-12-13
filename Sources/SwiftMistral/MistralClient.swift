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

    open func listModels() async throws -> [Model] {
        let response = try await client.listModels()
        let models = try response.ok.body.json.data
        return models.map { Model($0) }
    }

    open func createEmbedding(model: String, input: [String]) async throws -> [Embedding] {
        let embeddingRequest = Components.Schemas.EmbeddingRequest(model: model, input: input, encoding_format: .float)
        let body = Operations.createEmbedding.Input.Body.json(embeddingRequest)
        let response = try await client.createEmbedding(Operations.createEmbedding.Input(body: body))
        let embeddings = try response.ok.body.json.data
        return embeddings.map { Embedding($0) }
    }

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
