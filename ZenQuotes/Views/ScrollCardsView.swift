//
//  ScrollCardsView.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/05.
//

import SwiftUI

struct ScrollCardsView: View {
	
	var quotes: [LocalQuote] = []

	init(quotes: [LocalQuote]) {
		self.quotes = quotes
	}
	
	@State var offset = CGFloat.zero
	
    var body: some View {
		return GeometryReader { geometry in
			ZStack {
				ScrollView(.horizontal) {
					HStack(spacing: 0) {
						ForEach(quotes, id: \.self) { quote in
							CardView(quote: quote)
						}
						.frame(width: geometry.size.width, height: geometry.size.height)
					}
				}
				VStack {
					Spacer()
					Text("Count: \(quotes.count)")
				}
			}
		}
		.onAppear {
			UIScrollView.appearance().isPagingEnabled = true
		}
    }
	
}

struct ScrollCardsView_Previews: PreviewProvider {
    static var previews: some View {
		ScrollCardsView(quotes: [])
    }
}
