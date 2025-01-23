const API_BASE_URL = 'http://127.0.0.1:8000';

// Function to fetch request list data
async function fetchRequestList() {
  try {
      const response = await fetch('http://127.0.0.1:8000/api/v1/request_list');
      if (!response.ok) {
          throw new Error('Network response was not ok');
      }
      const data = await response.json();
      displayRequestList(data.data);
  } catch (error) {
      console.error('Error fetching request list:', error);
      document.getElementById('requestListBody').innerHTML = `
          <tr>
              <td colspan="6" style="text-align: center; color: red;">
                  Failed to load data. Please try again later.
              </td>
          </tr>`;
  }
}

// Function to update request status
async function updateApprovalStatus(id, status) {
  try {
      const response = await fetch(`http://127.0.0.1:8000/api/v1/request_list/${id}/status`, {
          method: 'PATCH',
          headers: {
              'Content-Type': 'application/json',
          },
          body: JSON.stringify({
              status_approval: status
          })
      });
      
      if (!response.ok) {
          throw new Error('Failed to update status');
      }
      
      // Refresh the table after successful update
      await fetchRequestList();
  } catch (error) {
      console.error('Error updating status:', error);
      alert('Failed to update status. Please try again.');
  }
}

// Function to display request list in table
function displayRequestList(requests) {
  const tableBody = document.getElementById('requestListBody');
  tableBody.innerHTML = '';

  requests.forEach(request => {
      const row = document.createElement('tr');
      
      // Create status badge class based on approval status
      const statusClass = `status-badge status-${request.status_approval}`;
      
      row.innerHTML = `
          <td>${request.panti.name}</td>
          <td>${request.product.name}</td>
          <td>${request.requested_qty}</td>
          <td>${request.donated_qty}</td>
          <td><span class="${statusClass}">${request.status_approval}</span></td>
          <td>
              <button onclick="updateApprovalStatus(${request.id}, 'approved')" 
                      ${request.status_approval !== 'pending' ? 'disabled' : ''}>
                  Accept
              </button>
              <button onclick="updateApprovalStatus(${request.id}, 'rejected')"
                      ${request.status_approval !== 'pending' ? 'disabled' : ''}>
                  Reject
              </button>
          </td>
      `;
      
      tableBody.appendChild(row);
  });
}

// Function to handle search
function handleSearch() {
  const searchInput = document.getElementById('searchInput');
  const searchTerm = searchInput.value.toLowerCase();
  const rows = document.getElementById('requestListBody').getElementsByTagName('tr');

  Array.from(rows).forEach(row => {
      const pantiName = row.cells[0].textContent.toLowerCase();
      const productName = row.cells[1].textContent.toLowerCase();
      const visible = pantiName.includes(searchTerm) || productName.includes(searchTerm);
      row.style.display = visible ? '' : 'none';
  });
}

// Add event listeners
document.addEventListener('DOMContentLoaded', () => {
  fetchRequestList();
  
  // Add search functionality
  const searchInput = document.getElementById('searchInput');
  searchInput.addEventListener('input', handleSearch);
});