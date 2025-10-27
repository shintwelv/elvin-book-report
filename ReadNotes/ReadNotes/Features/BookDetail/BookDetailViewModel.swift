//
//  BookDetailVewiModel.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

@MainActor
final class BookDetailViewModel: ObservableObject {
    @Published var book: Book
    @Published var isSummarizing = false
    @Published var error: AppError?
    
    private let repo: BookRepository
    private let summaryService: SummaryService
    
    init(repo: BookRepository, summaryService: SummaryService, book: Book) {
        self.repo = repo
        self.summaryService = summaryService
        self.book = book
    }
    
    func saveThoughts(_ text: String) async {
        book.myThoughts = text
        do { try await repo.update(book) } catch { self.error = .wrap(error) }
    }
    
    func makeSummary(from text: String) async {
        isSummarizing = true; defer { isSummarizing = false }
        do {
            let request = BookSummaryRequest(
                title: book.title,
                author: book.author,
                publisher: book.publisher
            )
            let s = try await summaryService.summarize(request)
            book.aiSummary = s
            try await repo.update(book)
        } catch { self.error = .wrap(error) }
    }
    
    func deleteBook() async {
        do { try await repo.delete(book) } catch { self.error = .wrap(error) }
    }
    
    func updateBook() async {
        do { try await repo.update(book) } catch { self.error = .wrap(error) }
    }
}
