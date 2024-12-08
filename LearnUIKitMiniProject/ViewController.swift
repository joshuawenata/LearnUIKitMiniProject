import UIKit
import Foundation

struct MealResponse: Codable {
    let meals: [Meal]?
}

struct Meal: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String?
}

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

class ViewController: UIViewController, UISearchBarDelegate {
    
    let stackCardView = UIStackView()
    let scrollCardView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // UI Setup
        setupUI()
        
        // Fetch and display meals with a default search query
        fetchAndDisplayMeals(query: "chicken")
    }

    private func setupUI() {
        // Label
        let labelView = UILabel()
        labelView.text = "Choose Your Menu"
        labelView.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        labelView.textColor = .black
        labelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelView)
        
        // Search Bar
        let searchBarView = SearchBarView()
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.onTextChanged = { text in
            print("Search text: \(text)")
        }

        view.addSubview(searchBarView)
        
        // Filter Buttons
        let buttonData = ["Filter 1", "Filter 2", "Filter 3", "Filter 4", "Filter 5", "Filter 6"]

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        buttonData.forEach { title in
            let filterButton = FilterButton()
            filterButton.title = title
            filterButton.onTap = {
                print("\(title) tapped!")
            }

            filterButton.button.setTitle(title, for: .normal)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true

            stackView.addArrangedSubview(filterButton)
        }
        
        // card
        scrollCardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollCardView)
        
        stackCardView.axis = .vertical
        stackCardView.spacing = 16
        stackCardView.translatesAutoresizingMaskIntoConstraints = false
        scrollCardView.addSubview(stackCardView)
        
        
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchBarView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 8),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            scrollView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.heightAnchor.constraint(equalToConstant: 30),
        
            scrollCardView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            scrollCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackCardView.topAnchor.constraint(equalTo: scrollCardView.topAnchor),
            stackCardView.leadingAnchor.constraint(equalTo: scrollCardView.leadingAnchor, constant: 16),
            stackCardView.trailingAnchor.constraint(equalTo: scrollCardView.trailingAnchor, constant: -16),
            stackCardView.bottomAnchor.constraint(equalTo: scrollCardView.bottomAnchor),
            stackCardView.widthAnchor.constraint(equalTo: scrollCardView.widthAnchor, constant: -32)
        ])
    }
    
    func fetchAndDisplayMeals(query: String) {
        fetchMeals(searchQuery: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self?.updateCardViews(with: meals)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateCardViews(with meals: [Meal]) {
        stackCardView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        meals.forEach { meal in
            let card = CardView()
            card.title = meal.strMeal
            card.category = meal.strCategory
            card.image = UIImage(systemName: "photo")
            card.onTap = {
                print("Tapped on \(meal.strMeal)")
            }
            card.imageView.loadImage(from: meal.strMealThumb)
            stackCardView.addArrangedSubview(card)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchAndDisplayMeals(query: query)
        searchBar.resignFirstResponder()
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        self.image = UIImage(systemName: "photo")

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
