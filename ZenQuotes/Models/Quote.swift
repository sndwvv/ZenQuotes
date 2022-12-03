//
//  Quote.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/02.
//

import Foundation

struct Quote: Codable, Equatable {
	let text: String
	let author: String
	
	enum CodingKeys: String, CodingKey {
		case text = "q"
		case author = "a"
	}
}
