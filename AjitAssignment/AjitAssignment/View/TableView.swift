import UIKit

class TableView: UIView {
    
    let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView(){
        addSubview(tableView)
        addSubview(headerView)
        headerView.addSubview(searchBar)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: headerView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
