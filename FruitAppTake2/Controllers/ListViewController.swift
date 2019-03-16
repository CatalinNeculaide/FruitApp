//
//  ListViewController.swift
//  FruitAppTake2
//
//  Created by Catalin Neculaide on 15/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var fruits: [Fruits] = []
    var images: [String:UIImage] = [:]
    var section: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.allowsSelection = true
        
        
        getAllFruit()
        getAllImages()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listTableView.reloadData()
    }
    // MARK: - Table view data source

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        let fruit = fruits[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        cell.accessoryType = .disclosureIndicator
        
        cell.fruitTitle.text = fruit.title!
        cell.fruitDetails.isHidden = true
        if images[fruit.title!] != nil {
            cell.fruitImage.image = images[fruit.title!]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = DetailViewController.instantiate(with: fruits[indexPath.row])
        self.present(detailViewController, animated: true, completion: nil)
        
    }
    
    func getAllFruit() {
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        var apiFruits = [Fruits]()
        
        APIManager.shared.getFruits { (isSuccess, error, getFruits) in
            if isSuccess == true {
                for fruit in getFruits {
                    apiFruits.append(fruit)
                }
                self.fruits = apiFruits
                CoreDataManager.saveMainContext()
                DispatchQueue.main.async { [weak self] in
                    self?.listTableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
                self.section = self.getSections(fruits: self.fruits)
                
            } else {
                print(error!)
                apiFruits = CoreDataManager.getFruits()!
                self.fruits = apiFruits
                CoreDataManager.saveMainContext()
                DispatchQueue.main.async { [weak self] in
                    self?.listTableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
                self.section = self.getSections(fruits: self.fruits)
            }
        }
        
    }
    
    func getAllImages(){
        
        for fruit in fruits {
            APIManager.shared.getPictureOfFruit(url: fruit.url!) { (isSuccess, error, apiImage) in
                if isSuccess == true {
                    if let image = apiImage {
                        self.images[fruit.title!] = image
                    } else {
                        print("Image from \(fruit.title) is missing")
                    }
                } else {
                    print("Couldnt get images")
                }
            }
        }
    }
    
    func getSections(fruits: [Fruits]) -> [String] {
        
        var counts: [String:Int] = [:]
        for fruit in fruits {
            counts[fruit.type!] = (counts[fruit.type!] ?? 0) + 1
        }
        
        var section: [String] = []

        for (key, _) in counts {
            section.append(key)
        }
        
        return section
    }
    
    
}
