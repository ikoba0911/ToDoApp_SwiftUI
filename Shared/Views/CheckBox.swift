//
//  CheckBox.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/16.
//

import SwiftUI

struct CheckBox<Label>: View where Label: View{
    
    // MARK: - Property
    @Binding private var checked: Bool
    private var label: ()-> Label
    
    // MARK: - Init
    init(
        checked: Binding<Bool>,
        @ViewBuilder label: @escaping ()-> Label
    ) {
        self._checked = checked
        self.label = label
    }
    
    // MARK: - View
    var body: some View {
        HStack {
            Image(systemName: checked ? "checkmark.circle" : "circle")
                .onTapGesture {
                    self.checked.toggle()
            }
            label()
        }
    }
}

#if DEBUG
struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CheckBox(checked: .constant(false)) {
                Text("ジョギング")
            }
            CheckBox(checked: .constant(true)) {
                Image(systemName: "hand.thumbsup")
            }
        }
    }
}
#endif
