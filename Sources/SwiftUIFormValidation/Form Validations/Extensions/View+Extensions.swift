//
//  View+Extension.swift
//  
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI

extension View where Self == FormValidationView {
    public func formValidationStyle<S, A>(_ style: S, appearance: A = DefaultFormValidationViewAppearance()) -> some View where S : FormValidationStyle, A : FormValidationViewAppearance {
        let configuration = FormValidationStyleConfiguration(
            content: self.content as! FormValidationStyleConfiguration.Content,
            appearance: appearance
        )
        return style.makeBody(configuration: configuration)
    }
}
