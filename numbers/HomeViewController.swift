//
//  ViewController.swift
//  numbers
//
//  Created by Andriy Biguniak on 07.08.2022.
//

import UIKit


class HomeViewController: UIViewController {

    // MARK:- VARs
    private let infoLabel = UILabel()
    private let button = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView()
    private let searchController = UISearchController()
    private let table = UITableView()
    private var fetchingDataIsON = false
    private var fetchedNumber : String? {
        didSet{
            guard let fetchedNumber = fetchedNumber
            else {return}
            // update label
            self.infoLabel.text = fetchingDataIsON == true ? fetchedNumber : "Fetch random numbers from RANDOM.ORG"
            // save number to the realm
            DispatchQueue.global(qos: .utility).async {
                StorageManager.shared.saveToTheRealm(number: fetchedNumber)
            }
        }
    }
    private var numbersFromRealm : [String] = []
    private var timer : Timer?
    

    
    
    // MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


    // MARK:- UI
    private func setupUI() {
        self.view.backgroundColor = .white
        self.activityIndicator.isHidden = true
        
        setupTable()
        setupNavigationBar()
        setupInfoLabel()
        setupButton()
        
        self.view.addSubview(self.button)
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.table)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.table.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            
            self.button.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            self.button.heightAnchor.constraint(equalToConstant: 50.0),
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100.0),
            
            self.infoLabel.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -44.0),
            self.infoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.infoLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.infoLabel.heightAnchor.constraint(equalToConstant: 150.0),
            
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -44.0),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.activityIndicator.heightAnchor.constraint(equalToConstant: 150.0),
            
            self.table.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            self.table.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.table.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.table.bottomAnchor.constraint(equalTo: self.infoLabel.topAnchor, constant: -10),
        ])
    }
    
    //table
    private func setupTable() {
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    // navigation bar & search
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Search"
        self.navigationItem.searchController = self.searchController
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Enter number or character"
    }
    
    //label
    private func setupInfoLabel() {
        self.infoLabel.text = "Fetch random numbers from RANDOM.ORG"
        self.infoLabel.font = .systemFont(ofSize: 36, weight: .medium)
        self.infoLabel.textColor = .systemGray
        self.infoLabel.textAlignment = .center
        self.infoLabel.numberOfLines = 0
    }
    
    // button
    private func setupButton() {
        self.button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        self.button.tintColor = .white
        self.button.layer.cornerRadius = 10
        self.button.clipsToBounds = true
        changeButton()
        self.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    
    // MARK:- ACTIONS
    private func changeButton() {
        self.button.setTitle(
            self.fetchingDataIsON == true ? "Stop" : "Start",
            for: .normal
        )
        self.button.backgroundColor = self.fetchingDataIsON == true ? .red : .systemBlue
    }
    
    @objc private func buttonPressed() {
        // update UI
        self.fetchingDataIsON = !self.fetchingDataIsON
        changeButton()
        
        if self.fetchingDataIsON {
            self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] timer in
                    // get random number
                    Task(priority: .medium) {
                        self!.fetchedNumber = await NetworkManager.shared.getDataIfYouAllow(allow: self!.fetchingDataIsON)
                    }
            })
            print("START fetching data")
        }
        else {
            self.timer?.invalidate()
            print("STOP fetching data")
        }
    }
        
    
} // class end


// MARK:- UISearchResultsUpdating
extension HomeViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // check text
        guard let text = self.searchController.searchBar.text
        else { return }
        
        // fetch data from realm
        self.numbersFromRealm = StorageManager.shared.getNumbers(withNumber: text)
        self.table.reloadData()
        
    }
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numbersFromRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.numbersFromRealm[indexPath.row]
        return cell
    }
}
