function update_clock() {
  const now = new Date();
  const clock_element = document.getElementById('clock');
  if (clock_element) {
    clock_element.innerText = now.toLocaleTimeString();
  }
}

setInterval(update_clock, 1000);
update_clock();

