# ![App Icon](./Paperwork/images/MemeMeAppIcon_80.png)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MemeMe

MemeMe allows the user to affix captions to the top and bottom of a selected photo, thereby creating a [meme](./Paperwork/READMEFiles/MemeDefinition.md). The user may then choose to distribute the meme to others via email or text.  As memes are sent, they are collected & held until the app terminates.  Previously-sent memes are presented in a table or a collection, and may be edited & resent.  

## Project

MemeMe is Portfolio Project #2 of the Udacity iOS Developer Nanodegree Program.  The following list contains pertinent course documents:

* [Udacity App Specification](./Paperwork/Udacity/UdacityAppSpecification.pdf)  
* [Udacity Grading Rubric](./Paperwork/Udacity/UdacityGradingRubric.pdf)  
* [GitHub Swift Style Guide](./Paperwork/Udacity/GitHubSwiftStyleGuide.pdf)  
* [Udacity Git Commit Message Style Guide](./Paperwork/Udacity/UdacityGitCommitMessageStyleGuide.pdf)  
* [Udacity Project & Code Reviews](https://review.udacity.com/#!/reviews/72996)<br/><br/>

|               | Project Submission         | Currently
| :----------   | :-------------             | :----------------- |
| Grade:        | ***Exceeds Expectations*** | |  
| App Version:  | 2.0                        |2.1&nbsp;&nbsp;(GH tag v2.1)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[changelog](./Paperwork/READMEFiles/ChangeLog.md)|
| Environment:  | Xcode 7.1 / iOS 9.1        | Xcode 7.2.1 / iOS 9.2 |
| Devices:      | iPhone only                | No Change |
| Orientations: | All except Upside Down     | No Change |

## Design

Upon app launch, the initial view is the Sent Memes Tabbed View  with the **Table** tab activated.  There is no persistence in this app, so there are [no sent memes to display](./Paperwork/READMEFiles/SentMemesEmpty.md).  As memes are created and distributed, a memory store keeps track of these [memes for appropriate presentation](./Paperwork/READMEFiles/SentMemesFull.md). However, upon app termination, all these memes are lost.

  * The **Table** tab is the default tab, and presents the memes in a table view.  Each row contains a sent meme, with the top & bottom legends appearing to the side.
    - Tap a roow to present the meme in the [Meme Detail View](./Paperwork/READMEFiles/MemeDetailView.md).
    - Left-Swipe a row to present the option to [delete](./Paperwork/READMEFiles/SwipeLeftOnRow.md) the associated meme from the memory store.<br/><br/>
  * The **Collection** tab presents the memes in a collection view.  Each cell contains only a sent meme.
    - Tap a cell to present the meme in the [Meme Detail View](./Paperwork/READMEFiles/MemeDetailView.md).<br/><br/>
  * The tabs share a common navigation bar:
    - Tap the **Add** button (&nbsp;![](./Paperwork/images/AddButtonIcon_15.png), right side, always visible) to present an [empty Meme Editor View](./Paperwork/READMEFiles/MemeEditorView.md), in order to create and send a meme.
    - Tap the **Edit** button (left side, visible for **Table** tab only) to present an [interface](./Paperwork/READMEFiles/TableEditMode.md) for deleting and reordering sent memes.
 
### iOS Developer Libraries In Use

* [CoreGraphics](./Paperwork/READMEFiles/CoreGraphics.md)
* [Foundation](./Paperwork/READMEFiles/Foundation.md)
* [UIKit](./Paperwork/READMEFiles/UIKit.md)

### Protocols Implemented

```
UIApplicationDelegate
UICollectionViewDataSource
UICollectionViewDelegate
UIImagePickerControllerDelegate
UINavigationControllerDelegate
UITableViewDataSource
UITableViewDelegate
UITextFieldDelegate
```

## 3rd-Party

* *GitHub Swift Style Guide* lives in this [repo](https://github.com/github/swift-style-guide).
* `Swift.gitignore`, the template used to create the local `.gitignore` file, lives in this [repo](https://github.com/github/gitignore).

---
**Copyright © 2016 Gregory White. All rights reserved.**
