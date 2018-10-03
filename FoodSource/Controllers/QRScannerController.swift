//
//  QRCodeViewController.swift
//  FoodSource
//
//  Created by Dina Deng on 4/28/18.
//  Copyright © 2018 DinaStudent. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var items:[NSString] = []
    
    // displays the decoded information of the QR code
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting the back-facing camera for caputring videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else{
            print("Unable to access camera device")
            return
        }
        do{
            // Get an instance of the AVCaptureDeviceInput class using the previous device
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // set the input device on the capture session
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadaOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        }
        catch{
            // Errors and do not continue
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: topbar)
        
        // Initializing Green Box
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                createAlert(decodedString: metadataObj.stringValue!)
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
    // If QR code is detected
    func createAlert(decodedString: String){
        if presentedViewController != nil{
            return
        }
        
        // Display a pop-up alert to notify user there is an external link
        let alert = UIAlertController(title: "More Information", message:"Click confirm to go to webpage.\nClick Add to List to add information to your personal receipt: \(decodedString)\n", preferredStyle: .actionSheet)
        
        // If user clicks confirm, url page will be opened
        let confirmation = UIAlertAction(title: "Open Page", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedString){
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        // If user clicks add to list, the product's text is added to ReceiptTableVC 
        let addToList = UIAlertAction(title: "Add to List", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let itemText = decodedString
            
            self.items.append(itemText as NSString)
            UserDefaults.standard.set(self.items, forKey: "scanned")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(confirmation)
        alert.addAction(addToList)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

