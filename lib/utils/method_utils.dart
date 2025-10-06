String converMethodPayment(String method) {
  switch (method) {
    case 'cash':
      return 'Tiền mặt';
    case 'bank':
      return 'Ngân hàng';
    case 'online':
      return 'Ngân hàng';
    default:
      return method;
  }
}
