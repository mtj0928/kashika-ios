//
//  ScheduledsTableViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/08.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ScheduledsTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    static let height: CGFloat = 120

    var presenter: ScheduledPresenterProtocol! {
        didSet {
            update()
        }
    }

    private var cellHeight: CGFloat {
        return collectionView.frame.height - cellSpace
    }

    private var cellWidth: CGFloat {
        return collectionView.frame.width - 2 * cellSpace - 80.0
    }

    private var cellSpace: CGFloat {
        return 16.0
    }

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.backgroundColor = UIColor.clear

        collectionView.setCollectionViewLayout(CollectionViewLayout(pageWidth: cellWidth, height: cellHeight, space: cellSpace), animated: false)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)

        collectionView.decelerationRate = .fast
        collectionView.register(R.nib.paymentScheduleColleionViewCell)
    }

    private func update() {
        disposeBag = DisposeBag()

        presenter.debts.asDriver().drive(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)

        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ScheduledsTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.debts.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellAndWrap(withReuseIdentifier: R.reuseIdentifier.paymentScheduleColleionViewCell, for: indexPath)
        let debt = presenter.debts.value[indexPath.item]
        presenter.getFriend(has: debt).subscribe(onSuccess: { friend in
            guard let friend = friend else {
                return
            }
            cell.set(debt: debt, friend: friend)
            cell.mainView.backgroundColor = UIColor.app.cardViewBackgroundColor
            }).disposed(by: disposeBag)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ScheduledsTableViewCell: UICollectionViewDelegate {

}

private class CollectionViewLayout: UICollectionViewLayout {

    let pageWidth: CGFloat
    let pageHeight: CGFloat
    let space: CGFloat

    var attributesArray = [UICollectionViewLayoutAttributes]()

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
                return CGSize.zero
        }

        let numberOfItems = CGFloat(integerLiteral: collectionView.numberOfItems(inSection: 0))
        let width = numberOfItems * (pageWidth + space) - space + (collectionView.frame.width - collectionView.contentInset.left - pageWidth)
        return CGSize(width: max(width, collectionView.frame.width + 1), height: pageHeight)
    }

    init(pageWidth: CGFloat, height: CGFloat, space: CGFloat) {
        self.pageWidth = pageWidth
        self.pageHeight = height
        self.space = space
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard attributesArray.isEmpty, let collectionView = collectionView else {
            return
        }
        attributesArray = (0..<collectionView.numberOfItems(inSection: 0))
            .map({ item -> UICollectionViewLayoutAttributes in
                let indexPath = IndexPath(item: item, section: 0)
                let frame = CGRect(x: (pageWidth + space) * CGFloat(item),
                                   y: (collectionView.frame.height - pageHeight) / 2,
                                   width: pageWidth,
                                   height: pageHeight)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                return attributes
            })
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray.filter({ $0.frame.intersects(rect) })
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return CGPoint.zero
        }

        let currentPage = collectionView.contentOffset.x / pageWidth

        if abs(velocity.x) > 0.4 {
            let nextPage = velocity.x > 0.0 ? ceil(currentPage) : floor(currentPage)
            return CGPoint(x: nextPage * (pageWidth + space) - collectionView.contentInset.left, y: proposedContentOffset.y)
        } else {
            return CGPoint(x: round(currentPage) * (pageWidth + space) - collectionView.contentInset.left, y: proposedContentOffset.y)
        }
    }
}
