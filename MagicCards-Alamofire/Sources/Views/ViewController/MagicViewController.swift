//
//  MagicViewController.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import UIKit
import Alamofire
import AlamofireImage

class MagicViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel = CardListViewModel()
    private var searchTimer: Timer?
    var allDataLoaded: Bool = false
    
    //MARK: - UI Elements
    
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Поиск"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Найти", for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сбросить", for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MagicCardTableViewCell.self, forCellReuseIdentifier: MagicCardTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupActions()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        fetchCards()
        view.backgroundColor = UIColor.white
        viewModel.fetchCards { [weak self] in
            self?.allDataLoaded = true
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupHierarchy() {
        view.addSubview(searchField)
        view.addSubview(activityIndicator)
        view.addSubview(buttonsStackView)
        view.addSubview(tableView)
    }
    
    //MARK: - Setups
    
    private func setupLayout() {
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(30)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(resetButton.snp.width)
        }
        
        resetButton.snp.makeConstraints { make in
            make.width.equalTo(searchButton.snp.width)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(buttonsStackView.snp.centerY)
            make.trailing.equalTo(buttonsStackView.snp.leading).offset(-8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    private func setupActions() {
        searchField.addTarget(self, action: #selector(searchFieldEditingChanged), for: .editingChanged)
    }
    
    private func fetchCards() {
        activityIndicator.startAnimating()
        viewModel.fetchCards { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
            }
        }
    }
    
    @objc private func searchFieldEditingChanged() {
        viewModel.search(for: searchField.text ?? "") {
            self.tableView.reloadData()
        }
    }
    
    @objc private func searchButtonTapped() {
        view.endEditing(true)
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.viewModel.search(for: self.searchField.text ?? "") {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.viewModel.numberOfCards() == 0 {
                        let alert = UIAlertController(title: "Ошибка", message: "Данные не найдены", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc private func resetButtonTapped() {
        tableView.isHidden = true
        searchField.text = ""
        viewModel.search(for: "") {
            self.tableView.reloadData()
        }
        fetchCards()
        tableView.isHidden = false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MagicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCards()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard allDataLoaded else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MagicCardTableViewCell.reuseIdentifier, for: indexPath)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MagicCardTableViewCell.reuseIdentifier, for: indexPath) as? MagicCardTableViewCell else {
            fatalError("Unable to dequeue MagicCardTableViewCell")
        }
        let card = viewModel.card(at: indexPath.row)
        cell.configure(with: card)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cardDetailsViewController = MagicDetailViewController()
        cardDetailsViewController.card = viewModel.card(at: indexPath.row)
        present(cardDetailsViewController, animated: true)
    }
}

