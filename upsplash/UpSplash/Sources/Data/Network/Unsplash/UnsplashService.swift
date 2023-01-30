import Foundation

protocol UnsplashService {
    func request<T: Decodable>(target: TargetType, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) 
}

final class UnsplashServiceImpl: UnsplashService {
    
    static let shared = UnsplashServiceImpl()
    
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(target: TargetType, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        session.dataTask(with: target.request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            print("📭 Request \(target.request.url!)")
            print("🚩 Response \(httpResponse.statusCode)")
            
            if let data = data {
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(decodedData))
                        }
                    }
                    catch let decodingError {
                        print("⁉️ Failure", decodingError)
                        DispatchQueue.main.async {
                            completion((.failure(NetworkError(message: decodingError.localizedDescription))))
                        }
                    }
                } else { /// error decode
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                }
            }
            if let error = error {
                print("❌ Failure (Internal)", error.localizedDescription)
                DispatchQueue.main.async {
                    completion((.failure(NetworkError(message: error.localizedDescription))))
                }
                return
            }
        }.resume()
    }
    
}
///error JSON
//{
//    "errors": [
//        "OAuth error: The access token is invalid"
//    ]
//}
