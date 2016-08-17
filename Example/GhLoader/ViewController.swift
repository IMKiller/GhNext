//
//  ViewController.swift
//  GhLoader
//
//  Created by 刘高晖 on 16/8/17.
//  Copyright © 2016年 刘高晖. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = GHCircleLoader.init(frame: self.view.bounds)
        self.view.addSubview(view)
        self.view.backgroundColor = UIColor.redColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

