//
//  APIEndpoint.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/02.
//

import Foundation

enum APIEndpoint {
	case quoteToday
	case quotes
}

extension APIEndpoint {
	
	var host: String {
		return "zenquotes.io"
	}
	
	var path: String {
		switch self {
		case .quoteToday:
			return "/api/today"
		case .quotes:
			return "/api/quotes" // returns 50
		}
	}
	
	var methodType: APIMethodType {
		switch self {
		default:
			return .GET
		}
	}
	
	var queryItems: [String: String]? {
		switch self {
		default:
			return nil
		}
	}
}

extension APIEndpoint {
	
	var url: URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = host
		urlComponents.path = path
		
		var requestQueryItems = [URLQueryItem]()
		queryItems?.forEach { item in
			requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
		}
		urlComponents.queryItems = requestQueryItems
		
		return urlComponents.url
	}
	
}

enum APIMethodType: String {
	case POST, GET, PUT, DELETE
}

enum MIMEType: String {
	case JSON = "application/json"
}

enum HTTPHeaders: String {
	case contentType = "Content-Type"
}
