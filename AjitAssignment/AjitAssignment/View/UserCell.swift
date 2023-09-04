import UIKit

class UserCell : UITableViewCell {
    
    let userLabel = UILabel()
    let userAvatar = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews(){
        contentView.addSubview(userLabel)
        userLabel.font = UIFont.boldSystemFont(ofSize: 16)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userAvatar.image = UIImage(systemName: "person.text.rectangle.fill")
        contentView.addSubview(userAvatar)
        userAvatar.tintColor = .darkGray
        userAvatar.contentMode = .scaleAspectFit
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userAvatar.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            userAvatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
            userAvatar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            userAvatar.heightAnchor.constraint(equalToConstant: 50),
            userLabel.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor,constant: 4),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -4),
            userLabel.topAnchor.constraint(equalTo: userAvatar.topAnchor),
            userLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
            
        ])
    }
    
    
    
    
}
