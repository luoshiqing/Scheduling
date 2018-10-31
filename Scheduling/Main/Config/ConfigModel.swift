//
//  ConfigModel.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/23.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

enum ConfigType: String, CaseIterable, Codable {
    case dayShift   = "白班"
    case middle     = "中班"
    case evening    = "夜班"
    case out        = "出班"
    case rest       = "休班"
}



class ConfigModel: NSObject {
    static let LsqConfigKey = "ConfigModelKey"
    static fileprivate let configModel = ConfigModel()
    public class var shard: ConfigModel{
        return configModel
    }
    
    fileprivate override init(){
        super.init()
    }
    
    
    var configArray = [ConfigTypeModel(type: .dayShift, colorStr: "#424FFF"),
                       ConfigTypeModel(type: .middle, colorStr: "#F3CCFF"),
                       ConfigTypeModel(type: .evening, colorStr: "#FF754F"),
                       ConfigTypeModel(type: .out, colorStr: "#ABBCFF"),
                       ConfigTypeModel(type: .rest, colorStr: "#46FFAB")]
    var configTime = Date()
    var configType = ConfigType.dayShift
    
    var configTypeColor: UIColor?{
        for m in self.configArray{
            let type = m.type
            if type == self.configType{
                return m.color
            }
        }
        return nil
    }
    
    public func save(){
        var configDics = [[String:String]]()
        for m in self.configArray{
            if let dic = LsqEncoder.encoder(toDictionary: m) as? [String:String]{
                configDics.append(dic)
            }
        }
        let dic: [String:Any] = ["configTime":self.configTime.toString(type: TimeFormat.yyyy_MM_dd),
                                 "configArray":configDics,
                                 "configType":self.configType.rawValue]
        guard let jsStr = getJSONString(with: dic) else{
            return
        }
        UserDefaults.standard.set(jsStr, forKey: ConfigModel.LsqConfigKey)
    }
    
    public class func loading(){
        guard let jsStr = UserDefaults.standard.value(forKey: ConfigModel.LsqConfigKey) as? String else {
            return
        }
        guard let dic = jsStr.dictionary else {
            return
        }
        let configType = dic["configType"] as! String
        let configTime = dic["configTime"] as! String
        let configArray = dic["configArray"] as! [[String:String]]
        
        if let date = configTime.toDate(type: TimeFormat.yyyy_MM_dd){
            ConfigModel.shard.configTime = date
        }
        let types = ConfigType.allCases
        for cs in types{
            if cs.rawValue == configType{
                ConfigModel.shard.configType = cs
                break
            }
        }
        
        if let cfArray = LsqDecoder.decode(ConfigTypeModel.self, array: configArray){
            ConfigModel.shard.configArray = cfArray
        }
 
    }
    
}



struct ConfigTypeModel: Codable {
    var type: ConfigType
    var colorStr: String
    
    
    var color: UIColor?{
        return UIColor.hexColor(with: self.colorStr)
    }
    
}


struct LsqDecoder {
    //TODO:转换模型(单个)
    public static func decode<T>(_ type: T.Type, param: [String:Any]) -> T? where T: Decodable{
        guard let jsonData = self.getJsonData(with: param) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            return nil
        }
        return model
    }
    //多个
    public static func decode<T>(_ type: T.Type, array: [[String:Any]]) -> [T]? where T: Decodable{
        if let data = self.getJsonData(with: array){
            if let models = try? JSONDecoder().decode([T].self, from: data){
                return models
            }
        }else{
            print("模型转换->转换data失败")
        }
        return nil
    }
    static fileprivate func getJsonData(with param: Any)->Data?{
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}

struct LsqEncoder {
    public static func encoder<T>(toString model: T) ->String? where T: Encodable{
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else{
            return nil
        }
        guard let jsonStr = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonStr
    }
    public static func encoder<T>(toDictionary model: T) ->[String:Any]? where T: Encodable{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else{
            return nil
        }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any] else{
            return nil
        }
        
        return dict
    }
}
