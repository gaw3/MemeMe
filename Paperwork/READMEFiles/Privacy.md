# ![][AppIcon]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Device Privacy

MemeMe is designed to utilize the Device Photo Library & the Device Camera.  The [Meme Editor View][MEV] is where the user chooses the Photo Library or the Camera to be the source of the original image for a meme.

## Photo Library Privacy

* Info.plist **MUST** contain the key/value pair for **Privacy - Photo Library Usage Description** for the app to gain access to the Photo Library.
* Key/Value pair is ["NSPhotoLibraryUsageDescription", String];  string may be empty,  this implementation leaves it empty.
* When the app is invoked for the first time after installation, and the **Photos** button is tapped, the following alert appears:

##### Photo Libary Usage Request
![][PhotoLibraryAlert]

* Tapping **OK** allows.. 
* Tapping **Don't Allow** renders.. 

## Camera Privacy

* Info.plist **MUST** contain the key/value pair for **Privacy - Camera Usage Description** for the app to work properly on a device:
* Key/Value pair is ["NSCameraUsageDescription", String];  string may be empty, this implementation leaves it empty.
* When the app is invoked for the first time after installation, and the **Camera** button is tapped, the following alert appears:

##### Camera Usage Request
![][CameraAlert]

* Tapping **OK** allows 
* Tapping **Don't Allow** renders... 

---
**Copyright © 2016-2017 Gregory A. White. All rights reserved.**



[AppIcon]:            ../images/MemeMeAppIcon_80.png

[CameraAlert]:        ../images/CameraUsageAlert.png
[PhotoLibraryAlert]:  ../images/PhotosUsageAlert.png

[MEV]:                ./MemeEditorView.md

