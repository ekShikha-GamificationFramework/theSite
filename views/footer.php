            </div>

            <div id="bottom">
                Brought to you by <a href="https://github.com/achie27">achie27</a>.
                <?php
                    if(isset($_SESSION["id"]) && $title != "Change Password")
                        print("<br/> <a href = 'password.php' > Change Password</a>");
                ?>
            </div>

        </div>

    </body>

</html>
