//
//  CalendarData.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/25.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

struct LsqCalendarModel {
    let day: Int
    let date: Date
    let isToday: Bool
    let type: ConfigType
}


struct CalendarData {
    
    static let weekdays = ["日","一","二","三","四","五","六"]

    //TODO:获取当前时间的月份以及前后3个月的
    public static func getBeforAndLastThreeMonth(date: Date, success: (([[LsqCalendarModel?]])->Swift.Void)?){
        MBProgressHUD.showState("正在生成数据...", to: UIApplication.shared.keyWindow)
        DispatchQueue.global().async {
            let dates = self.getMonthStartEndDate(date: date)
            let index = self.weekDayIndex(date: dates.start)
            
            var modelArray = [LsqCalendarModel?]()
            
            if index != 0{
                for _ in 0..<index{
                    modelArray.append(nil)
                }
            }
            
            //当前月份
            let startTimeInterval = dates.start.timeIntervalSince1970
            let endTimeInterval = dates.end.timeIntervalSince1970
            
            var currentTimeInterval = startTimeInterval
            var day = 1
            while currentTimeInterval <= endTimeInterval {
                let date = Date(timeIntervalSince1970: currentTimeInterval)
                let isToday = self.isToday(date: date)
                let type = self.getConfigType(date: date)
                let m = LsqCalendarModel(day: day, date: date, isToday: isToday, type: type)
                modelArray.append(m)
                currentTimeInterval += 24 * 60 * 60
                day += 1
            }
            var lastDatas = self.getLastModelArray(lastDate: dates.end)
            
            lastDatas.insert(modelArray, at: 0)
            
//            var beforeModelArray = self.getBeforeModelArray(beforeDate: dates.start)
            
//            beforeModelArray += lastDatas
            
            DispatchQueue.main.async {
                MBProgressHUD.hidden(to: UIApplication.shared.keyWindow!)
                success?(lastDatas)
            }
            
        }
   
    }
    
    //获取前1个月
    static func getBeforeModelArray(beforeDate: Date)->[[LsqCalendarModel?]]{
        
        var lastDate = beforeDate
        var lastArray = [[LsqCalendarModel?]]()
        var lastDay = self.getBeforeDay(date: lastDate)
        for _ in 0..<1{
            var lasts = [LsqCalendarModel?]()
            let dates = self.getMonthStartEndDate(date: lastDay)
            let index = self.weekDayIndex(date: dates.start)
            
            if index != 0{
                for _ in 0..<index{
                    lasts.append(nil)
                }
            }
            //当前月份
            let startTimeInterval = dates.start.timeIntervalSince1970
            let endTimeInterval = dates.end.timeIntervalSince1970
            
            var currentTimeInterval = startTimeInterval
            var day = 1
            while currentTimeInterval <= endTimeInterval {
                let date = Date(timeIntervalSince1970: currentTimeInterval)
                let isToday = self.isToday(date: date)
                
                let type = self.getConfigType(date: date)
                let m = LsqCalendarModel(day: day, date: date, isToday: isToday, type: type)
                lasts.append(m)
                currentTimeInterval += 24 * 60 * 60
                day += 1
            }
            lastArray.append(lasts)
            lastDate = dates.start
            lastDay = self.getBeforeDay(date: dates.start)
        }
        return lastArray.reversed()
    }
    
    //获取后6个月
    static func getLastModelArray(lastDate: Date)->[[LsqCalendarModel?]]{
        var lastDate = lastDate
        var lastArray = [[LsqCalendarModel?]]()
        var lastDay = self.getLastDay(date: lastDate)
        for _ in 0..<6{
            var lasts = [LsqCalendarModel?]()
            let dates = self.getMonthStartEndDate(date: lastDay)
            let index = self.weekDayIndex(date: dates.start)
            
            if index != 0{
                for _ in 0..<index{
                    lasts.append(nil)
                }
            }
            //当前月份
            let startTimeInterval = dates.start.timeIntervalSince1970
            let endTimeInterval = dates.end.timeIntervalSince1970
            
            var currentTimeInterval = startTimeInterval
            var day = 1
            while currentTimeInterval <= endTimeInterval {
                let date = Date(timeIntervalSince1970: currentTimeInterval)
                let isToday = self.isToday(date: date)
                
                let type = self.getConfigType(date: date)
                let m = LsqCalendarModel(day: day, date: date, isToday: isToday, type: type)
                lasts.append(m)
                currentTimeInterval += 24 * 60 * 60
                day += 1
            }
            lastArray.append(lasts)
            lastDate = dates.end
            lastDay = self.getLastDay(date: dates.end)
        }
        return lastArray
    }

    //获取前一天
    static func getBeforeDay(date: Date)->Date{
        let time = date.timeIntervalSince1970 - 24 * 60 * 60
        let end = Date(timeIntervalSince1970: time)
        return end
    }
    //获取后一天
    static func getLastDay(date: Date)->Date{
        let time = date.timeIntervalSince1970 + 24 * 60 * 60
        let end = Date(timeIntervalSince1970: time)
        return end
    }

    
    static func isToday(date: Date)->Bool{
        let st1 = date.toString(type: .yyyy_MM_dd)
        let curent = Date().toString(type: .yyyy_MM_dd)
        if st1 == curent{
            return true
        }
        return false
    }
    static func getConfigType(date: Date)->ConfigType{
        var allCase = [ConfigType]()//设置的类型排序
        var configIndex = 0//设置的下标
        let modelShare = ConfigModel.shard
        let configType = modelShare.configType
        for i in 0..<modelShare.configArray.count{
            let m = modelShare.configArray[i]
            let type = m.type
            allCase.append(type)
            if configType == type{
                configIndex = i
            }
        }
        let configTime = modelShare.configTime.toString(type: .yyyy_MM_dd).toDate(type: .yyyy_MM_dd)!
        let curetTime = date.toString(type: .yyyy_MM_dd).toDate(type: .yyyy_MM_dd)!
        
        let setTimeInterval = configTime.timeIntervalSince1970
        let currentTimeInterval = curetTime.timeIntervalSince1970
        
        let cha = currentTimeInterval - setTimeInterval
        let days = Int(cha / (24 * 60 * 60))
        if days < 0{
            let selectIndex = configIndex + days
            
            if selectIndex >= 0{
                let type = allCase[selectIndex]
                return type
            }else{
                
                var shan = abs(selectIndex) / allCase.count
            
                let mm = abs(selectIndex) % allCase.count
                if mm != 0{
                    shan += 1
                }
                let okIndex = selectIndex + allCase.count * shan
                let type = allCase[okIndex]
                return type
                
            }
        }else{
            let selectIndex = configIndex + days
            let okIndex = selectIndex % allCase.count
            let type = allCase[okIndex]
            return type
        }
    }
    
    
    //TODO:获取当前月份的起始结束日期
    public static func getMonthStartEndDate(date: Date)->(start: Date, end: Date){
        let dformatter = DateFormatter()
        dformatter.dateFormat = TimeFormat.yyyy_MM.rawValue
        //当前时间
        let yyyymm = dformatter.string(from: date)
        let yearMonth = yyyymm.components(separatedBy: "-")
        var year = Int(yearMonth[0]) ?? 1
        let month = Int(yearMonth[1]) ?? 1
        var nextMont = 1
        if month == 12{
            year += 1
            nextMont = 1
        }else{
            nextMont = month + 1
        }
        let nextYyyymm = "\(year)" + "-" + "\(nextMont)"
        let curretn = yyyymm.toDate(type: .yyyy_MM)
        let next = nextYyyymm.toDate(type: .yyyy_MM)
        let dformatter1 = DateFormatter()
        dformatter1.dateFormat = TimeFormat.yyyy_MM_dd.rawValue
        let nextInterval = next!.timeIntervalSince1970 - 24 * 60 * 60
        let nextDate = Date(timeIntervalSince1970: nextInterval)
        return (start: curretn!, end: nextDate)
    }
    //获取当前月份第一天的星期的下标位置
    public static func weekDayIndex(date: Date)->Int{
        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let timeZone = TimeZone.current
        calendar.timeZone = timeZone
        let theComponents = calendar.component(.weekday, from: date)
        return theComponents - 1
    }
    
    
}
