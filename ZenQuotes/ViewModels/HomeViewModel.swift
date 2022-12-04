//
//  HomeViewModel.swift
//  DuneQuotes
//
//  Created by Songyee Park on 2022/12/02.
//

import Foundation
import CoreData

final class HomeViewModel: ObservableObject {
	
	private let networkingManager: NetworkingManagerProtocol
	
	@Published var fetchState: APIFetchState = .loading
	// @Published var quoteText: String?
	@Published var quotes: [Quote] = []
	
	init(networkingManager: NetworkingManagerProtocol = NetworkingManager.shared) {
		self.networkingManager = networkingManager
	}
	
	func fetchQuotes(context: NSManagedObjectContext) async {
		do {
			let quotes: [Quote] = try await networkingManager.fetch(session: .shared,
														   endpoint: .quotes,
														   type: [Quote].self)
//			guard let quote = quotes.first else {
//				updateFetchState(state: .empty)
//				return
//			}
//			updateQuoteText(text: quote.text)
			updateQuotes(quotes: quotes)
			updateFetchState(state: .loaded)
			saveQuotesData(quotes: quotes, context: context)
		} catch {
			updateFetchState(state: .error(error.localizedDescription))
		}
	}
	
	private func updateFetchState(state: APIFetchState) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.fetchState = state
		}
	}
	
	private func updateQuotes(quotes: [Quote]) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.quotes = quotes
		}
	}
	
//	private func updateQuoteText(text: String) {
//		DispatchQueue.main.async { [weak self] in
//			guard let self = self else { return }
//			self.quoteText = text
//		}
//	}
	
	
	// MARK: - Save to Core Data
	
	private func saveQuotesData(quotes: [Quote], context: NSManagedObjectContext) {
		DispatchQueue.main.async {
			quotes.forEach { quote in
				let entity = LocalQuote(context: context)
				entity.text = quote.text
				entity.author = quote.author
				entity.htmlBlock = quote.htmlBlock
			}
			do {
				try context.save()
				print("SUCCESS: saved quotes to core data")
			} catch {
				print(error.localizedDescription)
			}
		}
	}
	
}
