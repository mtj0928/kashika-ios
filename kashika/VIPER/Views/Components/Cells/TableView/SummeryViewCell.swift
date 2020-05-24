//
//  SummeryViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SummeryViewCell: UITableViewCell {
    @IBOutlet private weak var mainView: SummeryView!

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        mainView.backgroundColor = UIColor.app.secondarySystemBackground
        mainView.layer.cornerRadius = 12
        mainView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    func set(money: BehaviorRelay<Int>) {
        money.asDriver().drive(onNext: { [weak self] money in
            self?.mainView.set(money)
        }).disposed(by: disposeBag)
    }
}
