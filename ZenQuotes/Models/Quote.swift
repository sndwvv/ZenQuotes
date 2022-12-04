//
//  Quote.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/02.
//

import Foundation

struct Quote: Codable, Equatable, Hashable {
	let text: String
	let author: String
	let htmlBlock: String
	
	enum CodingKeys: String, CodingKey {
		case text = "q"
		case author = "a"
		case htmlBlock = "h"
	}
}
