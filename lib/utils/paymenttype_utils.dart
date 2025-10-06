String convertPaymentType(String type) {
  switch (type) {
    case 'service':
      return 'Khám dịch vụ';
    case 'insurance':
      return 'Khám BHYT';
    default:
      return '--';
  }
}
