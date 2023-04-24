# Install flutter

sudo snap install flutter --classic
flutter sdk-path
install-android-studio
# open android studio, choose Standard setup, then waiting Android Studio seting up Android SDK
# open android studio, choose Tools -> SDK Manager
#   In System Settings -> Android SDK, tab SDK Tools, 
#      tick to Android SDK Command Line Tools (latest), choose Apply
flutter doctor --android-licenses
flutter doctor
flutter upgrade
# open android studio, choose Tools -> Device Manager, Create Device..

# install flutter package before run project
flutter packages get
flutter packages upgrade

# build
flutter build apk
flutter install
