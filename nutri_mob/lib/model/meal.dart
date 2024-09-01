class Meal {
  final String mealTime, name, imagePath, kiloCaloriesBurnt, timeTaken;

  Meal ( {
    required this.mealTime,
    required this.name,
    required this.imagePath,
    required this.kiloCaloriesBurnt,
    required this.timeTaken,
});
}
final meals = [
  Meal(
  mealTime: "Beakfast",
  name: "Oatmeal with fresh berries and a tablespoon of almond butter",
  kiloCaloriesBurnt: "300",
  timeTaken: "10",
  imagePath: "assets/Berry-and-Nut-Swirl-Oatmeal.jpg",
),
  Meal(
      mealTime: "Beakfast",
      name: "Boiled Egg",
      kiloCaloriesBurnt: "70",
      timeTaken: "8",
      imagePath: "assets/how-to-make-soft-boiled-eggs-4.jpg",
),






),
];