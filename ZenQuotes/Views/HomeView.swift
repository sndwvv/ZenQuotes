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
	
	private var unlikedQuotes: [LocalQuote] {
		return localQuotes.filter { $0.isLiked == false }
	}
	
    var body: some View {
		NavigationView {
			VStack {
				if unlikedQuotes.isEmpty {
					if viewModel.quotes.isEmpty {
						ProgressView()
							.onAppear {
								Task { do { await viewModel.fetchQuotes(context: managedObjectContext) }}
							}
					} else {
						// EMPTY VIEW
						Text("Something went wrong.")
					}
				} else {
					ScrollCardsView(quotes: unlikedQuotes)
				}
			}
			.navigationTitle(localQuotes.isEmpty ? "Fetched JSON" : "Fetched CoreData")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						do {
							unlikedQuotes.forEach { quote in
								managedObjectContext.delete(quote)
							}
							try managedObjectContext.save()
							Task { do { await viewModel.fetchQuotes(context: managedObjectContext) }}
						} catch {
							print(error.localizedDescription)
						}
						
					} label: {
						Image(systemName: "arrow.clockwise.circle")
							.font(.title3)
					}
				}
			}
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
