document.addEventListener("DOMContentLoaded", function () {
  const loginForm = document.querySelector("form");

  loginForm.addEventListener("submit", async function (event) {
      event.preventDefault();

      const username = document.getElementById("username").value.trim();
      const password = document.getElementById("password").value.trim();

      if (!username || !password) {
          alert("Please enter both username and password.");
          return;
      }

      try {
          const response = await fetch("http://127.0.0.1:8000/api/v1", {
              method: "POST",
              headers: {
                  "Content-Type": "application/json"
              },
              body: JSON.stringify({ username, password })
          });

          const data = await response.json();

          if (response.ok) {
              alert("Login successful!");
              localStorage.setItem("token", data.token); // Simpan token jika diperlukan
              window.location.href = "index.html"; // Redirect ke dashboard
          } else {
              alert(data.message || "Login failed. Please check your credentials.");
          }
      } catch (error) {
          console.error("Error:", error);
          alert("An error occurred. Please try again later.");
      }
  });
});

// Function to fetch RAB list
async function fetchRABList() {
    try {
        const response = await fetch('http://127.0.0.1:8000/api/v1/rab');
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        displayRABCards(data.data);
    } catch (error) {
        console.error('Error fetching RAB list:', error);
        document.querySelector('.rab-submissions').innerHTML = `
            <div class="error-message">
                Failed to load RAB data. Please try again later.
            </div>`;
    }
}

// Function to display RAB cards
function displayRABCards(rabItems) {
    const container = document.querySelector('.rab-submissions');
    container.innerHTML = '';

    rabItems.forEach(rab => {
        const card = document.createElement('article');
        card.className = 'card';
        card.setAttribute('data-id', rab.id);
        
        card.innerHTML = `
            <h3>${rab.panti.name}</h3>
            <p><strong>Submission Date:</strong> ${rab.date}</p>
            <p><strong>Status:</strong> <span class="status-badge status-${rab.status}">${rab.status}</span></p>
            <button class="view" onclick="openRABModal(${rab.id})">View</button>
            <button class="accept" onclick="updateRABStatus(${rab.id}, ${rab.panti.id}, 'approved')" 
                    ${rab.status !== 'pending' ? 'disabled' : ''}>
                Accept
            </button>
            <button class="reject" onclick="updateRABStatus(${rab.id}, ${rab.panti.id}, 'rejected')"
                    ${rab.status !== 'pending' ? 'disabled' : ''}>
                Reject
            </button>
        `;
        
        container.appendChild(card);
    });
}

// Function to update RAB status using POST with _method=PUT
async function updateRABStatus(id, pantiId, status) {
    try {
        const formData = new FormData();
        formData.append('pantiId', pantiId);
        formData.append('status', status);

        const response = await fetch(`http://127.0.0.1:8000/api/v1/rab/${id}?_method=PUT`, {
            method: 'POST',
            body: formData
        });
        
        if (!response.ok) {
            throw new Error('Failed to update RAB status');
        }
        
        await fetchRABList();
    } catch (error) {
        console.error('Error updating RAB status:', error);
        alert('Failed to update RAB status. Please try again.');
    }
}

// Function to open modal and fetch RAB details
async function openRABModal(rabId) {
    try {
        const response = await fetch(`http://127.0.0.1:8000/api/v1/rab/${rabId}`);
        if (!response.ok) {
            throw new Error('Failed to fetch RAB details');
        }
        
        const data = await response.json();
        const rab = data.data;

        // Update modal content with RAB details
        document.getElementById('rab-title').textContent = `RAB Details - ${rab.panti.name}`;
        document.getElementById('rab-date').textContent = rab.date;
        document.getElementById('rab-status').textContent = rab.status;
        
        // If there are additional details you want to display
        let detailsHTML = `
            <strong>Panti:</strong> ${rab.panti.name}<br>
            <strong>Address:</strong> ${rab.panti.address || '-'}<br>
            <strong>Phone:</strong> ${rab.panti.phone || '-'}<br>
            <strong>Total Budget:</strong> ${formatCurrency(rab.total_budget || 0)}<br>
        `;
        document.getElementById('rab-details').innerHTML = detailsHTML;

        // Handle PDF
        if (rab.pdf) {
            const pdfBlobData = base64ToBlob(rab.pdf, 'application/pdf');
            const pdfUrl = URL.createObjectURL(pdfBlobData);
            
            // Set up PDF viewer
            const pdfViewer = document.getElementById('rab-pdf-viewer');
            pdfViewer.src = pdfUrl;
            pdfViewer.style.display = 'block';

            // Set up download link
            const pdfLink = document.getElementById('rab-pdf-link');
            pdfLink.href = pdfUrl;
            pdfLink.download = `RAB-${rab.panti.name}.pdf`;
            pdfLink.style.display = 'block';
        } else {
            document.getElementById('rab-pdf-viewer').style.display = 'none';
            document.getElementById('rab-pdf-link').style.display = 'none';
        }

        // Show modal
        const modal = document.getElementById('rab-modal');
        modal.style.display = 'block';

        // Clean up when modal is closed
        const closeBtn = document.querySelector('.close-btn');
        closeBtn.onclick = function() {
            modal.style.display = 'none';
            if (rab.pdf) {
                URL.revokeObjectURL(document.getElementById('rab-pdf-viewer').src);
            }
        };
    } catch (error) {
        console.error('Error loading RAB details:', error);
        alert('Failed to load RAB details. Please try again.');
    }
}

// Helper function to convert base64 to Blob
function base64ToBlob(base64, contentType) {
    const byteCharacters = atob(base64);
    const byteArrays = [];

    for (let offset = 0; offset < byteCharacters.length; offset += 512) {
        const slice = byteCharacters.slice(offset, offset + 512);
        const byteNumbers = new Array(slice.length);
        
        for (let i = 0; i < slice.length; i++) {
            byteNumbers[i] = slice.charCodeAt(i);
        }

        const byteArray = new Uint8Array(byteNumbers);
        byteArrays.push(byteArray);
    }

    return new Blob(byteArrays, { type: contentType });
}

// Helper function to format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR'
    }).format(amount);
}

// Initialize when document is loaded
document.addEventListener('DOMContentLoaded', () => {
    fetchRABList();
    
    // Set up modal close on outside click
    const modal = document.getElementById('rab-modal');
    window.onclick = function(event) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    };
});
