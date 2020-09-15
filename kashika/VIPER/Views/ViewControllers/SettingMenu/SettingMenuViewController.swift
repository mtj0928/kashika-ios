//
//  SettingMenuViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Rswift

class SettingMenuViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private var presenter: SettingMenuPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }

    static func createFromStoryboard(with presenter: SettingMenuPresenterProtocol) -> SettingMenuViewController {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension SettingMenuViewController {

    private func setupNavigationBar() {
        navigationItem.title = "設定"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        let titleHeaderViewNib = UINib(nibName: R.nib.titleHeaderView.name, bundle: R.nib.titleHeaderView.bundle)
        tableView.register(titleHeaderViewNib, forHeaderFooterViewReuseIdentifier: R.nib.titleHeaderView.name)
        tableView.register(R.nib.tableViewCell)

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.systemGroupedBackground
    }
}

// MARK: - UITableViewDataSource

extension SettingMenuViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter.sections.value[section]
        return presenter.countRows(for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.tableViewCell, for: indexPath)
        let section = presenter.sections.value[indexPath.section]
        let text = presenter.title(at: indexPath.row, for: section)
        cell.set(text: text)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.titleHeaderView.name) as? TitleHeaderView else {
            return nil
        }
        let section = presenter.sections.value[section]
        let title = presenter.sectionTitle(for: section)
        header.set(title: title ?? "")
        header.contentView.backgroundColor = tableView.backgroundColor
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.backgroundColor = UIColor.clear
        view.contentView.backgroundColor = tableView.backgroundColor
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = presenter.sections.value[indexPath.section]
        presenter.tapped(at: indexPath.row, for: section)
    }
}
