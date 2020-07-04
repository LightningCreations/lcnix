
.global running_hypervisor virtualization_available vm_call


.is_amd_svm:


virtualization_available:
    call .is_amd_svm
    beq .is_intel_vt // Tailcall if no amd_svm
    ret



running_hypervisor:
    call virtualization_available
    ble .no_hypervisor
    mov 0x40000000,%eax
    cpuid
    cmp %eax,0x40000001
    bge .test_hypervisor_type
    .no_hypervisor:
    xor %rax,%rax
    ret
    .test_hypervisor_type:
    #test for lc platform hypervisor
    mov 0x40000001,%eax
    cpuid
    cmp %eax,0x4C435048 # Signature Register
    bne .not_lchypervisor
    cmp %ebx,0xEE4C4300 # Number of running guests.
    bne .not_lchypervisor
    cmp %ecx,0x414D4456
    be .is_lchypervisor
    .not_lchypervisor:
    mov 1,%rax
    ret
    .is_lchypervisor:
    xor %rax,%rax
    mov 0x4C434E4958565000,%rdi
    call vm_call
    cmp %rax,0x4C434E4958565000
    bne .not_lchypervisor
    mov 2,%rax
    ret



vm_call:
    call .is_amd_svm
    bne .amd_vm_call
    call .is_intel_vt
    bne .intel_vt_call
    mov 0xFFFFFFFFFFFFFFFF,%rax
    ret
    .amd_vm_call:
    vmcall
    ret
    .intel_vt_call:
    vmmcall
    ret