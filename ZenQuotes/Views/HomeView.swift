//
//  HomeView.swift
//  DuneQuotes
//
//  Created by Songyee Park on 2022/11/28.
//

import SwiftUI

struct HomeView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(entity: LocalQuote.entity(), sortDescriptors: []) var localQuotes : FetchedResults<LocalQuote>
	@StateObject var viewModel = HomeViewModel()
	
	@State private var currentIndex: Int = 0
	
	private var unlikedQuotes: [LocalQuote] {
		return localQuotes.filter { $0.isLiked == false }
	}
	
    var body: some View {
		NavigationView {
			VStack {
				if localQuotes.isEmpty {
					ProgressView()
						.onAppear {
							fetchQuotesFromAPI()
						}
				} else {
					CarouselView(index: $currentIndex, items: unlikedQuotes, id: \.id) { quote, cardSize in
						CardView(quote: quote)
							.frame(width: cardSize.width, height: cardSize.height)
						
					}
					.padding(.vertical, 50)
					.background(Color.gray.opacity(0.25))
				}
			}
			.navigationTitle(setNavigationTitle())
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					fetchMoreButton()
				}
			}
		}
    }
	
	// MARK: ToolBar Actions
	
	private func setNavigationTitle() -> String {
		if localQuotes.isEmpty {
			return "Fetching Quotes ..."
		} else {
			return "All Quotes: \(unlikedQuotes.count)"
		}
	}
	
	private func fetchMoreButton() -> Button<Text> {
		Button {
			do {
				localQuotes.forEach { quote in
					managedObjectContext.delete(quote)
				}
				try managedObjectContext.save()
			} catch {
				print(error.localizedDescription)
			}
			
		} label: {
			Text("Delete All")
		}
	}
	
	// MARK: Fetch Quotes
	
	private func fetchQuotesFromAPI() {
		Task {
			do {
				await viewModel.fetchQuotes(context: managedObjectContext)
			}
		}
	}
	
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
