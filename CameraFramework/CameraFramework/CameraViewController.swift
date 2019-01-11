//
//  CameraViewController.swift
//  CameraFramework
//
//  Created by Len van Zyl on 2019/01/10.
//  Copyright © 2019 Len van Zyl. All rights reserved.
//

import UIKit
import AVFoundation

public protocol CameraControllerDelegate {
    func cancelButtonTapped(controller : CameraViewController)
    func stillImageCaptured(controller: CameraViewController, image: UIImage)
}

public enum CameraPosition {
    case front
    case back
}

public final class CameraViewController: UIViewController {
    fileprivate var camera : Camera?
    var previewLayer: AVCaptureVideoPreviewLayer?
    private var _cancelButton: UIButton?
    var cancelButton: UIButton {
        if let currentbutton = _cancelButton {
            return currentbutton
        }
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        _cancelButton = button
        return button
    }
    
    private var _triggerButton: UIButton?
    var triggerButton: UIButton {
        if let currentbutton = _triggerButton {
            return currentbutton
        }
        let button = UIButton()
        button.setImage(UIImage(named: "trigger", in: Bundle(for: CameraViewController.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(triggerButtonTapped), for: .touchUpInside)
        _triggerButton = button
        return button
    }
    public var delegate: CameraControllerDelegate?
    public var position: CameraPosition = .back {
        didSet {
            guard let camera = self.camera else {
                return
            }
            camera.position = position
        }
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        let camera = Camera()
        camera.delegate = self
        self.camera = camera
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let camera = self.camera else {
            return
        }
        createUI()
        camera.update()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateUI(orientation: UIApplication.shared.statusBarOrientation)
        self.updateButtonFrame()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK : User interface creation
fileprivate extension CameraViewController {
    func createUI(){
        guard let camera = self.camera else {
            return
        }
        guard let previewLayer = camera.getPreviewLayer() else {
            return
        }
        previewLayer.frame = self.view.bounds
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(previewLayer)
        self.view.addSubview(cancelButton)
        self.view.addSubview(triggerButton)
    }
    func updateUI(orientation: UIInterfaceOrientation){
        guard let previewLayer = self.previewLayer, let connection = previewLayer.connection else {
            return
        }
        previewLayer.frame = self.view.bounds
        switch orientation {
        case .portrait:
            connection.videoOrientation = .portrait
            break
        case .landscapeLeft:
            connection.videoOrientation = .landscapeLeft
            break
        case .landscapeRight:
            connection.videoOrientation = .landscapeRight
            break
        case .portraitUpsideDown:
            connection.videoOrientation = .portraitUpsideDown
            break
        default:
            connection.videoOrientation = .portrait
            break
        }
    }
    func updateButtonFrame(){
        self.cancelButton.frame = CGRect(x: self.view.frame.minX + 10, y: self.view.frame.maxY - 50, width: 70, height: 30)
        self.triggerButton.frame = CGRect(x: self.view.frame.midX - 35, y: self.view.frame.maxY - 80, width: 70, height: 70)
    }
}
//MARK
fileprivate extension CameraViewController {
    @objc func cancelButtonTapped(){
        if let delegate = self.delegate {
            delegate.cancelButtonTapped(controller: self)
        }
    }
    @objc func triggerButtonTapped(){
        if let camera = self.camera {
            camera.captureStillImage()
        }
    }
}

extension CameraViewController: CameraDelegate {
    func stillImageCaputerd(camera: Camera, image: UIImage) {
        if let delegate = self.delegate {
            delegate.stillImageCaptured(controller: self, image: image)
        }
    }
    
    
}
