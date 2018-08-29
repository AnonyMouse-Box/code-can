let person = {
  _id,
  _firstName,
  _middleNames,
  _lastName,
  _birthDate,
  _birthMonth,
  _birthYear,
  _age,
  get id(){
    return this._id;
  },
  get firstName(){
    return this._firstName;
  },
  get middleNames(){
    return this.middleNames;
  },
  get lastName(){
    return this._lastName;
  },
  get birthDate(){
  	return this._birthDate;
  },
  get birthMonth(){
    return this._birthMonth;
  },
  get birthYear(){
    return this._birthYear;
  },
  get age(){
    return this._age;
  },
  set id(newID){
    this._id = newID;
  },  
  set firstName(newFirstName){
    this._firstName = newFirstName;
  },
  set middleNames(newMiddleNames){
    this._middleNames = newMiddleNames;
  },
  set lastName(newLastName){
    this._lastName = newLastName;
  },
  set birthDate(newDay){
    this._birthDate = newDay;
  },
  set birthMonth(newMonth){
    this._birthMonth = newMonth;
  },
  set birthYear(newYear){
    this._birthYear = newYear;
  },
  set age(newAge){
    this._age = newAge;
  }
}

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

function nowBirthMonth(current, birth){
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
  if(nowBirthMonth(date, month) && pastBirthDay(date, month)){
    return calcAgeBasedOnYear(date, year) +1;
  }
  return calcAgeBasedOnYear(date, year);
}

function changeID(){
  person.id = generateID();
}

function changeFirstName(changeFirstNameTo){
  if(typeof changeFirstNameTo === 'string'){
    person.firstName = changeFirstNameTo;
  } else{
    return 'Invalid input.';
  }
}

function changeMiddleNames(changeMiddleNamesTo){
  if(typeof changeMiddleNamesTo === 'string'){
    person.middleNames = changeMiddleNamesTo;
  } else{
    return 'Invalid input.';
  }
}

function changeLastName(changeLastNameTo){
  if(typeof changeLastNameTo === 'string'){
    person.lastName = changeLastNameTo;
  } else{
    return 'Invalid input.';
  }
}

function changeFullName(changeFullNameTo){
  if(typeof changeFullNameTo === 'string'){
    let arrayOfNames = changeFullNameTo.split(' ');
    if(arrayOfNames.length() > 2 && arrayOfNames.length() < 10){
//      for(){
//        changeFirstName(arrayOfNames[0]);
//        changeLastName(arrayOfNames[arrayOfNames.length() - 1]);
      }
    } else{
      return 'Name too short.'
    }
  } else{
    return 'Invalid input.';
  }
}

function changeBirthDate(changeBirthDateTo){
  person.birthDate = changeBirthDateTo;
}

function changeBirthMonth(changeBirthMonthTo){
  person.birthMonth = changeBirthMonthTo;
}

function changeBirthYear(changeBirthYearTo){
  person.birthYear = changeBirthYearTo;
}

function changeDOB(changeDayTo, changeMonthTo, changeYearTo){
//  if(typeof changeDayTo === 'number' && typeof changeMonthTo === 'number' && typeof changeYearTo === 'number' && String(changeDayTo).length === 2 && String(changeMonthTo).length === 2 && String(changeYearTo).length === 4){
//    person.dob = `${changeDayTo}-${changeMonthTo}-${changeYearTo}`;
//    person.age = calcAge(changeDayTo, changeMonthTo, changeYearTo);
//  } else {
//    return 'Invalid input.';
//  }
}