echo "🚀 Setting up FairFlight v2 (with loading animation)..."

# index.html
cat > index.html <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FairFlight App</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <h1>✈ FairFlight</h1>
    <p>Your flight made fair and easy.</p>

    <div class="form-group">
      <label for="origin">From:</label>
      <select id="origin">
        <option value="">Select origin</option>
        <option value="Nairobi">Nairobi</option>
        <option value="Mombasa">Mombasa</option>
        <option value="London">London</option>
        <option value="Dubai">Dubai</option>
      </select>
    </div>

    <div class="form-group">
      <label for="destination">To:</label>
      <select id="destination">
        <option value="">Select destination</option>
        <option value="Nairobi">Nairobi</option>
        <option value="Mombasa">Mombasa</option>
        <option value="London">London</option>
        <option value="Dubai">Dubai</option>
      </select>
    </div>

    <div class="form-group">
      <label for="date">Date:</label>
      <input type="date" id="date">
    </div>

    <div class="form-group">
      <label for="sort">Sort by:</label>
      <select id="sort">
        <option value="none">None</option>
        <option value="time">Departure</option>
        <option value="price">Price</option>
      </select>
    </div>

    <button id="checkFlightsBtn">Check Available Flights</button>

    <div id="flightResults" class="results"></div>
  </div>

  <script src="app.js" defer></script>
</body>
</html>
HTML

# style.css
cat > style.css <<'CSS'
body {
  font-family: Arial, sans-serif;
  background-color: #f5f5f5;
  margin: 0;
  padding: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.container {
  text-align: center;
  background-color: #fff;
  padding: 30px;
  border-radius: 15px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.2);
  max-width: 400px;
}

h1 {
  margin-bottom: 5px;
}

p {
  margin-bottom: 20px;
}

.form-group {
  margin-bottom: 15px;
  text-align: left;
}

label {
  display: block;
  margin-bottom: 5px;
}

select, input[type="date"] {
  width: 100%;
  padding: 8px;
  font-size: 14px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

button {
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
  border: none;
  background-color: #0077ff;
  color: white;
  border-radius: 5px;
  transition: background-color 0.2s ease;
  width: 100%;
}

button:hover {
  background-color: #005fcc;
}

.results {
  margin-top: 20px;
  font-size: 16px;
  text-align: left;
}

.loading {
  font-style: italic;
  color: gray;
}
CSS

# app.js
cat > app.js <<'JS'
document.getElementById("checkFlightsBtn").addEventListener("click", () => {
  const origin = document.getElementById("origin").value;
  const destination = document.getElementById("destination").value;
  const date = document.getElementById("date").value;
  const sort = document.getElementById("sort").value;

  const resultsDiv = document.getElementById("flightResults");
  resultsDiv.innerHTML = ""; // Clear previous results

  if (!origin || !destination || !date) {
    resultsDiv.textContent = "⚠ Please select origin, destination, and date.";
    return;
  }

  // Show loading animation
  const loadingMsg = document.createElement("p");
  loadingMsg.classList.add("loading");
  loadingMsg.textContent = "Loading flights...";
  resultsDiv.appendChild(loadingMsg);

  // Simulate loading delay
  setTimeout(() => {
    let flights = [
      { from: "Nairobi", to: "Mombasa", time: "08:00", price: 100 },
      { from: "Nairobi", to: "Mombasa", time: "12:00", price: 120 },
      { from: "Nairobi", to: "Mombasa", time: "16:00", price: 150 },
      { from: "London", to: "Dubai", time: "10:00", price: 400 },
      { from: "Dubai", to: "London", time: "18:00", price: 380 }
    ];

    // Filter
    flights = flights.filter(f => f.from === origin && f.to === destination);

    // Sort
    if (sort === "time") {
      flights.sort((a, b) => a.time.localeCompare(b.time));
    } else if (sort === "price") {
      flights.sort((a, b) => a.price - b.price);
    }

    resultsDiv.innerHTML = ""; // Clear "loading..."

    if (flights.length === 0) {
      resultsDiv.textContent = "No flights found for the selected route.";
      return;
    }

    // Show results
    flights.forEach(f => {
      const flightInfo = document.createElement("p");
      flightInfo.textContent = `✈ ${f.from} → ${f.to} | Date: ${date} | Time: ${f.time} | Price: $${f.price}`;
      resultsDiv.appendChild(flightInfo);
    });
  }, 1000); // 1 second delay for realism
});
JS

echo "✅ FairFlight v2 setup complete with loading animation!"
