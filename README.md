# Pre-work - Just the Tip

Just the Tip is a tip calculator application for iOS.

Submitted by: Stephen Chudleigh

Time spent: 30 hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage (see 3rd commit: 01db9b2)

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] Optional design decision: removed settings modal in favor of +/- tip % buttons in main view
- [x] Invert color black on white <=> white on black with double tap gesture anywhere on screen -- with animation for transition.
- [x] Added app icon and launch screen with assets for different screen sizes
- [x] Add ability to split the bill with up to 10 people via shake gesture
- [x] Remembers color scheme and bill splitting for up to 10 minutes also

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Video Walkthrough](JustTheTipSubmission.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Updating versions to Swift 3.0 and iOS 10 after my initial project submission was a bit of work but I learned about some of the new API and class name changes in the process.

I played with the design a little. I don't like settings modals so I wanted to make all the features available from the main screen. Double tap for color scheme is a bit awkward but I mostly wanted to play around with gesture recognition. I also added a shake gesture recognizer for splitting the bill with as many as 10 people.

Figuring out launch screen image resolution for different devices was more difficult than I expected. There was conflicting advice on the internet. I finally decided to create each image manually in an editor, but I'm not 100% sure it was implemented correctly.

Remembering the color scheme and split bill choice for 10 minute also took longer than expected. I implemented remembering the current amount pretty easily but getting them all working together took a lot longer. I cleaned up the code for the view controllers in the process.


## License

    Copyright [2016] [Stephen Chudleigh]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
