// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ulearna_reels/domain/entities/reel.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelCard extends StatefulWidget {
  final Reel reel;

  const ReelCard({Key? key, required this.reel}) : super(key: key);

  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideoPlayer();
    });
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.network(widget.reel.videoUrl);

    try {
      // await _controller.initialize();
      await _controller.setLooping(true);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play(); // autoplay
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.8 && _isInitialized && !_isPlaying) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    } else if (info.visibleFraction < 0.8 && _isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.reel.id.toString()),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video Player or Thumbnail
            _isInitialized
                ? GestureDetector(
                  onTap: _togglePlayPause,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                )
                : const Center(child: CircularProgressIndicator()),

            // Play/Pause Button
            if (_isInitialized && !_isPlaying)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              ),

            // Video Info
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            widget.reel.thumbcdnurl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Reel title
                    Text(
                      widget.reel.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Reel description
                    if (widget.reel.description.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        widget.reel.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
