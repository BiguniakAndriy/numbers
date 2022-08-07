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
    private let realm = try! Realm()
    private init() {}
    
    
    // MARK:- Save number in string
    private func saveToTheRealm(number: Int) {
        do {
            try self.realm.write {
                realm.add(StorageModel(number: number))
            }
        }
        catch let error { print(error) }
    }
    
    
    // MARK:- Filter data by containing number
    private func getNumbers(withNumber: Int) -> [Int] {
        
        // fetch numbers in string
        let numbersInString = Array(realm.objects(StorageModel.self)
            .where{ $0.number .contains(String(withNumber)) })
        
        var numbers : [Int] = []
        
        // convert to Int
        for object in numbersInString {
            if let intNumber = Int(object.number) {
                numbers.append(intNumber)
            }
        }
        
        return numbers
    }
      
}
