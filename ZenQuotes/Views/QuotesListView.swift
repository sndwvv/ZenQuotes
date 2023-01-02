//
//  QuotesListView.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/08.
//

import SwiftUI

struct QuotesListView: View {
	
	var quotes: [LocalQuote]
	
    var body: some View {
		List {
			ForEach(quotes, id: \.self) { quote in
				Text(quote.text ?? "")
			}
		}
    }
}

struct QuotesListView_Previews: PreviewProvider {
    static var previews: some View {
		let quotes = [Quote.localExample]
		QuotesListView(quotes: quotes)
    }
}
