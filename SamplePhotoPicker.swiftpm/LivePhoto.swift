//
//  LivePhoto.swift
//  SamplePhotoPicker
//
//  Created by zunda on 2022/06/13.
//

import SwiftUI
import PhotosUI

struct LivePhoto: UIViewRepresentable {
  let livePhoto: PHLivePhoto

  func makeUIView(context: Context) -> PHLivePhotoView {
    let livePhotoView = PHLivePhotoView()
    livePhotoView.livePhoto = livePhoto
    return livePhotoView
  }

  func updateUIView(_ livePhotoView: PHLivePhotoView, context: Context) {
  }
}
