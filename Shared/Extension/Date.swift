//
//  Date.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/26.
//

import Foundation

extension Date {
    // 「時分秒」を切り捨てて今日の日付を作成
    static var today: Date {
        let calender = Calendar(identifier: .gregorian)
        let time = Date()
        return calender.startOfDay(for: time)
    }
    
    // 「時分秒」を切り捨てて明日の日付を作成
    static var tomorrow: Date {
        let calender = Calendar(identifier: .gregorian)
        guard let tomorrow = calender.date(byAdding: DateComponents(day: 1), to: Date.today) else {
            return Date.today
        }
        return tomorrow
    }
}
