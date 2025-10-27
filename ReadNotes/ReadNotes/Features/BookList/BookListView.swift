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
                ScrollView {
                    VStack {
                        EmptyStateView(
                            title: "기록한 책이 없습니다",
                            message: "+ 버튼으로 첫 책을 추가해보세요"
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 16)
                        .padding(.top, 48)
                    }
                    .frame(maxWidth: .infinity)
                }
                .refreshable { await vm.load() }
            } else {
                List(vm.books, id: \.id) { book in
                    NavigationLink(value: book) {
                        HStack(spacing: 12) {
                            if let coverImage = book.coverImage {
                                Image(uiImage: coverImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            } else {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 70)
                                    .overlay {
                                        Image(systemName: "book.closed")
                                            .foregroundStyle(.secondary)
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(book.title).font(.headline)
                                Text("\(book.author) · \(book.publisher)")
                                    .font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .refreshable { await vm.load() }
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
