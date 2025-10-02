//
//  ReadNotesApp.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftUI
import SwiftData

@main
struct ReadNotesApp: App {
    @State private var container: ModelContainer = {
        let schema = Schema([Book.self])
        let config = ModelConfiguration()
        return try! ModelContainer(for: schema, configurations: config)
    }()

    var body: some Scene {
        WindowGroup {
            let env = AppEnvironment.default(container: container)
            ContentView()
                .environment(\.appEnvironment, env)
                .modelContainer(container)
        }
    }
}
