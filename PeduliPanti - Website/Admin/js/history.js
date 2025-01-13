document.addEventListener("DOMContentLoaded", () => {
    const tableBody = document.querySelector("#historyTable tbody");
  
    // Fetch data from the API
    fetch("https://your-backend-url/api/v1/orders") // Butuh Link API mu back-end kuh :v
      .then((response) => {
        if (!response.ok) throw new Error("Failed to fetch data");
        return response.json();
      })
      .then((data) => {
        data.forEach((order) => {
          const row = document.createElement("tr");
          row.innerHTML = `
            <td>${order.id}</td>
            <td>${order.customer_name}</td>
            <td>${new Date(order.created_at).toLocaleDateString()}</td>
            <td>${order.amount}</td>
            <td>${order.status}</td>
          `;
          tableBody.appendChild(row);
        });
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
        tableBody.innerHTML = `<tr><td colspan="5">Error loading data</td></tr>`;
      });
  });
  