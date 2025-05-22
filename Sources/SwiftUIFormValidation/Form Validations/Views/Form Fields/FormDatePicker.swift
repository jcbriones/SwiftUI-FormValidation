//
//  FormDatePicker.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormDatePicker: FormValidationContent {
    @Environment(\.formAppearance)
    private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult)
    private var validationResult
    @Environment(\.isEnabled)
    private var isEnabled: Bool

    @FocusState private var focused: Bool

    // MARK: - FormValidationContent Properties

    @Binding public var value: Date
    public var model: FormModel<Value>

    // MARK: - Form Field Properties

    @State private var showDatePicker: Bool = false
    private let imageName: String?
    private let range: ClosedRange<Date>?
    private let displayedComponents: DatePickerComponents?

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 5) {
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27, height: 27)
                    .foregroundColor(appearance.imageIconColor)
            }
            Button {
                showDatePicker.toggle()
            } label: {
                Text(
                    value.formatted(
                        date: .abbreviated,
                        time: displayedComponents?.contains(.hourAndMinute) == true ? .shortened : .omitted
                    )
                )
                .font(appearance.textFieldFont)
                .foregroundColor(appearance.formTextColor(focused: showDatePicker, isEnabled: isEnabled))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showDatePicker) {
                Group {
                    if let range, let displayedComponents {
                        DatePicker("", selection: $value, in: range, displayedComponents: displayedComponents)
                    } else if let range {
                        DatePicker("", selection: $value, in: range)
                    } else if let displayedComponents {
                        DatePicker("", selection: $value, displayedComponents: displayedComponents)
                    } else {
                        DatePicker("", selection: $value)
                    }
                }
                .padding()
                .labelsHidden()
                .datePickerStyle(.graphical)
                .presentationDetents([.medium])
            }
            .focused($focused)
            .disabled(!isEnabled)
            .onChange(of: focused) { newValue in
                showDatePicker = newValue
            }
        }
        .padding(
            .init(
                top: appearance.topPadding,
                leading: appearance.leadingPadding,
                bottom: appearance.bottomPadding,
                trailing: appearance.trailingPadding
            )
        )
        .background(
            RoundedRectangle(cornerRadius: appearance.borderRadius, style: .continuous)
                .stroke(
                    appearance.formValidationBorderColor(
                        focused: focused,
                        validationResult: validationResult
                    ),
                    lineWidth: focused ? appearance.borderWidthActive : appearance.borderWidthInactive
                )
                .background(
                    (
                        isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor
                    )
                    .cornerRadius(appearance.borderRadius)
                )
                .animation(appearance.animation, value: focused)
                .animation(appearance.animation, value: validationResult)
        )   
        .modifier(FormFieldContentModifier($value, model: model))
    }

    // MARK: - Initializer

    /// Simple date picker that allows user to select date based on an optional range and displayed components.
    /// - Parameters:
    ///   - value: The selected date
    ///   - header: The name of this form field.
    ///   - imageName: An optional icon to display beside the date picker
    ///   - range: The range from, to, or in between dates.
    ///   - displayedComponents: The components to be displayed such as date or time or even both
    public init(
        _ value: Binding<Date>,
        header: LocalizedStringKey? = nil,
        imageName: String? = nil,
        in range: ClosedRange<Date>? = nil,
        displayedComponents: DatePickerComponents? = nil
    ) {
        self._value = value
        self.model = .init(header: header)
        self.imageName = imageName
        self.range = range
        self.displayedComponents = displayedComponents
    }
}
