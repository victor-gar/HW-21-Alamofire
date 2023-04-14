//
//  ViewController.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import UIKit
import Alamofire
import AlamofireImage

class MagicViewController: UIViewController {
    
    private let viewModel = CardListViewModel()
    
    private let tableView: UITableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 250
            tableView.separatorStyle = .none
            tableView.backgroundColor = .cyan
            return tableView
        }()    
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupSearchController()
        
        viewModel.fetchCards {
            self.tableView.reloadData()
        }
//        { [weak self] in
//                   DispatchQueue.main.async {
//                       self?.//                   }
//               }
        tableView.register(MagicCardTableViewCell.self, forCellReuseIdentifier: MagicCardTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .red
    }
    
    private func setupSearchController() {
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search Cards"
            navigationItem.searchController = searchController
            definesPresentationContext = true
        }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
}

extension MagicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numberOfCards()
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: MagicCardTableViewCell.reuseIdentifier, for: indexPath) as! MagicCardTableViewCell
            let card = viewModel.card(at: indexPath.row)
            cell.configure(with: card)
            return cell
        }
}

// MARK: - UISearchResultsUpdating

extension MagicViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
            let searchText = searchController.searchBar.text ?? ""
            viewModel.search(for: searchText) {
                self.tableView.reloadData()
            }
        }
}
