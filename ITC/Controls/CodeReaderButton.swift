//
//  CodeReaderButton.swift
//  CustomControls
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit
import AVFoundation

protocol CodeReaderButtonProtocol {
    func codeReaderCompletion(code: String)
}

enum CameraError: Error {
    case notSupported
    case authorizationDenied
    case authourizationRestricted
}

extension CameraError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
        case .notSupported:
            return "Camera not supported"
        case .authorizationDenied:
            return "Camera authorization denied. You can enable it in settings"
        case .authourizationRestricted:
            return "Authorization restricted for camera"
        }
    }
}

class CodeReaderButton: UIButton {
    
    lazy var parentViewController: UIViewController? = {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }()
    
    var btnClose: UIButton?
    
    var delegate: CodeReaderButtonProtocol?
    
    //Variables for AVSession and Video
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var codeFrameView:UIView?
    
    var supportedCodes: [AVMetadataObject.ObjectType] = [.qr, .aztec, .code128, .code39, .code93, .code39Mod43, .dataMatrix, .ean13, .ean8, .upce, .pdf417]
    
    //MARK: - UIView Lifecycle
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupActions()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupActions()
    }
    
    func setupViews() {
        
        layer.cornerRadius = 5.0
        setTitle("Scan", for: .normal)
    }
    
    //MARK: - Button Action
    
    fileprivate func setupActions() {
        
        addTarget(self, action: #selector(CodeReaderButton.scanCode), for: .touchUpInside)
    }
    
    @objc func scanCode() {
        
        if videoPreviewLayer == nil {

            let captureDevice = AVCaptureDevice.default(for: .video)

            do {
                try supportsCamera()
                let input = try AVCaptureDeviceInput(device: captureDevice!)

                captureSession = AVCaptureSession()
                captureSession?.addInput(input)

            }
            catch CameraError.notSupported {

                let alertView = Alert.createErrorAlert(title: "Not supported", message: CameraError.notSupported.errorDescription!)
                parentViewController?.present(alertView, animated: true, completion: nil)
                return
            }
            catch {
                print(error)
                return
            }

            createCaptureSession()
        }

        captureSession?.startRunning()
    }
    
    fileprivate func createCaptureSession() {
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)

        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.qr, .aztec, .code128, .code39, .code93, .code39Mod43, .dataMatrix, .ean13, .ean8, .upce]

        //Adding preview layer to superview
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = (parentViewController?.view.layer.bounds)!
        parentViewController?.view.layer.addSublayer(videoPreviewLayer!)

        let btnClose = UIButton(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        btnClose.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        btnClose.addTarget(self, action: #selector(CodeReaderButton.closeReader), for: .touchUpInside)

        self.btnClose = btnClose
        //Adding code detection area view
        codeFrameView = UIView()
        
        //Setting delegate and presenting the Scanner
        if parentViewController is CodeReaderButtonProtocol {
            delegate = parentViewController as? CodeReaderButtonProtocol
        }
        
        if let qrCodeFrameView = codeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 1.0
            parentViewController?.view.addSubview(qrCodeFrameView)
            parentViewController?.view.addSubview(self.btnClose!)
        }
    }
    
    @objc func closeReader() {
        
        captureSession?.stopRunning()
        
        codeFrameView?.removeFromSuperview()
        videoPreviewLayer?.removeFromSuperlayer()
        btnClose?.removeFromSuperview()
        codeFrameView = nil
        videoPreviewLayer = nil
    }
    
    func sendScannedCodeToParentView(_ codeValue: String) {
        
        //Callback to superview
        delegate?.codeReaderCompletion(code: codeValue)
        closeReader()
    }
    
    //MARK: - Helper Methods
    
    func supportsCamera() throws -> (){
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            throw CameraError.notSupported
        }
        if let authenticationStatus = AVCaptureDevice.authorizationStatus(for: .video) as? AVAuthorizationStatus {
            
            if authenticationStatus == .denied {
                throw CameraError.authorizationDenied
            }
            else if authenticationStatus == .restricted {
                throw CameraError.authourizationRestricted
            }
            else if authenticationStatus == .notDetermined {
                
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                })
            }
        }
    }
    
}

extension CodeReaderButton: AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: - AVMetaDataOutput Delegates
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //Checking for scanned output
        if metadataObjects.count < 1 {
            
            let alertView = Alert.createErrorAlert(title: "Invalid code", message: "Please scan again")
            parentViewController?.present(alertView, animated: true, completion: nil)
            
            captureSession?.stopRunning()
            codeFrameView?.removeFromSuperview()
            videoPreviewLayer?.removeFromSuperlayer()
            codeFrameView = nil
            videoPreviewLayer = nil
            return
        }
        
        //Output from scanned code
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            codeFrameView?.frame = barCodeObject!.bounds
            
            if let codeValue = metadataObj.stringValue {
                DispatchQueue.main.async {
                    self.sendScannedCodeToParentView(codeValue)
                }
            }
        }
    }
}
