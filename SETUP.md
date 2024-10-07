# Setup




## MacOS
For my env I am using ZSH and Homebrew as my package manager.
I am using android studio for build process as well as build in android emulator.




### Installing Android Studio
Install android studio.




### Installing Homebrew
You only need to do this if you don't already have homebrew installed on your system.

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`




### Project Setup
Navigate to the directory you wish to contain the repo.

`git clone https://github.com/JadonZufall/cs4900`

Install the flutter cask.

`brew install --cask flutter`

In order to find out the SDK path of flutter run.

`flutter doctor -v`

Should be located in a path something like this.

`/Users/<username>/Caskroom/flutter/3.24.3/flutter`

Add the SDK path to android studio




### Firebase Setup
Install firebase command line interface.

`brew install firebase-cli`


You are going to need to login using your google account run.

`firebase login`

Then authenticate with your google account from the web browser that should open up.  
Authorize firebase with the required permissions then close the page when prompted to.


From any directory run, dart should already be in your system path.

`dart pub global activate flutterfire_cli`


In my install I had to fix my path by running
!Important not to run this unless prompted, however it shouldn't cause any problems.

`export PATH="$PATH":"$HOME/.pub-cache/bin"`


Then from the root of the project run

`flutterfire configure --project=cs4900-67bee`

1. Selected the options for IOS and Android development.
2. Package name was *com.senior_design_group*

*This automatically registers your per-platform apps with Firebase and adds
a lib/firebase_options.dart configuration file to your Flutter project.*


If you are having an issue mentioning ruby and gems with the Ruby Framework here is what fixed it.

`sudo gem install xcodeproj`


Then add firebase core to flutter

`flutter pub add firebase_core`


Get flutter packages
`flutter packages get`


Update flutter packages
`flutter packages upgrade`

Restart android studio

Add firebase authentication
`flutter pub add firebase_auth`

### Android Emulation
Click on Device Manager on the left side of Android Studio and create and run an android device

Fixing "No matching client found for package name '...'"
Go to `android/app/google-services.json`
find package name should be something like com.senior_design_group.cs4900
Go to `andoid/app/build.gradle`
find the namespace, change the `android/apps/google-services.json` to match the gradle, do not change the gradle.

Fixing bad version issue with the android api
`android/app/build.gradle`
change minSdk to 23 instead of flutter.minSdkVersion


### IOS Emulation
if you are on a macbook turn on power saving otherwise your macbook will cook itself.
both of these will take forever to install because ruby is terrible.

You only are required to run these if you are getting warning messages attempting to run this
on your computer.

This requires you install an XCode emulator for IOS too because I already had one installed,
you are gonna have to figure that out on your own.

required for cocoapods.  These are painful.

`sudo gem install drb -v 2.0.6`

`sudo gem install activesupport -v 6.1.7.8`


required for iphone emulation.

`sudo gem install cocoapods`


If it fails to run because the plugin firebase_auth requires a higher minimum iOS deployment
version then go to 
`ios/Flutter/AppFrameworkInfo.plist`
then change the value MinimumOSVersion to 13.0

Another thing to try is
`pod repo update`

If this does not work complete the following steps
1. Login to XCode with your apple ID.
2. ?
3. ?
4. ?
5. Cry yourself to sleep in apples terrible build enviorment.
6. Give up and emulate android

