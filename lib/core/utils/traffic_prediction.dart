/// Returns a simulated traffic prediction message based on current time.
String getTrafficPrediction([DateTime? at]) {
  final hour = (at ?? DateTime.now()).hour;
  if (hour >= 7 && hour < 9) {
    return '🚗 Heavy morning rush — expect +15 min delays on main roads';
  } else if (hour >= 9 && hour < 12) {
    return '✅ Moderate traffic — good time to travel';
  } else if (hour >= 12 && hour < 14) {
    return '🟡 Midday congestion near City Centre and the Old City';
  } else if (hour >= 14 && hour < 16) {
    return '✅ Light traffic — roads are clear';
  } else if (hour >= 16 && hour < 19) {
    return '🚗 Evening rush — major roads congested, use Al-Bypass';
  } else if (hour >= 19 && hour < 22) {
    return '🟡 Moderate evening traffic winding down';
  } else {
    return '✅ Night hours — minimal traffic, drive safely';
  }
}
