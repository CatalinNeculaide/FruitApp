//
//  DetailViewController.swift
//  FruitAppTake2
//
//  Created by Catalin Neculaide on 15/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleFruitName: UINavigationItem!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var imageFruit: UIImageView!
    
    var fruit: Fruits = Fruits()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    static func instantiate(with selectedFruit: Fruits) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.fruit = selectedFruit
        
        return controller
        
    }
    
    func configure() {
        
        title = fruit.title
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
}
