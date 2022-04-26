import SwiftUI

extension SymbolRenderingMode: CaseIterable, Identifiable, Hashable, RawRepresentable {
  public var id: String {
    return self.rawValue
  }
  
  public init?(rawValue: String) {
    switch rawValue {
      case "palette": self = .palette
      case "multicolor": self = .multicolor
      case "hierarchical": self = .hierarchical
      case "monochrome": self = .monochrome
      default:
        return nil
    }
  }

  public var rawValue: String {
    switch self {
      case .palette: return "palette"
      case .multicolor: return "multicolor"
      case .hierarchical: return "hierarchical"
      case .monochrome: return "monochrome"
      default: fatalError()
    }
  }

  public static var allCases: [SymbolRenderingMode] {
    return [.monochrome, .hierarchical, .multicolor, .palette]
  }
}
