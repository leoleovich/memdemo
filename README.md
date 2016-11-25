This tool will let you to test how much active/inactive memory is used for Page Cache. It supports **ONLY LINUX**, because it uses `/proc` filesystem.
I was inspired by for experiment by Roman Gushchin and his presentation https://habrahabr.ru/company/yandex/blog/231957/https://habrahabr.ru/company/yandex/blog/231957/
For demonstration, I recommend you to have VM with no load 
To make a proper demonstration I recommend you to do following steps:  
# Preparations:
1) Clone and compile `vmtouch` from here: https://github.com/hoytech/vmtouch
2) Generate files (1GB, 4GB). The rule is simple: first file should be less, than total amount of memory, second - more.
```
dd if=/dev/zero of=./large count=10240 bs=102400
dd if=/dev/zero of=./huge count=40960 bs=102400
```
3) Flush all caches:
```
echo 3 > /proc/sys/vm/drop_caches
```
4) Run script demonstating mapping these file in Page Cache (in separate terminal):
```
terminal1$ watch "echo HUGE; vmtouch ./huge ; echo LARGE ; vmtouch ./large"
```
5) Run in separate terminal
```
terminal2$ mem.sh 
```
# Demonstration:
After you flushed all caches, you shold see active and INACTIVE = 0
1) Read large file. You will to see INACTIVE growing. Also `vmtouch`  
```
cat ./large > /dev/null
```
2) Read huge file. You will see on terminal with `vmstat`, that file large was moved away from inactive memory
```
cat ./huge > /dev/null
```
3) Read large file again. You will see on terminal with `vmstat`, how part of huge file is moving away from inactive memory
4) Read large file again and you will see, that it moved to an Active memory
5) Read huge file again. You will see, that large file was moved away partially, or was not moved at all
6) Remove both files and see, how memory got freed from both queues
