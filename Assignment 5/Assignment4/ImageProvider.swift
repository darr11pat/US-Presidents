//
//  ImageProvider.swift
//  Presidents
//
//  Created by Kurt McMahon on 10/26/16.
//  Copyright © 2016 Northern Illinois University. All rights reserved.
//

import Foundation
import UIKit

class ImageProvider {
    
    // Singleton property that can be used to access the ImageProvider object
    static let sharedInstance = ImageProvider()
    
    // Image cache
    let imageCache = NSCache()
    
    // Gets an image. Arguments are the image URL as a string, and a closure
    // to execute if the image is successfully obtained.
    func imageWithURLString(urlString: String, completion: (image: UIImage?) -> Void) {
        
        // If the image is stored in the image cache, retrieve it
        if urlString == "None" {
            completion(image: UIImage(named: "default.png"))
        } else if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
            completion(image: cachedImage)
        } else {
            
            // Otherwise, try to download the image from the provided URL
            weak var weakSelf = self
            
            let session = NSURLSession.sharedSession()
            
            if let url = NSURL(string: urlString) {
                let task = session.dataTaskWithURL(url) {
                    (data, response, error) in
                    let httpResponse = response as? NSHTTPURLResponse
                    if httpResponse!.statusCode != 200 {
                        // Download failed, so perform some error handling
                        dispatch_async(dispatch_get_main_queue()) {
                            print("HTTP Error: status code \(httpResponse!.statusCode).")
                            completion(image: UIImage(named: "default.png"))
                        }
                    } else if (data == nil && error != nil) {
                        // Download failed, so perform some error handling
                        dispatch_async(dispatch_get_main_queue()) {
                            print("No image data downloaded for image \(urlString).")
                            completion(image: UIImage(named: "default.png"))
                        }
                    } else {
                        // Download succeeded; attempt to converte data to
                        // an image and call the completion closure on the
                        // main thread.
                        if let image = UIImage(data: data!) {
                            dispatch_async(dispatch_get_main_queue()) {
                                weakSelf!.imageCache.setObject(image, forKey: urlString)
                                completion(image: image)
                            }
                        }
                    }
                }
                task.resume()
            } else {
                // Invalid URL string, so perform some error handling
                print("Invalid URL \(urlString).")
                completion(image: UIImage(named: "default.png"))
            }
        }
    }
    
    // Call this method to clear the cache on a memory warning.
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
