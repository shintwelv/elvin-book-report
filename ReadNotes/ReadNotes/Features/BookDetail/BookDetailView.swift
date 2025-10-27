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
    @State private var showActionSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("기본 정보") {
                Text(vm.book.title).font(.headline)
                Text("\(vm.book.author) · \(vm.book.publisher)")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Section("책 내용") {
                if vm.isSummarizing { ProgressView() }
                TextEditor(text: Binding(get: { vm.book.aiSummary }, set: { vm.book.aiSummary = $0 }))
                    .frame(minHeight: 200)
//                Button("요약 생성") { Task { await vm.makeSummary(from: sourceText.isEmpty ? vm.book.myThoughts : sourceText) } }
            }
            Section("내 생각") {
                TextEditor(text: Binding(get: { vm.book.myThoughts }, set: { vm.book.myThoughts = $0 }))
                    .frame(minHeight: 200)
            }
        }
        .navigationTitle("상세")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showActionSheet = true
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .confirmationDialog("", isPresented: $showActionSheet) {
            Button("저장") {
                Task { await vm.saveThoughts(vm.book.myThoughts) }
            }
            Button("삭제", role: .destructive) {
                Task {
                    await vm.deleteBook()
                    dismiss()
                }
            }
            Button("취소", role: .cancel) { }
        }
    }
}