//
//  Book.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation
import SwiftData

@Model
final class Book: Identifiable, Hashable {
    @Attribute(.unique) var id: String
    var title: String
    var author: String
    var publisher: String
    var myThoughts: String
    var aiSummary: String
    var createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        title: String,
        author: String,
        publisher: String,
        myThoughts: String = "",
        aiSummary: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.myThoughts = myThoughts
        self.aiSummary = aiSummary
        self.createdAt = createdAt
    }
}
