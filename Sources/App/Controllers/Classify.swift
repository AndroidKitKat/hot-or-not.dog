//
//  Classify.swift
//  
//
//  Created by skg on 3/11/21.
//

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
        return prediction.classLabel
    } catch {
        return "something went wrong"
    }
}
