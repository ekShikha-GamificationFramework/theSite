<!DOCTYPE html>
<html>
    <head>
        <link href="/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="/css/styles.css" rel="stylesheet"/>

        <?php if (isset($title)): ?>
            <title>ekShiksha Gamification: <?= htmlspecialchars($title) ?></title>
        <?php else: ?>
            <title>ekShiksha Gamification</title>
        <?php endif ?>

        <script src="/js/jquery-1.11.3.min.js"></script>
        <script src="/js/bootstrap.min.js"></script>
        <script src="/js/scripts.js"></script>

    </head>
    <body>
        <div class="container">
            <div id="top">
                <div>
                    <a href="/"><img alt="Gamification" src="/img/logo.png"/></a>
                </div>
                <?php if (!empty($_SESSION["id"]) && $_SESSION["type"]==1 ): ?>
                    <ul class="nav nav-pills">
                        <li><a href="index.php">Home</a></li>
                        <li><a href="create_game.php">Gamify</a></li>
                        <li><a href="stats.php">Assess</a></li>
                        <li><a href="logout.php"><strong>Log Out</strong></a></li>
                    </ul>
                <?php endif ?>
            </div>
            
            <div id="middle">
