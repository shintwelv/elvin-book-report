//
//  BookRepositorySwiftData.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftData

final class BookRepositorySwiftData: BookRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }
    
    func fetchAll() async throws -> [Book] {
        try context.fetch(FetchDescriptor<Book>(sortBy: [.init(\.createdAt, order: .reverse)]))
    }
    
    func add(_ book: Book) async throws {
        context.insert(book)
        try context.save()
    }
    
    func update(_ book: Book) async throws {
        try context.save()
    }
    
    func delete(_ book: Book) async throws {
        context.delete(book)
        try context.save()
    }
}

final class BookRepositoryPreview: BookRepository {
    var storage: [Book] = [
        Book(title: "파친코", author: "이민진", publisher: "문학사상"),
        Book(title: "칵테일, 러브, 좀비", author: "조예은", publisher: "안전가옥")
    ]
    func fetchAll() async throws -> [Book] { storage }
    func add(_ book: Book) async throws { storage.insert(book, at: 0) }
    func update(_ book: Book) async throws {}
    func delete(_ book: Book) async throws { storage.removeAll { $0.id == book.id } }
}
