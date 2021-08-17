# ExternalProcessEx

## Overview

Swiftで外部プロセスを起動するサンプル。

## Discussion - 理論

### プロセスの起動

Swiftで外部プロセスを起動させる際は、`Foundation`の`Process`を使用します。

```swift
import Foundation

let process = Process()
```

`process.executableURL`に実行ファイルのパス、`process.arguments`に実行引数を代入し、
`process.run()`を呼び出すことでプロセスを実行できます。

```swift
let filePath: String = "/bin/ls"
process.executableURL = .init(string: filePath)!
process.arguments = ["-la", "/"]

do{
    try process.run()
} catch {
    print(error)
}
```

### 終了ハンドラ
`Process.terminationHandler` に関数またはクロージャを渡すことで、プロセス終了時に実行される関数を指定することができます。
関数は `(Process) -> Void` であり、`Process.terminationStatus`を読むことで終了コードを取得できます。

### 入出力ストリームの利用

プロセスの入出力ストリームはそれぞれ`process.standardInput`、`process.standardOutput`、`process.standardError`から取得・設定することができます。何も設定しないとアプリケーションそのもののストリームに接続されるため、必要のないストリームには`nil`を設定しておきます。

```Swift
let outputPipe = Pipe()
process.standardError = nil
process.standardOutput = outputPipe.fileHandleForWriting
```

入出力ストリームは `Pipe.fileHandleFor(Reading|Writing)` から取得できます。
プロセスが終了していれば `fileHandleForReading.readToEnd()` を用いることで出力をまとめて `Data` で取得できます。

```Swift
process.terminationHandler = {(process: Process) -> Void in
    print("Exitcode: \(process.terminationStatus)")
    
    // パイプを閉じて
    do {
        try outputPipe.fileHandleForWriting.close()
    } catch {
        print(error)
    }
    
    // 出力を取得
    guard let avaliableData = try? outputPipe.fileHandleForReading.readToEnd() else {return}
    print(String(data: avaliableData, encoding: .utf8)!)
    print("(\(avaliableData.count) bytes)")
}
```

