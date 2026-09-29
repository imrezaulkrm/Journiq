enum DownloadStatus {
  idle,
  downloading,
  paused,
  completed,
  error,
}

class DistrictMapStatus {
  final String districtId;
  final String districtName;
  final DownloadStatus status;
  final int totalTiles;
  final int downloadedTiles;
  final double sizeMb;
  final String? errorMessage;

  const DistrictMapStatus({
    required this.districtId,
    required this.districtName,
    this.status = DownloadStatus.idle,
    this.totalTiles = 0,
    this.downloadedTiles = 0,
    this.sizeMb = 0.0,
    this.errorMessage,
  });

  double get progress => totalTiles > 0 ? (downloadedTiles / totalTiles) : 0.0;
  bool get isDownloaded => status == DownloadStatus.completed;

  DistrictMapStatus copyWith({
    String? districtId,
    String? districtName,
    DownloadStatus? status,
    int? totalTiles,
    int? downloadedTiles,
    double? sizeMb,
    String? errorMessage,
  }) {
    return DistrictMapStatus(
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      status: status ?? this.status,
      totalTiles: totalTiles ?? this.totalTiles,
      downloadedTiles: downloadedTiles ?? this.downloadedTiles,
      sizeMb: sizeMb ?? this.sizeMb,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
