import UIKit

class DetailViewController: UIViewController {
    var meal: Meal?

    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let categoryButton = FilterButton()
    private let ingredientsLabel = UILabel()
    private let instructionsLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        guard let meal = meal else {
            print("Meal is nil!")
            return
        }

        print("Meal Title: \(meal.strMeal)")
        print("Meal Category: \(meal.strCategory)")

        // Configure Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Configure Content View
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Configure Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.text = meal.strMeal
        
        // Set titleLabel as the navigation title view
        navigationItem.titleView = titleLabel
        
        // Configure Image View
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        if let imageURL = URL(string: meal.strMealThumb) {
            let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }

        // Configure Category Button
        categoryButton.title = meal.strCategory
        categoryButton.onTap = {
            print("Category tapped: \(meal.strCategory)")
        }
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        print(meal.ingredients)
        
        // Configure Ingredients Label
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.text = meal.ingredients.isEmpty ? "No ingredients available" : meal.ingredients.map {
            "\($0.name): \($0.measure)"
        }.joined(separator: "\n")
        ingredientsLabel.numberOfLines = 0
        ingredientsLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Configure Instructions Label
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.text = meal.strInstructions
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = UIFont.systemFont(ofSize: 16)

        // Add Subviews to contentView
        contentView.addSubview(imageView)
        contentView.addSubview(categoryButton)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(instructionsLabel)

        // Layout Constraints
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Image view at the top
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            // Category button below imageView
            categoryButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryButton.heightAnchor.constraint(equalToConstant: 30),
            categoryButton.widthAnchor.constraint(equalToConstant: 150),

            // Ingredients label below category button
            ingredientsLabel.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 16),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Instructions label below ingredientsLabel
            instructionsLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 16),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            instructionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}
