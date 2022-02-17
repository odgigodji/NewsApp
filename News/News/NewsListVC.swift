//
//  ViewController.swift
//  News
//
//  Created by Nikita Evdokimov on 05.02.2022.
//

import UIKit
import SafariServices

class NewsListVC: UIViewController, UISearchBarDelegate {

    let refreshControl = UIRefreshControl()
    private var safeArea: UILayoutGuide!
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints =  false
        navigationItem.titleView = searchBar
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints =  false
        return tableView
    }()
    
    var news = [Article]()
//    let counters = UserDefaults.standard
    
    override func loadView() {
        super.loadView()
        print("hello")
        view.backgroundColor = .blue
        
//        let label: UILabel = {
//           let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//        view.addSubview(label)
        sleep(1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray3
        safeArea = view.layoutMarginsGuide
        setupSearchBar()
        setupTableView()
        
        fetchDataFromAPI()
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

    }
    

//MARK: - Setup SearchBar
    func setupSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
// MARK: - Setup TableView
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - UITableViewDataSource
extension NewsListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        
        cell.textLabel?.text = createTextLabel(indexPathRow: indexPath.row)
        cell.textLabel?.numberOfLines = 0

        return cell
    }
    
    func createTextLabel(indexPathRow: Int) -> (String){
//        guard let article = news[indexPathRow] else {
//            print("error on \(indexPathRow)" )
//            return
//        }
        
        let article = news[indexPathRow]
        print(article)
        
//        let countersValue = counters.integer(forKey: "counter" + String(indexPathRow))
//        let text = "test" //String(String(countersValue)) // + " | " + article.title!)
        let text = String(article.title!)
        
        return text
    }

}

// MARK: - UITableViewDelegate
extension NewsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        goToSafari(indexPathRow: indexPath.row)
        updateCounter(indexPathRow: indexPath.row)
    }
    
    private func goToSafari(indexPathRow: Int) {
        lazy var article = news[indexPathRow]
        let url = news[indexPathRow].url!
        let newsPage = SFSafariViewController(url: url)
        self.present(newsPage, animated: true)
    }
    
    private func updateCounter(indexPathRow: Int) {
        
//        let countersValue = counters.integer(forKey: "counter" + String(indexPathRow))
//        let newValue = countersValue + 1
        
//        counters.set(newValue, forKey: String("counter" + String(indexPathRow)))
        
        tableView.reloadData()
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - SearchBar
extension NewsListVC {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        searchBar.becomeFirstResponder()
//        print(searchBar.text ?? "-")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(searchBar.text)
        searchBar.resignFirstResponder()
        let anonymousFunction = { (fetchedNewsList: [Article]) in
            DispatchQueue.main.async {
                self.news = fetchedNewsList
                self.tableView.reloadData()
            }
        }
        print("SEARCHBARTEXT = \(searchBar.text!)")
        NewsAPI.shared.fetchNewsList(searchLabel: searchBar.text!, onCompletion: anonymousFunction)
        

    }
    
}

//MARK: - refresh
extension NewsListVC {
    func fetchDataFromAPI() {
        let anonymousFunction = { (fetchedNewsList: [Article]) in
            DispatchQueue.main.async {
                self.news = fetchedNewsList
                self.tableView.reloadData()
            }
        }
        NewsAPI.shared.fetchNewsList(searchLabel: "apple", onCompletion: anonymousFunction)
        tableView.reloadData()

    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("refresh")
        refreshControl.endRefreshing()
        fetchDataFromAPI()
        
    }
}
