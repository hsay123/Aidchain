import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QrCodeDisplayWidget extends StatefulWidget {
  final String amount;
  final String reason;
  final String transactionId;
  final VoidCallback onClose;
  final VoidCallback onShare;

  const QrCodeDisplayWidget({
    Key? key,
    required this.amount,
    required this.reason,
    required this.transactionId,
    required this.onClose,
    required this.onShare,
  }) : super(key: key);

  @override
  State<QrCodeDisplayWidget> createState() => _QrCodeDisplayWidgetState();
}

class _QrCodeDisplayWidgetState extends State<QrCodeDisplayWidget>
    with TickerProviderStateMixin {
  Timer? _countdownTimer;
  int _remainingSeconds = 1800; // 30 minutes
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  String get _qrCodeData {
    final qrData = {
      'type': 'aidchain_cashout',
      'transaction_id': widget.transactionId,
      'amount': widget.amount,
      'reason': widget.reason,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': DateTime.now()
          .add(const Duration(minutes: 30))
          .millisecondsSinceEpoch,
      'signature': _generateSignature(),
    };
    return jsonEncode(qrData);
  }

  String _generateSignature() {
    final random = Random();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            timer.cancel();
            _showExpiryDialog();
          }
        });
      }
    });
  }

  void _showExpiryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'access_time',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'QR Code Expired',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        content: Text(
          'This QR code has expired for security reasons. Please generate a new one.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onClose();
            },
            child: Text('Generate New Code'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onClose,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Cash Out QR Code',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onShare,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      SizedBox(height: 4.h),

                      // QR Code Container
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 70.w,
                              height: 70.w,
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // QR Code Pattern Simulation
                                      Container(
                                        width: 50.w,
                                        height: 50.w,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: CustomPaint(
                                          painter: QRCodePainter(_qrCodeData),
                                          size: Size(50.w, 50.w),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 4.h),

                      // Transaction Details
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                                'Amount', '\$${widget.amount}', 'attach_money'),
                            SizedBox(height: 2.h),
                            _buildDetailRow(
                                'Reason', widget.reason, 'description'),
                            SizedBox(height: 2.h),
                            _buildDetailRow('Transaction ID',
                                widget.transactionId, 'fingerprint'),
                            SizedBox(height: 2.h),
                            _buildDetailRow(
                              'Expires in',
                              _formatTime(_remainingSeconds),
                              'access_time',
                              isCountdown: true,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Agent Instructions
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'info',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Instructions for Agent',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            _buildInstructionStep(
                                '1',
                                'Scan this QR code with your agent app',
                                'qr_code_scanner'),
                            SizedBox(height: 1.h),
                            _buildInstructionStep(
                                '2', 'Verify transaction details', 'verified'),
                            SizedBox(height: 1.h),
                            _buildInstructionStep(
                                '3', 'Provide cash to beneficiary', 'payments'),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String iconName,
      {bool isCountdown = false}) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: isCountdown && _remainingSeconds < 300
              ? AppTheme.lightTheme.colorScheme.error
              : Colors.white.withValues(alpha: 0.8),
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: isCountdown && _remainingSeconds < 300
                      ? AppTheme.lightTheme.colorScheme.error
                      : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(
      String step, String instruction, String iconName) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        CustomIconWidget(
          iconName: iconName,
          color: Colors.white.withValues(alpha: 0.8),
          size: 18,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            instruction,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }
}

class QRCodePainter extends CustomPainter {
  final String data;

  QRCodePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final blockSize = size.width / 25;
    final random = Random(data.hashCode);

    // Generate a pattern based on the data
    for (int i = 0; i < 25; i++) {
      for (int j = 0; j < 25; j++) {
        if (random.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(
              i * blockSize,
              j * blockSize,
              blockSize * 0.9,
              blockSize * 0.9,
            ),
            paint,
          );
        }
      }
    }

    // Draw corner squares
    _drawCornerSquare(canvas, paint, 0, 0, blockSize);
    _drawCornerSquare(canvas, paint, 18 * blockSize, 0, blockSize);
    _drawCornerSquare(canvas, paint, 0, 18 * blockSize, blockSize);
  }

  void _drawCornerSquare(
      Canvas canvas, Paint paint, double x, double y, double blockSize) {
    // Outer square
    canvas.drawRect(
      Rect.fromLTWH(x, y, blockSize * 7, blockSize * 7),
      paint,
    );

    // Inner square (black)
    final blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(x + blockSize, y + blockSize, blockSize * 5, blockSize * 5),
      blackPaint,
    );

    // Center square (white)
    canvas.drawRect(
      Rect.fromLTWH(
          x + blockSize * 2, y + blockSize * 2, blockSize * 3, blockSize * 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
