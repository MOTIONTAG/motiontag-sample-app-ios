# # iOS sample app for the MotionTag Mobility & Location Analytics SDK

The MotionTag Mobility & Location Analytics SDK enables to collect raw sensor data of the telephone in
a battery efficient way. This data is then transmitted to the MotionTag back-end system (ISO 27001 certified).
In the backend, the sensor events are processed and a partial journey is constructed. Journeys consist
either solely of tracks or tracks plus stays. Tracks describe a movement from a origin to a destination with
a certain mode of transport. Stays symbolize a stationary behaviour with a particular purpose for the visit.

The use cases for the SDK are manifold. In the mobility sector it can be used to get detailed mobility data
for planning purposes. The collected data enables to compare how the transport network is being used.
This way the effectiveness of the current infrastructure and the passenger flow management is measured and
the design of new mobility services. By implementing and using the SDK you can make use of these findings
to improve timetables and routes, expand transport supply and attract more passengers.

If you integrate MotionTag Tracker SDK inside your own application, you can either download
user journeys via a provided dump interface on the internet or we tailor a customized solution to
your needs.

More information can be found on our website.

**Website:** https://motion-tag.com/

**Documentation:** https://api.motion-tag.de/developer/ios

**Changelog:** https://api.motion-tag.de/developer/ios_changelog


## Starting the sample app

1. Clone this repository
2. Navigate to `motiontag-sample-app-ios` folder
3. Initialize the pods: `pod install` (Contact us in order to get access to the MotionTag SDK framework)
4. Open `SampleApp.xcworkspace`
5. Navigate to `Signing & Capabilities` section inside Xcode and update the Team settings
6. Update `userToken` with a valid token
7. Run the project

Notes:

- The SDK does not ask for location or motion/activity permissions, and they need to be obtained before starting the SDK
- The Login button persists the given token in UserDefaults. It is important that this token is retrieved from UserDefaults 
and passed to the SDK on app startup in the AppDelegate's ```didFinishLaunchingWithOptions``` as shown.

