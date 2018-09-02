const funcValidator = (func, arg, number) => {
  let validationArray = [];
  for each (let i = 0; i < number; i++) {
    validationArray.push(func(value));
  }
  for each (let i = 0; i < number; i++) {
    if (validationArray[0] === validationArray[i]) {
    } else {
      return `This functions output is variable: $validationArray`
    }
  }
}