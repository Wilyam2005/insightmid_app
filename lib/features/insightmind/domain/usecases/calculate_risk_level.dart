import '../entities/mental_result.dart';

class CalculateRiskLevel {
  MentalResult execute(int score) {
    String risk;
    if (score >= 20) {
      risk = 'Tinggi';
    } else if (score >= 10) { //  <-- Apakah 9 lebih besar atau sama dengan 10? Tidak.
      risk = 'Sedang';
    } else { // 
      risk = 'Rendah'; //       <-- Program masuk ke sini
    }
    return MentalResult(score: score, riskLevel: risk);
  }
}