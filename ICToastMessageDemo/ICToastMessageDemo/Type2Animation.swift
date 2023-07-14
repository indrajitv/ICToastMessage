//
//  Type2Animation.swift
//  ICToastMessageDemo
//
//  Created by Indrajit Chavda on 14/07/23.
//

import SwiftUI

struct Type2Animation: View {

    @State
    var show: Bool = false

    var body: some View {
        VStack {
            Button("Show") {
                self.show = true
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .setToastMessage(show: $show,
                         text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                         config: .init(type: .type2(damping: 0.6)))
    }
}

struct Type2Animation_Previews: PreviewProvider {
    static var previews: some View {
        Type2Animation()
    }
}
