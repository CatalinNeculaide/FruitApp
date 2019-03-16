//
//  DetailViewController.swift
//  FruitAppTake2
//
//  Created by Catalin Neculaide on 15/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var imageFruit: UIImageView!
    
    
    var fruit: Fruits = Fruits()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
    }
    
    static func instantiate(with selectedFruit: Fruits) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        controller.fruit = selectedFruit
        
        return controller
        
    }
    
    func configure() {
        
        detailsLabel.text = fruit.title
        getImage(url: fruit.url!)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func getImage(url: String) {
        APIManager.shared.getPictureOfFruit(url: url) { (isSuccess, error, image) in
            if isSuccess == true {
                DispatchQueue.main.async {
                    self.imageFruit.image = image
                }
            } else {
                print("Error in getting image")
            }
            
            
        }
    }
    
}
