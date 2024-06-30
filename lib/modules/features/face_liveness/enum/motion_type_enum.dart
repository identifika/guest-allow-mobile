enum MotionTypeEnum {
  blink,
  shakeHead,
}

extension MotionTypeEnumExtension on MotionTypeEnum {
  String get name {
    switch (this) {
      case MotionTypeEnum.blink:
        return 'Blink';
      case MotionTypeEnum.shakeHead:
        return 'Shake Head';
      default:
        return '';
    }
  }
}
