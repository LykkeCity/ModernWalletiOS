//
//  KYCStepViewController.swift
//  ModernMoney
//
//  Created by Lyubomir Marinov on 7.11.18.
//  Copyright © 2018 Lykkex. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WalletCore
import RxSwift
import RxCocoa

class KYCStepViewController: UIViewController {

    @IBOutlet weak var photoPlaceholder: KYCPhotoPlaceholderView!
    
    // IN:
    let pickerTrigger = PublishSubject<Void>()
    
    let type = Variable<KYCDocumentType?>(nil)
    fileprivate let pickedImage = Variable<UIImage?>(nil)
    
    fileprivate let documentsTrigger = Variable<Void>(())
    
    let disposeBag = DisposeBag()
    lazy var documentsViewModel: KYCDocumentsViewModel! = {
        return KYCDocumentsViewModel(
            trigger: self.documentsTrigger.asObservable(),
            forAsset: LWRxAuthManager.instance.baseAsset.request()
        )
    }()
    lazy var documentsUploadViewModel: KycUploadDocumentsViewModel! = {
        return KycUploadDocumentsViewModel(
            forImage: self.pickedImage.asObservable(),
            withType: Variable<KYCDocumentType?>(self.kYCDocumentType)
        )
    }()
    
    static func create(withType type: KYCDocumentType) -> KYCStepViewController {
        guard let controller = UIStoryboard(name: "KYC", bundle: nil)
            .instantiateViewController(withIdentifier: "kycStepVC") as? KYCStepViewController else {
                return KYCStepViewController()
        }
        controller.type.value = type
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentsUploadViewModel.image.asObservable()
            .filterNil()
            .map{ _ in Void() }
            .bind(to: documentsTrigger)
            .disposed(by: disposeBag)
        
        photoPlaceholder.hintLabel.text = kYCDocumentType.getHint()
        photoPlaceholder.imageView.image = #imageLiteral(resourceName: "kycSelfie")
        
        pickerTrigger.asObservable()
            .subscribe(onNext: { [weak self] _ in
                let imagePicker = UIImagePickerController()
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                } else {
                    imagePicker.sourceType = .photoLibrary
                }
                
                imagePicker.delegate = self
                
                self?.present(imagePicker, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        documentsViewModel.documents
            .subscribeOn(MainScheduler.instance)
            .subscribeToFillImage(forVC: self)
            .disposed(by: disposeBag)
    }

}

extension KYCStepViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pickedImage.value = pickedImage
        }
        
        dismissViewController(picker, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissViewController(picker, animated: true)
    }
}

extension KYCStepViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: kYCDocumentType.getTabTitle())
    }
}

extension KYCStepViewController: KYCDocumentTypeAware {
    var kYCDocumentType: KYCDocumentType {
        return self.type.value ?? .none
    }
}

extension KYCStepViewController: KYCPhotoPlaceholder {}

extension KYCDocumentType {
    func getTabTitle() -> String {
        switch self {
        case .selfie: return Localize("kyc.process.tabs.selfie")
        case .idCard: return Localize("kyc.process.tabs.passport")
        case .proofOfAddress: return Localize("kyc.process.tabs.address")
        default: return ""
        }
    }
    
    func getHint() -> String {
        switch self {
        case .selfie: return Localize("kyc.process.titles.selfie")
        case .idCard: return Localize("kyc.process.titles.passport")
        case .proofOfAddress: return Localize("kyc.process.titles.address")
        default: return ""
        }
    }
}
