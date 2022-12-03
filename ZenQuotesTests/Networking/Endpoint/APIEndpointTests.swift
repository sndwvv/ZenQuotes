//
//  APIEndpointTests.swift
//  ZenQuotesTests
//
//  Created by Songyee Park on 2022/12/03.
//

import XCTest
@testable import ZenQuotes

final class APIEndpointTests: XCTestCase {

	func test_quote_today_endpoint_request_is_valid() {
		let endpoint = APIEndpoint.quoteToday
		XCTAssertEqual(endpoint.host, "zenquotes.io", "Host should be zenquotes.io")
		XCTAssertEqual(endpoint.path, "/api/today", "Path should be /api/today")
		XCTAssertEqual(endpoint.methodType, .GET, "Method should be GET")
		XCTAssertNil(endpoint.queryItems, "Query items should be nil")
		XCTAssertEqual(endpoint.url?.absoluteString, "https://zenquotes.io/api/today?")
	}
	
	func test_quotes_endpoint_request_is_valid() {
		let endpoint = APIEndpoint.quotes
		XCTAssertEqual(endpoint.host, "zenquotes.io", "Host should be zenquotes.io")
		XCTAssertEqual(endpoint.path, "/api/quotes", "Path should be /api/quotes")
		XCTAssertEqual(endpoint.methodType, .GET, "Method should be GET")
		XCTAssertNil(endpoint.queryItems, "Query items should be nil")
		XCTAssertEqual(endpoint.url?.absoluteString, "https://zenquotes.io/api/quotes?")
	}

}
