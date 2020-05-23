import Flutter
import UIKit
import PDFKit

@available(iOS 11, *)
public class SwiftPdfTextPackagePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "pdf_text_package", binaryMessenger: registrar.messenger())
    let instance = SwiftPdfTextPackagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  @available(iOS 11, *)
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

      DispatchQueue.global(qos: .default).async {
        if call.method == "getPDFtext" {
          let args = call.arguments as! NSDictionary
          let path = args["path"] as! String
          var pdfText = ""

            if let pdf = PDFDocument(url: URL(fileURLWithPath: path)) {
            let pageCount = pdf.pageCount
          
              for i in 1 ..< pageCount {
                  let pageContent = pdf.page(at: i)!.string!
                  pdfText += pageContent
              }
                DispatchQueue.main.sync {
                  result(pdfText);
                }
            }
            else
            {
                DispatchQueue.main.sync {
                  result(FlutterError(code: "NO_PATH",
                  message: "Path cannot be found",
                  details: nil))
                }
            }
        }       
        else {
                DispatchQueue.main.sync {
                  result(FlutterMethodNotImplemented)
                }
        }
      }
  }
}
