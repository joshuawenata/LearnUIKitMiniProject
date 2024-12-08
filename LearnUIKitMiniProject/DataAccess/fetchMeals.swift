//
//  fetchMeals.swift
//  LearnUIKitMiniProject
//
//  Created by Joshua Wenata Sunarto on 08/12/24.
//

import Foundation

func fetchMeals(searchQuery: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
    let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(searchQuery)"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
            return
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
            completion(.success(decodedResponse.meals ?? []))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}
