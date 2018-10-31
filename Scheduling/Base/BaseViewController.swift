//
//  BaseViewController.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/23.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    public var isShowBack = true{
        didSet{
            if isShowBack{
                self.setBackItem()
            }else{
                self.removeBackItem()
            }
        }
    }
    
    private var leftItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.setBackItem()
    }
   
    
    private func setBackItem(){
        if self.leftItem == nil{
            let img = UIImage(named: "返回")
            leftItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(self.backClick))
            self.navigationItem.leftBarButtonItem = leftItem
        }
    }
    private func removeBackItem(){
        self.leftItem = nil
        self.navigationItem.leftBarButtonItem = nil
    }
    
    @objc public func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
