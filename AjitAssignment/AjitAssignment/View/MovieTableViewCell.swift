import UIKit

class MovieTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let yearLabel = UILabel()
    let posterImageView = UIImageView()
    let seeMoreButton = UIButton()
    let typeLabel = UILabel()
    let idLabel = UILabel()
    var showMore: Bool = false
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        autoLayoutSubviews()
    }
    
    func setupSubviews(){
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.font = UIFont.systemFont(ofSize: 14)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let arrowImage = UIImage(systemName: "arrowtriangle.down.square")
        seeMoreButton.setImage(arrowImage, for: .normal)
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        seeMoreButton.imageView?.tintColor = .black
        seeMoreButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        typeLabel.font = UIFont.systemFont(ofSize: 14)
        typeLabel.numberOfLines = 0
        typeLabel.isHidden = !showMore
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        idLabel.font = UIFont.systemFont(ofSize: 14)
        idLabel.isHidden = !showMore
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(posterImageView)
        contentView.addSubview(seeMoreButton)
        contentView.addSubview(typeLabel)
        contentView.addSubview(idLabel)
        
    }
    
    func autoLayoutSubviews(){
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            posterImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            seeMoreButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 4),
            seeMoreButton.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor,constant: 4),
            
            typeLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor,constant: 4),
            typeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            idLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            idLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor,constant: 4),
            
            
        ])
        
    }
    
    @objc func tapped(){
        showMore = !showMore
        toggleButton()
        
    }
    
    func toggleButton(){
        typeLabel.isHidden = !showMore
        idLabel.isHidden = !showMore
        
        if showMore {
            let arrowImage = UIImage(systemName: "arrowtriangle.up.square")
            seeMoreButton.setImage(arrowImage, for: .normal)
        } else {
            let arrowImage = UIImage(systemName: "arrowtriangle.down.square")
            seeMoreButton.setImage(arrowImage, for: .normal)
        }
    }
    
    func bindViewData(_ movie: Movie){
        self.titleLabel.text = movie.title
        self.yearLabel.text = movie.year
        self.typeLabel.text = movie.type
        self.idLabel.text = "ID: \(movie.imdbID)"
        if let posterURL = URL(string: movie.poster) {
            ImageCache.shared.loadImage(fromURL: posterURL, forImageView: self.posterImageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
