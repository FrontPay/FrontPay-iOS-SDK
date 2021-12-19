
# FrontPay iOS SDK <a name="Introducation"></a>
FrontPay offers best online payment gateway and end to end payment solution for individuals, small and enterprise businesses in Pakistan. FrontPay accepts local and international payments in Pakistan.

This integration guide is for iOS developers who want to integrate FrontPay framework in their projects for payment processing.


# Table of contents
1. [Introducation](#Introducation)
2. [Requirements](#Requirements)
3. [Getting Started](#GettingStarted)
   1. [Integration](#Integration)
   2. [Pay](#Pay)
   3. [Inquiry](#Inquiry)
   4. [Get Merchant ID and Merchant Secret](#OrganizationIDandSourceID)
   5. [Test Card](#TestCard)
   6. [Test Bank Account](#BankAccount)
4. [Troubleshooting](#Troubleshooting)
   1. [Building for iOS, but the linked and embedded framework 'FrontPay.framework' was built for iOS + iOS Simulator.](#Universalframework)
   2. [Unsupported Architectures](#unsupportedarchitectures)
   3. [dyld: Library not loaded](#dyldLibrarynotloaded)
   4. [FrontPay no such module found](#nosuchmodulefound)



## Requirements <a name="Requirements"></a>
- iOS 12.0+
- Minimum Xcode 10.0

## Getting Started <a name="GettingStarted"></a>

### Integration: <a name="Integration"></a>
1. At first download sdk from https://github.com/FrontPay/FrontPay-iOS-SDK Then open the folder frameworks.

<img width="743" alt="Screenshot 2021-12-18 at 6 14 40 PM" src="https://user-images.githubusercontent.com/1830438/146642463-09575846-2cc6-4871-b0a0-8310fba96fe5.png">


2. First copy `FrontPay.xcframework` into your project directory and then Drag & Drop `FrontPay.xcramework` in your iOS app.

<img width="1388" alt="Screenshot 2021-12-18 at 6 16 48 PM" src="https://user-images.githubusercontent.com/1830438/146642498-451051cb-7ae9-4838-bf2e-8019e1a85018.png">

<img width="1278" alt="3" src="https://user-images.githubusercontent.com/1830438/145726584-998d5716-0618-4edf-9561-b037d535b994.png">

3. `FrontPay.xcframework` must set to `Embed & Sign`, Select your project `Traget -> Build Phase` expand `Embed Framework` and press `+` add `FrontPay.xcframework`

<img width="1278" alt="4" src="https://user-images.githubusercontent.com/1830438/145726588-22b0ee6e-f4be-43c4-b704-f0d898c0788e.png">


<img width="1422" alt="Screenshot 2021-12-18 at 6 18 14 PM" src="https://user-images.githubusercontent.com/1830438/146642539-30989800-b0ed-4c2f-82b2-f38968884615.png">


make sure in `Target ->General->Framework, Libraries and Embded Contents` `Embed & Sign` is selected.

<img width="1417" alt="Screenshot 2021-12-18 at 6 18 29 PM" src="https://user-images.githubusercontent.com/1830438/146642560-69ce86d6-83c6-4c55-8860-6d29be807852.png">


If you have followed the above 5 steps then you will be able to compile without any error.

### Pay: <a name="Pay"></a>

If Xcode 11.3 or above

Goto Your ViewController.swift file

``` swift
import FrontPay
    @IBAction func proceesPayment(){
        
        let amount:Double = 100.0
        let currency = "PKR"
        
        //create FrontPayConfig
        let config = FrontPayConfig.with(paymentMode:PAYMENT_MODE.TEST, merchantId:YOUR_MERCHANT_ID, merchantSecret:YOUR_MERCHANT_SECRET)
        
        //create payment object
        let payment = FrontPayPayment.with(amount: amount, currency: currency, transaction_reference: UUID().uuidString, fp_param1: "Smart Band", fp_param2: "FrontPay Retails", fp_param3: nil)
        
        //start paying
        let vcnt = FrontPayPaymentManager.paywith(viewController: self, config: config, payment: payment)
        vcnt.completionHandlerSuccess = { response in
            print("success response=",response ?? "")
        }
        vcnt.completionHandlerFailed = { response in
            print("error response=",response ?? "")
        }
        
    }
```

### Inquiry: <a name="Inquiry"></a>
To get payment details any time after payment processed, use below method.

``` swift
import FrontPay
    @IBAction func paymentInquiry(){
        
        let transaction_reference = TRANSACTION_REFERENCE
        
        //create FrontPayConfig
        let config = FrontPayConfig.with(paymentMode:PAYMENT_MODE.TEST, merchantId:YOUR_MERCHANT_ID, merchantSecret:YOUR_MERCHANT_SECRET)
        
        //start Inquiry
        let vcnt = FrontPayPaymentManager.paymentInquiry(config: config, transaction_reference: transaction_reference)
        vcnt.completionHandlerSuccess = { response in
            print("success response=",response ?? "")
        }
        vcnt.completionHandlerFailed = { response in
            print("error response=",response ?? "")
        }
        
    }
```

### Get Merchant ID and Merchant Secret <a name="OrganizationIDandSourceID"></a>
To get your merchantId please visit https://www.frontpay.pk/

### Test Card: <a name="TestCard"></a>
In Sandbox mode below card to be used for payment.
`5555 5555 5555 4444`

### Test Bank Account: <a name="BankAccount"></a>
In Sandbox mode below account to be used for payment.
Account `0002562478596921`
CNIC `4000113500111`
OPT `456980`

## Troubleshooting <a name="Troubleshooting"></a>
### Building for iOS, but the linked and embedded framework 'FrontPay.framework' was built for iOS + iOS Simulator. <a name="Universalframework"></a>
If you have used FrontPay universal framework then you may face this error. To resolve this please follow below steps.

Select your project `Target -> Build Settings` and search `Validate Workspace` Set Value to NO, if its already NO, then set to YES once and then set again to NO. This is workaround as sometimes xcode doesn't understand, so toggeling the value between YES/NO it worked.

<img width="1419" alt="7" src="https://user-images.githubusercontent.com/1830438/145729069-01e23505-2585-4692-93e4-02a7de001628.png">

### Appstore uploading issue of invalid unsupported architectures. <a name="unsupportedarchitectures"></a>

If you have added `FrontPay.framework` as `universal` then when submitting to app store Apple will show error of simulator architectures. To resolve this issue please select your project `Target -> Build Phase` and select `+` sign and add `New Run Script Phase`. It will add an empty runscript below, expand it and put the below script as shown in below screen shot.

```run script
# skip if we run in debug
if [ "$CONFIGURATION" == "Debug" ]; then
echo "Skip frameworks cleaning in debug version"
exit 0
fi

APP_PATH="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

EXTRACTED_ARCHS=()

for ARCH in $ARCHS
do
echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
done

echo "Merging extracted architectures: ${ARCHS}"
lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
rm "${EXTRACTED_ARCHS[@]}"

echo "Replacing original executable with thinned version"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
```

<img width="1421" alt="9" src="https://user-images.githubusercontent.com/1830438/145729086-20308662-f4e4-40ee-ab4f-8dc79b67d6b5.png">

### FrontPay no such module found <a name="nosuchmodulefound"></a>

Sometimes xcode behaves strange and not link properly, so first delete `FrontPay.framework` from your project, `clean build` and delete `Drived Data`
then again follow belwo steps to add framework

Open **universal** folder and first copy `FrontPay.Framework` into your project directory and then Drag & Drop `FrontPay.Framework` in your iOS app.

<img width="1278" alt="4" src="https://user-images.githubusercontent.com/1830438/145729273-465c353a-0ef6-4543-ae12-6a0d0829cac9.png">

<img width="1279" alt="5" src="https://user-images.githubusercontent.com/1830438/145729276-ee2c7e43-0793-4f67-923e-0b15fe4d08bf.png">

`FrontPay.framework` must set to `Embed & Sign`, Select your project `Traget -> Build Phase` expand `Embed Framework` and press `+` add `FrontPay.framework`


make sure in `Target ->General->Framework, Libraries and Embded Contents` `Embed & Sign` is selected.

<img width="1281" alt="6" src="https://user-images.githubusercontent.com/1830438/145729229-beb706b5-e219-40a1-9b97-c95450b0dee2.png">


