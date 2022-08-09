//
//  NetworkManager.swift
//  numbers
//
//  Created by Andriy Biguniak on 07.08.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
//    private let apiKey = "8c627fa2-167f-48e5-9258-a364633c78b7"
    
    // MARK:- Get random number
    func getDataIfYouAllow(allow: Bool) async -> String? {
        
        // check allow and url
        guard allow == true,
        let url = URL(string: "https://www.random.org/integers/?num=1&min=1&max=99999&col=1&base=10&format=plain&rnd=new")
        else { return nil }
    
        //get number
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return String(data: data, encoding: String.Encoding.utf8)
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
}
