String convertRelationship(String? relation) {
  switch (relation) {
    case "Tôi":
      return "self";
    case "Vợ/Chồng":
      return "spouse";
    case "Bố/Mẹ":
      return "parent";
    case "Anh/Chị/Em":
      return "sibling";
    case "Con":
      return "child";
    default:
      return "other";
  }
}

String convertRelationshipBack(String relation) {
  switch (relation) {
    case "self":
      return "Tôi";
    case "spouse":
      return "Vợ/Chồng";
    case "parent":
      return "Bố/Mẹ";
    case "sibling":
      return "Anh/Chị/Em";
    case "child":
      return "Con";
    default:
      return "Khác";
  }
}
