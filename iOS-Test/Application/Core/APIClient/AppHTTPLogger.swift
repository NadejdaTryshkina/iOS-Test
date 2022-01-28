//
//
//

import Alamofire
import Foundation
import Shakuro_iOS_Toolbox
import SwiftyJSON

internal class AppHTTPLogger: HTTPClientLogger {

    private enum Constant {
        static let tab: String = "    "
        static let bannedValue: String = "xxxxxx"
        static let bannedParameters: [String] = [
            "username",
            "password",
            "apiUser",
            "apiPw",
            "customerUsername",
            "customerPassword",
            "client_secret"
        ]
        static let bannedHeaders = [
            "apijwt",
            "Authorization"
        ]
        static let bannedResponseKeys = [
            "accessJwt",
            "access_token",
            "refreshJwt",
            "refresh_token"
        ]
        static let unwrapTokensKeys = [
            "accessJwt",
            "access_token"
        ]
    }

    // MARK: - HTTPClientLogger

    func clientDidCreateRequest<ParserType>(requestOptions: HTTPClient.RequestOptions<ParserType>,
                                            resolvedHeaders: HTTPHeaders) where ParserType: HTTPClientParser {
        let tab = Constant.tab
        var requestDescription = "Request: "
        requestDescription.append("\n\(tab)url: \(requestOptions.endpoint.urlString())")
        requestDescription.append("\n\(tab)timeoutInterval: \(requestOptions.timeoutInterval)")
        requestDescription.append("\n\(tab)method: \(requestOptions.method)")
        requestDescription.append("\n\(tab)allHTTPHeaderFields: \(censorHeaders(resolvedHeaders))")
        if var realParameters = requestOptions.parameters {
            switch realParameters {
            case .httpBody(let arrayBrakets, let parameters):
                realParameters = .httpBody(arrayBrakets: arrayBrakets, parameters: censorParameters(parameters))
            case .urlQuery(let arrayBrakets, let parameters):
                realParameters = .urlQuery(arrayBrakets: arrayBrakets, parameters: censorParameters(parameters))
            case .json(let parameters):
                if let typedParameters = parameters as? [String: Any] {
                    realParameters = .json(parameters: censorParameters(typedParameters))
                } else {
                    realParameters = .json(parameters: parameters)
                }
            }
            requestDescription.append("\n\(tab)parameters: \(realParameters)")
        }
        if let authCredentialActual = requestOptions.authCredential {
            let credentialForLog = URLCredential(user: Constant.bannedValue,
                                                 password: Constant.bannedValue,
                                                 persistence: authCredentialActual.persistence)
            requestDescription.append("\n\(tab)authCredential: \(credentialForLog)")
        }

        Logger.writeInfoLog(requestDescription)
    }

    func clientDidReceiveResponse<ParserType>(requestOptions: HTTPClient.RequestOptions<ParserType>,
                                              request: URLRequest?,
                                              response: HTTPURLResponse?,
                                              responseData: Data?,
                                              responseError: Error?) where ParserType: HTTPClientParser {
        let codeString: String
        if let statusCode = response?.statusCode {
            codeString = "\(statusCode)"
        } else {
            codeString = "unknown"
        }
        let responseHeaderDescription = response?.allHeaderFields.description ?? "No Response Header"
        let responseDataDescription = censorResponseData(responseData)

        let tab = Constant.tab

        var responseDescription = "Response:"
        responseDescription.append("\n\(tab)url: \(requestOptions.endpoint.urlString())")
        responseDescription.append("\n\(tab)status code: \(codeString)")
        if let error = responseError {
            responseDescription.append("\n\(tab)error: \(error)")
        }
        responseDescription.append("\n\(tab)headers:\n\(responseHeaderDescription)")
        responseDescription.append("\n\(tab)data:\n\(responseDataDescription)")

        Logger.writeInfoLog(responseDescription)
    }

    func requestWasCancelled<ParserType>(requestOptions: HTTPClient.RequestOptions<ParserType>,
                                         request: URLRequest?,
                                         response: HTTPURLResponse?,
                                         responseData: Data?) where ParserType: HTTPClientParser {
        // already handled by clientDidReceiveResponse()
    }

    func parserDidFindError<ParserType>(requestOptions: HTTPClient.RequestOptions<ParserType>,
                                        request: URLRequest?,
                                        response: HTTPURLResponse?,
                                        responseData: Data?,
                                        parsedError: Error) where ParserType: HTTPClientParser {
        let tab = Constant.tab
        var responseDescription = "Response:"
        responseDescription.append("\n\(tab)url: \(requestOptions.endpoint.urlString())")
        responseDescription.append("\n\(tab)parser found error: \(String(describing: parsedError))")
        // response body already logged in clientDidReceiveResponse()
        Logger.writeInfoLog(responseDescription)
    }

    func clientDidEncounterNetworkError<ParserType>(requestOptions: HTTPClient.RequestOptions<ParserType>,
                                                    request: URLRequest?,
                                                    response: HTTPURLResponse?,
                                                    responseData: Data?,
                                                    networkError: Error) where ParserType: HTTPClientParser {
        // already covered by clientDidReceiveResponse()
    }

    func clientDidEncounterSerializationError<ParserType>(requestOptions: HTTPClient.RequestOptions<ParserType>,
                                                          request: URLRequest?,
                                                          response: HTTPURLResponse?,
                                                          responseData: Data?,
                                                          serializationError: Error) where ParserType: HTTPClientParser {
        let tab = Constant.tab
        var responseDescription = "Response:"
        responseDescription.append("\n\(tab)url: \(requestOptions.endpoint.urlString())")
        responseDescription.append("\n\(tab)serialization error: \(String(describing: serializationError))")
        // response body already logged in clientDidReceiveResponse()
        Logger.writeInfoLog(responseDescription)
    }

    func clientDidEncounterParseError<ParserType>(requestOptions: HTTPClient.RequestOptions<ParserType>,
                                                  request: URLRequest?,
                                                  response: HTTPURLResponse?,
                                                  responseData: Data?,
                                                  parseError: Error) where ParserType: HTTPClientParser { }
}

// MARK: - Private

private extension AppHTTPLogger {

    private func censorResponseData(_ data: Data?) -> String {
        guard let responseRawData = data, !responseRawData.isEmpty else {
            return "No Response Data"
        }
        if let json = try? JSON(data: responseRawData) {
            var jsonCensored = json
            for bannedResponseKey in Constant.bannedResponseKeys {
                let value = jsonCensored[bannedResponseKey]
                if value.exists() {
                    jsonCensored[bannedResponseKey] = JSON(rawValue: Constant.bannedValue) ?? JSON()
                }
            }
            if let jsonDescription = jsonCensored.rawString(options: .prettyPrinted) {
                return jsonDescription
            }
        }
        if let responseDataString = String(data: responseRawData, encoding: .utf8) {
            return responseDataString
        } else {
            return "\(responseRawData)"
        }
    }

    private func censorParameters(_ parameters: [String: Any]) -> [String: Any] {
        var censoredParameters = parameters
        for bannedParam in Constant.bannedParameters where censoredParameters[bannedParam] != nil {
            censoredParameters[bannedParam] = Constant.bannedValue
        }
        return censoredParameters
    }

    private func censorHeaders(_ headers: HTTPHeaders) -> HTTPHeaders {
        var censoredHeaders = headers
        for bannedHeader in Constant.bannedHeaders where censoredHeaders.value(for: bannedHeader) != nil {
            censoredHeaders.update(name: bannedHeader, value: Constant.bannedValue)
        }
        return censoredHeaders
    }

}
