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

final class FriendListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var footerButtons: SNSFooterButtons!
    @IBOutlet private weak var bottomConstaraintOfFooter: NSLayoutConstraint!

    private var presenter: FriendListPresenterProtocol!
    private var footerPresenter: SNSFooterPresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFooter()
        setupNavigationBar()
        setupTableView()
    }

    static func createFromStoryboard(friendListpresenter: FriendListPresenterProtocol,
                                     footerPresenter: SNSFooterPresenterProtocol) -> Self {
        let viewController = createFromStoryboard()
        viewController.presenter = friendListpresenter
        viewController.footerPresenter = footerPresenter
        return viewController
    }
}

// MARK: - Set Up

extension FriendListViewController {

    private func setupNavigationBar() {
        navigationItem.title = "友達一覧"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupFooter() {
        footerButtons.presenter = footerPresenter
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableFooterView = UIView()

        tableView.register(R.nib.friendTableViewCell)

        tableView.rowHeight = 100.0

        tableView.contentInset.bottom += SNSFooterButtons.height + 2 * bottomConstaraintOfFooter.constant

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
        cell.set(presenter: FriendListCellPresenter(friend))
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
