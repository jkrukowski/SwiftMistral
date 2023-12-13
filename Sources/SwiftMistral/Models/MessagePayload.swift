import Foundation
import OpenAPIRuntime

public struct MessagePayload {
    public var role: RolePayload
    public var content: String

    init(role: RolePayload, content: String) {
        self.role = role
        self.content = content
    }
}

extension MessagePayload {
    var payload: Components.Schemas.ChatCompletionRequest.messagesPayloadPayload {
        Components.Schemas.ChatCompletionRequest.messagesPayloadPayload(
            role: role.payload,
            content: content
        )
    }
}
