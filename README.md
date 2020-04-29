# ![][AppIcon]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MemeMe

MemeMe allows the user to affix captions to the top and bottom of a selected photo, thereby creating a [meme][Meme]. The user may then choose to distribute the meme to others via email or text.  As memes are sent, they are collected & held until the app terminates.  Previously-sent memes are presented in a table or a collection, and may be edited & resent.  

## Project

MemeMe is Portfolio Project #2 of the Udacity iOS Developer Nanodegree Program.  The following list contains pertinent course documents:

* [Udacity App Specification][AppSpec]
* [Udacity Grading Rubric][GradingRubric]
* [GitHub Swift Style Guide][SwiftStyleGuide]
* [Udacity Git Commit Message Style Guide][CommitMsgStyleGuide]
* [Udacity Project Review][ProjectReview]<br/><br/>

| [Change Log][ChangeLog] | Current Build          | Project Submission - ***Exceeds Expectations*** |
| :----------             | :-----------------     | :-------------                                  |
| GitHub Tag              | v4.1                   | v2.0                                            |
| App Version:            | 4.1                    | 2.0                                             |
| Environment:            | iOS 13 / Swift 5       | iOS 9.1 / Swift 2                               |
| Devices:                | iPhone Only            | iPhone Only                                     |
| Orientations:           | All except Upside Down | Portrait Only                                   |

## Design

Upon app launch, the initial view is the **Sent Memes Tabbed View** with the **Table** tab activated.  There is no persistence in this app, so there are [no sent memes to display][NoMemes].  As memes are created and distributed, a memory store keeps track of these [memes for appropriate presentation][SomeMemes]. However, upon app termination, all these memes are lost.

* The **Table** tab is the default tab, and presents the memes in a table view.  Each row contains a sent meme, with the top & bottom legends appearing to the side.
  - Tap a row to present the meme in the [Meme Detail View][MDV].
  - Left-Swipe a row to present the option to [delete][DeleteMeme] the associated meme from the memory store.<br/><br/>
* The **Collection** tab presents the memes in a collection view.  Each cell contains a sent meme.
  - Tap a cell to present the meme in the [Meme Detail View][MDV].<br/><br/>
* The tabs share a common navigation bar:
  - Tap the **Add** button (&nbsp;![][AddButton], right side, always visible) to present an [empty Meme Editor View][EmptyMEV], in order to create and send a meme.
  - Tap the **Edit** button (left side, visible for **Table** tab only) to present an [interface][TableEdit] for deleting and reordering sent memes.
 
### Notes

* [Device Privacy][DevicePrivacy]

### iOS Frameworks

* Foundation
* UIKit

### 3rd-Party

* *GitHub Swift Style Guide* lives in this [repo][StyleGuideRepo].
* `Swift.gitignore`, the template used to create the local `.gitignore` file, lives in this [repo][GitIgnoreRepo].

---
**Copyright © 2016-2020 Gregory A. White. All rights reserved.**



[AddButton]:            ./Paperwork/images/AddButtonIcon_15.png
[AppIcon]:              ./Paperwork/images/MemeMeAppIcon_80.png

[AppSpec]:              ./Paperwork/Udacity/UdacityAppSpecification.pdf
[CommitMsgStyleGuide]:  ./Paperwork/Udacity/UdacityGitCommitMessageStyleGuide.pdf
[GradingRubric]:        ./Paperwork/Udacity/UdacityGradingRubric.pdf
[ProjectReview]:        ./Paperwork/Udacity/UdacityProjectReview.pdf
[SwiftStyleGuide]:      ./Paperwork/Udacity/GitHubSwiftStyleGuide.pdf  

[ChangeLog]:            ./Paperwork/READMEFiles/ChangeLog.md
[DeleteMeme]:           ./Paperwork/READMEFiles/SwipeLeftOnRow.md
[EmptyMEV]:             ./Paperwork/READMEFiles/MemeEditorView.md
[MDV]:                  ./Paperwork/READMEFiles/MemeDetailView.md
[Meme]:                 ./Paperwork/READMEFiles/MemeDefinition.md
[NoMemes]:              ./Paperwork/READMEFiles/SentMemesEmpty.md
[DevicePrivacy]:        ./Paperwork/READMEFiles/Privacy.md
[SomeMemes]:            ./Paperwork/READMEFiles/SentMemesFull.md
[TableEdit]:            ./Paperwork/READMEFiles/TableEditMode.md

[FDTN]:                 ./Paperwork/READMEFiles/Foundation.md
[UK]:                   ./Paperwork/READMEFiles/UIKit.md 

[GitIgnoreRepo]:        https://github.com/github/gitignore
[StyleGuideRepo]:       https://github.com/github/swift-style-guide

