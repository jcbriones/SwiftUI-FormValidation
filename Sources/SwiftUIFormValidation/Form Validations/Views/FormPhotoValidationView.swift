//
//  FormPhotoValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 9/3/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormPhotoValidationView: FormValidationContent {
    
    // MARK: - Initializer
    
    public init(value: Binding<Image?>) {
        self._value = value
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding public var value: Image?
    
    @State private var showPicker: Bool = false
    
    // MARK: - Body
    
    public var body: some View {
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
    
}

#if DEBUG
public struct FormPhotoValidationView_Previews: PreviewProvider {
    @State private static var image: Image?
    static public var previews: some View {
        FormPhotoValidationView(value: $image)
    }
}
#endif
