class Constants{
  String appName = 'ZAPA Mortgage';

  static const String USER_ID = 'USER_ID';
  static const String USER_NAME = 'USER_NAME';
  static const String USER_EMAIL = 'USER_EMAIL';
  static const String DETAIL_PHONE_NUMBER = 'DETAIL_PHONE_NUMBER';
  static const String DETAIL_USER_ID = 'DETAIL_USER_ID';


  final List<String> liabilityTypes = [
    'Revolving (Credit Card)',
    'Charge (Store Card)',
    'Installment (Auto)',
    'Installment (Student)',
    'Installment (Personal)',
    'Lease (Auto)',
    'Collection (Medical)',
    'Collection (Other)',
    'Other Liability',
  ];
  final List<String> verifiedButExcludedReasons = [
    'To Be Paid',
    'Paid by Others',
    'Less than 10 Months Remaining',
    'Court Ordered / Other',
  ];
  final List<String> assetsItems = [
    'Bank - Current A/C',
    'Bank - Saving A/C',
    'Stocks - Trading A/C',
    'Gift Funds - from Donor',
    'Other Source - Pending',
  ];
  final List<String> workTypes = [
    'Employment',
    'Business / Self Employed',
    'Other Income',
  ];

  final List<String> searchBy = [
    'All',
    'LOA',
    'Borrower',
  ];
  final List<String> payPerCycleTypes = [
    'Hourly',
    'Weekly',
    'Bi Weekly',
    'Semi Monthly',
    'Monthly',
  ];

  final List<String> leadStages = [
    'No Lead Selected',
    'Open',
    'Warm',
    'Hot',
    'On Followup',
    'Negotiation',
    'Booked',
    'Cold',
    'Inactive',
    'Pre-Approved',
    'Pending',
    'Not Qualified',
    'Up Coming',
  ];

  String note = 'If the additional income amount is added for just 1 w2 year then the amount will not be accepted/considered '
      'in total additional w2 income (YTD).';
}