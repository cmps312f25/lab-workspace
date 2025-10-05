class LocalDatasource {
  String getStudentById(int id) {
    return id == 1 ? "John Smith" : "No Student";
  }
}
