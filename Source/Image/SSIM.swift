import Accelerate
//
//  SSIM.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 21/02/2025.
//
import CoreGraphics
import SwiftUI

func grayscale(_ img: CGImage) -> CGImage? {
    do {
        guard
            let destinationFormat = vImage_CGImageFormat(
                bitsPerComponent: img.bitsPerComponent, bitsPerPixel: img.bitsPerPixel,
                colorSpace: CGColorSpaceCreateDeviceGray(),
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue))
        else { throw NSError() }

        guard let sourceFormat = vImage_CGImageFormat(cgImage: img) else { return nil }

        let grayscaleConverter = try vImageConverter.make(
            sourceFormat: sourceFormat, destinationFormat: destinationFormat)

        let width = img.width
        let height = img.height
        let count = width * height

        let sourceBuffer = try vImage_Buffer(cgImage: img, format: sourceFormat)

        var grayscaleDestinationBuffer = try vImage_Buffer(
            width: width, height: height,
            bitsPerPixel: destinationFormat.bitsPerPixel)

        try grayscaleConverter.convert(
            source: sourceBuffer,
            destination: &grayscaleDestinationBuffer)

        return try grayscaleDestinationBuffer.createCGImage(format: sourceFormat)
    } catch {
        if let err = error as? vImage.Error {
            debugPrint(err.localizedDescription, err)
        } else {
            debugPrint(error, error.localizedDescription)
        }
        return nil
    }

}

/// For reference: `x` is `img1` (e.g `mean_x` is the mean for `img1`) and `y` is `img2`
///
// TODO: This function doesn't work properly - fix before MVP
func ssim(_ img1: CGImage, _ img2: CGImage) throws -> Float {
    guard img1.bytesPerRow == img2.bytesPerRow else {
        debugPrint(img1.bytesPerRow, img2.bytesPerRow)
        throw ImageError.invalidInput
    }

    debugPrint("IMAGES")
    debugPrint(img1.width, img1.height, img1.bytesPerRow, img1.bitsPerPixel)
    debugPrint(img2.width, img2.height, img2.bytesPerRow, img2.bitsPerPixel)
    debugPrint("===========================")

    // grayscale images
    let bw_img1 = grayscale(img1) ?? img1
    let bw_img2 = grayscale(img2) ?? img2

    // get two images

    let width = img1.width
    let height = img1.height
    let count = width * height

    debugPrint("IMAGE BOUNDS")
    debugPrint(width, height, count)

    // convert the images to grayscale

    // store as image buffers
    guard let img1Format = vImage_CGImageFormat(cgImage: img1),
        var img1Buffer = try? vImage_Buffer(cgImage: img1, format: img1Format)
    else {
        throw ImageError.unknown
    }

    debugPrint("IMAGE 1 BUFFER")
    debugPrint(img1Buffer)

    guard let img2Format = vImage_CGImageFormat(cgImage: img2),
        var img2Buffer = try? vImage_Buffer(cgImage: img2, format: img2Format)
    else { throw ImageError.unknown }

    debugPrint("IMAGE 2 BUFFER")
    debugPrint(img2Buffer)

    // produce new buffers for float operations
    guard
        var img1FloatBuffer = try? vImage_Buffer(
            width: width, height: height, bitsPerPixel: img1Format.bitsPerPixel),
        var img2FloatBuffer = try? vImage_Buffer(
            width: width, height: height, bitsPerPixel: img2Format.bitsPerPixel)
    else { throw ImageError.unknown }

    defer {
        img1FloatBuffer.free()
        img2FloatBuffer.free()
    }

    let scale: Float = 1.0 / 255.0

    let _img1ConvertErr = vImageConvert_Planar8toPlanarF(
        &img1Buffer, &img1FloatBuffer, scale, 0, vImage_Flags(kvImageNoFlags))
    let _img2ConvertErr = vImageConvert_Planar8toPlanarF(
        &img2Buffer, &img2FloatBuffer, scale, 0, vImage_Flags(kvImageNoFlags))

    debugPrint("IMAGE FLOAT BUFFERS")
    debugPrint(img1FloatBuffer, img2FloatBuffer)
    debugPrint("Errors (1,2):", _img1ConvertErr, _img2ConvertErr)

    // get pointers for each buffer for array actions

    let img1FloatPointer = img1FloatBuffer.data.assumingMemoryBound(to: Float.self)
    let img1PixelArray = Array(UnsafeBufferPointer(start: img1FloatPointer, count: count))

    debugPrint("IMAGE 1 BUFFER")
    //    debugPrint(img1PixelArray.count)

    let img2FloatPointer = img2FloatBuffer.data.assumingMemoryBound(to: Float.self)
    let img2PixelArray = Array(UnsafeBufferPointer(start: img2FloatPointer, count: count))

    debugPrint("IMAGE 2 BUFFER")
    //    debugPrint(img2PixelArray.count)

    debugPrint("First 100 pixels of img1: \(Array(img1PixelArray.prefix(100)))")
    debugPrint("First 100 pixels of img2: \(Array(img2PixelArray.prefix(100)))")

    // produce mean and stdev for each
    //    var mean_x: Float = 0.0, stdev_x: Float = 0.0
    //    var mean_y: Float = 0.0, stdev_y: Float = 0.0
    //
    //    vDSP_normalize(img1PixelArray, 1, nil, 1, &mean_x, &stdev_x, vDSP_Length(count))
    //    vDSP_normalize(img2PixelArray, 1, nil, 1, &mean_y, &stdev_y, vDSP_Length(count))
    var mean_x = vDSP.mean(img1PixelArray)
    var mean_y = vDSP.mean(img2PixelArray)
    var (stdev_x, stdev_y) = {
        if #available(macCatalyst 18.0, iOS 18.0, *) {
            return (vDSP.standardDeviation(img1PixelArray), vDSP.standardDeviation(img2PixelArray))
        } else {
            // Fallback on earlier versions
            let m2_x = vDSP.meanSquare(img1PixelArray)
            let m2_y = vDSP.meanSquare(img2PixelArray)
            return (sqrt(m2_x - (mean_x * mean_x)), sqrt(m2_y - (mean_y * mean_y)))
        }
    }()

    //    var normalized_x = [Float](repeating: 0, count: count)
    //    var normalized_y = [Float](repeating: 0, count: count)
    //
    //    vDSP_normalize(img1PixelArray, 1, &normalized_x, 1, &mean_x, &stdev_x, vDSP_Length(count))
    //    vDSP_normalize(img2PixelArray, 1, &normalized_y, 1, &mean_y, &stdev_y, vDSP_Length(count))

    //    if stdev_x == 0 || stdev_y == 0 {
    //        return 0  // SSIM is meaningless if there's no variation
    //    }

    debugPrint("Mean and Stdev")
    debugPrint(mean_x, stdev_x, "<-x--y->", mean_y, stdev_y)

    // calculate the covariance
    let diff_x = vDSP.subtract(img1PixelArray, [Float](repeating: mean_x, count: count))
    let diff_y = vDSP.subtract(img2PixelArray, [Float](repeating: mean_y, count: count))

    var product = [Float](repeating: 0, count: count)
    vDSP_vmul(diff_x, 1, diff_y, 1, &product, 1, vDSP_Length(count))

    let covariance: Float = vDSP.mean(product)

    debugPrint("Covariance")
    debugPrint(covariance)

    // get the parameters
    let k_1 = 0.01
    let k_2 = 0.03

    // c_1
    let c_1: Float = Float(pow((k_1 * 256), 2))
    // c_2
    let c_2: Float = Float(pow((k_2 * 256), 2))
    // c_3
    let c_3: Float = c_2 / 2

    // account for error or 0 stdev
    let epsilon: Float = 1e-9
    let safe_stdev_x = stdev_x.isFinite ? max(stdev_x, epsilon) : epsilon
    let safe_stdev_y = stdev_y.isFinite ? max(stdev_y, epsilon) : epsilon

    // calculate the three functions for ssim
    let luminance_similarity: Float =
        ((2 * mean_x * mean_y) + c_1)
        / (max(pow(mean_x, 2), epsilon) + max(pow(mean_y, 2), epsilon) + c_1)
    let contrast_similarity: Float =
        ((2 * safe_stdev_x * safe_stdev_y) + c_2)
        / (pow(safe_stdev_x, 2) + pow(safe_stdev_y, 2) + c_2)
    let structural_similarity: Float = (covariance + c_3) / (safe_stdev_x * safe_stdev_y + c_3)

    debugPrint("SSIM Funcs")
    debugPrint("L:", luminance_similarity, "C:", contrast_similarity, "S:", structural_similarity)

    // evaluate the ssim
    let ssim = luminance_similarity * contrast_similarity * structural_similarity
    //    let ssim =
    //        (((2 * mean_x * mean_y) + c_1) * (2 * covariance + c_2))
    //        / ((max(pow(mean_x, 2), epsilon) + max(pow(mean_y, 2), epsilon) + c_1)
    //           * (pow(stdev_x, 2) + pow(stdev_y, 2) + c_2))

    // return
    return ssim
}

struct SSIMTestingInterface: View {
    var c1: CGImage
    var c2: CGImage

    init(c1: CGImage, c2: CGImage) {
        self.c1 = c1
        self.c2 = c2
    }

    var similarity: Float? {
        do {
            return try ssim(c1, c2)
        } catch {
            debugPrint(error)
            return nil
        }
    }

    @ViewBuilder func display(img: CGImage) -> some View {
        Group {
            if #available(macCatalyst 18.0, iOS 18.0, *) {
                Image(img, scale: 0.15, label: Text("Image 1"))
                    .labelsVisibility(.visible)
            } else {
                Image(img, scale: 0.15, label: Text("Image 1"))
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 10)
                display(img: c1)
                Spacer(minLength: 50)
                display(img: c2)
                Spacer(minLength: 10)
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
    let bitsPerComponent = 8  // 8-bit grayscale
    let bitsPerPixel = 8
    let bytesPerRow = width  // 1 byte per pixel in grayscale
    let colorSpace = CGColorSpaceCreateDeviceGray()

    var pixelData = [UInt8](repeating: 0, count: width * height)

    // Generate a simple gradient pattern
    for y in 0..<height {
        for x in 0..<width {
            let pixelIndex = y * width + x
            pixelData[pixelIndex] = UInt8((x + y) % 256)  // Simple gradient
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
    SSIMTestingInterface(
        c1: createTestGradientImage(width: 100, height: 100)!,
        c2: createTestGradientImage(width: 100, height: 100)!)
}

#Preview("Text SSIM") {
    let t1 = "SSIM".dotted_image(20)
    let t2 = "SSIM".dotted_image(20)

    SSIMTestingInterface(c1: t1!, c2: t2!)
}

#Preview("Dotted Text vs Text SSIM") {
    let t1 = "SSIM".dotted_image(20)
    let t2 = "SSIM".image(20)

    SSIMTestingInterface(c1: t1!, c2: t2!)
}

//#Preview("Unrelated Text SSIM") {
//    let t1 = "SSIM".dotted_image(20)
//    let t2 = "Sesame".image(20)
//
//    SSIMTestingInterface(c1: t1!, c2: t2!)
//}

#Preview("Unrelated Text SSIM") {
    let t1 = "SSIM".dotted_image(20)
    let t2 = "SXIM".dotted_image(20)

    SSIMTestingInterface(c1: t1!, c2: t2!)
}
