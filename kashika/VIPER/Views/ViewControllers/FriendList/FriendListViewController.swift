//
//  FriendListViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/22.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TapticEngine

final class FriendListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var footerButtons: SNSFooterButtons!
    @IBOutlet private weak var bottomConstaraintOfFooter: NSLayoutConstraint!
    private let popupView = PopupView()

    private var presenter: FriendListPresenterProtocol!
    private var footerPresenter: SNSFooterPresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFooter()
        setupNavigationBar()
        setupTableView()
        setupPopup()
        subscribePresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        TapticEngine.impact.prepare(.light)
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

    private func setupPopup() {
        tabBarController?.view.addSubview(popupView)
        popupView.fillSuperview()

        let contenView = LinkPopupView()
        let width = view.frame.width * 0.8
        contenView.backgroundColor = UIColor.app.cardViewBackgroundColor

        contenView.tappedCloseButton.asDriver().drive(onNext: { [weak self] _ in
            TapticEngine.impact.feedback(.light)
            self?.popupView.dismiss()
            guard let friend = contenView.friend else {
                return
            }
            self?.presenter.shouldShowPopup = !contenView.isSelectedUnshown
            self?.presenter.tappedLinkButton(friend: friend)
        }).disposed(by: disposeBag)

        popupView.contentSize = CGSize(width: width, height: 1.2 * width)
        popupView.contentView = contenView
        popupView.isHidden = true
    }

    private func subscribePresenter() {
        presenter.action.drive(onNext: { [weak self] action in
            switch action {
            case .showInvitationPopup(let itemSource):
                self?.showShareView(with: itemSource)
            case .showAlreadyRegisteredPopup:
                let alertController = UIAlertController(title: nil, message: "すでにリンク済みです", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alertController, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - View

extension FriendListViewController {

    private func showPopupView(friend: Friend) {
        if presenter.shouldShowPopup {
            (popupView.contentView as? LinkPopupView)?.set(friend)
            popupView.presentation()
        } else {
            presenter.tappedLinkButton(friend: friend)
        }
    }

    private func showShareView(with item: InviteActivityItemSource) {
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        present(activityViewController, animated: true)
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
        cell.set(friend)
        cell.tappedLinkButton.asDriver().drive(onNext: { [weak self] _ in
            TapticEngine.impact.feedback(.light)
            self?.showPopupView(friend: friend)
        }).disposed(by: cell.disposeBag)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FriendListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TapticEngine.impact.feedback(.light)

        let friend = presenter.friends.value[indexPath.row]
        presenter.tapped(friend: friend)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
