document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector(".register-form");
  
    form.addEventListener("submit", (event) => {
      event.preventDefault(); // Mencegah reload halaman
  
      // Mengambil nilai dari setiap input
      const firstName = form.querySelector('input[placeholder="First Name"]').value;
      const lastName = form.querySelector('input[placeholder="Last Name"]').value;
      const email = form.querySelector('input[type="email"]').value;
      const password = form.querySelector('input[type="password"]').value;
      const role = form.querySelector("select").value;
      const termsChecked = form.querySelector("#terms").checked;
  
      // Validasi input
      if (!firstName || !lastName || !email || !password || !role || !termsChecked) {
        alert("Please fill out all fields and agree to the terms and conditions.");
        return;
      }
  
      // Menampilkan data ke console
      console.log({
        firstName,
        lastName,
        email,
        password,
        role,
        termsChecked,
      });
  
      // Mengarahkan pengguna ke index.html
      window.location.href = "index.html";
    });
  });
  
  