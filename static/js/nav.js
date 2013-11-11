document.querySelector(".toggle").addEventListener("click",function(evt) {
  evt.preventDefault();
  document.querySelector("nav").classList.toggle('active')
})
