//
//  File.swift
//  
//
//  Created by Lonmee on 2/3/21.
//

import PerfectSQLite

let DB_PATH = "./db/database"
var contentArr = [[String: Any]]()
var page = 0

func opration() -> Void {
    print("db op")
}

func createTable(name: String) -> Void {
    do {
        let sqlite = try SQLite(DB_PATH)
        defer {
            sqlite.close()
        }
        try sqlite.execute(statement: "CREATE TABLE IF NOT EXISTS \(name) (id INTEGER PRIMARY KEY NOT NULL, option TEXT NOT NULL, value TEXT)")
    } catch {
        print(error)
    }
}

func readAll(table: String) -> Void {
    do {
        let sqlite = try SQLite(DB_PATH)
        defer {
            sqlite.close() // 确保数据库连接已关闭
        }
        let statement = "SELECT * FROM \(table)"
        try sqlite.forEachRow(statement: statement) {(statement: SQLiteStmt, i:Int) -> () in
            contentArr.append([
                "name": statement.columnText(position: 0),
                "sex": statement.columnText(position: 1),
                "age": statement.columnText(position: 2)
            ])
        }
    } catch {
        //处理错误
    }
}

func read(bindValue: Int) -> Void {
    do {
        let sqlite = try SQLite(DB_PATH)
        defer {
            sqlite.close() // 此处确定关闭数据连接
        }
        
        let demoStatement = "SELECT post_title, post_content FROM posts ORDER BY id DESC LIMIT :1"
        
        try sqlite.forEachRow(statement: demoStatement, doBindings: {
            (statement: SQLiteStmt) -> () in
            
            let bindValue = 5
            try statement.bind(position: 1, bindValue)
            
        }) {(statement: SQLiteStmt, i:Int) -> () in
            
            contentArr.append([
                "id": statement.columnText(position: 0),
                "second_field": statement.columnText(position: 1),
                "third_field": statement.columnText(position: 2)
            ])
        }
    } catch {
        // 错误处理
    }
}

func loadPageContent(forPage: Int) {
    do {
        let sqlite = try SQLite(DB_PATH)
        defer {
            sqlite.close()
        }
        let sqlStatement = "SELECT post_content, post_title FROM posts ORDER BY id DESC LIMIT 5 OFFSET :1"
        
        try sqlite.forEachRow(statement: sqlStatement, doBindings: {
            (statement: SQLiteStmt) -> () in
            
            let bindPage: Int
            if page == 0 || page == 1 {
                bindPage = 0
            } else {
                bindPage = forPage * 5 - 5
            }
            
            try statement.bind(position: 1, bindPage)
        }) {
            (statement: SQLiteStmt, i:Int) -> () in
            contentArr.append([
                "postContent": statement.columnText(position: 0),
                "postTitle": statement.columnText(position: 1)
            ])
        }
    } catch {
        print(error)
    }
}

//public struct Database<C: DatabaseConfigurationProtocol>: DatabaseProtocol {
//    public typealias Configuration = C
//    public let configuration: Configuration
//    public init(configuration c: Configuration)
//    public func table<T: Codable>(_ form: T.Type) -> Table<T, Database<C>>
//    public func transaction<T>(_ body: () throws -> T) throws -> T
//    public func create<A: Codable>(_ type: A.Type,
//                                   primaryKey: PartialKeyPath<A>? = nil,
//                                   policy: TableCreatePolicy = .defaultPolicy) throws -> Create<A, Self>
//}
//
//public extension Table {
//    func insert(_ instances: [Form]) throws -> Insert<Form, Table<A,C>>
//    func insert(_ instance: Form) throws -> Insert<Form, Table<A,C>>
//    func insert(_ instances: [Form], setKeys: PartialKeyPath<OverAllForm>, _ rest: PartialKeyPath<OverAllForm>...) throws -> Insert<Form, Table<A,C>>
//    func insert(_ instance: Form, setKeys: PartialKeyPath<OverAllForm>, _ rest: PartialKeyPath<OverAllForm>...) throws -> Insert<Form, Table<A,C>>
//    func insert(_ instances: [Form], ignoreKeys: PartialKeyPath<OverAllForm>, _ rest: PartialKeyPath<OverAllForm>...) throws -> Insert<Form, Table<A,C>>
//    func insert(_ instance: Form, ignoreKeys: PartialKeyPath<OverAllForm>, _ rest: PartialKeyPath<OverAllForm>...) throws -> Insert<Form, Table<A,C>>
//}


//init(_:readOnly:)
//close()
//prepare(_:)
//lastInsertRowID()
//totalChanges()
//changes()
//errCode()
//errMsg()
//execute(_:)
//execute(_:doBindings:)
//execute(_:count:doBindings:)
//doWithTransaction(_:)
//forEachRow(_:handleRow:)
//forEachRow(_:doBindings:handleRow
