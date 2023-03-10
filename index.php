<?php

echo $_SERVER['HTTP_USER_AGENT'];

$scripts_dir = "scripts";

if str_contains($_SERVER['HTTP_USER_AGENT'], "Windows") {
    $script = "install.ps1";
} else {
    $script = "install.sh";
}

$file = "$scripts_dir/$script";

# https://stackoverflow.com/a/27805443
$finfo = finfo_open("text/plain");
header("Content-Type: " . finfo_file($finfo, $file));
finfo_close($finfo);

header("Content-Disposition: attachment; filename=$script");
header("Expires: 0");
header("Cache-Control: must-revalidate");
header("Pragma: public");
header("Content-Length: " . filesize($file));

ob_clean();
flush();
readfile(file);
exit;
