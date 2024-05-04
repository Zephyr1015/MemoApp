//
//  EditMemoView.swift
//  MemoApp
//
//  Created by Vincent on 2024/05/04.
//

import SwiftUI

struct EditMemoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation
    @State private var title: String
    @State private var content: String
    private var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
        self.title = memo.title ?? ""
        self.content = memo.content ?? ""
    }
    
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
                Button(action: {saveMemo()}) {
                    Text("保存")
                }
            }
        }
    }
    
    private func saveMemo() {
        memo.title = title
        memo.content = content
        memo.updatedAt = Date()
        
        try? viewContext.save()
        
        presentation.wrappedValue.dismiss()
    }
}

//#Preview {
//    EditMemoView(memo: Memo())
//}
