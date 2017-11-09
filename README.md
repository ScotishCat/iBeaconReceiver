# iBeaconReceiver
Receiver sample app monitors proximity to a specific iBeacon device and sends a request to a specific endpoint once every 4 seconds while the phone is in close proximity to iBeacon.

# How to run
The app was written and tested with Xcode 9.1, using Swift 4.

In order to monitor a beacon, you have to specify its UUID, name, major and minor codes.
To do that, open AppCoordinator.swift in Xcode and find "let item = BeaconItem(" code in
setUp() function and change parameters of item to match your iBeacon device.
Build and run on your device.

App also has a custom animated view that is created on layers for better performance.
You can see video of working app by this link: https://youtu.be/IUuCUD3mFKI
