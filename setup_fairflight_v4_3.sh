#!/bin/bash
echo "🚀 Setting up FairFlight v4.3 PWA (New Flights Alert)..."

# index.html
cat > index.html <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FairFlight PWA v4.3</title>
<link rel="stylesheet" href="style.css">
<link rel="manifest" href="manifest.json">
</head>
<body>
<h1>FairFlight</h1>
<p>Your flight made fair and easy.</p>

<label>From:</label>
<select id="from">
<option value="">Select origin</option>
<option value="Nairobi">Nairobi</option>
<option value="Mombasa">Mombasa</option>
<option value="Kisumu">Kisumu</option>
</select>

<label>To:</label>
<select id="to">
<option value="">Select destination</option>
<option value="Mombasa">Mombasa</option>
<option value="Nairobi">Nairobi</option>
<option value="Kisumu">Kisumu</option>
</select>

<label>Date:</label>
<input type="date" id="date">

<label>Sort by:</label>
<select id="sort">
<option value="none">None</option>
<option value="price">Price</option>
<option value="departure">Departure</option>
</select>

<button id="checkFlightsBtn">Check Available Flights</button>
<div id="flightResults"></div>

<script src="app.js"></script>
<script>
if ('serviceWorker' in navigator) {
navigator.serviceWorker.register('sw.js').then(()=>console.log('SW registered')).catch(err=>console.log(err));
}
</script>
</body>
</html>
HTML

# style.css
cat > style.css <<'CSS'
body{font-family:Arial;background:#f5f5f5;margin:0;padding:0;display:flex;justify-content:center;align-items:center;height:100vh;}
h1,p{text-align:center;margin:5px 0;}
label{display:block;margin-top:10px;}
select,input[type="date"]{width:100%;padding:8px;margin-bottom:5px;border:1px solid #ccc;border-radius:5px;}
button{width:100%;padding:10px;margin-top:10px;background:#0077ff;color:#fff;border:none;border-radius:5px;cursor:pointer;}
button:hover{background:#005fcc;}
#flightResults{margin-top:15px;font-size:16px;}
.loading{font-style:italic;color:gray;}
CSS

# app.js with New Flights Alert
cat > app.js <<'JS'
document.addEventListener("DOMContentLoaded",()=>{
const from=document.getElementById("from");
const to=document.getElementById("to");
const date=document.getElementById("date");
const sort=document.getElementById("sort");
const resultsDiv=document.getElementById("flightResults");
const checkBtn=document.getElementById("checkFlightsBtn");

let lastFlightsHash="";
let firstLoad=true;

const savedData=JSON.parse(localStorage.getItem("fairflight-data"));
if(savedData){from.value=savedData.from||"";to.value=savedData.to||"";date.value=savedData.date||"";sort.value=savedData.sort||"none";}

async function hashFlights(data){return btoa(JSON.stringify(data));}

async function loadFlights(){
const searchData={from:from.value,to:to.value,date:date.value,sort:sort.value};
localStorage.setItem("fairflight-data",JSON.stringify(searchData));
resultsDiv.innerHTML="<p class='loading'>⏳ Loading flights...</p>";

try{
const res=await fetch("flights.json?cachebust="+Date.now());
const flights=await res.json();
const currentHash=await hashFlights(flights);

if(!firstLoad && currentHash!==lastFlightsHash){
alert("🛫 New flights are available!");
}
firstLoad=false;
lastFlightsHash=currentHash;

let filtered=flights.filter(f=>f.from===searchData.from&&f.to===searchData.to);
if(searchData.sort==="price"){filtered.sort((a,b)=>a.price-b.price);}
else if(searchData.sort==="departure"){filtered.sort((a,b)=>a.time.localeCompare(b.time));}
resultsDiv.innerHTML="";
if(filtered.length===0){resultsDiv.innerHTML="<p>❌ No flights found.</p>";return;}
filtered.forEach(f=>{
const flightInfo=document.createElement("p");
flightInfo.textContent=`✈ ${f.from} → ${f.to} | Date: ${searchData.date} | Time: ${f.time} | Price: $${f.price}`;
resultsDiv.appendChild(flightInfo);
});
}catch(e){resultsDiv.innerHTML="<p>❌ Error loading flights.</p>";console.log(e);}
}

// Load on click
checkBtn.addEventListener("click",loadFlights);

// Smart auto-refresh every 15 seconds
setInterval(()=>{
if(from.value && to.value && date.value){
loadFlights();
}
},15000);
});
JS

# manifest.json
cat > manifest.json <<'JSON'
{"name":"FairFlight","short_name":"FairFlight","start_url":"./","display":"standalone","background_color":"#f5f5f5","theme_color":"#0077ff","icons":[{"src":"icon.svg","sizes":"192x192","type":"image/svg+xml"}]}
JSON

# service worker
cat > sw.js <<'JS'
const cacheName='fairflight-v4.3';
const assets=['/','index.html','style.css','app.js','manifest.json','flights.json','icon.svg'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(cacheName).then(c=>c.addAll(assets)));});
self.addEventListener('fetch',e=>{e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request)));});
JS

echo "✅ FairFlight v4.3 setup complete with New Flights Alert!"
