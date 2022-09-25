//
//  FormValidationStyle.swift
//  
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI

/// The properties of a form validation view
public protocol FormValidationStyle {
    
    /// The type of view representing the body.
    associatedtype Body : View
    
    /// Creates a view that represents the body of a type of form validation view.
    ///
    /// The system calls this method for each ``FormValidationView`` instance
    /// in a view hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration : The properties of the form validation view.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    typealias Configuration = FormValidationStyleConfiguration
}

extension FormValidationStyle where Self == DefaultFormValidationStyle {
    
    /// The default style for the form view.
    public static var `default`: DefaultFormValidationStyle {
        DefaultFormValidationStyle()
    }
}

