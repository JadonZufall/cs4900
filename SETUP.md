# Flutter
## MacOS
For my env I am using ZSH and Homebrew as my package manager.

### Installing Android Studio
Install android studio

### Installing Homebrew
You only need to do this if you don't already have homebrew installed on your system.
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

### Project Setup
Navigate to the directory you wish to contain the repo
`git clone https://github.com/JadonZufall/cs4900`

Install the flutter cask.
`brew install --cask flutter`

In order to find out the SDK path of flutter run.
`flutter doctor -v`

Should be located in a path something like this
`/Users/<username>/Caskroom/flutter/3.24.3/flutter`

Add the SDK path to android studio

### Firebase Setup
Install firebase command line interface
`brew install firebase-cli`

You are going to need to login using your google account run
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
This automatically registers your per-platform apps with Firebase and adds a lib/firebase_options.dart configuration file to your Flutter project. 

