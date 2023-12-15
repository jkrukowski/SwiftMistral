import Foundation
import HTTPTypes
import OpenAPIRuntime

/// NOTE: Taken from https://github.com/apple/swift-openapi-generator/blob/main/Examples/retrying-middleware-example/Sources/RetryingClientMiddleware/RetryingClientMiddleware.swift
struct RetryingMiddleware {
    /// The policy to use when a retryable signal hints that a retry might be appropriate.
    enum RetryingPolicy: Hashable {
        /// Don't retry.
        case never

        /// Retry up to the provided number of attempts.
        case upToAttempts(count: Int)
    }

    /// The policy of delaying the retried request.
    enum DelayPolicy: Hashable {
        /// Don't delay, retry immediately.
        case none

        /// Constant delay.
        case constant(seconds: TimeInterval)
    }

    /// The retry status codes that lead to the retry policy being evaluated.
    var retryStatusCodes: Set<Int>

    /// The policy used to evaluate whether to perform a retry.
    var policy: RetryingPolicy

    /// The delay policy for retries.
    var delay: DelayPolicy

    /// Creates a new retrying middleware.
    /// - Parameters:
    ///   - retryStatusCodes: The retry status codes that lead to the retry policy being evaluated.
    ///   - policy: The policy used to evaluate whether to perform a retry.
    ///   - delay: The delay policy for retries.
    init(
        retryStatusCodes: Set<Int>,
        policy: RetryingPolicy = .upToAttempts(count: 3),
        delay: DelayPolicy = .constant(seconds: 1)
    ) {
        self.retryStatusCodes = retryStatusCodes
        self.policy = policy
        self.delay = delay
    }
}

extension RetryingMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPTypes.HTTPRequest, OpenAPIRuntime.HTTPBody?, URL) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        guard case let .upToAttempts(count: maxAttemptCount) = policy else {
            return try await next(request, body, baseURL)
        }
        if let body {
            guard body.iterationBehavior == .multiple else {
                return try await next(request, body, baseURL)
            }
        }
        for attempt in 1 ... maxAttemptCount {
            let (response, responseBody) = try await next(request, body, baseURL)
            if retryStatusCodes.contains(response.status.code), attempt < maxAttemptCount {
                try await willRetry()
            } else {
                return (response, responseBody)
            }
        }
        preconditionFailure("Unreachable")
    }

    private func willRetry() async throws {
        switch delay {
        case .none:
            return
        case let .constant(seconds: seconds):
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        }
    }
}
