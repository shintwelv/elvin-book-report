//
//  AddBookView.swift
//  ReadNotes
//
//  Created by ShinIl Heo on 10/2/25.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: AddBookViewModel
    
    var body: some View {
        Form {
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
    }
}
