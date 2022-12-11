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
	
	init(quote: LocalQuote) {
		self.quote = quote
	}
	
    var body: some View {
		VStack {
			Text(quote.text ?? "")
				.background(Color.gray)
				.font(.title)
				.frame(maxWidth: .infinity)
				.multilineTextAlignment(.center)
				.lineSpacing(4.0)
				.padding(.bottom, 20)
			
			Text(quote.author ?? "")
				.multilineTextAlignment(.center)
				.foregroundColor(.blue)
				.font(.title3)
				.padding(.bottom, 20)
			
			HStack {
				Button {
					do {
						managedObjectContext.delete(quote)
						try managedObjectContext.save()
					} catch {
						print("failed to save")
					}
				} label: {
					Label("Delete", systemImage: "delete.left")
				}
				
				Spacer()
				
				Button {
					quote.isLiked.toggle()
					do {
						try managedObjectContext.save()
					} catch {
						print("failed to save")
					}
				} label: {
					Label(quote.isLiked ? "Liked" : "Like",
						  systemImage: quote.isLiked ? "heart.fill" : "heart")
				}
			}
			.padding()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(.horizontal, 20)
    }
	
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
		let context = PersistenceController.shared.container.viewContext
		let example = LocalQuote.init(context: context)
		example.text = "Text"
		example.author = "Author"
		example.htmlBlock = ""
		example.isLiked = true
		return CardView(quote: example)
    }
}
