//
//  BookDetailView.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftUI
import PhotosUI

struct BookDetailView: View {
    @StateObject var vm: BookDetailViewModel
    @State private var thoughts: String = ""
    @State private var sourceText: String = ""
    @State private var showActionSheet = false
    @State private var showSaveAlert = false
    @State private var originalAiSummary = ""
    @State private var originalMyThoughts = ""
    @State private var selectedItem: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss
    
    var hasChanges: Bool {
        vm.book.aiSummary != originalAiSummary || vm.book.myThoughts != originalMyThoughts
    }
    
    var body: some View {
        Form {
            Section("기본 정보") {
                if let coverImage = vm.book.coverImage {
                    HStack {
                        Spacer()
                        Image(uiImage: coverImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 150, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 4)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    
                    HStack {
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Label("이미지 변경", systemImage: "photo.on.rectangle")
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button(role: .destructive) {
                            vm.book.coverImage = nil
                            Task { await vm.updateBook() }
                        } label: {
                            Label("이미지 삭제", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 150, height: 200)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.secondary)
                            }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("이미지 추가", systemImage: "photo.on.rectangle.angled")
                            .frame(maxWidth: .infinity)
                    }
                }
                
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
        .navigationBarBackButtonHidden(hasChanges)
        .toolbar {
            if hasChanges {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSaveAlert = true
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showActionSheet = true
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            originalAiSummary = vm.book.aiSummary
            originalMyThoughts = vm.book.myThoughts
        }
        .alert("변경사항 저장", isPresented: $showSaveAlert) {
            Button("저장") {
                Task {
                    await vm.saveThoughts(vm.book.myThoughts)
                    originalAiSummary = vm.book.aiSummary
                    originalMyThoughts = vm.book.myThoughts
                    dismiss()
                }
            }
            Button("저장 안 함", role: .destructive) {
                dismiss()
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("변경된 내용을 저장하시겠습니까?")
        }
        .confirmationDialog("", isPresented: $showActionSheet) {
            Button("저장") {
                Task { 
                    await vm.saveThoughts(vm.book.myThoughts) 
                    originalAiSummary = vm.book.aiSummary
                    originalMyThoughts = vm.book.myThoughts
                }
            }
            Button("삭제", role: .destructive) {
                Task {
                    await vm.deleteBook()
                    dismiss()
                }
            }
            Button("취소", role: .cancel) { }
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    vm.book.coverImage = image
                    await vm.updateBook()
                }
            }
        }
    }
}
