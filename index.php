<?php

$user_agent = $_SERVER['HTTP_USER_AGENT'];

if (strpos($user_agent, 'Windows')) {
    # some windows client
    echo("Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://" . $_SERVER['HTTP_HOST'] . "/install'))");
    exit;
} elseif (empty($user_agent)) {
    # powershell net.webclient doesn't set any useragent
    $filename = 'install.ps1';
} else {
    # whatever else that probably has bash
    $filename = 'install.sh';
}

header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Content-Transfer-Encoding: binary');
header('Content-Length: ' . filesize($filename));

readfile($filename);
