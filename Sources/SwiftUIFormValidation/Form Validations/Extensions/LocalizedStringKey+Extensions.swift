//
//  LocalizedStringKey+Extensions.swift
//  Recomdy
//
//  Created by Jc Briones on 3/5/23.
//  Copyright © 2023 Recomdy, LLC. All rights reserved.
//

import SwiftUI

public extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self)
            .children
            .first { $0.label == "key" }?
            .value as? String
    }

    func stringValue(locale: Locale = .current, bundle: Bundle = .main) -> String? {
        .localizedString(for: self.stringKey, locale: locale, bundle: bundle)
    }
}

public extension String {
    static func localizedString(
        for key: String?,
        locale: Locale = .current,
        bundle: Bundle = Bundle.main
    ) -> String? {
        guard let key else { return nil }
        let language = locale.languageCode
        let path = bundle.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        // swiftlint:disable:next nslocalizedstring_key
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

        return localizedString
    }
}
