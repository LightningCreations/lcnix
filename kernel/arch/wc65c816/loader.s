
.text.init

.global _Reset

_Reset:
    sei
    clc
    xce
    // Now back in regular execution mode
    rep #$30
    lda #__stack_tail
    tas
    sta __frame_base
    lda #$1600
    bit __expt_caps
    bne __unsupported
    lda #$7140
    sta __expt_secondary_paging
    sep #$20
    jmp __boot_start // Foreign Function we don't control, obey the calling convention

__unsupported:
    stp