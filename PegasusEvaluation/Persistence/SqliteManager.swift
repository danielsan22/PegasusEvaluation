//
//  SqliteManager.swift
//  PegasusEvaluation
//
//  Created by Daniel Sanchez on 16/09/18.
//  Copyright © 2018 DanielSR. All rights reserved.
//

import UIKit
import SQLite3

class SqliteManager: NSObject {
    override init() {
        super.init()
        self.createDatabase()
        self.setupDatabase()
    }
    
    var db: OpaquePointer?
    
    func createDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("convertionsDB")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error oppening database")
        }
    }
    func setupDatabase() {
        let query = "CREATE TABLE IF NOT EXISTS ConversionLog (id INTEGER PRIMARY KEY AUTOINCREMENT, celsius TEXT, fahrenheit TEXT, datetime INTEGER)"
        if(sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK) {
            print("error creating table")
        }
    }
    func insertConversion(celsius: String, fahrenheit: String) {
        let queryString = "INSERT INTO ConversionLog (celsius, fahrenheit, datetime) values (?,?,?)"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            print("error preparing query")
        }
        
        if sqlite3_bind_text(stmt, 1, celsius, -1, nil) != SQLITE_OK {
            print("Error binding parameters")
        }
        if sqlite3_bind_text(stmt, 2, fahrenheit, -1, nil) != SQLITE_OK {
            print("Error binding parameters")
        }
        let dateTime = Int32(NSDate().timeIntervalSince1970)
        if sqlite3_bind_int(stmt, 3, dateTime) != SQLITE_OK {
            print("Error binding parameters")
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            print("Error inserting into ConversionLog")
        }
        
        print("Conversion \(celsius) -> \(fahrenheit)inserted successfully!")
        
    }
    func readConversions() -> [ConversionLog] {
        var resp = [ConversionLog]()
        
        let queryString = "SELECT * from ConversionLog"
        
        var stmt:OpaquePointer?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            print("error preparing insert")
            return resp
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let celsius = String(cString: sqlite3_column_text(stmt, 1))
            let fahrenheit = String(cString: sqlite3_column_text(stmt, 2))
            let date = Int(sqlite3_column_int(stmt, 3))
            let cl = ConversionLog(id: id, celsius: String(describing: celsius), fahrenheit: String(describing: fahrenheit), dateTime: date)
            resp.append(cl)
        }
        return resp
    }
}
