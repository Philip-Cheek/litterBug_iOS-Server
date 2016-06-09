//
//  Camera.swift
//  litteriOS
//
//  Created by Philip Cheek on 6/7/16.
//  Copyright © 2016 Philip Cheek. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class Camera{
    
    let previewView:UIView
    
    init(previewView:UIView){
        self.previewView = previewView
    }

    
    var imageCollection = [UIImage]()
    var captureSession: AVCaptureSession?
    var previewLayer:AVCaptureVideoPreviewLayer?
    var stillImageOutput: AVCaptureStillImageOutput?
    
    func initCameraPreview(){
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                self.previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
            }
        }
    }
    
    func takePhoto(callback: (UIImage)->() ){
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    callback(image)
                    
                }
            })
        }
        
    }
    
    
    func setPreviewBounds(){
        print("thisshouldwork")
        self.previewLayer!.frame = self.previewView.bounds
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill;

    }
    
    
    
}