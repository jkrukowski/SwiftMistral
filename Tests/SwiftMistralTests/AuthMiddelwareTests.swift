import HTTPTypes
import OpenAPIRuntime
@testable import SwiftMistral
import XCTest

final class AuthMiddelwareTests: XCTestCase {
    func testMiddlewareShouldAddApiToken() async throws {
        let middleware = AuthMiddelware(apiKey: "test_api_key")
        let request = HTTPRequest(method: .post, scheme: nil, authority: nil, path: nil)

        let nextExpectation = expectation(description: "Wait for next to be called")
        let next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?) = { request, _, _ in
            XCTAssertTrue(request.headerFields.contains(.authorization))
            XCTAssertTrue(request.headerFields.contains(where: { $0.value == "Bearer test_api_key" }))
            nextExpectation.fulfill()
            return (HTTPResponse(status: .ok), nil)
        }

        _ = try await middleware.intercept(
            request,
            body: nil,
            baseURL: URL(string: "https://test.com")!,
            operationID: "test",
            next: next
        )

        await fulfillment(of: [nextExpectation])
    }
}
