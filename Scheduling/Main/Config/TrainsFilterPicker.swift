//
//  TrainsFilterPicker.swift
//  SmartBus
//
//  Created by DayHR on 2018/4/3.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit
//线路、驾驶员、车辆选择视图
class TrainsFilterPicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    public var okHandler: ((Int,String)->Swift.Void)?
    fileprivate var dataArray = [String](){
        didSet{
            self.myPickerView?.reloadAllComponents()
        }
    }
    fileprivate var bgView: UIView?
    fileprivate var myPickerView: UIPickerView?
    fileprivate var myRect = CGRect()
    fileprivate var okBtn: UIButton?
    
    fileprivate var selectIndex = 0//选择的index
    override init(frame: CGRect) {
        let rect = UIScreen.main.bounds
        super.init(frame: rect)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.myRect = frame
        self.loadSomeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func show(dataArray: [String], selectIndex: Int?){
        UIApplication.shared.keyWindow?.addSubview(self)
        self.dataArray = dataArray
        self.selectIndex = selectIndex ?? 0
        self.myPickerView?.selectRow(self.selectIndex, inComponent: 0, animated: false)
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
            if let index = self.myPickerView?.selectedRow(inComponent: 0){
                if index < self.dataArray.count{
                    let value = self.dataArray[index]
                    self.okHandler?(index,value)
                }
            }
            self.removeFromSuperview()
        }
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
    
    fileprivate func loadSomeView(){
        
        bgView = UIView(frame: CGRect(x: 0, y: ScreenHeight, width: self.myRect.width, height: self.myRect.height))
        bgView?.backgroundColor = UIColor.white
        self.addSubview(bgView!)
        
        
        myPickerView = UIPickerView(frame: CGRect(x: 0, y: 30, width: bgView!.frame.width, height: bgView!.frame.height - 30))
        myPickerView?.delegate = self
        myPickerView?.dataSource = self
        myPickerView?.selectRow(self.selectIndex, inComponent: 0, animated: false)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }

}
