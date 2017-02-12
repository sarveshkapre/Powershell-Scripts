$folderDateTime = (get-date).ToString('d-M-y HHmmss')
$userDir = (Get-ChildItem env:\userprofile).value + '\Port Scan Report ' + $folderDateTime
$fileSaveDir = New-Item  ($userDir) -ItemType Directory 
$date = get-date 
$Report = 'Scan Report' > $fileSaveDir'/ScanInfo.txt' 
$Report = $Report + "Port Scan Report Generated on:" + $Date + " `n "

$port = 0, 21, 22, 23, 25, 80, 110, 113, 119, 135, 137, 139, 143, 389, 443, 445, 1002, 1024, 1030, 1720, 1900, 5000, 8080
$net = "192.168.1"
$range = 1..30
foreach ($r in $range)
{
 $ip = "{0}.{1}" -F $net,$r
 if(Test-Connection -BufferSize 32 -Count 1 -Quiet -ComputerName $ip)
   {
     $Report = $Report  + "Port Scan of " + $ip + " `n "
     foreach ($portnumber in $port)
	  {
	    $socket = new-object System.Net.Sockets.TcpClient($ip, $portnumber)
        If($socket.Connected)
         {
		   $Report = $Report  +  "Port " + $portnumber + " is open `n"
           $socket.Close() 
		 }
		else 
		 {
		   $Report = $Report  +  "Port " + $portnumber + " is closed `n"
		 } 
      }
   }
}
$Report >> $fileSaveDir'/ScanInfo.txt'