//
//  AssetRecorderView.swift
//  Snowball
//
//  Created by Le Tai on 7/20/16.
//  Copyright © 2016 Snowball. All rights reserved.
//

//https://gist.github.com/levantAJ/10a1b73b2f50eaa0443b9fa21e704687

import UIKit
import AVFoundation
import ImageIO

enum AssetRecorderViewType {
    case image
    case video
}

enum MaskType {
    case none
    case poke
    case glass
    case mosaic
    case finger
    case batman
    case vietnamese
    case cartoon
    case replace
}

protocol AssetRecorderViewDelegate: class {
    func assetRecorderView(_ view: AssetRecorderView, didExport videoAssetURL: URL, userInfo: [String: Any]?)
    func assetRecorderView(_ view: AssetRecorderView, didCapture image: UIImage)
    func assetRecorderView(_ view: AssetRecorderView, didTurnOnLight isLightOn: Bool)
    func assetRecorderView(_ view: AssetRecorderView, didChangeCamera isFrontFacingCamera: Bool)
    func assetRecorderView(_ view: AssetRecorderView, didRecord isRecording: Bool)
    func assetRecorderView(_ view: AssetRecorderView, didFail error: Error, userInfo: [String: Any]?)
}

extension AssetRecorderViewDelegate {
    func assetRecorderView(_ view: AssetRecorderView, didExport videoAssetURL: URL, userInfo: [String: Any]?) {}
    func assetRecorderView(_ view: AssetRecorderView, didCapture image: UIImage) {}
    func assetRecorderView(_ view: AssetRecorderView, didTurnOnLight isLightOn: Bool) {}
    func assetRecorderView(_ view: AssetRecorderView, didChangeCamera isFrontFacingCamera: Bool) {}
    func assetRecorderView(_ view: AssetRecorderView, didRecord isRecording: Bool) {}
    func assetRecorderView(_ view: AssetRecorderView, didFail error: Error, userInfo: [String: Any]?) {}
}

final class AssetRecorderView: UIView {
    static let shared = AssetRecorderView()
    
    var type: AssetRecorderViewType = .video
    var maskType: MaskType = .none {
        didSet {
            guard isRecording else { return }
            recordingMasks.append(maskType)
        }
    }
    var lightOn: Bool = false {
        didSet {
            changeLight()
            delegate?.assetRecorderView(self, didTurnOnLight: lightOn)
        }
    }
    var isUsingFrontFacingCamera = true {
        didSet {
            captureSession.beginConfiguration()
            addDeviceInputs()
            captureSession.commitConfiguration()
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
            delegate?.assetRecorderView(self, didChangeCamera: isUsingFrontFacingCamera)
        }
    }
    
    weak var delegate: AssetRecorderViewDelegate?
    
    fileprivate(set) lazy var isExporting = false
    
    fileprivate let captureSession = AVCaptureSession()
    fileprivate var videoDevice: AVCaptureDevice!
    fileprivate var videoInput: AVCaptureDeviceInput!
    fileprivate lazy var videoDataOutput = AVCaptureVideoDataOutput()
    fileprivate lazy var audioDataOutput = AVCaptureAudioDataOutput()
    fileprivate lazy var stillImageOutput = AVCapturePhotoOutput()
    
    fileprivate var recorderWriter = AssetRecorderWriter()
    fileprivate let maskGenerator = AssetRecorderMaskGenerator()
    
    fileprivate let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
    fileprivate let videoProcessingQueue = DispatchQueue(label: "com.hilaoinc.hilao.queue.asset-recorder.video-output-processing", qos: .userInitiated)
    
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    
    fileprivate lazy var recordingMasks: [MaskType] = []
    
    required init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        relayout()
    }
}

// MARK: - Getters & Setters

extension AssetRecorderView {
    var isPausing: Bool {
        return recorderWriter.isPausing
    }
    
    var isRecording: Bool {
        return recorderWriter.isRecording
    }
    
    func run() {
        guard !captureSession.isRunning else { return }
        DispatchQueue(label: "com.hilaoinc.hilao.queue.asset-recorder-view.run").async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func relayout() {
        previewLayer?.setAffineTransform(.identity)
        previewLayer?.frame = bounds
    }
    
    func prepare() {
        guard videoDevice == nil else { return }
        setupRecorder()
    }
    
    func start() {
        //-recordingMasks.replace(maskType)
        recorderWriter = AssetRecorderWriter()
        recorderWriter.delegate = self
        recorderWriter.start()
    }
    
    func pause() {
        recorderWriter.pause()
    }
    
    func resume() {
        //-recordingMasks.replace(maskType)
        recorderWriter.resume()
    }
    
    func stop(_ completion: @escaping (DataResponse<URL>) -> Void) {
        log(masks: recordingMasks)
        recordingMasks.removeAll()
        recorderWriter.stop(completion)
    }
    
    func export(userInfo: [String: Any]? = nil, readyToRecord: (() -> Void)? = nil) {
        guard !isExporting else { return }
        isExporting = true
        DispatchQueue(label: "com.hilao.hilao.queue.asset-recorder-view.export").async { [unowned self] in
            self.stop { [unowned self] response in
                switch response {
                case .failure(let error):
                    self.isExporting = false
                    TrackingManager.log(event: .recordAssetUnknownError)
                    self.throw(error: error, userInfo: userInfo)
                case .success(let outputURL):
                    let asset = AVURLAsset(url: outputURL)
                    debugPrint("Record asset", asset.duration.seconds)
                    var timeRange: CMTimeRange? = nil
                    let shakeDetectingTime = Constant.ShakingManager.ShakeDetectingTime
                    if let isShaked = userInfo?[Constant.AssetRecorderView.IsShakedKey] as? Bool,
                        isShaked == true {
                        if asset.duration.seconds > shakeDetectingTime {
                            timeRange = CMTimeRange(start: kCMTimeZero, duration: CMTime(seconds: asset.duration.seconds - shakeDetectingTime))
                        } else {
                            self.isExporting = false
                            self.throwAssetTooShortError(userInfo: userInfo)
                            return
                        }
                    }
                    if let duration = timeRange?.duration.seconds {
                        if let minimumDuration = userInfo?[Constant.AssetRecorderView.MinimumDurationKey] as? Int,
                            duration < Double(minimumDuration) {
                            self.isExporting = false
                            self.throwAssetTooShortError(userInfo: userInfo)
                            return
                        }
                        if let maximumDuration = userInfo?[Constant.AssetRecorderView.MaximumDurationKey] as? Int,
                            duration > Double(maximumDuration) {
                            timeRange = CMTimeRange(start: timeRange!.start, duration: CMTime(seconds: Double(maximumDuration)))
                            TrackingManager.log(event: .submitToLongReactionVideo)
                        }
                    }
                    AssetUtils.export(asset: asset, timeRange: timeRange, completion: { [unowned self] response in
                        DispatchQueue.main.async { [unowned self] in
                            self.isExporting = false
                            switch response {
                            case .failure(let error):
                                self.throw(error: error, userInfo: userInfo)
                            case .success(let url):
                                self.delegate?.assetRecorderView(self, didExport: url, userInfo: userInfo)
                            }
                        }
                    })
                }
                
                DispatchQueue.main.async { unowned in
                    readyToRecord?()
                }
            }
        }
    }
    
    func caturePhoto() {
        guard !isExporting,
            let videoConnection = stillImageOutput.connection(with: .video) else { return }
        isExporting = true
        stillImageOutput.capturePhoto(with: <#T##AVCapturePhotoSettings#>, delegate: <#T##AVCapturePhotoCaptureDelegate#>)
        stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { [weak self] (sampleBuffer, error) in
            guard let `self` = self else { return }
            if let sampleBuffer = sampleBuffer,
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer),
                let image = UIImage(data: data) {
                let maxResolution = max(image.width, image.height)
                let image = image.rotateCameraImageToProperOrientation(maxResolution: maxResolution)
                self.delegate?.assetRecorderView(self, didCapture: image)
            }
            else if let error = error {
                self.delegate?.assetRecorderView(self, didFail: error, userInfo: nil)
            }
            else {
                self.delegate?.assetRecorderView(self, didFail: CMError.unspecified.error, userInfo: nil)
            }
            self.isExporting = false
        }
    }
    
    func reset() {
        DispatchQueue(label: "com.hilaoinc.hilao.queue.asset-recorder-view.reset").async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}

// MARK: - Privates

extension AssetRecorderView {
    fileprivate func commonInit() {
        recorderWriter.delegate = self
        setupRecorder()
    }
    
    fileprivate func setupRecorder() {
        captureSession.beginConfiguration()
        
        captureSession.sessionPreset = AVCaptureDevice.videoDevice(isUsingFrontFacingCamera: isUsingFrontFacingCamera).supportsAVCaptureSessionPreset(AVCaptureSessionPreset1280x720) ? AVCaptureSessionPreset1280x720 : AVCaptureSessionPreset640x480
        
        addDeviceInputs()
        
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(videoDataOutput) {
            let videoOutputQueue = DispatchQueue(label: "com.hilaoinc.hilao.queue.record-video.video-output")
            videoDataOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
            captureSession.addOutput(videoDataOutput)
        }
        
        if captureSession.canAddOutput(audioDataOutput) {
            let audioOutputQueue = DispatchQueue(label: "com.hilaoinc.hilao.queue.record-video.audio-output")
            audioDataOutput.setSampleBufferDelegate(self, queue: audioOutputQueue)
            captureSession.addOutput(audioDataOutput)
        }
        
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG,]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.bounds = bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer.addSublayer(previewLayer)
        
        DispatchQueue.main.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    fileprivate func changeLight() {
        do {
            try videoDevice?.lockForConfiguration()
            switch type {
            case .image:
                if videoDevice.hasFlash {
                    videoDevice.flashMode = lightOn ? .on : .off
                } else if videoDevice.hasTorch {
                    videoDevice.torchMode = lightOn ? .on : .off
                    if lightOn {
                        try videoDevice.setTorchModeOnWithLevel(1.0)
                    }
                }
            case .video:
                if videoDevice.hasTorch {
                    videoDevice.torchMode = lightOn ? .on : .off
                    if lightOn {
                        try videoDevice.setTorchModeOnWithLevel(1.0)
                    }
                } else if videoDevice.hasFlash {
                    videoDevice.flashMode = lightOn ? .on : .off
                }
            }
            videoDevice.unlockForConfiguration()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    fileprivate func addDeviceInputs() {
        do {
            captureSession.inputs.flatMap { $0 as? AVCaptureDeviceInput }.forEach { self.captureSession.removeInput($0) }
            
            let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
            
            videoDevice = AVCaptureDevice.videoDevice(isUsingFrontFacingCamera: isUsingFrontFacingCamera)
            videoDevice.configureCameraForHighestFrameRate()
            videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        }
        catch let error {
            debugPrint("Cannot add camera input: ", error.localizedDescription)
        }
    }
    
    fileprivate func log(masks: [MaskType]?) {
        guard let masks = masks else { return }
        for mask in masks {
            TrackingManager.log(mask: mask, tapping: false)
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate

extension AssetRecorderView: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard captureOutput != nil,
            sampleBuffer != nil,
            connection != nil else { return }
        if captureOutput == videoDataOutput {
            connection.videoOrientation = AVCaptureVideoOrientation(orientation: UIDevice.current.orientation) ?? .portrait
            var features: [CIFaceFeature] = []
            if maskType == .none {
                features = []
            } else {
                let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
                let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, pixelBuffer, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate)) as? [String: Any]
                let ciImage = CIImage(cvImageBuffer: pixelBuffer, options: attachments)
                
                let fs = faceDetector.features(in: ciImage, options: [
                    CIDetectorSmile: true,
                    CIDetectorEyeBlink: true,
                    ])
                features = fs.flatMap { $0 as? CIFaceFeature }
            }
            
            videoProcessingQueue.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.recorderWriter.handle(video: sampleBuffer, features: features, maskType: strongSelf.maskType)
            }
            
            let desc = CMSampleBufferGetFormatDescription(sampleBuffer)!
            let bufferFrame = CMVideoFormatDescriptionGetCleanAperture(desc, false)
            maskGenerator.drawFaceMasksFor(features: features, bufferFrame: bufferFrame, maskType: maskType, layer: layer, frame: frame)
            debugPrint("video...")
        } else if captureOutput == audioDataOutput {
            recorderWriter.handle(audio: sampleBuffer)
            debugPrint("audio...")
        }
    }
}

// MARK: - AssetRecorderWriterDelegate

extension AssetRecorderView: AssetRecorderWriterDelegate {
    func assetRecorderWriter(_ writer: AssetRecorderWriter, didRecord: Bool) {
        delegate?.assetRecorderView(self, didRecord: didRecord)
    }
}

// MARK: - Privates

extension AssetRecorderView {
    fileprivate func throwAssetTooShortError(userInfo: [String: Any]?) {
        TrackingManager.log(event: .submitToShortReactionVideo)
        var userInfo: [String: Any]? = userInfo
        userInfo?[NSLocalizedDescriptionKey] = Constant.LocalizedString.CannotExportYourVideoBecauseItsTooShort
        let error = NSError(domain: "com.hilao.hilao.error", code: Constant.AssetRecorderView.AssetTooShortErrorCode, userInfo: userInfo)
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.assetRecorderView(self, didFail: error, userInfo: userInfo)
        }
    }
    
    fileprivate func `throw`(error: Error, userInfo: [String: Any]?) {
        let error = NSError(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: userInfo)
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.assetRecorderView(self, didFail: error, userInfo: userInfo)
        }
    }
}

extension Constant {
    struct AssetRecorderView {
        static let IsShakedKey = "IsShaked"
        static let PromptKey = "Prompt"
        static let MaskKey = "Mask"
        static let MinimumDurationKey = "MinimumDuration"
        static let MaximumDurationKey = "MaximumDuration"
        static let AssetTooShortErrorCode = 99887766
    }
}

extension Error {
    var isTooShortAsset: Bool {
        return (self as NSError).code == Constant.AssetRecorderView.AssetTooShortErrorCode
    }
}

//
//  AssetRecorderWriter.swift
//  Hilao
//
//  Created by Le Tai on 4/14/17.
//  Copyright © 2017 Hilao. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

protocol AssetRecorderWriterDelegate: class {
    func assetRecorderWriter(_ writer: AssetRecorderWriter, didRecord: Bool)
}

final class AssetRecorderWriter: NSObject {
    weak var delegate: AssetRecorderWriterDelegate?
    
    fileprivate(set) lazy var isPausing = false
    fileprivate(set) var isRecording = false {
        didSet {
            delegate?.assetRecorderWriter(self, didRecord: isRecording)
        }
    }
    
    fileprivate var videoWriter: AVAssetWriter!
    fileprivate var videoWriterInput: AVAssetWriterInput!
    fileprivate var videoWriterInputPixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!
    fileprivate var audioWriterInput: AVAssetWriterInput!
    fileprivate var currentTime: CMTime!
    fileprivate var stopTime: CMTime!
    fileprivate lazy var sDeviceRgbColorSpace = CGColorSpaceCreateDeviceRGB()
    fileprivate lazy var bitmapInfo = CGBitmapInfo.byteOrder32Little.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue))
    
    fileprivate let writingQueue = DispatchQueue(label: "com.hilaoinc.hilao.queue.recorder.start-writing")
    fileprivate var completion: ((Responce<URL>) -> Void)!
}

// MARK: - Getters & Setters

extension AssetRecorderWriter {
    var outputURL: URL {
        return videoWriter.outputURL
    }
    
    func start() {
        guard !isRecording else { return }
        AssetUtils.recordInSilentMode()
        setupWriter()
        isRecording = true
        isPausing = false
        currentTime = nil
        stopTime = nil
    }
    
    func pause() {
        isRecording = false
        isPausing = true
    }
    
    func resume() {
        isRecording = true
        isPausing = false
    }
    
    func stop(_ completion: @escaping (DataResponse<URL>) -> Void) {
        guard stopTime == nil && (isRecording || (!isRecording && isPausing)) else { return }
        stopTime = currentTime
        self.completion = completion
    }
    
    func handle(audio sampleBuffer: CMSampleBuffer) {
        guard canWriting() else { return }
        defer {
            set(currentTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        }
        if audioWriterInput.isReadyForMoreMediaData,
            videoWriter.status == .writing {
            audioWriterInput.append(sampleBuffer)
        }
    }
    
    func handle(video sampleBuffer: CMSampleBuffer, features: [CIFaceFeature], maskType: MaskType) {
        startWritingIfNeeded(sampleBuffer: sampleBuffer)
        stop(at: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        guard canWriting() else { return }
        defer {
            set(currentTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        }
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        if !features.isEmpty {
            let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer), width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: self.sDeviceRgbColorSpace, bitmapInfo: self.bitmapInfo.rawValue)!
            
            var leftEyePosition: CGPoint!
            var rightEyePosition: CGPoint!
            var mouthPosition: CGPoint!
            var eyesY: CGFloat!
            
            for feature in features {
                if feature.hasLeftEyePosition {
                    leftEyePosition = feature.leftEyePosition
                    eyesY = leftEyePosition.y
                }
                if feature.hasRightEyePosition {
                    rightEyePosition = feature.rightEyePosition
                    eyesY = eyesY == nil ? rightEyePosition.y : (eyesY + rightEyePosition.y)/2
                }
                
                if feature.hasMouthPosition {
                    mouthPosition = feature.mouthPosition
                }
                
                if eyesY != nil,
                    let metadata = AssetRecorderMaskGenerator.faceMetadata(maskType: maskType, faceRect: feature.bounds, eyesY: eyesY, fromBottomLeft: true) {
                    context.draw(metadata.image.cgImage!, in: metadata.faceRect)
                }
                
                if leftEyePosition != nil,
                    let metadata = AssetRecorderMaskGenerator.eyeMetadata(maskType: maskType, eyePosition: feature.leftEyePosition, faceRect: feature.bounds) {
                    context.draw(metadata.image.cgImage!, in: metadata.eyeRect)
                }
                
                if rightEyePosition != nil,
                    let metadata = AssetRecorderMaskGenerator.eyeMetadata(maskType: maskType, eyePosition: feature.rightEyePosition, faceRect: feature.bounds) {
                    context.draw(metadata.image.cgImage!, in: metadata.eyeRect)
                }
                
                if mouthPosition != nil,
                    let metadata = AssetRecorderMaskGenerator.mouthMetadata(maskType: maskType, mouthPosition: feature.mouthPosition, faceRect: feature.bounds) {
                    context.draw(metadata.image.cgImage!, in: metadata.mouthRect)
                }
            }
        }
        
        if videoWriterInput.isReadyForMoreMediaData,
            videoWriter.status == .writing {
            videoWriterInputPixelBufferAdaptor.append(pixelBuffer, withPresentationTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        }
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    }
}

// MARK: - Privates

extension AssetRecorderWriter {
    fileprivate func setupWriter() {
        do {
            let url = AssetUtils.tempOutputAssetURL(mediaType: .video)
            _ = FileManager.deleteFile(pathURL: url)
            videoWriter = try AVAssetWriter(url: url, fileType: AVFileTypeMPEG4)
            
            videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: [
                AVVideoCodecKey: AVVideoCodecH264,
                AVVideoWidthKey: Constant.Configuration.DefaultAssetSize.width,
                AVVideoHeightKey: Constant.Configuration.DefaultAssetSize.height,
                AVVideoCompressionPropertiesKey: [
                    AVVideoAverageBitRateKey: 6000000,
                    AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
                    AVVideoExpectedSourceFrameRateKey: 60,
                    AVVideoAverageNonDroppableFrameRateKey: 30,
                ],
                ])
            
            videoWriterInputPixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                kCVPixelBufferWidthKey as String: Constant.Configuration.DefaultAssetSize.width,
                kCVPixelBufferHeightKey as String: Constant.Configuration.DefaultAssetSize.height,
                kCVPixelFormatOpenGLESCompatibility as String: true,
                ])
            
            videoWriterInput.expectsMediaDataInRealTime = true
            if videoWriter.canAdd(videoWriterInput) {
                videoWriter.add(videoWriterInput)
            }
            
            
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
            
            videoWriter.startWriting()
        }
        catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    fileprivate func canWriting() -> Bool {
        return isRecording && videoWriter != nil && currentTime != nil
    }
    
    fileprivate func startWritingIfNeeded(sampleBuffer: CMSampleBuffer) {
        writingQueue.sync { [weak self] in
            guard let strongSelf = self,
                strongSelf.isRecording,
                strongSelf.videoWriter != nil,
                strongSelf.currentTime == nil,
                strongSelf.stopTime == nil else { return }
            let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            self?.videoWriter.startSession(atSourceTime: time)
            self?.currentTime = time
        }
    }
    
    fileprivate func set(currentTime: CMTime) {
        if self.currentTime == nil {
            self.currentTime = currentTime
        } else {
            self.currentTime = max(self.currentTime, currentTime)
        }
    }
    
    fileprivate func stop(at time: CMTime) {
        writingQueue.sync { [weak self] in
            guard let strongSelf = self,
                strongSelf.videoWriter != nil,
                strongSelf.stopTime != nil,
                strongSelf.stopTime <= time,
                (strongSelf.isRecording || (!strongSelf.isRecording && strongSelf.isPausing)),
                strongSelf.videoWriter.status == .writing else { return }
            strongSelf.audioWriterInput.markAsFinished()
            strongSelf.videoWriterInput.markAsFinished()
            strongSelf.currentTime = nil
            strongSelf.isPausing = false
            strongSelf.isRecording = false
            strongSelf.stopTime = nil
            strongSelf.videoWriter.finishWriting { [weak self] in
                if let error = self?.videoWriter?.error {
                    self?.completion?(.failure(error))
                } else if let url = self?.videoWriter?.outputURL {
                    self?.completion?(.success(url))
                }
            }
        }
    }
}

//
//  AssetRecorderMaskGenerator.swift
//  Hilao
//
//  Created by Le Tai on 4/14/17.
//  Copyright © 2017 Hilao. All rights reserved.
//

import UIKit

final class AssetRecorderMaskGenerator {}

// MARK: - Getters & Setters

extension AssetRecorderMaskGenerator {
    func drawFaceMasksFor(features: [CIFaceFeature], bufferFrame: CGRect, maskType: MaskType, layer: CALayer, frame: CGRect) {
        DispatchQueue.main.async { [weak self] in
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            layer.sublayers?.filter({ $0.name?.hasPrefix(Constant.AssetRecorderMaskGenerator.MaskLayer) == true }).forEach { $0.isHidden = true }
            
            guard !features.isEmpty,
                maskType != .none else {
                    CATransaction.commit()
                    return
            }
            
            let xScale = frame.width / bufferFrame.width
            let yScale = frame.height / bufferFrame.height
            let transform = CGAffineTransform(rotationAngle: .pi).translatedBy(x: -bufferFrame.width, y: -bufferFrame.height)
            
            for feature in features {
                var faceRect = feature.bounds.applying(transform)
                faceRect = CGRect(x: faceRect.minX * xScale, y: faceRect.minY * yScale, width: faceRect.width * xScale, height: faceRect.height * yScale)
                
                var leftEyePosition: CGPoint!
                var rightEyePosition: CGPoint!
                var mouthPosition: CGPoint!
                var eyesY: CGFloat!
                
                if feature.hasLeftEyePosition {
                    leftEyePosition = feature.leftEyePosition.applying(transform)
                    leftEyePosition = CGPoint(x: leftEyePosition.x * xScale, y: leftEyePosition.y * yScale)
                    eyesY = leftEyePosition.y
                }
                
                if feature.hasRightEyePosition {
                    rightEyePosition = feature.rightEyePosition.applying(transform)
                    rightEyePosition = CGPoint(x: rightEyePosition.x * xScale, y: rightEyePosition.y * yScale)
                    eyesY = eyesY == nil ? rightEyePosition.y : (eyesY + rightEyePosition.y)/2
                }
                
                if feature.hasMouthPosition {
                    mouthPosition = feature.mouthPosition.applying(transform)
                    mouthPosition = CGPoint(x: mouthPosition.x * xScale, y: mouthPosition.y * yScale)
                }
                
                if eyesY != nil {
                    self?.addFaceInto(layer: layer, in: faceRect, maskType: maskType, eyesY: eyesY)
                }
                
                if leftEyePosition != nil {
                    self?.addEyeInto(layer: layer, at: leftEyePosition, faceRect: faceRect, maskType: maskType)
                }
                
                if rightEyePosition != nil {
                    self?.addEyeInto(layer: layer, at: rightEyePosition, faceRect: faceRect, maskType: maskType)
                }
                
                if mouthPosition != nil {
                    self?.addMouthInto(layer: layer, at: mouthPosition, faceRect: faceRect, maskType: maskType)
                }
            }
            CATransaction.commit()
        }
    }
    
    class func eyeMetadata(maskType: MaskType, eyePosition: CGPoint, faceRect: CGRect) -> (image: UIImage, eyeRect: CGRect)? {
        var ratioToWidth: CGFloat!
        var image: UIImage!
        switch maskType {
        case .cartoon:
            image = .maskCartoonEye
            ratioToWidth = 1.0/3.0
        case .batman, .none, .vietnamese, .mosaic, .glass, .poke, .finger:
            return nil
        }
        guard image != nil,
            ratioToWidth != nil else { return nil }
        let width = ratioToWidth * faceRect.width
        let height = image.height * width / image.width
        let size = CGSize(width: width, height: height)
        let position = CGPoint(x: eyePosition.x - width/2, y: eyePosition.y - height/2)
        return (image, CGRect(origin: position, size: size))
    }
    
    class func mouthMetadata(maskType: MaskType, mouthPosition: CGPoint, faceRect: CGRect) -> (image: UIImage, mouthRect: CGRect)? {
        var image: UIImage!
        var ratioToWidth: CGFloat!
        switch maskType {
        case .cartoon:
            image = .maskCartoonMouth
            ratioToWidth = 1.0/2.5
        case .batman, .none, .vietnamese, .mosaic, .poke, .glass, .finger:
            return nil
        }
        guard image != nil,
            ratioToWidth != nil else { return nil }
        let width = ratioToWidth * faceRect.width
        let height = image.height * width / image.width
        let size = CGSize(width: width, height: height)
        let position = CGPoint(x: mouthPosition.x - width/2, y: mouthPosition.y - height/2)
        return (image, CGRect(origin: position, size: size))
    }
    
    class func faceMetadata(maskType: MaskType, faceRect: CGRect, eyesY: CGFloat, fromBottomLeft: Bool) -> (image: UIImage, faceRect: CGRect)? {
        var image: UIImage!
        var ratioToWidth: CGFloat!
        
        var ratioX: CGFloat!
        var ratioY: CGFloat!
        
        var eyesRatioY: CGFloat!
        
        switch maskType {
        case .poke:
            image = .maskPokeFace
            ratioToWidth = 1.0
            ratioX = 0
            ratioY = -0.1
        case .glass:
            image = .maskGlassFace
            ratioToWidth = 1.0
            ratioX = 0
            ratioY = -0.1
        case .finger:
            image = .maskFingerFace
            ratioToWidth = 1.0
            ratioX = -0.05
            ratioY = -0.2
        case .mosaic:
            image = .maskMosaicFace
            ratioToWidth = 1.0
            ratioX = 0
            ratioY = -0.13
        case .batman:
            image = .maskBatmanFace
            ratioX = -0.01
            ratioToWidth = 1.0
            eyesRatioY = -0.7
        case .vietnamese:
            image = .maskVietnameseFace
            ratioX = 0.03
            ratioToWidth = 2
            eyesRatioY = -0.334
        case .none, .cartoon:
            return nil
        }
        
        guard image != nil,
            ratioToWidth != nil,
            ratioX != nil else { return nil }
        var rect = update(width: faceRect.width * ratioToWidth, for: faceRect)
        rect = update(height: image.height * rect.width / image.width, for: rect)
        rect.origin.x = rect.origin.x + rect.width * ratioX
        
        if ratioY != nil {
            rect.origin.y = rect.origin.y + (rect.height * (fromBottomLeft ? -ratioY : ratioY))
            return (image, rect)
        }
        
        if eyesRatioY != nil {
            rect.origin.y = eyesY + (rect.height * (fromBottomLeft ? (-1-eyesRatioY) : eyesRatioY))
            return (image, rect)
        }
        
        return nil
    }
}

// MARK: - Privates

extension AssetRecorderMaskGenerator {
    fileprivate func addFaceInto(layer: CALayer, in faceRect: CGRect, maskType: MaskType, eyesY: CGFloat) {
        guard let metadata = AssetRecorderMaskGenerator.faceMetadata(maskType: maskType, faceRect: faceRect, eyesY: eyesY, fromBottomLeft: false),
            let layerName = faceLayerName(maskType: maskType) else { return }
        let faceLayer = layer.sublayers?.find { $0.name == layerName && $0.isHidden == true }
        if faceLayer == nil {
            let maskFaceLayer = CALayer(image: metadata.image, frame: metadata.faceRect, isBlurred: false)
            maskFaceLayer.name = layerName
            maskFaceLayer.contentsGravity = kCAGravityResizeAspect
            layer.addSublayer(maskFaceLayer)
        } else {
            faceLayer?.frame = metadata.faceRect
            faceLayer?.contents = metadata.image.cgImage
            faceLayer?.isHidden = false
        }
    }
    
    private func faceLayerName(maskType: MaskType) -> String? {
        let name: String?
        switch maskType {
        case .poke:
            name = Constant.AssetRecorderMaskGenerator.MaskPokeFaceLayer
        case .glass:
            name = Constant.AssetRecorderMaskGenerator.MaskGlassFaceLayer
        case .mosaic:
            name = Constant.AssetRecorderMaskGenerator.MaskMosaicFaceLayer
        case .finger:
            name = Constant.AssetRecorderMaskGenerator.MaskFingerFaceLayer
        case .batman:
            name = Constant.AssetRecorderMaskGenerator.MaskBatmanFaceLayer
        case .vietnamese:
            name = Constant.AssetRecorderMaskGenerator.MaskVietnameseFaceLayer
        case .none, .cartoon:
            name = nil
        }
        return name
    }
    
    fileprivate func addEyeInto(layer: CALayer, at position: CGPoint, faceRect: CGRect, maskType: MaskType) {
        guard let metadata = AssetRecorderMaskGenerator.eyeMetadata(maskType: maskType, eyePosition: position, faceRect: faceRect),
            let layerName = eyeLayerName(maskType: maskType) else { return }
        
        let eyeLayer = layer.sublayers?.find { $0.name == layerName && $0.isHidden == true }
        if eyeLayer == nil {
            let maskEyeLayer = CALayer(image: metadata.image, size: metadata.eyeRect.size, isBlurred: false)
            maskEyeLayer.name = layerName
            layer.addSublayer(maskEyeLayer)
        } else {
            eyeLayer?.frame = metadata.eyeRect
            eyeLayer?.isHidden = false
        }
    }
    
    private func eyeLayerName(maskType: MaskType) -> String? {
        let name: String?
        switch maskType {
        case .cartoon:
            name = Constant.AssetRecorderMaskGenerator.MaskCartoonEyeLayer
        case .poke, .finger, .batman, .none, .vietnamese, .mosaic, .glass:
            name = nil
        }
        return name
    }
    
    fileprivate func addMouthInto(layer: CALayer, at position: CGPoint, faceRect: CGRect, maskType: MaskType) {
        guard let metadata = AssetRecorderMaskGenerator.mouthMetadata(maskType: maskType, mouthPosition: position, faceRect: faceRect),
            let layerName = mouthLayerName(maskType: maskType) else { return }
        
        let mouthLayer = layer.sublayers?.find { $0.name == layerName && $0.isHidden == true }
        if mouthLayer == nil {
            let maskCartoonMouthLayer = CALayer(image: metadata.image, size: metadata.mouthRect.size, isBlurred: false)
            maskCartoonMouthLayer.name = layerName
            layer.addSublayer(maskCartoonMouthLayer)
        } else {
            mouthLayer?.frame = metadata.mouthRect
            mouthLayer?.isHidden = false
        }
    }
    
    private func mouthLayerName(maskType: MaskType) -> String? {
        let name: String?
        switch maskType {
        case .cartoon:
            name = Constant.AssetRecorderMaskGenerator.MaskCartoonMouthLayer
        case .poke, .glass, .finger, .batman, .none, .vietnamese, .mosaic:
            name = nil
        }
        
        return name
    }
    
    fileprivate class func update(height: CGFloat? = nil, width: CGFloat? = nil, for rect: CGRect) -> CGRect {
        var rect = rect
        if let height = height {
            rect.origin.y = rect.origin.y - (height - rect.size.height)/2
            rect.size.height = height
        }
        if let width = width {
            rect.origin.x = rect.origin.x - (width - rect.size.width)/2
            rect.size.width = width
        }
        return rect
    }
}

extension Constant {
    struct AssetRecorderMaskGenerator {
        static let MaskLayer = "Mask"
        
        static let MaskCartoonEyeLayer = "MaskCartoonEyeLayer"
        static let MaskCartoonMouthLayer = "MaskCartoonMouthLayer"
        static let MaskCartoonFaceLayer = "MaskCartoonFaceLayer"
        
        static let MaskPokeFaceLayer = "MaskPokeFaceLayer"
        
        static let MaskFingerFaceLayer = "MaskFingerFaceLayer"
        
        static let MaskGlassFaceLayer = "MaskGlassFaceLayer"
        
        static let MaskBatmanFaceLayer = "MaskBatmanFaceLayer"
        
        static let MaskVietnameseFaceLayer = "MaskVietnameseFaceLayer"
        
        static let MaskMosaicFaceLayer = "MaskMosaicFaceLayer"
    }
}
