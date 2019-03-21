//
//  File.swift
//  Files
//
//  Created by 翟泉 on 2019/3/18.
//  Copyright © 2019 cezres. All rights reserved.
//

import UIKit
import FastImageCache

class File {
    let url: URL
    let name: String
    let type: FileType
    let pathExtension: String

    init(url: URL) {
        self.url = url
        name = url.lastPathComponent

        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        let pathExtension = url.pathExtension.lowercased()
        if isDirectory.boolValue {
            type = DirectoryFileType()
        } else if let result = File.types.first(where: {
            $0.pathExtensions.first(where: {
                $0.lowercased() == pathExtension
            }) != nil
        }) {
            type = result
        } else {
            type = UnknownFileType()
        }
        
        self.pathExtension = pathExtension
    }

    func thumbnail(completion: @escaping (UIImage) -> Void) {
        type.thumbnail(file: self, completion: completion)
    }

    func open(document: Document, controller: DocumentBrowserViewController) {
        type.openFile(self, document: document, controller: controller)
    }

    // MARK: - Types

    private static var types = [FileType]()

    static func register(type: FileType) {
        types.append(type)
    }

    // MARK: - Thumbnail

    // Gets
    lazy var relativePath: String = {
        guard let range = url.path.range(of: HomeDirectory.path) else { return url.path }
        return String(url.path[range.upperBound...])
    }()

    lazy var identifier: String = {
        let UUIDBytes = FICUUIDBytesFromMD5HashOfString(relativePath)
        let UUID = FICStringWithUUIDBytes(UUIDBytes)
        return UUID!
    }()
}

protocol FileType {
    var pathExtensions: [String] { get }
    func thumbnail(file: File, completion: @escaping (UIImage) -> Void)
    func openFile(_ file: File, document: Document, controller: DocumentBrowserViewController)
}

struct DirectoryFileType: FileType {
    func openFile(_ file: File, document: Document, controller: DocumentBrowserViewController) {
        let documentBrowser = DocumentBrowserViewController(directory: file.url)
        controller.navigationController?.pushViewController(documentBrowser, animated: true)
    }

    let pathExtensions: [String] = []

    func thumbnail(file: File, completion: @escaping (UIImage) -> Void) {
        completion(UIImage(named: "icon_directory")!)
    }
}

struct UnknownFileType: FileType {
    func openFile(_ file: File, document: Document, controller: DocumentBrowserViewController) {
    }

    let pathExtensions: [String] = []

    func thumbnail(file: File, completion: @escaping (UIImage) -> Void) {
        completion(UIImage(named: "icon_unknown")!)
    }
}