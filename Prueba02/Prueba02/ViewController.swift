//
//  ViewController.swift
//  Prueba02
//
//  Created by AlexCandi on 14/01/2019.
//  Copyright © 2019 AlexCandi. All rights reserved.
//

import UIKit
import WebKit
import SQLite3

class ViewController: UIViewController,WKNavigationDelegate {
    
    var db: OpaquePointer?
    var websList = [Webs]()
    
    @IBAction func historial(_ sender: Any) {}
    @IBOutlet weak var buscador: UITextField!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Base de datos -- Base de datos -- Base de datos -- Base de datos -- Base de datos
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
        //insertar()
        //readValues()
        /*for he in websList {
            print(he.name!)
        }*/
        //Base de datos -- Base de datos -- Base de datos -- Base de datos -- Base de datos
        
        buscador.text = "www.google.com"
        
        let url = URL(string: "https://" + buscador.text!)!
        webView.load(URLRequest(url: url))
    }
    
    @IBAction func buscarWeb(_ sender: Any) {
        if let url = URL(string: "https://" + buscador.text!) {
            print("Correcto")
            webView.load(URLRequest(url: url))
            
            insertar(direccionWeb: buscador.text!)
        } else {
            print("Error")
        }
        /*for he in websList {
            print(he.name!)
        }*/
    }
    
    func insertar(direccionWeb: String)  {
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Webs ('name') VALUES ('" + direccionWeb + "')"
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting web: \(errmsg)")
            return
        }
        
        //readValues()
        
        //displaying a success message
        print("Web saved successfully")
    }
    
    @IBAction func webAnterior(_ sender: Any) {
        if(webView.canGoBack) {
            //Go back in webview history
            webView.goBack()
        } else {
            //Pop view controller to preview view controller
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func webSiguiente(_ sender: Any) {
        if(webView.canGoForward) {
            //Go forward in webview history
            webView.goForward()
        } else {
            //Pop view controller to preview view controller
            self.navigationController?.popViewController(animated: true)
        }
    }
    /*func readValues(){
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
    }*/
    
}

class Webs {
    
    var id: Int
    var name: String?
    
    init(id: Int, name: String?){
        self.id = id
        self.name = name
    }
}
