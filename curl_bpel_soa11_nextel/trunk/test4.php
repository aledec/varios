<?php -v

//URL for BPEL
$url = "http://crmsoa10.nextel.com.mx/BPELConsole";

//RETURN FILE
$fp = fopen("return.txt", "w");

//CURL LOGIN INFORMATION
$username = "read";
$password = "read1234";

//COOKIE FILE
$cookie_file = "cookie.txt";

// INIT
$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, "http://crmsoa10.nextel.com.mx/BPELConsole/j_security_check");
curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_HEADER, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
//curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.3) Gecko/20070309 Firefox/2.0.0.3");
curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file);
//curl_setopt($ch, CURLOPT_REFERER, "https://unknown.com/common/Frames.jsp");
curl_setopt($ch, CURLOPT_REFERER, "http://crmsoa10.nextel.com.mx/BPELConsole/default/index.jsp");
curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
curl_setopt($ch, CURLOPT_VERBOSE, true);



  //curl_setopt($ch, CURLOPT_URL, $url);
  //curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/My Test Browser");
  //curl_setopt($ch, CURLOPT_HEADER, 0);
  //curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  //curl_setopt($ch, CURLOPT_TIMEOUT, 10);

  //curl_setopt ($ch, CURLOPT_URL, $url);
   //curl_setopt($ch, CURLOPT_URL, $url);
   //curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/My Test Browser");
   //curl_setopt($ch, CURLOPT_HEADER, 0);
   //curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
   //curl_setopt($ch, CURLOPT_TIMEOUT, 10);
   //curl_setopt($ch, CURLOPT_FILE, $fp);
   //curl_setopt($ch, CURLOPT_POSTFIELDS,
    //'Username=read&Password=read1234');
   //curl_setopt ($ch, CURLOPT_COOKIEJAR, $cookie_file);

    $result = curl_exec($ch);


//run a fetch
//$url = 











    curl_close ($ch);

    print $result;
?> 
