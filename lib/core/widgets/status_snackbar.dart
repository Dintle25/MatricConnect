import 'package:flutter/material.dart';
import '../network/api_error_mapper.dart';

/// A nicer alternative to the default SnackBar. It slides down from
/// the top, sits for a moment, then slides back up on its own. Used
/// for both errors and happy "you're all caught up" style messages.
class StatusSnackbar {
  StatusSnackbar._();

  static void showError(BuildContext context, Object error, {VoidCallback? onRetry}) {
    final friendly = ApiErrorMapper.map(error);
    _show(
      context,
      icon: friendly.icon,
      color: friendly.color,
      title: friendly.title,
      message: friendly.message,
      actionLabel: friendly.canRetry && onRetry != null ? 'Retry' : null,
      onAction: onRetry,
    );
  }

  static void showSuccess(BuildContext context, String title, String message) {
    _show(
      context,
      icon: Icons.check_circle_rounded,
      color: const Color(0xFF3F9D6F),
      title: title,
      message: message,
    );
  }

  static void _show(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _AnimatedBanner(
        icon: icon,
        color: color,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: () {
          onAction?.call();
          entry.remove();
        },
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

class _AnimatedBanner extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback onAction;
  final VoidCallback onDismiss;

  const _AnimatedBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.onAction,
    required this.onDismiss,
    this.actionLabel,
  });

  @override
  State<_AnimatedBanner> createState() => _AnimatedBannerState();
}

class _AnimatedBannerState extends State<_AnimatedBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Auto-dismiss after a few seconds unless the student taps it away.
    Future.delayed(const Duration(seconds: 4), _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _fade,
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, topPadding == 0 ? 12 : 4, 16, 0),
                child: GestureDetector(
                  onTap: _dismiss,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(widget.icon, color: widget.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(
                                widget.message,
                                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.3),
                              ),
                              if (widget.actionLabel != null) ...[
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: widget.onAction,
                                  child: Text(
                                    widget.actionLabel!,
                                    style: TextStyle(
                                      color: widget.color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
