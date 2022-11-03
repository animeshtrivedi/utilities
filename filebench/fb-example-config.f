define fileset name="testF",entries=100,filesize=512,prealloc,path="/mnt/nvmf-tcp/filebench/"

define process name="readerP",instances=1 {
  thread name="readerT",instances=1 {
    flowop openfile name="openOP",filesetname="testF",directio
    flowop readwholefile name="readOP",filesetname="testF",directio
    flowop closefile name="closeOP"
  }
}

run 30
