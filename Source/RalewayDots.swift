//
//  JBMono.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 16/02/2025.
//


import Foundation
import SwiftUI

public struct RalewayDots {
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
            debugPrint("Couldn't create font")
            return
        }
        
        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
    public static func registerFonts() {
        registerFont(bundle: .main, fontName: "RalewayDots", fontExtension: "ttf")
    }
}


