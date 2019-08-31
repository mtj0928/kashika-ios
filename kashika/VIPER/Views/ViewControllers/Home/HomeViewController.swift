//
//  HomeViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift

enum HomeSection {
    case summery, schedule, kari, kashi

    var title: String? {
        switch self {
        case .summery:
            return nil
        case .schedule:
            return "今後の返済予定"
        case .kari:
            return "借りている人"
        case .kashi:
            return "貸している人"
        }
    }
}

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var presenter: HomePresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }

    static func createFromStoryboard(with presenter: HomePresenterProtocol) -> HomeViewController {
        let viewController = HomeViewController.createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension HomeViewController {

    private func setupNavigationBar() {
        navigationItem.title = "Kashika"
    }

    private func setupTableView() {
        tableView.dataSource = self

        tableView.tableFooterView = UIView()

        tableView.register(R.nib.summeryViewCell)

        presenter.sections.asDriver().drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections.value[indexPath.section]
        if section == .summery {
            let cell = tableView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.summeryViewCell, for: indexPath)
            cell.set(money: presenter.userTotalDebtMoney.value)
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.sections.value[section].title
    }
}
