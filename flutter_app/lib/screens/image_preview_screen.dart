// Enhanced Image Preview Screen with better UX and animations
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePreviewScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const ImagePreviewScreen({super.key, required this.imageBytes});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen>
    with TickerProviderStateMixin {
  final TextEditingController _captionController = TextEditingController();
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isTyping = false;
  bool _showImageControls = true;
  final FocusNode _captionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    // Start animations
    _slideController.forward();
    _fadeController.forward();
    
    // Listen to text changes
    _captionController.addListener(() {
      setState(() {
        _isTyping = _captionController.text.isNotEmpty;
      });
    });
    
    // Listen to focus changes
    _captionFocus.addListener(() {
      setState(() {
        _showImageControls = !_captionFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _captionFocus.dispose();
    super.dispose();
  }

  void _onSend() async {
    // Add haptic feedback
    HapticFeedback.selectionClick();
    
    // Animate out before closing
    await _slideController.reverse();
    
    if (mounted) {
      Navigator.pop(context, {
        'bytes': widget.imageBytes,
        'caption': _captionController.text.trim(),
      });
    }
  }

  void _onBack() async {
    await _slideController.reverse();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildAppBar(isDark),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Image display area
            Expanded(
              child: Stack(
                children: [
                  // Background blur effect
                  Positioned.fill(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Image.memory(
                        widget.imageBytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  // Main image
                  Center(
                    child: Hero(
                      tag: 'image_preview',
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(
                            widget.imageBytes,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Image controls overlay
                  if (_showImageControls)
                    _buildImageControls(),
                ],
              ),
            ),
            
            // Caption input area
            _buildCaptionArea(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: _onBack,
          ),
          title: const Text(
            'Preview Image',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            AnimatedScale(
              scale: _isTyping ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isTyping 
                          ? Colors.blue.withOpacity(0.8)
                          : Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isTyping 
                            ? Colors.blue
                            : Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: _onSend,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageControls() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildControlButton(
              icon: Icons.zoom_in,
              onTap: () {
                // Implement zoom functionality
                HapticFeedback.lightImpact();
              },
            ),
            const SizedBox(height: 12),
            _buildControlButton(
              icon: Icons.crop_rotate,
              onTap: () {
                // Implement rotate functionality
                HapticFeedback.lightImpact();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCaptionArea(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black,
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isTyping) ...[
              Text(
                'Caption',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _captionFocus.hasFocus
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _captionController,
                focusNode: _captionFocus,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Add a caption...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  suffixIcon: _isTyping
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white70,
                            size: 20,
                          ),
                          onPressed: () {
                            _captionController.clear();
                            HapticFeedback.lightImpact();
                          },
                        )
                      : null,
                ),
                onSubmitted: (_) => _onSend(),
              ),
            ),
            
            if (_isTyping) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Press Enter to send or tap the send button',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}