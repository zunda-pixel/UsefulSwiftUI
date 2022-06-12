import SwiftUI
import PhotoPicker
import PhotosUI
import AVKit

struct Photo: Identifiable {
  let id: String?
  let item: Any
}

struct ContentView: View {
  @State var results: [PHPickerResult] = []
  @State var photos: [Photo] = []

  func loadPhotos(results: [PHPickerResult]) async throws {
    let originalPhotos = photos
    var newPhotos: [Photo] = []

    for result in results {
      if let foundPhoto = originalPhotos.first(where: { $0.id == result.assetIdentifier }) {
        newPhotos.append(foundPhoto)
      } else {
        let item = try await result.itemProvider.loadPhoto()
        let newPhoto: Photo = .init(id: result.assetIdentifier, item: item)
        newPhotos.append(newPhoto)
      }

      photos = newPhotos
    }
  }

  var body: some View {
    VStack {
      PhotosPicker(selection: $results,
                   maxSelectionCount: 0,
                   selectionBehavior: .ordered,
                   matching: nil,
                   preferredItemEncoding: .current,
                   photoLibrary: .shared()) {
        Image(systemName: "photo")
      }
        .onChange(of: results) { newResults in
          Task {
            do {
              try await loadPhotos(results: newResults)
            } catch {
              print(error)
            }
          }
        }

      ScrollView {
        ForEach(photos) { photo in
          PhotoView(item: photo.item)
            .scaledToFit()
            .frame(width: 200)
        }
      }
    }
  }
}
