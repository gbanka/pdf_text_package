package com.example.pdf_text_package;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.tom_roush.pdfbox.pdmodel.PDDocument;
import com.tom_roush.pdfbox.text.PDFTextStripper;
import com.tom_roush.pdfbox.util.PDFBoxResourceLoader;

import java.io.File;
import java.io.IOException;
import android.util.Log;

/** PdfTextPackagePlugin */
public class PdfTextPackagePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "pdf_text_package");
    channel.setMethodCallHandler(this);
    PDFBoxResourceLoader.init(flutterPluginBinding.getApplicationContext());
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "pdf_text_package");
    channel.setMethodCallHandler(new PdfTextPackagePlugin());
    PDFBoxResourceLoader.init(registrar.activity().getApplicationContext());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    // Get the method call from Dart side
    if (call.method.equals("getPDFtext")) {

      String parsedText = null;
      PDDocument document = null;

      // Parse the path from arguments
      final String path = call.argument("path");

      // Get the DPF document from the path
      try {
        File renderFile = new File(path);
        document = PDDocument.load(renderFile);    

      } catch(IOException e) {
        Log.e("Flutter-Read-Pdf-Plugin", "Exception thrown while loading document", e);
      }
      try {
        // Create stripper that can parse the pdf document.
        PDFTextStripper pdfStripper = new PDFTextStripper();

        // Get the text/strings from the document
        parsedText = pdfStripper.getText(document);
      }
      catch (IOException e)
     {
        Log.e("Flutter-Read-Pdf-Plugin", "Exception thrown while stripping text", e);
     } 
     finally {
        try {
          // Close the document when done
          if (document != null) document.close();
        }
        catch (IOException e)
        {
          Log.e("Flutter-Read-Pdf-Plugin", "Exception thrown while closing document", e);
        }
     }
    // Return the parsedText to Dart
    result.success(parsedText);

    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
