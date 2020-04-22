# emap(2)

int emap(void* pg); 

Maps the Page indicated by pg into an encrypted Page. The page is transparently
 encrypted and decrypted whenever read. 

Encrypted Pages cannot be read from outside the process they were created. 
If read via /proc/<pid>/mem, the ciphertext is read, rather than the plaintext. 
Encrypted Pages are unmapped in children created by fork(2) or clone(2). 

pg shall not be a page mapped to a file descriptor, unless PROC_COW is used. 
If PROC_COW is used for that page, the page is copied, and the fd descriptor is unbound. 

A process cannot map more encrypted pages than is specified in /proc/sys/kernel/emap-max, unless it has CAP_SYS_RESOURCE. 

