import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    let stackCardView = UIStackView()
    let scrollCardView = UIScrollView()
    var filterCategories: [String] = [] // Store unique categories

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.fetchAndDisplayMeals(query: "")
        
        // UI Setup
        setupUI()
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
        searchBarView.onTextChanged = { [weak self] text in
            if !text.isEmpty {
                self?.fetchAndDisplayMeals(query: text)
            }
        }

        view.addSubview(searchBarView)
        
        // Filter Buttons (dynamically populated)
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

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // card
        scrollCardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollCardView)
        
        stackCardView.axis = .vertical
        stackCardView.spacing = 16
        stackCardView.translatesAutoresizingMaskIntoConstraints = false
        scrollCardView.addSubview(stackCardView)
        
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -16),
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
                    self?.updateFilterButtons(with: meals) // Update filter buttons with categories
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

                if let navigationController = self.navigationController {
                    print("Navigating to DetailViewController")
                    let detailVC = DetailViewController()
                    detailVC.meal = meal
                    navigationController.pushViewController(detailVC, animated: true)
                } else {
                    print("navigationController is nil")
                }
            }
            card.imageView.loadImage(from: meal.strMealThumb)
            stackCardView.addArrangedSubview(card)
        }
    }

    func updateFilterButtons(with meals: [Meal]) {
        let categories = Set(meals.compactMap { $0.strCategory }) // Extract unique categories
        self.filterCategories = Array(categories)
        
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView,
           let stackView = scrollView.subviews.first(where: { $0 is UIStackView }) as? UIStackView {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
        
        filterCategories.forEach { category in
            let filterButton = FilterButton()
            filterButton.title = category
            filterButton.onTap = {
                print("\(category) tapped!")
            }

            filterButton.button.setTitle(category, for: .normal)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true

            if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView,
               let stackView = scrollView.subviews.first(where: { $0 is UIStackView }) as? UIStackView {
                stackView.addArrangedSubview(filterButton)
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchAndDisplayMeals(query: query)
        searchBar.resignFirstResponder()
    }
}

