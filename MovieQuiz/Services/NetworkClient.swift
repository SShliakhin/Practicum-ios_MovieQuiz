//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 16.11.2022.
//

import Foundation

enum ServiceError: Error {
    case network(statusCode: Int)
    case parsing
    case general(reason: String)
}

struct NetworkClient {
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(ServiceError.general(reason: error.localizedDescription)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(ServiceError.network(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
