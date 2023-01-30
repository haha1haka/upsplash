import Foundation

enum UnsplashRouter {
    case topic
    case photo(id: String)
    case search(query: String)
}

extension UnsplashRouter: TargetType {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.unsplash.com"
    }
    
    var path: String {
        switch self {
        case .topic: return "/topics"
        case .photo(let id): return "/topics/\(id)/photos"
        case .search: return "/search/photos"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .topic:
            return [URLQueryItem(name: "order_by", value: "featured")]
        case .photo:
            return [URLQueryItem(name: "page", value: "1")]
        case .search(let query):
            return [URLQueryItem(name: "page", value: "1"),
                    URLQueryItem(name: "query", value: "\(query)")]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var header: [String: String] {
        switch self {
        default:
            return ["Accept-Version": "v1",
                    "Authorization": "Client-ID \(UnsplashAPIKey.appKey)"]
        }
    }
    
    var parameters: String? {
        return nil
    }
}
