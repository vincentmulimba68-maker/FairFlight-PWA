#!/bin/bash
# === FairFlight PWA Full Auto Setup === This 
# creates all main app files and the random 
# flight updater in one go
echo "🚀 Setting up FairFlight PWA..."
# --- index.html ---
cat > index.html <<'EOF' <!DOCTYPE html> <html 
lang="en"> <head>
  <meta charset="UTF-8" /> <meta 
  name="viewport" content="width=device-width, 
  initial-scale=1.0" /> 
  <title>FairFlight</title> <link 
  rel="stylesheet" href="style.css" /> <link 
  rel="manifest" href="manifest.json" /> 
  <script defer src="app.js"></script>
</head> <body> <header> <h1>✈️ FairFlight</h1> 
    <p>Your simple real-time flight tracker</p>
  </header> <main> <button id="refresh-btn">🔄 
    Check Available Flights</button> <p 
    id="status">Fetching flights...</p> <ul 
    id="flights-list"></ul>
  </main> <footer> <p>© 2025 FairFlight | 
    Offline-ready PWA</p>
  </footer> </body> </html> EOF
# --- style.css ---
cat > style.css <<'EOF' body { font-family: 
  Arial, sans-serif; background: #f2f6fc; 
  color: #333; text-align: center; margin: 0; 
  padding: 0;
}
header { background: #0078d7; color: white; 
  padding: 1em 0;
}
button { background: #0078d7; color: white; 
  border: none; padding: 10px 16px; 
  border-radius: 6px; margin: 15px; cursor: 
  pointer;
}
button:hover { background: #005fa3;
}
#status {
  color: #555; margin-bottom: 10px;
}
ul { list-style: none; padding: 0;
}
li { background: white; margin: 8px auto; 
  width: 90%; border-radius: 8px; box-shadow: 0 
  2px 5px rgba(0,0,0,0.1); padding: 10px; 
  text-align: left;
}
footer { margin-top: 20px; font-size: 0.8em; 
  color: #666;
}
EOF
# --- app.js ---
cat > app.js <<'EOF' async function 
loadFlights() {
  const status = 
  document.getElementById('status'); const list 
  = document.getElementById('flights-list'); 
  status.textContent = "Loading latest 
  flights..."; list.innerHTML = ""; try {
    const res = await 
    fetch('flights.json?cachebust=' + 
    Date.now()); const flights = await 
    res.json(); if (flights.length === 0) {
      status.textContent = "No flights 
      available."; return;
    }
    status.textContent = "Available Flights 
    (Auto-updating every 30s):"; 
    flights.forEach(f => {
      const li = document.createElement('li'); 
      li.textContent = `✈️ ${f.from} → ${f.to} | 
      🕒 ${f.time} | 💲${f.price}`; 
      list.appendChild(li);
    });
  } catch (err) {
    status.textContent = "Failed to load 
    flights.";
  }
}
document.getElementById('refresh-btn').addEventListener('click', 
loadFlights); setInterval(loadFlights, 30000); 
loadFlights(); EOF
# --- manifest.json ---
cat > manifest.json <<'EOF' { "name": 
  "FairFlight", "short_name": "FairFlight", 
  "start_url": ".", "display": "standalone", 
  "background_color": "#0078d7", "theme_color": 
  "#0078d7", "icons": [
    { "src": "icon.svg", "sizes": "512x512", 
      "type": "image/svg+xml"
    }
  ]
}
EOF
# --- sw.js (service worker) ---
cat > sw.js <<'EOF' 
self.addEventListener('install', e => {
  e.waitUntil( 
    caches.open('fairflight-cache').then(cache 
    => {
      return cache.addAll([ '/', '/index.html', 
        '/style.css', '/app.js', 
        '/manifest.json', '/flights.json'
      ]);
    })
  );
});
self.addEventListener('fetch', e => { 
  e.respondWith(
    caches.match(e.request).then(response => { 
      return response || fetch(e.request);
    })
  );
});
EOF
# --- flights.json (initial empty data) ---
cat > flights.json <<'EOF' [] EOF
# --- update_flights_random.sh ---
cat > update_flights_random.sh <<'EOF'
#!/bin/bash
# Random flight generator for FairFlight
FLIGHTS_FILE="flights.json"
# Create file if missing
[ ! -f "$FLIGHTS_FILE" ] && echo "[]" > 
"$FLIGHTS_FILE"
# Generate random flight
FROM_CITIES=("Nairobi" "Mombasa" "Kisumu" 
"Eldoret" "Malindi") TO_CITIES=("Mombasa" 
"Nairobi" "Kisumu" "Eldoret" "Malindi") 
TIMES=("06:15" "09:45" "11:30" "14:10" "16:50" 
"19:20") PRICES=(89 110 132 158 224 260) 
FROM=${FROM_CITIES[$RANDOM % 
${#FROM_CITIES[@]}]} TO=${TO_CITIES[$RANDOM % 
${#TO_CITIES[@]}]} TIME=${TIMES[$RANDOM % 
${#TIMES[@]}]} PRICE=${PRICES[$RANDOM % 
${#PRICES[@]}]}
# Read, append, and save JSON
jq --arg from "$FROM" --arg to "$TO" --arg time 
"$TIME" --arg price "$PRICE" \ '. += 
[{"from":$from,"to":$to,"time":$time,"price":$price}]' 
"$FLIGHTS_FILE" > tmp.json && mv tmp.json 
"$FLIGHTS_FILE" echo "✅ Added flight: $FROM → 
$TO | Time: $TIME | Price: \$$PRICE" EOF chmod 
+x update_flights_random.sh
# --- auto_update_flights.sh (background 
# updater) ---
cat > auto_update_flights.sh <<'EOF'
#!/bin/bash
# Automatically add random flights every 5 
# minutes
while true; do echo "🔁 Auto-updating 
  flights..." 
  ~/FairFlight-PWA/update_flights_random.sh 
  sleep 300
done EOF chmod +x auto_update_flights.sh echo 
"✅ All FairFlight files (including flight 
updater) created successfully!" EOF ---
## ⚙️ Step 2: Run it once
In Termux: ```bash chmod +x setup_fairflight.sh
./setup_fairflight.sh
