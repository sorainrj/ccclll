

###### 2018.03.10 [v5.0.083]

Major update including complete refactor for future development
Android: Updated SDK to v11.8.0
iOS: Updated SDK to v7.28.0
  - Added ability to get advert size (resolves #46)
  - New method to retrieve advertising id
  - Added advertising id tracking flag info (resolves #41)
  - Added gender and birthday to requests (resolves #6)
  - Better advert positioning (resolves #1) 
  - Resolved crash (resolves #44)


###### 2017.10.26 [v4.0.019]

Corrected setTestDetails function definition (#50)


###### 2017.07.10 [v4.0.011]

Updated for compatibility with new Core library (for Notifications/PushNotifications fix)


###### 2017.03.15 [v4.0.010]

Removed iOS Simulator version to reduce file size
Android: Updated SDK to v10.2.0
iOS: Updated SDK to v3.14.0


###### 2017.03.15 [v4.0.010]

Removed iOS Simulator version to reduce file size
Android: Updated SDK to v10.2.0
iOS: Updated SDK to v3.14.0


###### 2017.01.06 [v4.0.003]

iAd Shutdown, updated SDKs, new documentation


###### 2016.06.04

Android: Minor view parameter changes (#35)


###### 2016.05.20

iOS: Resolved missing framework references (resolves #33, #25)


###### 2016.05.03

Updated SDK versions (#25)

###### 2016.03.10


###### 2015.06.26

Android: Fix to prevent unusual crashes (resolves #21)


###### 2015.04.23

Android: Resolved issue with AdMob test details (resolves #19)


###### 2015.02.26

Android: Fixed banner positioning issue (resolves #15)


###### 2015.02.24

Android: Fixed crash when initialising doubleClick (resolves #10)


###### 2015.02.19

Added Interstitial Advert support for AdMob and iAd 
Fixed Flash Builder 4.6 missing class issue
iOS: Updated Google Mobile Ads library to version 7.0.0
iOS: Fix for smart banner rendering in landscape mode when flat
iOS: Fix for iOS 8 dimension changes for position banner adverts
iOS: Fixed issue with arm64 compilation error undefined symbols (resolves #5) (notify #12)
Android: Separated Google Play Libraries into separate ANE


###### 2015.01.31

iOS: Removed reference to the IDFA returned as the advertising identifier in the iAdOnly version to avoid review rejection (resolves #3)


###### 2015.01.31

Added check for .debug suffix in application id


###### 2014.12.17

iOS: Included arm64 support (resolves #2) 
Android: Corrected application id check when doesn't contain air prefix 


###### 2014.12.05

Corrected missing EventDispatcher functions from base class
iOS: Implemented autoreleasepools for all c function calls


###### 2014.11.26

New application based key check, removing server checks


###### 2014.10.20
iOS Update for iOS 8
- iOS: Split into two versions to satisfy Apple review for iAd (resolves #218)
