//
//  StorageManager.swift
//  numbers
//
//  Created by Andriy Biguniak on 07.08.2022.
//

import UIKit
import RealmSwift


class StorageManager {
    
    // MARK:- VARs
    static let shared = StorageManager()
//    private let realm = try! Realm()
    private init() {}
    
    
    // MARK:- Save number in string
    func saveToTheRealm(number: String) {
        do {
            let realm = try! Realm()
            try realm.write {
                realm.add(StorageModel(number: number))
            }
            print("number \(number) is saved")
        }
        catch let error { print(error) }
    }
    
    
    // MARK:- Filter data by containing number
    func getNumbers(withNumber: String) -> [String] {
        // fetch numberObjects
        let realm = try! Realm()
        let numberObjects = realm.objects(StorageModel.self)
            .where{ $0.number.contains(withNumber) }
        // get numbers
        let numbers = Array(numberObjects).map { $0.number }
        return numbers
    }
      
}
