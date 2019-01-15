//
//  StringExtension.swift
//  UltimateLog
//
//  Created by Peigen.Liu on 1/15/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

import Foundation


extension String {
    public static func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
}
