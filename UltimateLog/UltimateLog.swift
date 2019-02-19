//
//  Logger.swift
//  UltimateLog
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

import Foundation

@objc public enum FilterLevel : Int{
    case Verbose = 0
    case Debug
    case Info
    case Warn
    case Error
    case Fatal
    case All
}



@objc open class UltimateLog : NSObject {
    @objc public static let `default` = UltimateLog()

    static let _mars = MarsWapper()
    static var tag = ""
    private var _encryptKey : Data? = nil
    static let logPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/UltimateLog/"
    static var logsCount = 0;
    

    
    
    @objc public static func setup(prefix : String = "", filterLevel : FilterLevel = .Verbose, encryptSeed : String? = nil){
        if encryptSeed != nil && !(encryptSeed?.isEmpty)! {
            let encryptSeed = encryptSeed!
            UltimateLog.default.plantEncryptSeed(seed: encryptSeed)
        }
        _mars.initXloggerFilterLevel(Int32(filterLevel.rawValue), path: logPath, prefix: prefix)
        LoggerUtility.printInitInfo()
    }
    
    @objc public static func v(tag : String = "ULog" , msg : String){
        logsCountPlus()
        
        printLog(level: .Verbose, tag: tag, msg: msg)
        
        guard let encryptMsg = UltimateLog.default.encrypt(string: msg) else {
            _mars.log(Int32(FilterLevel.Verbose.rawValue), tag: tag, content: msg)
            return
        }
        _mars.log(Int32(FilterLevel.Verbose.rawValue), tag: tag, content: encryptMsg)
    }
    @objc public let v = {(_ tag : String , _ msg : String) in
        UltimateLog.v(tag: tag, msg: msg)
    }
    
    
    
    @objc public static func d(tag : String = "ULog" , msg : String){
        logsCountPlus()
        
        
        printLog(level: .Debug, tag: tag, msg: msg)
        
        guard let encryptMsg = UltimateLog.default.encrypt(string: msg) else {
            _mars.log(Int32(FilterLevel.Debug.rawValue), tag: tag, content: msg)
            return
        }
        _mars.log(Int32(FilterLevel.Debug.rawValue), tag: tag, content: encryptMsg)
    }
    @objc public let d = {(_ tag : String , _ msg : String) in
        UltimateLog.d(tag: tag, msg: msg)
    }
    
    
    
    
    
    
    @objc public static func i(tag : String = "ULog" , msg : String){
        logsCountPlus()
        
        
        printLog(level: .Info, tag: tag, msg: msg)
        
        guard let encryptMsg = UltimateLog.default.encrypt(string: msg) else {
            _mars.log(Int32(FilterLevel.Info.rawValue), tag: tag, content: msg)
            return
        }
        _mars.log(Int32(FilterLevel.Info.rawValue), tag: tag, content: encryptMsg)
    }
    @objc public let i = {(_ tag : String , _ msg : String) in
        UltimateLog.i(tag: tag, msg: msg)
    }
    
    
    
    
    
    @objc public static func w(tag : String = "ULog" , msg : String){
        logsCountPlus()
        
        
        printLog(level: .Warn, tag: tag, msg: msg)
        
        guard let encryptMsg = UltimateLog.default.encrypt(string: msg) else {
            _mars.log(Int32(FilterLevel.Warn.rawValue), tag: tag, content: msg)
            return
        }
        _mars.log(Int32(FilterLevel.Warn.rawValue), tag: tag, content: encryptMsg)
        _mars.flush()
    }
    @objc public let w = {(_ tag : String , _ msg : String) in
        UltimateLog.w(tag: tag, msg: msg)
    }
    
    
    
    
    @objc public static func e(tag : String = "ULog" , msg : String){
        logsCountPlus()
        
        
        printLog(level: .Error, tag: tag, msg: msg)
        
        guard let encryptMsg = UltimateLog.default.encrypt(string: msg) else {
            _mars.log(Int32(FilterLevel.Error.rawValue), tag: tag, content: msg)
            return
        }
        _mars.log(Int32(FilterLevel.Error.rawValue), tag: tag, content: encryptMsg)
        _mars.flush()
    }
    @objc public let e = {(_ tag : String , _ msg : String) in
        UltimateLog.e(tag: tag, msg: msg)
    }
    
}



// MARK: -  Open Interface
extension UltimateLog{
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
        NSLog(levelStr + "[\(tag)]  " + msg);
    }
}



// MARK: - Encryption
extension UltimateLog {
    
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
        if _encryptKey == nil {
            return string
        }
        
        guard let _encryptKey = _encryptKey ,_encryptKey.count == 32 , let string = AES.encrypt(string: string, keyData: _encryptKey) else {
            return nil
        }
        return "[[[" + string + "]]]"
    }
}



// MARK: - Zip
extension UltimateLog {
    
    @objc open class func zipLog() -> String?{
        let tmpDir = NSTemporaryDirectory()

        
        let fileManager = FileManager()
        let sourceURL = URL(fileURLWithPath: UltimateLog.logPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH:mm:ss"
        let destPath = dateFormatter.string(from: Date()) + "_" + String.randomString(length: 8) + ".zip"
        let destinationURL = URL(fileURLWithPath: tmpDir + destPath)
        


        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try? fileManager.removeItem(at: destinationURL)
            }
            try? fileManager.createDirectory(atPath: tmpDir, withIntermediateDirectories: true, attributes: nil)
            
            try fileManager.zipItem(at: sourceURL, to: destinationURL)
            
        } catch {
            print("Creation of ZIP archive failed with error:\(error)")
            return nil
        }
        
        return destinationURL.path
    }
    
}


// MARK: - Flush
extension UltimateLog {
    static func logsCountPlus() {
        logsCount = logsCount + 1;
        
        if logsCount > 30 {
            _mars.flush()
            
            logsCount = 0;
        }
    }
}
