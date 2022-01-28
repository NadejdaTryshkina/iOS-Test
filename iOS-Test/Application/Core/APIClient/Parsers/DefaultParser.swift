import Shakuro_iOS_Toolbox
import SwiftyJSON

final class DefaultParser: AppAPIClientParser<Void> {

    override func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws {
        return ()
    }

}
