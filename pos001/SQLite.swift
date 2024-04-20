//
//  SQLite.swift
//  pos001
//
//  Created by 성재 on 2021/07/07.
//

//open /Users/seongjae/Library/Developer/CoreSimulator/Devices/56875EA2-078D-419F-92B6-AC5AE076368B/data/Containers/Data/Application/308DC106-3FB3-4167-BEDC-34E021D0A074/Library/FOOD.db

import Foundation
import SQLite3

public class SQLite {
    let path: String = {
          let fm = FileManager.default
          return fm.urls(for:.libraryDirectory, in:.userDomainMask).last!
                   .appendingPathComponent("FOOD.db").path
        }()
    
    let createTableString = """
CREATE TABLE IF NOT EXISTS FOOD(
Id INTEGER PRIMARY KEY AUTOINCREMENT,
memo INTEGER,
image VARCHAR,
color INTEGER,
sort INTEGER,
feel INTEGER);
"""
    var db : OpaquePointer? //db를 가리키는 포인터
    
    init(){ //클래스 인스턴스가 생성될 때 호출
        if sqlite3_open(path,&db) == SQLITE_OK {
            if sqlite3_exec(db, createTableString,nil,nil,nil) == SQLITE_OK {
                return
            }
        }
    }
    
    func insertToDo(memo : Int, image: String, color:Int, sort:Int, feel:Int) -> Int{
            //(1) insert sql문
            let insertStatementString = "INSERT INTO FOOD (memo,image,color,sort,feel) VALUES (?, ?, ?, ?,?);"
            //(2) 쿼리 저장 변수
            var stmt: OpaquePointer? //query를 가리키는 포인터
            
            if sqlite3_prepare(db, insertStatementString, -1, &stmt, nil) == SQLITE_OK{
                sqlite3_bind_int(stmt, 1, Int32(memo))
                sqlite3_bind_text(stmt, 2, image, -1, nil)
                sqlite3_bind_int(stmt, 3, Int32(color))
                sqlite3_bind_int(stmt, 4, Int32(sort))
                sqlite3_bind_int(stmt, 5, Int32(feel))
                
                if sqlite3_step(stmt) == SQLITE_DONE{
                    print("\nInsert row Success")
                }else{
                    print("\nInsert row Faild")
                }
            }else{
                print("\nInsert Statement is not prepared")
            }
            sqlite3_finalize(stmt)
            return Int(sqlite3_last_insert_rowid(db))
    }
    
    func deleteToDo(id: Int) {
          let deleteStatementString = "DELETE FROM FOOD WHERE Id = \(id);"
          var stmt: OpaquePointer? //query를 가리키는 포인터
          
            if sqlite3_prepare(db, deleteStatementString, -1, &stmt, nil) == SQLITE_OK{
                if sqlite3_step(stmt) == SQLITE_DONE{
                    print("\nDelete Row Success")
                }else{
                    print("\nDelete Row Faild")
                }
            }else{
                print("\nDelete Statement in not prepared")
            }
            sqlite3_finalize(stmt)
        }
    
    func fetchToDo_UP() -> [SQLiteItem]{
            let queryStatementString = "SELECT * FROM FOOD WHERE memo=1;"
            var items : [SQLiteItem] = []
            var stmt: OpaquePointer? //query를 가리키는 포인터
            
            if sqlite3_prepare(db, queryStatementString, -1, &stmt, nil) == SQLITE_OK{
                while(sqlite3_step(stmt) == SQLITE_ROW){
                    let idResult = sqlite3_column_int(stmt, 0)
                    let memoResult = sqlite3_column_int(stmt, 1)
                    guard let imageResult = sqlite3_column_text(stmt, 2) else {
                        continue
                    }
                    let imageRes = String(cString: imageResult)
                    let colorResult = sqlite3_column_int(stmt, 3)
                    let sortResult = sqlite3_column_int(stmt, 4)
                    let feelResult = sqlite3_column_int(stmt, 5)
                    
                    let item = SQLiteItem(id: Int(idResult), memo: Int(memoResult), image: imageRes, color: Int(colorResult), sort: Int(sortResult), feel: Int(feelResult))
                    items.append(item)
                }
            }else{
                print("query is not prepared")
            }
            
            sqlite3_finalize(stmt)
            return items
    }
    
    func fetchToDo_DOWN() -> [SQLiteItem]{
            let queryStatementString = "SELECT * FROM FOOD WHERE memo=2;"
            var items : [SQLiteItem] = []
            var stmt: OpaquePointer? //query를 가리키는 포인터
            
            if sqlite3_prepare(db, queryStatementString, -1, &stmt, nil) == SQLITE_OK{
                while(sqlite3_step(stmt) == SQLITE_ROW){
                    let idResult = sqlite3_column_int(stmt, 0)
                    let memoResult = sqlite3_column_int(stmt, 1)
                    guard let imageResult = sqlite3_column_text(stmt, 2) else {
                        continue
                    }
                    let imageRes = String(cString: imageResult)
                    let colorResult = sqlite3_column_int(stmt, 3)
                    let sortResult = sqlite3_column_int(stmt, 4)
                    let feelResult = sqlite3_column_int(stmt, 5)
                    
                    let item = SQLiteItem(id: Int(idResult), memo: Int(memoResult), image: imageRes, color: Int(colorResult), sort: Int(sortResult), feel: Int(feelResult))
                    items.append(item)
                }
            }else{
                print("query is not prepared")
            }
            
            sqlite3_finalize(stmt)
            return items
    }
}
