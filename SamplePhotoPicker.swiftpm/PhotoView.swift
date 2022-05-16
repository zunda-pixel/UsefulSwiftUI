import SwiftUI
import PhotosUI
import AVKit

struct PhotoView: View {
  let item: NSItemProviderReading
  @State var isPresentedVideoPlayer = false
  @State var didError = false
  @State var error: PhotoError?

  var body: some View {
    GeometryReader { geometry in
      if let item = item {
        switch item {
          case let livePhoto as PHLivePhoto:
            LivePhoto(livePhoto: livePhoto)
          case let uiImage as UIImage:
            Image(uiImage: uiImage)
              .resizable()
              .aspectRatio(contentMode: .fit)
          case let movieURL as URL:
            ZStack {
              if let uiImage = try? UIImage(movieURL: movieURL) {
                Image(uiImage: uiImage)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                Image(systemName: "play")
              } else {
                Text("Failed Load Image")
              }
            }
            .onTapGesture {
              isPresentedVideoPlayer = true
            }
            .sheet(isPresented: $isPresentedVideoPlayer) {
              let player: AVPlayer = .init(url: movieURL)
              VideoPlayer(player: player)
                .onAppear {
                  player.play()
                }
            }
          default:
            Text("Failed Load Error")
        }
      }
    }
    .alert(isPresented: $didError, error: error) {
      Text("load error")
    }
  }
}
