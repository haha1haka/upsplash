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
            
            guard let data = data else {
                completion(.failure(.unexpectedData))
                return
            }
            
            switch httpResponse.statusCode {
            case (200...299):
                print("✅ Success", data)
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch let decodingError {
                    print("⁉️ Failure", decodingError)
                    completion(.failure(.decodingError))
                }
            case (400...499):
                print("❌ Failure", String(data: data, encoding: .utf8)!)
                completion((.failure(.clientError)))
            case (500...599):
                print("❌ Failure", String(data: data, encoding: .utf8)!)
                completion((.failure(.serverError)))
            default:
                completion((.failure(.internalError)))
            }
            
            if let error = error {
                print("❌ Failure (Internal)", error.localizedDescription)
                completion((.failure(.internalError)))
                return
            }
        }.resume()
    }
    
}
