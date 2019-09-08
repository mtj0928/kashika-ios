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
import JTAppleCalendar

final class AddDebtViewController: UIViewController {
    
    // swiftlint:disable:next private_outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var okanewoLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var moneylabel: UILabel!
    @IBOutlet private weak var placeHolderView: UIView!
    @IBOutlet private weak var karitaButton: UIButton!
    @IBOutlet private weak var kashitaButton: UIButton!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var additionalView: UIView!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var calendarView: JTAppleCalendarView!
    @IBOutlet private weak var calendarSelectView: UIView!
    @IBOutlet private weak var calendarSelectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var scheduleLabel: UILabel!
    
    private let height: CGFloat = 309
    
    private(set) var presenter: AddDebtPresenterProtocol!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEssentialView()
        setupAdditionalView()
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
    
    @IBAction func tappedKashitaButton() {
        TapticEngine.impact.feedback(.light)
        presenter.createDebt(debtType: .kashi)
    }
    
    @IBAction func tappedKaritaButton() {
        TapticEngine.impact.feedback(.light)
        presenter.createDebt(debtType: .kari)
    }
    
    @IBAction func tappedScheduleButton() {
        presenter.shouldOpenCalendar.accept(!presenter.shouldOpenCalendar.value)
    }
    
    class func createFromStoryboard(presenter: AddDebtPresenterProtocol) -> AddDebtViewController {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up for EssentialView

extension AddDebtViewController {
    
    private func setupEssentialView() {
        setupSaveButton()
        setupMoneyLabel()
        setupCollectionView()
    }
    
    private func setupMoneyLabel() {
        presenter.shouldShowPlaceHolder.subscribe(onNext: { [weak self] shouldShowPlaceHolder in
            self?.placeHolderView.isHidden = !shouldShowPlaceHolder
            self?.moneylabel.isHidden = shouldShowPlaceHolder
        }).disposed(by: disposeBag)
        
        presenter.money.subscribe(onNext: { [weak self] value in
            self?.moneylabel.text = String.convertWithComma(from: value)
        }).disposed(by: disposeBag)
    }
    
    private func setupSaveButton() {
        presenter.canBeAddDebt.asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] canBeAdd in
            self?.karitaButton.backgroundColor = canBeAdd ? UIColor.app.negativeColor : UIColor.app.nonActiveButtonColor
            self?.kashitaButton.backgroundColor = canBeAdd ? UIColor.app.positiveColor : UIColor.app.nonActiveButtonColor
            self?.karitaButton.isUserInteractionEnabled = canBeAdd
            self?.kashitaButton.isUserInteractionEnabled = canBeAdd
        }).disposed(by: disposeBag)
        
        karitaButton.setTitle("借りた！", for: .normal)
        kashitaButton.setTitle("貸した！", for: .normal)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: okanewoLabel.frame.minX, bottom: 0.0, right: okanewoLabel.frame.minX)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(R.nib.simpleFriendCell)
        collectionView.register(R.nib.userIconCollectionViewCell)
        
        presenter.selectedIndexes.asDriver().drive(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        presenter.friends.asDriver().drive(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - Setup for AdditionalView

extension AddDebtViewController {
    
    private func setupAdditionalView() {
        additionalView.alpha = 0.0
        setupTextView()
        setupCalendarView()
        setuScheduledLabel()
    }
    
    private func setupTextView() {
        memoTextView.setDoneButton()
        memoTextView.placeholder = "メモを入力"
        
        memoTextView.rx.text.subscribe(onNext: { [weak self] text in
            self?.presenter.memo.accept(text)
        }).disposed(by: disposeBag)
    }
    
    @objc
    private func hideKeyboard() {
        memoTextView.resignFirstResponder()
    }
    
    private func setuScheduledLabel() {
        presenter.selectedDate
            .onlyNil()
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] _ in
                self?.scheduleLabel.text = "入力する"
                self?.scheduleLabel.textColor = UIColor.app.placeHolderText
            }).disposed(by: disposeBag)
        
        presenter.selectedDate
            .filterNil()
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] date in
                let formatter = DateFormatter()
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale(identifier: "ja_JP"))
                self?.scheduleLabel.text = formatter.string(from: date)
                self?.scheduleLabel.textColor = UIColor.app.label
            }).disposed(by: disposeBag)
    }
    
    private func setupCalendarView() {
        presenter.shouldOpenCalendar.skip(1).asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] shouldOpenCalendar in
            guard let `self` = self else {
                return
            }
            
            UIView.animate(withDuration: 0.3,
                           delay: shouldOpenCalendar ? 0 : 0.3,
                           animations: {
                            self.calendarSelectViewHeightConstraint.constant = shouldOpenCalendar ? self.height : 0
                            self.view.layoutIfNeeded()
            })
        }).disposed(by: disposeBag)
        
        calendarSelectViewHeightConstraint.constant = 0
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        calendarView.register(R.nib.calendarViewCell)
        calendarView.contentInset = UIEdgeInsets.zero
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        let today = Date()
        updateMonthLabel(for: today)
        calendarView.scrollToDate(today, animateScroll: false)
    }
    
    private func updateMonthLabel(for date: Date?) {
        let calendar = Calendar(identifier: .gregorian)
        guard let date = date else {
            return
        }
        let startDate = calendar.startOfMonth(for: date)
        if let month = calendar.dateComponents([.month], from: startDate).month {
            monthLabel.text = "\(month)月"
        }
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
        if viewController.position != .full {
            memoTextView.resignFirstResponder()
        }
        presenter.isDecelerating.accept(false)
    }
    
    func floatingPanelDidMove(_ viewController: FloatingPanelController) {
        // swiftlint:disable:next identifier_name
        let y = viewController.surfaceView.frame.origin.y
        let halfY = viewController.originYOfSurface(for: .half)
        let fullY = viewController.originYOfSurface(for: .full)
        
        if fullY < y && y < halfY {
            let progress = (y - fullY) / (halfY - fullY)
            additionalView.alpha = 1 - progress
        }
    }
    
    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return AddDebtPanelBehavior(additionalView)
    }
}

private class AddDebtPanelBehavior: FloatingPanelBehavior {
    
    private weak var additionalView: UIView?
    
    init(_ view: UIView?) {
        self.additionalView = view
    }
    
    func interactionAnimator(_ viewController: FloatingPanelController, to targetPosition: FloatingPanelPosition, with velocity: CGVector) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator()
        
        animator.addAnimations {[weak self] in
            self?.additionalView?.alpha = targetPosition == .full ? 1.0 : 0.0
        }
        
        return animator
    }
}

// MARK: - JTAppleCalendarViewDataSource

extension AddDebtViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let calendar = Calendar(identifier: .gregorian)
        
        let lastYear = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let startDate = calendar.startOfMonth(for: lastYear)
        
        let nextYear = calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        let endDate = calendar.endOfMonth(for: nextYear)
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: .tillEndOfRow)
    }
}

// MARK: - JTAppleCalendarViewDelegate

extension AddDebtViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: R.reuseIdentifier.calendarViewCell.identifier, for: indexPath) as? CalendarViewCell
        cell?.set(cellState.text)
        
        if cellState.dateBelongsTo == .thisMonth {
            cell?.isHidden = false
        } else {
            cell?.isHidden = true
        }
        cell?.isSelected = cellState.isSelected
        
        return cell ?? JTAppleCell()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        cell.isSelected = cellState.isSelected
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        presenter.selectedDate.accept(date)
        presenter.shouldOpenCalendar.accept(false)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateMonthLabel(for: visibleDates.monthDates.first?.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateMonthLabel(for: visibleDates.monthDates.first?.date)
    }
}
