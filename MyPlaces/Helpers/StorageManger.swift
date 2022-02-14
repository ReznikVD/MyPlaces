//
//  StorageManger.swift
//  MyPlaces
//
//  Created by user207855 on 2/3/22.
//

import RealmSwift

let realm = try! Realm()

class StorageManger {
    
    static func saveObject(_ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place) {
        
        try! realm.write {
            realm.delete(place)
        }
    }
}
