#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <sys/time.h>

#define DATA_SIZE 512
//char path[]="/mnt/nvmf-tcp/atr-bench/";
//char path[]="/home/atr/optane-mnt/atr-test/";

static unsigned long long epoch_time(){
    struct timeval tv;
    gettimeofday(&tv, NULL);
    unsigned long long usec =
            (unsigned long long) (tv.tv_sec) * 1000000 +
            (unsigned long long) (tv.tv_usec);
    return usec;
}

int create_single(char *fpath, int dirfd, char *buffer, int size) {
    int fd = open(fpath, O_CREAT | O_WRONLY | O_APPEND | O_CREAT, 0644);
    if (fd < 0) {
        printf("file opening failed path %s errno %d \n", fpath, errno);
        return -1;
    }
    /* write it out */
    int done = 0, ret;
    while (done < size){
        ret = write(fd, buffer + done, size - done);
        if(ret < 0){
            return ret;
        }
        done+=ret;
    }
    if(fsync(fd) != 0){
        printf("file fsync failed path %s errno %d \n", fpath, errno);
        return -1;
    }
    close(fd);

    if(fsync(dirfd) != 0){
        printf("file fsync DIR failed path %s errno %d \n", fpath, errno);
        return -1;
    }
    return 0;
}

int main(int argc, char **argv) {
    int times = 10;
    char *buffer = calloc(1, DATA_SIZE);
    if(buffer == NULL){
        printf("buffer allocation of size %d failed\n", DATA_SIZE);
        return -ENOMEM;
    }
    if(argc < 3){
        printf("Please pass : path and number. Like: \n");
        printf("./a.out /home/atr/optane-mnt/atr-test/ 10000");
        return -1;
    }
    char *path = argv[1];
    // add +100 bytes in the end to capture a 100 digit number, well!
    int sizeAlloc = strlen(path) + 100;
    char *enumPath = calloc(sizeAlloc, 1);
    if(enumPath == NULL){
        printf("Failed memory allocation \n");
        return -1;
    }
    times = atoi(argv[2]);
    // open the dirfd
    int dirfd = open(path, O_RDONLY|O_DIRECTORY, 0644);
    if(dirfd < 0){
        printf("opening of the directory path failed at %s errno %d \n", path, errno);
        return -1;
    }

    long long int s = epoch_time();
    for(int i = 0; i < times; i++){
        snprintf(enumPath, sizeAlloc, "%s/%d", path, i);
        if(create_single(enumPath, dirfd, buffer, DATA_SIZE) != 0){
            printf("Error failed, break \n");
            break;
        }
    }
    long long int e = epoch_time();
    close(dirfd);
    float msec = (e-s)/1000;
    printf(" %d files at %s directory took %f milliseconds\n", times, path, msec);
    printf(" rate: %f ops/sec \n", (times * 1000)/msec);
    return 0;
}
