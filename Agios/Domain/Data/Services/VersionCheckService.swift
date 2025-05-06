import Foundation

class VersionCheckService {
    static let shared = VersionCheckService()
    
    private init() {}

    func checkVersion(currentVersion: String) async throws -> VersionCheckResponse {
        guard let url = URL(string: "https://api.agios.co/versionCheck?current_version=\(currentVersion)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(VersionCheckResponse.self, from: data)
    }
}
