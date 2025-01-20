document.getElementById('registerForm').addEventListener('submit', async function(event) {
  event.preventDefault();

  // Mengambil data dari form
  const firstName = document.getElementById('firstName').value.trim();
  const lastName = document.getElementById('lastName').value.trim();
  const email = document.getElementById('email').value.trim();
  const password = document.getElementById('password').value;
  const role = document.getElementById('role').value;

  if (!document.getElementById('terms').checked) {
    alert('Anda harus menyetujui Terms & Conditions.');
    return;
  }

  const fullName = `${firstName} ${lastName}`;

  try {
    const response = await fetch('http://127.0.0.1:8000/api/v1', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        name: fullName,
        email: email,
        password: password,
        role: role,
      }),
    });

    const data = await response.json();

    if (response.ok) {
      alert('Akun berhasil dibuat!');
      window.location.href = 'index.html';
    } else {
      alert(`Error: ${data.message || 'Terjadi kesalahan'}`);
    }
  } catch (error) {
    console.error('Error:', error);
    alert('Terjadi kesalahan pada server. Silakan coba lagi nanti.');
  }
});

  
  