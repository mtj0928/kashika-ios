//
//  WarikanViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import FloatingPanel
import TapticEngine

class WarikanViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var haveBeenFinished = false

    var scrollView: UIScrollView {
        return tableView
    }

    private var presenter: WarikanSettingPresenterProtocol!
    private let disposeBag = RxSwiftDisposeBag()

    @IBAction func tappedClosedButtton() {
        TapticEngine.impact.feedback(.light)
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        presenter.usersWhoHavePaid.asDriver().drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)

        presenter.usersWhoWillPay.asDriver().drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        TapticEngine.impact.prepare(.light)
    }

    static func createFromStoryboard(with presenter: WarikanSettingPresenterProtocol) -> WarikanViewController {
        let viewController = WarikanViewController.createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - View

extension WarikanViewController {

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension

        tableView.tableFooterView = UIView()

        tableView.register(R.nib.warikanUserTableViewCell)

        let warikanHeaderViewNib = UINib(nibName: R.nib.warikanHeaderView.name, bundle: R.nib.warikanHeaderView.bundle)
        tableView.register(warikanHeaderViewNib, forHeaderFooterViewReuseIdentifier: R.nib.warikanHeaderView.name)

        let headerViewNib = UINib(nibName: R.nib.homeTitleHeader.name, bundle: R.nib.homeTitleHeader.bundle)
        tableView.register(headerViewNib, forHeaderFooterViewReuseIdentifier: R.nib.homeTitleHeader.name)
    }
}

// MARK: - UITableViewDataSource

extension WarikanViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.usersWhoHavePaid.value.count
        } else if section == 1 {
            return presenter.usersWhoWillPay.value.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.warikanUserTableViewCell, for: indexPath)
        cell.color = view.backgroundColor
        if indexPath.section == 0 {
            cell.warikanUser = presenter.usersWhoHavePaid.value[indexPath.row]
        } else if indexPath.section == 1 {
            cell.warikanUser = presenter.usersWhoWillPay.value[indexPath.row]
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WarikanViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 1 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.warikanHeaderView.name) as? WarikanHeaderView
            view?.text = section == 0 ? "支払った人" : "支払う人"
            view?.color = self.view.backgroundColor
            return view
        }

        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.homeTitleHeader.name) as? HomeTitleHeader
        view?.set(title: "精算の流れ")
        view?.backgroundColor = self.view.backgroundColor
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
}

// MARK: - FloatingPanelControllerDelegate

extension WarikanViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ viewController: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        viewController.surfaceView.backgroundColor = view.backgroundColor
        return WarikaneSettingLayout()
    }

    func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
        if vc.position == .hidden && !haveBeenFinished {
            let alertController = UIAlertController(title: "割り勘の設定を終了しますか？", message: "設定した内容は保存されません", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "終了", style: .destructive, handler: { [weak self] _ in
            self?.haveBeenFinished = true
                vc.move(to: .hidden, animated: true) { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }))
            alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in
            }))

            DispatchQueue.main.async { [weak self] in
                TapticEngine.impact.feedback(.light)
                vc.move(to: .full, animated: true) {
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
