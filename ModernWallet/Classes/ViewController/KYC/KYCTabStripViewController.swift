//
//  KYCTabStripViewController.swift
//  ModernWallet
//
//  Created by Georgi Stanev on 9/15/17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import WalletCore
import RxSwift
import RxCocoa
import XLPagerTabStrip
import AlamofireImage

class KYCTabStripViewController: BaseButtonBarPagerTabStripViewController<KYCTabCollectionViewCell>,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var nextStepButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var pendingApprovalContainer: UIStackView!
    
    private let selectedScreenSubject = PublishSubject<KYCStepViewController>()
    
    private let disposeBag = DisposeBag()
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "KYCTabCollectionViewCell", bundle: Bundle(for: KYCTabCollectionViewCell.self), width: { (cell: IndicatorInfo) -> CGFloat in
            return 55.0
        })
    }
    
    fileprivate lazy var controllers: [UIViewController] = {
        guard let storyboard = self.storyboard else {return []}
        
        return [
            KYCStepViewController.create(withType: .selfie),
            KYCStepViewController.create(withType: .idCard),
            KYCStepViewController.create(withType: .proofOfAddress)
        ]
    }()
    
    override func viewDidLoad() {
        pagerBehaviour = PagerTabStripBehaviour.common(skipIntermediateViewControllers: true)
        
        // change selected bar color
        guard let font = UIFont(name: "Geomanist-Book", size: 14) else {return}
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = font
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { (oldCell: KYCTabCollectionViewCell?, newCell: KYCTabCollectionViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.alpha = 0.5
            newCell?.label.alpha = 1.0
        }
        
        // MARK: Button bindings
        cameraButton.rx.tap
            .withLatestFrom(selectedScreenSubject)
            .subscribe(onNext: { controller in
                controller.pickerTrigger.onNext(())
            })
            .disposed(by: disposeBag)
        
        
        // MARK: Current screen bindings
        let currentScreen = selectedScreenSubject.asObservable()
            .shareReplay(1)
        
        let currentScreenDocuments = currentScreen
            .flatMapLatest { $0.documentsViewModel.documents }
            .shareReplay(1)
        
        nextStepButton.rx.tap.asObservable()
            .withLatestFrom(currentScreenDocuments)
            .subscribeToMoveNext(withVC: self)
            .disposed(by: disposeBag)
        
        currentScreen
            .flatMapLatest { $0.documentsUploadViewModel.image.asObservable() }
            .filterNil()
            .asDriver(onErrorJustReturn: UIImage())
            .driveToReplacePlaceHolder(inVC: self)
            .disposed(by: disposeBag)
        
        currentScreen
            .flatMapLatest { Observable<Bool>.merge(
                $0.documentsViewModel.loadingViewModel.isLoading,
                $0.documentsUploadViewModel.loadingViewModel.isLoading)
            }
            .bind(to: rx.loading)
            .disposed(by: disposeBag)
        
        currentScreen
            .flatMapLatest {
                Driver.merge($0.documentsViewModel.error, $0.documentsUploadViewModel.error)
            }
            .asDriver(onErrorJustReturn: [:])
            .drive(onNext: { [weak self] error in
                guard let `self` = self else { return }
                self.show(error: error)
            })
            .disposed(by: disposeBag)
        
        currentScreenDocuments
            .subscribeToFillIcon(forType: .selfie, inButtonBar: self.buttonBarView)
            .disposed(by: disposeBag)
        
        currentScreenDocuments
            .subscribeToFillIcon(forType: .idCard, inButtonBar: self.buttonBarView)
            .disposed(by: disposeBag)
        
        currentScreenDocuments
            .subscribeToFillIcon(forType: .proofOfAddress,  inButtonBar: self.buttonBarView)
            .disposed(by: disposeBag)
        
        currentScreen
            .flatMapLatest { $0.type.asObservable() }
            .bindToDisable(button: self.nextStepButton)
            .disposed(by: disposeBag)
        
        currentScreenDocuments
            .filterAnyRejected()
            .mapToFailedViewController(withStoryBoard: self.storyboard)
            .subscribe(onNext: {[weak self] controller in
                self?.present(controller, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        currentScreenDocuments
            .filterAllUploadedOrApproved()
            .subscribe(onNext: {[weak self] _ in
                self?.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .kycDocumentsUploadedOrApproved, object: nil)
                }
            })
            .disposed(by: disposeBag)
        
        let documentsAndType = Observable
            .combineLatest(currentScreenDocuments, currentScreen.asObservable().map { $0.kYCDocumentType })
            .shareReplay(1)
            
        documentsAndType
            .bindToChangeText(ofButton: self.cameraButton)
            .disposed(by: disposeBag)
        
        documentsAndType
            .mapToStatus()
            .map{!$0.isUploaded}
            .bind(to: pendingApprovalContainer.rx.isHiddenAnimated)
            .disposed(by: disposeBag)
        
        let documentStatus = documentsAndType
            .mapToStatus()
            .shareReplay(1)
            
        documentStatus
            .map{$0.isUploaded}
            .bind(to: cameraButton.rx.isHiddenAnimated)
            .disposed(by: disposeBag)
        
        documentStatus
            .filter { !$0.isUploaded || !$0.isUploadedOrApproved || $0.isRejected }
            .map {_ in true}
            .bind(to: cameraButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return controllers
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex)
        
        // TODO: Change this tab controller
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            guard let kycStepVC = self.controllers[self.currentIndex] as? KYCStepViewController else { return }
            self.selectedScreenSubject.onNext(kycStepVC)
            
            print(kycStepVC.kYCDocumentType.getTabTitle())
        })
        
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
    }

    override func configure(cell: KYCTabCollectionViewCell, for indicatorInfo: IndicatorInfo) {
        cell.label.text = indicatorInfo.title
        cell.image.image = indicatorInfo.image
        cell.image.isHidden = indicatorInfo.image == nil
    }
}

// MARK:- Computed properties
fileprivate extension KYCTabStripViewController {
    fileprivate var currentPhotoPlaceHolder: KYCPhotoPlaceholder? {
        guard let photoHolder = self.controllers[self.currentIndex] as? KYCPhotoPlaceholder else {return nil}
        return photoHolder
    }
    
    fileprivate var currentKYCDocumentType: KYCDocumentType? {
        guard let kycDocumentypeAware = self.controllers[self.currentIndex] as? KYCDocumentTypeAware else {return nil}
        return kycDocumentypeAware.kYCDocumentType
    }
}

// MARK:- RX Exensions
fileprivate extension ObservableType where Self.E == LWKYCDocumentsModel {
    func filterAnyRejected() -> Observable<LWKYCDocumentsModel> {
        return filter{kycModel in
            kycModel.status(for: .selfie).isRejected ||
            kycModel.status(for: .idCard).isRejected ||
            kycModel.status(for: .proofOfAddress).isRejected
        }
    }
    
    func filterAllUploadedOrApproved() -> Observable<LWKYCDocumentsModel> {
        return filter{kycModel in
            kycModel.status(for: .selfie).isUploadedOrApproved &&
            kycModel.status(for: .idCard).isUploadedOrApproved &&
            kycModel.status(for: .proofOfAddress).isUploadedOrApproved
        }
    }
    
    func mapToFailedViewController(withStoryBoard storyboard: UIStoryboard?) -> Observable<KYCPhotoFailedViewController> {
        return map{[weak storyboard] documentsModel -> KYCPhotoFailedViewController? in
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "kycPhotoFailedVC")
                as? KYCPhotoFailedViewController else {
                    return nil
            }
            
            controller.documentsModel = documentsModel
            return controller
        }.filterNil()
    }
    
    func subscribeToMoveNext(withVC vc: BaseButtonBarPagerTabStripViewController<KYCTabCollectionViewCell>) -> Disposable {
        return subscribe(onNext: {[weak vc] documentsModel -> Void in
            guard let vc = vc else {return}
            guard var nextDocType = KYCDocumentType.find(byIndex: vc.currentIndex)?.next else{return}
            
            //If next doctype is uploaded or approved go to one after the next one
            if [.uploaded, .approved].contains(documentsModel.status(for: nextDocType)), let furtherDocType = nextDocType.next {
                nextDocType = furtherDocType
            }
            
            guard vc.canMoveTo(index: nextDocType.index) else {return}
            vc.moveToViewController(at: nextDocType.index, animated: true)
        })
    }
}

extension ObservableType where Self.E == LWKYCDocumentsModel {
    func subscribeToFillImage<ViewController: UIViewController>(forVC vc: ViewController) -> Disposable
        where ViewController: KYCDocumentTypeAware & KYCPhotoPlaceholder
    {
        return subscribe(onNext: {[weak vc] kycModel in
            guard let vc = vc else {return}
            
            if let imageUrlStr = kycModel.imageUrl(for: vc.kYCDocumentType), let imageUrl = URL(string: imageUrlStr)  {
                vc.photoPlaceholder.photoImage.isHidden = false
                vc.photoPlaceholder.photoImage.af_setImage(withURL: imageUrl, useToken: true, loaderHolder: vc)
                return
            }
            
            if let image = kycModel.image(for: vc.kYCDocumentType) {
                vc.photoPlaceholder.photoImage.isHidden = false
                vc.photoPlaceholder.photoImage.image = image
                return
            }
        })
    }
    
    func subscribeToFillIcon(
        forType type: KYCDocumentType,
        inButtonBar buttonBar: ButtonBarView
    ) -> Disposable {
        return subscribe(onNext: {[weak buttonBar] documents in
            let status = documents.status(for: type)
            
            guard let cell = buttonBar?.cellForItem(at: IndexPath(row: type.index, section: 0)) as? KYCTabCollectionViewCell else {
                return
            }
            
            cell.image.image = status.image
            cell.image.isHidden = status.image == nil
        })
    }
}

fileprivate extension ObservableType where Self.E == KYCDocumentType? {
    func bindToDisable(button: UIBarButtonItem) -> Disposable {
        return filterNil()
            .map{documentType in documentType.next != nil}
            .bind(to: button.rx.isEnabled)
    }
}

fileprivate extension ObservableType where Self.E == (LWKYCDocumentsModel, KYCDocumentType) {
    func bindToChangeText(ofButton button: UIButton) -> Disposable {
        return mapToStatus()
            .map{$0.buttonText}
            .bind(to: button.rx.title)
    }
    
    func mapToStatus() -> Observable<KYCDocumentStatus> {
        return map{$0.0.status(for: $0.1)}
    }
}

fileprivate extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Self.E == UIImage {
    func driveToReplacePlaceHolder(inVC vc: KYCTabStripViewController) -> Disposable {
        return drive(onNext: {[weak vc] image in
            guard let vc = vc, let photoHolder = vc.currentPhotoPlaceHolder else{return}
            photoHolder.photoPlaceholder.photoImage.isHidden = false
            photoHolder.photoPlaceholder.photoImage.image = image
        })
    }
}
