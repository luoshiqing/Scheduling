//
//  ConfigViewController.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/23.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit
import SnapKit
import MSColorPicker
//TODO:配置
class ConfigViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, MSColorSelectionViewControllerDelegate{
    
    public var eidtHandler: ((String)->Swift.Void)?
    
    private var dateBtn = UIButton()
    private var typeBtn = UIButton()
    private var editBtn = UIButton()
    private var myTabView: UITableView?
    
    private var model = ConfigModel.shard
    
    private lazy var dataArray: [ConfigTypeModel] = {
        return self.model.configArray
    }()
    
    private var isHaveEdit = false//是否有过编辑
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "配置"
        
        
        self.loadSomeView()
    }
    override func backClick() {
        if self.myTabView!.isEditing == true{
            let alert = UIAlertController(title: "提示", message: "排班顺序未保存，是否放弃保存?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (act) in
                if self.isHaveEdit{
                    self.eidtHandler?("重新搞数据")
                }
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            if self.isHaveEdit{
                self.eidtHandler?("重新搞数据")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
   
    private func loadSomeView(){
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = UIColor.hexColor(with: "#333333")
        dateLabel.text = "起始日期:"
        self.view.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20 + navStatusHeight)
            make.height.equalTo(18)
        }

        dateBtn.setTitle(self.model.configTime.toString(type: .yyyy_MM_dd), for: .normal)
        dateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        dateBtn.setTitleColor(UIColor.navColor, for: .normal)
        dateBtn.setTitleColor(UIColor.darkGray, for: .highlighted)
        dateBtn.tag = 0
        dateBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: .touchUpInside)
        self.view.addSubview(dateBtn)
        dateBtn.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right).offset(0)
            make.centerY.equalTo(dateLabel.snp.centerY).offset(0)
            make.width.equalTo(110)
            make.height.equalTo(35)
        }
        
        let typeLabel = UILabel()
        typeLabel.font = UIFont.systemFont(ofSize: 16)
        typeLabel.textColor = UIColor.hexColor(with: "#333333")
        typeLabel.text = "起始班次:"
        self.view.addSubview(typeLabel)
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(dateLabel.snp.bottom).offset(25)
            make.height.equalTo(18)
        }

        typeBtn.setTitle(self.model.configType.rawValue, for: .normal)
        typeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        typeBtn.setTitleColor(self.model.configTypeColor, for: .normal)
        typeBtn.setTitleColor(UIColor.darkGray, for: .highlighted)
        typeBtn.tag = 1
        typeBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: .touchUpInside)
        self.view.addSubview(typeBtn)
        typeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(typeLabel.snp.right).offset(0)
            make.centerY.equalTo(typeLabel.snp.centerY).offset(0)
            make.width.equalTo(54)
            make.height.equalTo(35)
        }
        
        
        let tipsLabel = UILabel()
        tipsLabel.font = UIFont.systemFont(ofSize: 15)
        tipsLabel.textColor = UIColor.hexColor(with: "#333333")
        tipsLabel.text = "排班顺序(点击编辑即可拖动以调整排班顺序)"
        self.view.addSubview(tipsLabel)
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(typeLabel.snp.bottom).offset(25)
            make.height.equalTo(18)
        }
        
        editBtn.setTitle("编辑", for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        editBtn.setTitleColor(UIColor.navColor, for: .normal)
        editBtn.setTitleColor(UIColor.darkGray, for: .highlighted)
        editBtn.layer.cornerRadius = 3
        editBtn.layer.masksToBounds = true
        editBtn.layer.borderColor = UIColor.navColor.cgColor
        editBtn.layer.borderWidth = 0.5
        editBtn.tag = 2
        editBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: .touchUpInside)
        self.view.addSubview(editBtn)
        editBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(tipsLabel.snp.centerY).offset(0)
            make.width.equalTo(54)
            make.height.equalTo(30)
        }
        
        myTabView = UITableView(frame: CGRect(), style: .plain)
        myTabView?.delegate = self
        myTabView?.dataSource = self
        myTabView?.bounces = false
        myTabView?.layer.cornerRadius = 3
        myTabView?.layer.masksToBounds = true
        myTabView?.layer.borderWidth = 0.5
        myTabView?.layer.borderColor = UIColor.hexColor(with: "cdd9e6")?.cgColor
        myTabView?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(myTabView!)
        
        myTabView?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(tipsLabel.snp.bottom).offset(15)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(self.dataArray.count * 45)
        })
    }
    
    @objc private func someBtnAct(_ send: UIButton){
        let tag = send.tag
        switch tag {
        case 0://时间
            self.myTabView?.isEditing = false
            self.editBtn.setTitle("编辑", for: .normal)
            self.model.configArray = self.dataArray
            ConfigModel.shard.configArray = self.dataArray
            ConfigModel.shard.save()
            
            self.showYYYYMMDDPicker()
        case 1://班次
            
            self.myTabView?.isEditing = false
            self.editBtn.setTitle("编辑", for: .normal)
            self.model.configArray = self.dataArray
            ConfigModel.shard.configArray = self.dataArray
            ConfigModel.shard.save()
            
            var dataArray = [String]()
            var select = self.yearSelectIndex
            
            let oldType = ConfigModel.shard.configType
            let ms = ConfigModel.shard.configArray
            for i in 0..<ms.count{
                let m = ms[i]
                let type = m.type
                dataArray.append(type.rawValue)
                if oldType == type{
                    select = i
                }
            }
            self.showYearPicker(dataArray: dataArray, selectIndex: select)
        case 2:
            let editing = !self.myTabView!.isEditing
            self.myTabView?.isEditing = editing
            
            if editing{//开始编辑
                self.editBtn.setTitle("保存", for: .normal)
                self.isHaveEdit = true
            }else{//结束编辑
                self.editBtn.setTitle("编辑", for: .normal)
                self.model.configArray = self.dataArray
                ConfigModel.shard.configArray = self.dataArray
                ConfigModel.shard.save()
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idf = "ConfigTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: idf) as? ConfigTableViewCell
        if cell == nil{
            cell = Bundle.main.loadNibNamed("ConfigTableViewCell", owner: self, options: nil)?.last as? ConfigTableViewCell
        }
        cell?.selectionStyle = .none
        cell?.data = self.dataArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.dataArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
 
    var selecColorIndexPath: IndexPath?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ConfigTableViewCell{
            self.selecColorIndexPath = indexPath
            let color = self.dataArray[indexPath.row].color ?? UIColor.black
            self.popColors(send: cell, color: color)
        }
        
        
    }
    var navCtrl: UINavigationController?
    func popColors(send: UIView, color: UIColor){
        let colorSelectionController = MSColorSelectionViewController()
        navCtrl = UINavigationController(rootViewController: colorSelectionController)
        navCtrl?.navigationBar.barTintColor = UIColor.white//导航栏颜色
        navCtrl?.navigationBar.isTranslucent = false
        navCtrl?.modalPresentationStyle = .popover
        navCtrl?.popoverPresentationController?.delegate = self
        navCtrl?.popoverPresentationController?.sourceView = send
        navCtrl?.popoverPresentationController?.sourceRect = send.bounds
        navCtrl?.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        colorSelectionController.delegate = self
        colorSelectionController.color = color
        
        if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
            let doneBtn: UIBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("完成", comment: ""),
                style: UIBarButtonItem.Style.done,
                target: self,
                action: #selector(self.dismissAct)
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        self.present(navCtrl!, animated: true, completion: nil)
    }
    @objc private func dismissAct(){
        self.navCtrl?.dismiss(animated: true, completion: {
            self.navCtrl = nil
        })
    }
    
    func colorViewController(_ colorViewCntroller: MSColorSelectionViewController, didChange color: UIColor) {
        
        if let index = self.selecColorIndexPath{
            let hexStr = color.hexString
            var configs = self.model.configArray
            var m = configs[index.row]
            m.colorStr = hexStr ?? ""
            configs[index.row] = m
            ConfigModel.shard.configArray = configs
            ConfigModel.shard.save()
            
            typeBtn.setTitleColor(self.model.configTypeColor, for: .normal)
            
            self.dataArray = configs
            self.myTabView?.reloadData()
            
            self.isHaveEdit = true
        }
        
    }
    
    
    //TODO:选择时间（年月日）
    fileprivate func showYYYYMMDDPicker(){
        let rect = CGRect(x: 0, y: ScreenHeight - 235, width: ScreenWidth, height: 235)
        let picker = TrainsDatePicker(frame: rect, dataModel: .date)
    
        let min = "2018-01-01".toDate(type: .yyyy_MM_dd)
        
        picker.show(selectTime: Date(), minDate: min, maxDate: nil)
        picker.dateHandler = { [weak self](date) in
            self?.dateBtn.setTitle(date.toString(type: .yyyy_MM_dd), for: .normal)
            self?.model.configTime = date.toString(type: .yyyy_MM_dd).toDate(type: .yyyy_MM_dd)!
            ConfigModel.shard.save()
            
            self?.isHaveEdit = true
        }
    }
    
    //选择类型
    fileprivate var yearSelectIndex = 0
    fileprivate func showYearPicker(dataArray: [String], selectIndex: Int){
        let rect = CGRect(x: 0, y: ScreenHeight - 235, width: ScreenWidth, height: 235)
        let picker = TrainsFilterPicker(frame: rect)
        
        picker.show(dataArray: dataArray, selectIndex: selectIndex)
        picker.okHandler = { [weak self](index, value) in
            self?.yearSelectIndex = index
            self?.typeBtn.setTitle(value, for: .normal)
            let type = ConfigModel.shard.configArray[index].type
            ConfigModel.shard.configType = type
            
            self?.typeBtn.setTitleColor(ConfigModel.shard.configTypeColor, for: .normal)
            
            ConfigModel.shard.save()
            
            self?.isHaveEdit = true
        }
    }
}
