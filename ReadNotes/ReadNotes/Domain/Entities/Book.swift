//
//  Book.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation
import SwiftData
import UIKit

@Model
final class Book: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String = ""
    var author: String = ""
    var publisher: String = ""
    var myThoughts: String = ""
    var aiSummary: String = ""
    var coverImageData: Data? = nil
    var createdAt: Date = Date()
    
    var modifiedAt: Date? = nil // Optional to support existing books created before this field was added
    
    init(
        id: String = UUID().uuidString,
        title: String,
        author: String,
        publisher: String,
        myThoughts: String = "",
        aiSummary: String = "",
        coverImageData: Data? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.myThoughts = myThoughts
        self.aiSummary = aiSummary
        self.coverImageData = coverImageData
        self.createdAt = createdAt
        self.modifiedAt = createdAt
    }
    
    // Computed property for UIImage conversion
    var coverImage: UIImage? {
        get {
            guard let data = coverImageData else { return nil }
            return UIImage(data: data)
        }
        set {
            coverImageData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }
    
    var lastEdited: Date { modifiedAt ?? createdAt }
    
    func touch() { modifiedAt = Date() }
    
    static func == (lhs: Book, rhs: Book) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
