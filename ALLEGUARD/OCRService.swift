import Foundation
import UIKit
import Vision
import CoreImage

final class OCRService {

    static func recognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
        // Pre-process on a background thread — the Vision request runs there too
        DispatchQueue.global(qos: .userInitiated).async {
            guard let processed = preprocess(image),
                  let cgImage = processed.cgImage else {
                DispatchQueue.main.async { completion("") }
                return
            }

            // Map UIImage orientation to CGImagePropertyOrientation so
            // Vision doesn't analyse the image sideways on portrait photos
            let orientation = cgOrientation(from: image.imageOrientation)

            let request = VNRecognizeTextRequest { request, error in
                guard error == nil else {
                    DispatchQueue.main.async { completion("") }
                    return
                }

                let text = (request.results as? [VNRecognizedTextObservation] ?? [])
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")

                DispatchQueue.main.async { completion(text) }
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage,
                                                orientation: orientation,
                                                options: [:])
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async { completion("") }
            }
        }
    }

    // MARK: - Pre-processing

    /// Applies contrast enhancement and returns a normalised UIImage.
    /// The input UIImage already carries correct orientation metadata in
    /// imageOrientation — we preserve that through the CIImage round-trip.
    private static func preprocess(_ image: UIImage) -> UIImage? {
        // Build CIImage from the CGImage so CIFilter can work on it.
        // We pass the orientation explicitly so the filter output is
        // correctly oriented when we convert back.
        guard let cgSource = image.cgImage else { return image }

        var ciImage = CIImage(cgImage: cgSource)

        // Apply EXIF orientation so the CIImage is upright before filtering
        let ciOrientation = image.imageOrientation
        ciImage = ciImage.oriented(ciOrientation)

        // Contrast + vibrance boost — helps with low-light label photos.
        // Controls are conservative so well-lit photos aren't over-processed.
        let boosted: CIImage
        if let filter = CIFilter(name: "CIVibrance") {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            filter.setValue(0.3, forKey: "inputAmount")   // gentle vibrance lift
            boosted = filter.outputImage ?? ciImage
        } else {
            boosted = ciImage
        }

        // Mild sharpening to help OCR on slightly blurry photos
        let sharpened: CIImage
        if let filter = CIFilter(name: "CIUnsharpMask") {
            filter.setValue(boosted, forKey: kCIInputImageKey)
            filter.setValue(0.8, forKey: kCIInputRadiusKey)
            filter.setValue(0.6, forKey: kCIInputIntensityKey)
            sharpened = filter.outputImage ?? boosted
        } else {
            sharpened = boosted
        }

        let context = CIContext(options: [.useSoftwareRenderer: false])
        guard let outputCG = context.createCGImage(sharpened, from: sharpened.extent) else {
            return image
        }

        // Return as UIImage with .up orientation — the CIImage round-trip
        // has already baked in the correct orientation
        return UIImage(cgImage: outputCG, scale: image.scale, orientation: .up)
    }

    // MARK: - Orientation mapping

    /// Converts UIImage.Orientation to CGImagePropertyOrientation.
    /// Without this, Vision treats every photo as if it were taken in
    /// landscape-right, producing rotated or mirrored OCR results.
    private static func cgOrientation(from ui: UIImage.Orientation) -> CGImagePropertyOrientation {
        switch ui {
        case .up:            return .up
        case .down:          return .down
        case .left:          return .left
        case .right:         return .right
        case .upMirrored:    return .upMirrored
        case .downMirrored:  return .downMirrored
        case .leftMirrored:  return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default:    return .up
        }
    }
}

// MARK: - CIImageOrientation helper

private extension CIImage {
    func oriented(_ uiOrientation: UIImage.Orientation) -> CIImage {
        let mapping: [UIImage.Orientation: CGImagePropertyOrientation] = [
            .up:            .up,
            .down:          .down,
            .left:          .left,
            .right:         .right,
            .upMirrored:    .upMirrored,
            .downMirrored:  .downMirrored,
            .leftMirrored:  .leftMirrored,
            .rightMirrored: .rightMirrored
        ]
        let cgOrientation = mapping[uiOrientation] ?? .up
        return self.oriented(cgOrientation)
    }
}
