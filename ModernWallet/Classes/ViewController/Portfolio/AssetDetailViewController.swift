//
//  AssetDetailViewController.swift
//  ModernWallet
//
//  Created by Georgi Stanev on 15.11.17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WalletCore

class AssetDetailViewController: UIViewController {

    @IBOutlet weak var baseAssetAmount: AssetAmountView!
    @IBOutlet weak var assetAmount: AssetAmountView!
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var transactionsTap: UITapGestureRecognizer!
    
    @IBOutlet weak var sendButton: IconOverTextButton!
    @IBOutlet weak var transactionsTable: UITableView!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var filterDescriptionView: UIStackView!
    @IBOutlet weak var filterDescriptionLabel: UILabel!
    @IBOutlet weak var filterDescriptionClearButton: UIButton!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!

    private var filterViewController: TransactionPickDateRangeViewController?
    
    fileprivate lazy var assetBalanceViewModel: AssetBalanceViewModel = {
        return AssetBalanceViewModel(asset: self.asset.asObservable())
    }()
    
    fileprivate lazy var currencyExchanger: CurrencyExchanger = {
        return CurrencyExchanger()
    }()
    
    fileprivate lazy var blockchainAddressViewModel: BlockchainAddressViewModel = {
        return BlockchainAddressViewModel(alertPresenter: self)
    }()
    
    fileprivate lazy var transactionsViewModel: TransactionsViewModel = {
        return TransactionsViewModel(
            downloadCsv: self.messageButton.rx.tap.asObservable(),
            dependency: (
                currencyExcancher: self.currencyExchanger,
                authManager: LWRxAuthManager.instance,
                formatter: TransactionFormatter.instance
            )
        )
    } ()

    private let disposeBag = DisposeBag()
    
    var asset: Observable<Asset>!
    fileprivate var assetModel: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionsTable.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        transactionsTable.register(UINib(nibName: "AssetInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "AssetInfoTableViewCell")
        
        transactionsViewModel.transactionsAsCsv = self.messageButton.rx.tap
            .asObservable()
            .mapToCSVURL(transactions: transactionsViewModel
                                        .transactions
                                        .asObservable()
                                        .filter(byAsset: asset))
        
        transactionsViewModel
            .bind(toViewController: self)
            .disposed(by: disposeBag)
        
        blockchainAddressViewModel
            .bind(toViewController: self)
            .disposed(by: disposeBag)
        
        assetBalanceViewModel
            .bind(toAsset: assetAmount, baseAsset: baseAssetAmount)
            .disposed(by: disposeBag)

        asset
            .bind(toViewController: self)
            .disposed(by: disposeBag)
        
        assetAmount.configure(fontSize: 30)
        baseAssetAmount.configure(fontSize: 12)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let segueIdentifier = segue.identifier,
            let assetModel = assetModel
        else {
            rx.messageBottom.onNext("No selected asset")
            return
        }
        
        switch segueIdentifier {
        case "BuyAsset":
            guard let buyVC = segue.destination as? BuyOptimizedViewController else { return }
            buyVC.tradeType = .buy
            buyVC.tradeAssetIdentifier = assetModel.cryptoCurrency.identity
            buyVC.currencyExchanger = currencyExchanger
        case "SellAsset":
            guard let sellVC = segue.destination as? BuyOptimizedViewController else { return }
            sellVC.tradeType = .sell
            sellVC.tradeAssetIdentifier = assetModel.cryptoCurrency.identity
            sellVC.currencyExchanger = currencyExchanger
        case "ReceiveAddress":
            guard let receiveVC = segue.destination as? ReceiveWalletViewController,
                let walletAddress = sender as? String else { return }
                receiveVC.asset = Variable(assetModel)
                receiveVC.address = walletAddress
        case "SendAsset":
            guard let sendVC = segue.destination as? SendToWalletViewController else { return }
            sendVC.asset = Variable(assetModel)
        case "ShowFilterPopover":
            guard let filterNavigationController = segue.destination as? UINavigationController,
                let filterViewController = filterNavigationController.topViewController as? TransactionPickDateRangeViewController else { return }
            
            filterNavigationController.modalPresentationStyle = UIModalPresentationStyle.popover
            filterNavigationController.preferredContentSize = CGSize(width: transactionsTable.bounds.width, height: 280)

            if let filterPopover = filterNavigationController.popoverPresentationController {
                // Calculate the offset for the popover depending on the screen size
                let popoverOffset: CGFloat = UIScreen.isSmallScreen ? -16 : 16

                filterPopover.backgroundColor = Colors.darkGreen
                filterPopover.permittedArrowDirections = UIScreen.isSmallScreen ? .down : .up
                filterPopover.sourceView = self.filterButton
                filterPopover.delegate = self
                filterPopover.sourceRect = CGRect(x: self.filterButton.bounds.midX, y: self.filterButton.bounds.midY + popoverOffset, width: 0,height: 0)
            }
            
            filterViewController.filterViewModel = transactionsViewModel.filterViewModel
            
        default:
            break
        }
    }

    func creatCSV(_ path: URL) -> Void {
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - Bindings
fileprivate extension TransactionsViewModel {
    func bind(toViewController vc: AssetDetailViewController) -> [Disposable] {
        return [
            vc.filterDescriptionClearButton.rx.tap.asObservable()
                .throttle(1.0, scheduler: MainScheduler.instance)
                .map({ return (start: nil, end: nil) })
                .bind(to: filterViewModel.filterDatePair),
            
            isDownloadButtonEnabled.drive(vc.messageButton.rx.isEnabled),
            
            transactions.asObservable()
                .filter(byAsset: vc.asset)
                .bind(
                    to: vc.transactionsTable.rx.items(cellIdentifier: "AssetInfoTableViewCell",
                                                   cellType: AssetInfoTableViewCell.self)
                ){ (row, element, cell) in
                    cell.bind(toTransaction: element)
                },
            
            loading.isLoading.bind(to: vc.rx.loading),
            
            transactionsAsCsv
                .asObservable()
                .filterSuccess()
                .waitFor(loading.isLoading)
                .bind(onNext: {[weak vc] path in vc?.creatCSV(path)}),
            
            errors.drive(vc.rx.error),
            
            filterViewModel.filterDescription.drive(vc.filterDescriptionLabel.rx.attributedText),
            
            filterViewModel.filterDatePair.asObservable()
                .map { return $0.start == nil && $0.end == nil }
                .startWith(true)
                .asDriver(onErrorJustReturn: true)
                .drive(vc.filterDescriptionView.rx.isHidden)
        ]
    }
}

extension ObservableType where Self.E == Asset {
    func getAssetModel() -> Observable<LWAssetModel> {
        return flatMap { asset -> Observable<LWAssetModel> in
            guard let assetModel = asset.wallet?.asset else {
                return .empty()
            }
            return Observable.just(assetModel)
        }
    }
    
    func bind(toViewController vc: AssetDetailViewController) -> [Disposable] {
        return [
            getAssetModel()
                .map { $0.blockchainDeposit }
                .asDriver(onErrorJustReturn: false)
                .drive(vc.receiveButton.rx.isEnabled),
            
            bind{ [weak vc] in vc?.assetModel = $0 },
            
            mapToCryptoName()
                .asDriver(onErrorJustReturn: "")
                .drive(vc.rx.title),
            
            map{ $0.wallet?.asset.blockchainWithdraw ?? false }
                .asDriver(onErrorJustReturn: false)
                .drive(vc.sendButton.rx.isEnabled),
        ]
    }
}

extension ObservableType where Self.E == [TransactionViewModel] {
    func filter(byAsset asset: Observable<Asset>) -> Observable<[TransactionViewModel]> {
        return
            withLatestFrom(asset) {(transactions: $0, asset: $1)}
            .map{ data in
                data.transactions.filter{transaction in
                    transaction.transaction.asset == data.asset.wallet?.asset.identity
                }
            }
    }
}

extension BlockchainAddressViewModel {
    func bind(toViewController vc: AssetDetailViewController) -> [Disposable] {
        return [
            vc.receiveButton.rx.tap.asObservable()
                .withLatestFrom(vc.asset.getAssetModel())
                .bind(to: asset),
            
            blockchainAddress
                .waitFor(loadingViewModel.isLoading)
                .subscribe(onNext: { [weak vc] address in
                    vc?.performSegue(withIdentifier: "ReceiveAddress", sender: address)
                }),
            errors.bind(to: vc.rx.error),
            loadingViewModel.isLoading
                .asDriver(onErrorJustReturn: false)
                .drive(vc.rx.loading)
        ]
    }
}

extension AssetBalanceViewModel {
    func bind(toAsset asset: AssetAmountView, baseAsset: AssetAmountView) -> [Disposable] {
        return [
            assetBalance.drive(asset.rx.amount),
            assetBalanceInBase.drive(baseAsset.rx.amount),
            assetCode.drive(asset.rx.code),
            baseAssetCode.drive(baseAsset.rx.code)
        ]
    }
}

fileprivate extension AssetAmountView {
    func configure(fontSize: CGFloat) {
        codeFont = UIFont(name: "Geomanist-Light", size: fontSize)
        amountFont = UIFont(name: "Geomanist-Light", size: fontSize)
    }
}

extension AssetDetailViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
