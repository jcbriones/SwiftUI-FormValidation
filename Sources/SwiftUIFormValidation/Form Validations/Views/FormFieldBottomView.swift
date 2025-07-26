//
//  FormFieldBottomView.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/23/25.
//  Copyright © 2025 PetCollab, LLC. All rights reserved.
//

import SwiftUI

// MARK: - Validation Strategy
public enum ValidationStrategy: Sendable, Equatable {
    case immediate
    case onBlur
    case onSubmit
    case debounced(TimeInterval)
}

// MARK: - Validation State
struct ValidationState: Sendable, Equatable {
    let result: FormValidationResult
    let isValidating: Bool
    let lastValidatedValue: String?

    static let initial = ValidationState(
        result: .valid,
        isValidating: false,
        lastValidatedValue: nil
    )
}

struct FormFieldBottomView<Value: Equatable & Sendable>: View {
    @Environment(\.formAppearance)
    private var appearance
    @Environment(\.isFocused)
    private var isFocused
    @Environment(\.externalValidationResult)
    @Binding private var externalFormValidationResult
    @Environment(\.externalValidator)
    private var externalValidator

    // MARK: - Properties
    @State private var trailingFooter: String = ""
    @State private var shake: Bool = false
    @State private var validationState: ValidationState = .initial
    @State private var debounceTask: Task<Void, Never>?

    @Binding var value: Value
    @Binding var result: FormValidationResult
    var validators: [any FormValidator]
    var footerMessage: LocalizedStringResource?
    var validationStrategy: ValidationStrategy = .immediate

    // MARK: - Body
    var body: some View {
        HStack {
            switch validationState.result {
            case .valid where footerMessage != nil:
                Text(footerMessage!)
                    .font(appearance.validatedDescriptionFont)
                    .foregroundColor(
                        appearance.formValidationDescriptionTextColor(
                            focused: isFocused,
                            validationResult: validationState.result
                        )
                    )
                    .accessibilityHidden(footerMessage == nil)
            case .info(let message), .warning(let message), .error(let message):
                HStack(spacing: 4) {
                    if validationState.isValidating {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: appearance.activeTextColor))
                    }
                    Text(message)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(
                            appearance.formValidationDescriptionTextColor(
                                focused: isFocused,
                                validationResult: validationState.result
                            )
                        )
                        .shake(shake, offsetRange: 3)
                        .onAppear {
                            if !validationState.result.isValid {
                                shake.toggle()
                            }
                        }
                }
            default:
                EmptyView()
            }
            Spacer()
            characterCountView
        }
        .onChange(of: value) { newValue in
            handleValueChange(newValue)
        }
        .onReceive(externalValidator) {
            Task { @MainActor in
                await performValidation()
            }
        }
        .onAppear {
            externalFormValidationResult = validationState.result
        }
        .onDisappear {
            externalFormValidationResult = nil
            debounceTask?.cancel()
        }
        .onChange(of: validationState.result) { newValue in
            result = newValue
            externalFormValidationResult = newValue
        }
    }

    // MARK: - Character Count View
    @ViewBuilder
    private var characterCountView: some View {
        if !trailingFooter.isEmpty {
            Text(trailingFooter)
                .font(appearance.validatedDescriptionFont)
                .foregroundColor(appearance.activeTextColor)
        } else if let validator = validators.first(where: { $0 is CharacterLimitValidator }) as? CharacterLimitValidator,
                  let text = value as? CustomStringConvertible {
            Text("\(text.description.count.formatted()) / \(validator.characterLimit.formatted())")
                .font(appearance.validatedDescriptionFont)
                .foregroundColor(
                    text.description.count <= validator.characterLimit ?
                    appearance.activeTextColor :
                        appearance.formValidationBorderColor(
                            focused: isFocused,
                            validationResult: validationState.result
                        )
                )
        }
    }

    // MARK: - Validation Logic
    private func handleValueChange(_ newValue: Value) {
        let valueString = String(describing: newValue)

        // Cancel previous debounce task
        debounceTask?.cancel()

        switch validationStrategy {
        case .immediate:
            Task { @MainActor in
                await performValidation()
            }

        case .debounced(let delay):
            validationState = ValidationState(
                result: validationState.result,
                isValidating: true,
                lastValidatedValue: valueString
            )

            debounceTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

                if !Task.isCancelled {
                    await performValidation()
                }
            }

        case .onBlur:
            // Validation will be triggered when focus is lost
            break

        case .onSubmit:
            // Validation will be triggered on form submission
            break
        }
    }

    @MainActor
    private func performValidation() async {
        let valueString = String(describing: value)

        // Skip if already validated this value
        if validationState.lastValidatedValue == valueString && !validationState.isValidating {
            return
        }

        validationState = ValidationState(
            result: validationState.result,
            isValidating: true,
            lastValidatedValue: valueString
        )

        let newResult = (try? await validators.validate(value).first { $0 != .valid }) ?? .valid

        validationState = ValidationState(
            result: newResult,
            isValidating: false,
            lastValidatedValue: valueString
        )
    }
}

// MARK: - Shake Animation Extension
extension View {
    func shake(_ isShaking: Bool, offsetRange: CGFloat = 10) -> some View {
        self.offset(x: isShaking ? offsetRange : 0)
            .animation(
                isShaking ?
                Animation.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true) :
                        .default,
                value: isShaking
            )
    }
}
