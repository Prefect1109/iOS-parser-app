//
//  SearchHistoryManager.swift
//  iOS Parser
//
//  Created by Prefect on 01.04.2022.
//

import Foundation
import SQLite
 
class SearchHistoryManager {
 
    private var db: Connection!
    private var searchHistory: Table!
  
    private var id: Expression<Int64>!
    private var text: Expression<String>!
     
    init () {
          
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
  
            db = try Connection("\(path)/search_history.sqlite3")
            searchHistory = Table("search_history")
            
            id = Expression<Int64>("id")
            text = Expression<String>("title")
              
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                try db.run(searchHistory.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(text)
                })
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
              
        } catch {
            print(error.localizedDescription)
        }
    }
     public func isExists(searchedText: String) -> Bool {
        var isExists: Bool = false
    
        do {
            let searchRecord: AnySequence<Row> = try db.prepare(searchHistory.filter(text.lowercaseString == searchedText.lowercased()))
      
            searchRecord.forEach({ (rowValue) in
                isExists = true
            })
             
        } catch {
            print(error.localizedDescription)
        }
      
        return isExists
    }
     
    public func addSearchRecord(nameValue: String) {
        do {
            try db.run(searchHistory.insert(text <- nameValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getHistoryRecords() -> [String] {
          
        var historyRecords: [String] = []
      
        do {
            for record in try db.prepare(searchHistory) {
                historyRecords.append(record[text])
            }
        } catch {
            print(error.localizedDescription)
        }
      
        // return array
        return historyRecords
    }
}
