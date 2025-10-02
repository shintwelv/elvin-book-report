//
//  BookListView.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftUI

struct BookListView: View {
    @StateObject var vm: BookListViewModel
    @State private var showingAdd = false
    @Environment(\.appEnvironment) private var env
    
    var body: some View {
        Group {
            if vm.books.isEmpty {
                EmptyStateView(
                    title: "기록한 책이 없습니다",
                    message: "+ 버튼으로 첫 책을 추가해보세요"
                )
            } else {
                List(vm.books, id: \.id) { book in
                    NavigationLink(value: book) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.title).font(.headline)
                            Text("\(book.author) · \(book.publisher)")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .overlay { if vm.isLoading { ProgressView() } }
        .onAppear { Task { await vm.load() } }
        .navigationTitle("내 책장")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showingAdd) {
            NavigationStack {
                AddBookView(vm: .init(repo: env.bookRepo))
            }
            .presentationDetents([.medium, .large])
        }
        .onChange(of: showingAdd, initial: false) { _, isPresented in
            guard !isPresented else { return }
            Task { await vm.load() }
        }
    }
}
