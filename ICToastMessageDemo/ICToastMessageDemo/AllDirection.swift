//
//  ContentView.swift
//  ICToastMessageDemo
//
//  Created by Indrajit Chavda on 14/07/23.
//

import SwiftUI

struct AllDirection: View {

    @State
    var isTopToastVisible: Bool = false

    @State
    var isTopLeadingToastVisible: Bool = false

    @State
    var isTopTrailingToastVisible: Bool = false

    @State
    var isBottomToastVisible: Bool = false

    @State
    var isBottomLeadingToastVisible: Bool = false

    @State
    var isBottomTrailingToastVisible: Bool = false


    var body: some View {
        VStack {
            HStack {
                Button("TopLeading") {
                    self.isTopLeadingToastVisible = true
                }
                Spacer()
                Button("Top") {
                    self.isTopToastVisible = true
                }
                Spacer()
                Button("TopTrailing") {
                    self.isTopTrailingToastVisible = true
                }
            }
            Spacer()
            HStack {
                Button("BottomLeading") {
                    self.isBottomLeadingToastVisible = true
                }
                Spacer()
                Button("Bottom") {
                    self.isBottomToastVisible = true
                }
                Spacer()
                Button("BottomTrailing") {
                    self.isBottomTrailingToastVisible = true
                }
            }
        }
        .padding()
        .setToastMessage(show: $isTopToastVisible,
                         text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                         config: .init(presentingAlignment: .top))

        .setToastMessage(show: $isTopLeadingToastVisible,
                         text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                         config: .init(presentingAlignment: .topLeading))

        .setToastMessage(show: $isTopTrailingToastVisible,
                         text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                         config: .init(presentingAlignment: .topTrailing))

        .setToastMessage(show: $isBottomToastVisible,
                         text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.")

        .setToastMessage(show: $isBottomLeadingToastVisible,
                         text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                         config: .init(presentingAlignment: .bottomLeading))

        .setToastMessage(show: $isBottomTrailingToastVisible,
                         text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                         config: .init(presentingAlignment: .bottomTrailing))
    }


}

struct AllDirection_Previews: PreviewProvider {
    static var previews: some View {
        AllDirection()
    }
}
