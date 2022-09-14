//
//  FormPhotoValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 9/3/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
public struct FormPhotoValidationView: FormValidationView {

    // MARK: - Private Properties

    @Environment(\.isEnabled) public var isEnabled: Bool
    @FocusState public var focused: Bool
    @State public var validationResult: FormValidationResult = .valid
    @State private var showPicker: Bool = false

    // MARK: - Public Properties

    public let header: String
    public var leftFooterMessage: String = ""
    public var rightFooterMessage: String = ""
    public var isRequired: Bool = false
    @Binding public var value: Image?

    public var trigger: AnyPublisher<Void, Never>?
    public var validators: [FormValidator] = []

    // MARK: - Body

    public var body: some View {
        createView(innerBody)
    }

    var innerBody: some View {
        Button {
            showPicker.toggle()
        } label: {
            VStack(spacing: 10) {
                if let image = value {
                    image.resizable().scaledToFit()
                } else {
                    Image(systemName: "plus")
                        .foregroundColor(appearance.activeBorderColor)
                        .padding()
                        .background(appearance.imageIconColor).clipShape(Circle())
                    Text("Add Photos")
                        .font(appearance.titleHeaderFont)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8], dashPhase: 0))
                .foregroundColor(appearance.inactiveBorderColor)
        )
        .sheet(isPresented: $showPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$value)
        }
    }

    // MARK: - Validator

    public func validate() {
        validationResult = validators.validate(value)
    }

}

#if DEBUG
@available(iOS 15.0, *)
public struct FormPhotoValidationView_Previews: PreviewProvider {
    @State private static var image: Image?
    static public var previews: some View {
        FormPhotoValidationView(header: "Photos", value: $image)
    }
}
#endif
