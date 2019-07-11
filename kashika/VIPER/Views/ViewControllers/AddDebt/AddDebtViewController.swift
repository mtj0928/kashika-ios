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

final class AddDebtViewController: UIViewController {

    @IBOutlet private weak var okanewoLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var karitaButton: UIButton!
    @IBOutlet private weak var kashitaButton: UIButton!

    private var presenter: AddDebtPresenterProtocol!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
        setupCollectionView()
    }

    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        presenter.tappedCloseButton()
    }

    class func createFromStoryboard(presenter: AddDebtPresenterProtocol) -> AddDebtViewController {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension AddDebtViewController {

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
        collectionView.register(R.nib.addUserCell)

        presenter.selectedIndexes.asDriver().drive(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionVewDataSource

extension AddDebtViewController: UICollectionViewDataSource {

    private enum Section: Int, CaseIterable {
        case friend, add
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
            return presenter.friends.value.count + 10
        case .add:
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
        case .add:
            return addCell(collectionView, cellForItemAt: indexPath)
        }
    }

    private func friendCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.simpleFriendCell, for: indexPath)
        let status = presenter.getStatus(at: indexPath.item)
        cell.setFriend(status: status)
        cell.isSecondary = true
        return cell
    }

    private func addCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.addUserCell, for: indexPath)
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
        case .add:

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
        case .add:
            let cells = collectionView.visibleCells.compactMap({ $0 as? AddUserCell })
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
        case .add:
            let cells = collectionView.visibleCells.compactMap({ $0 as? AddUserCell })
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
        case .add:
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
