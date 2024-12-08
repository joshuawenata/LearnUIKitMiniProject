import Foundation

// The main response model that contains an array of meals
struct MealResponse: Codable {
    let meals: [Meal]?
}

// Meal structure which defines the details of each meal
struct Meal: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String?
    
    // Ingredients with their name and measure
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strCategory, strArea, strInstructions, strMealThumb, strTags, strYoutube
    }

    // Custom struct to hold ingredient name and measure
    struct Ingredient: Codable {
        let name: String
        let measure: String
    }

    // Custom initializer to process ingredients and their measures
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
        
        // Decode ingredients dynamically using a loop
        var ingredientsList: [Ingredient] = []
        var index = 1
        
        // Loop through possible ingredients and measures
        while true {
            // Construct dynamic keys for ingredient and measure
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            
            // Check if the ingredient key exists
            if let ingredientNameKey = CodingKeys(stringValue: ingredientKey),
               let ingredientName = try? container.decodeIfPresent(String.self, forKey: ingredientNameKey),
               let ingredientMeasureKey = CodingKeys(stringValue: measureKey),
               let ingredientMeasure = try? container.decodeIfPresent(String.self, forKey: ingredientMeasureKey) {
                
                // If the ingredient is empty, break out of the loop
                if ingredientName.isEmpty {
                    break
                }
                
                // Add the ingredient and measure to the list
                ingredientsList.append(Ingredient(name: ingredientName, measure: ingredientMeasure ?? ""))
            } else {
                break // Exit the loop if no ingredient or measure found at the given index
            }
            
            index += 1
        }
        
        ingredients = ingredientsList
    }

}
