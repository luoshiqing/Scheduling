//
//  HomeViewController.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/23.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit
import MJRefresh

enum RefreshType {
    case up//上拉加载更多
    case down//下拉刷新
}

class HomeViewController: BaseViewController, UICollectionViewDelegate ,UICollectionViewDataSource {

    
    private var myCollectionView: UICollectionView?
    private let idf = "CalendarCollectionViewCell"
    private let headIdf = "UICollectionElementKindSectionHeader"
    
    private let leftSpace: CGFloat = 15
    private lazy var oneItemWidth: CGFloat = {
        let count = CalendarData.weekdays.count
        let widht = (self.view.frame.width) / CGFloat(count)
        return widht
    }()
    
    private var dataArray = [[LsqCalendarModel?]]()
    
    private var stDatas = [[LsqCalendarModel?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "排班表"
        self.isShowBack = false
        self.setRightItem()
        self.loadTopWeekday()
        self.loadCollectionView()
        
        self.createDatas()
        
    }
    private func createDatas(){
        CalendarData.getBeforAndLastThreeMonth(date: Date()) { [weak self](models: [[LsqCalendarModel?]]) in
            self?.dataArray = models
      
            self?.myCollectionView?.reloadData()
            
        }
    }
   
    private func setRightItem(){
        let right = UIBarButtonItem(title: "配置", style: .plain, target: self, action: #selector(self.rightItemAct(_:)))
        self.navigationItem.rightBarButtonItem = right
    }
    @objc private func rightItemAct(_ send: UIBarButtonItem){
        let configVC = ConfigViewController()
        configVC.eidtHandler = { [weak self](str) in
            self?.createDatas()
        }
        self.navigationController?.pushViewController(configVC, animated: true)
    }
    private func loadTopWeekday(){
        let h: CGFloat = 40
        for i in 0..<CalendarData.weekdays.count{
            let day = CalendarData.weekdays[i]
            let x = CGFloat(i) * self.oneItemWidth
            let label = UILabel(frame: CGRect(x: x, y: self.navStatusHeigh, width: self.oneItemWidth, height: h))
            label.textColor = UIColor.hexColor(with: "#666666")
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            label.text = day
            self.view.addSubview(label)
        }
    }
    
    
    private func loadCollectionView(){
        //---UICollectionView---
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.oneItemWidth, height: 62)
        layout.minimumLineSpacing = 0 //上下间隔
        layout.minimumInteritemSpacing = 0 //左右间隔
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40) //头部间距
        layout.footerReferenceSize = CGSize(width: 0, height: 0) //尾部间距
        layout.sectionInset.left = 0
        layout.sectionInset.right = 0
        let rect = CGRect(x: 0, y: 40 + self.navStatusHeigh, width: self.view.frame.width, height: ScreenHeight - 40 - self.navStatusHeigh)
        myCollectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        myCollectionView?.backgroundColor = UIColor.clear
        myCollectionView?.delegate = self
        myCollectionView?.dataSource = self
        self.view.addSubview(myCollectionView!)
        let nib = UINib(nibName: self.idf, bundle: Bundle.main)
        myCollectionView?.register(nib, forCellWithReuseIdentifier: self.idf)
        
        myCollectionView?.register(HeadCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headIdf)
        
        myCollectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            
            if let firsts = self.dataArray.first{
                var first: LsqCalendarModel?
                for m in firsts{
                    if m != nil{
                        first = m
                        break
                    }
                }
                if let f = first{
                    var ms = CalendarData.getBeforeModelArray(beforeDate: f.date)
                    ms += self.dataArray
                    self.dataArray = ms
                    self.endRefresh(with: .down)
                    
                    self.myCollectionView?.reloadData()
                }else{
                    self.endRefresh(with: .down)
                }
            }else{
                self.endRefresh(with: .down)
            }
        })
        
        myCollectionView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            if let last = self.dataArray.last?.last??.date{
                let ms = CalendarData.getLastModelArray(lastDate: last)
                self.endRefresh(with: .up)
                self.dataArray += ms
                self.myCollectionView?.reloadData()
   
            }
        })
        
    }
    
    //用于设置上下拉刷新完成
    private func endRefresh(with type: RefreshType){
        switch type {
        case .down:
            self.myCollectionView?.mj_header.endRefreshing()
        case .up:
            self.myCollectionView?.mj_footer.endRefreshing()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.idf, for: indexPath) as! CalendarCollectionViewCell
        
        cell.data = self.dataArray[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView?
        
        if kind == UICollectionView.elementKindSectionHeader{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headIdf, for: indexPath)
            
//            reusableview?.backgroundColor = UIColor.yellow
            let text = self.dataArray[indexPath.section].last??.date.toString(type: TimeFormat.yyyy_MM)
            
            (reusableview as? HeadCollectionReusableView)?.dateLabel?.text = text
            
        }
        
        return reusableview!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}
