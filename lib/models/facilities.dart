class Facilities {
  final String name, image, category, biography;
  final int patients, reviews;
  final double ratings;

  Facilities(this.name, this.image, this.category, this.biography, this.patients,
      this.ratings, this.reviews);

  static List<Facilities> doctorList() {
    List<Facilities> list = [];
    list.add(Facilities(
        'Dr. Anna Baker',
        'assets/images/profile/avatar_2.jpg',
        'Heart Surgeon Specialist',
        'Dr. Anna Baker is an indonesian Heart Surgeon specialist. She practices general at Elizabeth Hospital in Semarang. . .',
        1000,
        4.5,
        120));

    list.add(Facilities(
        'Dr. Emilie Jones',
        'assets/images/profile/avatar_4.jpg',
        'Paediatrician',
        'Dr. Emilie Jones is an Indian Paediatrician. She practices general at HealthCare Hospital in New Jersey. . .',
        1200,
        4.0,
        100));

    list.add(Facilities(
        'Dr. Joe Taylor',
        'assets/images/profile/avatar_3.jpg',
        'Ophthalmologist',
        'Dr. Joe Taylor is an Japanese Ophthalmologist. He practices general at St. Thomas Hospital in Boston. . .',
        1100,
        3.5,
        150));

    return list;
  }

  static Facilities getOne() {
    return Facilities(
        'Dr. Anna Baker',
        'assets/images/profile/avatar_2.jpg',
        'Heart Surgeon Specialist',
        'Dr. Anna Baker is an indonesian Heart Surgeon specialist. She practices general at Elizabeth Hospital in Semarang...',
        1000,
        4.5,
        120);
  }
}
