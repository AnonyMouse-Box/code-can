const progress = (id) => {
  if(document.getElementById(id).value === 100){
    window.alert('Complete!');
  } else {
    document.getElementById(id).value ++;
    document.getElementById(id).title = document.getElementById(id).value;
  }
}