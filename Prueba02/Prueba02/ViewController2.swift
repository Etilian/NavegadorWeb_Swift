//
//  ViewController2.swift
//  Prueba02
//
//  Created by AlexCandi on 21/01/2019.
//  Copyright © 2019 AlexCandi. All rights reserved.
//

import UIKit
import SQLite3

class ViewController2: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    var direcciones: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return direcciones.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text  = direcciones[indexPath.row]
        
        return cell
    }
    
    var db: OpaquePointer?
    var websList = [Webs]()

    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ProductsDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Webs (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        readValues()
        for he in websList {
            direcciones.append(String(he.name!))
        }
        // Do any additional setup after loading the view.
    }
    
    func readValues(){
        //first empty the list of heroes
        websList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM Webs"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            
            //adding values to list
            websList.append(Webs(id: Int(id), name: String(describing: name)))
        }
    }

    @IBAction func volver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
