//
//  AddBookViewModel.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

@MainActor
final class AddBookViewModel: ObservableObject {
    @Published var title = ""
    @Published var author = ""
    @Published var publisher = ""
    @Published var isSaving = false
    @Published var error: AppError?
    
    let repo: BookRepository
    init(repo: BookRepository) { self.repo = repo }
    
    var canSave: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }
    
    func save() async -> Bool {
        guard canSave else { return false }
        isSaving = true; defer { isSaving = false }
        do {
            let book = Book(title: title, author: author, publisher: publisher)
            try await repo.add(book)
            return true
        } catch {
            self.error = .wrap(error)
            return false
        }
    }
}
