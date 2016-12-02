
This tool will let you to make multiple experiments to understand, how memory management under Linux is working.
It contains experiments:
1) How to generate major pagefaults.  
2) How much active/inactive memory is used for Page Cache. It supports **ONLY LINUX**, because it uses `/proc` filesystem.  
I was inspired for the experiment by Roman Gushchin's presentation https://habrahabr.ru/company/yandex/blog/231957/ 
For demonstration, I recommend you to have VM with no load/other services running.  

# Basic
1) Clone and compile `vmtouch` from here: https://github.com/hoytech/vmtouch

# Major Pagefault generator
## Preparations:
1) Compile pgmajfault.go:  
```
# Install go https://golang.org/doc/install
terminal1$ go get golang.org/x/exp/mmap
terminal1$ go build pgmajfault.go
```
2) Generate small file in any place:  
```
terminal1$ echo Something > /tmp/test
```
3) Evict file pages from Page cache:  
```
terminal1$ vmtouch -e /tmp/test.txt
```
4) Run in separate terminal
```
terminal2$ mem.sh 
```
## Demonstration:
1) Run pgmajfault with file as parameter
```
terminal1$ pgmajfault tmp/test.txt
```
2) Look at output on `mem.sh`. You should see "PAGEFAULT!" message  
3) Repeat evicting of file from page cache and run pgmajfault again if you missed the output

# Active/inactive memory
## Preparations:
1) Generate files (1GB, 4GB). The rule is simple: first file should be less, than total amount of memory, second - more.
```
terminal1$ dd if=/dev/zero of=./large count=10240 bs=102400
terminal1$ dd if=/dev/zero of=./huge count=40960 bs=102400
```
2) Flush all caches:
```
terminal1$ echo 3 > /proc/sys/vm/drop_caches
```
3) Run script demonstating mapping these file in Page Cache (in separate terminal):
```
terminal2$ watch "echo HUGE; vmtouch ./huge ; echo LARGE ; vmtouch ./large"
```
4) Run in separate terminal
```
terminal3$ mem.sh 
```
## Demonstration:
After you flushed all caches, you shold see active and INACTIVE = 0  
1) Read large file. You will to see INACTIVE growing. Also `vmtouch`  
```
terminal1$ cat ./large > /dev/null
```
2) Read huge file. You will see on terminal with `vmstat`, that file large was moved away from inactive memory
```
terminal1$ cat ./huge > /dev/null
```
3) Read large file again. You will see on terminal with `vmstat`, how part of huge file is moving away from inactive memory
4) Read large file again and you will see, that it moved to an Active memory
5) Read huge file again. You will see, that large file was moved away partially, or was not moved at all
6) Remove both files and see, how memory got freed from both queues
