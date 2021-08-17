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
        process.arguments = ["-r", "print('Hello, World')"]
        
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

