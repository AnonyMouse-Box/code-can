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

function birthMonth(current, birth){
  return (birth - (current.getMonth() + 1)) < 1;
}

function pastBirthMonth(current, birth){
  return (birth - (current.getMonth() + 1)) < 0;
}

function pastBirthDay(current, birth){
  return (birth - current.getDate()) < 1;
}

function calcAgeBasedOnYear(current, birthyear){
  return current.getFullYear() - (birthyear + 1);
}

function calcAge(day, month, year){
  let date = new Date();
  if(pastBirthMonth(date, month)){
    return calcAgeBasedOnYear(date, year) +1;
  }
  if(birthMonth(date, month) && pastBirthDay(date, month)){
    return calcAgeBasedOnYear(date, year) +1;
  }
  return calcAgeBasedOnYear(date, year);
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
    this._name = newName;
    return `Name was set to ${newName}.`;
  },
  set dob(newDay, newMonth, newYear){
    this._dob = `${newDay}-${newMonth}-${newYear}`;
    return `${this._name}'s Date of Birth has been set to ${this._dob}`;
  },
  set age(newAge){
    this._age = newAge;
    return `${this._name}'s age has been updated to ${this._age}.`;
  }
}

function changeName(changeNameTo){
  if(typeof changeNameTo === 'string'){
    person.name = changeNameTo;
  } else {
    return 'Invalid input.';
  }
}

function changeDOB(changeDayTo, changeMonthTo, changeYearTo){
  if(typeof changeDayTo === 'number' && typeof changeMonthTo === 'number' && typeof changeYearTo === 'number' && String(changeDayTo).length === 2 && String(changeMonthTo).length === 2 && String(changeYearTo).length === 4){
    person.dob = `${changeDayTo}-${changeMonthTo}-${changeYearTo}`;
    person.age = calcAge(changeDayTo, changeMonthTo, changeYearTo);
  } else {
    return 'Invalid input.';
  }
}