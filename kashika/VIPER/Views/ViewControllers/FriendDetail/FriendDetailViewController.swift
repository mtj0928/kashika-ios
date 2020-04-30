//
//  FriendDetailViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/17.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import FloatingPanel
import TapticEngine

final class FriendDetailViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var overlayHeightConstraint: NSLayoutConstraint!

    var scrollView: UIScrollView {
        return tableView
    }

    private var presenter: FriendDetailPresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupOverlayView()
        subscribePresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        TapticEngine.impact.prepare(.light)
    }

    @IBAction func tappedCloseButton() {
        TapticEngine.impact.feedback(.light)
        presenter.dismiss()
    }

    static func createFromStoryboard(with presenter: FriendDetailPresenterProtocol) -> FriendDetailViewController {
        let viewController = FriendDetailViewController.createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension FriendDetailViewController {

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(R.nib.friendDetailMainTableViewCell)
        tableView.register(R.nib.debtLogCell)
        let headerViewNib = UINib(nibName: R.nib.homeTitleHeader.name, bundle: R.nib.homeTitleHeader.bundle)
        tableView.register(headerViewNib, forHeaderFooterViewReuseIdentifier: R.nib.homeTitleHeader.name)
    }

    private func setupOverlayView() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {
            overlayHeightConstraint.constant = 0
            return
        }
        overlayHeightConstraint.constant = tableView.frame.height - cell.frame.height
    }

    private func subscribePresenter() {
        presenter.debts.asDriver().drive(onNext: { [weak self] _ in
            self?.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource

extension FriendDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return presenter.debts.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.friendDetailMainTableViewCell, for: indexPath)
            presenter.friend.asDriver().drive(onNext: { friend in
                cell.set(for: friend)
            }).disposed(by: disposeBag)
            return cell
        }
        let cell = tableView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.debtLogCell, for: indexPath)
        cell.set(debt: presenter.debts.value[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FriendDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.homeTitleHeader.name) as? HomeTitleHeader
            view?.set(title: "ログ")
            return view
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60.0
        }
        return -1
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? FriendDetailMainTableViewCell != nil {
            overlayHeightConstraint.constant = tableView.frame.height - cell.frame.height - 60
        }
    }
}

// MARK: - FloatingPanelControllerDelegate

extension FriendDetailViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ viewController: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        viewController.surfaceView.backgroundColor = view.backgroundColor
        return FriendDetailLayout()
    }

    func floatingPanelDidEndDecelerating(_ viewController: FloatingPanelController) {
        if viewController.position == .hidden {
            presenter.dismiss()
        }
    }

    func floatingPanelDidMove(_ viewController: FloatingPanelController) {
        // swiftlint:disable:next identifier_name
        let y = viewController.surfaceView.frame.origin.y
        let halfY = viewController.originYOfSurface(for: .half)
        let fullY = viewController.originYOfSurface(for: .full)

        if fullY < y && y < halfY {
            let progress = (y - fullY) / (halfY - fullY)
            overlayView.alpha = progress
        }
    }

    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return FriendDetailPanelBehavior(overlayView)
    }
}

private class FriendDetailPanelBehavior: FloatingPanelBehavior {

    private weak var targetView: UIView?

    init(_ view: UIView?) {
        self.targetView = view
    }

    func interactionAnimator(_ viewController: FloatingPanelController, to targetPosition: FloatingPanelPosition, with velocity: CGVector) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator()

        animator.addAnimations {[weak self] in
            self?.targetView?.alpha = targetPosition == .full ? 0.0 : 1.0
        }

        return animator
    }
}
