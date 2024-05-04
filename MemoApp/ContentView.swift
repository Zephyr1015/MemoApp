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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        exportMemos()
                    }) {
                        Image(systemName: "square.and.arrow.up")
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
    
    private func exportMemos() {
        let request = NSFetchRequest<Memo>(entityName: "Memo")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Memo.updatedAt, ascending: true)]
        
        do {
            let memos = try viewContext.fetch(request)
            let csvString = convertToCSV(memos: memos)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("memos.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            shareCVS(fileURL: fileURL)
        } catch {
            print("获取备忘录数据失败: \(error)")
        }
    }
    
    private func convertToCSV(memos: [Memo]) -> String {
        var csvString = "标题,内容,时间戳\n"
        for memo in memos {
            let title = memo.title ?? ""
            let content = memo.content ?? ""
            let timestamp = memo.updatedAt ?? Date()
            let row = "\"\(title)\",\"\(content)\",\(timestamp.ISO8601Format())\n"
            csvString += row
        }
        return csvString
    }
    
    private func shareCVS(fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
