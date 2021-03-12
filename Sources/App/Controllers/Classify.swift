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
    contentsOf: URL.init(fileURLWithPath: "Sources/App/HotDogClassifier/mlmodelc"),
                                  configuration: MLModelConfiguration())


func wtf() -> String{
    var prediction = ""
    do {
        prediction = try model.prediction(input: HotDogClassifierInput(imageAt: URL.init(fileURLWithPath: "Public/NCI_Visuals_Food_Hot_Dog.jpg")))
        print(prediction.classLabel)
    } catch {
        print("please")
    }
//    do {
//        let model = try HotDogClassifier
//        let pic_url = URL.init(fileURLWithPath: "Public/6ab.png")
//        let ci_image = CIImage(contentsOf: pic_url)
//        let pic_input = try! HotDogClassifierInput(imageAt: pic_url)
//        do {
//            let prediction = try model.prediction(input: pic_input)
////            print(prediction!.classLabel)
//        } catch {
//            print("issue with coreml")
//        }
//        do {
//
//        } catch {
//            print("issue with coreml")
//        }
//        let items = try fm.con
//        let items = try fm.contentsOfDirectory(atPath: "Public")
//        for item in items {
//            let url = URL.init(fileURLWithPath: "Public/" + item)
//            let ciimage = CIImage(contentsOf: url)
//            print(ciimage)
////            print(url)
////            print("found \(item)")
//        }
//    } catch {
//        print("issue with file")
//    }
    
//    do {
//        let prediction = try model?.prediction(image:
//        print(prediction)
//    } catch {
//        print("shit fuckt")
//    }
    return "no"
}
