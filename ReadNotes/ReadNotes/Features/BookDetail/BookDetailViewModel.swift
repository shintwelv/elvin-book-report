//
//  BookDetailVewiModel.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import UIKit

@MainActor
final class BookDetailViewModel: ObservableObject {
    let title: String
    let author: String
    let publisher: String
    @Published var aiSummary: String
    @Published var myThoughts: String
    @Published var coverImage: UIImage?
    @Published var isSummarizing = false
    @Published var error: AppError?
    
    private var book: Book
    private let repo: BookRepository
    private let summaryService: SummaryService
    
    init(repo: BookRepository, summaryService: SummaryService, book: Book) {
        self.repo = repo
        self.summaryService = summaryService
        self.book = book
        
        // Initialize published properties
        self.title = book.title
        self.author = book.author
        self.publisher = book.publisher
        self.aiSummary = book.aiSummary
        self.myThoughts = book.myThoughts
        self.coverImage = book.coverImage
    }
    
    func saveChanges() async {
        book.aiSummary = aiSummary
        book.myThoughts = myThoughts
        book.touch()
        do { try await repo.update(book) } catch { self.error = .wrap(error) }
    }
    
    func makeSummary(from text: String) async {
        isSummarizing = true; defer { isSummarizing = false }
        do {
            let request = BookSummaryRequest(
                title: title,
                author: author,
                publisher: publisher
            )
            let s = try await summaryService.summarize(request)
            aiSummary = s
            book.aiSummary = s
            book.touch()
            try await repo.update(book)
        } catch { self.error = .wrap(error) }
    }
    
    func deleteBook() async {
        do { try await repo.delete(book) } catch { self.error = .wrap(error) }
    }
    
    func updateCoverImage(_ image: UIImage?) async {
        coverImage = image
        book.coverImage = image
        book.touch()
        do { try await repo.update(book) } catch { self.error = .wrap(error) }
    }
    
    func deleteCoverImage() async {
        coverImage = nil
        book.coverImage = nil
        book.touch()
        do { try await repo.update(book) } catch { self.error = .wrap(error) }
    }
}
