import Alamofire
import Shakuro_iOS_Toolbox
import Shakuro_TaskManager

struct LoadContributorsOperationOptions: BaseOperationOptions {
    let apiClient: AppAPIClient
}

class LoadContributorsOperation: BaseOperation<[Contributor], LoadContributorsOperationOptions> {

    private var loadContributorsRequest: Alamofire.Request?

    override func main() {
        let requestOptions = HTTPClient.RequestOptions(endpoint: AppAPIClientEndPoint.contributors,
                                                       method: .get,
                                                       parser: ContributorParser())
        loadContributorsRequest = options.apiClient.sendRequest(options: requestOptions, completion: { (result) in
            guard !self.isCancelled else {
                self.finish(result: .cancelled)
                return
            }
            switch result {
            case .success(result: let result):
                self.finish(result: .success(result: result))
            case .cancelled:
                self.finish(result: .cancelled)
            case .failure(error: let error):
                self.finish(result: .failure(error: error))
            }
        })
    }

    override func internalCancel() {
        loadContributorsRequest?.cancel()
    }

    override func internalFinished() {
        loadContributorsRequest = nil
    }

}
