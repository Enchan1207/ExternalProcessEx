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
        process.executableURL = .init(fileURLWithPath: "/bin/ls")
        process.arguments = ["-1", "/Applications"]
        
        do {
            try process.run()
        } catch {
            print(error)
        }

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

