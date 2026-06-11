## 介绍

hydra是一款暴力破解在线密码的程序，一种快速破解系统登录密码的工具。

hydra可以遍历列表并“暴力破解”某些身份验证服务。想象一下，试图手动猜测某人在特定服务上的密码（SSH网上申请表FTP或 SNMP）——我们可以使用九头蛇它会遍历密码列表，加快我们确定正确密码的过程。

根据其[官方存储库（在新标签页中打开）](https://github.com/vanhauser-thc/thc-hydra)，九头蛇支持，即能够暴力破解以下协议：

```
Asterisk, AFP, Cisco AAA, Cisco auth, Cisco enable, CVS, Firebird, FTP, HTTP-FORM-GET, HTTP-FORM-POST, HTTP-GET, HTTP-HEAD, HTTP-POST, HTTP-PROXY, HTTPS-FORM-GET, HTTPS-FORM-POST, HTTPS-GET, HTTPS-HEAD, HTTPS-POST, HTTP-Proxy, ICQ, IMAP, IRC, LDAP, MEMCACHED, MONGODB, MS-SQL, MYSQL, NCP, NNTP, Oracle Listener, Oracle SID, Oracle, PC-Anywhere, PCNFS, POP3, POSTGRES, Radmin, RDP, Rexec, Rlogin, Rsh, RTSP, SAP/R3, SIP, SMB, SMTP, SMTP Enum, SNMP v1+v2+v3, SOCKS5, SSH (v1 and v2), SSHKEY, Subversion, TeamSpeak (TS2), Telnet, VMware-Auth, VNC and XMPP.
```

有关每种协议选项的更多信息，请参阅九头蛇你可以查看[卡利九头蛇工具页面（在新标签页中打开）](https://en.kali.tools/?p=220)。

这凸显了使用强密码的重要性；如果你的密码很常见，不包含特殊字符，且长度不超过八个字符，就很容易被猜到。一个包含一亿个常用密码的列表就能说明这一点，所以当一个开箱即用的应用程序使用简单的密码登录时，一定要更改默认密码！监控摄像头和网页框架通常使用`admin:password`简单的密码作为默认登录凭据，这显然不够安全。

## 示例

* passlist.txt是密码列表

```
hydra -l user -P passlist.txt ftp://10.48.135.77


//四个线程爆破ssh
hydra -l root -P passwords.txt 10.48.135.77 -t 4 ssh
```

