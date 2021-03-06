//
//  Classify.swift
//
//
//  Created by skg on 3/11/21.
//

import Vapor
import Foundation
import CoreML
import Vision
import ImageIO
import CoreImage


let model = try! HotDogClassifier(
    contentsOf: URL.init(fileURLWithPath: "Sources/App/HotDogClassifier.mlmodelc"),
                                  configuration: MLModelConfiguration())

func isHotDog(path: String) -> (status: Int, result: String, probability: [String : Double], destination: String) {
    let fileManager = FileManager.default
    let image = URL.init(fileURLWithPath: path)
    do {
        let prediction = try model.prediction(input: HotDogClassifierInput(imageAt: image))
        //move the file to the proper place
        var destination: String
        switch prediction.classLabel {
        case "hot_dog":
            destination = "Public/hot/" + image.lastPathComponent
            break
        case "not_hot_dog":
            destination = "Public/not/" + image.lastPathComponent
            break
        default:
            destination = "/dev/null"
        }
        // move the image to the right folder
        do {
            try fileManager.moveItem(at: image, to: URL.init(fileURLWithPath: destination))
        } catch {
            return (1, "File IO error", ["hot_dog": 0.00, "not_hot_dog": 0.00], destination)
        }
        // main return
        return (0, prediction.classLabel, prediction.classLabelProbs, destination)
    } catch {
        return (1, "Error in Classification", ["hot_dog": 0.00, "not_hot_dog": 0.00], "/dev/null")
    }
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in
        letters.randomElement()!
    })
}

func countFiles(path: String) -> Int {
    let fileMan = FileManager.default
    let dirContents = try? fileMan.contentsOfDirectory(atPath: path)
    return dirContents?.count ?? 0
}

