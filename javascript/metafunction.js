const funcValidator = (func, arg, number) => {
  let validated = true;
  let validationArray = [];
  for each (let i = 0; i < number; i++) {
    validationArray.push(func(value));
    if (validationArray[0] === validationArray[i]) {
      break
    } else {
      validated = false;
      break
    }
  }
  if (validated === true) {
    return validationArray[0];
  } else {
    return `This functions output varies: ${validationArray}`;
}