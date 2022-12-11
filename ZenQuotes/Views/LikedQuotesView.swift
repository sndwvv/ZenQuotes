//
//  LikedQuotesView.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/11.
//

import SwiftUI

struct LikedQuotesView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(entity: LocalQuote.entity(), sortDescriptors: []) var localQuotes : FetchedResults<LocalQuote>
	
	private var likedQuotes: [LocalQuote] {
		return localQuotes.filter { $0.isLiked }
	}
	
    var body: some View {
		NavigationView {
			VStack {
				ScrollCardsView(quotes: likedQuotes)
			}
			.navigationTitle("Liked Quotes")
			.navigationBarTitleDisplayMode(.inline)
		}
    }
}

struct LikedQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        LikedQuotesView()
    }
}
