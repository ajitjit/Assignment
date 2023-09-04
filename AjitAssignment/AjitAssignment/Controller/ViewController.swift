import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let contentView1 = TableView()
    let contentView2 = CollectionView()
    let contentView3 = TableView()
    
    var offset = 0.0
    var movies : [Movie] = []
    var users : [User] = []
    var photos : [Photo] = []
    var allUsernames: [String] = []
    var filteredUsernames: [String] = []

    let tabView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    let underLineView: CALayer = {
        let underlineLayer = CALayer()
        underlineLayer.backgroundColor = UIColor.systemGreen.cgColor
        return underlineLayer
    }()
    
    let firstTab: UIButton = {
        let button = UIButton()
        button.setTitle("Table", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tag = 1
        return button
    }()
    
    let secondTab: UIButton = {
        let button = UIButton()
        button.setTitle("Collection", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tag = 2
        return button
    }()
    
    let thirdTab: UIButton = {
        let button = UIButton()
        button.setTitle("List", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tag = 3
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupSubViews()
        configureTabView()
        configureScrollView()
        autoLayoutSubViews()
        view.backgroundColor = .white
        filteredUsernames = allUsernames

    }
    
    func fetchData(){
        let concurrentQueue = DispatchQueue.global(qos: .userInitiated)
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        concurrentQueue.async {
            APIService.shared.makeAPICall(urlString: "https://www.omdbapi.com/?apikey=e5311742&s=Batman&page=1") { (result: Result<MovieSearchResponse, Error>) in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let movies):
                    self.movies = movies.search
                    DispatchQueue.main.async {
                        self.contentView1.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        dispatchGroup.enter()
        concurrentQueue.async {
            APIService.shared.makeAPICall(urlString: "https://jsonplaceholder.typicode.com/users") { (result: Result<[User], Error>) in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let users):
                    print(users)
                    self.filteredUsernames = users.map({ user in
                        user.name
                    })
                    self.allUsernames = self.filteredUsernames
                    self.users = users
                    DispatchQueue.main.async {
                        self.contentView3.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        dispatchGroup.enter()
        concurrentQueue.async {
            APIService.shared.makeAPICall(urlString: "https://jsonplaceholder.typicode.com/photos") { (result: Result<[Photo], Error>) in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let photos):
                    self.photos = photos
                    DispatchQueue.main.async {
                        self.contentView2.activityIndicator.removeFromSuperview()
                        self.contentView2.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            
        }

    }
    
    func configureScrollView(){
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: scrollView.frame.size.height)
        contentView1.tableView.dataSource = self
        contentView1.tableView.delegate = self
        contentView3.tableView.dataSource = self
        contentView3.tableView.delegate = self
        contentView3.searchBar.delegate = self
        contentView2.collectionView.dataSource = self
        contentView2.collectionView.delegate = self
        contentView2.collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        contentView3.tableView.register(UserCell.self, forCellReuseIdentifier: "Cell")
        contentView1.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
    }
    
    func setupSubViews(){
        view.addSubview(tabView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView1)
        scrollView.addSubview(contentView2)
        scrollView.addSubview(contentView3)

    }
    
    func configureTabView() {
        tabView.axis = .horizontal
        tabView.alignment = .fill
        tabView.distribution = .fillEqually
        tabView.addArrangedSubview(firstTab)
        tabView.addArrangedSubview(secondTab)
        tabView.addArrangedSubview(thirdTab)
        underLineView.frame = CGRect(x: 0, y: 60, width: view.bounds.width / 3, height: 5)
        tabView.layer.addSublayer(underLineView)
        firstTab.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        secondTab.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        thirdTab.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func autoLayoutSubViews(){
        tabView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView1.translatesAutoresizingMaskIntoConstraints = false
        contentView2.translatesAutoresizingMaskIntoConstraints = false
        contentView3.translatesAutoresizingMaskIntoConstraints = false
        
        let contentViews = [contentView1, contentView2, contentView3]
        
        for contentView in contentViews {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabView.heightAnchor.constraint(equalToConstant: 60),
            scrollView.topAnchor.constraint(equalTo: tabView.bottomAnchor,constant:5),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView2.leadingAnchor.constraint(equalTo: contentView1.trailingAnchor),
            contentView3.leadingAnchor.constraint(equalTo: contentView2.trailingAnchor),
            contentView3.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffSet = scrollView.contentOffset.x / 3
        if xOffSet > 0{
            underLineView.frame.origin.x = xOffSet
        }
        self.offset = xOffSet
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            self.underLineView.frame.origin.x = sender.frame.origin.x
        }
        let pageCount = CGFloat(sender.tag - 1)
        let pageWidth = scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: pageCount*pageWidth, y: 0), animated: true)
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == contentView1.tableView {
            return movies.count
        } else{
            return filteredUsernames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == contentView1.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! MovieTableViewCell
            cell.bindViewData(movies[indexPath.row])
            return cell
        } else if tableView == contentView3.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
            cell.userLabel.text = filteredUsernames[indexPath.row]
            return cell
        }
        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == contentView3.tableView){
            let userViewController = UserViewController()
            userViewController.user = self.users[indexPath.row]
            self.navigationController?.pushViewController(userViewController, animated: true)
        }
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            filteredUsernames = allUsernames.filter { username in
                return username.lowercased().contains(searchText.lowercased())
            }
            contentView3.tableView.reloadData()
        } else {
            filteredUsernames = allUsernames
            contentView3.tableView.reloadData()
        }
    }

}


extension ViewController :UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.bindViewData(photo)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = (collectionViewWidth - 3 * 8) / 2
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
}
