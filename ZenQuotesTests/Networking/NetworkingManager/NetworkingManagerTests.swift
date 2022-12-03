//
//  NetworkingManagerTests.swift
//  ZenQuotesTests
//
//  Created by Songyee Park on 2022/12/03.
//

import XCTest
@testable import ZenQuotes

final class NetworkingManagerTests: XCTestCase {

	private var session: URLSession!
	private var url: URL!
	
	override func setUp() {
		url = URL(string: "https://zenquotes.io/api/quotes?")
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLSessionProtocol.self]
		session = URLSession(configuration: config)
		
	}
	
	override func tearDown() {
		session = nil
		url = nil
	}
	
	func test_with_successful_response() async throws {
		guard let path = Bundle.main.path(forResource: "Quotes", ofType: "json"),
			  let data = FileManager.default.contents(atPath: path) else {
			XCTFail("Failed to get Quotes.json file")
			return
		}
		MockURLSessionProtocol.loadingHandler = {
			let response = HTTPURLResponse(url: self.url,
										   statusCode: 200,
										   httpVersion: nil,
										   headerFields: nil)
			return (response!, data)
		}
		
		let quotes = try await NetworkingManager.shared.fetch(session: session,
													 endpoint: .quotes,
													 type: [Quote].self)
		
		let json = try StaticJSONMapper.decode(file: "Quotes", type: [Quote].self)
		XCTAssertEqual(quotes, json, "Returned response matches expected JSON format")
	}
	
	func test_with_failed_response_invalid_status_code_error() async {
		let invalidStatusCode = 400
		
		MockURLSessionProtocol.loadingHandler = {
			let response = HTTPURLResponse(url: self.url,
										   statusCode: invalidStatusCode,
										   httpVersion: nil,
										   headerFields: nil)
			return (response!, nil)
		}
		do {
			_ = try await NetworkingManager.shared.fetch(session: session,
														 endpoint: .quotes,
														 type: [Quote].self)
		} catch {
			guard let networkingError = error as? APIError else {
				XCTFail("Got the wrong type of error, expecting APIError")
				return
			}
			XCTAssertEqual(networkingError, APIError.badResponse(statusCode: invalidStatusCode), "Returned error with status code \(invalidStatusCode)")
		}
	}
	
	func test_with_failed_response_parsing_error() async {
		guard let path = Bundle.main.path(forResource: "Quotes", ofType: "json"),
			  let data = FileManager.default.contents(atPath: path) else {
			XCTFail("Failed to get Quotes.json file")
			return
		}
		MockURLSessionProtocol.loadingHandler = {
			let response = HTTPURLResponse(url: self.url,
										   statusCode: 200,
										   httpVersion: nil,
										   headerFields: nil)
			return (response!, data)
		}
		do {
			let wrongTypeToParse = Quote.self // correct type is [Quote].self
			_ = try await NetworkingManager.shared.fetch(session: session,
														 endpoint: .quotes,
														 type: wrongTypeToParse)
			XCTFail("Expected to fail when type mismatch")
		} catch {
			guard let _ = error as? DecodingError else {
				XCTFail("Got the wrong type of error, expecting DecodingError")
				return
			}
			XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
		}
	}
	
	func test_with_failed_response_unauthorized_error() async {
		let unauthorizedStatusCode = 401
		
		MockURLSessionProtocol.loadingHandler = {
			let response = HTTPURLResponse(url: self.url,
										   statusCode: unauthorizedStatusCode,
										   httpVersion: nil,
										   headerFields: nil)
			return (response!, nil)
		}
		do {
			_ = try await NetworkingManager.shared.fetch(session: session,
														 endpoint: .quotes,
														 type: [Quote].self)
		} catch {
			guard let networkingError = error as? APIError else {
				XCTFail("Got the wrong type of error, expecting APIError")
				return
			}
			XCTAssertEqual(networkingError, APIError.unauthorized, "Returned error with status code \(unauthorizedStatusCode)")
		}
	}
	
}
