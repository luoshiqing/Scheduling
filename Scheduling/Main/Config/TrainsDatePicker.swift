//
//  TrainsDatePicker.swift
//  SmartBus
//
//  Created by DayHR on 2018/4/3.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

class TrainsDatePicker: UIView {
    public var dateHandler: ((Date)->Swift.Void)?
    
    fileprivate var bgView: UIView?
    fileprivate var myPickerView: UIDatePicker?
    fileprivate var myRect = CGRect()
    fileprivate var okBtn: UIButton?

    fileprivate var selectTime = Date()
    fileprivate var minDate: Date?
    fileprivate var maxDate: Date?
    fileprivate var dataModel = UIDatePicker.Mode.date
    init(frame: CGRect, dataModel: UIDatePicker.Mode) {
        let rect = UIScreen.main.bounds
        super.init(frame: rect)
        self.dataModel = dataModel
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.myRect = frame
        
        self.loadSomeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(selectTime: Date?, minDate: Date?, maxDate: Date?){
        UIApplication.shared.keyWindow?.addSubview(self)
        self.minDate = minDate
        self.maxDate = maxDate
        self.myPickerView?.minimumDate = minDate
        self.myPickerView?.maximumDate = maxDate
        if let t = selectTime{
            self.selectTime = t
            self.myPickerView?.date = self.selectTime
        }
        self.showAnimation()
    }
    fileprivate func showAnimation(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.bgView?.frame.origin.y = ScreenHeight - self.myRect.height
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }) { (isok) in
            
        }
    }
    fileprivate func removeAnimation(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.bgView?.frame.origin.y = ScreenHeight
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (isok) in
            if let date = self.myPickerView?.date{
                self.dateHandler?(date)
            }
            self.removeFromSuperview()
        }
    }
    
    fileprivate func loadSomeView(){
        
        bgView = UIView(frame: CGRect(x: 0, y: ScreenHeight, width: self.myRect.width, height: self.myRect.height))
        bgView?.backgroundColor = UIColor.white
        self.addSubview(bgView!)
        
        myPickerView = UIDatePicker(frame: CGRect(x: 0, y: 30, width: bgView!.frame.width, height: bgView!.frame.height - 30))
        myPickerView?.datePickerMode = self.dataModel
        myPickerView?.maximumDate = Date()
        
        bgView?.addSubview(myPickerView!)
        
        okBtn = UIButton(frame: CGRect(x: self.myRect.width - 45 - 8, y: 2, width: 45, height: 35))
        okBtn?.backgroundColor = UIColor.clear
        okBtn?.setTitle("确定", for: .normal)
        okBtn?.setTitleColor(UIColor.navColor, for: .normal)
        okBtn?.setTitleColor(UIColor.gray, for: .highlighted)
        okBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        okBtn?.addTarget(self, action: #selector(self.getPickerValue), for: .touchUpInside)
        bgView?.addSubview(okBtn!)
        
    }
    @objc fileprivate func getPickerValue(){
        self.removeAnimation()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let p = touches.first?.location(in: self.bgView)
        if !(self.bgView?.layer.contains(p!))!{
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.bgView?.frame.origin.y = ScreenHeight
                self.backgroundColor = UIColor.black.withAlphaComponent(0)
            }) { (isok) in
                self.removeFromSuperview()
            }
        }
    }
}
