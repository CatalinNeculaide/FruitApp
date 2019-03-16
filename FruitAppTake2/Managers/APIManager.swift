//
//  APIManager.swift
//  FruitAppTake2
//
//  Created by Catalin Neculaide on 15/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIManager {
    
    static let shared = APIManager()
    
    private let apiFruit = "https://api.myjson.com/bins/rmxwi"
    
    func getFruits(completionHandler: @escaping (Bool, Error?, [Fruits]) -> Void) {
        
        var fruits = [Fruits]()
        var isSuccess = true
        
        guard let url = URL(string: apiFruit) else {
            print("Error: cannot create URL")
            isSuccess = false
            completionHandler(isSuccess,nil,fruits)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling GET on getFruits: \(error!)")
                isSuccess = false
                completionHandler(isSuccess,error!,fruits)
                return
            }
            
            guard let dataResponse = data else {
                print("Error: did not receive data")
                isSuccess = false
                completionHandler(isSuccess,error!,fruits)
                return
            }
            
            let localFruits = CoreDataManager.getFruits() ?? []
            for fruit in localFruits {
                CoreDataManager.mainViewContext.delete(fruit)
            }
            
            let json = JSON(dataResponse)
            
            if let fruitsJson = json["data"].array {
                for fruitJson in fruitsJson {
                    let fruit = Fruits(context: CoreDataManager.mainViewContext)
                    fruit.configureWithJson(json: fruitJson)
                    fruits.append(fruit)
                }
            }
            print(fruits)
            completionHandler(isSuccess, nil, fruits)
        }
        task.resume()
    }
    
    
    func getPictureOfFruit(url: String, completionHandler: @escaping (Bool,Error?,UIImage?) -> Void) {
        
        let pictureUrl = URL(string: url)!
        var isSuccess = true
        var cError: Error?
        
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: pictureUrl) { (data, response, error) in
            if let e = error {
                print("Error downloading picture \(e)")
                isSuccess = false
                cError = e
                completionHandler(isSuccess,cError,nil)
            } else {
                if let res = response as? HTTPURLResponse {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        completionHandler(isSuccess,cError, image)
                    } else {
                        print("Couldnt get image: Image is nil")
                        isSuccess = false
                        completionHandler(isSuccess,cError, nil)
                    }
                } else {
                    print("Couldnt get a resonse code for some reason")
                    isSuccess = false
                    completionHandler(isSuccess,cError,nil)
                }
            }
        }
        downloadPicTask.resume()
    }
    
}
