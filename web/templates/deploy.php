<!-- web/templates/deploy.php -->
<?php include $_SERVER["DOCUMENT_ROOT"] . "/templates/header.php"; ?>

<div class="toolbar">
    <div class="toolbar-inner">
        <div class="toolbar-buttons">
            <a class="button button-secondary" href="/list/web/">Back</a>
        </div>
    </div>
</div>

<div class="container">
    <form method="post" name="deploy">
        <input type="hidden" name="token" value="<?= $_SESSION["token"] ?>">

        <div class="form-group">
            <label for="domain">Domain</label>
            <input type="text" class="form-control" name="domain" id="domain" required>
        </div>

        <div class="form-group">
            <label for="app_name">Application Name</label>
            <input type="text" class="form-control" name="app_name" id="app_name" required>
        </div>

        <button type="submit" class="button">Deploy</button>
    </form>
</div>

<?php include $_SERVER["DOCUMENT_ROOT"] . "/templates/footer.php"; ?>
