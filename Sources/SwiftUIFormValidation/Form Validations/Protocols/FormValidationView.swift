//
//  FormValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public protocol FormValidationView: View {
    associatedtype Value: Equatable
    var requireFontColor: Color { get }
    var requireSymbol: String { get }

    var focused: Bool { get set }
    var header: String { get }
    var leftFooterMessage: String { get set }
    var rightFooterMessage: String { get set }
    var isEnabled: Bool { get }
    var isRequired: Bool { get set }
    var value: Value { get set }
    var trigger: AnyPublisher<Void, Never>? { get }
    var validators: [FormValidator] { get set }
    var validationResult: FormValidationResult { get set }

    func validate()
    
    var appearance: FormValidationViewAppearanceProtocol { get }
}

extension FormValidationView {

    public var requireFontColor: Color { .red }
    public var requireSymbol: String { " *" }

    // MARK: - Public API

    @ViewBuilder func createView<Content: View>(_ content: Content) -> some View {
        injectView(content)
            .onChange(of: value) { _ in
                validate()
            }
            .onReceive(trigger.publisher) { _ in
                validate()
            }
    }

    // MARK: - Private API

    @ViewBuilder private func injectView<Content: View>(_ content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if isRequired {
                    (Text(header)
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(focused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor)
                     +
                     Text(requireSymbol)
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(requireFontColor))
                    .animation(.easeInOut(duration: 0.5), value: focused)
                } else {
                    Text(header)
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(focused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor)
                        .animation(.easeInOut(duration: 0.5), value: focused)
                }
            }.accessibilityAddTraits([.isHeader])
            content
                .padding(.vertical, 3)
            HStack {
                switch validationResult {
                case .valid:
                    Text(leftFooterMessage)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: validationResult)
                        .accessibilityHidden(leftFooterMessage.isEmpty)
                case .info(let message), .warning(let message), .error(let message):
                    Text(message)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: validationResult)
                }
                Spacer()
                if !rightFooterMessage.isEmpty {
                    Text(rightFooterMessage)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: validationResult)
                }
            }
        }.accessibilityElement(children: .contain)
    }
    
}
