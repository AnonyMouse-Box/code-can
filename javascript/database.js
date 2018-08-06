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
    if(typeof newName === 'string'){
      this._name = newName;
      return `Name was set to ${newName}.`;
    } else {
      return 'Invalid input.';
    }
  },
  set dob(newDay,newMonth,newYear){
    if(typeof newDay === 'number' && typeof newMonth === 'number' && typeof newYear === 'number' && String(newDay).length === 2 && String(newMonth).length === 2 && String(newYear).length === 4){
      this._dob = `${newDay}-${newMonth}-${newYear}`;
      const date = new Date();
      let c = -1;
      if(newMonth - (date.getMonth() + 1) < 1){
        if(newMonth - (date.getMonth() + 1) < 0){
          let c = 0;
        } else {
          if(newDay - date.getDate() < 1){
            let c = 0;
          }
        }
      }
      this._age = (newYear - date.getFullYear()) + c;
      return `${this._name}'s Date of Birth set to ${newDoB} and age has been updated to ${this._age}.`;
    } else {
      return 'Invalid input.';
    }
  }
}