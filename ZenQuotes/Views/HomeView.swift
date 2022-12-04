//
//  HomeView.swift
//  DuneQuotes
//
//  Created by Songyee Park on 2022/11/28.
//

import SwiftUI

struct HomeView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@StateObject var viewModel = HomeViewModel()
	@FetchRequest(entity: LocalQuote.entity(), sortDescriptors: []) var results : FetchedResults<LocalQuote>
	
    var body: some View {
		NavigationView {
			VStack {
				if results.isEmpty {
					if viewModel.quotes.isEmpty {
						ProgressView()
							.onAppear {
								Task { do { await viewModel.fetchQuotes(context: managedObjectContext) }}
							}
					} else {
						// Fetched from API
						List(viewModel.quotes, id: \.self) { quote in
							Text(quote.text)
						}
					}
				} else {
					// Fetched from CoreData
					List(results) { quote in
						Text(quote.text ?? "")
					}
				}
			}
			.navigationTitle(results.isEmpty ? "Fetched JSON" : "Fetched CoreData")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						do {
							results.forEach { quote in
								managedObjectContext.delete(quote)
							}
							try managedObjectContext.save()
						} catch {
							print(error.localizedDescription)
						}
						
					} label: {
						Image(systemName: "arrow.clockwise.circle")
							.font(.title)
					}

				}
			}
		}
    }
}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
