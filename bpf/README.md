 * nvme-trace is taken from https://www.informit.com/articles/article.aspx?p=2995360&seqNum=3
   * I modified to have it #!/usr/bin/env bpftrace instead of #!/usr/local/bin/bpftrace
   * must be run as root
 * biostack is from https://github.com/iovisor/bpftrace/tree/master/tools 

Size count histogram example:
```shell
bpftrace -e 'tracepoint:block:block_rq_issue { @ = hist(args->bytes); }'
```

To search for all probes (example nvme): 
```shell
bpftrace -l 'kprobe:*nvme*' | less
```

But attaching does not work on wild card, https://github.com/iovisor/bpftrace/issues/1036 (wild card pattern matching)  
Attaching one by one works: 
```shell
root@node1:/home/atr# bpftrace -e 'kprobe:nvme_alloc_request { @[func] = count(); }'
Attaching 1 probe...
^C

@[nvme_alloc_request]: 2
```

