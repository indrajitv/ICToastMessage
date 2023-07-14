//
//  WithButtonImage.swift
//  ICToastMessageDemo
//
//  Created by Indrajit Chavda on 14/07/23.
//

import SwiftUI

struct WithButtonImage: View {

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
                         buttons: [.withImage(image: .init(systemName: "gear"),
                                              size: .init(width: 20, height: 20),
                                              onTap: didTapSettingButton)])
        /*

        .setToastMessage(show: $show,
                         text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                         buttons: [.withImage(image: .init(systemName: "gear"),
                                              size: .init(width: 20, height: 20),
                                              onTap: didTapSettingButton),
                                   .withImage(image: .init(systemName: "star"),
                                              size: .init(width: 20, height: 20),
                                              onTap: didTapStarButton)])
         */
    }

    func didTapSettingButton() {

    }

    func didTapStarButton() {

    }
}

struct WithButtonImage_Previews: PreviewProvider {
    static var previews: some View {
        WithButtonImage()
    }
}
