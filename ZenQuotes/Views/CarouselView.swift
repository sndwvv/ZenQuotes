//
//  CarouselView.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2023/01/02.
//

import SwiftUI

struct CarouselView<Content: View, Item, ID>: View where Item: RandomAccessCollection, ID: Hashable, Item.Element: Equatable {
	
	var content: (Item.Element, CGSize) -> Content
	var id: KeyPath<Item.Element, ID>
	
	var spacing: CGFloat
	var cardPadding: CGFloat
	var items: Item
	
	@Binding var index: Int
	
	init(index: Binding<Int>,
		 items: Item,
		 spacing: CGFloat = 30,
		 cardPadding: CGFloat = 80,
		 id: KeyPath<Item.Element, ID>,
		 @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content
	) {
		self.content = content
		self.id = id
		self._index = index
		self.spacing = spacing
		self.cardPadding = cardPadding
		self.items = items
	}
	
	// MARK: Gesture Properties
	
	@GestureState var translation: CGFloat = 0
	@State var offset: CGFloat = 0
	@State var lastStoredOffset: CGFloat = 0
	@State var currentIndex: Int = 0
	
	// MARK: Rotation
	
	@State var rotation: Double = 0
	
    var body: some View {
		GeometryReader { proxy in
			let size = proxy.size
			let cardWidth = size.width - (cardPadding - spacing)
			
			LazyHStack(spacing: spacing) {
				ForEach(items, id: id) { card in
					ZStack(alignment: .bottomTrailing) {
						let index = indexOf(item: card)
						content(card, CGSize(width: size.width - cardPadding, height: size.height))
							.rotationEffect(.degrees(Double(index) * 5), anchor: .bottom)
							.rotationEffect(.degrees(rotation), anchor: .bottom)
							.frame(width: size.width - cardPadding, height: size.height)
						
						Text("\(index + 1)")
							.foregroundColor(.white)
							.padding([.bottom, .trailing], 20)
							.font(.title3)
					}
				}
			}
			.padding(.horizontal, spacing)
			.offset(x: limitScroll())
			.contentShape(Rectangle())
			.gesture(
				DragGesture(minimumDistance: 5)
					.updating($translation, body: { value, out, _ in
						out = value.translation.width
					})
					.onChanged { onChanged(value: $0, cardWidth: cardWidth) }
					.onEnded { onEnded(value: $0, cardWidth: cardWidth) }
			)
		}
//		.onAppear {
//			let extraSpace = (cardPadding / 2) - spacing
//			offset = extraSpace
//			lastStoredOffset = extraSpace
//		}
		.animation(.easeInOut, value: translation == 0)
    }
	
	// MARK: Item Index
	private func indexOf(item: Item.Element) -> Int {
		let array = Array(items)
		if let index = array.firstIndex(of: item) {
			return index
		}
		return 0
	}
	
	// MARK: Limiting Scroll On First and Last Items
	private func limitScroll() -> CGFloat {
		let extraSpace = (cardPadding / 2) - spacing
		if index == 0 && offset > extraSpace {
			return extraSpace + (offset / 4)
		} else if index == items.count - 1 && translation < 0 {
			return offset - (translation / 2)
		} else {
			return offset
		}
	}
	
	// MARK: - Drag Gesture

	private func onChanged(value: DragGesture.Value, cardWidth: CGFloat) {
		let translationX = value.translation.width
		offset = translationX + lastStoredOffset
		
		let progress = offset / cardWidth
		rotation = progress * 5
	}
	
	private func onEnded(value: DragGesture.Value, cardWidth: CGFloat) {
		var _index = (offset / cardWidth).rounded()
		_index = max(-CGFloat(items.count - 1), _index)
		_index = min(_index, 0)
		currentIndex = Int(_index)
		print("current index: \(currentIndex)")
		index = -currentIndex
		
		withAnimation(.easeInOut(duration: 0.25)) {
			let extraSpace = (cardPadding / 2) - spacing
			offset = (cardWidth * _index) + extraSpace
			
			let progress = offset / cardWidth
			rotation = (progress * 5).rounded()
		}
		lastStoredOffset = offset
	}
	
}
