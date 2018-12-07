//
//  DatabaseService.swift
//  TrackMe
//
//  Created by David Hohl on 13.12.17.
//  Copyright © 2018 David Hohl. All rights reserved.
//

import SQLite


class DatabaseService {
    
    // database handler
    var db:Connection!
    
    let trackingTable:Table = Table("tracking")
    let id:Expression = Expression<Int>("id")
    let name:Expression = Expression<String>("name")
    let published:Expression = Expression<Date>("published")
    
    init() {}
    
    /**
     connect to database
     */
    func connect() {
        
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            
            let fileUrl = documentDirectory
                .appendingPathComponent("tracking")
                .appendingPathExtension("sqlite3")
            
            
            self.db = try! Connection(fileUrl.path)
            
            createTables()
            
        } catch {
            print(error)
        }
    }
    
    /**
     remove tables
     */
    func resetDB() {
        do {
            try self.db.run(self.trackingTable.drop())
            createTables()
        } catch {
            print(error)
        }
    }
   
    
    /**
     create all needed tables
     */
    private func createTables() {
        
        
        let createTable = self.trackingTable.create(ifNotExists:true) {(table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.published)
        }
        
        do {
            try self.db.run(createTable)
            print("table created")
        } catch {
            print(error)
        }
    }
    
    
    
    
}
