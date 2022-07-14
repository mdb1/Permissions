//
//  CameraPermissionsManager.swift
//
//
//  Created by Manu on 10/07/2022.
//

import AVKit
import Combine

/// Class that acts as the manager for the camera permissions.
/// To integrate it, use Combine to observe the `permissionGranted` @Published property.
///
/// Example:
/// ```
/// private var subscribers: Set<AnyCancellable> = []
/// private let cameraManager = CameraPermissionsManager()
///
/// func addSubscriber() {
///     cameraManager.$permissionGranted
///         .sink { [weak self] permissionGranted in
///             guard let self = self else { return }
///             guard let permissionGranted = permissionGranted else { return }
///             if permissionGranted {
///                 // Display the camera
///             } else {
///                 // Display a missing permissions view
///             }
///         }.store(in: &subscribers)
///
///     cameraManager.requestPermissionIfNeeded()
/// }
/// ```
public final class CameraPermissionsManager: ObservableObject {
    /// Property to observe that will emit values once the permission for the camera has changed
    @Published public var permissionGranted: Bool?

    private var subscribers: Set<AnyCancellable> = []

    /// Public initializer for the CameraPermissionManager
    public init() {
        addWillEnterForegroundObserver()
    }

    /// Requests the camera permission if possible.
    /// If not, pushes a new value to the `permissionGranted` property
    public func requestPermissionIfNeeded() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        guard authStatus == .notDetermined else {
            let newValue = authStatus == .authorized
            if newValue != permissionGranted {
                permissionGranted = newValue
            }
            return
        }
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            DispatchQueue.main.async {
                self.permissionGranted = accessGranted
            }
        })
    }

    private func addWillEnterForegroundObserver() {
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.requestPermissionIfNeeded()
            }
            .store(in: &subscribers)
    }
}
