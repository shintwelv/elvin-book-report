//
//  AppEnvironment.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftUI
import SwiftData

@Observable
final class AppEnvironment {
    let bookRepo: BookRepository
    let summaryService: SummaryService
    
    init(bookRepo: BookRepository, summaryService: SummaryService) {
        self.bookRepo = bookRepo
        self.summaryService = summaryService
    }
    
    static func `default`(container: ModelContainer) -> AppEnvironment {
        let ctx = ModelContext(container)
        return AppEnvironment(
            bookRepo: BookRepositorySwiftData(context: ctx),
            summaryService: DummySummaryService()
        )
    }
}

private struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppEnvironment = AppEnvironment(
        bookRepo: BookRepositoryPreview(),
        summaryService: DummySummaryService()
    )
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}

extension View {
    func environment(_ env: AppEnvironment) -> some View {
        environment(\.appEnvironment, env)
    }
}
