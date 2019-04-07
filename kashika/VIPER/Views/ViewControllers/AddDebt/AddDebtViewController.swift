//
//  AddDebtViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class AddDebtViewController: UIViewController {

    @IBOutlet private weak var okanewoLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var karitaButton: UIButton!
    @IBOutlet private weak var kashitaButton: UIButton!

    private var presenter: AddDebtPresenterProtocol!

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
    }
}

// MARK: - UICollectionVewDataSource

extension AddDebtViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.friends.value.count + 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.simpleFriendCell, for: indexPath)
        cell.setFriend()
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AddDebtViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddDebtViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 7 / 10
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}
