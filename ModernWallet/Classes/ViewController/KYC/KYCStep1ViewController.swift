//
//  KYCStep1ViewController.swift
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

class KYCStep1ViewController: UIViewController, KYCStepBinder {

    @IBOutlet weak var photoPlaceholder: KYCPhotoPlaceholderView!
    
    var disposeBag: DisposeBag!
    var documentsViewModel: KYCDocumentsViewModel!
    var documentsUploadViewModel: KycUploadDocumentsViewModel!
    
    lazy var loadingViewModel: LoadingViewModel = self.loadingViewModelFactory()
    
    static func create(withViewModel documentsViewModel: KYCDocumentsViewModel, andUploadViewModel uploadViewModel: KycUploadDocumentsViewModel, andDisposeBag disposeBag: DisposeBag) -> KYCStep1ViewController {
        guard let controller = UIStoryboard(name: "KYC", bundle: nil)
            .instantiateViewController(withIdentifier: "kycStep1VC") as? KYCStep1ViewController else {
            return KYCStep1ViewController()
        }
        controller.documentsViewModel = documentsViewModel
        controller.documentsUploadViewModel = uploadViewModel
        controller.disposeBag = disposeBag
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPlaceholder.hintLabel.text = Localize("kyc.process.titles.selfie")
        photoPlaceholder.imageView.image = #imageLiteral(resourceName: "kycSelfie")
        bindKYC(disposedBy: disposeBag)
    }
}


extension KYCStep1ViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Localize("kyc.process.tabs.selfie"))
    }
}

extension KYCStep1ViewController: KYCDocumentTypeAware {
    var kYCDocumentType: KYCDocumentType{
        return .selfie
    }
}

extension KYCStep1ViewController: KYCPhotoPlaceholder {}


