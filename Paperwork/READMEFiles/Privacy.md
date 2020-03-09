# ![][AppIcon]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Device Privacy

MemeMe is designed to utilize the device **Photo Library** & the device **Camera**.  The [Meme Editor View][MEV] is where the user chooses the **Photo Library** or the **Camera** to be the source of the original image for a meme.  At this time, iOS 10 controls the following device behavior.

## Photo Library Privacy

* Info.plist **MUST** contain the key/value pair for **Privacy - Photo Library Usage Description** for the app to gain access to the **Photo Library**.
* Key/Value pair is ["NSPhotoLibraryUsageDescription", String];  string may be empty,  this implementation leaves it empty.
* When the **Photos** button is tapped for the first time after installation, the following alert appears:

##### Photo Libary Usage Request
![][PhotoLibraryAlert]

* Tapping **OK** allows the main **Photo Library** view to appear.
* Tapping **Don't Allow** prevents the main **Photo Library** view from appearing.  Tapping the **Cancel** button returns app to the [Meme Editor View][MEV].  Subsequent taps of the **Photos** button results in the following display:

##### No Access to Photo Library
![][PhotoLibraryNoAccess]

## Camera Privacy

* Info.plist **MUST** contain the key/value pair for **Privacy - Camera Usage Description** for the app to gain access to the device **Camera**:
* Key/Value pair is ["NSCameraUsageDescription", String];  string may be empty, this implementation leaves it empty.
* When the **Camera** button is tapped for the first time after installation, the following alert appears:

##### Camera Usage Request
![][CameraAlert]

* Tapping **OK** allows the **Camera app** to appear and access the device **Camera**.
* Tapping **Don't Allow** allows the **Camera app** to appear, but the app cannot access the device **Camera**.  Tapping the **Cancel** button returns app to the [Meme Editor View][MEV].  Subsequent taps of the **Camera** button result in the same behavior minus the alert.

---
**Copyright © 2016-2020 Gregory A. White. All rights reserved.**



[AppIcon]:               ../images/MemeMeAppIcon_80.png

[CameraAlert]:           ../images/CameraUsageAlert.png
[PhotoLibraryAlert]:     ../images/PhotosUsageAlert.png
[PhotoLibraryNoAccess]:  ../images/PhotoLibraryNoAccess.png

[MEV]:                   ./MemeEditorView.md

