//
//  KYCPendingViewController.swift
//  ModernWallet
//
//  Created by Georgi Stanev on 10/2/17.
//  Copyright © 2017 Lykkex. All rights reserved.
//

import UIKit
import WalletCore
import RxSwift
import RxCocoa

class KYCPendingViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = String(format: Localize("kyc.pending.text"), LWKeychainManager.instance().fullName())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
