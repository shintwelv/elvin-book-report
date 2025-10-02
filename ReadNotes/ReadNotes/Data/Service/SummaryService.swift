//
//  SummaryService.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

protocol SummaryService {
    func summarize(_ text: String) async throws -> String
}
