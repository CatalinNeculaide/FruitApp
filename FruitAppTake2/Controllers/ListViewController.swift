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
    
    enum TableSection: Int{
        case local = 0, exotic, total
    }
    
    let sectionHeaderHeight: CGFloat = 25
    
    var data = [TableSection: [Fruits]?]()
    
    
    var fruits: [Fruits] = []
    var images: [String:UIImage] = [:]
    var section: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.allowsSelection = true
        listTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        
        getAllFruit()
//        getAllImages()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listTableView.reloadData()
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.total.rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tableSection = TableSection(rawValue: section), let fruitData = data[tableSection] {
            return fruitData!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        if section == 0 {
            if let fruitData = data[.local] {
                if fruitData!.count > 0 {
                    return sectionHeaderHeight
                }
            }
        } else if section == 1 {
            if let fruitData = data[.exotic] {
                if fruitData!.count > 0 {
                    return sectionHeaderHeight
                }
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        view.backgroundColor = UIColor.green
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        
        if let tableSection = TableSection(rawValue: section){
            switch tableSection {
            case .local:
                label.text = "Local"
            case .exotic:
                label.text = "Exotic"
            default:
                label.text = "Fruits"
            }
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 0 {
            if let fruit = data[.local]??[indexPath.row] {
                if let title = fruit.title {
                    cell.fruitTitle.text = title
                    cell.fruitDetails.isHidden = true
                    cell.imageView?.isHidden = true
                }
            }
        } else if indexPath.section == 1 {
            if let fruit = data[.exotic]??[indexPath.row] {
                if let title = fruit.title {
                    cell.fruitTitle.text = title
                    cell.fruitDetails.isHidden = true
                    cell.imageView?.isHidden = true
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var option: Fruits = Fruits()
        if indexPath.section == 0 {
            if let fruit = data[.local]??[indexPath.row] {
                option = fruit
            }
        } else if indexPath.section == 1 {
            if let fruit = data[.exotic]??[indexPath.row] {
               option = fruit
            }
        }
        
        let detailViewController = DetailViewController.instantiate(with: option)
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
                    self?.sortData()
                }
                
            } else {
                print(error!)
                apiFruits = CoreDataManager.getFruits()!
                self.fruits = apiFruits
                CoreDataManager.saveMainContext()
                DispatchQueue.main.async { [weak self] in
                    self?.listTableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.sortData()
                }
            }
        }
        
    }
    
//    func getAllImages(){
//
//        for fruit in fruits {
//            APIManager.shared.getPictureOfFruit(url: fruit.url!) { (isSuccess, error, apiImage) in
//                if isSuccess == true {
//                    if let image = apiImage {
//                        self.images[fruit.title!] = image
//                    } else {
//                        print("Image from \(fruit.title) is missing")
//                    }
//                } else {
//                    print("Couldnt get images")
//                }
//            }
//        }
//    }
    
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
    
    
    func sortData() {
        
        data[.local] = Array(CoreDataManager.getFruitsType(type: "local")!)
        data[.exotic] = Array(CoreDataManager.getFruitsType(type: "exotic")!)
        listTableView.reloadData()
    }
    
}
