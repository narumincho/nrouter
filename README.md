# nrouter

Flutter 内部で Web の History API の State に {serialCount: 0, state: null}
の構造のデータを入れていて, うまく取り出すことができない? JsAny
から取り出せない?

| called                                 | stack             |
| -------------------------------------- | ----------------- |
| RouterDelegate.setNewRoutePath(A:null) | (A:0)             |
| NRouter.push(B)                        | A:0,(B:1)         |
| RouterDelegate.setNewRoutePath(A:0)    | (A:0),B:1         |
| RouterDelegate.setNewRoutePath(C:null) | A:0,(C:1)         |
| RouterDelegate.setNewRoutePath(A:null) | A:0,C:1,(A:2)     |
| RouterDelegate.setNewRoutePath(C:1)    | A:0,(C:1),A:2     |
| RouterDelegate.setNewRoutePath(D:3)    | A:0,C:1,A:2,(D:3) |
| RouterDelegate.setNewRoutePath(C:0)    | (C:0),C:1,A:2,D:3 |

Flutter が RouterDelegate.currentConfiguration
を使って取得したパスをどのようにブラウザに伝搬させているのかが不明
