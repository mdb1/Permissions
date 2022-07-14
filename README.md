# Permissions

A package that handles authorization status and permissions for the iOS SDKs.

## Camera
Using the `CameraPermissionManager` and `Combine`:
```swift
private var subscribers: Set<AnyCancellable> = []
private let cameraManager = CameraPermissionsManager()

func addSubscriber() {
    cameraManager.$permissionGranted
        .sink { [weak self] permissionGranted in
            guard let self = self else { return }
            guard let permissionGranted = permissionGranted else { return }
            if permissionGranted {
                // Display the camera
            } else {
                // Display a missing permissions view
            }
        }.store(in: &subscribers)

    cameraManager.requestPermissionIfNeeded()
}
```
