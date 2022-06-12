//
//  PhotoView.swift
//  SamplePhotoPicker
//
//  Created by zunda on 2022/06/13.
//


import SwiftUI
import PhotosUI
import AVKit
import PhotoPicker

struct PhotoView: View {
  let item: Any

  @State var isPresentedVideoPlayer = false

  var body: some View {
    switch item {
      case let livePhoto as PHLivePhoto:
        LivePhoto(livePhoto: livePhoto)
      case let uiImage as UIImage:
        Image(uiImage: uiImage)
          .resizable()
      case let movie as Movie:
        ZStack {
          Image(uiImage: movie.thumbnail)
            .resizable()
          Image(systemName: "play")
        }
        .onTapGesture {
          isPresentedVideoPlayer.toggle()
        }
        .sheet(isPresented: $isPresentedVideoPlayer) {
          let player: AVPlayer = .init(url: movie.path)
          VideoPlayer(player: player)
            .onAppear {
              player.play()
            }
        }
        Text("")
      default:
        fatalError()
    }
  }
}
