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

String normalizeGender(String raw) {
  raw = raw.trim().toLowerCase();
  if (raw == "nam" || raw == "male" || raw == "m") return "Nam";
  if (raw == "nữ" || raw == "nu" || raw == "female" || raw == "f") return "Nữ";
  return "Khác";
}
