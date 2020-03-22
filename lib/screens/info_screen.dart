import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../constants/constants.dart';

class InfoScreen extends StatefulWidget {
  static const routeName = '/info-screen';
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  VideoPlayerController _controller1;
  VideoPlayerController _controller2;

  @override
  void initState() {
    _controller1 =
        VideoPlayerController.asset("assets/videos/whatiscorona.mp4");
    _controller1.initialize().then((_) => setState(() {}));

    _controller2 = VideoPlayerController.asset("assets/videos/whatandhow.mkv");
    _controller2.initialize().then((_) => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context)),
                  Text(
                    'About COVID-19',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.blueAccent),
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () => _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                          textColor: Colors.greenAccent,
                            label: 'Open Website',
                            onPressed: () => launch(
                                'https://www.who.int/emergencies/diseases/novel-coronavirus-2019')),
                        content: Text(
                          'Video Source: https://www.who.int/emergencies/diseases/novel-coronavirus-2019',
                          textAlign: TextAlign.center,
                          style: kNormalTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('What is Corona Virus ?', style: kHeadingTextStyle),
              playVideo(_controller1),
              SizedBox(height: 20),
              Text('How to Protect Yourself ?', style: kHeadingTextStyle),
              playVideo(_controller2),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Container playVideo(VideoPlayerController controller) {
    return Container(
      padding: EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: _controller1.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(controller),
            ClosedCaption(text: controller.value.caption.text),
            _PlayPauseOverlay(controller: controller),
            VideoProgressIndicator(controller, allowScrubbing: true),
          ],
        ),
      ),
    );
  }
}

class _PlayPauseOverlay extends StatefulWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  __PlayPauseOverlayState createState() => __PlayPauseOverlayState();
}

class __PlayPauseOverlayState extends State<_PlayPauseOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.controller.value.isPlaying
                  ? widget.controller.pause()
                  : widget.controller.play();
            });
          },
        ),
      ],
    );
  }
}
