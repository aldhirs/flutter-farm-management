enum DropdownTypeEnum {
  single(1),
  multiple(2);

  final int value;

  const DropdownTypeEnum(this.value);

  static DropdownTypeEnum getEnum(int value) {
    for (var enumValue in DropdownTypeEnum.values) {
      if (enumValue.value == value) {
        return enumValue;
      }
    }
    return DropdownTypeEnum.single;
  }
}
