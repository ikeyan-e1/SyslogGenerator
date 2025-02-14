# ハッシュテーブルの初期値設定
$htbl_protocol = @{
    "Syslog over UDP" = "UDP"
    "Syslog over TCP" = "TCP"
    }

$htbl_facility = @{
    "00:カーネル" = 0
    "01:ユーザー" = 1
    "02:メールシステム" = 2
    "03:システムデーモン" = 3
    "04:セキュリティ" = 4
    "05:syslog" = 5
    "06:ラインプリンタ" = 6
    "07:ネットワーク" = 7
    "08:UUCPサブシステム" = 8
    "09:クロックデーモン" = 9
    "10:セキュリティ2" = 10
    "11:FTP" = 11
    "12:NTP" = 12
    "13:監査ログ" = 13
    "14:アラートログ" = 14
    "15:クロックデーモン2" = 15
    "16:local0" = 16
    "17:local1" = 17
    "18:local2" = 18
    "19:local3" = 19
    "20:local4" = 20
    "21:local5" = 21
    "22:local6" = 22
    "23:local7" = 23
}

$htbl_severity = @{
    "0:緊急" = 0
    "1:アラート" = 1
    "2:クリティカル" = 2
    "3:エラー" = 3
    "4:警告" = 4
    "5:通知" = 5
    "6:情報" = 6
    "7:デバッグ" = 7
}

########################################################
# Syslog を送信する
########################################################
function SendSyslogUdp( $SyslogServer,$Port, $SyslogMessage){
    # UDP port
    #$Port = 514
    
    # アセンブリがロードされていなかったらロードする
    $Lib = "System.Net"
    $AssembliesName = [Appdomain]::CurrentDomain.GetAssemblies() | % {$_.GetName().Name}
    if( -not ($AssembliesName -contains $Lib)){
        [void][System.Reflection.Assembly]::LoadWithPartialName($Lib)
    }
    
    # 送信データを作る
    $ByteData = [System.Text.Encoding]::UTF8.GetBytes($SyslogMessage)
    
    # UDP ソケット作る
    $UDPSocket = $null
    $UDPSocket = New-Object System.Net.Sockets.UdpClient($SyslogServer, $Port)
    
    if( $UDPSocket -ne $null ){
        # 送信
        [void]$UDPSocket.Send($ByteData, $ByteData.Length)
        
        # ソケット Close
        $UDPSocket.Close()
    }
}

function SendSyslogTcp( $SyslogServer,$Port, $SyslogMessage){
    # UDP port
    #$Port = 514

    # アセンブリがロードされていなかったらロードする
    $Lib = "System.Net"
    $AssembliesName = [Appdomain]::CurrentDomain.GetAssemblies() | % {$_.GetName().Name}
    if( -not ($AssembliesName -contains $Lib)){
        [void][System.Reflection.Assembly]::LoadWithPartialName($Lib)
    }

    # 送信データを作る
    $ByteData = [System.Text.Encoding]::UTF8.GetBytes($SyslogMessage)

    # TCP ソケット作る
    $TCPSocket = $null
    $TCPSocket = New-Object System.Net.Sockets.TcpClient($SyslogServer, $Port)
    # ストリームを取得
    $stream = $TCPSocket.GetStream()

    if( $TCPSocket -ne $null ){
        # 送信
        #[void]$TCPSocket.Send($ByteData, $ByteData.Length)
        $stream.Write($ByteData, 0, $ByteData.Length)

        # ソケット Close
        $stream.Close()
        $TCPSocket.Close()
    }
}


function frm_main(){
    ## フォーム
    Add-Type -AssemblyName System.Windows.Forms
    $f = New-Object System.Windows.Forms.Form
    $f.Size = "510,400" # (Width,Height)
    $f.Text="Syslog Gen"

    ### フォーム内オブジェクト
    ### ------- 1
    $lbl_protocol = New-Object System.Windows.Forms.Label
    $lbl_protocol.Location = New-Object System.Drawing.Point(6, 20) #x,y
    $lbl_protocol.Size = New-Object System.Drawing.Size(60,20) # W,H
    $lbl_protocol.Text = "Protocol"
    $f.Controls.Add($lbl_protocol)
    $cmb_protocol = New-Object System.Windows.Forms.Combobox
    $cmb_protocol.Location = New-Object System.Drawing.Point(6, 40) #x,y
    $cmb_protocol.Size = New-Object System.Drawing.Size(120,30)
    
    $my_hash = $htbl_protocol.GetEnumerator() | sort -Property key # ハッシュテーブルをKeyの昇順でソート
    foreach ( $protocol in $my_hash.Name ){
        [void] $cmb_protocol.Items.Add($protocol)
    }

    $f.Controls.Add($cmb_protocol)

    ### -------
    $lbl_ip = New-Object System.Windows.Forms.Label
    $lbl_ip.Location = New-Object System.Drawing.Point(150, 20) #x,y
    $lbl_ip.Size = New-Object System.Drawing.Size(100,20) # W,H
    $lbl_ip.Text = "SyslogServer IP"
    $f.Controls.Add($lbl_ip)
    $txt_ip = New-Object System.Windows.Forms.TextBox
    $txt_ip.Location = New-Object System.Drawing.Point(150, 40) #x,y
    $txt_ip.Size = New-Object System.Drawing.Size(120,30)
    $f.Controls.Add($txt_ip)

    ### -------

    $lbl_port = New-Object System.Windows.Forms.Label
    $lbl_port.Location = New-Object System.Drawing.Point(280, 20) #x,y
    $lbl_port.Size = New-Object System.Drawing.Size(100,20) # W,H
    $lbl_port.Text = "Port"
    $f.Controls.Add($lbl_port)
    $txt_port = New-Object System.Windows.Forms.TextBox
    $txt_port.Location = New-Object System.Drawing.Point(280, 40) #x,y
    $txt_port.Size = New-Object System.Drawing.Size(50,30)
    $txt_port.Text = 514
    $f.Controls.Add($txt_port)

    ### -------2

    $lbl_facility = New-Object System.Windows.Forms.Label
    $lbl_facility.Location = New-Object System.Drawing.Point(6, 65) #x,y
    $lbl_facility.Size = New-Object System.Drawing.Size(60,20) # W,H
    $lbl_facility.Text = "facility"
    $f.Controls.Add($lbl_facility)
    $cmb_facility = New-Object System.Windows.Forms.Combobox
    $cmb_facility.Location = New-Object System.Drawing.Point(6, 85) #x,y
    $cmb_facility.Size = New-Object System.Drawing.Size(120,30)
    
    $my_hash = $htbl_facility.GetEnumerator() | sort -Property key # ハッシュテーブルをKeyの昇順でソート
    foreach ( $facility in $my_hash.Name ){
        [void] $cmb_facility.Items.Add($facility) 
    }

    $f.Controls.Add($cmb_facility)
    ### -------

    $lbl_severity = New-Object System.Windows.Forms.Label
    $lbl_severity.Location = New-Object System.Drawing.Point(150, 65) #x,y
    $lbl_severity.Size = New-Object System.Drawing.Size(60,20) # W,H
    $lbl_severity.Text = "severity"
    $f.Controls.Add($lbl_severity)
    $cmb_severity = New-Object System.Windows.Forms.Combobox
    $cmb_severity.Location = New-Object System.Drawing.Point(150, 85) #x,y
    $cmb_severity.Size = New-Object System.Drawing.Size(80,30)
    #[void] $cmb_severity.Items.Add("1") # for each + ハッシュテーブルのkeyで、追加

    $my_hash = $htbl_severity.GetEnumerator() | sort -Property key # ハッシュテーブルをKeyの昇順でソート
    foreach ( $severity in $my_hash.Name ){
        [void] $cmb_severity.Items.Add($severity)
    }


    $f.Controls.Add($cmb_severity)
    ### -------

    $lbl_date = New-Object System.Windows.Forms.Label
    $lbl_date.Location = New-Object System.Drawing.Point(280, 65) #x,y
    $lbl_date.Size = New-Object System.Drawing.Size(100,20) # W,H
    $lbl_date.Text = "Date"
    $f.Controls.Add($lbl_date)
    $obj_date = New-Object System.Windows.Forms.DatetimePicker
    $obj_date.Format = [Windows.Forms.DateTimePickerFormat]::Custom
    $obj_date.CustomFormat = "yyyy-MM-dd"
    $obj_date.Location = New-Object System.Drawing.Point(280, 85) #x,y
    $obj_date.Size = New-Object System.Drawing.Size(100,30)
    $f.Controls.Add($obj_date)


    ### -------

    $lbl_time = New-Object System.Windows.Forms.Label
    $lbl_time.Location = New-Object System.Drawing.Point(380, 65) #x,y
    $lbl_time.Size = New-Object System.Drawing.Size(100,20) # W,H
    $lbl_time.Text = "Time"
    $f.Controls.Add($lbl_time)
    $obj_time = New-Object System.Windows.Forms.DateTimePicker
    $obj_time.Format = [Windows.Forms.DateTimePickerFormat]::Custom
    $obj_time.CustomFormat = "HH:mm:ss.000"
    $obj_time.ShowUpDown = $TRUE
    $obj_time.Location = New-Object System.Drawing.Point(380, 85) #x,y
    $obj_time.Size = New-Object System.Drawing.Size(100,30)
    $f.Controls.Add($obj_time)

    ### ------- 3

    $lbl_source = New-Object System.Windows.Forms.Label
    $lbl_source.Location = New-Object System.Drawing.Point(6, 115) #x,y
    $lbl_source.Size = New-Object System.Drawing.Size(60,20) # W,H
    $lbl_source.Text = "source"
    $f.Controls.Add($lbl_source)
    $txt_source = New-Object System.Windows.Forms.TextBox
    $txt_source.Location = New-Object System.Drawing.Point(6, 135) #x,y
    $txt_source.Size = New-Object System.Drawing.Size(120,30)
    $f.Controls.Add($txt_source)

    ### -------
    $lbl_appname = New-Object System.Windows.Forms.Label
    $lbl_appname.Location = New-Object System.Drawing.Point(150, 115) #x,y
    $lbl_appname.Size = New-Object System.Drawing.Size(100,20) # W,H
    $lbl_appname.Text = "App Name"
    $f.Controls.Add($lbl_appname)
    $txt_appname = New-Object System.Windows.Forms.TextBox
    $txt_appname.Location = New-Object System.Drawing.Point(150, 135) #x,y
    $txt_appname.Size = New-Object System.Drawing.Size(120,30)
    $txt_appname.Text = "SyslogGenerator"
    $f.Controls.Add($txt_appname)

    ### -------
    $lbl_pid = New-Object System.Windows.Forms.Label
    $lbl_pid.Location = New-Object System.Drawing.Point(300, 115) #x,y
    $lbl_pid.Size = New-Object System.Drawing.Size(100,20) # W,H
    $lbl_pid.Text = "Process id"
    $f.Controls.Add($lbl_pid)
    $txt_pid = New-Object System.Windows.Forms.TextBox
    $txt_pid.Location = New-Object System.Drawing.Point(300, 135) #x,y
    $txt_pid.Size = New-Object System.Drawing.Size(120,30)
    $txt_pid.Text = "9999"
    $f.Controls.Add($txt_pid)

    ### ------- 4
    $lbl_send_msg = New-Object System.Windows.Forms.Label
    $lbl_send_msg.Location = New-Object System.Drawing.Point(6, 155) #x,y
    $lbl_send_msg.Size = New-Object System.Drawing.Size(100,20) # W,H
    $lbl_send_msg.Text = "message"
    $f.Controls.Add($lbl_send_msg)
    $txt_send_msg = New-Object System.Windows.Forms.TextBox
    $txt_send_msg.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
    $txt_send_msg.Multiline = $TRUE
    $txt_send_msg.Location = New-Object System.Drawing.Point(6, 175) #x,y
    $txt_send_msg.Size = New-Object System.Drawing.Size(420,100)
    $txt_send_msg.Text = " This is Test Message from SyslogGenerator."
    $f.Controls.Add($txt_send_msg)

    ### ------- 5
    $btn_send = New-Object System.Windows.Forms.Button
    $btn_send.Location = New-Object System.Drawing.Point(260, 290)
    $btn_send.Size = New-Object System.Drawing.Size(80,30)
    $btn_send.Text = "送信"
    $f.Controls.Add($btn_send)
    ### -------
    $btn_close = New-Object System.Windows.Forms.Button
    $btn_close.Location = New-Object System.Drawing.Point(340, 290)
    $btn_close.Size = New-Object System.Drawing.Size(80,30)
    $btn_close.Text = "閉じる"
    #$f.Controls.Add($btn_close)
    ### -------

    $txt_debug_msg = New-Object System.Windows.Forms.TextBox
    $txt_debug_msg.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
    $txt_debug_msg.Multiline = $TRUE
    $txt_debug_msg.Location = New-Object System.Drawing.Point(6, 350) #x,y
    $txt_debug_msg.Size = New-Object System.Drawing.Size(420,100)
    #$f.Controls.Add($txt_debug_msg)
    ### -------


    ## イベントの追加
    #### 送信ボタン押下時
    $btn_send.Add_Click({
        $ip = $txt_ip.Text
        $port = $txt_port.Text
        $txt_debug_msg.Text = $htbl_protocol[$cmb_protocol.Text]
		
        # Priority は Facility * 8 + Severity で計算される
        $Priority = $htbl_facility[$cmb_facility.Text] * 8 + $htbl_severity[$cmb_severity.Text]
        
        # $txt_full_msg is  exp. <13>1 2024-05-07T10:10:10.000+09:00 test_nas appname 9999 this is syslog test message.
        $txt_full_msg = "<$($Priority)>1 $($obj_date.Text)T$($obj_time.Text)+09:00 $($txt_source.Text) $($txt_appname.Text) $($txt_pid.Text) $($txt_send_msg.Text)"

        $txt_debug_msg.Text = $($txt_debug_msg.Text) + "||||"+ $($txt_full_msg)

        if ($htbl_protocol[$($cmb_protocol.Text)] -eq "TCP"){ 
            #Write-Host "TCP" 
            SendSyslogTcp $($ip) $($port) $($txt_full_msg)
        }else{ 
            #Write-host "UDP"
            SendSyslogUdp $($ip) $($port) $($txt_full_msg)
        }

        SendSyslogTcp $($ip) $($port) $($txt_full_msg)
        $txt_debug_msg.Text = $($txt_debug_msg.Text) + "|||| END"

    })



    ## フォームの描画
    $f.ShowDialog()	

}

frm_main

