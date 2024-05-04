//
//  ContentView.swift
//  MemoApp
//
//  Created by Vincent on 2024/05/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Memo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)],
        animation: .default
    ) var fetchedMemoList: FetchedResults<Memo>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fetchedMemoList) { memo in
                    // VStackをNavigationLinkで囲み、遷移先を指定する
                    NavigationLink(destination: EditMemoView(memo: memo)) {
                        VStack {
                            Text(memo.title ?? "")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .lineLimit(1)
                            HStack {
                                Text(memo.stringUpdatedAt)
                                    .font(.caption)
                                    .lineLimit(1)
                                Text(memo.content ?? "")
                                    .font(.caption)
                                    .lineLimit(1)
                                Spacer()
                            }
                        }
                    }
                }
                .onDelete(perform: deleteMemo)
            }
            .navigationTitle("メモ")
            .navigationBarTitleDisplayMode(.automatic)
            // ここに追加！
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddMemoView()) {
                        Text("新規作成")
                    }
                }
            }
        }
    }
    
    // 削除時の処理
    private func deleteMemo(offsets: IndexSet) {
        offsets.forEach { index in
            viewContext.delete(fetchedMemoList[index])
        }
        // 保存を忘れない
        try? viewContext.save()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
