//
//  View+Extension.swift
//  
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI

extension View where Self: FormValidationProtocol {
    public func formValidationStyle<S, A>(_ style: S, appearance: A = DefaultFormValidationViewAppearance()) -> some View where S : FormValidationStyle, A : FormValidationViewAppearance {
        let configuration = FormValidationStyleConfiguration(
            content: content(appearance),
            appearance: appearance
        )
        return style.makeBody(configuration: configuration)
    }
}
