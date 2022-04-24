import SwiftUI
import CoreLocation

struct DynamicLocationView: View {
  @StateObject var viewModel: DynamicLocationViewModel

  var body: some View {
    VStack {
      Button {
        Task {
          await viewModel.getLocation()
        }
      } label: {
        Text("Start Location")
      }
      .alert("Location Error", isPresented: $viewModel.didLocationError) {
      } message: {
        Text("Not found location")
      }
      .alert("Location Error", isPresented: $viewModel.didAuthorizationError) {
      } message: {
        Text("Authorization Error")
      }
      Button {
        viewModel.locationManager.stopUpdatingLocation()
      } label: {
        Text("Stop Location")
      }

      if let coordinate = viewModel.coordinate {
        Text("\(coordinate.latitude), \(coordinate.longitude)")
      }

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

extension DynamicLocationViewModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      didLocationError = true
      return
    }

    self.coordinate = location.coordinate

    Task {
      do {
        self.place = try await CLGeocoder().reverseGeocodeLocation(location).first
      } catch {
        print(error)
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
    didLocationError = true
  }
}

@MainActor  class DynamicLocationViewModel: NSObject, ObservableObject {
  @Published var place: CLPlacemark?
  @Published var didAuthorizationError = false
  @Published var didLocationError = false
  @Published var coordinate: CLLocationCoordinate2D?

  let locationManager = CLLocationManager()

  override init() {
    super.init()
    locationManager.delegate = self
  }

  func getLocation() async {
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
        locationManager.startUpdatingLocation()
      case .authorizedWhenInUse:
        locationManager.startUpdatingLocation()
      @unknown default:
        fatalError()
    }
  }
}
