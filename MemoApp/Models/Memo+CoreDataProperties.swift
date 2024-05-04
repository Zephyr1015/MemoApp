//
//  Memo+CoreDataProperties.swift
//  MemoApp
//
//  Created by Vincent on 2024/05/04.
//
//

import Foundation
import CoreData


extension Memo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    
}

extension Memo : Identifiable {
    // ここに追加
    // stringUpdatedAtを呼び出すとString型のupdatedAtが返却される
    public var stringUpdatedAt: String { dateFomatter(date: updatedAt ?? Date()) }
    
    func dateFomatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        return dateFormatter.string(from: date)
    }
    
}
