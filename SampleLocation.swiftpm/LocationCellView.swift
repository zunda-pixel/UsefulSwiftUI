import SwiftUI
import CoreLocation

struct LocationCellView: View {
  let place: CLPlacemark

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        if let county = place.country {
          if let isoCountryCode = place.isoCountryCode {
            Text("\(county)(\(isoCountryCode))")
          } else {
            Text(county)
          }
        }

        if let timezone = place.timeZone?.identifier {
          Text("⏰\(timezone)")
        }
      }

      if let postalCode = place.postalCode {
        Text("〒\(postalCode)")
      }

      let locationInformation = [
        place.administrativeArea,
        place.subAdministrativeArea,
        place.locality,
        place.thoroughfare,
        place.subThoroughfare
      ]
        .compactMap { $0 }
        .joined(separator: " ")

      if locationInformation != "" {
        Text(locationInformation)
      }

      if let ocean = place.ocean {
        Text(ocean)
      }

      if let inlandWater = place.inlandWater {
        Text(inlandWater)
      }
    }
  }
}
