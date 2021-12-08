//
//  ViewController.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import UIKit

protocol DataLoader {
    func execute(completion: @escaping (Result<[Post], Error>) -> ())
}

class ViewController: UIViewController {
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dataLoader: DataLoader
    private var posts: [Post] = []
    
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchData()
    }
    
    @objc
    func fetchData() {
        dataLoader.execute { [weak self] result in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let posts):
                self.posts = posts
                self.tableView.reloadData()
            case .failure(let err):
                self.showAlert(message: err.localizedDescription)
            }
        }
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = posts[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = posts[indexPath.row].body
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
