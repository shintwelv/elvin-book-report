//
//  BookListViewModel.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

@MainActor
final class BookListViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var isLoading = false
    @Published var error: AppError?
    
    private let repo: BookRepository
    
    init(repo: BookRepository) { self.repo = repo }
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        do { books = try await repo.fetchAll() }
        catch { self.error = .wrap(error) }
    }
}
