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
            RootView()
                .environment(\.appEnvironment, env)
                .modelContainer(container)
        }
    }
}

struct RootView: View {
    @Environment(\.appEnvironment) private var env
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            BookListView(vm: .init(repo: env.bookRepo))
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(vm: .init(repo: env.bookRepo, summaryService: env.summaryService, book: book))
                }
                .toolbarTitleDisplayMode(.large)
        }
    }
}
