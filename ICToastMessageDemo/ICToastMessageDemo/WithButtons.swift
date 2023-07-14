//
//  WithButtons.swift
//  ICToastMessageDemo
//
//  Created by Indrajit Chavda on 14/07/23.
//

import SwiftUI

struct WithButtons: View {

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
                         buttons: [.withTitle(title: "Setting", onTap: didTapSettingButton)],
                         config: .init(type: .type1,
                                       autoHideTime: 3,
                                       hideOnButtonClick: true,
                                       tapOnToHide: true,
                                       backgroundColor: .blue,
                                       contentTextColor: .white,
                                       buttonTextColor: .white,
                                       textFont: .title2,
                                       buttonFont: .title,
                                       presentingAlignment: .bottom,
                                       cornerRadius: 6,
                                       initialInvisibleYOffset: 500,
                                       visibleYOffset: 30))
    }

    func didTapSettingButton() {

    }
}

struct WithButtons_Previews: PreviewProvider {
    static var previews: some View {
        WithButtons()
    }
}
