# AppImageViewer

[![Version](https://img.shields.io/cocoapods/v/AppImageViewer.svg?style=flat)](http://cocoapods.org/pods/AppImageViewer)
[![License](https://img.shields.io/cocoapods/l/AppImageViewer.svg?style=flat)](http://cocoapods.org/pods/AppImageViewer)
[![Platform](https://img.shields.io/cocoapods/p/AppImageViewer.svg?style=flat)](http://cocoapods.org/pods/AppImageViewer)


![Effect](https://github.com/karthikAdaptavant/AppImageViewer//raw/master/AppImageViewer1.gif)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AppImageViewer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AppImageViewer'
```

## Usage
```swift
    let appImage = ViewerImage.appImage(forImage: tappedImage.image!)
    let viewer = AppImageViewer(originImage: tappedImage.image!, photos: [appImage], animatedFromView: tappedImage)
    viewer.delegate = self
    present(viewer, animated: true, completion: nil)
```

## Author

karthik-ios-dev, karthik.samy@a-cti.com

## License

AppImageViewer is available under the MIT license. See the LICENSE file for more info.
