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
        let config = ModelConfiguration(cloudKitDatabase: .automatic)
        let container = try! ModelContainer(for: schema, configurations: config)
        
        // Backfill modifiedAt for existing books if needed
        backfillModifiedDateIfNeeded(container: container)
        
        return container
    }()

    var body: some Scene {
        WindowGroup {
            let env = AppEnvironment.default(container: container)
            RootView()
                .environment(\.appEnvironment, env)
                .modelContainer(container)
        }
    }
    
    static func backfillModifiedDateIfNeeded(container: ModelContainer) {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<Book>(
            predicate: #Predicate { $0.modifiedAt == nil }
        )
        do {
            let needsBackfill = try context.fetch(descriptor)
            guard !needsBackfill.isEmpty else { return }
            
            for book in needsBackfill {
                book.modifiedAt = book.createdAt
            }
            do {
                try context.save()
            } catch {
                print("Error saving context during backfill: \(error)")
            }
        } catch {
            print("Error fetching books needing backfill: \(error)")
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
