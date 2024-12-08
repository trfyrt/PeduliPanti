// script.js
document.querySelector('form').addEventListener('submit', function (event) {
    event.preventDefault();
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();

    if (!username || !password) {
        alert('Please fill in both fields');
        return;
    }

    // Replace this with your login logic
    alert('Login successful');
});
