import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _videoPlayerController.value.isPlaying ? _videoPlayerController.pause() : _videoPlayerController.play();
    });
  }

  void _resetVideo() {
    _videoPlayerController.seekTo(Duration.zero);
    _videoPlayerController.play();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoPlayerController.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _seekForward() {
    final newPosition = _videoPlayerController.value.position + const Duration(seconds: 5);
    _videoPlayerController.seekTo(newPosition);
  }

  void _seekBackward() {
    final newPosition = _videoPlayerController.value.position - const Duration(seconds: 5);
    _videoPlayerController.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio, // Keeps original aspect ratio
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_videoPlayerController),
                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(Icons.replay_5, _seekBackward),
                          _buildControlButton(
                              _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              _togglePlayPause),
                          _buildControlButton(Icons.forward_5, _seekForward),
                          _buildControlButton(Icons.replay, _resetVideo),
                          _buildControlButton(_isMuted ? Icons.volume_off : Icons.volume_up, _toggleMute),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}
