const API_BASE_URL = 'http://127.0.0.1:8000';

// Function to fetch Panti Detail data
async function fetchPantiDetail() {
  try {
    const response = await fetch(`${API_BASE_URL}/api/v1/panti_detail`);
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const data = await response.json();
    displayPantiDetail(data.data);
  } catch (error) {
    console.error('Error fetching Panti Detail:', error);
    document.getElementById('requestListBody').innerHTML = `
      <tr>
        <td colspan="6" style="text-align: center; color: red;">
          Failed to load data. Please try again later.
        </td>
      </tr>`;
  }
}

// Function to display Panti Detail in table
function displayPantiDetail(pantiList) {
  const tableBody = document.getElementById('requestListBody');
  tableBody.innerHTML = '';

  pantiList.forEach(panti => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${panti.id}</td>
      <td>${panti.name}</td>
      <td>${panti.childNumber}</td>
      <td>${panti.foundingDate}</td>
      <td>${panti.priorityValue}</td>
      <td>
        <button onclick="viewDetails(${panti.id})">View</button>
        <button onclick="editPanti(${panti.id})">Edit</button>
        <button onclick="deletePanti(${panti.id})">Delete</button>
        <button onclick="calculate(${panti.id})">Calculate Priorities</button>
      </td>
    `;
    
    tableBody.appendChild(row);
  });
}

// Function to open calculate modal
function calculate(pantiId) {
  const modal = document.getElementById('priority-modal');
  modal.innerHTML = `
    <div class="modal-content">
      <span class="close-btn">&times;</span>
      <h2>Calculate Priorities - Panti ID: ${pantiId}</h2>
      <p>Harap masukkan skor survey</p>
      <input type="number" id="welfare-score-input" placeholder="Masukkan Welfare Score">
      <button onclick="submitPriorityCalculation(${pantiId})">Submit</button>
    </div>
  `;
  
  modal.style.display = 'block';

  // Close button functionality
  const closeBtn = modal.querySelector('.close-btn');
  closeBtn.onclick = () => {
    modal.style.display = 'none';
  };
}

// Function to submit priority calculation
async function submitPriorityCalculation(pantiId) {
  const welfareScoreInput = document.getElementById('welfare-score-input');
  const welfareScore = parseFloat(welfareScoreInput.value);

  // Basic validation
  if (isNaN(welfareScore)) {
    alert('Please enter a valid welfare score');
    return;
  }

  try {
    const response = await fetch(`${API_BASE_URL}/api/v1/panti_detail/${pantiId}/calculate`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        welfare_score: welfareScore
      })
    });

    if (!response.ok) {
      throw new Error('Failed to calculate priorities');
    }

    const data = await response.json();
    alert('Priorities calculated successfully!');
    
    // Close modal
    document.getElementById('priority-modal').style.display = 'none';
  } catch (error) {
    console.error('Error calculating priorities:', error);
    alert('Failed to calculate priorities. Please try again.');
  }
}

// Placeholder functions for other actions
function viewDetails(id) {
  console.log(`Viewing details for Panti ID: ${id}`);
}

function editPanti(id) {
  console.log(`Editing Panti with ID: ${id}`);
}

function deletePanti(id) {
  console.log(`Deleting Panti with ID: ${id}`);
}

// Add event listeners
document.addEventListener('DOMContentLoaded', () => {
  fetchPantiDetail();
});