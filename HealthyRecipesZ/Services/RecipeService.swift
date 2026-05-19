//
//  RecipeService.swift
//  HealthyRecipesZ
//
//  Created by Codex on 2026/5/15.
//

import Foundation

enum RecipeServiceError: Error {
    case invalidURL
    case emptyResponse
    case apiMessage(String)
}

final class RecipeService {
    private let session: URLSession
    private let baseURL = "https://apis.tianapi.com/caipu/index"
    private let apiKey = "830e1bbb334c9aec4c7ae3e41b819f9f"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchRecipes(searchTerm: String, page: Int, pageSize: Int = 10, completion: @escaping (Result<[TianAPIRecipeDTO], Error>) -> Void) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "word", value: searchTerm),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "num", value: "\(pageSize)")
        ]

        guard let url = components?.url else {
            completion(.failure(RecipeServiceError.invalidURL))
            return
        }

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(RecipeServiceError.emptyResponse))
                return
            }

            do {
                let response = try JSONDecoder().decode(TianAPIRecipeResponse.self, from: data)
                guard response.code == 200 else {
                    completion(.failure(RecipeServiceError.apiMessage(response.msg)))
                    return
                }
                completion(.success(response.result?.list ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
