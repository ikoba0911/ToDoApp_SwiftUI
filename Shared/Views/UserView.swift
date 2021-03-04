//
//  UserView.swift
//  ToDoApp_SwiftUI (iOS)
//
//  Created by IkkiKobayashi on 2021/02/18.
//

import SwiftUI

struct UserView: View {
    
    let image: Image
    let userName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello".localized)
                    .foregroundColor(Color.white)
                    .font(.footnote)
                Text(String(format: "UserName".localized,
                            userName))
                    .foregroundColor(Color.white)
                    .font(.title)
            }
            Spacer()
            image
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
        }
        .padding()
        .background(Color.green)
    }
}

#if DEBUG
struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            UserView(image: Image("swift"),
                     userName: "SwiftToDo")
            Circle()
        }
    }
}
#endif
