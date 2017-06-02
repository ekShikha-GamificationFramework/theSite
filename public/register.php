<?php
	require("../includes/config.php");
	if ($_SERVER["REQUEST_METHOD"] == "GET"){
		render("register_form.php", ["title" => "Register"]);
	}
	else if ($_SERVER["REQUEST_METHOD"] == "POST"){
		
	}
?>