// Ambil elemen form dan input
const form = document.querySelector('form');
const usernameInput = document.getElementById('username');
const passwordInput = document.getElementById('password');

// Event listener untuk menangani submit
form.addEventListener('submit', (event) => {
    event.preventDefault(); // Mencegah reload halaman

    // Validasi input
    const username = usernameInput.value.trim();
    const password = passwordInput.value.trim();

    if (!username || !password) {
        alert('Semua kolom harus diisi!');
        return;
    }

    // Dummy login validation (sesuaikan dengan backend jika diperlukan)
    if (username === 'admin' && password === 'admin123') {
        alert('Login berhasil!');
        window.location.href = 'index.html'; // Redirect ke halaman index.html
    } else {
        alert('Username atau password salah!');
    }
});
