; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZATION THE PLAYER
; INPUT    - NONE
; OUTPUT   - (PLRPOSY)
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVE.W  #PLRYINI,(PLRPOSY)  ; INITIAL Y CONVERTED
            MOVE.L  #0,(PLRYSPD)
            
            RTS

; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - (KBDVAL)
; OUTPUT   - (PLRPOSY) AND (PLRYSPD)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D0,-(A7)
                  
            BTST.B   #KBDBITUP,(KBDVAL)     ; UP BUTTON PRESSED?
            BNE      .MOVEU                 ; YES
            ADD.L    #PLRACCY,(PLRYSPD)     ; DECREMENT THE SPEED
            MOVE.W   (PLRYSPD),D0
            ADD.W    D0,(PLRPOSY)           ; UPDATE THE Y POSITION

            CMP.W    #SCRHEIGH-PLRRAD,(PLRPOSY)  ; BOTTOM EDGE?
            BLT      .TOP                   ; NO=TOP
            MOVE.W   #SCRHEIGH-PLRRAD,(PLRPOSY)  ; SET POSITION         
            BRA      .END


.MOVEU      MOVE.L   #PLRVINIT,(PLRYSPD)    ; INIT Y SPEED
            MOVE.W   (PLRYSPD),D0
            ADD.W    D0,(PLRPOSY)           ; UPDATE THE Y POSITION

.TOP        CMP.W    #PLRRAD,(PLRPOSY)      ; TOPSIDE EDGE?
            BGT      .END                   ; NO=END
            MOVE.W   #PLRRAD,(PLRPOSY)
            MOVE.L   #PLRACCY,(PLRYSPD)     ; PREPARE SPEED TO DECREASE
.END        MOVEM.W  (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L  D0-D4,-(A7)
            
            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #BLACK,D1               ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            ADDQ.B  #1,D0                   ; SET FILL COLOR TASK
            MOVE.L  #YELLOW,D1              ; FILL COLOR
            TRAP    #15                     ; SET FILL COLOR
            
            ; --- DRAW THE BODY ---
            MOVE.W  #PLRPOSX,D1             ; D1 = XCENTRAL
            MOVE.W  (PLRPOSY),D2            ; D2 = YCENTRAL
            MOVE.W  D1,D3                   ; D3 = XCENTAL
            MOVE.W  D2,D4                   ; D4 = YCENTRAL
            SUB.W   #PLRRAD,D1              ; D1 = XLEFT
            SUB.W   #PLRRAD,D2              ; D2 = YTOP
            ADD.W   #PLRRAD,D3              ; D3 = XRIGHT              
            ADD.W   #PLRRAD,D4              ; D4 = YBOTTOM
            MOVE.B  #88,D0                  ; DRAW ELIPSE TASK
            TRAP    #15                     ; DRAW ELIPSE
            
            ; --- DRAW THE WING ---
            MOVE.W  #PLRPOSX-5,D3
            SUB.W   #5,D1
            ADD.W   #10,D2
            SUB.W   #10,D4
            TRAP    #15
            
            ; --- DRAW THE EYE SCLERA ---
            MOVE.B  #81,D0
            MOVE.L  #WHITE,D1
            TRAP    #15
            SUB.W   #6,D2
            SUB.W   #7,D4
            ADD.W   #32/2+7,D3
            MOVE.W  #PLRPOSX+6,D1
            MOVE.B  #88,D0
            TRAP    #15
            
            ; --- DRAW THE LIPS ---
            MOVE.B  #81,D0
            MOVE.L  #RED,D1
            TRAP    #15
            ADD.W   #11,D2
            ADD.W   #10,D4
            ADD.W   #2,D3
            MOVE.W  #PLRPOSX+4,D1
            MOVE.B  #88,D0
            TRAP    #15
            
            ; --- DRAW THE LIP SEPARATION ---
            MOVE.B  #81,D0
            MOVE.L  #BLACK,D1
            TRAP    #15
            ADD.W   #5,D2
            SUB.W   #4,D4
            MOVE.W  #PLRPOSX+9,D1
            MOVE.B  #87,D0
            TRAP    #15
            
            ; --- DRAW THE IRIS ---
            SUB.W   #11,D2
            SUB.W   #9,D4
            ADD.W   #4,D1
            MOVE.W  D1,D3
            ADD.W   #2,D3
            MOVE.B  #88,D0
            TRAP    #15

            MOVEM.L  (A7)+,D0-D4
            RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
