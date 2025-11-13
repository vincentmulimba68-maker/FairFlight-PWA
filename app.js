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
