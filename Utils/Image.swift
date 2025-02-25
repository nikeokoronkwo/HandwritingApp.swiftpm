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
    guard let ciImage = CIImage(image: input) else {
        return nil
    }
    
    let context = CIContext(options: nil)
    return context.createCGImage(ciImage, from: ciImage.extent)
}

struct TextToImageView: View {
    let text: String
    let lineSpacing: CGFloat
    let imageSize: CGSize
    
    var body: some View {
        Image(uiImage: renderTextAsImage(text: text, size: imageSize, lineSpacing: lineSpacing))
            .resizable()
            .scaledToFit()
    }
    
    func renderTextAsImage(text: String, size: CGSize, lineSpacing: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle,
//                .foregroundColor: UIColor.black
                .foregroundColor: UIColor(Color.primary)
            ]
            
            let textRect = CGRect(x: 20, y: 20, width: size.width - 40, height: size.height - 40)
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
}

#Preview {
    TextToImageView(text: "This is multiline text.\nIt has custom line spacing.",
                    lineSpacing: 10,
                    imageSize: CGSize(width: 300, height: 200))
}
