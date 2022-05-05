import SwiftUI

extension SymbolVariants: CaseIterable, RawRepresentable, Identifiable {
  public var id: String {
    self.rawValue
  }

  public init?(rawValue: String) {
    switch rawValue {
      case "square": self = .square
      case "fill": self = .fill
      case "rectangle": self = .rectangle
      case "circle": self = .circle
      case "slash": self = .slash
      case "none": self = .none
      default: return nil
    }
  }

  public var rawValue: String {
    switch self {
      case .square: return "square"
      case .fill: return "fill"
      case .rectangle: return "rectangle"
      case .circle: return "circle"
      case .slash: return "slash"
      case .none: return "none"
      default:
        fatalError()
    }
  }

  public static var allCases: [SymbolVariants] {
    return [.fill, .rectangle, .circle, .slash, .none, .square]
  }
}
