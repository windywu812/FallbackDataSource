//
//  ViewController.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import UIKit

class ViewController: UIViewController {
    
    init(presenter: PostPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var presenter: PostPresenterInput
    private var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchData()
    }
    
    @objc
    func fetchData() {
        presenter.fetchPost()
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
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = posts[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = posts[indexPath.row].body
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return posts.count
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: PostPresenterOutput {
    
    func didFetchPost(posts: [Post]) {
        self.posts = posts
        self.refreshControl.endRefreshing()
    }
    
    func didError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
}
