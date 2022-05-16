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
        ForEach(0..<results.count, id: \.self) { i in
          PhotoView(provider: results[i].provider, item: .init(get: { results[i].item }, set: { results[i].item = $0 }))
            .frame(height: 300)
        }
      }
    }
  }
}
