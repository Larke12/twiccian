// Open websocket connection to twicciand
var exampleSocket = new WebSocket("ws://localhost:1922/ws");

// Once the websocket opens, send a blank message
// I don't remember exactly why this does, might be just to affirm to twicciand that everything went alright
exampleSocket.onopen = function (event) {
    exampleSocket.send("");
}

// On message received from twicciand
exampleSocket.onmessage = function (event) {
    // Get current timestamp
    var s = (new Date()).toTimeString().substr(0,5)
    // Make sure we've received a proper message from the daemon
    if (event.data.search(/((\<span id='text'\>:)\s*(\<\/span\>)$)/) == -1) {
	// Create the timestamp object
	var timestamp = "<span id='timestamp'>" + s + "&nbsp;&nbsp;</span>";
	// Add a new message to the chat box
	document.getElementById('chat').innerHTML += '<div id="msg">';
	document.getElementById('chat').innerHTML += timestamp;
	document.getElementById('chat').innerHTML += checkMessage(event.data);
	document.getElementById('chat').innerHTML += '<br></div>';
	document.getElementById('chat').scrollTop = document.getElementById('chat').scrollHeight;
    }
}

// Send the message from the text box to the daemon
function sendMessage() {
    exampleSocket.send(document.getElementById("chatmsg").value);
    console.log(document.getElementById("chatmsg").value);
    // Clear the text box
    document.getElementById('chatmsg').value = "";
}

// Catch the Enter key so it can be used to submit the chat message from the text box
function process(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if (code == 13) { //Enter keycode
	sendMessage();
	if(event.preventDefault) event.preventDefault();
	return false;
    }
}

// Makes an XMLHttpRequest call
// Used as part of getting JSON data
function Get(yourUrl){
    var Httpreq = new XMLHttpRequest(); // a new request
    Httpreq.open("GET",yourUrl,false);
    Httpreq.send(null);
    return Httpreq.responseText;          
}

// This behemoth fetches all the emotes from Twitch and caches them in localStorage
function fetchEmotes() {
    // If the emotes already exist in localStorage, just pull them from there
    var json = JSON.parse(localStorage.getItem('jsoncache'));
    if (!json) {
	// Get the JSON object from Twitch's API endpoint
	json = JSON.parse(Get("https://api.twitch.tv/kraken/chat/emoticon_images"))["emoticons"];

	// Add the missing emotes (mostly the smilies) manually
	var smile = new Object();
	smile["id"] = 3;
	smile["code"] = ":D";
	smile["emoticon_set"] = null;
	json.push(smile);
	var smile2 = new Object();
	smile2["id"] = 3;
	smile2["code"] = ":-D";
	smile2["emoticon_set"] = null;
	json.push(smile2);
	var sunglasses = new Object();
	sunglasses["id"] = 7;
	sunglasses["code"] = "B)";
	sunglasses["emoticon_set"] = null;
	json.push(sunglasses);
	var sunglasses2 = new Object();
	sunglasses2["id"] = 7;
	sunglasses2["code"] = "B-)";
	sunglasses2["emoticon_set"] = null;
	json.push(sunglasses2);
	var pirate = new Object();
	pirate["id"] = 14;
	pirate["code"] = "R)";
	pirate["emoticon_set"] = null;
	json.push(pirate);
	var pirate2 = new Object();
	pirate2["id"] = 14;
	pirate2["code"] = "R-)";
	pirate2["emoticon_set"] = null;
	json.push(pirate2);
	var wink = new Object();
	wink["id"] = 11;
	wink["code"] = ";)";
	wink["emoticon_set"] = null;
	json.push(wink);
	var wink2 = new Object();
	wink2["id"] = 11;
	wink2["code"] = ";-)";
	wink2["emoticon_set"] = null;
	json.push(wink2);
	var agape = new Object();
	agape["id"] = 8;
	agape["code"] = ":o";
	agape["emoticon_set"] = null;
	json.push(agape);
	var agape2 = new Object();
	agape2["id"] = 8;
	agape2["code"] = ":O";
	agape2["emoticon_set"] = null;
	json.push(agape2);
	var smile = new Object();
	smile["id"] = 1;
	smile["code"] = ":)";
	smile["emoticon_set"] = null;
	json.push(smile);
	var smile2 = new Object();
	smile2["id"] = 1;
	smile2["code"] = ":-)";
	smile2["emoticon_set"] = null;
	json.push(smile2);
	var frown = new Object();
	frown["id"] = 2;
	frown["code"] = ":(";
	frown["emoticon_set"] = null;
	json.push(frown);
	var frown2 = new Object();
	frown2["id"] = 2;
	frown2["code"] = ":-(";
	frown2["emoticon_set"] = null;
	json.push(frown2);
	var p = new Object();
	p["id"] = 13;
	p["code"] = ";p";
	p["emoticon_set"] = null;
	json.push(p);
	var p2 = new Object();
	p2["id"] = 13;
	p2["code"] = ";-p";
	p2["emoticon_set"] = null;
	json.push(p2);
	var p3 = new Object();
	p3["id"] = 13;
	p3["code"] = ";P";
	p3["emoticon_set"] = null;
	json.push(p3);
	var p4 = new Object();
	p4["id"] = 13;
	p4["code"] = ";-P";
	p4["emoticon_set"] = null;
	json.push(p4);
	var boggle = new Object();
	boggle["id"] = 6;
	boggle["code"] = "o_O";
	boggle["emoticon_set"] = null;
	json.push(boggle);
	var boggle2 = new Object();
	boggle2["id"] = 6;
	boggle2["code"] = "O_o";
	boggle2["emoticon_set"] = null;
	json.push(boggle2);
	var boggle3 = new Object();
	boggle3["id"] = 6;
	boggle3["code"] = "o.O";
	boggle3["emoticon_set"] = null;
	json.push(boggle3);
	var boggle4 = new Object();
	boggle4["id"] = 6;
	boggle4["code"] = "O.o";
	boggle4["emoticon_set"] = null;
	json.push(boggle4);
	var anger = new Object();
	anger["id"] = 4;
	anger["code"] = "&gt;(";
	anger["emoticon_set"] = null;
	json.push(anger);
	var pout = new Object();
	pout["id"] = 10;
	pout["code"] = ":\\";
	pout["emoticon_set"] = null;
	json.push(pout);
	var pout2 = new Object();
	pout2["id"] = 10;
	pout2["code"] = ":-\\";
	pout2["emoticon_set"] = null;
	json.push(pout2);
	var pout3 = new Object();
	pout3["id"] = 10;
	pout3["code"] = ":/";
	pout3["emoticon_set"] = null;
	json.push(pout3);
	var pout4 = new Object();
	pout4["id"] = 10;
	pout4["code"] = ":-/";
	pout4["emoticon_set"] = null;
	json.push(pout4);
	var sleep = new Object();
	sleep["id"] = 5;
	sleep["code"] = ":z";
	sleep["emoticon_set"] = null;
	json.push(sleep);
	var sleep2 = new Object();
	sleep2["id"] = 5;
	sleep2["code"] = ":Z";
	sleep2["emoticon_set"] = null;
	json.push(sleep2);
	var sleep3 = new Object();
	sleep3["id"] = 5;
	sleep3["code"] = ":|";
	sleep3["emoticon_set"] = null;
	json.push(sleep3);
	var sleep4 = new Object();
	sleep4["id"] = 5;
	sleep4["code"] = ":-z";
	sleep4["emoticon_set"] = null;
	json.push(sleep4);
	var sleep5 = new Object();
	sleep5["id"] = 5;
	sleep5["code"] = ":-Z";
	sleep5["emoticon_set"] = null;
	json.push(sleep5);
	var sleep6 = new Object();
	sleep6["id"] = 5;
	sleep6["code"] = ":-|";
	sleep6["emoticon_set"] = null;
	json.push(sleep6);
	var pt = new Object();
	pt["id"] = 12;
	pt["code"] = ":p";
	pt["emoticon_set"] = null;
	json.push(pt);
	var pt2 = new Object();
	pt2["id"] = 12;
	pt2["code"] = ":-p";
	pt2["emoticon_set"] = null;
	json.push(pt2);
	var pt3 = new Object();
	pt3["id"] = 12;
	pt3["code"] = ":P";
	pt3["emoticon_set"] = null;
	json.push(pt3);
	var pt4 = new Object();
	pt4["id"] = 12;
	pt4["code"] = ":-P";
	pt4["emoticon_set"] = null;
	json.push(pt4);
	var heart = new Object();
	heart["id"] = 9;
	heart["code"] = "&lt;3";
	heart["emoticon_set"] = null;
	json.push(heart);
	// Cache all the emotes to localStorage
	localStorage.setItem('jsoncache', JSON.stringify(json));
    }

    console.log(json);

    // Initialize an empty hashmap for the emotes
    window.tagMap = {};
    var i = null;

    // Loop through the emotes array and create a hashmap of the image corresponding to each string
    for (i = 0; json.length > i; i += 1) {
	tagMap[json[i].code] = json[i].id;
    }

    // Debug output
    console.log(searchEmote("B-)"));
    console.log(searchEmote("B)"));
}

// Looks for an emote in the hashmap from the given string
function searchEmote(emote) {
    if (window.tagMap[emote] != null)
	return window.tagMap[emote];
    return -1;
}

// Splits each chat message into an array of words, and checks every one to see if it's a valid emote
// If it finds one, it replaces it with the appropriate image tag
function checkMessage(rec) {
    var msg = rec.split(" ");
    for (i = 0; i <= msg.length ; i ++) {
	var img = searchEmote(msg[i]);
	if (img != -1) {
	    url = 'https://static-cdn.jtvnw.net/emoticons/v1/' + window.tagMap[msg[i]] + '/1.0';
	    console.log(url);
	    msg[i] = "<img src=\"" + url + "\" alt=\"" + msg[i] + "\" title=\"" + msg[i] + "\"/>";
	}
    }
    return msg.join(" ");
}
