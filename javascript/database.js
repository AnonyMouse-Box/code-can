let person = {
  _name,
  _dob,
  _age,
  get name() {
    return this._name;
  },
  get dob() {
    return this._dob;
  },
  get age() {
    return this._age;
  },
  set name(newName) {
    if (typeof newName === 'string') {
      this._name = newName;
      return `Name was set to ${newName}.`;
    } else {
      return 'Invalid input.';
    }
  },
  set dob(newDoB) {
    if (typeof newDoB === '') {
      this._dob = newDoB;
      return `${this._name}'s Date of Birth set to ${newDoB}.`;
    } else {
      return 'Invalid input.';
    }
  }
}