//
// Created by chorm on 2020-03-19.
//

#ifndef LCNIX_ALLOCATOR_H
#define LCNIX_ALLOCATOR_H

#include <cstddef>

namespace lcnix{
    struct ProcessHandle;
    extern"C" void* alloc_paged(std::size_t size,ProcessHandle* ctx);
    extern"C" void free_paged(void* vptr,ProcessHandle* ctx);
    extern"C" void* alloc_atomic(std::size_t size);
    extern"C" void free_atomic(void* vptr);

    extern"C" [[noreturn]] void panic(const char*);

    // Use this allocator in the context of a process
    // Such as in a syscall
    template<typename T> struct paged_allocator{
    private:
        ProcessHandle* handle;
    public:
        using value_type = T;
        explicit paged_allocator(ProcessHandle* handle) : handle(handle){}
        template<typename U> explicit paged_allocator(paged_allocator<U> other) : handle(handle){}
        T* allocate(std::size_t cnt){
            if(void* ret =alloc_paged(cnt*sizeof(T),handle);ret)
                return static_cast<T*>(ret);
            else
                panic("Allocation failure in alloc_paged.");
        }
        void deallocate(T* v,std::size_t cnt){
            free_paged(v,handle);
        }
    };

    // Use this allocator in interrupts
    template<typename T> struct atomic_allocator{
        template<typename U> explicit atomic_allocator(paged_allocator<U>){}
        T* allocate(std::size_t cnt){
            if(void* ret =alloc_atomic(cnt*sizeof(T));ret)
                return static_cast<T*>(ret);
            else
                panic("Allocation failure in alloc_atomic.");
        }
        void deallocate(T* v,std::size_t cnt){
            free_atomic(v);
        }
    };
}

#endif //LCNIX_ALLOCATOR_H
