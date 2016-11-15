//
//  ExecuteCmd.swift
//  QuixeyAgent
//
//  Created by Irshad on 6/22/15.
//
//

import Foundation

/// Complete command line tool for executing all kinds of terminal commands
class ExecuteCmd:NSObject {
      
    /**
    Run terminal command using this function
    
    - parameter launchPath: Command with path
    - parameter arguments:  Parameters to be passed for that command
    - parameter error:      NSError Pointer. can also be ignored.
    
    - returns: 'output' if command succesfully executed
    */
   @objc open func run (_ launchP : String, arguments : [String]) throws -> String{
    
        let launchPath = launchP
        NSLog("ExecuteCmd : \(launchPath) \(arguments)")
        
//        if Platform.isSimulator {
//            launchPath = simulatorSDKPath+launchPath
//        }
        
        let task : NSTask = NSTask()
        task.setLaunchPath(launchPath)
        task.setArguments(arguments)
        
        // Pipe for capturing output
        let pipe = Pipe()
        task.setStandardOutput(pipe)

        // Pipe of capturing errors
        let errorPipe = Pipe()
        task.setStandardError(errorPipe)
        
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        NSLog("Cmd output : \(output)")
        
        // capture error
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let errorOutput: String = NSString(data: errorData, encoding: String.Encoding.utf8.rawValue) as! String
//        NSLog("Cmd error : \(errorOutput)")
        
        // If error occured, report back to
        if errorOutput.contains("ERROR") {
            throw NSError(domain: "Comand Line Error", code: 0, userInfo: [NSLocalizedDescriptionKey:errorOutput])
        }
        
        return output
    }
}
