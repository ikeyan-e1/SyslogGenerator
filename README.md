# SyslogGenerator

SysLogサーバーを立てた際に、動作確認用のテストメッセージを送信したく作成したものです。  

以前は、どこかの会社がフリーソフトとして似たようなものを提供してくれていたのですが、DL出来なくなっていたので、作成してみました。  


## 困ったとき

### 実行時に、「このシステムではスクリプトの実行が無効に。。。。」のようなメッセージが表示され上手く動かない場合  
```txt
このシステムではスクリプトの実行が無効になっているため、ファイル SyslogGen.ps1 を読み込むことができません。
詳細については、「about_Execution_Policies」(https://go.microsoft.com/fwlink/?LinkID=135170) を参照してください。
```

PowerShellのスクリプト実行のポリシーを確認してください。  
```powershell
PS C:\>Get-ExecutionPolicy
Restricted
```
となっている場合、セキュリティの関係で動かすことができません。  

管理者権限でPowerShellを起動しなおしたうえで下記のコマンドを実行すると動くようになる予定です。  
```
Set-ExecutionPolicy RemoteSigned
```

### 実行ファイル化して使用したい場合

PS2EXEを使用して、実行ファイル化してください。  
[ps2exe](https://www.powershellgallery.com/packages/ps2exe/1.0.15)


