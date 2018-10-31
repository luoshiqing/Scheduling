//
//  HeadCollectionReusableView.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/25.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

class HeadCollectionReusableView: UICollectionReusableView {
    
    public var dateLabel: UILabel?
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadSomeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func loadSomeView(){
  
        dateLabel = UILabel(frame: CGRect(x: 15, y: 15, width: self.frame.width - 15 * 2, height: self.frame.height - 15))
        dateLabel?.textColor = UIColor.navColor
        dateLabel?.textAlignment = .right
        dateLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.addSubview(dateLabel!)
        
      
    }
    
}
