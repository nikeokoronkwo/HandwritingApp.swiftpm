//
//  Fonts.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 16/02/2025.
//

import Foundation
import SwiftUI

public struct Raleway {
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider)
        else {
            debugPrint("Couldn't create font")
            return
        }
        
        debugPrint(font)

        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }

    public static func registerFonts() {
        registerFont(bundle: .main, fontName: "RalewayDots", fontExtension: "ttf")
        registerFont(bundle: .main, fontName: "Raleway", fontExtension: "ttf")
    }
}

#Preview {
    let t = "Jesus"
    VStack {
        Text(t)
            .font(.custom("Raleway-Thin", size: 70))
        Text(t)
            .font(.custom("RalewayDots-Regular", size: 70))
    }
    .task {
        Raleway.registerFonts()
    }
}
