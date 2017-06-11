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
