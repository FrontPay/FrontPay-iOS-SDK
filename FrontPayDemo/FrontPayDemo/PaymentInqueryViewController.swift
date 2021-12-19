//
//  PaymentInqueryViewController.swift
//  FrontPayDemo
//
//  Created by Waseem Sarwar on 18/12/2021.
//

import UIKit
import FrontPay

class PaymentInqueryViewController: UIViewController {

    @IBOutlet weak var tfReference: UITextField!
    @IBOutlet weak var txtResponse: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicatorView.stopAnimating()
    }
    

    @IBAction func checkPaymentResponse(){
        
        if (tfReference.text ?? "").isEmpty{
            self.showAlert("Please input transaction reference first.")
            return
        }
        activityIndicatorView.startAnimating()
        
        //create FrontPayConfig
        let config = FrontPayConfig.with(paymentMode:PAYMENT_MODE.TEST, merchantId:"72806695", merchantSecret:"fp-client-secret-0729065549")
        //start paying
        let vcnt = FrontPayPaymentManager.paymentInquiry(config: config, transaction_reference:tfReference.text ?? "")
        vcnt.completionHandlerSuccess = { response in
            print("success response=",response ?? "")
            var resultValues = [String]()
            if let paramDict = response{
                for (key, value) in paramDict {
                    print("value = \(value)")
                    resultValues.append(key + " = " + "\(value)")
                }
                self.txtResponse.text = resultValues.joined(separator: "\n")
            }
            self.activityIndicatorView.stopAnimating()
        }
        vcnt.completionHandlerFailed = { response in
            print("error response=",response ?? "")
            var resultValues = [String]()
            if let paramDict = response{
                for (key, value) in paramDict {
                    print("value = \(value)")
                    resultValues.append(key + " = " + "\(value)")
                }
                self.txtResponse.text = resultValues.joined(separator: "\n")
            }
            self.activityIndicatorView.stopAnimating()
        }
 
    }
    
    func showAlert(_ msg:String){
        let alert = UIAlertController(title: "Hang On!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
