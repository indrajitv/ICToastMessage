//
//  WithButtonsCombo.swift
//  ICToastMessageDemo
//
//  Created by Indrajit Chavda on 14/07/23.
//

import SwiftUI

struct WithButtonsCombo: View {

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
                         buttons: [.withTitle(title: "Setting", onTap: didTapSettingButton),
                                   .withTitle(title: "Details", onTap: didTapDetailsButton)
                                  ])
    }

    func didTapSettingButton() {

    }

    func didTapDetailsButton() {

    }
}

struct WithButtonsCombo_Previews: PreviewProvider {
    static var previews: some View {
        WithButtonsCombo()
    }
}
