console.log("Dashboard loaded Successfully!")

// Get the modal
var modal = document.getElementById("rabModal");

// Get the button that opens the modal
var btns = document.querySelectorAll(".btn");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// Get the accept and reject buttons
var acceptButtons = document.querySelectorAll(".accept");
var rejectButtons = document.querySelectorAll(".reject");

// When the user clicks the button, open the modal 
btns.forEach(btn => {
  btn.onclick = function() {
    modal.style.display = "block";
  }
});

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
  modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}

// Close the modal and show "Approved" message when "Accept" is clicked
acceptButtons.forEach(button => {
  button.onclick = function() {
    modal.style.display = "none";
    alert("Approved");
  }
});

// Close the modal and show "Rejected" message when "Reject" is clicked
rejectButtons.forEach(button => {
  button.onclick = function() {
    modal.style.display = "none";
    alert("Rejected");
  }
});