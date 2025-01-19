const API_BASE_URL = 'https://127.0.0.1:8000';

async function fetchRequestList() {
  try {
    const response = await fetch('${https://127.0.0.1:8000}/api/v1/request-list');
    const data = await response.json();
    displayRequestList(data.data);
  } catch (error) {
    console.error('Error fetching request list:', error);
  }
}

function displayRequestList(requests) {
  const tbody = document.getElementById('requestListBody');
  tbody.innerHTML = '';

  requests.forEach(request => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
          <td>${request.panti.name}</td>
          <td>${request.products.name}</td>
          <td>${request.requested_qty}</td>
          <td>${request.donated_qty || 0}</td>
          <td><span class="status-badge status-${request.status_approval.toLowerCase()}">${request.status_approval}</span></td>
          <td>
              <button onclick="updateStatus(${request.id}, 'APPROVED')">Approve</button>
              <button onclick="updateStatus(${request.id}, 'REJECTED')">Reject</button>
              <button onclick="deleteRequest(${request.id})">Delete</button>
          </td>
      `;
      tbody.appendChild(tr);
  });
}

// Add new request
async function addRequest(formData) {
  try {
      const response = await fetch(`${'https://127.0.0.1:8000'}/api/v1/request-list`, {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json',
          },
          body: JSON.stringify(formData)
      });
      
      if (response.ok) {
          closeAddModal();
          fetchRequestList();
      }
  } catch (error) {
      console.error('Error adding request:', error);
  }
}

// Update request status
async function updateStatus(id, status) {
  try {
      const response = await fetch(`${'https://127.0.0.1:8000'}/api/v1/request-list/${id}/status`, {
          method: 'PUT',
          headers: {
              'Content-Type': 'application/json',
          },
          body: JSON.stringify({ status_approval: status })
      });

      if (response.ok) {
          fetchRequestList();
      }
  } catch (error) {
      console.error('Error updating status:', error);
  }
}

// Delete request
async function deleteRequest(id) {
  if (confirm('Are you sure you want to delete this request?')) {
      try {
          const response = await fetch(`${'https://127.0.0.1:8000'}/api/v1/request-list/${id}`, {
              method: 'DELETE'
          });

          if (response.ok) {
              fetchRequestList();
          }
      } catch (error) {
          console.error('Error deleting request:', error);
      }
  }
}

// Modal functions
function openAddModal() {
  document.getElementById('addModal').style.display = 'block';
}

function closeAddModal() {
  document.getElementById('addModal').style.display = 'none';
}

// Event Listeners
document.getElementById('addRequestForm').addEventListener('submit', (e) => {
  e.preventDefault();
  const formData = {
      pantiID: document.getElementById('pantiID').value,
      productID: document.getElementById('productID').value,
      requested_qty: document.getElementById('requested_qty').value
  };
  addRequest(formData);
});

// Initialize
document.addEventListener('DOMContentLoaded', () => {
  fetchRequestList();
});
