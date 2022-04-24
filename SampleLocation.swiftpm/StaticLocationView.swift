import SwiftUI
import CoreLocation

struct StaticLocationView: View {
  @StateObject var viewModel: StaticLocationViewModel

  var body: some View {
    VStack {
      Button {
        Task {
          await viewModel.getLocation()
        }
      } label: {
        Text("Get Location")
      }
      .disabled(viewModel.loadingLocation)
      .alert("Location Error", isPresented: $viewModel.didLocationError) {
      } message: {
        Text("Not found location")
      }
      .alert("Location Error", isPresented: $viewModel.didAuthorizationError) {
      } message: {
        Text("Authorization Error")
      }
      ForEach(viewModel.places, id: \.location) { place in
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

@MainActor  class StaticLocationViewModel: ObservableObject {
  @Published var places: [CLPlacemark] = []
  @Published var didAuthorizationError = false
  @Published var didLocationError = false
  @Published var loadingLocation = false

  func getLocation() async {
    defer {
      loadingLocation = false
    }

    loadingLocation = true

    let locationManager = CLLocationManager()

    switch locationManager.authorizationStatus {
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        return
      case .restricted:
        didAuthorizationError = true
        return
      case .denied:
        didAuthorizationError = true
        return
      case .authorizedAlways:
        break
      case .authorizedWhenInUse:
        break
      @unknown default:
        fatalError()
    }

    guard let location = locationManager.location else {
      didLocationError = true
      return
    }

    do {
      self.places = try await CLGeocoder().reverseGeocodeLocation(location)
    } catch {
      print(error)
    }
  }
}
