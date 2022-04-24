; =============================================================================
; SYSTEM VARIABLES
; =============================================================================

; --- KEYBOARD RELATED VARIABLES ----------------------------------------------

KBDVAL      DS.B    1                       ; KEY PRESSED=1
KBDEDGE     DS.B    1                       ; KEY CHANGED=1

            DS.W    0

; --- SCREEN RELATED VARIABLES ------------------------------------------------

SCRINTCT    DS.B    1                       ; INTERRUPT COUNTER/FLAG
SCRCYCCT    DS.B    1                       ; CYCLE COUNTER
            DS.W    0
            
; --- MOUSE RELATED VARIABLES -------------------------------------------------

MSEPOS
MSEYPOS     DS.W    1                       ; MOUSE UP CLICKED POSITION
MSEXPOS     DS.W    1

; --- DYNAMIC MEMORY VARIABLES ------------------------------------------------

            ORG     (*+DMMBSIZE-1)&-DMMBSIZE ; ALIGN TO DMMBSIZE
DMMDATA     DS.B    DMMBSIZE*DMMBNUM        ; DYNAMIC MEMORY ALLOCATION SPACE
            DS.W    0                       ; JUST IN CASE (SIZE IS POW OF TWO)







*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
