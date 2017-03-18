//
//  ViewController.swift
//  Flicks
//
//  Created by Omar Abbasi on 2016-12-16.
//  Copyright © 2016 Omar Abbasi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        imageView.addBlurEffect()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

