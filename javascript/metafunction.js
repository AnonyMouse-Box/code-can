const funcValidator = (func, arg, number) => {
  let validated = true;
  let validationArray = [];
  for each (let i = 0; i < number; i++) {
    validationArray.push(func(arg));
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
    return `This function's output varies: ${validationArray}`;
  }
}

const funcTimer = (func, arg) => {
  let start = new Date();
  func(arg);
  let finish = new Date();
  return `Program took ${(finish.getMilliseconds() - start.getMilliseconds()) / 1000}s.`
}