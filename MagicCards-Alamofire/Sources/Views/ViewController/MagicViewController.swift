//
//  ViewController.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import UIKit
import SnapKit

class MagicViewController: UIViewController {
    
    private let viewModel = CardsViewModel()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        configure()
        // Do any additional setup after loading the view.
    }
    
    private func configure() {
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
