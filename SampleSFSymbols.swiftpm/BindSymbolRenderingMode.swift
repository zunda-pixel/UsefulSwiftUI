import SwiftUI

enum BindSymbolRenderingMode: String, CaseIterable, Hashable, Identifiable {
  case palette
  case multicolor
  case hierarchical
  case monochrome

  var id: String {
    return self.rawValue
  }

  var bind: SymbolRenderingMode {
    switch self {
      case .palette: return .palette
      case .multicolor: return .multicolor
      case .hierarchical: return .hierarchical
      case .monochrome: return .monochrome
    }
  }
}
