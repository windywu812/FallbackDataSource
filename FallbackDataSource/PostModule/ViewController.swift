//
//  ViewController.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: PostViewModel
    
    var posts: [Post] = [] {
        didSet {
            refreshControl.endRefreshing()
            tableView.reloadData()
        }
    }
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    private var disposeBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        createBinding()
        fetchData()
    }
    
    @objc
    func fetchData() {
        viewModel.fetchPost()
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
    
    func createBinding() {
        viewModel.$posts
            .sink { [weak self] posts in
                self?.posts = posts
            }.store(in: &disposeBag)
        
        viewModel.$errorMessage
            .sink { [weak self] message in
                guard let message = message else { return }
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                self?.present(alert, animated: true, completion: nil)
            }.store(in: &disposeBag)
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
