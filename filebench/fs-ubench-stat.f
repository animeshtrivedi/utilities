set $dir=/mnt/nvmf-tcp/filebench
set $nfiles=100000
set $meandirwidth=20
set $filesize=8
set $nthreads=1
set $prealloc=0

define fileset name="stat",entries=$nfiles,filesize=$filesize,prealloc=$prealloc,path=$dir

define process name="readerP",instances=1 {
  thread name="readerT",instances=1 {
    flowop statfile name=statfile,filesetname=stat,directio=1
  }
}

run 30