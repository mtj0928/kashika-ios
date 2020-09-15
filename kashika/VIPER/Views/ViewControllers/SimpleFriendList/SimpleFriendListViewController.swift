//
//  SimpleFriendListViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/09/06.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

// TODO: - cellがemptyの時に何を表示するのか？
final class SimpleFriendListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var presenter: SimpleFriendListPresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationTitle()
    }

    static func createFromStoryboard(with presenter: SimpleFriendListPresenterProtocol) -> SimpleFriendListViewController {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Setup

extension SimpleFriendListViewController {

    private func setupNavigationTitle() {
        presenter.title.drive(onNext: { [weak self] text in
            self?.navigationItem.title = text
        }).disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()

        tableView.register(R.nib.simpleFriendListCell)

        presenter.friends.asDriver().drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - TableViewDataSource

extension SimpleFriendListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.friends.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.simpleFrierndListCell, for: indexPath)
        let friend = presenter.friends.value[indexPath.row]
        cell.set(friend)
        return cell
    }
}

// MARK: - TableViewDelegate

extension SimpleFriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = presenter.friends.value[indexPath.item]
        presenter.select(friend)
    }
}
