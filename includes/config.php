<?php

    // display errors, warnings, and notices
    ini_set("display_errors", true);
    error_reporting(E_ALL);

    // requirements
    require("helpers.php");

    // enable sessions
    session_start();

    // require authentication for all pages except /index.php, /login.php, /logout.php, and /register.php
    if (!in_array($_SERVER["PHP_SELF"], ["/index.php", "/login.php", "/logout.php", "/register.php"]))
    {
        if (empty($_SESSION["id"]))
        {
            redirect("login.php");
        }
    }

?>
