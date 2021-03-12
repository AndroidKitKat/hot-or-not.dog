//
// HotDogClassifier.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class HotDogClassifierInput : MLFeatureProvider {

    /// Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high
    var image: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }


    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imageWith image: CGImage) throws {
        let __image = try MLFeatureValue(cgImage: image, pixelsWide: 299, pixelsHigh: 299, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
        self.init(image: __image)
    }


    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imageAt image: URL) throws {
        let __image = try MLFeatureValue(imageAt: image, pixelsWide: 299, pixelsHigh: 299, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
        self.init(image: __image)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImage(with image: CGImage) throws  {
        self.image = try MLFeatureValue(cgImage: image, pixelsWide: 299, pixelsHigh: 299, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImage(with image: URL) throws  {
        self.image = try MLFeatureValue(imageAt: image, pixelsWide: 299, pixelsHigh: 299, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
    }
}


/// Model Prediction Output Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class HotDogClassifierOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// Probability of each category as dictionary of strings to doubles
    lazy var classLabelProbs: [String : Double] = {
        [unowned self] in return self.provider.featureValue(for: "classLabelProbs")!.dictionaryValue as! [String : Double]
    }()

    /// Most likely image category as string value
    lazy var classLabel: String = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")!.stringValue
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(classLabelProbs: [String : Double], classLabel: String) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["classLabelProbs" : MLFeatureValue(dictionary: classLabelProbs as [AnyHashable : NSNumber]), "classLabel" : MLFeatureValue(string: classLabel)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.14, iOS 12.0, tvOS 12.0, *)
@available(watchOS, unavailable)
class HotDogClassifier {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "HotDogClassifier", withExtension:"mlmodelc")!
    }

    /**
        Construct HotDogClassifier instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of HotDogClassifier.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `HotDogClassifier.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct HotDogClassifier instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct HotDogClassifier instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct HotDogClassifier instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<HotDogClassifier, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct HotDogClassifier instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<HotDogClassifier, Error>) -> Void) {
        MLModel.__loadContents(of: modelURL, configuration: configuration) { (model, error) in
            if let error = error {
                handler(.failure(error))
            } else if let model = model {
                handler(.success(HotDogClassifier(model: model)))
            } else {
                fatalError("SPI failure: -[MLModel loadContentsOfURL:configuration::completionHandler:] vends nil for both model and error.")
            }
        }
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as HotDogClassifierInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as HotDogClassifierOutput
    */
    func prediction(input: HotDogClassifierInput) throws -> HotDogClassifierOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as HotDogClassifierInput
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as HotDogClassifierOutput
    */
    func prediction(input: HotDogClassifierInput, options: MLPredictionOptions) throws -> HotDogClassifierOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return HotDogClassifierOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - image: Input image to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 299 pixels wide by 299 pixels high

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as HotDogClassifierOutput
    */
    func prediction(image: CVPixelBuffer) throws -> HotDogClassifierOutput {
        let input_ = HotDogClassifierInput(image: image)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [HotDogClassifierInput]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [HotDogClassifierOutput]
    */
    func predictions(inputs: [HotDogClassifierInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [HotDogClassifierOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [HotDogClassifierOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  HotDogClassifierOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
