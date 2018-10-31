//
//  FunctionAtt.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/23.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

public let ScreenWidth     = UIScreen.main.bounds.width //屏幕宽度
public let ScreenHeight    = UIScreen.main.bounds.height //屏幕高度

public var navStatusHeight: CGFloat{
    return statusHeight + 44
}
public var statusHeight: CGFloat{
    return UIApplication.shared.statusBarFrame.height
}

//TODO:转json字符串
public func getJSONString(with data: Any)->String?{
    if !JSONSerialization.isValidJSONObject(data) {
        print("无法解析出JSONString")
        return nil
    }
    let data = try? JSONSerialization.data(withJSONObject: data, options: [])
    let jsonString = String(data: data!, encoding: .utf8)
    return jsonString
}

