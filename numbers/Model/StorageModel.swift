//
//  StorageModel.swift
//  numbers
//
//  Created by Andriy Biguniak on 07.08.2022.
//

import Foundation
import RealmSwift

class StorageModel : Object {
    
    @Persisted var number : String
    
    convenience init(number: Int) {
        self.init()
        self.number = String(number)
    }
}