//
//  APIError.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/11/29.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
	case badURL
	case noResponse
	case badResponse(statusCode: Int)
	case urlSession(URLError?)
	case parsing(DecodingError?)
	case unauthorized
	case noData
	case unknown
	
	var localizedDescription: String { // description for user
		return "Sorry, something went wrong. Please try again."
	}

	var description: String { // description for developer
		switch self {
		case .unknown:
			return "API ERROR: unknown error"
		case .badURL:
			return "API ERROR: invalid URL"
		case .urlSession(let error):
			return "API ERROR: \(error?.localizedDescription ?? "url session error")"
		case .noResponse:
			return "API ERROR: no response"
		case .badResponse(let statusCode):
			return "API ERROR: bad response with status code \(statusCode)"
		case .parsing(let error):
			return "API ERROR: parsing error, \(error.debugDescription)"
		case .unauthorized:
			return "API ERROR: unauthorized"
		case .noData:
			return "API ERROR: data returned nil"
		}
	}
	

}

extension APIError: Equatable {
	
	static func == (lhs: APIError, rhs: APIError) -> Bool {
		switch (lhs, rhs) {
		case (.badURL, .badURL):
			return true
		case (.noResponse, .noResponse):
			return true
		case (.badResponse(let lhsType), .badResponse(let rhsType)):
			return lhsType == rhsType
		case (.urlSession(let lhsType), .urlSession(let rhsType)):
			return lhsType?.localizedDescription == rhsType?.localizedDescription
		case (.parsing(let lhsType), .parsing(let rhsType)):
			return lhsType.debugDescription == rhsType.debugDescription
		case (.unauthorized, .unauthorized):
			return true
		case (.noData, .noData):
			return true
		case (.unknown, .unknown):
			return true
		default:
			return false
		}
	}
}
