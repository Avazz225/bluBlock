import 'dart:math';


int randomNumberGenerator(int min, int max){
  var random = Random();
  return min + random.nextInt(max - min);
}