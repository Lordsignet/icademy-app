import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:math';
import 'dart:typed_data';
import 'package:epub_view/epub_view.dart' as ep;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart' as p;
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:internet_file/internet_file.dart';
import 'package:racfmn/ui/page/readbooks/speech_txt.dart';





class ReadFileSCreen extends StatefulWidget {
  final String? filename;
  
 ReadFileSCreen({Key? key, this.filename}): super(key: key);
  @override
  _ReadFileSCreenState createState() =>  _ReadFileSCreenState();
}
enum TtsState { playing, stopped }

class  _ReadFileSCreenState extends State<ReadFileSCreen> {
  //bool _isLoading = false;
 // PDFDocument? document;
//late String fileToretuened;
//String textToWrite = "I am programming";
String? _fileExtension;
String? _fileNameUse;
String? _fullfileName;
 PDFDoc? _pdfDoc;
  bool _buttonsEnabled = true;
  bool _playStop = true;
  String _text = "";
  double _percentage = 0.0;
 static const int _initialPage = 1;
 int _actualPageNumber = _initialPage, _allPagesCount = 0;
 bool isSampleDoc = true;
 PdfControllerPinch? _pdfcontroller;
 late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? _newVoiceText;
  PersistentBottomSheetController? _bottomController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
loadDocument(String filenameValue) async {
    
    
      
     bool isPassed =  filenameValue == null ? false : isUrl(filenameValue);
     if(isPassed == true) {
final fullPath = filenameValue;
    print('Is passed1 value is this: ${isPassed}');
  print('Is filenameValue1 value is this: ${filenameValue}');
    return fullPath;

} else {

    
       print(filenameValue);
       var parsedDocument =  parse(filenameValue);
     var tageelement = parsedDocument.getElementsByTagName("a");
     var returnedHref = tageelement[0].attributes["href"];
    String filterdhref = returnedHref?.replaceFirst("../../", Constants.baseHttp) as String;
    final uri =  Uri.parse(filterdhref);
  final lastUri = '${uri.scheme.replaceAll('${uri.scheme}', "https://")}';
  final lastHostname = Constants.stripeslash;
  final pathUri =  uri.path; 
  final fullPath = lastHostname + pathUri;
/*print('Is passed value is this: ${isPassed}');
  print('Is filenameValue value is this: ${filenameValue}'); */
    
    return fullPath;
}   
   
  
  }
bool isUrl(String text) {
try{
Uri.parse(text);
return true;
}on FormatException {
return false;
}
}
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

   ep.EpubController? _epubReaderController;
Uint8List? _documentBytes;
@override
void initState() {
//getPdfBytes();
super.initState();
 SchedulerBinding.instance!.addPostFrameCallback(
      (_) => getPdfBytes());
}
@override
  void dispose() {
    _epubReaderController?.dispose();
    _pdfcontroller?.dispose();
    super.dispose();
     flutterTts.stop();
  }
///Get the PDF document as bytes

 void getPdfBytes() async {
   flutterTts = FlutterTts();
  //var documentBytes;
  
   
  //final String fileName = await loadDocument('${widget.filename!.replaceAll(, Constants.baseHttp)}'); 
  final String fileName = await loadDocument("${widget.filename}"); 
  final baseName = p.basename(fileName);
 // _fileNameUse = 

final fileExtension = p.extension(fileName);
print(fileName);
  final documentBytes = await InternetFile.get('$fileName', process: (percentage) {
  _percentage = percentage;
  });
  print(_percentage + 1);
  final pdfControllers = fileExtension == ".pdf" ? PdfControllerPinch(document: PdfDocument.openData(documentBytes),initialPage: _initialPage) : null;
 final  epubReaderController = fileExtension == ".pdf" ? null : ep.EpubController(
      document: ep.EpubDocument.openData(documentBytes));
    _setAwaitOptions();
    _getDefaultEngine();
    _getDefaultVoice();
      setState(() {
        _fileExtension = fileExtension;
        _fileNameUse = baseName;
        _fullfileName = fileName;
        _documentBytes = documentBytes;
        _epubReaderController = epubReaderController;
        _pdfcontroller = pdfControllers;
      });
       flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
        print(ttsState);
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });
 
}
Future<dynamic> _getLanguages() => flutterTts.getLanguages;
 Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    try {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await _readWholeDoc();
  
      if (_text.isNotEmpty) {
        print("about to begin to play");
        print(_playStop);
        await flutterTts.speak(_text);

      }
    } catch(e) {
      print(e);
    }
    
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
    print(_playStop);
  }
  
List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    _bottomController?.setState!(() {
      language = selectedType;
      flutterTts.setLanguage(language!);
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    });
  }
  
/*Future<Uint8List> _readPdf() async {
   final String fileName = await loadDocument(widget.filename!);
   final fileExtensions = p.extension(fileName);
   var bytesToreturn;
   if(fileExtensions == "pdf") {
    bytesToreturn = await http.readBytes(Uri.parse(fileName));
   } else {
    return bytes.buffer.asUint8List();
  }
  
epubReaderController = EpubController(
      document: EpubReader.readBook(_documentBytes as Uint8List ));
      _pickPDFText();
      
*/

@override
Widget build(BuildContext context) {

print('$_fileExtension' + '$_documentBytes' + '$_epubReaderController');
Widget child = const Center(child: CircularProgressIndicator());
if(_percentage < 100) {
   child = const Center(child: CircularProgressIndicator());
}
else if (_documentBytes != null && _fileExtension != null && _epubReaderController?.document == null && _fileExtension == ".pdf") {
child = PdfViewPinch(
 documentLoader: const Center(child: CircularProgressIndicator(),),
 pageLoader: const Center(child: CircularProgressIndicator(),),
 controller: _pdfcontroller as PdfControllerPinch,
 onDocumentLoaded: (document) {
  setState(() {
    _allPagesCount = document.pagesCount;
  });
 },
 onPageChanged: (page) {
  setState(() {
    _actualPageNumber = page;
  });
 },
 
 
);
} else if(_documentBytes != null &&  _fileExtension != null && _epubReaderController?.document != null && _fileExtension == ".epub") {
  //child = Container();
  child = ep.EpubView(
          builders: ep.EpubViewBuilders<ep.DefaultBuilderOptions>(options: const ep.DefaultBuilderOptions(),
          chapterDividerBuilder: (_) => const Divider()),
          controller: _epubReaderController as ep.EpubController,
        );

} else {
  child = Center(child: Container());
}

return Scaffold(
  
 /*appBar: AppBar(title:  _fileExtension == ".pdf" ? Text('${_fileNameUse.toString().length < 30 ? _fileNameUse : '${_fileNameUse?.substring(0,30)}...'}') 
 : ep.EpubViewActualChapter(controller: _epubReaderController as ep.EpubController,
 builder: (chapterValue) => Text(chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '', textAlign: TextAlign.start,))), */
 appBar: _appbar(),

 floatingActionButton: _fileExtension == ".pdf" ? _buildFloatingACtionButtons(context,Theme.of(context).primaryColor) : null,
drawer: _sideBar(),
body: child,
//drawer: fileExtension == "pdf" ? null : EpubReaderTableOfContents(controller: _epubReaderController!),
);
}
Widget _sideBar() {
  Widget? childed = const Center(child: CircularProgressIndicator());
if(_percentage < 100) {
   childed = const Center(child: CircularProgressIndicator());
}else if (_documentBytes != null && _fileExtension != null && _epubReaderController?.document == null && _fileExtension == ".pdf") {
childed = null;
} else if(_documentBytes != null &&  _fileExtension != null && _epubReaderController?.document != null && _fileExtension == ".epub") {
childed = Drawer(child: ep.EpubViewTableOfContents(controller: _epubReaderController as ep.EpubController));
} else {
  childed = const Center(child: CircularProgressIndicator());
}
return childed as Widget;
}
 Widget _languageDropDownSection(dynamic languages) => Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        DropdownButton(
          value: language,
          items: getLanguageDropDownMenuItems(languages),
          onChanged: changedLanguageDropDownItem,
        ),
        Visibility(
          visible: isAndroid,
          child: Text("Is installed: $isCurrentLanguageInstalled"),
        ),
      ]));
Widget _futureBuilder() => FutureBuilder<dynamic>(
      future: _getLanguages(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _languageDropDownSection(snapshot.data);
        } else if (snapshot.hasError) {
          return Text('Error loading languages...');
        } else
          return Text('Loading Languages...');
      });

_buildFloatingACtionButtons(BuildContext context, Color color) {

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    
  children: [
    FloatingActionButton(
      backgroundColor: color,
      child: ttsState == TtsState.stopped ? Icon(Icons.play_arrow, size: 25,) : Icon(Icons.pause, size: 25,) ,

      onPressed: () {
        if(_pdfDoc == null) {
          Center(child: CircularProgressIndicator(semanticsLabel: "Synthesizing text to speech...",));
        }
        ttsState == TtsState.stopped ? _speak() : _stop();
       
        //  _commentopenDialog();
       /* final screenHeight = MediaQuery.of(context).size.height + 40.0;
        _controller.animateTo(screenHeight, curve: Curves.easeOut, duration: Duration(seconds: 1)); */
       // _focusNode.requestFocus();
      },
      heroTag: Text("Btn1"),),
    SizedBox(
    height: 30,
    ),

    FloatingActionButton(
      backgroundColor: color,
      child: Icon(Icons.settings, size: 25,),
      onPressed: () {
         buiildButtomsheet();
         //Navigator.pushNamed(context, '/SearchPage');
      },
      heroTag: Text("Btn2"),
      ),  
      SizedBox(
        height: 80
      )

  ]
  );
}
_appbar() {
  Widget appBarChild = AppBar(title: CircularProgressIndicator());
  if(_percentage == 100) {
   appBarChild = AppBar(title:  _fileExtension == ".pdf" ? Text('${_fileNameUse.toString().length < 30 ? _fileNameUse : '${_fileNameUse?.substring(0,30)}...'}') 
 : ep.EpubViewActualChapter(controller: _epubReaderController as ep.EpubController,
 builder: (chapterValue) => Text(chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '', textAlign: TextAlign.start,)),
 actions: _fileExtension == ".pdf" ? <Widget>[IconButton(onPressed: () {
  _pdfcontroller?.previousPage(duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
 }, icon: Icon(Icons.navigate_before)
 ), 
 Container(
  alignment: Alignment.center, 
 child: Text('$_actualPageNumber/$_allPagesCount',
 style: TextStyle(fontSize: 22)),
 ),
 IconButton(onPressed: () {
 _pdfcontroller?.nextPage(duration: Duration(milliseconds: 100), curve: Curves.ease);
 }, icon: Icon(Icons.navigate_next)),
 IconButton(onPressed: () {
  if(isSampleDoc) {
    _pdfcontroller?.loadDocument(PdfDocument.openData(_documentBytes!));
  } else {
    _pdfcontroller?.loadDocument(PdfDocument.openData(_documentBytes!));

  }
  isSampleDoc = !isSampleDoc;
 }, icon: Icon(Icons.refresh)
 ) 
 ] : null
 );
  }
  return appBarChild;
}
void buiildButtomsheet() async {
    
     await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) { 
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
            //  _futureBuilder(),
                Text("Settings for tts",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),textAlign: TextAlign.center),
                SizedBox(height: 50),
              _buildSliders(bottomState),
            ],
        )
        );
      });
      },
   );
   
}
 Widget _buildSliders(bottomState) {
    return Column(
      children: [_volume(bottomState), _pitch(bottomState), _rate(bottomState)],
    );
  }

  Widget _volume(bottomState) {
    return Slider(
        value: volume,
        onChanged: (newVolume) {
        bottomState(() => volume = newVolume);
        },
        min: 0.0,
        max: 1.0,
        divisions: 10,
        label: "Volume: $volume");
  }

  Widget _pitch(bottomState) {
    return Slider(
      value: pitch,
      onChanged: (newPitch) {
         bottomState(() => pitch = newPitch);
      },
      min: 0.5,
      max: 2.0,
      divisions: 15,
      label: "Pitch: $pitch",
      activeColor: Colors.red,
    );
  }

  Widget _rate(bottomState) {
    return Slider(
      value: rate,
      onChanged: (newRate) {
      bottomState(() => rate = newRate);
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $rate",
      activeColor: Colors.green,
    );
  }
_pickPDFText() async {
  //  var filePickerResult = await loadDocument(widget.filename!.replaceAll("https://hephziland.org/", Constants.baseHttp));
   // print(filePickerResult);
   //var fileUrl = widget.filename!.replaceAll("https://hephziland.org/", Constants.baseHttp);
   if(_pdfDoc != null) {
      return;
   }
   
    var fileUrl =  _fullfileName;
    if (fileUrl != null) {
     // _pdfDoc = await PDFDoc.fromURL(fileUrl);
     _pdfDoc = await PDFDoc.fromData(fileUrl, _documentBytes);
      setState(() {});
    }
  }

  /// Reads a random page of the document
  Future _readRandomPage() async {
    await _pickPDFText();
    if (_pdfDoc == null) {
      return;
    }
    setState(() {
      _buttonsEnabled = false;
    });

    String text =
        await _pdfDoc!.pageAt(Random().nextInt(_pdfDoc!.length) + 1).text;

    setState(() {
      _text = text;
      _buttonsEnabled = true;
    });
  }
   Future _readWholeDoc() async {
   await _pickPDFText();
    if (_pdfDoc == null) {
      return;
    }
   /* setState(() {
      _buttonsEnabled = false;
    });
*/
    String text = await _pdfDoc!.pageAt(_actualPageNumber).text;
    setState(() {
      _text = text;
    //  _buttonsEnabled = true;
    });
  
   }
}


