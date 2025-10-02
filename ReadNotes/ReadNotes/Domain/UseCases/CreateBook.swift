//
//  CreateBook.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

struct CreateBook {
    let repo: BookRepository
    func callAsFunction(_ book: Book) async throws {
        try await repo.add(book)
    }
}
