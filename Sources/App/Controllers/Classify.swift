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


func is_hotdog(image: String) -> String {
    do {
        let prediction = try model.prediction(input: HotDogClassifierInput(imageAt: URL.init(fileURLWithPath: image)))
        return prediction.classLabel + " " + randomString(length: 10)
    } catch {
        return "something went wrong"
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
