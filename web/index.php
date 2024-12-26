<?php
// web/index.php

include $_SERVER["DOCUMENT_ROOT"] . "/inc/main.php";

// Check user session
if ($_SESSION["user"] != "admin" && !isset($_SESSION["user"])) {
	header("Location: /login/");
	exit();
}

// Initialize messages array
$_SESSION["messages"] = [];

if (!empty($_POST["domain"]) && check_csrf($_POST["token"])) {
	try {
		// Validate inputs
		$user = clean_string($_SESSION["user"]);
		$domain = clean_string($_POST["domain"]);
		$app_name = clean_string($_POST["app_name"]);

		if (!is_valid_domain($domain) || !is_valid_username($user)) {
			throw new Exception("Invalid input parameters");
		}

		// Execute deployment
		exec(
			HESTIA_CMD .
				"v-deploy-nextjs " .
				escapeshellarg($domain) .
				" " .
				escapeshellarg($user) .
				" " .
				escapeshellarg($app_name),
			$output,
			$return_var,
		);

		if ($return_var !== 0) {
			throw new Exception("Deployment failed: " . implode("\n", $output));
		}

		$_SESSION["messages"][] = [
			"type" => "success",
			"text" => "Deployment completed successfully",
		];
		log_event("system", "info", "Next.js deployment completed for " . $domain);
	} catch (Exception $e) {
		$_SESSION["messages"][] = ["type" => "error", "text" => $e->getMessage()];
		log_event("system", "error", $e->getMessage());
	}
}

// Render template
require_once "../templates/deploy.php";
