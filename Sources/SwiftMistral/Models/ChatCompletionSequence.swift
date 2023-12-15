import Collections
import Foundation
import OpenAPIRuntime

public struct ChatCompletionSequence: AsyncSequence {
    public typealias Element = ChatCompletion
    private let body: HTTPBody

    public init(_ body: HTTPBody) {
        self.body = body
    }

    public func makeAsyncIterator() -> ChatCompletionIterator {
        ChatCompletionIterator(body.makeAsyncIterator())
    }
}

public struct ChatCompletionIterator: AsyncIteratorProtocol {
    private var iterator: HTTPBody.AsyncIterator
    private var responseBuffer: Deque<String.SubSequence>
    private let prefix = "data: "
    private let endString = "[DONE]"
    private let jsonDecoder = JSONDecoder()

    public init(_ iterator: HTTPBody.AsyncIterator) {
        self.iterator = iterator
        responseBuffer = []
    }

    public mutating func next() async throws -> ChatCompletion? {
        while try await populateBuffer() {
            while let string = responseBuffer.popFirst() {
                guard string.hasPrefix(prefix) else {
                    continue
                }
                let toDecode = String(string.dropFirst(prefix.count)).trimmingCharacters(in: .whitespacesAndNewlines)
                guard !string.isEmpty, toDecode != endString else {
                    continue
                }
                guard let dataToDecode = toDecode.data(using: .utf8) else {
                    continue
                }
                let partialResponse = try jsonDecoder.decode(Components.Schemas.ChatCompletionResponse.self, from: dataToDecode)
                return ChatCompletion(partialResponse)
            }
        }
        return nil
    }

    /// Populates the buffer with the next element from the body iterator.
    /// - Returns: `true` if the buffer is not empty, `false` otherwise.
    private mutating func populateBuffer() async throws -> Bool {
        guard responseBuffer.isEmpty else {
            return true
        }
        guard let bodyFragment = try await iterator.next() else {
            return !responseBuffer.isEmpty
        }
        guard let strings = String(bytes: bodyFragment, encoding: .utf8)?.split(separator: "\n") else {
            return !responseBuffer.isEmpty
        }
        responseBuffer.append(contentsOf: strings)
        return !responseBuffer.isEmpty
    }
}
