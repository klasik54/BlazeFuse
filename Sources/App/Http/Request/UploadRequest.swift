//
//  UploadRequest.swift
//  
//
//  Created by Matúš Klasovitý on 03/01/2024.
//

import Foundation

struct UploadRequest: AppRequest {
    
    let file: Data
    let fileName: String
    
}
