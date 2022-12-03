//
//  HomeViewModel.swift
//  DuneQuotes
//
//  Created by Songyee Park on 2022/12/02.
//

import Foundation

final class HomeViewModel: ObservableObject {
	
	private let networkingManager: NetworkingManagerProtocol
	
	@Published var fetchState: APIFetchState = .loading
	@Published var quoteText: String?
	
	init(networkingManager: NetworkingManagerProtocol = NetworkingManager.shared) {
		self.networkingManager = networkingManager
	}
	
	func fetchRandomQuote() async {
		do {
			let quotes: [Quote] = try await networkingManager.fetch(session: .shared,
														   endpoint: .quotes,
														   type: [Quote].self)
			guard let quote = quotes.first else {
				updateFetchState(state: .empty)
				return
			}
			updateQuoteText(text: quote.text)
			updateFetchState(state: .loaded)
		} catch {
			updateFetchState(state: .error(error.localizedDescription))
		}
	}
	
	private func updateFetchState(state: APIFetchState) {
		DispatchQueue.main.async {
			self.fetchState = state
		}
	}
	
	private func updateQuoteText(text: String) {
		DispatchQueue.main.async {
			self.quoteText = text
		}
	}
	
}
