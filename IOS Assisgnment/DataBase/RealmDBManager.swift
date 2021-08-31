//
//  RealmDBManager.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 30/08/21.
//

import Foundation
import RealmSwift

class RealmDBManager: NSObject {
    static  let sharedManager = RealmDBManager()
     var realmURL: String!
     var config : Realm.Configuration!
     var realm  : Realm!
    override init() {
        super.init()
        self.configureRealmDatabase()

    }
    // MARK: - CONFIGURATION
    func configureRealmDatabase() {


      
        self.config = Realm.Configuration.defaultConfiguration
       
        self.config.fileURL = self.config.fileURL!.deletingLastPathComponent().appendingPathComponent("com.assignment")
        self.realm = try! Realm(configuration: self.config)
        self.realmURL = self.config.fileURL!.absoluteString
    }
    // MARK: - Add
    public func addObject(object: Object) {
        do {
            try realm.write({
                realm.add(object)
                
            })
        }catch let error {
            print(error)
        }
    }

    public func addOrUpdateObject(object: Object) {

        do {
            try realm.write({
                realm.add(object, update: .all)
               
            })
        }catch let error {
            print(error)
        }
        
    }
    // MARK: - Fetch
    public func fetchObjects(object: Object.Type) -> Array<Any> {

        if let realm = realm {
            return Array(realm.objects(object.self))
        }

        return []
    }
}
