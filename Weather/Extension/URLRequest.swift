import Foundation

extension URLRequest {
    init(
        _ url: URL,
        method: String,
        params: [String: Any?] = [:]
    ) {
        
        self.init(url: url.appending(
            params
                .filter { $0.value != nil }
                .map { (key, value) in
                    URLQueryItem(name: key, value: String(describing: value!))
                })!
        )
        // headers
        self.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
}
