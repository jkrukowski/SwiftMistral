import Foundation
import HTTPTypes
import OpenAPIRuntime

struct AuthMiddelware: ClientMiddleware {
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func intercept(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPTypes.HTTPRequest, OpenAPIRuntime.HTTPBody?, URL) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        var request = request
        request.headerFields.append(
            HTTPField(name: .authorization, value: "Bearer \(apiKey)")
        )
        return try await next(request, body, baseURL)
    }
}
