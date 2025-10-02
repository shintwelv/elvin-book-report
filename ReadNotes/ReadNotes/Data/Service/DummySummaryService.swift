//
//  DummySummaryService.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

struct DummySummaryService: SummaryService {
    func summarize(_ text: String) async throws -> String {
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6s
        return "요약(더미): \(text.prefix(140))..."
    }
}
