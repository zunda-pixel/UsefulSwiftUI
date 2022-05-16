import UIKit
import AVFoundation

extension UIImage {
  public convenience init(movieURL url: URL) throws {
    let asset: AVAsset = .init(url: url)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    let cgImage = try generator.copyCGImage(at: asset.duration, actualTime: nil)
    self.init(cgImage: cgImage)
  }
}
