import OpenAPIRuntime
@testable import SwiftMistral
import XCTest

final class ChatCompletionSequenceTests: XCTestCase {
    func testEmpyBodyShouldCreateEmptySequence() async throws {
        let body = HTTPBody()
        let asyncSequence = ChatCompletionSequence(body)
        let sequence = try await asyncSequence.collect()
        XCTAssertTrue(sequence.isEmpty)
    }

    func testMalformedBodyShouldCreateEmptySequence() async throws {
        let body = HTTPBody("{{{\\\\")
        let asyncSequence = ChatCompletionSequence(body)
        let sequence = try await asyncSequence.collect()
        XCTAssertTrue(sequence.isEmpty)
    }

    func testBodyNoContentDataShouldCreateNonEmptySequence() async throws {
        let body = HTTPBody(TestData.noContent)
        let asyncSequence = ChatCompletionSequence(body)
        let sequence = try await asyncSequence.collect()
        XCTAssertEqual(sequence.count, 1)
    }

    func testBodyContentDataShouldCreateNonEmptySequence() async throws {
        let body = HTTPBody(TestData.content)
        let asyncSequence = ChatCompletionSequence(body)
        let sequence = try await asyncSequence.collect()
        XCTAssertEqual(sequence.count, 1)
    }

    func testBodyEndContentDataShouldCreateEmptySequence() async throws {
        let body = HTTPBody(TestData.end)
        let asyncSequence = ChatCompletionSequence(body)
        let sequence = try await asyncSequence.collect()
        XCTAssertTrue(sequence.isEmpty)
    }

    func testBodyFullContentDataShouldCreateNonEmptySequence() async throws {
        let body = HTTPBody(TestData.fullContent)
        let asyncSequence = ChatCompletionSequence(body)
        let sequence = try await asyncSequence.collect()
        XCTAssertEqual(sequence.count, 3)
    }
}
