//
//  APIFetchState.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/03.
//

enum APIFetchState {
	case loading
	case loaded
	case empty
	case error(String)
}
