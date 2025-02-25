# Dev Ops


## Common Tasks

##### Deploy app to firebase

```
# ios
firebase appdistribution:distribute ~/Downloads/LLOO-ios/lloo_mobile.ipa \
  --app 1:851215965679:ios:2c26e1ae828d7369c9aa1a \
  --groups "core" \
  --release-notes "Release notes"
 ```

##### Re-computer app icons

```
flutter pub run flutter_launcher_icons
```

