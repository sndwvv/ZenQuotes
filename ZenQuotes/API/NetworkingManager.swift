//
//  HTTPClient.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/11/29.
//

import Foundation

protocol NetworkingManagerProtocol {
	
	func fetch<T: Codable>(session: URLSession,
						   endpoint: APIEndpoint,
						   type: T.Type) async throws -> T
	
}

final class NetworkingManager: NetworkingManagerProtocol {
	
	static let shared = NetworkingManager()
	private init() {}
	
	func fetch<T: Codable>(session: URLSession = .shared,
						   endpoint: APIEndpoint,
						   type: T.Type) async throws -> T {
		guard let url = endpoint.url else {
			throw APIError.badURL
		}
		var request = URLRequest(url: url)
		request.httpMethod = endpoint.methodType.rawValue
		
		let (data, response) = try await session.data(for: request)
		
		guard let response = response as? HTTPURLResponse else {
			throw APIError.noResponse
		}
		
		let statusCode = response.statusCode
		switch statusCode {
		case 200...299:
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let decodedData = try decoder.decode(T.self, from: data)
				return decodedData // :: SUCCESS :: //
			}
		case 401:
			throw APIError.unauthorized
		default:
			throw APIError.badResponse(statusCode: statusCode)
		}
	}
	
}
