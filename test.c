#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

typedef double msec_t;

msec_t time_msec(void) {
        struct timeval now_tv;
        gettimeofday(&now_tv, NULL);
        return (msec_t)now_tv.tv_sec * (msec_t)1000 + now_tv.tv_usec / (msec_t)1000;
}

int main(int argc, char *argv[]) {
        if(argc != 4) exit(1);
        double f1 = atof(argv[1]);
        double f2 = atof(argv[2]);
        double ans = 1.0;
        msec_t start = time_msec();
        long iterations = atoi(argv[3]) * 1000 * 1000;
        for(int i=0; i<iterations; i++) {
          ans *= f1;
          ans /= f2;
          //if(i < 10)
            //printf("%d ans = %f\n", i, ans);
        }
        msec_t end = time_msec();
        printf("ans = %f %d loop/msec\n", ans, (int)(iterations/(end - start)));
        return 0;
}
