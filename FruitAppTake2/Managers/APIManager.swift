//
//  APIManager.swift
//  FruitAppTake2
//
//  Created by Catalin Neculaide on 15/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import Foundation


class APIManager {
    
    static let shared = APIManager()
    
    let apiFruit = "https://api.myjson.com/bins/rmxwi"
    
    func getFruits() {
        
        guard let url = URL(string: apiFruit) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling GET on getFruits: \(error!)")
                return
            }
            
            guard let dataResponse = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let fruit = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? [String: Any] else {
                    print("Error trying to convert data to JSON")
                    return
                }
                print("Fruits is: " + fruit.description)
                
                guard let fruitTitle = fruit["title"] as? String else {
                    print("Couldnt not get fruit title from JSON")
                    return
                }
                print("The title is :\(fruitTitle)")
            } catch {
                print("error trying to convert data to JSON")
            }
        }
        task.resume()
    }
    
}
