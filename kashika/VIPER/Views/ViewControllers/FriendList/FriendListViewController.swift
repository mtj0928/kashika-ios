//
//  FriendListViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/22.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import TapticEngine

fileprivate extension UIColor.AppColor {
    var greenColor: UIColor {
        return UIColor(hex: "01A564")
    }
}

final class FriendListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addUserButton: EmphasisButton!
    @IBOutlet private weak var addUseromSNSButton: EmphasisButton!

    private var presenter: FriendListPresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
        setupNavigationBar()
        setupTableView()
    }

    @IBAction func tappedAddUserButton() {
        TapticEngine.impact.feedback(.light)
        presenter.tappedAddUserButton(with: .manual)
    }

    @IBAction func tappedAddUserFromSNSButton() {
        TapticEngine.impact.feedback(.light)
        presenter.tappedAddUserButton(with: .sns)
    }

    static func createFromStoryboard(with presenter: FriendListPresenterProtocol) -> Self {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
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

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableFooterView = UIView()

        tableView.register(R.nib.friendTableViewCell)

        tableView.rowHeight = 100.0

        presenter.friends.asDriver().drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource

extension FriendListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.friends.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.friendTableViewCell, for: indexPath)
        let friend = presenter.friends.value[indexPath.row]
        cell.set(friend: friend)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FriendListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = presenter.friends.value[indexPath.row]
        presenter.tapped(friend: friend)
    }
}
