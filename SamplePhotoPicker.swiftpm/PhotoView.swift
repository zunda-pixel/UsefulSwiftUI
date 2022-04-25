import SwiftUI
import PhotosUI
import AVKit

struct PhotoView: View {
  let provider: NSItemProvider

  @Binding var item: NSItemProviderReading?
  @State var tappedImage: UIImage?
  @State var isPresentedVideoPlayer = false
  @State var didError = false
  @State var error: PhotoViewError?

  var body: some View {
    GeometryReader { geometry in
      if let item = item {
        if let livePhoto = item as? PHLivePhoto {
          LivePhoto(livePhoto: livePhoto)
        }
        else if let uiImage = item as? UIImage {
          Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
        } else if let url = item as? URL {
          ZStack {
            if let uiImage = try? UIImage(movieURL: url) {
              Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            }

            Image(systemName: "play")
          }
          .onTapGesture {
            isPresentedVideoPlayer.toggle()
          }
          .sheet(isPresented: $isPresentedVideoPlayer) {
            let player: AVPlayer = .init(url: url)
            VideoPlayer(player: player)
              .onAppear {
                player.play()
              }
          }
        }
      }
    }
    //.alert(isPresented: $didError, error: $error, actions: { Text("") })

    .onAppear {
      if item == nil {
        Task {
          do {
            item = try await provider.loadPhoto()
          } catch {
            print("error")
            self.error = .loadPhoto
            self.didError = true
          }
        }
      }
    }
  }
}
