import Shakuro_iOS_Toolbox
import SwiftyJSON

final class ContributorParser: AppAPIClientParser<[Contributor]> {

    override func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws -> [Contributor] {
        return try parseContributorData(data: serializedResponse)
    }

    private func parseContributorData(data: JSON) throws -> [Contributor] {

        guard let array = data.array else {
            throw HTTPClient.Error.cantSerializeResponseData(underlyingError: nil)
        }
        var resultArray: [Contributor] = []
        for element in array {
            guard let dictionary = element.dictionary,
                  let id = dictionary["id"]?.int,
                  let login = dictionary["login"]?.string else {
                throw HTTPClient.Error.cantSerializeResponseData(underlyingError: nil)
            }
            let avatar = dictionary["avatar_url"]?.string
            resultArray.append(Contributor(id: id, login: login, avatarURLString: avatar))
        }
        return resultArray
    }

}

struct Contributor {
    let id: Int
    let login: String
    let avatarURLString: String?

    var avatarURL: URL? {
        if let avatarURLString = avatarURLString {
            return URL(string: avatarURLString)
        } else {
            return nil
        }
    }
}
