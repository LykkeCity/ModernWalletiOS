//
//  CashOutSelectAssetViewController.swift
//  ModernWallet
//
//  Created by Nacho Nachev on 10.10.17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WalletCore

class CashOutSelectAssetViewController: UIViewController {
    
    @IBOutlet private var availableBalanceLabel: UILabel!
    
    @IBOutlet private var assetAmountView: AssetAmountView!
    
    @IBOutlet private var selectAssetLabel: UILabel!
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private let totalBalanceViewModel = TotalBalanceViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var walletsViewModel: WalletsViewModel = {
        return WalletsViewModel(
            withBaseAsset: self.totalBalanceViewModel.observables.baseAsset.filterSuccess(),
            mainInfo: self.totalBalanceViewModel.observables.mainInfo.filterSuccess()
        )
    }()
    
    var assets = Variable<[Variable<Asset>]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        totalBalanceViewModel.balance
            .drive(assetAmountView.rx.amount)
            .disposed(by: disposeBag)
        
        totalBalanceViewModel.currencyName
            .drive(assetAmountView.rx.code)
            .disposed(by: disposeBag)
        
        collectionView.register(UINib(nibName: "AssetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AssetCell")
        
        assets.asObservable()
            .map{$0.sorted{$0.0.value.percent > $0.1.value.percent}}
            .bind(to: collectionView.rx.items(cellIdentifier: "AssetCell", cellType: AssetCollectionViewCell.self)) { (row, element, cell) in
                cell.bind(toAsset: AssetCollectionCellViewModel(element))
            }
            .disposed(by: disposeBag)
        
        
        walletsViewModel.wallets
            .filterOnlySwiftWithdraw()
            .bind(to: assets)
            .disposed(by: disposeBag)
        
        availableBalanceLabel.text = Localize("cashOut.newDesign.availableBalance")
        selectAssetLabel.text = Localize("cashOut.newDesign.selectAsset")
    }
    
    override func viewWillLayoutSubviews() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let sideInset = view.frame.width.truncatingRemainder(dividingBy: layout.itemSize.width) / 2
        var insets = layout.sectionInset
        insets.left = sideInset
        insets.right = sideInset
        layout.sectionInset = insets
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

fileprivate extension ObservableType where Self.E == [Variable<Asset>] {
    func filterOnlySwiftWithdraw() -> Observable<[Variable<Asset>]> {
        return map{wallets in
            wallets.filter{(asset: Variable<Asset>) in
                asset.value.wallet?.asset.swiftWithdraw ?? false
            }
        }
    }
}
