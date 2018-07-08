# libSoftMeter Changelog
All notable changes to this project will be documented in this file.

The format is based on [libSoftMeter website](https://www.starmessagesoftware.com/softmeter).

## [0.6.0] - Unreleased
### Added
- Detect invalid Google Analytics propertyIDs and mute the hits to G.A.

## [0.5.9] - Unreleased
### Changed
- Alignment of the code with the [SoftMeter Pro](https://www.starmessagesoftware.com/softmeter-pro) edition

## [0.5.8] - 2018-06-21
### Added
- Anonymize client's IP
- Disable/bypass the computer's internet cache
- New [example for Delphi GUI](https://github.com/starmessage/libSoftMeter/tree/master/delphi-gui-demo) applications

### Changed
- Internal improvements
- Better modelling of the Application ID and the Application Installation ID

## [0.5.6] - 2018-02-03
### Added
- New function: sendException(char *exceptionDescription, bool isFatal)  
  Use it to [remotely log and monitor exceptions](https://www.starmessagesoftware.com/blog/how-to-track-software-exceptions-via-google-analytics).  
  You can see the exceptions of your distributed installations in real-time from Google Analytics

