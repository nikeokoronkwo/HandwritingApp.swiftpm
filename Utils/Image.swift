//
//  Image.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 15/02/2025.
//

import SwiftUI

func ImageFromData(_ data: Data) -> Image {
    debugPrint(data)

    #if canImport(UIKit)
        return Image(uiImage: UIImage(data: data) ?? UIImage(ciImage: CIImage(data: data)!))
    #elseif canImport(AppKit)
        return Image(nsImage: NSImage(data: data))
    //        #else
    #endif
}

func convertUIImageToCGImage(input: UIImage) -> CGImage! {
    guard var ciImage = CIImage(image: input) else {
        return nil
    }
    
    let context = CIContext(options: nil)
    return context.createCGImage(ciImage, from: ciImage.extent)
}
