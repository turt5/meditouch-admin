class Degree {
  final String year;
  final String degree;
  final String institution;

  Degree({required this.year, required this.degree, required this.institution});

  factory Degree.fromMap(Map<String, dynamic> data) {
    final year = data['passedYear'];
    final degree = data['degree'];
    final institution = data['institution'];
    return Degree(year: year, degree: degree, institution: institution);
  }

  Map<String, dynamic> toMap() {
    return {'passedYear': year, 'degree': degree, 'institution': institution};
  }

  @override
  String toString() =>
      'Degree(year: $year, degree: $degree, institution: $institution)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Degree otherDegree = other as Degree;
    return otherDegree.year == year &&
        otherDegree.degree == degree &&
        otherDegree.institution == institution;
  }

  @override
  int get hashCode => year.hashCode ^ degree.hashCode ^ institution.hashCode;
}
