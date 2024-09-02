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
  Meal(
    mealTime: "Beakfast",
    name: "Greek Yogurt with Honey",
    kiloCaloriesBurnt: "150",
    timeTaken: "8",
    imagePath: "assets/a3af2ecd96d0219a679cce127b49f29a.jpg",
),






),
];