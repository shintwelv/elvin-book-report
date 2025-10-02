//
//  BookDetailView.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var vm: BookDetailViewModel
    @State private var thoughts: String = ""
    @State private var sourceText: String = ""
    
    var body: some View {
        Form {
            Section("기본 정보") {
                Text(vm.book.title).font(.headline)
                Text("\(vm.book.author) · \(vm.book.publisher)")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Section("AI 요약") {
                if vm.isSummarizing { ProgressView() }
                TextEditor(text: Binding(get: { vm.book.aiSummary }, set: { vm.book.aiSummary = $0 }))
                    .frame(minHeight: 120)
                TextField("요약할 원문(선택)", text: $sourceText, axis: .vertical)
                Button("요약 생성") { Task { await vm.makeSummary(from: sourceText.isEmpty ? vm.book.myThoughts : sourceText) } }
            }
            Section("내 생각") {
                TextEditor(text: Binding(get: { vm.book.myThoughts }, set: { vm.book.myThoughts = $0 }))
                    .frame(minHeight: 120)
                Button("저장") { Task { await vm.saveThoughts(vm.book.myThoughts) } }
            }
        }
        .navigationTitle("상세")
    }
}
