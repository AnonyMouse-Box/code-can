function pickRandomCharacterFromString(string){
  return string.charAt(Math.floor(Math.random() * string.length));
}

function generateID(){
  let uid = '';
  const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789£@';
  for(let iteratorA = 0; iteratorA < 2; iteratorA++){
    if(iteratorA != 0){
      uid += ' :: ';
    }
    for(let iteratorB = 0; iteratorB < 4; iteratorB++){
      if(iteratorB != 0){
        uid += '-';
      }
      for(let iteratorC = 0; iteratorC < 4; iteratorC++){
        uid += pickRandomCharacterFromString(possible);
      }
    }
  }
  return uid;
}

let person = {
  _id,
  _name,
  _dob,
  _age,
  get id() {
    return this._id;
  },
  get name() {
    return this._name;
  },
  get dob() {
    return this._dob;
  },
  get age() {
    return this._age;
  },
  set id(){
    this._id = generateID();
    return `${this._name}'s ID has been set to ${this._id}`;
  },  
  set name(newName){
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
      return `${this._name}'s Date of Birth has been set to ${this._dob} and age has been updated to ${this._age}.`;
    } else {
      return 'Invalid input.';
    }
  }
}