//
//  BookRepository.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

protocol BookRepository {
    func fetchAll() async throws -> [Book]
    func add(_ book: Book) async throws
    func update(_ book: Book) async throws
    func delete(_ book: Book) async throws
}
