import Foundation

class VersionCheckViewModel: ObservableObject {
    @Published var updateType: UpdateType = .none
    @Published var updateMessage: String = ""
    @Published var updateUrl: String = ""
    @Published var versionUpdateIsExpanded = false

    func performVersionCheck() async {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return
        }
        do {
            let response = try await VersionCheckService.shared.checkVersion(currentVersion: currentVersion)
            DispatchQueue.main.async {
                self.updateType = response.type
                self.updateMessage = response.message
                self.updateUrl = response.updateUrl
            }
        } catch {
            print("Failed to check version: \(error)")
        }
    }
}
