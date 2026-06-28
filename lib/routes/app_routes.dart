import 'package:flutter/material.dart';
import '../presentation/beneficiary_dashboard/beneficiary_dashboard.dart';
import '../presentation/qr_code_generator/qr_code_generator.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/beneficiary_management/beneficiary_management.dart';
import '../presentation/transaction_history/transaction_history.dart';
import '../presentation/admin_dashboard/admin_dashboard.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/help_screen/help_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/auditor_dashboard/auditor_dashboard.dart';
import '../presentation/agent_dashboard/agent_dashboard.dart';
import '../presentation/program_management/program_management.dart';
// Missing admin pages imports
import '../presentation/active_programs/active_programs.dart';
import '../presentation/create_program/create_program.dart';
import '../presentation/program_analytics/program_analytics.dart';
import '../presentation/bulk_upload/bulk_upload.dart';
import '../presentation/kyc_verification/kyc_verification.dart';
import '../presentation/pending_approvals/pending_approvals.dart';
import '../presentation/audit_trail/audit_trail.dart';
import '../presentation/financial_reports/financial_reports.dart';
import '../presentation/compliance_reports/compliance_reports.dart';
import '../presentation/fraud_detection/fraud_detection.dart';
import '../presentation/system_settings/system_settings.dart';
import '../presentation/user_management/user_management.dart';

class AppRoutes {
  // Authentication Routes
  static const String initial = '/';
  static const String login = '/login-screen';

  // Dashboard Routes
  static const String beneficiaryDashboard = '/beneficiary-dashboard';
  static const String adminDashboard = '/admin-dashboard';
  static const String auditorDashboard = '/auditor-dashboard';
  static const String agentDashboard = '/agent-dashboard';
  
  // Feature Routes
  static const String qrCodeGenerator = '/qr-code-generator';
  static const String beneficiaryManagement = '/beneficiary-management';
  static const String transactionHistory = '/transaction-history';
  static const String programManagement = '/program-management';
  
  // User Management Routes
  static const String profile = '/profile';
  static const String help = '/help';
  static const String settings = '/settings';

  // Admin-specific Routes
  static const String activePrograms = '/active-programs';
  static const String createProgram = '/create-program';
  static const String programAnalytics = '/program-analytics';
  static const String bulkUpload = '/bulk-upload';
  static const String kycVerification = '/kyc-verification';
  static const String pendingApprovals = '/pending-approvals';
  static const String auditTrail = '/audit-trail';
  static const String financialReports = '/financial-reports';
  static const String complianceReports = '/compliance-reports';
  static const String fraudDetection = '/fraud-detection';
  static const String systemSettings = '/system-settings';
  static const String userManagement = '/user-management';

  static Map<String, WidgetBuilder> routes = {
    // Authentication
    initial: (context) => const LoginScreen(),
    login: (context) => const LoginScreen(),
    
    // Dashboards
    beneficiaryDashboard: (context) => const BeneficiaryDashboard(),
    adminDashboard: (context) => const AdminDashboard(),
    auditorDashboard: (context) => const AuditorDashboard(),
    agentDashboard: (context) => const AgentDashboard(),
    
    // Features
    qrCodeGenerator: (context) => const QrCodeGenerator(),
    beneficiaryManagement: (context) => const BeneficiaryManagement(),
    transactionHistory: (context) => const TransactionHistory(),
    programManagement: (context) => const ProgramManagement(),
    
    // User Management
    profile: (context) => const ProfileScreen(),
    help: (context) => const HelpScreen(),
    settings: (context) => const SettingsScreen(),

    // Admin-specific pages
    activePrograms: (context) => const ActivePrograms(),
    createProgram: (context) => const CreateProgram(),
    programAnalytics: (context) => const ProgramAnalytics(),
    bulkUpload: (context) => const BulkUpload(),
    kycVerification: (context) => const KycVerification(),
    pendingApprovals: (context) => const PendingApprovals(),
    auditTrail: (context) => const AuditTrail(),
    financialReports: (context) => const FinancialReports(),
    complianceReports: (context) => const ComplianceReports(),
    fraudDetection: (context) => const FraudDetection(),
    systemSettings: (context) => const SystemSettings(),
    userManagement: (context) => const UserManagement(),
  };
}
