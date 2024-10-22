import 'dart:io';

import 'package:demo/MyModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'ImageUtils.dart';

class CommonPageLayout extends StatefulWidget {
  final String text;
  final String image;
  final bool showDecoration;
  final Widget? additionalChild;

  CommonPageLayout({
    required this.text,
    required this.image,
    required this.showDecoration,
    required this.additionalChild,
  });

  @override
  _CommonPageLayoutState createState() => _CommonPageLayoutState();
}

class _CommonPageLayoutState extends State<CommonPageLayout> {
  MyModel? myModel;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    myModel = Provider.of<MyModel>(context, listen: false);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildDescriptionSection(String description) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[Text(
                      description,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontSize: 16, color: Colors.purpleAccent),
                    ),
            ]
      );
  }

  void ButtonHelper(File? file, BuildContext context) async {
    String? link = '';
    String? flower;
    if (file != null) {
      if (myModel != null) {
        List<String>? values = await myModel?.classifyImage(file);

        if (values != null) {
          flower = values[0];
          link = values[1];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommonPageLayout(
                  text: 'The flower identified is: ' + flower!,
                  image: file.path,
                  showDecoration: false,
                  additionalChild: _buildDescriptionSection(link!)),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommonPageLayout(
                  text: ' Error during identification',
                  image: 'Images/Detective.png',
                  showDecoration: true,
                  additionalChild: null),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ch = [];
    if (widget.additionalChild != null)
      ch = [
        SizedBox(height: 20),
        widget.additionalChild!,
        SizedBox(height: 20)
      ];
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text('Flower D\'techtion'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'Images/App_Icon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: widget.showDecoration
                        ? BoxDecoration(
                            color: Colors.white,
                          )
                        : null,
                    child: widget.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: widget.showDecoration
                                ? Image.asset(
                                    widget.image,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  )
                                : Image.file(File(widget.image),
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.contain),
                          )
                        : CommonPageLayout(
                            text:
                                'Upload an image with a flower for identification',
                            image: 'Images/Detective.png',
                            showDecoration: true,
                            additionalChild: null),
                  ),
                  widget.additionalChild != null
                      ? Column(children: ch)
                      : SizedBox(height: 20),
                  GrooveButton(
                    text: 'Take a picture',
                    onPressed: () async {
                      final File? file = await ImageUtils().takePicture();
                      ButtonHelper(file, context);
                    },
                  ),
                  SizedBox(height: 10),
                  GrooveButton(
                    text: 'Gallery',
                    onPressed: () async {
                      final File? file = await ImageUtils().selectFromGallery();
                      ButtonHelper(file, context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GrooveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GrooveButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 1),
        side: BorderSide(
          color: Colors.blueAccent,
          width: 3.0,
          style: BorderStyle.solid,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
