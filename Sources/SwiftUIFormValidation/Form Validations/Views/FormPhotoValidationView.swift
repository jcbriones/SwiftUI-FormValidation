//
//  FormPhotoValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 9/3/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Combine
import PhotosUI
import SwiftUI

public struct FormPhotoValidationView: FormValidationContent {

    // MARK: - Initializer

    public init(value: Binding<Image?>) {
        self._value = value
    }

    // MARK: - Private Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult) private var validationResult
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @Binding public var value: Image?

    @State private var selectedItems: [PhotosPickerItem] = []

    // MARK: - Body

    public var body: some View {
        PhotosPicker(selection: $selectedItems,
                     matching: .images,
                     photoLibrary: .shared()) {
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
        }.buttonStyle(.borderless)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8], dashPhase: 0))
                    .foregroundColor(appearance.inactiveBorderColor)
            )
    }

}

#if DEBUG
public struct FormPhotoValidationView_Previews: PreviewProvider {
    @State private static var image: Image?
    static public var previews: some View {
        FormPhotoValidationView(value: $image)
    }
}
#endif

public extension FormValidationContent where Self == FormPhotoValidationView {
    /// A form validation that allows to select a photo from the photo library or taken from the camera.
    /// - Parameter value: The image selected.
    static func photo(value: Binding<Image?>) -> FormPhotoValidationView {
        FormPhotoValidationView(value: value)
    }
}
