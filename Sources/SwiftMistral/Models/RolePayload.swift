import Foundation
import OpenAPIRuntime

public enum RolePayload: String {
    case assistant
    case system
    case user
}

extension RolePayload {
    var payload: Components.Schemas.ChatCompletionRequest.messagesPayloadPayload.rolePayload {
        switch self {
        case .assistant:
            return .assistant
        case .system:
            return .system
        case .user:
            return .user
        }
    }
}
