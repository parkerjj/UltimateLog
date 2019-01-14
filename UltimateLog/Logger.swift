//
//  Logger.swift
//  UltimateLog
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

import Foundation

public enum FilterLevel : Int{
    case Verbose = 0
    case Debug
    case Info
    case Warn
    case Error
    case Fatal
    case All
}


@objc open class Logger : NSObject {
    static let `default` = Logger()
    static let _mars = MarsWapper()
    static var tag = ""
    private var _encryptKey : Data = Data()
    
    
    
    open class func setup(prefix : String = "", filterLevel : FilterLevel = .Verbose, encryptSeed : String? = nil){
        if encryptSeed != nil && !(encryptSeed?.isEmpty)! {
            let encryptSeed = encryptSeed!
            Logger.default.plantEncryptSeed(seed: encryptSeed)
            
            
            var logPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            logPath = logPath + "/UltimateLog/"
            print(logPath)

            _mars.initXloggerFilterLevel(UInt(filterLevel.rawValue), path: logPath, prefix: prefix)
        }
    }
    
    open class func v(tag : String = "ULog" , msg : String){
        printLog(level: .Verbose, tag: tag, msg: msg)

        guard let msg = Logger.default.encrypt(string: msg) else {return}
        _mars.log(UInt(FilterLevel.Verbose.rawValue), tag: tag, content: msg)
    }
    
    open class func d(tag : String = "ULog" , msg : String){
        printLog(level: .Debug, tag: tag, msg: msg)

        guard let msg = Logger.default.encrypt(string: msg) else {return}
        _mars.log(UInt(FilterLevel.Debug.rawValue), tag: tag, content: msg)
    }
    
    open class func i(tag : String = "ULog" , msg : String){
        printLog(level: .Info, tag: tag, msg: msg)

        guard let msg = Logger.default.encrypt(string: msg) else {return}
        _mars.log(UInt(FilterLevel.Info.rawValue), tag: tag, content: msg)

    }
    
    open class func w(tag : String = "ULog" , msg : String){
        printLog(level: .Warn, tag: tag, msg: msg)

        guard let msg = Logger.default.encrypt(string: msg) else {return}
        _mars.log(UInt(FilterLevel.Warn.rawValue), tag: tag, content: msg)
        _mars.flush()
    }
    
    open class func e(tag : String = "ULog" , msg : String){
        printLog(level: .Error, tag: tag, msg: msg)

        guard let msg = Logger.default.encrypt(string: msg) else {return}
        _mars.log(UInt(FilterLevel.Error.rawValue), tag: tag, content: msg)
        _mars.flush()
    }
    
    
    private class func printLog(level : FilterLevel , tag : String , msg : String){
        var levelStr : String
        switch level {
        case .Verbose:
            levelStr = "[V]"
            
        case .Debug:
            levelStr = "[D]"
            
        case .Info:
            levelStr = "[I]"
            
        case .Warn:
            levelStr = "⚠️[W]"
            
        case .Error:
            levelStr = "❌[E]"
            
            
        default:
            return
        }
        NSLog(levelStr + " " + msg);
    }
    
}


extension Logger {
    
    private func plantEncryptSeed( seed : String?) {
        guard let seed = seed else {
            return
        }
        let password = (seed.sha256() + seed).uppercased().data(using: .utf8)?.sha256()
        let originKey = seed.sha256()
        
        guard let ek = AES.encrypt(string: originKey, keyData: password!) else {
            return
        }
        
        _encryptKey = (ek.data(using: .utf8)?.sha256())!
    }
    
    
    private func encrypt(string : String) -> String?{
        guard _encryptKey.count == 32 , let string = AES.encrypt(string: string, keyData: _encryptKey) else {
            return nil
        }
        return string
    }
}

