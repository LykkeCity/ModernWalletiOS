//
//  KYCStep2ViewController.swift
//  ModernWallet
//
//  Created by Georgi Stanev on 9/15/17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WalletCore
import RxSwift
import RxCocoa

class KYCStep2ViewController: UIViewController, KYCStepBinder {
    
    @IBOutlet weak var photoPlaceholder: KYCPhotoPlaceholderView!
    
    var disposeBag: DisposeBag!
    var documentsViewModel: KYCDocumentsViewModel!
    var documentsUploadViewModel: KycUploadDocumentsViewModel!
    
    lazy var loadingViewModel: LoadingViewModel = self.loadingViewModelFactory()
    
    static func create(withViewModel documentsViewModel: KYCDocumentsViewModel, andUploadViewModel uploadViewModel: KycUploadDocumentsViewModel, andDisposeBag disposeBag: DisposeBag) -> KYCStep2ViewController {
        guard let controller = UIStoryboard(name: "KYC", bundle: nil)
            .instantiateViewController(withIdentifier: "kycStep2VC") as? KYCStep2ViewController else {
                return KYCStep2ViewController()
        }
        controller.documentsViewModel = documentsViewModel
        controller.documentsUploadViewModel = uploadViewModel
        controller.disposeBag = disposeBag
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPlaceholder.hintLabel.text = Localize("kyc.process.titles.passport")
        photoPlaceholder.imageView.image = #imageLiteral(resourceName: "kycPassport")
        bindKYC(disposedBy: disposeBag)
    }
}

extension KYCStep2ViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Localize("kyc.process.tabs.passport"))
    }
}

extension KYCStep2ViewController: KYCDocumentTypeAware {
    var kYCDocumentType: KYCDocumentType{
        return .idCard
    }
}

extension KYCStep2ViewController: KYCPhotoPlaceholder {}
