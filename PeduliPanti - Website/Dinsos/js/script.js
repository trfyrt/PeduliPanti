document.addEventListener('DOMContentLoaded', function() {
    const acceptButtons = document.querySelectorAll('.accept');
    const rejectButtons = document.querySelectorAll('.reject');

    acceptButtons.forEach(button => {
        button.addEventListener('click', function() {
            const confirmAccept = confirm("Are you sure you want to accept this submission?");
            if (confirmAccept) {
                // Handle the accept logic here
                alert("Submission accepted.");
            }
        });
    });

    rejectButtons.forEach(button => {
        button.addEventListener('click', function() {
            const confirmReject = confirm("Are you sure you want to reject this submission?");
            if (confirmReject) {
                // Handle the reject logic here
                alert("Submission rejected.");
            }
        });
    });
});
