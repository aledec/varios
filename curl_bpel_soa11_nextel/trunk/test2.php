<?php

//initiate curl process
$ch = curl_init();
$url = "http://10.103.107.12:7777/BPELConsole/";

//set options
/*
There are a number of options, which you can use to manipulate
the behaviour of this ''invisible browser''.
See php.net/curl for more details.
*/
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/My Test Browser");
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 10);

//run the process and fetch the document
$doc = curl_exec($ch);

//terminate curl process
curl_close($ch);

//print output
echo $doc;

?>
