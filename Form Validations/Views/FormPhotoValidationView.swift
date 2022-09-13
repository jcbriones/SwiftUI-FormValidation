//
//  FormPhotoValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 9/3/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

struct FormPhotoValidationView: FormValidationView {

    // MARK: - Private Properties

    @Environment(\.isEnabled) var isEnabled: Bool
    @FocusState var focused: Bool
    @State var validationResult: FormValidationResult = .valid
    @State private var showPicker: Bool = false

    // MARK: - Public Properties

    let header: String
    var leftFooterMessage: String = ""
    var rightFooterMessage: String = ""
    var isRequired: Bool = false
    @Binding var value: Image?

    var trigger: AnyPublisher<Void, Never>?
    var validators: [FormValidator] = []

    // MARK: - Body

    var body: some View {
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
                        .foregroundColor(AppColor.accent)
                        .padding()
                        .background(AppColor.lightAccent).clipShape(Circle())
                    Text("Add Photos").textStyle(.h4Headline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8], dashPhase: 0))
                .foregroundColor(AppColor.lightGray)
        )
        .sheet(isPresented: $showPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$value)
        }
    }

    // MARK: - Validator

    func validate() {
        validationResult = validators.validate(value)
    }

}

struct FormPhotoValidationView_Previews: PreviewProvider {
    @State private static var image: Image?
    static var previews: some View {
        FormPhotoValidationView(header: "Photos", value: $image)
    }
}
