import Foundation

extension NSItemProvider {
  public func loadFileRepresentation(forTypeIdentifier typeIdentifier: String) async throws -> URL {
    try await withCheckedThrowingContinuation { continuation in
      self.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
        if let error = error {
          return continuation.resume(throwing: error)
        }

        guard let url = url else {
          return continuation.resume(throwing: NSError())
        }

        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: localURL)

        do {
          try FileManager.default.copyItem(at: url, to: localURL)
        } catch {
          return continuation.resume(throwing: error)
        }

        continuation.resume(returning: localURL)
      }.resume()
    }
  }

  public func loadObject(ofClass aClass : NSItemProviderReading.Type) async throws -> NSItemProviderReading {
    try await withCheckedThrowingContinuation { continuation in
      self.loadObject(ofClass: aClass) { data, error in
        if let error = error {
          return continuation.resume(throwing: error)
        }

        guard let data = data else {
          return continuation.resume(throwing: NSError())
        }

        continuation.resume(returning: data)
      }.resume()
    }
  }
}
