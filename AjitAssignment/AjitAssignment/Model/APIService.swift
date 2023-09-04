import Foundation

class APIService {
    
    static let shared = APIService()
    private init(){}
    
    func makeAPICall<T:Decodable>(urlString:String,completion: @escaping(Result<T,Error>) -> Void){
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 404,userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
    
}
