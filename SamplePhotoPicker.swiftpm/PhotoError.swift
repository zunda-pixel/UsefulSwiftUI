import Foundation

enum PhotoError: Error, LocalizedError {
  case invalidCast
  case missingData
  case unknown
}
