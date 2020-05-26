#pragma ide diagnostic ignored "bugprone-reserved-identifier"


void exit(int code)__attribute__((noreturn));
void _Exit(int code)__attribute__((noreturn));

extern int main(int argc,char** argv,char** envp);


_Noreturn void _start(long* arg){
    _Exit(-1);
}