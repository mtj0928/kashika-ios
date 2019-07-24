//
//  FriendListViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/22.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

fileprivate extension UIColor.AppColor {
    var greenColor: UIColor {
        return UIColor(hex: "01A564")
    }
}

final class FriendListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addUserButton: EmphasisButton!
    @IBOutlet private weak var addUseromSNSButton: EmphasisButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupButton()
    }
}

// MARK: - Set Up

extension FriendListViewController {

    private func setupNavigationBar() {
        navigationItem.title = "友達一覧"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupButton() {
        addUserButton.setTitle("手動で追加", for: .normal)
        addUserButton.backgroundColor = UIColor.app.greenColor
        addUserButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)

        addUseromSNSButton.setTitle("SNSから追加", for: .normal)
        addUseromSNSButton.backgroundColor = UIColor.app.positiveColor
        addUseromSNSButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
    }
}
