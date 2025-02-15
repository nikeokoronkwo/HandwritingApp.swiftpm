//
//  Image.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 15/02/2025.
//

import SwiftUI

func ImageFromData(_ data: Data) -> Image {
    #if canImport(UIKit)
        return Image(uiImage: UIImage(data: data)!)
    #elseif canImport(AppKit)
        return Image(nsImage: NSImage(data: data))
//        #else
    #endif
}
