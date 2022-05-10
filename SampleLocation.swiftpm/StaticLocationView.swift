import SwiftUI
import CoreLocation
import CoreLocationUI

struct StaticLocationView: View {
  @StateObject var viewModel: StaticLocationViewModel

  var body: some View {
    VStack {
      LocationButton(.currentLocation) {
        Task {
          viewModel.place = await viewModel.getLocation()
        }
      }
      .symbolVariant(.circle)
      .tint(.red)
      .foregroundStyle(.white)
      .labelStyle(.iconOnly)

      if let place = viewModel.place {
        LocationCellView(place: place)
          .padding()
          .overlay {
            RoundedRectangle(cornerRadius: 14, style: .circular)
              .strokeBorder(.black.opacity(0.5), lineWidth: 3)
          }
      }
    }
  }
}

@MainActor class StaticLocationViewModel: NSObject, ObservableObject {
  @Published var place: CLPlacemark?
  @Published var error: Error?
  private let manager = CLLocationManager()

  override init() {
    super.init()
    manager.delegate = self
  }

  func getLocation() async -> CLPlacemark? {
    guard let location =  manager.location else {
      return nil
    }

    let places = try? await CLGeocoder().reverseGeocodeLocation(location)

    return places?.last
  }
}

extension StaticLocationViewModel: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    Task {
      self.place = await getLocation()
    }
  }
}
