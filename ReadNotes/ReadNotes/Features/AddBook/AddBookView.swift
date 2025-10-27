//
//  AddBookView.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftUI
import PhotosUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: AddBookViewModel
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        Form {
            Section("표지 이미지") {
                HStack {
                    Spacer()
                    if let coverImage = vm.coverImage {
                        Image(uiImage: coverImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 120, maxHeight: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 4)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 160)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.secondary)
                            }
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("이미지 선택", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                }
                
                if vm.coverImage != nil {
                    Button(role: .destructive) {
                        vm.coverImage = nil
                    } label: {
                        Label("이미지 삭제", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            Section("기본 정보") {
                TextField("제목", text: $vm.title)
                TextField("저자", text: $vm.author)
                TextField("출판사", text: $vm.publisher)
            }
        }
        .navigationTitle("책 추가")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("닫기") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("저장") {
                    Task {
                        if await vm.save() { dismiss() }
                    }
                }.disabled(!vm.canSave)
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    vm.coverImage = image
                }
            }
        }
    }
}
