import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(
    title: 'Sports Streaming',
    theme: ThemeData.dark(),
    home: StreamMenuPage(),
  ));
}

// -----------------------
// Página principal (menú)
// -----------------------
class StreamMenuPage extends StatelessWidget {
  final List<Map<String, String>> streams = [
    {
      'title': 'ESPN Premium',
      'url': 'https://m2.merichunidya.com:999/hls/capespnprem.m3u8?md5=bdW_qvbWrywibbKXLCCAmA&expires=1746659495',
    },
    {
      'title': 'Win Sports+',
      'url': 'https://m1.merichunidya.com:999/hls/winsportsplus.m3u8?md5=mTiRAnOxwm3AI7y7Su8pvQ&expires=1746658184',
    },
    {
      'title': 'TNT Argentina',
      'url': 'https://m3.merichunidya.com:999/hls/captntarg.m3u8?md5=SDm5ZTfZvahfJ63lLnhzPg&expires=1746659610',
    },
    {
      'title': 'Gol Perú',
      'url': 'https://m1.merichunidya.com:999/hls/capgolperu.m3u8?md5=d5njHJebNPBwIH-ugZRTxg&expires=1746659670',
    },
    {
      'title': 'Fox Sports',
      'url': 'https://linear-211.frequency.stream/dist/localnow/211/hls/master/playlist.m3u8',
    },
    {
      'title': 'TyC Sports',
      'url': 'https://edge6a.v2.mediastream.pe/live/tycsports/playlist.m3u8',
    },
    {
      'title': 'ESPN',
      'url': 'https://livees.pw/stream/espn.m3u8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sports Streaming')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: streams.length,
        itemBuilder: (context, index) {
          final stream = streams[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text(stream['title']!, style: TextStyle(fontSize: 18)),
              onPressed: () {
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
            ),
          );
        },
      ),
    );
  }
}

// -----------------------
// Página del reproductor
// -----------------------
class VideoPage extends StatefulWidget {
  final String title;
  final String videoUrl;

  VideoPage({required this.title, required this.videoUrl});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  final Map<String, String> customHeaders = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:138.0) Gecko/20100101 Firefox/138.0',
    'Accept': '*/*',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate, br, zstd',
    'Referer': 'https://capo5play.com/',
    'Origin': 'https://capo5play.com',
    'Connection': 'keep-alive',
  };

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: customHeaders,
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
