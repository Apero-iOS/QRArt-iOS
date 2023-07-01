//
//  FileManagerUtil.swift
//  Aibi
//
//  Created by Quang Ly Hoang on 08/05/2023.
//

import UIKit

class FileManagerUtil: NSObject {
    
    // MARK: - Singleton
    static let shared = FileManagerUtil()
    
    
    // MARK: - Variables
    let photoFolderName = "Photo"
    var manager = FileManager.default
    var documentUrl: URL? {
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    var photoUrl: URL? {
        return documentUrl?.appendingPathComponent(photoFolderName)
    }
    private let imageExtension = ".jpg"
    
    // MARK: - Functions
    func saveImage(image: UIImage, name: String) {
        do {
            let fileName = "\(name)\(imageExtension)"
            let fileURL = FileManagerUtil.shared.photoUrl?.appendingPathComponent(fileName)
            guard let fileURL = fileURL, !FileManager.default.fileExists(atPath: fileURL.pathString) else { return }
            if let data = image.jpegData(compressionQuality: 1) {
                // writes the image data to disk
                try data.write(to: fileURL)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteImage(name: String) {
        let deletePath = photoUrl?.appendingPathComponent(name + imageExtension).pathString ?? ""
        if FileManager.default.fileExists(atPath: deletePath) {
            do {
                try FileManager.default.removeItem(atPath: deletePath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeFolder(folder: String) {
        let folderUrl = documentUrl?.appendingPathComponent(folder).pathString ?? ""
        try? manager.removeItem(atPath: folderUrl)
    }
    
    func createFolder(folder: String) {
        let folderUrl = documentUrl?.appendingPathComponent(folder).pathString ?? ""
        if manager.fileExists(atPath: folderUrl) {
            return
        }
        try? manager.createDirectory(atPath: folderUrl, withIntermediateDirectories: true)
    }
    
    func getImage(from id: String) -> UIImage {
        UIImage(contentsOfFile: FileManagerUtil.shared.photoUrl?.appendingPathComponent(id + imageExtension).pathString ?? "") ?? UIImage()
    }
}
