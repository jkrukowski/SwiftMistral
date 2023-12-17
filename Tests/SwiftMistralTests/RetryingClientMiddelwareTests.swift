import HTTPTypes
import OpenAPIRuntime
@testable import SwiftMistral
import XCTest

final class RetryingClientMiddelwareTests: XCTestCase {
    func testMiddlewareShouldNotRepeatWhenPolicyIsNever() async throws {
        let middleware = RetryingMiddleware(
            retryStatusCodes: [500],
            policy: .never
        )

        let nextExpectation = expectation(description: "Wait for next to be called")
        let next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?) = { _, _, _ in
            nextExpectation.fulfill()
            let status = HTTPResponse.Status(code: 500)
            return (HTTPResponse(status: status), nil)
        }

        _ = try await middleware.intercept(
            body: nil,
            next: next
        )

        await fulfillment(of: [nextExpectation])
    }

    func testMiddlewareShouldNotRepeatWhenResponseDoesNotMatchRetryStatusCodes() async throws {
        let middleware = RetryingMiddleware(
            retryStatusCodes: [500],
            policy: .upToAttempts(count: 3)
        )

        let nextExpectation = expectation(description: "Wait for next to be called")
        let next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?) = { _, _, _ in
            nextExpectation.fulfill()
            let status = HTTPResponse.Status(code: 429)
            return (HTTPResponse(status: status), nil)
        }

        _ = try await middleware.intercept(
            body: nil,
            next: next
        )

        await fulfillment(of: [nextExpectation])
    }

    func testMiddlewareShouldNotRepeatWhenBodyIterationBehaviorIsNotMultiple() async throws {
        let middleware = RetryingMiddleware(
            retryStatusCodes: [500],
            policy: .upToAttempts(count: 3)
        )

        let nextExpectation = expectation(description: "Wait for next to be called")
        let next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?) = { _, _, _ in
            nextExpectation.fulfill()
            let status = HTTPResponse.Status(code: 500)
            return (HTTPResponse(status: status), nil)
        }

        _ = try await middleware.intercept(
            body: HTTPBody([1, 2, 3], length: .known(3), iterationBehavior: .single),
            next: next
        )

        await fulfillment(of: [nextExpectation])
    }

    func testMiddlewareShouldRepeatWhenBodyIterationBehaviorIsMultipleAndPolicyIsRepeat() async throws {
        let middleware = RetryingMiddleware(
            retryStatusCodes: [500],
            policy: .upToAttempts(count: 3),
            delay: .none
        )

        let nextExpectation = expectation(description: "Wait for next to be called")
        nextExpectation.expectedFulfillmentCount = 4
        let next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?) = { _, _, _ in
            nextExpectation.fulfill()
            let status = HTTPResponse.Status(code: 500)
            return (HTTPResponse(status: status), nil)
        }

        _ = try await middleware.intercept(
            body: HTTPBody([1, 2, 3], length: .known(3), iterationBehavior: .multiple),
            next: next
        )

        await fulfillment(of: [nextExpectation])
    }
}
