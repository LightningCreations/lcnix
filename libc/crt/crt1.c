

void exit(int code)__attribute__((noreturn));

extern int main(int argc,char** argv,char** envp);


_Noreturn void _start(long* arg){
    exit(-1);
}