//
//  AppError.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import Foundation

enum AppError: LocalizedError, Identifiable {
    case message(String)
    case underlying(Error)
    
    var id: String { localizedDescription }
    
    var errorDescription: String? {
        switch self {
        case .message(let m): return m
        case .underlying(let e): return e.localizedDescription
        }
    }
    
    static func wrap(_ error: Error) -> AppError { .underlying(error) }
}
