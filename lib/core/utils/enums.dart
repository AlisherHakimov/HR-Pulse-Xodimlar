import 'dart:ui';

import '../core.dart';

enum BlocStatus {
  initial,
  loading,
  success,
  error;

  bool get isLoading => this == BlocStatus.loading;

  bool get isSuccess => this == BlocStatus.success;

  bool get isError => this == BlocStatus.error;
}

enum PermissionStatus {
  ALL,
  PENDING,
  CREATED,
  REJECTED,
  APPROVED,
  AI_APPROVED,
  AI_REJECTED;

  String get tr {
    switch (this) {
      case PermissionStatus.ALL:
        return 'all'.tr();
      case PermissionStatus.CREATED:
        return 'created'.tr();
      case PermissionStatus.PENDING:
        return 'pending'.tr();
      case PermissionStatus.REJECTED:
        return 'rejected'.tr();
      case PermissionStatus.APPROVED:
        return 'approved'.tr();
      case PermissionStatus.AI_APPROVED:
        'approved'.tr();
        throw UnimplementedError();
      case PermissionStatus.AI_REJECTED:
        'rejected'.tr();
        throw UnimplementedError();
    }
  }

  Color get titleColor {
    switch (this) {
      case PermissionStatus.ALL:
        return AppColors.neutral700;
      case PermissionStatus.CREATED:
        return AppColors.primary700;
      case PermissionStatus.PENDING:
        return AppColors.warning700;
      case PermissionStatus.REJECTED:
        return AppColors.destructive700;
      case PermissionStatus.APPROVED:
        return AppColors.success700;
      case PermissionStatus.AI_APPROVED:
        return AppColors.success700;
      case PermissionStatus.AI_REJECTED:
        return AppColors.destructive700;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case PermissionStatus.ALL:
        return AppColors.neutral50;
      case PermissionStatus.CREATED:
        return AppColors.primary50;
      case PermissionStatus.PENDING:
        return AppColors.warning50;
      case PermissionStatus.REJECTED:
        return AppColors.destructive50;
      case PermissionStatus.APPROVED:
        return AppColors.success50;
      case PermissionStatus.AI_APPROVED:
        return AppColors.success50;
      case PermissionStatus.AI_REJECTED:
        return AppColors.destructive50;
    }
  }
}

enum ReportType {
  ADVANCE_PAYMENT,
  SALARY_PAYMENT,
  SALARY_PAYMENT_CARD,
  BONUS,
  PENALTY;

  String get tr {
    switch (this) {
      case ReportType.ADVANCE_PAYMENT:
        return 'advance_payment'.tr();
      case ReportType.SALARY_PAYMENT:
        return 'salary_payment'.tr();
      case ReportType.SALARY_PAYMENT_CARD:
        return 'salary_payment_card'.tr();

      case ReportType.BONUS:
        return 'bonus'.tr();

      case ReportType.PENALTY:
        return 'penalty'.tr();
    }
  }

  Color get titleColor {
    switch (this) {
      case ReportType.ADVANCE_PAYMENT:
        return AppColors.success700;
      case ReportType.SALARY_PAYMENT:
        return AppColors.success700;
      case ReportType.SALARY_PAYMENT_CARD:
        return AppColors.primary700;

      case ReportType.BONUS:
        return AppColors.success700;

      case ReportType.PENALTY:
        return AppColors.warning700;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ReportType.ADVANCE_PAYMENT:
        return AppColors.success50;

      case ReportType.SALARY_PAYMENT:
        return AppColors.success50;

      case ReportType.SALARY_PAYMENT_CARD:
        return AppColors.primary50;

      case ReportType.BONUS:
        return AppColors.success50;

      case ReportType.PENALTY:
        return AppColors.warning50;
    }
  }
}
