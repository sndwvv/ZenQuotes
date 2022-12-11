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

extension Quote {
	
	static var localExample: LocalQuote {
		let quote = LocalQuote()
		quote.text = "A person hears only what they understand."
		quote.author = "Johann Wolfgang von Goethe"
		quote.htmlBlock = "<blockquote>&ldquo;A person hears only what they understand.&rdquo; &mdash; <footer>Johann Wolfgang von Goethe</footer></blockquote>"
		quote.isLiked = false 
		return quote
	}
}

