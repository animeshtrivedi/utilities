#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <sys/time.h>

#define DATA_SIZE 1000
/* Variable to store user content */
char data[DATA_SIZE];
char path[]="/mnt/nvmf-tcp/atr-bench/";

static unsigned long long epoch_time(){
    struct timeval tv;
    gettimeofday(&tv, NULL);
    unsigned long long usec =
            (unsigned long long) (tv.tv_sec) * 1000000 +
            (unsigned long long) (tv.tv_usec);
    return usec;
}

int create_single(char *fpath, int dirfd) {
    int fd = open(fpath, O_CREAT | O_WRONLY | O_APPEND | O_CREAT, 0644);
    if (fd < 0) {
        printf("file opening failed path %s errno %d \n", fpath, errno);
        return -1;
    }
    if(fsync(fd) != 0){
        printf("file fsync failed path %s errno %d \n", fpath, errno);
        return -1;
    }
    if(fsync(dirfd) != 0){
        printf("file fsync DIR failed path %s errno %d \n", fpath, errno);
        return -1;
    }
    close(fd);
    return 0;
}

int main(int argc, char **argv) {
    int times = 10;
    // add +10 bytes in the end to capture a 10 digit number
    int sizeAlloc = strlen(path) + 10;
    char *enumPath = calloc(sizeAlloc, 1);
    if(enumPath == NULL){
        printf("Failed memory allocation \n");
        return -1;
    }
    if(argc == 2){
        times = atoi(argv[1]);
    }
    // open the dirfd
    int dirfd = open(path, O_WRONLY, 0644);
    if(dirfd < 0){
        printf("opening of the directory path failed at %s errno %d \n", path, errno);
        return -1;
    }

    long long int s = epoch_time();
    for(int i = 0; i < times; i++){
        snprintf(enumPath, sizeAlloc, "%s/%d", path, i);
        if(create_single(enumPath, dirfd) != 0){
            printf("Error failed, break \n");
            break;
        }
    }
    long long int e = epoch_time();
    close(dirfd);
    printf(" %d files at %s directory took %llu milliseconds\n", times, path, (e-s)/1000);
    return 0;
}
