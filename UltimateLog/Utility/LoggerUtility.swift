//
//  LoggerUtility.swift
//  UltimateLog
//
//  Created by Peigen.Liu on 1/15/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

import Foundation


struct LoggerUtility {
    
    static func printInitInfo() {
        UltimateLog.v(msg: "===========  Ultimate Log - Init Infomation ===========")
        UltimateLog.v(msg: "Device Name : " + UIDevice.current.name)
        UltimateLog.v(msg: "System Version : " + UIDevice.current.systemVersion)
        UltimateLog.v(msg: "Device Model : " + UIDevice.current.model)
        UltimateLog.v(msg: "Model Name: " + UIDevice.current.modelName)

        let infoDic = Bundle.main.infoDictionary
        UltimateLog.v(msg: "App Version : " + (infoDic?["CFBundleShortVersionString"] as? String ?? ""))
        UltimateLog.v(msg: "Build Version : " + (infoDic?["CFBundleVersion"] as? String ?? ""))
        UltimateLog.v(msg: "App Identifier : " + (infoDic?["CFBundleIdentifier"] as? String ?? ""))
        UltimateLog.v(msg: "App Name : " + (infoDic?["CFBundleName"] as? String ?? ""))
        UltimateLog.v(msg: "===========  Ultimate Log - Init Infomation Done ===========")
        UltimateLog.v(msg: "\n\n\n\n")

        
        startMemoryMonitor()
        setCrashHandler()
    }
    
    static func startMemoryMonitor() {
        let deadlineTime = DispatchTime.now() + .seconds(30)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            reportMemory()
        }
    }
    
    
    
    static func reportMemory() {

        var info = mach_task_basic_info()
        let MACH_TASK_BASIC_INFO_COUNT = MemoryLayout<mach_task_basic_info>.stride/MemoryLayout<natural_t>.stride
        var count = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: MACH_TASK_BASIC_INFO_COUNT) {
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          $0,
                          &count)
            }
        }
        UltimateLog.v(msg: "===========  Ultimate Log - Memory Infomation  ===========")

        if kerr == KERN_SUCCESS {
            UltimateLog.v(msg: String(format: "Memory Usage : %ld MB(%ld KB) ", info.resident_size/1024/1024, info.resident_size/1024))


        }
        else {
            UltimateLog.v(msg: "Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
        }
        UltimateLog.v(msg: "===========  Ultimate Log - Memory Infomation Done ===========")
        UltimateLog.v(msg: "\n\n\n\n")
        
       
    }
    
    
    

    static func setCrashHandler() {
        reportMemory()
        NSSetUncaughtExceptionHandler { (exception) in
            let arr:NSArray = exception.callStackSymbols as NSArray
            let reason:String = exception.reason!
            let name:String = exception.name.rawValue
            let date:NSDate = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "YYYY/MM/dd hh:mm:ss SS"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            let url:String = String.init(format: "\n❌❌❌❌❌❌❌❌  FATAL ERROR  ❌❌❌❌❌❌❌❌\nTime:%@\nName:%@\nReason:\n%@\nCallStackSymbols:\n%@",strNowTime,name,reason,arr.componentsJoined(by: "\n"))
            
            UltimateLog.e(msg: url)

        }
    }
}


public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone Xs"
        case "iPhone11,4", "iPhone11,6":                return "iPhone Xs Max"
        case "iPhone11,8":                              return "iPhone XR"
            
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12 Inch2"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10 Inch"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro 11 Inch"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro 12 Inch3"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    
}


