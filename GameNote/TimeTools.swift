//
//  TimeTools.swift
//  testPlayWithTime
//
//  Created by 劉進泰 on 2017/7/26.
//  Copyright © 2017年 劉進泰. All rights reserved.
//

import Foundation

class TimeTools: NSObject {
    
    private let dateComponents:DateComponents = DateComponents()
    private let dateFormatter:DateFormatter = DateFormatter()
    private let dateComponentFormater:DateComponentsFormatter = DateComponentsFormatter()
    
    private var limitTimeInterval:Double = 0
    
    var userDefault:UserDefaults = UserDefaults.standard
    let savedTimeKey:String = "savedtime"
    
    override init() {
        super.init()
        setupTools()
    }
    
    private func setupTools() {
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        dateComponentFormater.unitsStyle = .short
        dateComponentFormater.allowedUnits = [.day, .hour, .minute, .second]
    }
    
    //根據給予的限制值，將現在時間與給予的時間做比較，超過限制值就回傳 true
    func isTimeOver(limit:Double) -> Bool {
        print("isTimeOver 執行")
        limitTimeInterval = limit
        
        var result:Bool = false
        
        if let lastSavedDateString = userDefault.object(forKey: savedTimeKey) as? String {
            let lastSavedDate:Date = dateFormatter.date(from: lastSavedDateString)!
            result = Date().timeIntervalSince(lastSavedDate) > limitTimeInterval
            print("從上次更新時間距今已經:\(Date().timeIntervalSince(lastSavedDate))秒，更新？ > \(result)")
        }else {
            result = false
        }
        
        saveNowToUserDefault()
        return result
    }
    
    func saveNowToUserDefault() {
        let nowDateString:String = dateFormatter.string(from: Date())
        userDefault.set(nowDateString, forKey: savedTimeKey)
        print("儲存更新日期^\(nowDateString)^成功 (at TimeTools.swift)")
    }
}
