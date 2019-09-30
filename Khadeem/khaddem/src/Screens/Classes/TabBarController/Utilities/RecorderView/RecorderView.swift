//
//  RecorderView.swift
//  khaddem
//
//  Created by Gudisi, Manjunath on 24/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

class RecorderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    fileprivate lazy var cameraSession = AVCaptureSession()
    fileprivate lazy var videoDataOutput = AVCaptureVideoDataOutput()
    fileprivate lazy var audioDataOutput = AVCaptureAudioDataOutput()
    
    fileprivate lazy var faceDetector = CIDetector(ofType: CIDetectorTypeFace,
                                                   context: nil,
                                                   options: [
                                                    CIDetectorAccuracy: CIDetectorAccuracyHigh,
                                                    CIDetectorTracking: true
        ])!
    
    
    fileprivate(set) lazy var isRecording = false
    fileprivate var videoWriter: AVAssetWriter!
    fileprivate var videoWriterInput: AVAssetWriterInput!
    fileprivate var audioWriterInput: AVAssetWriterInput!
    fileprivate var sessionAtSourceTime: CMTime?
    
    
    fileprivate var videoWriterInputPixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!
    fileprivate lazy var sDeviceRgbColorSpace = CGColorSpaceCreateDeviceRGB()
    fileprivate lazy var bitmapInfo = CGBitmapInfo.byteOrder32Little
        .union(CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue))

    fileprivate func setupCamera() {
        //The size of output video will be 720x1280
        cameraSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        //Setup your camera
        //Detect which type of camera should be used via `isUsingFrontFacingCamera`
        let captureDevice: AVCaptureDevice
        if isUsingFrontFacingCamera {
            captureDevice = AVCaptureDevice.devices(for: AVMediaTypeVideo)
                .flatMap { $0 as? AVCaptureDevice }
                .find(where: { $0.position == .front }) ?? AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        } else {
            captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        }
        
        //Setup your microphone
        let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        
        do {
            cameraSession.beginConfiguration()
            
            // Add camera to your session
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if cameraSession.canAddInput(deviceInput) {
                cameraSession.addInput(deviceInput)
            }
            
            // Add microphone to your session
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if cameraSession.canAddInput(audioInput) {
                cameraSession.addInput(audioInput)
            }
            
            //Now we should define your output data
            let queue = DispatchQueue(label: "com.hilaoinc.hilao.queue.record-video.data-output")
            
            //Define your video output
            videoDataOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            ]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            if cameraSession.canAddOutput(videoDataOutput) {
                videoDataOutput.setSampleBufferDelegate(self, queue: queue)
                cameraSession.addOutput(videoDataOutput)
            }
            
            //Define your audio output
            if cameraSession.canAddOutput(audioDataOutput) {
                audioDataOutput.setSampleBufferDelegate(self, queue: queue)
                cameraSession.addOutput(audioDataOutput)
            }
            
            cameraSession.commitConfiguration()
            
            //Present the preview of video
            var previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
            previewLayer.bounds = bounds
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            layer.addSublayer(previewLayer)
            
            //Don't forget start running your session
            //this doesn't mean start record!
            cameraSession.startRunning()
        }
        catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    
}

extension RecorderView: AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureVideoDataOutputSampleBufferDelegate {
    //There is only one same method for both of these delegates
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        
        //The detect faces, overlay video will happen here, take care my man :]
        guard captureOutput != nil,
            sampleBuffer != nil,
            connection != nil,
            CMSampleBufferDataIsReady(sampleBuffer) else { return }
        
        let writable = canWrite()
        
        if writable,
            sessionAtSourceTime == nil {
            //Start writing
            sessionAtSourceTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            videoWriter.startSession(atSourceTime: sessionAtSourceTime!)
        }
        
        //Overlay means processing on the images, not audio
        if captureOutput == videoDataOutput {
            //Important: Correct your video orientation from your device orientation
            switch UIDevice.current.orientation {
            case .landscapeRight:
                connection.videoOrientation = .landscapeLeft
            case .landscapeLeft:
                connection.videoOrientation = .landscapeRight
            case .portrait:
                connection.videoOrientation = .portrait
            case .portraitUpsideDown:
                connection.videoOrientation = .portraitUpsideDown
            default:
                connection.videoOrientation = .portrait //Make `.portrait` as default (should check will `.faceUp` and `.faceDown`)
            }
            
            //Convert current frame to `CIImage`
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                            pixelBuffer,
                                                            CMAttachmentMode(kCMAttachmentMode_ShouldPropagate)) as? [String: Any]
            let ciImage = CIImage(cvImageBuffer: pixelBuffer, options: attachments)
            
            //Detects faces base on your `ciImage`
            let features = faceDetector.features(in: ciImage, options: [
                CIDetectorSmile: true,
                CIDetectorEyeBlink: true,
                ]).flatMap ({ $0 as? CIFaceFeature })
            
            //Retreive frame of your buffer
            let desc = CMSampleBufferGetFormatDescription(sampleBuffer)!
            let bufferFrame = CMVideoFormatDescriptionGetCleanAperture(desc, false)
            
            //Draw faces masks
            DispatchQueue.main.async { [weak self] in
                self?.drawFaceMasksFor(features: features, bufferFrame: bufferFrame)
            }
            
//            if videoWriterInput.isReadyForMoreMediaData {
//                //Write video buffer
//                videoWriterInput.append(sampleBuffer)
//            }
            
            if writable {
                autoreleasepool { //Make sure `CVPixelBuffer` will release after used
                    //Lock `pixelBuffer` before working on it
                    CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
                    
                    //Deep copy buffer pixel to avoid memory leak
                    var renderedOutputPixelBuffer: CVPixelBuffer? = nil
                    let options = [
                        kCVPixelBufferCGImageCompatibilityKey as String: true,
                        kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
                        ] as CFDictionary
                    let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                                     CVPixelBufferGetWidth(pixelBuffer),
                                                     CVPixelBufferGetHeight(pixelBuffer),
                                                     kCVPixelFormatType_32BGRA, options,
                                                     &renderedOutputPixelBuffer)
                    guard status == kCVReturnSuccess else { return }
                    
                    CVPixelBufferLockBaseAddress(renderedOutputPixelBuffer!,
                                                 CVPixelBufferLockFlags(rawValue: 0))
                    
                    let renderedOutputPixelBufferBaseAddress = CVPixelBufferGetBaseAddress(renderedOutputPixelBuffer!)
                    
                    memcpy(renderedOutputPixelBufferBaseAddress,
                           CVPixelBufferGetBaseAddress(pixelBuffer),
                           CVPixelBufferGetHeight(pixelBuffer) * CVPixelBufferGetBytesPerRow(pixelBuffer))
                    
                    //Lock the copy of pixel buffer when working on ti
                    CVPixelBufferLockBaseAddress(renderedOutputPixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
                    if !features.isEmpty {
                        //Create context base on copied buffer
                        let context = CGContext(data: renderedOutputPixelBufferBaseAddress,
                                                width: CVPixelBufferGetWidth(renderedOutputPixelBuffer!),
                                                height: CVPixelBufferGetHeight(renderedOutputPixelBuffer!),
                                                bitsPerComponent: 8,
                                                bytesPerRow: CVPixelBufferGetBytesPerRow(renderedOutputPixelBuffer!),
                                                space: sDeviceRgbColorSpace,
                                                bitmapInfo: bitmapInfo.rawValue)
                        
                        for feature in features {
                            //Draw mask image
                            let faceImage = UIImage("face-image")!
                            context?.draw(faceImage.cgImage!, in: feature.bounds)
                        }
                    }
                    
                    //Make sure adaptor and writer able to write
                    if videoWriterInputPixelBufferAdaptor.assetWriterInput.isReadyForMoreMediaData,
                        canWrite() {
                        //Write down to adator instead of `videoWriterInput`
                        videoWriterInputPixelBufferAdaptor.append(renderedOutputPixelBuffer!, withPresentationTime: timestamp)
                    }
                    
                    //Unlock buffers after processed on them
                    CVPixelBufferUnlockBaseAddress(renderedOutputPixelBuffer!,
                                                   CVPixelBufferLockFlags(rawValue: 0))
                    CVPixelBufferUnlockBaseAddress(pixelBuffer,
                                                   CVPixelBufferLockFlags(rawValue: 0))
                }
            }
        }  else if writable,
            captureOutput == audioDataOutput,
            audioWriterInput.isReadyForMoreMediaData {
            //Write audio buffer
            audioWriterInput.append(sampleBuffer)
        }
    }
}

extension RecorderView {
    fileprivate func drawFaceMasksFor(features: [CIFaceFeature], bufferFrame: CGRect) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        //Hide all current masks
        layer.sublayers?.filter({ $0.name == "MaskFace" }).forEach { $0.isHidden = true }
        
        //Do nothing if no face is dected
        guard !features.isEmpty else {
            CATransaction.commit()
            return
        }
        
        //The problem is we detect the faces on video image size
        //but when we show on the screen which might smaller or bigger than your video size
        //so we need to re-calculate the faces bounds to fit to your screen
        
        let xScale = frame.width / bufferFrame.width
        let yScale = frame.height / bufferFrame.height
        let transform = CGAffineTransform(rotationAngle: .pi).translatedBy(x: -bufferFrame.width,
                                                                           y: -bufferFrame.height)
        
        for feature in features {
            var faceRect = feature.bounds.applying(transform)
            faceRect = CGRect(x: faceRect.minX * xScale,
                              y: faceRect.minY * yScale,
                              width: faceRect.width * xScale,
                              height: faceRect.height * yScale)
            
            //Reuse the face's layer
            let faceLayer = layer.sublayers?
                .filter { $0.name == "MaskFace" && $0.isHidden == true }
                .first
            if faceLayer == nil {
                //Add an image as a mask to your project with name: `face-imaged
                let faceImage = UIImage(named: "face-imaged")
                faceLayer = CALayer()
                faceLayer.contents = faceImage.ciImage
                faceLayer.frame = faceRect
                faceLayer.masksToBounds = true
                faceLayer.contentsGravity = kCAGravityResizeAspectFill
                layer.addSublayer(faceLayer)
            } else {
                faceLayer?.frame = faceRect
                faceLayer?.position = faceRect.origin
                faceLayer?.isHidden = false
            }
            
            //You can add some masks for your left eye, right eye, mouth
        }
        CATransaction.commit()
    }
  
    
    fileprivate func setupWriter() {
        
        do {
            let url = AssetUtils.outputAssetURL(mediaType: .video)
            videoWriter = try AVAssetWriter(url: url, fileType: AVFileTypeMPEG4)
            
            //Add video input
            videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: [
                AVVideoCodecKey: AVVideoCodecH264,
                AVVideoWidthKey: 720,
                AVVideoHeightKey: 1280,
                AVVideoCompressionPropertiesKey: [
                    AVVideoAverageBitRateKey: 2300000,
                ],
                ])
            videoWriterInput.expectsMediaDataInRealTime = true //Make sure we are exporting data at realtime
            if videoWriter.canAdd(videoWriterInput) {
                videoWriter.add(videoWriterInput)
            }
            
            //Add audio input
            audioWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeAudio, outputSettings: [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVNumberOfChannelsKey: 1,
                AVSampleRateKey: 44100,
                AVEncoderBitRateKey: 64000,
                ])
            audioWriterInput.expectsMediaDataInRealTime = true
            if videoWriter.canAdd(audioWriterInput) {
                videoWriter.add(audioWriterInput)
            }
            
            videoWriterInputPixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                kCVPixelBufferWidthKey as String: Constant.Configuration.DefaultAssetSize.width,
                kCVPixelBufferHeightKey as String: Constant.Configuration.DefaultAssetSize.height,
                kCVPixelFormatOpenGLESCompatibility as String: true,
                ])
            
            videoWriter.startWriting() //Means ready to write down the file
        }
        catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}

extension RecorderView {
    fileprivate func canWrite() -> Bool {
        return isRecording
            && videoWriter != nil
            && videoWriter.status == .writing
    }
}

extension RecorderView {
    func start() {
        guard !isRecording else { return }
        isRecording = true
        sessionAtSourceTime = nil
        startWriting()
    }
}

extension RecorderView {
    func stop() {
        guard isRecording else { return }
        isRecording = false
        videoWriter.finishWriting { [weak self] in
            self?.sessionAtSourceTime = nil
            guard let url = self?.videoWriter.outputURL else { return }
            let asset = AVURLAsset(url: url)
            //Do whatever you want with your asset here
        }
    }
}

extension RecorderView {
    func pause() {
        isRecording = false
    }
    
    func resume() {
        isRecording = true
    }
}
