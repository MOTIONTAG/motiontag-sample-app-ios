# iOS sample app for the MOTIONTAG Mobility & Location Analytics SDK

The MOTIONTAG Mobility & Location Analytics SDK enables to collect raw sensor data of the telephone in
a battery efficient way. This data is then transmitted to the MOTIONTAG back-end system (ISO 27001 certified).
In the backend, the sensor events are processed and a partial journey is constructed. Journeys consist
either solely of tracks or tracks plus stays. Tracks describe a movement from a origin to a destination with
a certain mode of transport. Stays symbolize a stationary behaviour with a particular purpose for the visit.

The use cases for the SDK are manifold. In the mobility sector it can be used to get detailed mobility data
for planning purposes. The collected data enables to compare how the transport network is being used.
This way the effectiveness of the current infrastructure and the passenger flow management is measured and
the design of new mobility services. By implementing and using the SDK you can make use of these findings
to improve timetables and routes, expand transport supply and attract more passengers.

If you integrate MOTIONTAG Tracker SDK inside your own application, you can either download
user journeys via a provided dump interface on the internet or we tailor a customized solution to
your needs.

More information can be found on our website.

**Website:** https://motion-tag.com/

**Documentation:** https://api.motion-tag.de/developer/ios

**Changelog:** https://api.motion-tag.de/developer/ios_changelog

**SDK License:** https://api.motion-tag.de/developer/sdk_test_license


## Starting the sample app

1. Clone this repository
2. Open `SampleApp.xcproject`
3. Navigate to `Signing & Capabilities` section inside Xcode and update the Team settings
4. Update `userJwtToken` with a valid token (Please contact us in order to get a valid JWT token)
5. Run the project

Notes:

- The SDK does not ask for location or motion/activity permissions, and they need to be obtained before starting the SDK
- The Login button persists the given token in UserDefaults. It is important that this token is retrieved from UserDefaults 
and passed to the SDK on app startup in the AppDelegate's ```didFinishLaunchingWithOptions``` as shown.


## iOS 27 UIScene lifecycle requirement

Starting with iOS 27, Apple requires all apps built with the latest SDK to adopt the UIScene lifecycle. **Apps that still initialize their UI solely through `AppDelegate.application(_:didFinishLaunchingWithOptions:)` will fail to launch.**

This sample app satisfies the requirement without a hand-written `SceneDelegate`. Here is why, and what the options are.

### Option A: Use SwiftUI's `App` protocol (this sample app's approach)

When your entry point conforms to the SwiftUI `App` protocol and uses `WindowGroup`, **SwiftUI manages the UIScene lifecycle internally**. Xcode and the build system recognize this as compliant — no explicit `SceneDelegate` is needed.

```swift
@main
struct SampleAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

`AppDelegate` is still used here (via `@UIApplicationDelegateAdaptor`) for SDK initialization and background URL session handling — both of which belong in `AppDelegate` and are unaffected by this requirement.

### Option B: Explicit `SceneDelegate` (pure UIKit apps)

If your app does not use SwiftUI, you must migrate manually:

1. **Create a `SceneDelegate`** class conforming to `UISceneDelegate` and move UI setup (window creation, root view controller) into `scene(_:willConnectTo:options:)`.
2. **Update `AppDelegate`** — add `application(_:configurationForConnecting:options:)` returning a `UISceneConfiguration` that names your `SceneDelegate` class.
3. **Add `UIApplicationSceneManifest`** to `Info.plist`:
   - `UIApplicationSupportsMultipleScenes`: `NO` (for a standard single-window app)
   - A scene configuration entry pointing at your `SceneDelegate` class name.
4. **Keep in `AppDelegate`**: anything that must run at process launch before a scene exists — SDK initialization, background session handling, push notification registration.
5. **Move to `SceneDelegate`**: window and root view controller setup, anything that depends on a UI surface being available.

