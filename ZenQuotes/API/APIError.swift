//
//  APIError.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/11/29.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
	case invalidURL
	case invalidResponse(statusCode: Int)
	case failedToDecode(error: Error)
	case unauthorized
	case invalidData
	case noResponse
	
	var localizedDescription: String { // description for user
		return "Sorry, something went wrong. Please try again."
	}

	var description: String { // description for developer
		switch self {
		case .invalidURL:
			return "API ERROR: invalid URL"
		case .invalidResponse(let statusCode):
			return "API ERROR: bad response with status code \(statusCode)"
		case .failedToDecode(let error):
			return "API ERROR: parsing error, \(error.localizedDescription)"
		case .unauthorized:
			return "API ERROR: unauthorized"
		case .invalidData:
			return "API ERROR: invalid data"
		case .noResponse:
			return "API ERROR: HTTPURLResponse is nil"
		}
	}

}

extension APIError: Equatable {
	
	static func == (lhs: APIError, rhs: APIError) -> Bool {
		switch (lhs, rhs) {
		case (.invalidURL, .invalidURL):
			return true
		case (.invalidResponse(let lhsType), .invalidResponse(let rhsType)):
			return lhsType == rhsType
		case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
			return lhsType.localizedDescription == rhsType.localizedDescription
		case (.unauthorized, .unauthorized):
			return true
		case (.invalidData, .invalidData):
			return true
		case (.noResponse, .noResponse):
			return true
		default:
			return false
		}
	}
}
