//
//  StringExt.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 16/02/2025.
//

import SwiftUI

@MainActor private func renderTextImage(_ str: String, font: String, size: CGFloat) -> CGImage {
    let renderer = ImageRenderer(
        content: Text(str)
            .font(Font.custom(font, size: size))
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(nil)

    )
    
    
    debugPrint(renderer.cgImage, renderer.cgImage == nil, str, Text(str))
    
    return renderer.cgImage!
}

@MainActor private func renderTextImage(_ str: AttributedString, font: String, size: CGFloat)
    -> CGImage
{
    let renderer = ImageRenderer(
        content: Text(str)
            .font(Font.custom(font, size: size))
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(nil)
    )

    return renderer.cgImage!
}

extension String {

    @MainActor func image(_ fontSize: CGFloat = 17) -> CGImage {
        return renderTextImage(self, font: "Raleway-Thin", size: fontSize)

    }

    @MainActor func dotted_image(_ fontSize: CGFloat = 17) -> CGImage {
        return renderTextImage(self, font: "RalewayDots-Regular", size: fontSize)

    }

}

extension AttributedString {
    @MainActor func image(_ fontSize: CGFloat = 17) -> CGImage {
        return renderTextImage(self, font: "Raleway-Thin", size: fontSize)

    }

    @MainActor func dotted_image(_ fontSize: CGFloat = 17) -> CGImage {
        return renderTextImage(self, font: "RalewayDots-Regular", size: fontSize)

    }
}

struct StringExtPreview: View {
    var text: String
    var size: CGFloat

    init(_ text: String, size: CGFloat = 17) {
        Raleway.registerFonts()
        self.text = text
        self.size = size
    }

    var body: some View {
        VStack {
                Image(text.dotted_image(size), scale: 2, label: Text("f"))
        }
    }
}

struct AttributedStringExtPreview: View {
    var text: AttributedString
    var size: CGFloat

    init(_ text: AttributedString, size: CGFloat = 17) {
        Raleway.registerFonts()
        self.text = text
        self.size = size
    }

    var body: some View {
        VStack {
                Image(text.image(size) , scale: 2, label: Text("f"))
        }
    }
}

#Preview {
    StringExtPreview("Water")
}

#Preview {
    GeometryReader { geo in
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                StringExtPreview("Mary Had a Little Lamb", size: geo.size.width * 0.1)
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    GeometryReader { geo in
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                StringExtPreview("Mary Had\n a Little\n Lamb", size: geo.size.width * 0.1)
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    GeometryReader { geo in
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                AttributedStringExtPreview(
                    (try? AttributedString(markdown: "Mary had **two** little lambs"))
                        ?? "Mary had _two_ little lambs", size: geo.size.width * 0.1)
                Spacer()
            }
            Spacer()
        }
    }
}
