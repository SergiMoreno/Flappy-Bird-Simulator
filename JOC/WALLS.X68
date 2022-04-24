; =============================================================================
; TITLE    : WALLS MANAGEMENT (AGENT)
; AUTHOR   : SERGI MORENO PEREZ
;            ANTONI PAYERAS MUNAR
;            DANIEL SUAU VALLES
; COMMENTS : WALL AGENT LOCAL VARIABLES:
;             (A0) : XCENTER - WORD
;            2(A0) : YGAP    - WORD
;            4(A0) : XSPEED  - WORD
; HISTORY  : 12-10-2020 - CREATION
;            26-12-2020 - MINOR CHANGES
;            27-12-2020 - WALLS IMPLEMENTATION
; =============================================================================

; -----------------------------------------------------------------------------
WALLINIT
; INITIALIZE A BALL
; INPUT    - NONE
; OUTPUT   - (A0),2(A0),4(A0)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)            ; STACK REGISTERS  
          
            ; --- GENERATE A RANDOM NUMBER FOR THE WALL GAP ---
            JSR     RNDGET                  ; D0.L=RND(0,255)
            ADD.W   #SCRHEIGH/2-127,D0      ; D0.W=RND(XC-127,XC+128) 
            MOVE.W  D0,2(A0)                ; SET THE YGAP
            MOVE.W  #SCRWIDTH-50,(A0)       ; SET THE XCENTER            
            MOVE.W  #WALLSPD,4(A0)          ; SET THE SPEED
                                            
            MOVEM.L (A7)+,D0-D1/A1          
            RTS

; -----------------------------------------------------------------------------
WALLUPD
; UPDATE A WALL
; INPUT    - NONE
; OUTPUT   - (SCORE) AND (ENDGAME) 
; MODIFIES - (A0)
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1-A3,-(A7)
            
            ; --- RIGHT WALL LOCATION PASSED THE PLAYER? ---
            MOVE.W  (A0),D0                 ; D0 = XCENTER                
            ADD.W   #WALLWDH/2,D0           ; D0 = XRIGHT                  
            CMP.W   #WALLSCR,D0             ; CHECK WALL LOCATION
            BNE     .SCR                    ; NO=SCR
            
            CMP.B   #57,(SCOREUN)           ; INCREASE TENS?
            BNE     .NDC                    ; NO=NDC
            
            ADDQ.B  #1,(SCOREDC)
            MOVE.B  #48,(SCOREUN)
            BRA     .SCR
            
.NDC        ADDQ.B   #1,(SCOREUN)           ; INCREMENT SCORE
            
            ; --- WALL IN DESIRED LOCATION? ---
.SCR        CMP.W   #WALLSPC,D0             ; CHECK WALL LOCATION
            BNE     .SKP                    ; NO=SKP
            LEA     WALLINIT,A1             
            LEA     WALLUPD,A2
            LEA     WALLPLOT,A3
            JSR     AGLADD                  ; CREATE A NEW WALL (AGENT)
          
            ; --- PLAYER LOCATION IN X WALL RANGE? ---
.SKP        SUB.W   #WALLWDH,D0             ; D0 = XLEFT
            CMP.W   #PLRPOSX+32/2,D0        ; PLAYER FURTHER LEFT THAN WALL?
            BGE     .NSQR                   ; YES=NSQR
            
            ADD.W   #WALLWDH,D0             ; D0 = XRIGHT
            CMP.W   #PLRPOSX-32/2,D0        ; PLAYER FURTHER RIGHT THAN WALL?
            BLE     .NSQR                   ; YES=NSQR

            ; --- PLAYER LOCATION IN Y WALL RANGE? ---
            MOVE.W  (PLRPOSY),D1            ; D1 = PLAYER YCENTER
            SUB.W   #PLRRAD,D1              ; D1 = PLAYER YTOP
            MOVE.W  2(A0),D0                ; D0 = YGAP
            SUB.W   #WALLHLE/2,D0           ; DO = YBOTTOM (UP WALL)
            CMP.W   D0,D1                   ; PLAYER FURTHER DOWN THAN TOP WALL?             
            BLE     .STOP                   ; YES=STOP
       
            ADD.W   #WALLHLE,D0             ; D0 = YTOP (DOWN WALL)
            ADD.W   #32,D1                  ; D1 = PLAYER YBOTTOM
            CMP.W   D0,D1                   ; PLAYER FURTHER UP THAN DOWN WALL?
            BGE     .STOP                   
            
            ; --- DECREASE WALL LOCATION --- 
.NSQR       MOVE.W  (A0),D0
            SUB.W   4(A0),D0
            MOVE.W  D0,(A0)
            
            ; --- CHECK WALL X LOCATION ---
            CMP.W   #-WALLWDH/2,(A0)        ; WALL OFF-SCREEN?
            BGE     .END                    ; NO=END
            JSR     AGLKILL                 ; DELATE WALL
            BRA     .END
            
.STOP       JSR     AGLKILLA                ; DELATE ALL AGENTS
            MOVE.B  #1,(ENDGAME)            ; UPDATES ENDGAME
            
.END        MOVEM.L (A7)+,D0-D1/A1-A3
            RTS


; -----------------------------------------------------------------------------
WALLPLOT
; PLOT A WALL
; INPUT    - NONE
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A1,-(A7)

            ; --- SET COLORS ---
            MOVE.B  #80,D0                  ; SET PEN COLOR TASK
            MOVE.L  #BLACK,D1               ; PEN COLOR
            TRAP    #15                     ; SET PEN COLOR
            ADDQ.B  #1,D0                   ; SET FILL COLOR TASK
            MOVE.L  #GREEN,D1               ; FILL COLOR
            TRAP    #15                     ; SET FILL COLOR

            ; --- UP WALL ---
            MOVE.W  (A0),D1                 ; D1 = XCENTER
            MOVE.W  #0,D2                   ; D2 = YTOP       
            MOVE.W  D1,D3                   ; D3 = XCENTER
            MOVE.W  2(A0),D4                ; D4 = YGAP
            SUB.W   #WALLHLE/2,D4           ; D4 = YBOTTOM
            SUB.W   #WALLWDH/2,D1           ; D1 = XLEFT
            ADD.W   #WALLWDH/2,D3           ; D3 = XRIGHT
            MOVE.B  #87,D0                  
            TRAP    #15                     ; DRAW RECTANGLE

            ; --- DOWN WALL ---
            MOVE.W  2(A0),D2                ; D2 = YGAP         
            ADD.W   #WALLHLE/2,D2           ; D2 = YTOP
            MOVE.W  #SCRHEIGH,D4            ; D4 = YBOTTOM
            MOVE.B  #87,D0
            TRAP    #15                     ; DRAW RECTANGLE 

            
            ; --- UP WALL DECORATION ---
            SUB.W   #5,D1                   ; D1 = XLEFT
            ADD.W   #5,D3                   ; D3 = XRIGHT
            MOVE.W  2(A0),D4                ; D4 = YGAP
            SUB.W   #WALLHLE/2,D4           ; D4 = YBOTTOM
            MOVE.W  D4,D2                   
            SUB.W   #20,D2                  ; D2 = YTOP
            MOVE.B  #87,D0               
            TRAP    #15                     ; DRAW RECTANGLE

            ; --- DOWN WALL DECORATION ---
            ADD.W   #WALLHLE+WALLDEC,D4     ; D4 = YBOTTOM           
            ADD.W   #WALLHLE+WALLDEC,D2     ; D2 = YTOP       
            TRAP    #15                     ; DRAW RECTANGLE
            
            ; --- CHANGE LETTER STYLE & COLORS ---
            MOVE.B  #21,D0
            MOVE.L  #WHITE,D1               ; PEN COLOR
            MOVE.L  #$03120001,D2           ; LETTER STYLE
            TRAP    #15                     ; SET PEN COLOR & LETTER STYLE
            MOVE.B  #81,D0                  ; SET FILL COLOR TASK
            MOVE.L  #BLUE,D1                ; FILL COLOR
            TRAP    #15                     ; SET FILL COLOR

            ; --- SCORE MARKER ---
            MOVE.W  #20<<8|1,D1             ; SET POINTER LOCATION
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .STR,A1                 ; LOAD TEXT TO PRIND
            MOVE.B  #14,D0
            TRAP    #15                     ; PRINT TEXT
            MOVE.B  (SCOREDC),D1            ; LOAD SCORE VALUE TO PRINT
            MOVE.B  #6,D0
            TRAP    #15
            MOVE.B  (SCOREUN),D1            ; LOAD SCORE VALUE TO PRINT
            MOVE.B  #6,D0
            TRAP    #15                     ; PRINT SCORE
            
            MOVEM.L (A7)+,D0-D4/A1
            RTS

.STR        DC.B    'SCORE:',0 
            DS.W    0




*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~0~
*~Tab size~4~
