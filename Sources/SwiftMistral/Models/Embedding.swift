import Foundation
import OpenAPIRuntime

public struct Embedding {
    public var object: String?
    public var embedding: [Double]?
    public var index: Int?

    public init(
        object: String?,
        embedding: [Double]?,
        index: Int?
    ) {
        self.object = object
        self.embedding = embedding
        self.index = index
    }
}

extension Embedding {
    init(_ embedding: Components.Schemas.EmbeddingResponse.dataPayloadPayload) {
        self.init(
            object: embedding.object,
            embedding: embedding.embedding,
            index: embedding.index
        )
    }
}
