//
//  Extension.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/23.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit
extension UIViewController {
    var navStatusHeigh: CGFloat{
        return self.statusHeigh + navHeigh
    }
    var statusHeigh: CGFloat{
        return UIApplication.shared.statusBarFrame.height
    }
    var navHeigh: CGFloat{
        if self.navigationController == nil {
            return 0
        }else{
            return self.navigationController!.navigationBar.frame.height
        }
    }
}
//MARK:UIColor扩展
extension UIColor {
    //16进制颜色
    @objc public class func hexColor(with string:String)->UIColor? {
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.count < 6{
            return nil
        }
        if cString.hasPrefix("0X"){
            let index = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[index...])
        }
        if cString .hasPrefix("#"){
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[index...])
        }
        if cString.count != 6{
            return nil
        }
        let rString = String(cString[cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)])
        let gString = String(cString[cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)])
        let bString = String(cString[cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)])
        
        var r:CUnsignedInt = 0 ,g:CUnsignedInt = 0 ,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    //RGB颜色
    @objc class func rgbColor(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    public class var navColor: UIColor{
        return self.hexColor(with: "#20a0ff")!
    }
    public var hexString: String?{
        let cgColor = self.cgColor
        guard let components = cgColor.components else{
            return nil
        }

        if components.count == 4{
            let R = Int(components[0] * 255.0)
            let G = Int(components[1] * 255.0)
            let B = Int(components[2] * 255.0)
            
            var r = String(format: "%0X", R)
            var g = String(format: "%0X", G)
            var b = String(format: "%0X", B)
            
            if r == "0"{
                r = "00"
            }
            if g == "0"{
                g = "00"
            }
            if b == "0"{
                b = "00"
            }
            
            let hex = "#\(r)\(g)\(b)"
            return hex
        }
        
        return nil
    }
}
extension UIDevice{
    //是否是iPhone X
    class func isX()->Bool{
        if ScreenHeight == 812 && ScreenWidth == 375 {
            return true
        }
        return false
    }
}
extension String{
    //json字符串转换成字典
    var dictionary: [String:Any]?{
        guard let data = self.data(using: .utf8) else{ return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else{
            return nil
        }
        return dict
    }
    //字符串转date
    func toDate(type: TimeFormat)->Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        let date = formatter.date(from: self)
        return date
    }
}

extension MBProgressHUD{
    class func showError(_ message: String, to view: UIView?, delay: TimeInterval = 1){
        guard let v = view else {
            return
        }
        let mb = MBProgressHUD.showAdded(to: v, animated: true)
        mb?.labelText = message
        mb?.mode = .text
        mb?.removeFromSuperViewOnHide = true
        mb?.hide(true, afterDelay: delay)
    }
    class func showState(_ message: String, to view: UIView?){
        guard let v = view else {
            return
        }
        let mb = MBProgressHUD.showAdded(to: v, animated: true)
        mb?.labelText = message
    }
    class func hidden(to view: UIView){
        MBProgressHUD.hideAllHUDs(for: view, animated: false)
    }
}

extension Date{
    //转字符串格式
    func toString(type: TimeFormat)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = type.rawValue
        let dateStr = dateFormat.string(from: self)
        return dateStr
    }
}
//时间戳转换
enum TimeFormat: String {
    //y表示年份，m表示月份，d表示日，h表示小时，m表示分钟，s表示秒
    case yyyy_MM_dd_HH_mm_ss    = "yyyy-MM-dd HH:mm:ss"
    case yyyy_MM_dd_HH_mm       = "yyyy-MM-dd HH:mm"
    case yyyy_MM_dd_HH          = "yyyy-MM-dd HH"
    case yyyy_MM_dd             = "yyyy-MM-dd"
    case yyyyMMdd               = "yyyy.MM.dd"
    case yyyyMM                 = "yyyy.MM"
    case yyyy_MM                = "yyyy-MM"
    case HH_mm                  = "HH:mm"
    case yyyy                   = "yyyy"
    case MM                     = "MM"
}
