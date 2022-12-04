//
//  PersistenceController.swift
//  ZenQuotes
//
//  Created by Songyee Park on 2022/12/03.
//

import CoreData
import SwiftUI

struct PersistenceController {

	static let shared = PersistenceController()
	
	let container: NSPersistentContainer
	
	init() {
		container = NSPersistentContainer(name: "Storage")
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Error: \(error.localizedDescription)")
			}
		}
	}
	
	func save(completion: @escaping (Error?) -> () = { _ in }) {
		let context = container.viewContext
		if context.hasChanges {
			do {
				try context.save()
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
	
}
