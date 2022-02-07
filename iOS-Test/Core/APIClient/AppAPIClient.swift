import Alamofire
import Foundation
import Shakuro_iOS_Toolbox

// MARK: - HTTPClient

class AppAPIClient: HTTPClient {

    private enum SupportVersionAPIHeader {
        static let name = "x-api-test"
        static let value = "1"
    }

    init() {
        super.init(name: "\(UIApplication.bundleIdentifier).app.test", logger: AppHTTPLogger())
    }

    override func commonHeaders() -> [HTTPHeader] {
        return [
            ContentType.applicationJSON.acceptHeader(),
            HTTPHeader(name: SupportVersionAPIHeader.name, value: SupportVersionAPIHeader.value)
        ]
    }

}

// MARK: - AppAPIClientEndPoint

enum AppAPIClientEndPoint {
    case contributors

    var pathString: String {
        switch self {
        case .contributors:
            return "repos/videolan/vlc/contributors"
        }
    }

}

// MARK: - HTTPClientAPIEndPoint

extension AppAPIClientEndPoint: HTTPClientAPIEndPoint {

    func urlString() -> String {
        return "\(serverURLString)\(pathString)"
    }

}

// MARK: - Private

private extension AppAPIClientEndPoint {

    private var serverURLString: String {
        return "https://api.github.com/"
    }
    
}
