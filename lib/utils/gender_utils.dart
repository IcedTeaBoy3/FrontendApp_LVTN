String convertGender(String gender) {
  switch (gender) {
    case "Nam":
      return "male";
    case "Nữ":
      return "female";
    default:
      return "other";
  }
}

String convertGenderBack(String gender) {
  switch (gender) {
    case "male":
      return "Nam";
    case "female":
      return "Nữ";
    default:
      return "Khác";
  }
}
