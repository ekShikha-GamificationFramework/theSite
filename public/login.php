<?php

    // configuration
    require("../includes/config.php"); 

    // if user reached page via GET (as by clicking a link or via redirect)
    if ($_SERVER["REQUEST_METHOD"] == "GET")
    {
        // else render form
        render("login_form.php", ["title" => "Log In"]);
    }

    // else if user reached page via POST (as by submitting a form via POST)
    else if ($_SERVER["REQUEST_METHOD"] == "POST"){
        // validate submission
        if (empty($_POST["username"])){
            apologize("You must provide your username.");
        }
        else if (empty($_POST["password"])){
            apologize("You must provide your password.");
        }

        // query database for user
        $servername = "localhost";
		$username = "root";
		$password = "root";
		$dbname = "ekshiksha_gamification";
		$rows=null;

		try {
		    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
		    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		    // prepare sql and bind parameters
		    $stmt = $conn->prepare("SELECT * FROM teacher WHERE id = :userid");
		    
		    $stmt->bindParam(':userid', $_POST["userid"]);
		    $stmt->execute();

		    $rows = $stmt->fetch();
		    //print("<p>{$stmt->fetch()}<p>")
		    
		}
		catch(PDOException $e){
	    	apologize("ERROR :" . $e->getMessage());
	    }
		
		$conn = null;

        // if we found user, check password
        if (count($rows) == 1)
        {
            // first (and only) row
            $row = $rows[0];

            // compare hash of user's input against hash that's in database
            if (password_verify($_POST["password"], $row["hash"]))
            {
                // remember that user's now logged in by storing user's ID in session
                $_SESSION["id"] = $row["id"];

                // redirect to portfolio
                redirect("/");
            }
        }

        // else apologize
        apologize("Invalid username and/or password.");
    }

?>
