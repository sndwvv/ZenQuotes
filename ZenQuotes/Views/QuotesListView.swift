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
		ScrollView(.vertical) {
			ForEach(quotes, id: \.self) { quote in
				CardView(quote: quote)
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
