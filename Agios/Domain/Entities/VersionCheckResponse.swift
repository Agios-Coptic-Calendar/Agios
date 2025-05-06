import Foundation

struct VersionCheckResponse: Decodable {
    let type: UpdateType
    let latestVersion: String
    let minRequiredVersion: String
    let updateUrl: String
    let message: String
}

enum UpdateType: String, Decodable {
    case none
    case optional
    case force
}
