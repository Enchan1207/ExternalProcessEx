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
        process.executableURL = .init(fileURLWithPath: "/usr/bin/python3")
        
        // パイプ生成
        let inputPipe = Pipe(), outputPipe = Pipe()
        process.standardInput = inputPipe.fileHandleForReading
        process.standardOutput = outputPipe.fileHandleForWriting
        
        // まずは実行
        do {
            try process.run()
        } catch {
            print(error)
        }
        
        // 突っ込んでみる
        inputPipe.fileHandleForWriting.write("print(\"Hello, World!\")".data(using: .utf8)!)
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }


}

