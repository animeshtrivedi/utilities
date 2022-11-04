#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>

#define DATA_SIZE 1000
/* Variable to store user content */
char data[DATA_SIZE];
char path[]="/mnt/nvmf-tcp/atr-bench/";

int create_single(char *fpath) {
    int fd = open(fpath, O_CREAT | O_WRONLY | O_APPEND | O_CREAT, 0644);
    if (fd < 0) {
        printf("file opening failed errno %d \n", errno);
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
    for(int i = 0; i < times; i++){
        snprintf(enumPath, sizeAlloc, "%s/%d", path, i);
        if(create_single(enumPath) != 0){
            printf("Error failed, break \n");
            break;
        }
    }
    return 0;
}
