enum TrackingStatus {
  idle,
  starting,
  waitingForGps,
  tracking,
  paused,
  stopping,
  saving,
  completed,
  error,
}

extension TrackingStatusX on TrackingStatus {
  bool get isActivelyTracking => this == TrackingStatus.tracking;
  bool get isPaused => this == TrackingStatus.paused;
  bool get isRecording =>
      this == TrackingStatus.tracking || this == TrackingStatus.paused;
}
