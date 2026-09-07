import Foundation

@MainActor
struct AppDependencies {
    let appClient: AppClientType
    let appSession: AppSessionType

    init(
        appClient: AppClientType? = nil,
        appSession: AppSessionType = AppSession.shared
    ) {
        self.appSession = appSession
        self.appClient = appClient ?? AppClient(session: appSession)
    }
}
