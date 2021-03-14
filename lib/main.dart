import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {

  bool playing = false;
  IconData playButton = Icons.play_arrow;

  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  Widget slider(){
    return Container(
      width: 300,
      child: Slider.adaptive(
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value){
          seekToSec(value.toInt());
      }),
    );
  }

  void seekToSec(int sec){
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

@override
  void initState(){
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);
    _player.durationHandler = (d){
      setState(() {
        musicLength = d;
      });
    };
    _player.positionHandler = (p){
      setState(() {
        position = p;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green[500],
              Colors.green[400],
              Colors.green[300],
              Colors.green[200],
            ]
          )
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 49),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:12.0),
                  child: Text(
                    "Music Beats",
                    style: TextStyle(
                        color:Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:12.0),
                  child: Text(
                    "Listen to your favorite music",
                    style: TextStyle(
                        color:Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((30)),
                      image: DecorationImage(
                        image: AssetImage("assets/adele.png"),
                      )
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Center(
                  child: Text(
                    "Someone Like You",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Container(
                          width: 500,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${position.inMinutes}:${position.inSeconds.remainder(60)}",
                                style: TextStyle(fontSize: 20),
                              ),
                              slider(),
                              Text("${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              iconSize:45,
                              color: Colors.black,
                              onPressed: (){},
                              icon: Icon(Icons.skip_previous),
                            ),
                            IconButton(
                              iconSize:65,
                              color: Colors.black,
                              onPressed: (){
                                if(!playing){
                                  cache.play("Adele.mp3");
                                  setState(() {
                                    playButton = Icons.pause;
                                    playing = true;
                                  });
                                }
                                else{
                                  _player.pause();
                                  setState(() {
                                    playButton = Icons.play_arrow;
                                    playing = false;
                                  });
                                }
                              },
                              icon: Icon(playButton),
                            ),
                            IconButton(
                              iconSize:45,
                              color: Colors.black,
                              onPressed: (){},
                              icon: Icon(Icons.skip_next),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
