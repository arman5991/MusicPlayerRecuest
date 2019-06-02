import UIKit

class RequestManager {
    class func getSongsByArtistName(_ name: String, completion: @escaping (_ musicItems: [MusicItem]) -> (), failure: @escaping (_ error: Error) -> ()) {
        let stringURL = baseURL + name
        if let url = URL(string: stringURL) {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error.debugDescription)
                    failure(error!)
                } else {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let result = try jsonDecoder.decode(MusicItems.self, from: data!)
                
                        completion(result.results)
                    } catch let err {
                        failure(err)
                        print(err.localizedDescription)
                    }
                }
            }.resume()
        }
    }
}
