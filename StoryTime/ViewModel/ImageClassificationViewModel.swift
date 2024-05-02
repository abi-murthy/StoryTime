//
//  ImageClassifierViewModel.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/28/24.
//

import Foundation


import CoreML
import Vision
import SwiftUI
import Combine

class ImageClassificationViewModel: ObservableObject {
    @Published var classificationLabel: String = "Take a picture to start classification"

    private var model: VNCoreMLModel?

    init() {
        loadModel()
    }

    private func loadModel() {
        do {
            let configuration = MLModelConfiguration()
            model = try VNCoreMLModel(for: MobileNetV2(configuration: configuration).model)
        } catch {
            print(error) //load model
        }
    }

    func classifyImage(_ image: UIImage) {
        guard let model = model else {
            classificationLabel = "Model is not loaded."
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in // uses inceptions v3 model to make a prediciton based on the model
            DispatchQueue.main.async {
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    self?.classificationLabel = "\(topResult.identifier)" //updates in main queue for UI updates
                } else {
                    self?.classificationLabel = "Classification failed." //this request defines the actual request and the callback after
                }
            }
        }

        guard let ciImage = CIImage(image: image) else {
            classificationLabel = "Failed to convert UIImage to CIImage."
            return
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async { //this is the actual requeust
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.classificationLabel = "Image classification failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func clearClassification(){
        classificationLabel = ""
    }
}
