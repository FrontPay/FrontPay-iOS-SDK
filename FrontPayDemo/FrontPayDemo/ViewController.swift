//
//  ViewController.swift
//  FrontPayDemo
//
//  Created by Waseem Sarwar on 12/12/2021.
//

import UIKit
import FrontPay

class ViewController: UIViewController {

    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfCurrency: UITextField!
    @IBOutlet weak var txtResponse: UITextView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfAmount.delegate = self
        tfCurrency.delegate = self
       
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    @IBAction func proceesPayment(){
        
        let amount = Double(tfAmount.text ?? "") ?? 0.0
        let currency = tfCurrency.text ?? "PKR"
        
        //create FrontPayConfig
        let config = FrontPayConfig.with(paymentMode:PAYMENT_MODE.TEST, merchantId:"72806695", merchantSecret:"fp-client-secret-0729065549")
        
        //create payment object
        let payment = FrontPayPayment.with(amount: amount, currency: currency, transaction_reference: UUID().uuidString, fp_param1: "Smart Band", fp_param2: "FrontPay Retails", fp_param3: nil)
        
        //start paying
        let vcnt = FrontPayPaymentManager.paywith(viewController: self, config: config, payment: payment)
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
        }
        
        
    }
    @IBAction func checkPaymentResponse(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcnt = storyboard.instantiateViewController(withIdentifier: "PaymentInqueryViewController") as! PaymentInqueryViewController
        self.navigationController?.pushViewController(vcnt, animated: true)
        
    }
}

extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
