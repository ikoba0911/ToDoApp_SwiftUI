//
//  Binding.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/21.
//

import SwiftUI

extension Binding {
    
    // 任意のBindingの値を取得した際に、nilでなければ値をset、defaultValueと設定された値が同じであればtrueを返却
    init<T>(isNotNil source: Binding<T?>, defaultValue: T) where Value == Bool {
        self.init(get: { source.wrappedValue != nil },
                  set: { source.wrappedValue = $0 ? defaultValue : nil })
    }
    
    // Optional型の値を受け取った場合に、defaultValueが設定されていたらその値をそのままセットする
    init(source: Binding<Value?>, defaultValue: Value) {
        self.init(get: {
            if source.wrappedValue == nil {
                source.wrappedValue = defaultValue
            }
            return source.wrappedValue ?? defaultValue
        }, set: {
            source.wrappedValue = $0
        })
    }
}
