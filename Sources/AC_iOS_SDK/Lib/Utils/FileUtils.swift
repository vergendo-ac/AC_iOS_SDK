//
//  File.swift
//  
//
//  Created by Mac on 28.08.2020.
//

import Foundation
//import FileManager

open class FileUtils {
    
    public class func writeFile(name: String, data: Data, fileExtension: String = "png") -> URL? {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileURL = URL(fileURLWithPath: name, relativeTo: directoryURL).appendingPathExtension(fileExtension)
        
        // Save the data
        do {
         try data.write(to: fileURL)
            print("File saved: \(fileURL.absoluteURL)")
            return fileURL
        } catch {
         // Catch any errors
         print(error.localizedDescription)
            return nil
        }
        
    }
 
}
