<?php

$user_agent = $_SERVER['HTTP_USER_AGENT'];

if (strpos($user_agent, 'Windows') !== false) {
    // User is on Windows
    $filename = 'install.ps1';
} else {
    // User is whatever else that probably has bash
    $filename = 'install.sh';
}

header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Content-Transfer-Encoding: binary');
header('Content-Length: ' . filesize($filename));

readfile($filename);

?>
