//
//  EmptyStateView.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "books.vertical")
                .font(.system(size: 44))
                .padding(.bottom, 8)
            Text(title).font(.title3).bold()
            Text(message).font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
