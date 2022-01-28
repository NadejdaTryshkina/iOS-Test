import Shakuro_iOS_Toolbox
import SwiftyJSON

class AppAPIClientParser<T>: HTTPClientParser {

    typealias ResultType = T
    typealias ResponseValueType = JSON

    func serializeResponseData(_ responseData: Data?) throws -> JSON {
        guard let data = responseData else {
            return JSON()
        }
        return try JSON(data: data)
    }

    func parseForError(response: HTTPURLResponse?, responseData: Data?) -> Swift.Error? {
        guard let responseActual = response else {
            return nil
        }
        if let json = try? serializeResponseData(responseData),
           let errorsJSON = json["errors"].array?.first {
            if let code = errorsJSON["code"].string, code == "UNSUPPORTED_VERSION",
               let reason = errorsJSON["meta"]["reason"].string {
                switch reason {
                case "TOO_LOW":
                    return ServerAPIError.unsupportedVersionAPITooLow
                case "TOO_HIGH":
                    return ServerAPIError.unsupportedVersionAPITooHigh
                default:
                    break
                }
            }
        }
        switch responseActual.statusCode {
        case 401:
            return ServerAPIError.unAuthorized
        case 500:
            return ServerAPIError.internalServerError
        case 503:
            return ServerAPIError.serviceUnavailable
        default:
            break
        }
        return nil
    }

    func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws -> T {
        fatalError("abstract")
    }

}
