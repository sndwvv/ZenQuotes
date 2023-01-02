//
//  CardView.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/05.
//

import SwiftUI

struct CardView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	
	private var quote: LocalQuote
	
	@State private var showingDeleteAlert: Bool = false

	init(quote: LocalQuote) {
		self.quote = quote
		
	}

	var body: some View {
		VStack {
			
			// MARK: Quote Text
			
			VStack(alignment: .leading) {
				HStack {
//					Text("\(index)")
//						.font(.system(size: 50))
//						.foregroundColor(.white)
//						.padding(.horizontal)
//						.multilineTextAlignment(.leading)
//
//					Spacer()
				}

				Text(quote.text ?? "")
					.font(.title)
					.frame(maxWidth: .infinity)
					.multilineTextAlignment(.leading)
					.lineSpacing(4.0)
					.padding(.horizontal)
					.padding(.bottom, 20)
					.foregroundColor(.white)

				Text(quote.author ?? "")
					.font(.callout)
					.frame(maxWidth: .infinity)
					.multilineTextAlignment(.leading)
					.foregroundColor(.blue)
					.padding(.bottom, 20)
			}
			.frame(maxWidth: .infinity)

			
			// MARK: Action Buttons 

			HStack {
				Spacer()

				Button {
					showingDeleteAlert = true
				} label: {
					// Image(systemName: "trash")
					Label("Delete", systemImage: "trash")
				}
				.alert(isPresented: $showingDeleteAlert) {
					deleteConfirmationAlert()
				}
				.foregroundColor(.blue)
				.padding(12)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.blue, lineWidth: 1)
				)

				Spacer()

				Button {
					quote.isLiked.toggle()
					saveQuoteToLikes()
				} label: {
					Label(quote.isLiked ? "Liked" : "Like",
						  systemImage: quote.isLiked ? "heart.fill" : "heart")
				}
				.foregroundColor(.red)
				.padding(12)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.red, lineWidth: 1)
				)

				Spacer()
			}
			.padding()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.cardBackground)
		.cornerRadius(10)
		.shadow(radius: 10)
	}
	
	// MARK: - Main Actions
	
	private func deleteConfirmationAlert() -> Alert {
		let deleteAction = Alert.Button.destructive(Text("Delete")) {
			do {
				managedObjectContext.delete(quote)
				try managedObjectContext.save()
			} catch {
				print("failed to save")
			}
		}
		return Alert(
			title: Text("Delete Quote"),
			message: Text("Are you sure you want to delete this quote?"),
			primaryButton: deleteAction,
			secondaryButton: .cancel()
		)
	}
	
	private func saveQuoteToLikes() {
		do {
			try managedObjectContext.save()
		} catch {
			print("failed to save")
		}
	}

}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
		let context = PersistenceController.shared.container.viewContext
		let example = LocalQuote.init(context: context)
		example.text = "The nearer a man comes to a calm mind, the closer he is to strength."
		example.author = "Marcus Aurelius"
		example.htmlBlock = ""
		example.isLiked = true
		return CardView(quote: example)
    }
}


