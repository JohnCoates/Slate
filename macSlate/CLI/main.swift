//
//  main.swift
//  slateCLI
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

func parseCommandLine() {
    var arguments = CommandLine.arguments.dropFirst()
    
    let firstArgument = arguments.removeFirst()
    
    switch firstArgument {
    case "--generateImageAssets":
        generateImageAssets()
    default:
        print("unrecognized argument: \(firstArgument)")
    }
}

func newestBuildObjectDate() -> Date {
    let fileManager = FileManager.default
    let objectsDirectory = BuildPaths.buildObjectsDirectory().appendingPathComponent("x86_64")
    let files: [URL]
    do {
        files = try fileManager.contentsOfDirectory(at: objectsDirectory,
                                                    includingPropertiesForKeys: [.contentModificationDateKey],
                                                    options: [.skipsHiddenFiles])
    } catch let error {
        print("Couldn't get objects at \(objectsDirectory): \(error)")
        return Date(timeIntervalSince1970: 0)
    }
    
    var newestDate = Date.init(timeIntervalSince1970: 0)
    for file in files {
        guard let fileDate = modificationDate(forFile: file) else {
            continue
        }
        if fileDate > newestDate {
            newestDate = fileDate
        }
    }
    
    return newestDate
}

func modificationDate(forFile filePath: URL) -> Date? {
    do {
        let resourceValues = try filePath.resourceValues(forKeys: [.contentModificationDateKey])
        guard let fileDate = resourceValues.contentModificationDate else {
            return nil
        }
        return fileDate
    } catch let error {
        print("Couldn't get modification date for \(filePath.path): \(error)")
        return nil
    }
}

func imageAssetsFilePath() -> URL {
    let projectDirectory = BuildPaths.projectDirectory()
    let generatedDirectory = projectDirectory.appendingPathComponent("Resources/Images/Generated")
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: generatedDirectory.path) {
        do {
            try fileManager.createDirectory(at: generatedDirectory,
                                            withIntermediateDirectories: false, attributes: nil)
        } catch let error {
            fatalError("Couldn't create generated images diretory: \(generatedDirectory.path): \(error)")
        }
        
    }
    
    return generatedDirectory.appendingPathComponent(ImageFile.coreAssets.rawValue)
}
func generateImageAssets() {
    let writeToFile = imageAssetsFilePath()
    
    if let lastModified = modificationDate(forFile: writeToFile) {
        let codeObjectsModified = newestBuildObjectDate()
        if lastModified > codeObjectsModified {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            let lastModifiedPretty = dateFormatter.string(from: lastModified)
            let objectsModifiedPretty = dateFormatter.string(from: codeObjectsModified)
            let skipMessage = "Skipping image creation, image created \(lastModifiedPretty), " +
            "code objects haven't changed since \(objectsModifiedPretty)"
            print(skipMessage)
            return
        }
    }
    
    let images: [VectorImageAsset] = [
        DrawProxyDSL.KitSettingsImage(),
        DrawProxyDSL.CameraPermissionsImage(),
        DrawProxyDSL.PhotosPermissionsImage()
    ]
    
    var canvases = [Canvas]()
    for image in images {
        DrawProxyDSL.pushCanvas(name: image.name, section: image.section,
                                width: Float(image.width), height: Float(image.height))
        image.simulateDraw()
        let canvas = DrawProxyDSL.popCanvas()
        canvases.append(canvas)
    }
    
    let writer = VectorAssetWriter.init(canvases: canvases)
    writer.write(toFile: writeToFile, compressed: true)
}

parseCommandLine()
