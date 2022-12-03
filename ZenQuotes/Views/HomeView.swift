//
//  HomeView.swift
//  DuneQuotes
//
//  Created by Songyee Park on 2022/11/28.
//

import SwiftUI

struct HomeView: View {
	
	@StateObject var viewModel = HomeViewModel()
	
    var body: some View {
		NavigationView {
			VStack {
				switch viewModel.fetchState {
				case .error(let errorMessage):
					Text("Error: \(errorMessage)")
				case .empty:
					Text("Empty")
				case .loaded:
					Text("Quote: \(viewModel.quoteText ?? "")")
				case .loading:
					Text("Loading...")
				}
			}
			.navigationTitle("Home")
		}
		.onAppear {
			Task {
				do {
					await viewModel.fetchRandomQuote()
				}
			}
		}
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
