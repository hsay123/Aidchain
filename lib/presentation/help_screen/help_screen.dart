import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/contact_card_widget.dart';
import './widgets/faq_item_widget.dart';
import './widgets/help_category_widget.dart';
import './widgets/emergency_contact_widget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock FAQ data
  final List<Map<String, dynamic>> _faqs = [
    {
      "category": "account",
      "question": "How do I create an account?",
      "answer": "To create an account, download the AidChain app and follow the registration process. You'll need to provide basic information and complete KYC verification.",
    },
    {
      "category": "account",
      "question": "How do I reset my password?",
      "answer": "On the login screen, tap 'Forgot Password' and enter your email address. You'll receive a password reset link.",
    },
    {
      "category": "transactions",
      "question": "How do I check my transaction history?",
      "answer": "Go to the 'Transactions' tab in your dashboard to view all your transaction history with detailed information.",
    },
    {
      "category": "transactions",
      "question": "How long do transactions take to process?",
      "answer": "Most transactions are processed within 2-5 minutes. However, during high network activity, it may take longer.",
    },
    {
      "category": "wallet",
      "question": "What is a blockchain wallet?",
      "answer": "A blockchain wallet is a digital wallet that allows you to securely store and manage your digital assets on the blockchain.",
    },
    {
      "category": "wallet",
      "question": "How do I generate a QR code for cash withdrawal?",
      "answer": "In your dashboard, tap 'Request Cash Out', enter the amount and reason, then generate your QR code to show to an authorized agent.",
    },
    {
      "category": "security",
      "question": "Is my data secure?",
      "answer": "Yes, AidChain uses advanced encryption and blockchain technology to ensure your data and transactions are secure.",
    },
    {
      "category": "security",
      "question": "What is two-factor authentication?",
      "answer": "Two-factor authentication adds an extra layer of security by requiring a second form of verification when logging in.",
    },
  ];

  // Contact information
  final List<Map<String, dynamic>> _contacts = [
    {
      "type": "phone",
      "title": "Call Support",
      "value": "+1-800-AID-HELP",
      "description": "Available 24/7 for urgent issues",
      "icon": "phone",
    },
    {
      "type": "email",
      "title": "Email Support",
      "value": "support@aidchain.org",
      "description": "Response within 24 hours",
      "icon": "email",
    },
    {
      "type": "chat",
      "title": "Live Chat",
      "value": "Start Chat",
      "description": "Available Mon-Fri 9AM-6PM",
      "icon": "chat",
    },
  ];

  // Help categories
  final List<Map<String, dynamic>> _categories = [
    {
      "title": "Getting Started",
      "icon": "play_circle",
      "description": "Learn the basics of using AidChain",
      "articles": 8,
    },
    {
      "title": "Account Management",
      "icon": "account_circle",
      "description": "Managing your profile and settings",
      "articles": 12,
    },
    {
      "title": "Transactions",
      "icon": "swap_horiz",
      "description": "Understanding payments and transfers",
      "articles": 15,
    },
    {
      "title": "Security",
      "icon": "security",
      "description": "Keeping your account safe",
      "articles": 10,
    },
    {
      "title": "Troubleshooting",
      "icon": "build",
      "description": "Common issues and solutions",
      "articles": 20,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _faqs;
    
    return _faqs.where((faq) {
      final question = faq['question'].toString().toLowerCase();
      final answer = faq['answer'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return question.contains(query) || answer.contains(query);
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _contactSupport(String type, String value) {
    switch (type) {
      case 'phone':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Calling $value...')),
        );
        break;
      case 'email':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening email to $value...')),
        );
        break;
      case 'chat':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Starting live chat...')),
        );
        break;
    }
  }

  void _openCategory(String categoryTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $categoryTitle articles...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Help & Support'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'FAQ'),
            Tab(text: 'Contact'),
            Tab(text: 'Guides'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // FAQ Tab
          _buildFaqTab(),
          
          // Contact Tab
          _buildContactTab(),
          
          // Guides Tab
          _buildGuidesTab(),
        ],
      ),
    );
  }

  Widget _buildFaqTab() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: EdgeInsets.all(4.w),
          color: AppTheme.lightTheme.colorScheme.surface,
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search frequently asked questions...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ),

        // FAQ List
        Expanded(
          child: _filteredFaqs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'search_off',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No results found',
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Try different search terms or browse categories',
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: _filteredFaqs.length,
                  itemBuilder: (context, index) {
                    final faq = _filteredFaqs[index];
                    return FaqItemWidget(
                      question: faq['question'],
                      answer: faq['answer'],
                      category: faq['category'],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emergency Contact
          EmergencyContactWidget(
            onEmergencyCall: () => _contactSupport('phone', '+1-800-EMERGENCY'),
          ),

          SizedBox(height: 3.h),

          // Contact Options
          Text(
            'Contact Support',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 2.h),

          ..._contacts.map((contact) => ContactCardWidget(
                title: contact['title'],
                value: contact['value'],
                description: contact['description'],
                icon: contact['icon'],
                onTap: () => _contactSupport(contact['type'], contact['value']),
              )).toList(),

          SizedBox(height: 3.h),

          // Additional Information
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Support Information',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Our support team is here to help you with any questions or issues you may have. For urgent matters, please call our support hotline.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help Categories',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 2.h),

          ..._categories.map((category) => HelpCategoryWidget(
                title: category['title'],
                description: category['description'],
                icon: category['icon'],
                articleCount: category['articles'],
                onTap: () => _openCategory(category['title']),
              )).toList(),

          SizedBox(height: 3.h),

          // Quick Links
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Links',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                
                _buildQuickLink('Privacy Policy', 'privacy_tip'),
                _buildQuickLink('Terms of Service', 'description'),
                _buildQuickLink('Community Guidelines', 'people'),
                _buildQuickLink('Report an Issue', 'report'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLink(String title, String icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 20,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 16,
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $title...')),
        );
      },
    );
  }
}
