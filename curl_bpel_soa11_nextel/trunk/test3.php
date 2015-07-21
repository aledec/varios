<?php

//the basics
$ch = curl_init();
//$url = "http://www.example.com/privatefiles/login.php";
$url = "http://10.103.107.12:7777/BPELConsole/";
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/My Test Browser");
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 10);

//enable the POST method
curl_setopt($ch, CURLOPT_POST, 1);

//identify the form values for credentials
curl_setopt($ch, CURLOPT_POSTFIELDS,
//'username=admin&password=Admin00x');
'Username=read&Password=read1234');

//set location of cookie jar, the file that will hold
the cookies for the duration of the process
curl_setopt ($ch, CURLOPT_COOKIEJAR, ''cookie.txt'');

//run the process to login
$auth = curl_exec($ch);

//run the process to fetch file #1

$url = "http://10.103.107.12:7777/BPELConsole/default/xmlGetAuditTrail.jsp?referenceId=bpel://localhost/default/TransformAppContextSiebelService~1.0/2462308&mode=audit";
curl_setopt($ch, CURLOPT_URL, $url);
$file1 = curl_exec($ch);
//$url = "http://www.example.com/privatefiles/file1.txt";
//curl_setopt($ch, CURLOPT_URL, $url);
//$file1 = curl_exec($ch);

//run the process to fetch file #2
//$url = "http://www.example.com/privatefiles/file2.txt";
//curl_setopt($ch, CURLOPT_URL, $url);
//$file2 = curl_exec($ch);

//run the process to fetch file #3
//$url = "http://www.example.com/privatefiles/file3.txt";
//curl_setopt($ch, CURLOPT_URL, $url);
//$file3 = curl_exec($ch);
terminate curl process

//free up the system
curl_close($ch);

?>
