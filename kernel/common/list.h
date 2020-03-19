//
// Created by chorm on 2020-03-19.
//

#ifndef LCNIX_LIST_H
#define LCNIX_LIST_H

#include <allocator.h>
#include <memory>

namespace lcnix{
    template<typename T,typename Allocator=lcnix::paged_allocator<T>> struct list{
    private:
        struct node{
            T value;
            node* last;
            node* next;
        };
        node* head;
        node* tail;
        Allocator alloc;
    public:

    };
}

#endif //LCNIX_LIST_H
