
import 'package:camera/camera.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';

import 'scanner_screen.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller?.initialize();
      await _controller?.setFlashMode(FlashMode.off);
    } catch (e) {
      print('Error al inicializar la cámara: $e');
    } finally {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Escanea tu ticket'),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                CameraPreview(_controller!),
                Positioned(
                  top: 10,
                  right: 10.0,
                  child: IconButton(
                    icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
                    color: Colors.white,
                    onPressed: () async {
                      if (_controller?.value.flashMode == FlashMode.always) {
                        await _controller?.setFlashMode(FlashMode.off);
                        setState(() {
                          isFlashOn = false;
                        });
                      } else {
                        await _controller?.setFlashMode(FlashMode.always);
                        setState(() {
                          isFlashOn = true;
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.outline,),
        onPressed: () async {
          try {
            final XFile? image = await _controller?.takePicture();

            // Aquí se está devolviendo la ruta de la imagen a la pantalla anterior
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScannerView(image?.path)));
            //Navigator.pop(context, image?.path);
  
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}