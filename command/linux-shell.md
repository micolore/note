# shell 

### 列出最常使用的命令
history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head

### 列出所有网络状态：ESTABLISHED / TIME_WAIT / FIN_WAIT1 / FIN_WAIT2 
netstat -n | awk '/^tcp/ {++tt[$NF]} END {for (a in tt) print a, tt[a]}'

### 通过 SSH 来 mount 文件系统
sshfs name@server:/path/to/folder /path/to/mount/point

### 显示前十个运行的进程并按内存使用量排序
ps aux | sort -nk +4 | tail

### 在右上角显示时钟
while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done&

### 从网络上的压缩文件中解出一个文件来，并避免保存中间文件
wget -qO - "http://www.tarball.com/tarball.gz" | tar zxvf -

### 性能测试：测试处理器性能
python -c "import test.pystone;print(test.pystone.pystones())"

### 性能测试：测试内存带宽
dd if=/dev/zero of=/dev/null bs=1M count=32768

### Linux 下挂载一个 iso 文件
mount /path/to/file.iso /mnt/cdrom -oloop

### 通过主机 A 直接 ssh 到主机 B
ssh -t hostA ssh hostB

### 下载一个网站的所有图片
wget -r -l1 --no-parent -nH -nd -P/tmp -A".gif,.jpg" http://example.com/images

### 快速创建项目目录
mkdir -p work/{project1,project2}/{src,bin,bak}

### 按日期范围查找文件
find . -type f -newermt "2010-01-01" ! -newermt "2010-06-01"

### 显示当前正在使用网络的进程
lsof -P -i -n | cut -f 1 -d " "| uniq | tail -n +2

### Vim 中保存一个没有权限的文件
:w !sudo tee > /dev/null %

### 在 .bashrc / .bash_profile 中加载另外一个文件（比如你保存在 github 上的配置）
source ~/github/profiles/my_bash_init.sh

### 终端下正确设置 ALT 键和 BackSpace 键
http://www.skywind.me/blog/archives/2021

