function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

const hideTop = () => {
  document.getElementsByClassName("top-unhide")[0].removeAttribute("id");
  document.getElementsByClassName("top-hide")[0].setAttribute("id", "disappear");
  document.getElementsByTagName("nav")[0].setAttribute("id", "collapse-top");
  document.getElementsByClassName("content")[0].classList.add("hide-top");
  document.getElementsByClassName("title")[0].setAttribute("id", "hide");
  document.getElementsByClassName("quote")[0].setAttribute("id", "hide");
  document.getElementsByClassName("menu")[0].setAttribute("id", "hide");
}

const unhideTop = () => {
  document.getElementsByClassName("top-unhide")[0].setAttribute("id", "disappear");
  document.getElementsByClassName("top-hide")[0].removeAttribute("id");
  document.getElementsByTagName("nav")[0].removeAttribute("id");
  document.getElementsByClassName("content")[0].classList.remove("hide-top");
  sleep(500).then(() => {
    document.getElementsByClassName("title")[0].removeAttribute("id");
    document.getElementsByClassName("quote")[0].removeAttribute("id");
    document.getElementsByClassName("menu")[0].removeAttribute("id");
  })
}

const hideSide = () => {
  document.getElementsByClassName("side-unhide")[0].removeAttribute("id");
  document.getElementsByClassName("side-hide")[0].setAttribute("id", "disappear");
  document.getElementsByTagName("aside")[0].setAttribute("id", "collapse-side");
  document.getElementsByClassName("content")[0].classList.add("hide-side");
  //contents
}

const unhideSide = () => {
  document.getElementsByClassName("side-unhide")[0].setAttribute("id", "disappear");
  document.getElementsByClassName("side-hide")[0].removeAttribute("id");
  document.getElementsByTagName("aside")[0].removeAttribute("id");
  document.getElementsByClassName("content")[0].classList.remove("hide-side");
  sleep(500).then(() => {
    //contents
  })
}

function scrollFunction() {
    if (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50) {
        document.getElementsByClassName("to-top")[0].removeAttribute("id");
    } else {
        document.getElementsByClassName("to-top")[0].setAttribute("id", "disappear");
    }
}

window.onscroll = function() {scrollFunction()};

function toTop() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}

function validateForm() {
    var input = document.forms["flagForm"]["flag"].value;
    var re = /^(?:\s|)(?:OUCSS(?:{|)|)((?:[\S])*)(?:\s|)(?:}(?:{. *}|)|)(?:\s|)$/;
    var match = re.exec(input)
    var response = document.getElementById("response")
    if (match == null || match[1] == false) {
        response.setAttribute("style", "color:red;")
        response.innerHTML = "invalid entry";
        return false;
    }
    else {
        response.setAttribute("style", "color:green;")
        response.innerHTML = "success!";
    }
}
