//
//  DummySummaryService.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

struct DummySummaryService: SummaryService {
    func summarize(_ book: BookSummaryRequest) async throws -> String {
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6s
        var lines = ["요약(더미): \(book.title) · \(book.author) · \(book.publisher)"]
        return lines.joined(separator: "\n")
    }
}
