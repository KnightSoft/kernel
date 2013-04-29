; Kernel error screen
; Simply displays the A register on the screen. If things are
; bad enough that the kernel can't provide a nice error message,
; the user can handle some googling to figure out what's going on.

kernelError:
    ; This routine assumes that everything is well and truly screwed, 
    ; and cleans up everything it might need before use.
    di
    ld hl, 0 \ ld sp, 0
    push af
        ; Clear some memory
        ld hl, 0x8000
        ld de, 0x8001
        xor a
        ld (hl), a
        ld bc, 768
        ldir
        ; Reset the screen to a usable state
        ld a, 0x05
        call lcdDelay
        out (0x10), a
        ld a, 0x01
        call lcdDelay
        out (0x10), a
        ld a, 3
        call lcdDelay
        out (0x10), a
        ld a, 0x17
        call lcdDelay
        out (0x10), a
        ld a, $B
        call lcdDelay
        out (0x10), a
    pop af
    
    ld iy, 0x8000
    ld (iy), a
    ; We could just directly output to the screen and maybe be a
    ; little safer, but we need to clear the screen as well and
    ; this saves enough space to make it worth doing.
    call fastCopy_skipCheck
    
    jr $ ; Halt forever