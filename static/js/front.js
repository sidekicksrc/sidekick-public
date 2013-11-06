document.querySelector(".toggle").addEventListener("click",function(evt) {
  evt.preventDefault();
  console.log("clicked")
  document.querySelector("nav").classList.toggle('active')
})
