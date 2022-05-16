import SwiftUI

struct ContentView: View {
  @State var results: [PhotoResult] = []
  @State var isPresentedPhotoPicker = false
  @State var didPickPhoto = true

  var body: some View {
    VStack {
      Button(action: {
        isPresentedPhotoPicker = true
        didPickPhoto = false
      }, label: {
        Image(systemName: "photo")
      })
      .padding()
      .disabled(!didPickPhoto)
      .sheet(isPresented: $isPresentedPhotoPicker) {
        PhotoPicker(results: $results, didPickPhoto: $didPickPhoto)
      }

      ScrollView(.vertical) {
        ForEach(results) { result in
          PhotoView(item: result.item)
            .frame(height: 300)
        }
      }
    }
  }
}
