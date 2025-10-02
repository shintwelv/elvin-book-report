//
//  SummaryService.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

struct BookSummaryRequest {
    let title: String
    let author: String
    let publisher: String
}

protocol SummaryService {
    func summarize(_ book: BookSummaryRequest) async throws -> String
}
