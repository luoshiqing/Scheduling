//
//  ConfigTableViewCell.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/23.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

class ConfigTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    public var data: ConfigTypeModel!{
        didSet{
            if data == nil{
                return
            }
            nameLabel.text = data.type.rawValue
            nameLabel.textColor = data.color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
