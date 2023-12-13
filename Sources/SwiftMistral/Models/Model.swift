import Foundation
import OpenAPIRuntime

public struct Model: Codable, Hashable {
    public var id: String
    public var object: String
    public var created: Int
    public var ownedBy: String

    public init(id: String, object: String, created: Int, ownedBy: String) {
        self.id = id
        self.object = object
        self.created = created
        self.ownedBy = ownedBy
    }
}

extension Model {
    init(_ model: Components.Schemas.Model) {
        self.init(
            id: model.id,
            object: model.object,
            created: model.created,
            ownedBy: model.owned_by
        )
    }
}
