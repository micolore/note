# 0-100  GIT
what? why? how?

# 概念
## 存储代码的地方(repository)
### 工作区
 本地的目录，也叫工作树
### 暂存区
 stage、index，也叫索引。
### 本地仓库
### 远程仓库(公共仓库)

* 创建数据库的方式，1 全新的 2 复制远程数据库

## 行为
### pull
### branch
* git branch -D br
* git branch [-r] [-a] #列出分支，-r远端 ,-a全部
* git branch <分支名> #新建分支
* git branch -b <分支名> #新建并切换分支
* git branch -d <分支名> #删除分支

### push 
1. git push origin :0507-b 删除远程分支
### commit
### add 
### diff
比较版本之间的不同之处
* git diff                                                  # 显示所有未添加至index的变更
* git diff --cached                                         # 显示所有已添加index但还未commit的变更
* git diff HEAD^                                            # 比较与上一个版本的差异
* git diff HEAD -- ./lib                                    # 比较与HEAD版本lib目录的差异
* git diff origin/master..master                            # 比较远程分支master上有本地分支master上没有的
* git diff origin/master..master --stat                     # 只显示差异的文件，不显示具体内容
### fetch 
* git fetch
* git fetch remote_repo
* git fetch remote_repo remote_branch_name
* git fetch remote_repo remote_branch_name:local_branch_name

### remote
* git remote add <别名> <git地址> #设置远端别名
* git remote [-v] #列出远端，-v为详细信息
* git remote show <远端别名> #查看远端信息
* git remote rename <远端别名> <新远端别名> #重命名远端
* git remote rm <远端别名> #删除远端
* git remote update [<远端别名>] #更新分支列表

### rebase 衍合
可以对某一段线性提交历史进行编辑、删除、复制、粘贴,目标commit历史简洁、干净
example:  
1. 合并多个commit为一个完整commit
2. 将某一段commit粘贴到另一个分支上
3. http://www.ruanyifeng.com/blog/2015/08/git-use-process.html
### merge
1. git merge <分支名> #合并某分支到当前分支

### fetch_head
是一个版本链接，记录在本地的一个文件中，指向着目前已经从远程仓库取下来的分支的末端版本。

* $ git log --graph --pretty=oneline --abbrev-commit 合并情况
### checkout 
  切换（分支）
* git checkout -b mybranch 创建并切换
* git checkout <分支名> #切换到分支
* git checkout -b <本地branch> [-t <远端别名>/<远端分支>] #-b新建本地分支并切换到分支, -t绑定远端分支
### reset
* git reset --hard commit-id :回滚到commit-id，讲commit-id之后提交的commit都去除
* git reset --hard HEAD~3：将最近3次的提交回滚
## 其他
### revision 
执行提交后，数据库中会生成上次提交的状态与当前状态的差异记录
### 工作树
在Git管理下，大家实际操作的目录被称为工作树。
### 索引
在数据库和工作树之间有索引，索引是为了向数据库提交作准备的区域。
* Git在执行提交的时候，不是直接将工作树的状态保存到数据库，而是将设置在中间索引区域的状态保存到数据库。因此，要提交文件，首先需要把文件加入到索引区域中。
### commit-id

### head 游标



## tips 
1. 不同类别的修改 (如：Bug修复和功能添加) 要尽量分开提交，以方便以后从历史记录里查找特定的修改内容。
2. 查看其他人提交的修改内容或自己的历史记录的时候，提交信息是需要用到的重要资料。所以请用心填写修改内容的提交信息，以方便别人理解。  
   第1行：提交修改内容的摘要  
   第2行：空行  
   第3行以后：修改的理由  
## 资料参考
[https://segmentfault.com/a/1190000004992316](git 教程)


3. 不要通过rebase对任何已经提交到公共仓库中的commit进行修改（你自己一个人玩的分支除外）
