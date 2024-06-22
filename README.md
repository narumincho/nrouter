# nrouter

Flutter 内部で Web の History API の State に {serialCount: 0, state: null}
の構造のデータを入れていて, うまく取り出すことができない? JsAny
から取り出せない?

## macOS log

```
flutter: init NRouterDelegate
flutter: (called parseRouteInformation, /)
flutter: (called build, null)
flutter: called locationHref in no_web
flutter: (called setInitialRoutePath, /)
flutter: (called setNewRoutePath, /)
flutter: (called build, /)
flutter: called locationHref in no_web
flutter: (called parseRouteInformation, settings?)
flutter: (called setNewRoutePath, settings?)
flutter: (called build, settings?)
flutter: called locationHref in no_web
```
