const progress = (id) => {
  if(document.getElementById(id).value === 100){
    window.alert('Complete!');
  } else {
    document.getElementById(id).value ++;
  }
}

const current = (id, output) => {
  document.getElementById(output).innerHTML(document.getElementById(id).value);
}