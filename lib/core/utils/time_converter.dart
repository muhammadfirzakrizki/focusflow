class TimeConverter {
  static int getHours(int totalSeconds) => totalSeconds ~/ 3600;
  static int getMinutes(int totalSeconds) => (totalSeconds % 3600) ~/ 60;
  static int getSeconds(int totalSeconds) => totalSeconds % 60;

  static int toTotalSeconds(String h, String m, String s) {
    final int hours = int.tryParse(h) ?? 0;
    final int minutes = int.tryParse(m) ?? 0;
    final int seconds = int.tryParse(s) ?? 0;
    return (hours * 3600) + (minutes * 60) + seconds;
  }

  // Update format digital untuk timer nanti
  static String formatToDigital(int totalSeconds) {
    final h = getHours(totalSeconds);
    final m = getMinutes(totalSeconds).toString().padLeft(2, '0');
    final s = getSeconds(totalSeconds).toString().padLeft(2, '0');
    // Cek jika total waktu lebih dari atau sama dengan 1 jam (3600 detik)
    if (totalSeconds >= 3600) {
      // Format H:MM:SS (Contoh: 1:05:09)
      return "$h:$m:$s";
    } else {
      // Format MM:SS (Contoh: 05:09)
      return "$m:$s";
    }
  }
}
