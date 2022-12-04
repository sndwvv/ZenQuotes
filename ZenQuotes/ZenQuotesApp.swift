//
//  ZenQuotesApp.swift
//  DuneQuotes
//
//  Created by Songyee Park on 2022/11/28.
//

import SwiftUI

@main
struct ZenQuotesApp: App {
	
	let persistenceController = PersistenceController.shared
	@Environment(\.scenePhase) var scenePhase
	
    var body: some Scene {
        WindowGroup {
            HomeView()
				.environment(\.managedObjectContext,
							  persistenceController.container.viewContext)
        }
		.onChange(of: scenePhase) { newScenePhase in
			switch newScenePhase {
			case .background:
				print("Scene is in background")
				persistenceController.save()
			case .inactive:
				print("Scene is inactive")
			case .active:
				print("Scene is active")
			@unknown default:
				print("Scene is unknown default")
			}
		}
    }
	
}
