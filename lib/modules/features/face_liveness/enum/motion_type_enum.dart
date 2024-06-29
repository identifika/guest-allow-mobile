enum MotionTypeEnum {
  blink,
  openMouth,
  shakeHead,
}

extension MotionTypeEnumExtension on MotionTypeEnum {
  String get name {
    switch (this) {
      case MotionTypeEnum.blink:
        return 'Blink';
      case MotionTypeEnum.openMouth:
        return 'Open Mouth';
      case MotionTypeEnum.shakeHead:
        return 'Shake Head';
      default:
        return '';
    }
  }
}
