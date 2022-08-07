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
    private let searchBur = UISearchBar()
    private var fetchingDataIsON = false
    
    
    // MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }


    // MARK:- UI
    private func setupUI() {
        self.view.backgroundColor = .white
        
        setupInfoLabel()
        setupButton()
        
        self.view.addSubview(button)
        self.view.addSubview(infoLabel)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.button.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            self.button.heightAnchor.constraint(equalToConstant: 50.0),
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100.0),
            
            self.infoLabel.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -44.0),
            self.infoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.infoLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.infoLabel.heightAnchor.constraint(equalToConstant: 100.0),
        ])
    }
    
    private func setupButton() {
        self.button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        self.button.tintColor = .white
        self.button.layer.cornerRadius = 10
        self.button.clipsToBounds = true
        changeButton()
        self.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    private func setupInfoLabel() {
        self.infoLabel.text = "Fetch random numbers from RANDOM.ORG"
        self.infoLabel.font = .systemFont(ofSize: 24, weight: .medium)
        self.infoLabel.textColor = .systemGray
        self.infoLabel.textAlignment = .center
        self.infoLabel.numberOfLines = 0
    }
    
    
    // MARK:- ACTIONS
    private func changeButton() {
        self.button.setTitle(
            self.fetchingDataIsON == true ? "Stop" : "Start",
            for: .normal
        )
        self.button.backgroundColor = self.fetchingDataIsON == true ? .red : .systemBlue
    }
    
    @objc private func buttonPressed() async {
        self.fetchingDataIsON = !self.fetchingDataIsON
        changeButton()
        // get random number
        guard let number = await NetworkManager.shared.getDataIfYouAllow(allow: self.fetchingDataIsON)
        else { return }
        
        DispatchQueue.main.async { self.infoLabel.text = "\(number)" }
    }

}
