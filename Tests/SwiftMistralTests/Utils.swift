import OpenAPIRuntime
@testable import SwiftMistral

enum TestData {
    static let noContent = #"data: {"id": "cmpl-d43b420501804c298b1a5ac6b03c68c6", "model": "mistral-tiny", "choices": [{"index": 0, "delta": {"role": "assistant"}, "finish_reason": null}]}"#
    static let content = #"data: {"id": "cmpl-d43b420501804c298b1a5ac6b03c68c6", "object": "chat.completion.chunk", "created": 1702635854, "model": "mistral-tiny", "choices": [{"index": 0, "delta": {"role": null, "content": "Why don't scientists trust atoms? Because"}, "finish_reason": null}]}"#
    static let end = #"data: [DONE]"#
    static let fullContent = "\(noContent)\n\(content)\n\(content)\n\(end)"
}

extension HTTPBody {
    convenience init(_ string: String) {
        self.init(string.data(using: .utf8)!)
    }
}

extension ChatCompletionSequence {
    func collect() async throws -> [ChatCompletion] {
        try await reduce(into: []) { $0.append($1) }
    }
}
