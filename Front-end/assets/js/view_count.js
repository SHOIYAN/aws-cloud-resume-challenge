// Javascript code

document.addEventListener('DOMContentLoaded', function() {
    // POST method to increment the visitor count
    fetch('https://9gczilbu81.execute-api.us-east-1.amazonaws.com/prod/myfunc', {
      method: 'POST'
    }).catch(error => {
      console.error('Error updating view count:', error);
    });
  
    // GET method to retrieve the current visitor count and display it on the webpage
    async function getCurrentViewCount() {
      try {
        const response = await fetch('https://9gczilbu81.execute-api.us-east-1.amazonaws.com/prod/myfunc');
        const data = await response.json();
        const viewCount = data.views;  // Use 'views' (not 'view') from the API response
        const countElement = document.getElementById('views');
        countElement.innerText = viewCount;  // Display the correct view count
      } catch (error) {
        console.error('Error loading view count:', error);
        const countElement = document.getElementById('views');
        countElement.innerText = 'Error loading view count';
      }
    }
  
    // Call the GET function to update the count on the webpage
    getCurrentViewCount();
  });