# SyslogGenerator

SysLogサーバーを立てた際に、動作確認用のテストメッセージを送信したく作成したものです。  

以前は、どこかの会社がフリーソフトとして似たようなものを提供してくれていたのですが、DL出来なくなっていたので、作成してみました。  

対象ユーザー：初心者？  
コマンドラインでこのような事が出来るものはすでに存在します。  
これは、「コマンドラインの説明は少し難しいな」と思った私のような人のためのツールとして作成しております。

## 使い方

下記のファイルに簡単に画面の説明(drawioファイル)を作成しております。  
適当に項目を埋めて、送信ボタンを押すだけなので、細かい説明は割愛します。  

[使い方.drawio](./doc/使い方.drawio)



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


### drawioファイルってどうやって開くの？

ここでアプリをDLして  
[draw.io](https://www.drawio.com/)