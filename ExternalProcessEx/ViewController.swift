//
//  ViewController.swift
//  ExternalProcessEx
//
//  Created by EnchantCode on 2021/08/17.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let process = Process()
        
        // 外部プロセスのパスと引数を設定
        process.executableURL = .init(fileURLWithPath: "/usr/bin/curl")
        process.arguments = ["-i", "https://example.com"]
        
        // パイプを作り、プロセスのstdoutにつなぐ　繋がれなかったパイプはアプリケーションの出力に流れるらしいので
        // 困るときは明示的にnilにしておく (curlは受信状況をstderrに吐き出すので今回はnilに設定)
        let outputPipe = Pipe()
        process.standardError = nil
        process.standardOutput = outputPipe.fileHandleForWriting
        
        // process.run()はスレッドブロックしないので、terminationHandlerに終了後の処理を記述
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
        
        // 実行
        do {
            try process.run()
        } catch {
            print(error)
        }
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }


}

