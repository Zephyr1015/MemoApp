//
//  AddMemoView.swift
//  MemoApp
//
//  Created by Vincent on 2024/05/04.
//

import SwiftUI

struct AddMemoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        VStack {
            TextField("タイトル", text: $title)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .font(.title)
            TextEditor(text: $content)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .font(.body)
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {addMemo()}) {
                    Text("保存")
                }
            }
        }
    }
    // 保存ボタン押下時の処理
    private func addMemo() {
        let memo = Memo(context: viewContext)
        memo.title = title
        memo.content = content
        memo.createdAt = Date()
        memo.updatedAt = Date()
    // 生成したインスタンスをCoreDataに保存する
        try? viewContext.save()
    
        presentation.wrappedValue.dismiss()
    }
}

#Preview {
    AddMemoView()
}
