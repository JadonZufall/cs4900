# Flutter
## MacOS

### Installing Homebrew
You only need to do this if you don't already have homebrew installed on your system.
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

### Project Setup
navigate to the directory you wish to contain the repo
`git clone https://github.com/JadonZufall/cs4900`

`brew install --cask flutter`

In order to find out the SDK path of flutter run.
`flutter doctor -v`

Should be located in a path something like this
`/Users/<username>/Caskroom/flutter/3.24.3/flutter`

Add the SDK path to android studio