document.addEventListener("DOMContentLoaded", () => {
    const viewButtons = document.querySelectorAll(".view");
    const modal = document.getElementById("rab-modal");
    const closeBtn = document.querySelector(".close-btn");
  
    // Tambahkan Event Listener untuk Tombol "View"
    viewButtons.forEach(button => {
      button.addEventListener("click", () => {
        modal.style.display = "block"; // Tampilkan Modal
  
        // Fetch Data API (Jika Diperlukan)
        const rabId = button.getAttribute("data-id");
        fetch(`https://127.0.0.1:8000/rab/${rabId}`)
          .then(response => response.json())
          .then(data => {
            document.getElementById("rab-title").textContent = data.panti_name;
            document.getElementById("rab-date").textContent = data.submission_date;
            document.getElementById("rab-status").textContent = data.status;
            document.getElementById("rab-details").textContent = data.details;
          })
          .catch(error => {
            console.error("Error fetching RAB details:", error);
          });
      });
    });
  
    // Event Listener untuk Tombol "Close"
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none"; // Sembunyikan Modal
    });
  
    // Tutup Modal saat Klik di Luar Modal
    window.addEventListener("click", event => {
      if (event.target === modal) {
        modal.style.display = "none";
      }
    });
  });
  