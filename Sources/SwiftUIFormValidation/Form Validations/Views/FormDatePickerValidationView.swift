//
//  FormDatePickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormDatePickerValidationView: FormValidationContent {
    
    // MARK: - Initializer
    
    init(value: Binding<Date>, imageName: String? = nil, in range: ClosedRange<Date>? = nil, displayedComponents: DatePickerComponents? = nil) {
        self._value = value
        self.imageName = imageName
        self.range = range
        self.displayedComponents = displayedComponents
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding public var value: Date
    
    private let imageName: String?
    private let range: ClosedRange<Date>?
    private let displayedComponents: DatePickerComponents?
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            if let imageName = imageName {
                Image(imageName).resizable().scaledToFit().frame(width: 27, height: 27).foregroundColor(appearance.imageIconColor)
            }
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
                .labelsHidden()
                .datePickerStyle(.compact)
                .focused($focused)
                .disabled(!isEnabled)
        }
    }
    
}

public extension FormValidationContent where Self == FormDatePickerValidationView {
    /// Simple date picker that allows user to select date based on an optional range and displayed components.
    /// - Parameters:
    ///   - value: The selected date
    ///   - imageName: An optional icon to display beside the date picker
    ///   - range: The range from, to, or in between dates.
    ///   - displayedComponents: The components to be displayed such as date or time or even both
    static func datePicker(value: Binding<Date>, imageName: String? = nil, in range: ClosedRange<Date>? = nil, displayedComponents: DatePickerComponents? = nil) -> FormDatePickerValidationView {
        FormDatePickerValidationView(value: value, imageName: imageName, in: range, displayedComponents: displayedComponents)
    }
}
