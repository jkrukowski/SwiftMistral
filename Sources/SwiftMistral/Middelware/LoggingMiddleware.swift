import Foundation
import HTTPTypes
import Logging
import OpenAPIRuntime

public let defaultLogger = Logger(label: "com.mistral-client.logging-middleware")

final class LoggingMiddleware {
    private let logger: Logger

    init(logger: Logger = defaultLogger) {
        self.logger = logger
    }
}

extension LoggingMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPTypes.HTTPRequest, OpenAPIRuntime.HTTPBody?, URL) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        log(request: request)
        do {
            let (response, responseBody) = try await next(request, body, baseURL)
            log(request: request, response: response)
            return (response, responseBody)
        } catch {
            log(request: request, error: error)
            throw error
        }
    }
}

extension LoggingMiddleware {
    func log(request: HTTPRequest) {
        logger.debug(
            "Request",
            metadata: [
                "method": .stringConvertible(request.method),
                "path": .string(request.path ?? "<nil>"),
                "headers": .array(request.headerFields.map { "\($0.name)=\($0.value)" })
            ]
        )
    }

    func log(request: HTTPRequest, response: HTTPResponse) {
        logger.debug(
            "Response",
            metadata: [
                "method": .stringConvertible(request.method),
                "path": .string(request.path ?? "<nil>"),
                "headers": .array(response.headerFields.map { "\($0.name)=\($0.value)" })
            ]
        )
    }

    func log(request: HTTPRequest, error: any Error) {
        logger.warning(
            "Request error",
            metadata: [
                "method": .stringConvertible(request.method),
                "path": .string(request.path ?? "<nil>"),
                "error": .string(error.localizedDescription)
            ]
        )
    }
}
