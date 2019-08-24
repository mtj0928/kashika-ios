//
//  AddDebtViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FloatingPanel
import TapticEngine

final class AddDebtViewController: UIViewController {

    @IBOutlet private weak var okanewoLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var moneylabel: UILabel!
    @IBOutlet private weak var placeHolderView: UIView!
    @IBOutlet private weak var karitaButton: UIButton!
    @IBOutlet private weak var kashitaButton: UIButton!
    @IBOutlet private weak var unitLabel: UILabel!

    private var presenter: AddDebtPresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
        setupMoneyLabel()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        TapticEngine.impact.prepare(.light)
    }

    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        TapticEngine.impact.feedback(.light)
        presenter.tappedCloseButton()
    }
    
    @IBAction func tappedMoneyButton() {
        presenter.tappedMoneyButton()
    }

    class func createFromStoryboard(presenter: AddDebtPresenterProtocol) -> AddDebtViewController {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension AddDebtViewController {

    private func setupMoneyLabel() {
        presenter.shouldShowPlaceHolder.subscribe(onNext: { [weak self] shouldShowPlaceHolder in
            self?.placeHolderView.isHidden = !shouldShowPlaceHolder
            self?.moneylabel.isHidden = shouldShowPlaceHolder
        }).disposed(by: disposeBag)

        presenter.money.subscribe(onNext: { [weak self] value in
            self?.moneylabel.text = String.convertWithComma(from: value)
        }).disposed(by: disposeBag)
    }

    private func setupButton() {
        karitaButton.backgroundColor = UIColor.app.negativeColor
        karitaButton.setTitle("借りた！", for: .normal)

        kashitaButton.backgroundColor = UIColor.app.positiveColor
        kashitaButton.setTitle("貸した！", for: .normal)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: okanewoLabel.frame.minX, bottom: 0.0, right: okanewoLabel.frame.minX)

        collectionView.register(R.nib.simpleFriendCell)
        collectionView.register(R.nib.userIconCollectionViewCell)

        presenter.selectedIndexes.asDriver().drive(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionVewDataSource

extension AddDebtViewController: UICollectionViewDataSource {

    private enum Section: Int, CaseIterable {
        case friend, users
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }

        switch section {
        case .friend:
            return presenter.friends.value.count 
        case .users:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch section {
        case .friend:
            return friendCell(collectionView, cellForItemAt: indexPath)
        case .users:
            return usersCell(collectionView, cellForItemAt: indexPath)
        }
    }

    private func friendCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.simpleFriendCell, for: indexPath)
        let status = presenter.getStatus(at: indexPath.item)
        let friend = presenter.friends.value[indexPath.item]
        cell.set(friend: friend, status: status)
        cell.isSecondary = true
        return cell
    }

    private func usersCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.userIconCollectionViewCell, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AddDebtViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .friend:
            presenter.selectFriend(at: indexPath.item)
        case .users:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .friend:
            break
        case .users:
            let cells = collectionView.visibleCells.compactMap({ $0 as? UserIconCollectionViewCell })
            if let cell = cells.first {
                cell.select()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .friend:
            break
        case .users:
            let cells = collectionView.visibleCells.compactMap({ $0 as? UserIconCollectionViewCell })
            if let cell = cells.first {
                cell.unselect()
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddDebtViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 7 / 10
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = Section(rawValue: section) else {
            return UIEdgeInsets.zero
        }
        switch section {
        case .users:
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        default:
            return UIEdgeInsets.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}

// MARK: - FloatingPanelControllerDelegate

extension AddDebtViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ viewController: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        viewController.surfaceView.backgroundColor = view.backgroundColor
        return EditDebtLayout()
    }

    func floatingPanelWillBeginDecelerating(_ viewController: FloatingPanelController) {
        presenter.isDecelerating.accept(true)
    }

    func floatingPanelDidEndDecelerating(_ viewController: FloatingPanelController) {
        if viewController.position == .hidden {
            presenter.dismissedFloatingPanel()
        }
        presenter.isDecelerating.accept(false)
    }
}
