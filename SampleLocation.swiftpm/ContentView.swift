import SwiftUI
import UIKit

struct ContentView: View {
  var body: some View {
    TabView {
      let staticLocationViewModel = StaticLocationViewModel()
      StaticLocationView(viewModel: staticLocationViewModel)
        .tabItem {
          Text("Static")
        }
      let dynamicLocationViewModel = DynamicLocationViewModel()
      DynamicLocationView(viewModel: dynamicLocationViewModel)
        .tabItem {
          Text("Dynamic")
        }
    }
  }
}
