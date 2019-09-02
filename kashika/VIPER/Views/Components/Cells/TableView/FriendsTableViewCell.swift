//
//  FriendsTableViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/01.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FriendsTableViewCell: UITableViewCell {

    static let height: CGFloat = 108

    @IBOutlet private weak var collectionView: UICollectionView!
    private var presenter: FriendsGridPresenterProtocol!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
    }

    func set(presenter: FriendsGridPresenterProtocol) {
        self.presenter = presenter

        collectionView.reloadData()
    }
}

// MARK: - setup

extension FriendsTableViewCell {

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset.left = 16.0
        collectionView.contentInset.right = 16.0

        collectionView.register(R.nib.simpleFriendCell)
    }
}

// MARK: - UICollectionViewDataSource

extension FriendsTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.friends.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.simpleFriendCell, for: indexPath)
        let friend = presenter.friends.value[indexPath.item]
        cell.set(friend: friend, status: .none)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FriendsTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friend = presenter.friends.value[indexPath.item]
        presenter.tapped(friend: friend)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FriendsTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 7 / 10
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
