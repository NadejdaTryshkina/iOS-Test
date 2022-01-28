import Shakuro_iOS_Toolbox

extension HTTPClient.Error: AppErrorProtocol {

    func errorTitle() -> String {
        return NSLocalizedString("Pparsing error", comment: "")
    }

    func errorDescription() -> String {
        switch self {
        case .cantParseSerializedResponse:
            return NSLocalizedString("Can not parse serialized response", comment: "")
        case .cantSerializeResponseData:
            return NSLocalizedString("Can not serialize response data", comment: "")
        }
    }

}
