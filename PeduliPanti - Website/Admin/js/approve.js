async function updateApprovalStatus(id, status) {
    const response = await fetch(`http://127.0.0.1:8000/api/v1/request_list/${id}/status`, {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status_approval: status }),
    });

    if (!response.ok) {
        console.error('Failed to update approval status:', response.statusText);
    } else {
        console.log('Approval status updated successfully');
    }
}

// Attach event listeners to accept and reject buttons
document.querySelectorAll('.accept').forEach(button => {
    button.addEventListener('click', function() {
        const itemId = this.closest('.item').dataset.id; // Assuming each item has a data-id attribute
        updateApprovalStatus(itemId, 'approved');
    });
});

document.querySelectorAll('.reject').forEach(button => {
    button.addEventListener('click', function() {
        const itemId = this.closest('.item').dataset.id; // Assuming each item has a data-id attribute
        updateApprovalStatus(itemId, 'rejected');
    });
});
