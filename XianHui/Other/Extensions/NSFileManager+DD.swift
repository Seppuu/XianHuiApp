//
//  NSFileManager+DD.swift
//  DingDong
//
//  Created by Seppuu on 16/2/29.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import UIKit

enum FileExtension:String {
    
    case M4A = "m4a"
    case JPG = "jpg"
    
    case plist = "plist"
}

extension NSFileManager {
    
    /**
    返回Documents URL目录
     */
    class func ddDocsURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    }
    
    /**
     返回DingDong URL目录
     */
    class func ddDingDongDocsURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        
        let dingDongDocsURL = ddDocsURL().URLByAppendingPathComponent("DingDong", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(dingDongDocsURL!, withIntermediateDirectories: true, attributes: nil)
            return dingDongDocsURL
        } catch _ {
            
        }
        
        return nil
    }
    
    /**
     返回DingDong - School URL目录
     */
    class func ddSchoolDocsURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        
        let schoolDocsURL = ddDingDongDocsURL()!.URLByAppendingPathComponent("School", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(schoolDocsURL!, withIntermediateDirectories: true, attributes: nil)
            return schoolDocsURL
        } catch _ {
            
        }
        
        return nil
    }
    
    
    /**
     返回DingDong - School - MakeLesson URL目录
     */
    class func ddMakeLessonDocsURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        
        let makeLessonDocsURL = ddSchoolDocsURL()!.URLByAppendingPathComponent("MakeLesson", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(makeLessonDocsURL!, withIntermediateDirectories: true, attributes: nil)
            return makeLessonDocsURL
        } catch _ {
            
        }
        
        return nil
    }
    
    /**
     返回DingDong - School - MakeLesson - Records URL目录
     */
    class func ddRecordsDocsURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        
        let recordsDocsURL = ddMakeLessonDocsURL()!.URLByAppendingPathComponent("Records", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(recordsDocsURL!, withIntermediateDirectories: true, attributes: nil)
            return recordsDocsURL
        } catch _ {
            
        }
        
        return nil
    }
    
    /**
     返回DingDong - School - MakeLesson - Photos URL目录
     */
    class func ddPhotosDocsURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        
        let photosDocsURL = ddMakeLessonDocsURL()!.URLByAppendingPathComponent("Photos", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(photosDocsURL!, withIntermediateDirectories: true, attributes: nil)
            return photosDocsURL
        } catch _ {
            
        }
        
        return nil
    }
    

    // MARK: Transfer
    /**
    返回DingDong - School - MakeLesson - Transfer URL目录
    */
    class func ddTransferDocsURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let transferDocsURL = ddMakeLessonDocsURL()!.URLByAppendingPathComponent("Transfer", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(transferDocsURL!, withIntermediateDirectories: true, attributes: nil)
            return transferDocsURL
        } catch _ {
            
        }
        
        return nil
    
    }
    
    // MARK: SamplesArry
    /**
    返回DingDong - School - MakeLesson - SamplesArry URL目录
    */
    class func ddSamplesDocsURl() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        
        let samplesArry = ddMakeLessonDocsURL()!.URLByAppendingPathComponent("SamplesArry", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(samplesArry!, withIntermediateDirectories: true, attributes: nil)
            return samplesArry
        } catch _ {
            
        }
        
        return nil
    }
    
    
    
    
    
    class func ddRecordURLWithNameInTransfer(name:String) -> NSURL? {
        
        if let transferFileURL = ddTransferDocsURL() {
            return transferFileURL.URLByAppendingPathComponent("\(name).\(FileExtension.M4A.rawValue)")
        }
        
        return nil
    }
    
    
    // MARK: Lesson
    class func ddLessonFileURL(uuidName:String) -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let lessonFileURL = ddRecordsDocsURL()!.URLByAppendingPathComponent(uuidName, isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(lessonFileURL!, withIntermediateDirectories: true, attributes: nil)
            return lessonFileURL
        }catch _ {
            
        }
        
        return nil
    }
    
    class func ddPlistFileURlWithName(name:String) -> NSURL? {
        
        if let samplesFileURL = ddSamplesDocsURl()  {
            
              return samplesFileURL.URLByAppendingPathComponent("\(name).\(FileExtension.plist.rawValue)")
        }
        
        return nil
    }
        

    class func ddRecordURLWithName(lessonURL:NSURL,name:String) -> NSURL? {

        return lessonURL.URLByAppendingPathComponent("\(name).\(FileExtension.M4A.rawValue)")
 
    }
    
    
    /**
     返回DingDong - School - MyAlbums URL目录
     */
    class func ddMyAlbumsDocsURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        
        let myAlbumsDocsURL = ddSchoolDocsURL()!.URLByAppendingPathComponent("MyAlbums", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(myAlbumsDocsURL!, withIntermediateDirectories: true, attributes: nil)
            return myAlbumsDocsURL
        } catch _ {
            
        }
        
        return nil
    }
    
    /**
     返回DingDong - School - MyAlbums - AlbumIndex URL目录
     */
    class func ddAlbumFileURL(index:Int) -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let albumIndexFileURL = ddMyAlbumsDocsURL()!.URLByAppendingPathComponent("Album\(index)", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(albumIndexFileURL!, withIntermediateDirectories: true, attributes: nil)
            return albumIndexFileURL
        }catch _ {
            
        }
        
        return nil
    }
    
    
    /**
     返回DingDong - School - MyAlbums - AlbumIndex - Audios URL目录
     */
    class func ddAlbumIndexAudiosFileURL(index:Int) -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let albumAudiosFileURL = ddAlbumFileURL(index)!.URLByAppendingPathComponent("Audios", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(albumAudiosFileURL!, withIntermediateDirectories: true, attributes: nil)
            return albumAudiosFileURL
        }catch _ {
            
        }
        
        return nil
    }
    
    /**
     返回DingDong - School - MyAlbums - AlbumIndex - Images URL目录
     */
    class func ddAlbumIndexImagesFileURL(index:Int) -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let albumImagesFileURL = ddAlbumFileURL(index)!.URLByAppendingPathComponent("Images", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(albumImagesFileURL!, withIntermediateDirectories: true, attributes: nil)
            return albumImagesFileURL
        }catch _ {
            
        }
        
        return nil
    }
    
    
    
    /**
     返回 专辑Album - Audios - 具体存储audio的名字以及路径
     */
    class func ddAlbumAudioURLWithName(AlbumIndex:Int,name:String) -> NSURL? {
        
        if let audioFileURL = ddAlbumIndexAudiosFileURL(AlbumIndex) {
            return audioFileURL.URLByAppendingPathComponent("\(name).\(FileExtension.M4A.rawValue)")
        }
        
        return nil
    }
    
    /**
     返回 专辑Album - Images - 具体存储images的名字以及路径
     */
    class func ddAlbumImagesURLWithName(AlbumIndex:Int,name:String) -> NSURL? {
        
        if let imagesFileURL = ddAlbumIndexImagesFileURL(AlbumIndex) {
            return imagesFileURL.URLByAppendingPathComponent("\(name).\(FileExtension.JPG.rawValue)")
        }
        
        return nil
    }
    
    
    // MARK: Clean Documents
    /* 
    删除Document下的文件
    */
    class func cleanDocs() {
        let fileManager = NSFileManager.defaultManager()
        
        if let fileURLs = (try? fileManager.contentsOfDirectoryAtURL(ddDocsURL(), includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())) {
            for fileURL in fileURLs {
                do {
                    try fileManager.removeItemAtURL(fileURL)
                } catch _ {
                    
                }
            }
        }
    }
    /**
     document中,子目录下的文件.
     
     - parameter docsDirectoryURL: 参数是子目录
     */
    class func cleanDocsDirectoryAtURL(docsDirectoryURL:NSURL) {
        let fileManager = NSFileManager.defaultManager()
        
        if let fileURLs = (try? fileManager.contentsOfDirectoryAtURL(docsDirectoryURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())) {
            for fileURL in fileURLs {
                do {
                    try fileManager.removeItemAtURL(fileURL)
                } catch _{
                    
                }
            }
            
        }
    }
    
    
    class func cleanMakeLessonFiles() {
        if let makeLessonURl = ddMakeLessonDocsURL() {
            cleanDocsDirectoryAtURL(makeLessonURl)
        }
    }
    
    class func cleanRecordFilesWithURL(url:NSURL) {
        
            cleanDocsDirectoryAtURL(url)
    
    }
    
    class func cleanTransferFiles() {
        if let transferURL = ddTransferDocsURL() {
            cleanDocsDirectoryAtURL(transferURL)
        }
    }
    
    class func cleanSamplesArryFile() {
        if let samplesArryURL = ddSamplesDocsURl() {
            cleanDocsDirectoryAtURL(samplesArryURL)
        }
        
    }
    
    
    //MARK:Count Record Of Lesson
    class func recordCountInLessonIndex(lessonFileURL:NSURL) -> Int {
        let fileManager = NSFileManager.defaultManager()
        
        if let urls = (try? fileManager.contentsOfDirectoryAtURL(lessonFileURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())) {
            return urls.count
        }
        
        return 0
    }
    
    
    
    
    
}
