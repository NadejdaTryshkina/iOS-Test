import Shakuro_iOS_Toolbox

enum ServerAPIError: AppErrorProtocol {

    case internalServerError
    case serviceUnavailable
    case unsupportedVersionAPITooLow
    case unsupportedVersionAPITooHigh
    case unAuthorized
    case unknown

    func errorTitle() -> String {
        return NSLocalizedString("Server error", comment: "")
    }

    func errorDescription() -> String {
        switch self {
        case .internalServerError:
            return NSLocalizedString("Unexpected server error.", comment: "")
        case .serviceUnavailable:
            return NSLocalizedString("The server is temporarily offline.", comment: "")
        case .unAuthorized:
            return NSLocalizedString("The user should be logged in for this request.", comment: "")
        case .unsupportedVersionAPITooLow:
            return NSLocalizedString("Update App", comment: "")
        case .unsupportedVersionAPITooHigh:
            return NSLocalizedString("Please wait", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }

}
