//
//  DeleteBook.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

struct DeleteBook {
    let repo: BookRepository
    func callAsFUnction(_ book: Book) async throws {
        try await repo.delete(book)
    }
}
