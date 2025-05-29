import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(SportsStreamingApp());
}

class SportsStreamingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deporte en Vivo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
        fontFamily: 'Roboto',
        cardColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: StreamMainPage(),
    );
  }
}

class StreamMainPage extends StatelessWidget {
  final List<Map<String, String>> streams = [
    {
      'title': 'ESPN',
      'url': 'https://livees.pw/stream/espn.m3u8',
    },
    {
      'title': 'Fox Sports',
      'url': 'https://linear-211.frequency.stream/dist/localnow/211/hls/master/playlist.m3u8',
    },
    {
      'title': 'TyC Sports',
      'url': 'https://edge6a.v2.media.stream.pe/live/tycsports/playlist.m3u8',
    },
    {
      'title': 'Win Sports',
      'url': 'https://tv.win.m3u8', // <- reemplaza por uno funcional
    },
    {
      'title': 'TNT Sports',
      'url': 'https://tv.tnt.m3u8', // <- reemplaza por uno funcional
    },
    {
      'title': 'DirecTV Sports',
      'url': 'https://tv.directv.m3u8', // <- reemplaza por uno funcional
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canales Deportivos'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 2,
        ),
        itemCount: streams.length,
        itemBuilder: (context, index) {
          final stream = streams[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPage(
                    title: stream['title']!,
                    videoUrl: stream['url']!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tv, size: 48, color: Colors.blueAccent),
                    SizedBox(height: 8),
                    Text(
                      stream['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String title;
  final String videoUrl;

  const VideoPage({required this.title, required this.videoUrl});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _isInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                VideoProgressIndicator(_controller, allowScrubbing: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                  ],
                )
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}