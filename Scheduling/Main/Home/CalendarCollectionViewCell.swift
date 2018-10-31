//
//  CalendarCollectionViewCell.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/25.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    public var data: LsqCalendarModel!{
        didSet{
            if data == nil{
                self.dateLabel.text = nil
                self.valueLabel.text = nil
                self.dateLabel.backgroundColor = UIColor.clear
            }else{
                
                self.dateLabel.text = "\(data.day)"
                
                let type = data.type
                self.valueLabel.text = type.rawValue
                var color: UIColor? = UIColor.navColor
                let ms = ConfigModel.shard.configArray
                for m in ms{
                    let t = m.type
                    if type == t{
                        color = m.color
                        break
                    }
                }
                self.valueLabel.textColor = color
                
                if data.isToday{
                    self.dateLabel.backgroundColor = UIColor.navColor.withAlphaComponent(0.8)
                    self.dateLabel.textColor = UIColor.white
                }else{
                    self.dateLabel.backgroundColor = UIColor.clear
                    self.dateLabel.textColor = UIColor.hexColor(with: "#333333")
                }
                
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.layer.cornerRadius = dateLabel.frame.height / 2.0
        dateLabel.layer.masksToBounds = true
    }

}
