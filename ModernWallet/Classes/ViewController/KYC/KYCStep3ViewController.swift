//
//  KYCStep3ViewController.swift
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

class KYCStep3ViewController: UIViewController, KYCStepBinder {
    
    @IBOutlet weak var photoPlaceholder: KYCPhotoPlaceholderView!
    
    var disposeBag: DisposeBag!
    var documentsViewModel: KYCDocumentsViewModel!
    var documentsUploadViewModel: KycUploadDocumentsViewModel!
    
    lazy var loadingViewModel: LoadingViewModel = self.loadingViewModelFactory()
    
    static func create(withViewModel documentsViewModel: KYCDocumentsViewModel, andUploadViewModel uploadViewModel: KycUploadDocumentsViewModel, andDisposeBag disposeBag: DisposeBag) -> KYCStep3ViewController {
        guard let controller = UIStoryboard(name: "KYC", bundle: nil)
            .instantiateViewController(withIdentifier: "kycStep3VC") as? KYCStep3ViewController else {
                return KYCStep3ViewController()
        }
        controller.documentsViewModel = documentsViewModel
        controller.documentsUploadViewModel = uploadViewModel
        controller.disposeBag = disposeBag
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPlaceholder.hintLabel.text = Localize("kyc.process.titles.address")
        photoPlaceholder.imageView.image = #imageLiteral(resourceName: "kycAddress")
        bindKYC(disposedBy: disposeBag)
    }
}

extension KYCStep3ViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: Localize("kyc.process.tabs.address"))
    }
}

extension KYCStep3ViewController: KYCDocumentTypeAware {
    var kYCDocumentType: KYCDocumentType{
        return .proofOfAddress
    }
}

extension KYCStep3ViewController: KYCPhotoPlaceholder {}
