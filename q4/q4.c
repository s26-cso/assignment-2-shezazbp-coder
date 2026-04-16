#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[6];        
    int n1, n2;

    while (scanf("%s %d %d", op, &n1, &n2) == 3) {
        char libname[20];
        snprintf(libname, sizeof(libname), "./lib%s.so", op);

        // Loading shared library
        void *handle = dlopen(libname, RTLD_LAZY);
        if (!handle) {
            fprintf(stderr, "Error loading %s\n", libname);
            continue;
        }

// Getting function from library
        int (*func)(int, int);
        *(void **)(&func) = dlsym(handle, op);

        if (!func) {
            fprintf(stderr, "Error finding function %s\n", op);
            dlclose(handle);
            continue;
        }
        int result = func(n1, n2);
        printf("%d\n", result);
        dlclose(handle);
    }

    return 0;
}