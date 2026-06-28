import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FaqItemWidget extends StatefulWidget {
  final String question;
  final String answer;
  final String category;

  const FaqItemWidget({
    Key? key,
    required this.question,
    required this.answer,
    required this.category,
  }) : super(key: key);

  @override
  State<FaqItemWidget> createState() => _FaqItemWidgetState();
}

class _FaqItemWidgetState extends State<FaqItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color _getCategoryColor() {
    switch (widget.category.toLowerCase()) {
      case 'account':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'transactions':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'wallet':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'security':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getCategoryIcon() {
    switch (widget.category.toLowerCase()) {
      case 'account':
        return 'account_circle';
      case 'transactions':
        return 'swap_horiz';
      case 'wallet':
        return 'account_balance_wallet';
      case 'security':
        return 'security';
      default:
        return 'help';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Question Header
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Category Icon
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getCategoryIcon(),
                        color: categoryColor,
                        size: 16,
                      ),
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Question Text
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Expand/Collapse Icon
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Answer Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                    height: 1,
                  ),
                  SizedBox(height: 2.h),
                  
                  // Category Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.category.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Answer Text
                  Text(
                    widget.answer,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Helpful Actions
                  Row(
                    children: [
                      Text(
                        'Was this helpful?',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Thank you for your feedback!')),
                          );
                        },
                        icon: CustomIconWidget(
                          iconName: 'thumb_up',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 16,
                        ),
                        constraints: BoxConstraints(minWidth: 8.w, minHeight: 8.w),
                        padding: EdgeInsets.all(1.w),
                      ),
                      
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Thank you for your feedback!')),
                          );
                        },
                        icon: CustomIconWidget(
                          iconName: 'thumb_down',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        constraints: BoxConstraints(minWidth: 8.w, minHeight: 8.w),
                        padding: EdgeInsets.all(1.w),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
