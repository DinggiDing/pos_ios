//
//  ViewController.swift
//  MVVM
//
//  Created by 성재 on 2021/12/31.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _ = Observable.from([1,2,3,4,5])
    }


}

