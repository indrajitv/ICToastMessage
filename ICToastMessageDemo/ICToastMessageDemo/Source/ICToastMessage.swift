//
//  ICToastMessage.swift
//
//  Created by Indrajit Chavda on 12/07/23.
//

import SwiftUI

public extension View {

    func setToastMessage(show: Binding<Bool>,
                         text: String,
                         buttons: [ICToastMessage.ToastButton] = [],
                         config: ICToastMessage.Configuration = ICToastMessage.Configuration()) -> some View {

        modifier(ICToastMessage(show: show,
                                text: text,
                                buttons: buttons,
                                config: config))
    }
}

public struct ICToastMessage: ViewModifier {

    @Binding
    var show: Bool

    let text: String

    @ObservedObject
    var config: Configuration

    let buttons: [ToastButton]

    @ViewBuilder
    private var buttonsContainer: some View {
        HStack {
            ForEach(0..<self.buttons.count, id: \.self) { index in
                let button = self.buttons[index]
                switch button {
                    case .withTitle(let title, let onTap):
                        Button(title) {
                            onTap?()

                            self.onButtonTap()
                        }
                    case .withImage(let image, let size, let onTap):
                        Button {
                            onTap?()
                            self.onButtonTap()
                        } label: {
                            image
                                .resizable()
                                .frame(width: size.width, height: size.height)
                        }
                }
            }
        }
        .foregroundColor(self.config.buttonTextColor)
        .font(self.config.buttonFont)
    }

    private var textLabel: some View {
        Text(text)
            .font(self.config.textFont)
    }

    public init(show: Binding<Bool>, text: String, buttons: [ToastButton] = [], config: Configuration = Configuration()) {

        self._show = show
        self.buttons = buttons
        self.text = text
        self.config = config
    }

    public func body(content: Content) -> some View {
        content.overlay(
            VStack {
                if config.presentingAlignment == .bottom || config.presentingAlignment == .bottomLeading || config.presentingAlignment == .bottomTrailing {
                    Spacer()
                }

                HStack {
                    if buttons.isEmpty {
                        self.textLabel
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    } else {
                        VStack(spacing: 8) {
                            self.textLabel
                                .frame(maxWidth: .infinity, alignment: .leading)
                            self.buttonsContainer
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(self.config.backgroundColor)
                .foregroundColor(self.config.contentTextColor)
                .cornerRadius(self.config.cornerRadius)
                .padding()
                .modifier(AnimationTypeSetter(config: self.config, show: self.$show))
                .onTapGesture {
                    if self.config.tapOnToHide {
                        self.show = false
                    }
                }

                if config.presentingAlignment == .top || config.presentingAlignment == .topLeading || config.presentingAlignment == .topTrailing {
                    Spacer()
                }
            }
                .onChange(of: self.show, perform: { newValue in
                    if newValue, let autoHideTime = self.config.autoHideTime {

                        self.config.scheduledTimerToAutoHide = Timer.scheduledTimer(withTimeInterval: autoHideTime, repeats: false, block: { _ in
                            if self.show {
                                self.show = false
                            }
                        })

                    }

                    if !newValue {
                        self.config.scheduledTimerToAutoHide?.invalidate()
                    }
                })
        )
    }

    private func onButtonTap() {
        if self.config.hideOnButtonClick {
            self.show = false
        }
    }
}

public extension ICToastMessage {

    enum ToastButton {
        case withTitle(title: String, onTap: (() -> ())? = nil)
        case withImage(image: Image, size: CGSize, onTap: (() -> ())? = nil)
    }

    enum AnimationType {
        case type1
        case type2(damping: CGFloat = 0.65)
        case type3(duration: TimeInterval = 0.4)
    }

    struct AnimationTypeSetter: ViewModifier {

        let config: Configuration

        @Binding
        var show: Bool

        public func body(content: Content) -> some View {
            let offset = getOffset()
            switch config.type {
                case .type1:
                    content
                        .offset(x: offset.x, y: offset.y)
                        .opacity(show ? 1 : 2)
                        .animation(.interpolatingSpring(mass: 0.1,
                                                        stiffness: 3,
                                                        damping: 0.9,
                                                        initialVelocity: 1),
                                   value: self.show)

                        .animation(.easeIn(duration: 1), value: self.show)
                case .type2(let damping):
                    content
                        .offset(x: offset.x, y: offset.y)
                        .opacity(show ? 1 : 2)
                        .animation(.interactiveSpring(response: 1,
                                                      dampingFraction: damping,
                                                      blendDuration: 1),
                                   value: self.show)
                case .type3(let duration):
                    content
                        .opacity(self.show ? 1 : 0)
                        .animation(.easeIn(duration: duration), value: self.show)
                        .offset(x: offset.x, y: offset.y)
            }

        }

        func getOffset() -> CGPoint {

            if case .type3 = config.type {
                if [Alignment.top, .topLeading, .topTrailing].contains(where: { config.presentingAlignment == $0}) {
                    return .init(x: 0,
                                 y: config.visibleYOffset)
                } else {
                    return .init(x: 0,
                                 y: -config.visibleYOffset)
                }
            } else {
                switch config.presentingAlignment {
                    case .top:
                        return .init(x: 0,
                                     y: show ? config.visibleYOffset : -config.initialInvisibleYOffset)
                    case .topLeading:
                        return .init(x: show ? 0 : -config.initialInvisibleYOffset,
                                     y: config.visibleYOffset)
                    case .topTrailing:
                        return .init(x: show ? 0 : config.initialInvisibleYOffset,
                                     y: config.visibleYOffset)
                    case .bottom:
                        return .init(x: 0,
                                     y: show ? -config.visibleYOffset : config.initialInvisibleYOffset)

                    case .bottomLeading:
                        return .init(x: show ? 0 : -config.initialInvisibleYOffset,
                                     y: -config.visibleYOffset)

                    case .bottomTrailing:
                        return .init(x: show ? 0 : config.initialInvisibleYOffset,
                                     y: -config.visibleYOffset)
                    default: // becomes .bottom
                        assertionFailure("Other alignments are not supported.")
                        return .init(x: 0,
                                     y: show ? -config.visibleYOffset : config.initialInvisibleYOffset)
                }
            }
        }
    }

    final class Configuration: ObservableObject {

        fileprivate var scheduledTimerToAutoHide: Timer?

        /// Decides from which direction toast should appear.
        var presentingAlignment: Alignment

        var cornerRadius: CGFloat
        var backgroundColor: Color
        var contentTextColor: Color
        var buttonTextColor: Color

        var textFont: Font
        var buttonFont: Font

        /// If not nil then hides the toast after 'n' seconds. If nil then toast will need to get instruction to get hidden.
        var autoHideTime: TimeInterval?

        var hideOnButtonClick: Bool
        /// Tap anywhere on toast to hide. default is false.
        var tapOnToHide: Bool

        /// This is the original y offset of toast from where it animates toward decided visible place. Should give more space if the parent is smaller than the screen.
        let initialInvisibleYOffset: CGFloat

        /// Gives padding from the edge while toast is visible.
        let visibleYOffset: CGFloat

        /// Type of animation while toast is presenting to the visible screen.
        let type: ICToastMessage.AnimationType

        public init
        (
            type: ICToastMessage.AnimationType = .type1,
            autoHideTime: TimeInterval? = 3.5,
            hideOnButtonClick: Bool = true,
            tapOnToHide: Bool = false,
            backgroundColor: Color = Color(UIColor.systemBlue),
            contentTextColor: Color = Color(UIColor.white),
            buttonTextColor: Color = Color(UIColor.white),
            textFont: Font = Font(UIFont.systemFont(ofSize: 14)),
            buttonFont: Font = Font(UIFont.systemFont(ofSize: 14, weight: .semibold)),
            presentingAlignment: Alignment = .bottom,
            cornerRadius: CGFloat = 6,
            initialInvisibleYOffset: CGFloat = 400,
            visibleYOffset: CGFloat = 30
        ) {

            self.type = type
            self.autoHideTime = autoHideTime
            self.presentingAlignment = presentingAlignment
            self.cornerRadius = cornerRadius
            self.backgroundColor = backgroundColor
            self.contentTextColor = contentTextColor
            self.buttonTextColor = buttonTextColor
            self.textFont = textFont
            self.buttonFont = buttonFont
            self.hideOnButtonClick = hideOnButtonClick
            self.tapOnToHide = tapOnToHide
            self.initialInvisibleYOffset = initialInvisibleYOffset
            self.visibleYOffset = visibleYOffset
        }
    }
}
