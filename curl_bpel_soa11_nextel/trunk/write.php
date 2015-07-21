  <?php

/**function getInput() {
  $fr = fopen("php://stdin", "r");
  while (!feof ($fr)) {
    $ordernumber .= fgets($fr);
  }
  fclose($fr);
  return $ordernumber;
}


$order = getInput();
$ordernumber = "$order";
print $ordernumber;
**/

function arguments($argv) {
    $_ARG = array();
    foreach ($argv as $arg) {
        if (ereg('--[a-zA-Z0-9]*=.*',$arg)) {
            $str = split("=",$arg); $arg = '';
            $key = ereg_replace("--",'',$str[0]);
            for ( $i = 1; $i < count($str); $i++ ) {
                $arg .= $str[$i];
            }
                        $_ARG[$key] = $arg;
        } elseif(ereg('-[a-zA-Z0-9]',$arg)) {
            $arg = ereg_replace("-",'',$arg);
            $_ARG[$arg] = 'true';
        }
   
    }
return $_ARG;
}

//$ordernumber = "OM-1-137267925";

$ordernumber = $argv[1];
//$ordernumber = "OM-1-137267925";
//$ordernumber = $_GET['ordernumber'];
//$ordernumber = getenv("ordernumber");
//print $ordernumber;
//URL for BPEL
$url = "http://crmsoa10.nextel.com.mx/BPELConsole";

//RETURN FILE
$fp = fopen("script.sh.tmp", "w");

//CURL LOGIN INFORMATION
$username = "read";
$password = "read1234";
$postData = "j_username=".$username."&j_password=".$password."&logon=submit";

//COOKIE FILE
$cookie_file = "cookie.txt";

// INIT
$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, "$url/j_security_check");
curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_HEADER, 1);
// // // // // // // // // // // curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);

//we don't use ssl, so we comment it
//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
//curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.3) Gecko/20070309 Firefox/2.0.0.3");
curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file);

//curl_setopt($ch, CURLOPT_REFERER, "https://unknown.com/common/Frames.jsp");
//curl_setopt($ch, CURLOPT_REFERER, "http://crmsoa10.nextel.com.mx/BPELConsole/default/index.jsp");
curl_setopt($ch, CURLOPT_REFERER,  "$url/default/instances.jsp?instanceTitle=%25$ordernumber%25&showTestCases=showAll");
curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
curl_setopt($ch, CURLOPT_VERBOSE, false);
curl_setopt($ch, CURLOPT_FILE, $fp);

//execute
$result = curl_exec($ch);
//print $result;
    
//run the process to fetch file #1
//$urlfetch = "$url/default/instances.jsp?fromReports=false&rangeStart=0&rangeSize=-1&defaultView=true";
//curl_setopt($ch, CURLOPT_URL, $urlfetch);
//$result = curl_exec($ch);
//print $result;

//run the process to fetch order number
//curl_setopt($ch, CURLOPT_REFERER, "http://crmsoa10.nextel.com.mx/BPELConsole/default/instances.jsp");
//$urlfetch = "$url/default/instances.jsp?processId=*&revisionTag=*&instanceId=&instanceTitle=%25$ordernumber%25&instancePriority=&indexStr=&creationDate=all&instanceState=all&showTestCases=showAll&Go=++Go++&instanceIds=";
//echo $url;
//$result = curl_exec($ch);
//print $result;

//run the process to fetch order number
//curl_setopt($ch, CURLOPT_REFERER,  "http://crmsoa10.nextel.com.mx/BPELConsole/default/instances.jsp?instanceTitle=%25OM-1-137267925%25&showTestCases=showAll");
//curl_setopt($ch, CURLOPT_REFERER, "http://crmsoa10.nextel.com.mx/BPELConsole/default/instances.jsp");
//$result = curl_exec($ch);
//print $result;

curl_close ($ch);
?> 
