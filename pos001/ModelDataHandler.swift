//
//  ModelDataHandler.swift
//  pos001
//
//  Created by 성재 on 2021/07/11.
//

import Foundation
import UIKit
import TensorFlowLite
import Accelerate

typealias FileInfo = (name: String, extension: String)

struct Result {
    let arrtf: [Float]
}

enum MobileNet {
    static let modelInfo: FileInfo = (name:"color_final",extension:"tflite")
}

class ModelDataHandler {
    //let threadCount:Int
    private var interpreter: Interpreter

   // init? (modelFileInfo: FileInfo, threadCount: Int = 1) {
    init? () {

        //let modelFilename = modelFileInfo.name

        // Construct the path to the model file.
        guard let modelPath = Bundle.main.path(
          forResource: "color_final",
          ofType: "tflite"
        ) else {
          print("Failed to load the model file with name:.")
          return nil
        }
        // Specify the options for the `Interpreter`.
        let options = Interpreter.Options()
        do {
          // Create the `Interpreter`.
          interpreter = try Interpreter(modelPath: modelPath, options: options)
          // Allocate memory for the model's input `Tensor`s.
          try interpreter.allocateTensors()
        } catch let error {
          print("Failed to create the interpreter with error: \(error.localizedDescription)")
          return nil
        }
    }

    func runModel(onFrame Ucolor: UIColor) -> Result? {
        let outputTensor: Tensor
        do {
            _ = try interpreter.input(at: 0)

//            var floats = [[Int]](repeating: Array(repeating: 0, count: 1), count: 2)
//            let myColorComponents = Ucolor.components
//            floats[0][0] = (Int(myColorComponents.red*255.0))
//            floats[1][0] = (Int(myColorComponents.green*255.0))
//            floats[2][0] = (Int(myColorComponents.blue*255.0))
            var floats = [Float32](repeating: 0, count: 3)
            let myColorComponents = Ucolor.components
            floats[0] = (Float32(myColorComponents.red*255.0))
            floats[1] = (Float32(myColorComponents.green*255.0))
            floats[2] = (Float32(myColorComponents.blue*255.0))
            print("floats : %d",floats.count)
            print(floats[0], floats[1], floats[2])
//            print("float count: ",floats[0].count)
            let Data_floats = Data(copyingBufferOf: floats)
            print(Data_floats)
            try interpreter.copy(Data_floats, toInputAt: 0)

            try interpreter.invoke()
            outputTensor = try interpreter.output(at: 0)
        } catch let error {
            print("Failed to invoke the interpreter with error: \(error.localizedDescription)")
                return nil
        }
        let result: [Float]
        result = [Float32](unsafeData: outputTensor.data) ?? []
        return Result(arrtf: result)
    }
}

extension Data {
    init<T>(copyingBufferOf array: [T]) {
        self = array.withUnsafeBufferPointer(Data.init)
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

extension Array {
    init?(unsafeData: Data) {
        guard unsafeData.count % MemoryLayout<Element>.stride == 0 else { return nil }
        #if swift(>=5.0)
        self = unsafeData.withUnsafeBytes { .init($0.bindMemory(to: Element.self)) }
        #else
        self = unsafeData.withUnsafeBytes {
          .init(UnsafeBufferPointer<Element>(
            start: $0,
            count: unsafeData.count / MemoryLayout<Element>.stride
          ))
        }
        #endif  // swift(>=5.0)
    }
}
