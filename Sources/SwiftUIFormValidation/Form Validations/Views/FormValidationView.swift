//
//  FormValidationView.swift
//
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI
import Combine

public struct FormValidationView<Content>: View where Content: FormValidationContent {
    // MARK: - ViewModel

    @StateObject private var viewModel: FormValidationViewModel

    // MARK: - View Binding Properties

    @Environment(\.externalValidationResult)
    @Binding private var externalFormValidationResult

    @Environment(\.externalValidator)
    private var externalValidator

    @Environment(\.formAppearance)
    private var appearance

    @Environment(\.isEnabled)
    private var isEnabled

    @FocusState private var focused: Bool

    // MARK: - Form Validation Properties

    private var header: LocalizedStringKey?
    private var footerMessage: LocalizedStringKey?
    @State private var trailingFooter: String = ""
    private var isRequired: Bool
    private var contentType: Content
    private let maxCharCount: Int?

    @State private var shake: Bool = false

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let header {
                HStack {
                    if isRequired {
                        (Text(header)
                            .font(appearance.titleHeaderFont)
                            .foregroundColor(
                                focused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor
                            )
                         +
                         Text(" *")
                            .accessibilityLabel(
                                NSLocalizedString(
                                    "xloc.field.required",
                                    bundle: .module,
                                    comment: "For the input field of the form that is required."
                                )
                            )
                                .font(appearance.titleHeaderFont)
                                .foregroundColor(appearance.requiredFieldSymbolTextColor))
                        .animation(appearance.animation, value: focused)
                    } else {
                        Text(header)
                            .font(appearance.titleHeaderFont)
                            .foregroundColor(
                                focused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor
                            )
                            .animation(appearance.animation, value: focused)
                    }
                }.accessibilityAddTraits([.isHeader])
            }
            contentType
                .environment(\.formValidationResult, viewModel.validationResult)
                .focused($focused)
                .formAppearance(appearance)
                .padding(.vertical, 3)
            HStack {
                switch viewModel.validationResult {
                case .valid:
                    Text(footerMessage ?? "")
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(
                            appearance.formValidationDescriptionTextColor(
                                focused: focused,
                                validationResult: viewModel.validationResult
                            )
                        )
                        .frame(minHeight: 15)
                        .accessibilityHidden(footerMessage == nil)
                case .info(let message), .warning(let message), .error(let message):
                    Text(message, bundle: .module)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(
                            appearance.formValidationDescriptionTextColor(
                                focused: focused,
                                validationResult: viewModel.validationResult
                            )
                        )
                        .shake(shake, offsetRange: 3)
                        .onAppear {
                            if !viewModel.validationResult.isValid {
                                shake.toggle()
                            }
                        }
                }
                Spacer()
                if !trailingFooter.isEmpty {
                    Text(trailingFooter)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(
                            appearance.activeTextColor
                        )
                        .frame(minHeight: 15)
                } else if let maxCharCount,
                          let text = contentType.value as? CustomStringConvertible {
                    Text("\(text.description.count.formatted()) / \(maxCharCount.formatted())")
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(text.description.count <= maxCharCount ?
                                         appearance.activeTextColor :
                                            appearance.formValidationBorderColor(
                                                focused: focused,
                                                validationResult: viewModel.validationResult
                                            )
                        )
                        .frame(minHeight: 15)
                }
            }
            .padding(.bottom, 3)
        }
        .onChange(of: contentType.value) { newValue in
            viewModel.validate(newValue)
        }
        .onReceive(externalValidator) {
            viewModel.validate(contentType.value)
        }
        .onAppear {
            externalFormValidationResult = .valid
        }
        .onDisappear {
            externalFormValidationResult = nil
        }
        .onChange(of: viewModel.validationResult) { newValue in
            externalFormValidationResult = newValue
        }
        .onChange(of: isRequired) { newValue in
            if newValue, let header,
               !viewModel.validators.contains(where: { $0 is RequiredFieldValidator }) {
                viewModel.validators.append(RequiredFieldValidator(fieldName: header.stringValue()))
            } else {
                viewModel.validators.removeAll(where: { $0 is RequiredFieldValidator })
            }
        }
        .onChange(of: maxCharCount) { newValue in
            if let newValue,
               !viewModel.validators.contains(where: { $0 is CharacterLimitValidator }) {
                viewModel.validators.append(CharacterLimitValidator(characterLimit: newValue))
            } else {
                viewModel.validators.removeAll(where: { $0 is CharacterLimitValidator })
            }
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: - Initializer

    /// Creates a form validation field view.
    /// - Parameters:
    ///   - header: The title header of the validation field.
    ///   - footerMessage: An optional string which is displayed at the bottom of the form validation field.   
    ///   - isRequired: If the validation field is required.
    ///   - maxCharCount: The maximum number of characters allowed before it throws an error validation result.
    ///   - validators: Validators to be applied on this field.
    ///   - contentType: The type of validation field.
    public init(
        header: LocalizedStringKey?,
        footerMessage: LocalizedStringKey? = nil,
        isRequired: Bool = false,
        maxCharCount: Int? = nil,
        validators: [any FormValidator] = [],
        validatorDelay: RunLoop.SchedulerTimeType.Stride = .zero,
        validationResult: Binding<FormValidationResult?>? = nil,
        _ contentType: Content
    ) {
        self.header = header
        self.footerMessage = footerMessage
        self.isRequired = isRequired
        self.contentType = contentType
        self.maxCharCount = maxCharCount

        var validators = validators
        if isRequired, let header,
           !validators.contains(where: { $0 is RequiredFieldValidator }) {
            validators.append(RequiredFieldValidator(fieldName: header.stringValue()))
        }
        if let maxCharCount,
           !validators.contains(where: { $0 is CharacterLimitValidator }) {
            validators.append(CharacterLimitValidator(characterLimit: maxCharCount))
        }
        _viewModel = StateObject(wrappedValue: FormValidationViewModel(validators: validators, delay: validatorDelay))
    }

    /// Creates a form validation field view.
    /// - Parameters:
    ///   - header: The title header of the validation field.
    ///   - footerMessage: An optional string which is displayed at the bottom of the form validation field.
    ///   - isRequired: If the validation field is required.
    ///   - maxCharCount: The maximum number of characters allowed before it throws an error validation result.
    ///   - validators: Validators to be applied on this field.
    ///   - contentType: The type of validation field.
    public init(
        header: String?,
        footerMessage: String? = nil,
        isRequired: Bool = false,
        maxCharCount: Int? = nil,
        validators: [any FormValidator] = [],
        validatorDelay: RunLoop.SchedulerTimeType.Stride = .zero,
        _ contentType: Content
    ) {
        if let header {
            self.header = .init(header)
        }
        self.footerMessage = footerMessage != nil ? .init(footerMessage!) : nil
        self.isRequired = isRequired
        self.contentType = contentType
        self.maxCharCount = maxCharCount

        var validators = validators
        if isRequired, let header,
           !validators.contains(where: { $0 is RequiredFieldValidator }) {
            validators.append(RequiredFieldValidator(fieldName: header))
        }
        if let maxCharCount,
           !validators.contains(where: { $0 is CharacterLimitValidator }) {
            validators.append(CharacterLimitValidator(characterLimit: maxCharCount))
        }
        _viewModel = StateObject(wrappedValue: FormValidationViewModel(validators: validators, delay: validatorDelay))
    }
}
