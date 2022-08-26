# git ssh key的作用

ssh key是属于ssh的,与git无关,一般使用RSA算法

git的ssh一般使用的是RSA非对称加密算法
密钥和公钥的概念是针对于该算法的

使用私钥加密的内容，只能通过公钥来解密
使用公钥加密的内容，只能通过私钥来解密

生成密钥时,在windows下都存放在C:\Users\xxx\.ssh
xxx.pub这个是公钥,则xxx这个是私钥
### 公钥:
可以对外给任何人的加密和解密密码，公开的，可以任何人访问.  

一般是给服务器的,他们到时候在权限中加入我给的公钥,然后当我从远地仓库中下载项目的时候,我在git clone xxx的时候，那个服务器我通过他的绑定的公钥来匹配我的私钥，这个时候,如果匹配,则就可以正常下载,如果不匹配,则需要输入服务器中对应登录用户的密码才可下载.
### 私钥:
私钥是一定要严格保护的，通过私钥可以生成公钥，但是从公钥可以认为是永远无法推导出私钥的。  
是服务器用来解密的,服务器存放客户端的公钥,之后客户端用自己的私钥加密传输的信息,然后当连接时,若服务器存放了对应的公钥,将会用对应客户端的公钥进行解密.

# origin
origin默认是指github的服务器你对应的仓库地址(上面有你存放的项目文件)


# git指令
## 在当前目录下创建新仓库
```bash
git init	(加上--bare可建立一个空仓库(自己去体会))
```
最好带上--bare来初始化,不然可能会出现自己建立的服务器无法被push的情况(这是由于git默认拒绝了push操作)
需要进行设置，修改.git/config文件后面添加如下代码：  

```bash
[receive]  
    denyCurrentBranch = ignore）
```

[加和不加--bare的区别](http://blog.haohtml.com/archives/12265)

## 添加关联库
```bash
git remote add origin <远程库地址或服务器地址>
```
## 删除某个连接
```bash
git remote remove <名字>
```
## 取消origin关联库
```bash
git remote remove origin
```
## 取消origin关联库(同上)
```bash
git remote rm origin
```

## 从别的仓库克隆
```bash
git clone <远程库地址或服务器地址>
```
## 本地克隆
```bash
git clone <本地仓库路径>
```

## 添加改动的文件到缓存区
```bash
git add <filename>
git add *
```

## 在本地库中添加提交的改动信息
```bash
git commit -m "本次提交信息"	//改命令只是将修改操作提交至本地库
```

## 实际上传
当前目录连接到远程某个库(不会发起上传):  

```bash
git remote add origin <远程库地址或服务器地址>
```

&emsp;origin为一个名字,指当此连接的名字	  
&emsp;<远程库地址或服务器地址>=  
服务器中执行该操作的用户@IP:/系统中该仓库目录

## 开始上传:
```bash
git push origin 分支名	 可以用来远程创建新分支
```
&emsp;origin为一个名字,指当此连接的名字,该操作将本地修改操作提交至远程库  
&emsp;注意上传后,不会对应更新本地文件,服务器需要用pull来选择要更新分支来更新本地文件(github中一般一开始你默认了你自己的这种操作)


```bash
git push    不写参数的默认情况下会把当前分支推送到默认远端
```

## 分支相关
### 由当前分支为原本建立一个本地分支
```bash
git branch 分支名   
```

### 新建一个分支并切换至
```bash
git checkout -b 分支名
```
### 切换到某个分支
```bash
git checkout 分支名
```
### 删除某个分支 
```bash
git branch -d 分支名   删除某个本地分支
git branch -D 分支名   删除某个本地分支
git push origin --delete 远程分支名   删除远程git仓库origin上的某个分支
```

### 查看当前本地仓库的所有分支以及远程仓库所有分支
```bash
git branch -a		(不加-a只会仅列出本地仓库所有分支)
git branch -r       查看远程所有分支
```

### 查看当前库是克隆的远程库哪个分支
用branch查询的分支时出现的origin/HEAD所指分支为外部克隆时对应的分支  

例：origin/HEAD -> origin/master表示该库克隆时以远程库的master分支为主  

若要修改这个，可以修改要克隆的库中.git文件夹中的HEAD文件


## 缓存区相关文件操作
```bash
git ls-files 				查看暂存区中文件信息

git ls-files -c				查看暂存区中文件信息(上面命令默认操作)
	
git ls-files -m				查看修改的文件
	
git ls-files -d				查看删除过的文件
	
git ls-files -o				查看没有被git跟踪的文件(没有被git add到缓存区的文件)
	
git rm --cached "文件路径"		不删除物理文件，仅将该文件从准备提交上去的缓存中删除
	
git rm --f "文件路径"			不仅将该文件从缓存中删除，还会将物理文件删除（不会回收到垃圾桶）
```

&emsp;额外注意,本地每个分支都共享缓存区,但是每个分支都有一个缓存文件条目表,记录了当前分支用git add命令添加的文件  

&emsp;切换分支时需要注意缓存区要有缓存文件条目中对应的每个文件,不然将会报错并且无法切换分支,并且要求你在缓存区添加或删除对应文件.
		
		
## 分支合并操作
### 将当前库的某个分支的后续commit操作合并至当前分支并且使当前库commit
```bash
git merge 合并的库										
```
### 将某个分支的commit操作合并至当前库,但本次不会commit
```bash
git merge --no--commit 合并的库									
```
### 取回远程主机的特定分支的更新
```bash
git fetch <远程库地址或服务器地址> <分支名>  
```
&emsp;<远程库地址或服务器地址>=服务器中执行该操作的用户@IP:/系统中该仓库目录  
    
```bash
git	fetch <远程库地址或服务器地址>         //将某个远程主机的更新全部取回本地								
	
git pull <远程库地址或服务器地址> <远程分支名>:<本地分支名>		
                        	//从远程主机的某分支拉取更新内容
                        	//1.并且将拉取下来的最新内容合并到当前所在的分支中
                        	//2.若要合并至当前操作的分支,则可省略:后以及后面内容
                        	//3.该操作也会更新本地文件至pull所指的远程改动
```
&emsp;git pull	等同于  git fetch 和 git merge 相结合。
&emsp;git pull 只会取回别人对应分支相较于你的分支的更新，而不会拷贝别人的全部内容。同样的，git pull后会自动commit一次。

```bash
git pull <远程库地址或服务器地址> <远程分支名>
                            //取回远程某分支与当前分支合并

注意git pull <远程库地址或服务器地址> <远程分支名>:<本地分支名>	无法用来合并至当前分支
```


​															
## 查看当前文件夹关联远程仓库地址
```bash
git remote -v
```

## 查看当前文件夹对应软件仓库的提交历史  
也可以查询到别人提交到该仓库的历史和该仓库提交到别人仓库的提交历史,还有克隆仓库也记录了  

```bash
git log             选项 	--stat查看文件历史修改情况

git reflog
                    可以查看所有分支的所有操作记录
                    (包括已经被删除的 commit 记录和 reset 的操作)
                    其第一行显示的版本号
```

## 存储当前分支的未提交的(commit)操作
```bash
git stash save "save message"       //save message为备注,执行存储时，添加备注，方便查找
                                    //只有git stash 也要可以的，但查找时不方便识别。

git stash list		                //查看stash了哪些存储

git stash show 					    //显示做了哪些改动，默认show第一个存储
                                    //如果要显示其他存贮，后面加stash@{$num}(注意记录从0开始记起) 

git stash show -p 		    	    //显示第一个存储的改动，
//如果想显示其他存存储,
git stash show  stash@{$num}  -p 	//注意记录从0开始记起 

git stash apply	                    //应用某个存储,但不会把存储从存储列表中删除，
                                    //默认使用第一个存储,即stash@{0}。
//如果要使用其他个
git stash apply stash@{$num}        //注意记录从0开始记起 

git stash pop 						//命令恢复之前缓存的工作目录，将缓存堆栈中的对应stash删除，并将对应修改应用到当前的工作目录下,默认为第一个stash,即stash@{0}.
//如果要应用并删除其他stash
git stash pop stash@{$num}          //比如应用并删除第二个：git stash pop stash@{1}

git stash drop stash@{$num}	    	//丢弃stash@{$num}存储，从列表中删除这个存储

	git stash clear												删除所有缓存的stash
```

## 合并提交分支
```bash
git rebase -i HEAD~x				//合并从最开始到地x的提交操作,执行后会进入vim模式来指导操作
```


​		
## 版本回退(回退的是本地文件的修改,故和分支没关系)
```bash
git reset -–hard 版本号										//回退到版本号	git reflog可以查看版本号
	
git reset -–hard HEAD~x										//回退到操作前的x个版本
	
git reset -–hard HEAD^										//回退到上个版本
	
git reset -–hard HEAD^^										//回退到上上个版本
```

另外学习
		git rebase命令

## .gitignore
该文件可以自动屏蔽不想被add添加的文件,该文件在.git目录的同目录下才会生效



##  比较差异

```bash
git diff [提交id_1/分支1] [提交id_2/分支2]
```





## tag相关

> 切换到某个tag

```bash
git checkout <tag_name>
```

> 列出所有的tag

```bash
git tag
```

> 将某次提交打成一个tag

```bash
git tag <tag_name> <commit id value>
```


> 删除某个标签

```bash
git tag -d <tag_name>
```

> 推送某一个tag到某个远程仓库

```bash
git push <remote> <tag_name>
```

> 推送所有标签到远程仓库

```bash
git push <remote> --tags
```

> 删除远程仓库中的某个标签

```bash
git push <remote> --delete <tag_name>
```

