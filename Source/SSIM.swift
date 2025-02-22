//
//  SSIM.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 21/02/2025.
//
import CoreGraphics
import Accelerate

//func meanAndVariance(from cgImage: CGImage) -> (mean: Float, stdev: Float)? {
//    let width = cgImage.width
//    let height = cgImage.height
//    let count = width * height
//    let bytesPerRow = width
//
////    var pixelData = [Float](repeating: 0, count: width * height)
//    guard var fmt = vImage_CGImageFormat(cgImage: cgImage),
//          var buf = try? vImage_Buffer(cgImage: cgImage,
//                                     format: fmt) else {
//        return nil
//    }
//    
////    var format = vImage_Buffer(data: &pixelData, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
//
////    let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8,
////                            bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceGray(),
////                            bitmapInfo: CGImageAlphaInfo.none.rawValue)
//
////    guard let ctx = context else { return nil }
////    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//    
//    guard var newBuf = try? vImage_Buffer(width: width,
//                                          height: height,
//                                          bitsPerPixel: fmt.bitsPerPixel) else {
//        return nil
//    }
//    
//    defer {
//        newBuf.free()
//    }
//    
//    let scale: Float = 1.0 / 255.0
//    
//    // convert to float buf
//    vImageConvert_Planar8toPlanarF(&buf, &newBuf, scale, 0, vImage_Flags(kvImageNoFlags))
//    
//    let floatPointer = newBuf.data.assumingMemoryBound(to: Float.self)
//    let pixelArray = Array(UnsafeBufferPointer(start: floatPointer, count: count))
//
//    var mean: Float = 0.0
//    var stdev: Float = 0.0
//    
//    vDSP_normalize(pixelArray, 1, nil, 1, &mean, &stdev, vDSP_Length(count))
////    vDSP_normalize(pixelArray, standardDeviation: &stdev, mean: &mean, result: &normalizedPixels)
//
////    return (CGFloat(mean) / 255.0, CGFloat(stdev) / (255.0)) // Normalize
//    return (mean, stdev)
//}


/// For reference: `x` is `img1` (e.g `mean_x` is the mean for `img1`) and `y` is `img2`
func ssim(_ img1: CGImage, _ img2: CGImage) throws -> Float {
    guard img1.bytesPerRow == img2.bytesPerRow else {
        debugPrint(img1.bytesPerRow, img2.bytesPerRow)
        throw ImageError.invalidInput
    }
    
    debugPrint("IMAGES")
    debugPrint(img1, img2)
    
    // get two images
    
    let width = img1.width
    let height = img1.height
    let count = width * height
    
    debugPrint("IMAGE BOUNDS")
    debugPrint(width, height, count)
    
    // store as image buffers
    guard let img1Format = vImage_CGImageFormat(cgImage: img1),
          var img1Buffer = try? vImage_Buffer(cgImage: img1, format: img1Format) else {
        throw ImageError.unknown
    }
    
    debugPrint("IMAGE 1 BUFFER")
    debugPrint(img1Buffer)
    
    guard let img2Format = vImage_CGImageFormat(cgImage: img2),
          var img2Buffer = try? vImage_Buffer(cgImage: img2, format: img2Format) else { throw ImageError.unknown }
    
    debugPrint("IMAGE 2 BUFFER")
    debugPrint(img2Buffer)
    
    // produce new buffers for float operations
    guard var img1FloatBuffer = try? vImage_Buffer(width: width, height: height, bitsPerPixel: img1Format.bitsPerPixel),
          var img2FloatBuffer = try? vImage_Buffer(width: width, height: height, bitsPerPixel: img1Format.bitsPerPixel) else { throw ImageError.unknown }
    
    
    defer { img1FloatBuffer.free(); img2FloatBuffer.free() }
    
    let scale: Float = 1.0 / 255.0
    
    vImageConvert_Planar8toPlanarF(&img1Buffer, &img1FloatBuffer, scale, 0, vImage_Flags(kvImageNoFlags))
    vImageConvert_Planar8toPlanarF(&img2Buffer, &img2FloatBuffer, scale, 0, vImage_Flags(kvImageNoFlags))
    
    debugPrint("IMAGE FLOAT BUFFERS")
    debugPrint(img1FloatBuffer, img2FloatBuffer)
    
    // get pointers for each buffer for array actions
    
//    let img1FloatPointer = img1FloatBuffer.data.assumingMemoryBound(to: Float.self)
//    let img1PixelArray = Array(UnsafeBufferPointer(start: img1FloatPointer, count: count))
    let img1PixelArray = img1FloatBuffer.data.withMemoryRebound(to: Float.self, capacity: count) { pointer in
        Array(UnsafeBufferPointer(start: UnsafePointer<Float>(pointer), count: count))
    }
    
    debugPrint("IMAGE 1 BUFFER")
//    debugPrint(img1PixelArray.count)
    
    let img2FloatPointer = img2FloatBuffer.data.assumingMemoryBound(to: Float.self)
    let img2PixelArray = Array(UnsafeBufferPointer(start: img2FloatPointer, count: count))
    
    debugPrint("IMAGE 2 BUFFER")
//    debugPrint(img2PixelArray.count)
    
    // produce mean and stdev for each
    var mean_x: Float = 0.0, stdev_x: Float = 0.0
    var mean_y: Float = 0.0, stdev_y: Float = 0.0

    
    vDSP_normalize(img1PixelArray, 1, nil, 1, &mean_x, &stdev_x, vDSP_Length(count))
    vDSP_normalize(img2PixelArray, 1, nil, 1, &mean_y, &stdev_y, vDSP_Length(count))
    
    if mean_x.isNaN { mean_x = 0.0 }
    if mean_y.isNaN { mean_y = 0.0 }
    
    debugPrint("Mean and Stdev")
    debugPrint(mean_x, stdev_x, "---", mean_y, stdev_y)
    
    // calculate the covariance
    let diff_x = vDSP.subtract(img1PixelArray, [Float](repeating: mean_x, count: count))
    let diff_y = vDSP.subtract(img2PixelArray, [Float](repeating: mean_y, count: count))
    
    var product = [Float](repeating: 0, count: count)
    vDSP_vmul(diff_x, 1, diff_y, 1, &product, 1, vDSP_Length(count))
    
    let covariance: Float = vDSP.mean(product)
    
    // get the parameters
    let k_1 = 0.01, k_2 = 0.03
    
    // c_1
    let c_1: Float = Float(pow((k_1 * 255), 2))
    // c_2
    let c_2: Float = Float(pow((k_2 * 255), 2))
    // c_3
    let c_3: Float = c_2 / 2
    
    // account for error or 0 stdev
    let epsilon: Float = 1e-6
    
    // calculate the three functions for ssim
    let luminance_similarity: Float = ((2 * mean_x * mean_y) + c_1) / (pow(mean_x, 2) + pow(mean_y, 2) + c_1)
    let contrast_similarity: Float = ((2 * stdev_x * stdev_y) + c_2) / (max(pow(stdev_x, 2), epsilon) + max(pow(stdev_y, 2), epsilon) + c_2)
    let structural_similarity: Float = (covariance + c_3) / (stdev_x * stdev_y + c_3)
    
    // evaluate the ssim
    let ssim = luminance_similarity * contrast_similarity * structural_similarity
    
    // return
    return ssim
}

import SwiftUI

struct SSIMTestingInterface: View {
    var c1: CGImage
    var c2: CGImage
    
    init(c1: CGImage, c2: CGImage) {
        self.c1 = c1
        self.c2 = c2
    }
    
    var similarity: Float? {
        try? ssim(c1, c2)
    }
    
    @ViewBuilder func display(img: CGImage) -> some View {
        Group {
            if #available(macCatalyst 18.0, iOS 18.0, *) {
                Image(img, scale: 1, label: Text("Image 1"))
                    .resizable()
                    .frame(width: 200, height: 200)
                    .labelsVisibility(.visible)
            } else {
                Image(img, scale: 1, label: Text("Image 1"))
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 50) {
                display(img: c1)
                display(img: c2)
            }
            Text("SSIM: \(similarity ?? -1)")
        }
    }
}

//struct SSIMTextTestingInterface: View {
//    var body: some View {
//        
//    }
//}

func createTestGradientImage(width: Int, height: Int) -> CGImage? {
    let bitsPerComponent = 8   // 8-bit grayscale
    let bitsPerPixel = 8
    let bytesPerRow = width    // 1 byte per pixel in grayscale
    let colorSpace = CGColorSpaceCreateDeviceGray()

    var pixelData = [UInt8](repeating: 0, count: width * height)
    
    // Generate a simple gradient pattern
    for y in 0..<height {
        for x in 0..<width {
            let pixelIndex = y * width + x
            pixelData[pixelIndex] = UInt8((x + y) % 256) // Simple gradient
        }
    }

    guard let provider = CGDataProvider(data: Data(pixelData) as CFData) else { return nil }
    
    return CGImage(
        width: width,
        height: height,
        bitsPerComponent: bitsPerComponent,
        bitsPerPixel: bitsPerPixel,
        bytesPerRow: bytesPerRow,
        space: colorSpace,
        bitmapInfo: CGBitmapInfo(rawValue: 0),
        provider: provider,
        decode: nil,
        shouldInterpolate: false,
        intent: .defaultIntent
    )
}


#Preview {
    SSIMTestingInterface(c1: createTestGradientImage(width: 100, height: 100)!, c2: createTestGradientImage(width: 100, height: 100)!)
}

#Preview("Text SSIM") {
    let t1 = "SSIM".dotted_image(20)
    let t2 = "SSIM".dotted_image(20)
    
    SSIMTestingInterface(c1: t1!, c2: t2!)
}


