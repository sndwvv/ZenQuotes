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
			VStack(alignment: .leading) {
				HStack {
					Text("\"")
						.font(.system(size: 50))
						.foregroundColor(.white)
						.padding(.horizontal)
						// .background(Color.gray)
						.multilineTextAlignment(.leading)
						
					Spacer()
				}
				
				Text(quote.text ?? "")
					.font(.title)
					.frame(maxWidth: .infinity)
					.multilineTextAlignment(.leading)
					.lineSpacing(4.0)
					.padding(.horizontal)
					.padding(.bottom, 20)
					
				Text(quote.author ?? "")
					.font(.callout)
					.frame(maxWidth: .infinity)
					.multilineTextAlignment(.leading)
					.foregroundColor(.blue)
					.padding(.bottom, 20)
			}
			.frame(maxWidth: .infinity)

			
			HStack {
				
				Spacer()
				
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
				.padding(12)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.blue, lineWidth: 1)
				)
				
				
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
				.padding(12)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.blue, lineWidth: 1)
				)
				
				
				Spacer()
			}
			.padding()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.gray)
		.padding(20)
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


