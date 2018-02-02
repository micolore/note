# git
![git river](https://github.com/micolore/blogs/blob/master/common/img/git-river.png)
* Workspace：工作区  
程序员进行开发改动的地方，是你当前看到的，也是最新的,平常我们开发就是拷贝远程仓库中的一个分支，基于该分支进行开发。在开发过程中就是对工作区的操作。

* Index / Stage：暂存区  
.git目录下的index文件, 暂存区会记录git add添加文件的相关信息(文件名、大小、timestamp...)，不保存文件实体, 通过id指向每个文件实体。可以使用git status查看暂存区的状态。暂存区标记了你当前工作区中，哪些内容是被git管理的。
当你完成某个需求或功能后需要提交到远程仓库，那么第一步就是通过git add先提交到暂存区，被git管理。

* Repository：仓库区（或本地仓库）  
保存了对象被提交 过的各个版本，比起工作区和暂存区的内容，它要更旧一些,git commit后同步index的目录树到本地仓库，方便从下一步通过git push同步本地仓库与远程仓库的同步

* Remote：远程仓库  
远程仓库的内容可能被分布在多个地点的处于协作关系的本地仓库修改，因此它可能与本地仓库同步，也可能不同步，但是它的内容是最旧的。

![git river](https://github.com/micolore/blogs/blob/master/common/img/workspace.png)

## HEAD
它始终指向当前所处分支的最新的提交点。你所处的分支变化了，或者产生了新的提交点，HEAD就会跟着改变

### COMMAND
1. add 
主要实现将工作区修改的内容提交到暂存区，交由git管理   
* git add .添加当前目录的所有文件到暂存区  
* git add 添加指定目录到暂存区，包括子目录  
* git add 添加指定文件到暂存区  

2. commit 
主要实现将暂存区的内容提交到本地仓库，并使得当前分支的HEAD向后移动一个提交点     
* git commit -m 提交暂存区到本地仓库,message代表说明信息
* git commit -m 提交暂存区的指定文件到本地仓库
* git commit --amend -m 使用一次新的commit，替代上一次提交

3. branch
涉及到协作，自然会涉及到分支，关于分支，大概有展示分支，切换分支，创建分支，删除分支这四种操作
* git branch列出所有本地分支
* git branch -r列出所有远程分支
* git branch -a列出所有本地分支和远程分支
* git branch 新建一个分支，但依然停留在当前分支
* git checkout -b 新建一个分支，并切换到该分支
* git branch --track 新建一个分支，与指定的远程分支建立追踪关系
* git checkout 切换到指定分支，并更新工作区
* git branch -d 删除分支
* git push origin --delete 删除远程分支

4. merge 
我们可能从master分支中切出一个分支，然后进行开发完成需求，中间经过R3,R4,R5的commit记录，最后开发完成需要合入master中，这便用到了merge
* git fetch merge之前先拉一下远程仓库最新代码
* git merge 合并指定分支到当前分支   
一般在merge之后，会出现conflict，需要针对冲突情况，手动解除冲突。主要是因为两个用户修改了同一文件的同一块区域

5. rebase
rebase又称为衍合，是合并的另外一种选择   
在开始阶段，我们处于new分支上，执行git rebase dev，那么new分支上新的commit都在master分支上重演一遍，最后checkout切换回到new分支。这一点与merge是一样的，合并前后所处的分支并没有改变。git rebase dev，通俗的解释就是new分支想站在dev的肩膀上继续下去。rebase也需要手动解决冲突。
> rebase与merge的区别  
>merge操作会生成一个新的节点，之前的提交分开显示。而rebase操作不会生成新的节点，是将两个分支融合成一个线性的提交。

>如果你想要一个干净的，没有merge commit的线性历史树，那么你应该选择git rebase

>如果你想保留完整的历史记录，并且想要避免重写commit history的风险，你应该选择使用git merge  

6. reset  
reset命令把当前分支指向另一个位置，并且相应的变动工作区和暂存区  
* git reset —soft 只改变提交点，暂存区和工作目录的内容都不改变
* git reset —mixed 改变提交点，同时改变暂存区的内容
* git reset —hard 暂存区、工作区的内容都会被修改到与提交点完全一致的状态
* git reset --hard HEAD让工作区回到上次提交时的状态

7. revert  
git revert用一个新提交来消除一个历史提交所做的任何修改。 
git revert是用一次新的commit来回滚之前的commit，git reset是直接删除指定的commit。 

8. push  
上传本地仓库分支到远程仓库分支，实现同步  
* git push 上传本地指定分支到远程仓库
* git push --force强行推送当前分支到远程仓库，即使有冲突
* git push --all推送所有分支到远程仓库
 
9. other  
* git status显示有变更的文件
* git log显示当前分支的版本历史
* git diff显示暂存区和工作区的差异
* git diff HEAD显示工作区与当前分支最新commit之间的差异
* git cherry-pick 选择一个commit，合并进当前分支

[Git高级教程](https://www.jianshu.com/p/15b8e6b7e3d7)  
[Git 分支 - 分支的新建与合并](https://git-scm.com/book/zh/v1/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E7%9A%84%E6%96%B0%E5%BB%BA%E4%B8%8E%E5%90%88%E5%B9%B6)  





