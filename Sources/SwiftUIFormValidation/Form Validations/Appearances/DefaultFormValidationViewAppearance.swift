//
//  DefaultFormValidationViewAppearance.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct DefaultFormValidationViewAppearance: FormValidationViewAppearance {
    private struct Row<Item>: View where Item: AnyItem {
        @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
        let columns: [GridItem]
        let item: Item
        let isSelected: Bool?
        var onTap: (() -> Void)?

        var body: some View {
            LazyVGrid(columns: columns) {
                HStack {
                    if let systemImage = item.systemImage {
                        Image(systemName: systemImage)
                    } else if let imageUrl = item.imageUrl {
                        AsyncImage(url: imageUrl) { phase in
                            if let image = phase.image {
                                image.resizable()
                            } else if phase.error != nil {
                                EmptyView()
                            } else {
                                ProgressView().controlSize(.mini)
                            }
                        }.frame(width: 40, height: 40).clipShape(Circle())
                    }
                }
                HStack {
                    Text(item.localizedString)
                        .font(appearance.textFieldFont)
                        .foregroundColor(appearance.activeTextColor)
                    Spacer()
                    if let isSelected {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isSelected ? appearance.activeBorderColor : appearance.inactiveBorderColor)
                    }
                }
            }.onTapGesture {
                onTap?()
            }
        }
    }

    public let accentBackgroundColor: Color = .accentColor

    public let enabledBackgroundColor: Color = .white

    public let disabledBackgroundColor: Color = .gray.opacity(0.5)

    public let activeTitleHeaderColor: Color = .accentColor

    public let inactiveTitleHeaderColor: Color = .primary

    public let activeBorderColor: Color = .accentColor

    public let inactiveBorderColor: Color = .gray

    public let disabledBorderColor: Color = .gray

    public let infoBorderColor: Color = .blue

    public let warningBorderColor: Color = .yellow

    public let errorBorderColor: Color = .red

    public let validDescriptionTextColor: Color = .gray

    public let infoDescriptionTextColor: Color = .blue

    public let warningDescriptionTextColor: Color = .yellow

    public let errorDescriptionTextColor: Color = .red

    public let activeTextColor: Color = .primary

    public let inactiveTextColor: Color = .primary

    public let disabledTextColor: Color = .gray

    public let placeholderTextColor: Color = .gray

    public let requiredFieldSymbolTextColor: Color = .red

    public let imageIconColor: Color = .gray.opacity(0.8)

    public let animation: Animation = .default

    public let titleHeaderFont: Font = .headline

    public let textFieldFont: Font = .body

    public let validatedDescriptionFont: Font = .callout

    public let topPadding: CGFloat = 10

    public let bottomPadding: CGFloat = 10

    public let leadingPadding: CGFloat = 10

    public let trailingPadding: CGFloat = 10

    public let borderWidthActive: CGFloat = 1.5

    public let borderWidthInactive: CGFloat = 1

    public let borderRadius: CGFloat = 10

    public init() { }

    @MainActor
    public func row<Item>(_ items: [Item]) -> AnyView where Item: AnyItem {
        let columns: [GridItem] = items.contains { $0.systemImage != nil || $0.imageUrl != nil } ?
        [.init(.flexible(minimum: 10, maximum: 40)), .init(.flexible())] : [.init(.flexible())]
        return AnyView(
            List(items) { item in
                Row(columns: columns, item: item, isSelected: nil)
            }
        )
    }

    @MainActor
    public func selectableRow<Item>(_ items: [Item], selected: Binding<[Item]>) -> AnyView
    where Item: AnySelectableItem {
        let columns: [GridItem] = items.contains { $0.systemImage != nil || $0.imageUrl != nil } ?
        [.init(.flexible(minimum: 10, maximum: 40)), .init(.flexible())] : [.init(.flexible())]
        return AnyView(
            List(items) { item in
                Row(columns: columns, item: item, isSelected: selected.wrappedValue.contains(item)) {
                    if let index = selected.wrappedValue.firstIndex(of: item) {
                        selected.wrappedValue.remove(at: index)
                    } else {
                        selected.wrappedValue.append(item)
                    }
                }
            }
        )
    }
}

public extension FormValidationViewAppearance where Self == DefaultFormValidationViewAppearance {

    /// The default style for the form view.
    static var `default`: DefaultFormValidationViewAppearance {
        DefaultFormValidationViewAppearance()
    }
}
