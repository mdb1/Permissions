//
//  CameraViewController.swift
//  PermissionsExampleApp
//
//  Created by Manu on 14/07/2022.
//

import AVFoundation
import Combine
import Permissions
import UIKit

enum ScannerState {
    case nonInitialized
    case scanning
    case finished
}

final class CameraViewController: UIViewController {
    private lazy var cameraManager = CameraPermissionsManager()
    private lazy var captureSession = AVCaptureSession()
    private lazy var cameraView: UIView = .init()
    private lazy var missingCameraView: InformationView = .init()
    private lazy var missingPermissionsView: InformationView = .init()

    private var videoLayer: AVCaptureVideoPreviewLayer?
    private var subscribers: Set<AnyCancellable> = []
    private lazy var state: ScannerState = .nonInitialized

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addCameraPermissionObserver()
        cameraManager.requestPermissionIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer?.frame = cameraView.bounds
    }
}

// MARK: - View Layout

extension CameraViewController {
    func setUpView() {
        view.backgroundColor = Constants.backgroundColor
        title = Constants.title

        setUpMissingCameraView()
        setUpMissingPermissionsView()
        setUpCameraView()
    }
}

private extension CameraViewController {
    enum Constants {
        static let backgroundColor = UIColor.systemBackground
        static let title = "Camera"
    }

    func setUpCameraView() {
        view.addSubview(cameraView)
        cameraView.pinEdges(.notTop)
        cameraView.pin(.top, to: .topMargin, of: view)
    }

    func setUpMissingCameraView() {
        view.addSubview(missingCameraView)
        missingCameraView.pinEdges()
        missingCameraView.buttonAction = .init(handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        })
        missingCameraView.render(
            .init(
                image: UIImage(systemName: "video.slash"),
                title: "Error",
                description: "No camera detected in the device",
                buttonText: "Go back"
            )
        )
        missingCameraView.isHidden = true
    }

    func setUpMissingPermissionsView() {
        view.addSubview(missingPermissionsView)
        missingPermissionsView.pinEdges()
        missingPermissionsView.buttonAction = .init(handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        missingPermissionsView.render(
            .init(
                image: UIImage(systemName: "camera.on.rectangle"),
                title: "Missing Permissions",
                description: "Please, provide camera permissions in Settings",
                buttonText: "Open Settings"
            )
        )
        missingPermissionsView.isHidden = true
    }

    func addCameraPermissionObserver() {
        cameraManager.$permissionGranted
            .sink { [weak self] permissionGranted in
                guard let self = self else { return }
                guard let permissionGranted = permissionGranted else { return }

                if permissionGranted {
                    self.startCamera()
                } else {
                    self.displayMissingPermissions()
                }
            }.store(in: &subscribers)
    }

    func startCamera() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: .back
        )

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            displayMissingCameraView()
            return
        }

        do {
            if captureSession.inputs.isEmpty {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
            }

            if captureSession.outputs.isEmpty {
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [.upce, .ean8, .ean13, .pdf417]
            }

            if videoLayer == nil {
                let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoLayer.frame = cameraView.bounds

                cameraView.layer.addSublayer(videoLayer)

                self.videoLayer = videoLayer
            }

            if !captureSession.isRunning {
                captureSession.startRunning()
                state = .scanning
            }

            displayCameraView()

        } catch {
            displayMissingCameraView()
            return
        }
    }

    func displayMissingPermissions() {
        DispatchQueue.main.async {
            self.hideAllViews()
            self.missingPermissionsView.isHidden = false
        }
    }

    func displayMissingCameraView() {
        DispatchQueue.main.async {
            self.hideAllViews()
            self.missingCameraView.isHidden = false
        }
    }

    func displayCameraView() {
        DispatchQueue.main.async {
            self.hideAllViews()
            self.cameraView.isHidden = false
        }
    }

    func hideAllViews() {
        cameraView.isHidden = true
        missingCameraView.isHidden = true
        missingPermissionsView.isHidden = true
    }
}

extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from _: AVCaptureConnection
    ) {
        if state == .finished { return }
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            state = .finished

            print("Found barcode: \(stringValue)")
        }
    }
}
