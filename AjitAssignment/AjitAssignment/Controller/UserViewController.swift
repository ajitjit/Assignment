import UIKit

class UserViewController: UIViewController {
    
    var user: User?
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }
    
    private lazy var nameLabel: UILabel = makeLabel(text: "")
    private lazy var usernameLabel: UILabel = makeLabel(text: "")
    private lazy var emailLabel: UILabel = makeLabel(text: "")
    private lazy var addressLabel: UILabel = makeLabel(text: "")
    private lazy var phoneLabel: UILabel = makeLabel(text: "")
    private lazy var websiteLabel: UILabel = makeLabel(text: "")
    private lazy var companyLabel: UILabel = makeLabel(text: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        updateUserDetails()
    }
    
    private func setupUI() {
        view.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        let userDetailLabels: [(property: String, label: UILabel)] = [
            ("Name", nameLabel),
            ("Username", usernameLabel),
            ("Email", emailLabel),
            ("Address", addressLabel),
            ("Phone", phoneLabel),
            ("Website", websiteLabel),
            ("Company", companyLabel)
        ]
        
        for (property, label) in userDetailLabels {
            label.text = "\(property):"
            verticalStackView.addArrangedSubview(label)
        }
        
    }
    
    private func updateUserDetails() {
        guard let user = user else {
            return
        }
        
        nameLabel.text = "Name: \(user.name)"
        usernameLabel.text = "Username: \(user.username)"
        emailLabel.text = "Email: \(user.email)"
        addressLabel.text = "Address: \(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)"
        phoneLabel.text = "Phone: \(user.phone)"
        websiteLabel.text = "Website: \(user.website)"
        companyLabel.text = "Company: \(user.company.name), \(user.company.catchPhrase), \(user.company.bs)"
        verticalStackView.layoutIfNeeded()
    }
}
