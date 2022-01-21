import UIKit

struct GifAPIClient {
    // TODO: Implement
    func getRequest <ResponseBody: Decodable>(params: [String:String] = [:], gifType: String, completion: @escaping (ResponseBody) -> Void) {
        
        let urlComp = NSURLComponents(string: "https://api.giphy.com/v1/gifs/\(gifType)")!
        
        var parameters = params
        parameters["api_key"] = Constants.giphyApiKey
        var items = [URLQueryItem]()
        
        for (key,value) in parameters {
            items.append(URLQueryItem(name: key, value: value))
        }
                
        urlComp.queryItems = items
        
        urlComp.percentEncodedQuery = urlComp.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {}
                        
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200,
               let result = try? JSONDecoder().decode(ResponseBody.self, from: data){
                completion(result)
            }
        })
        task.resume()
    }
}
