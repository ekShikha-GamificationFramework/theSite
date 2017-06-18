function change(){
	if(document.getElementById('usertype').value=="t"){
		document.getElementById('dob').style.display="none";
		document.getElementById('theClassDiv').style.display="none";
	}
	else if(document.getElementById("usertype").value="s"){
		document.getElementById('dob').style.display="block";
		document.getElementById('theClassDiv').style.display="block";
	}
}

if (!Object.prototype.watch) {
	Object.defineProperty(Object.prototype, "watch", {
		  enumerable: false
		, configurable: true
		, writable: false
		, value: function (prop, handler) {
			var
			  oldval = this[prop]
			, newval = oldval
			, getter = function () {
				return newval;
			}
			, setter = function (val) {
				oldval = newval;
				return newval = handler.call(this, prop, oldval, val);
			}
			;
			
			if (delete this[prop]) { // can't watch constants
				Object.defineProperty(this, prop, {
					  get: getter
					, set: setter
					, enumerable: true
					, configurable: true
				});
			}
		}
	});
}

// object.unwatch
if (!Object.prototype.unwatch) {
	Object.defineProperty(Object.prototype, "unwatch", {
		  enumerable: false
		, configurable: true
		, writable: false
		, value: function (prop) {
			var val = this[prop];
			delete this[prop]; // remove accessors
			this[prop] = val;
		}
	});
}	

var request;  

//dict has all the table row values
//type - select/insert/update -> s,i,u
function sendInfo(table, type, dict){  
	var url="../includes/ajaxHandler.jsp?table="+table+"&type="+type;  
	var keys = Object.keys(dict);

	for(a of keys){
		if(dict[a].constructor===Array){
			for(x of dict[a]){
				url=url+"&"+a+"="+ x;
			}
		}
		else{
			url=url+"&"+a+"="+dict[a];
		}
	}

	if(window.XMLHttpRequest){  
		request=new XMLHttpRequest();  
	}  
	else if(window.ActiveXObject){  
		request=new ActiveXObject("Microsoft.XMLHTTP");  
	}  

	try{  
		if(type=="s")	request.onreadystatechange=getInfo;  
		request.open("GET", url, true);  
		request.send();  
	}
	catch(e){
		alert("Unable to connect to server");
	}  
}  

function getInfo(){
	if(request.readyState==4){   
		console.log(JSON.parse(request.responseText));  
	}  
}