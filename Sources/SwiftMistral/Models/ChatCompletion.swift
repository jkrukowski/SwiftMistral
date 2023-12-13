import Foundation
import OpenAPIRuntime

public struct ChatCompletion {
    public var id: String?
    public var object: String?
    public var created: Int?
    public var model: String?
    public var choices: [Choices]
    public var usage: Usage?

    init(
        id: String?,
        object: String?,
        created: Int?,
        model: String?,
        choices: [ChatCompletion.Choices],
        usage: ChatCompletion.Usage?
    ) {
        self.id = id
        self.object = object
        self.created = created
        self.model = model
        self.choices = choices
        self.usage = usage
    }

    init(_ chatCompletion: Components.Schemas.ChatCompletionResponse) {
        let choices: [ChatCompletion.Choices] =
            if let choices = chatCompletion.choices {
                choices.map { ChatCompletion.Choices($0) }
            } else {
                []
            }
        let usage: ChatCompletion.Usage? =
            if let usage = chatCompletion.usage {
                ChatCompletion.Usage(usage)
            } else {
                nil
            }
        self.init(
            id: chatCompletion.id,
            object: chatCompletion.object,
            created: chatCompletion.created,
            model: chatCompletion.model,
            choices: choices,
            usage: usage
        )
    }
}

extension ChatCompletion {
    public struct Choices {
        public var index: Int
        public var messages: [Message]
        public var finishReason: FinishReason

        public init(
            index: Int,
            messages: [ChatCompletion.Message],
            finishReason: ChatCompletion.FinishReason
        ) {
            self.index = index
            self.messages = messages
            self.finishReason = finishReason
        }

        init(_ choice: Components.Schemas.ChatCompletionResponse.choicesPayloadPayload) {
            let messages: [ChatCompletion.Message] =
                if let message = choice.message {
                    message.map { ChatCompletion.Message($0) }
                } else {
                    []
                }
            self.init(
                index: choice.index,
                messages: messages,
                finishReason: ChatCompletion.FinishReason(choice.finish_reason)
            )
        }
    }
}

extension ChatCompletion {
    public enum FinishReason {
        case stop
        case length
        case modelLength

        init(_ finishReason: Components.Schemas.ChatCompletionResponse.choicesPayloadPayload.finish_reasonPayload) {
            switch finishReason {
            case .stop:
                self = .stop
            case .length:
                self = .length
            case .model_length:
                self = .modelLength
            }
        }
    }
}

extension ChatCompletion {
    public struct Message {
        public var role: Role?
        public var content: String?

        public init(
            role: ChatCompletion.Role?,
            content: String?
        ) {
            self.role = role
            self.content = content
        }

        init(_ message: Components.Schemas.ChatCompletionResponse.choicesPayloadPayload.messagePayloadPayload) {
            let role: ChatCompletion.Role? =
                if let role = message.role {
                    ChatCompletion.Role(role)
                } else {
                    nil
                }
            self.init(role: role, content: message.content)
        }
    }
}

extension ChatCompletion {
    public enum Role {
        case user
        case assistant

        init(_ role: Components.Schemas.ChatCompletionResponse.choicesPayloadPayload.messagePayloadPayload.rolePayload) {
            switch role {
            case .user:
                self = .user
            case .assistant:
                self = .assistant
            }
        }
    }
}

extension ChatCompletion {
    public struct Usage {
        public var promptTokens: Int
        public var completionTokens: Int
        public var totalTokens: Int

        public init(
            promptTokens: Int,
            completionTokens: Int,
            totalTokens: Int
        ) {
            self.promptTokens = promptTokens
            self.completionTokens = completionTokens
            self.totalTokens = totalTokens
        }

        init(_ usage: Components.Schemas.ChatCompletionResponse.usagePayload) {
            self.init(
                promptTokens: usage.prompt_tokens,
                completionTokens: usage.completion_tokens,
                totalTokens: usage.total_tokens
            )
        }
    }
}