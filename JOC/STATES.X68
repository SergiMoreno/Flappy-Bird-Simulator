; =============================================================================
; TITLE    : GAME STATE MANAGEMENT
; AUTHOR   : SERGI MORENO PEREZ
;            ANTONI PAYERAS MUNAR
;            DANIEL SUAU VALLES
; HISTORY  : XX-XXX-201X - CREATION
;            11-OCT-2020 - MINOR CHANGES
;            23-DEC-2020 - STATES IMPLEMENTATION
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)       ; INVALID STATE, JUST TO FORCE INIT
            MOVE.W  #STAINTRO,(STANEXT)     ; INITIAL STATE

            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAOVERI,STASCOI
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAOVERU,STASCOU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAOVERP,STASCOP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS
            
; -----------------------------------------------------------------------------     
STAINTRI
; INITIALATION OF STATE INTRO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.B  #AUDMSKLP|AUDMU1ID,D1   ; CHANGE MUSIC
            JSR     AUDSND
            
            MOVE.W  #0,(REPAINT)
            
            RTS
            
; -----------------------------------------------------------------------------
STAINTRU
; PERFORMS STATE UPDATE
; INPUT    - NONE
; OUTPUT   - (STANEXT)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            CMP.B   #0,(MSECLK)             ; CHECK IF MOUSE CLICKED
            BEQ     .END                    ; NO=END
            MOVE.B  #0,(MSECLK)             ; YES=RESTART MOUSE CLICKED
            
            ; CHECK IF CLICK ON PLAY BUTTON
            ; NO=NEXT1
            CMP.W   #STRTLX,(MSEXPOS)       
            BLT     .NEXT1
            
            CMP.W   #STRTRX,(MSEXPOS)
            BGT     .NEXT1
            
            CMP.W   #STRTUY,(MSEYPOS)
            BLT     .NEXT1
            
            CMP.W   #STRTDY,(MSEYPOS)
            BGT     .NEXT1
            
            ; YES=CHANGE TO PLAY STATE
            MOVE.W  #STAPLAY,(STANEXT)
            BRA     .END
            
.NEXT1
            ; CHECK IF CLICK ON EXIT BUTTON
            ; NO=NEXT2
            CMP.W   #STRTLX,(MSEXPOS)       
            BLT     .NEXT2
            
            CMP.W   #STRTRX+58,(MSEXPOS)
            BGT     .NEXT2
            
            CMP.W   #STRTUY+20,(MSEYPOS)
            BLT     .NEXT2
            
            CMP.W   #STRTDY+58,(MSEYPOS)
            BGT     .NEXT2
            
            SIMHALT

.NEXT2
            ; CHECK IF CLICK ON SCORE BUTTON
            ; NO=NEXT3    
            CMP.W   #INFOLX,(MSEXPOS)
            BLT     .NEXT3
            
            CMP.W   #INFORX,(MSEXPOS)
            BGT     .NEXT3
            
            CMP.W   #INFOUY,(MSEYPOS)
            BLT     .NEXT3
            
            CMP.W   #INFODY,(MSEYPOS)
            BGT     .NEXT3
            
            ; YES=CHANGE TO SCORE STATE
            MOVE.W  #STASCO,(STANEXT)

.NEXT3            
            ; CHECK IF CLICK ON FILE CLEAR BUTTON
            ; NO=END
            CMP.W   #INFOLX,(MSEXPOS)
            BLT     .END
            
            CMP.W   #INFORX+58,(MSEXPOS)
            BGT     .END
            
            CMP.W   #INFOUY+59,(MSEYPOS)
            BLT     .END
            
            CMP.W   #INFODY+58,(MSEYPOS)
            BGT     .END
            ; YES=CLEAR SCORE FILE
            JSR     FILECLR  
             
.END        RTS
 
; -----------------------------------------------------------------------------     
STAINTRP
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A1,-(A7)
            
*            ; --- CHANGE LETTER STYLE & COLORS ---
*            MOVE.B  #21,D0
*            MOVE.L  #WHITE,D1               ; PEN COLOR
*            MOVE.L  #$060C0001,D2           ; LETTER STYLE
*            TRAP    #15                     ; SET PEN COLOR & LETTER STYLE
*            MOVE.B  #81,D0                  ; SET FILL COLOR TASK
*            MOVE.L  #BLACK,D1               ; FILL COLOR
*            TRAP    #15                     ; SET FILL COLOR
*
*            ; --- VISUALIZES TITLE AND SUBTITLE ---
*            MOVE.W  #12<<8|4,D1
*            MOVE.B  #11,D0
*            TRAP    #15
*            LEA     .TTL,A1
*            MOVE.B  #13,D0
*            TRAP    #15
*            
*            MOVE.W  #10<<8|6,D1
*            MOVE.B  #11,D0
*            TRAP    #15
*            LEA     .SUBTTL,A1
*            MOVE.B  #13,D0
*            TRAP    #15
            MOVE.B  #81,D0
            MOVE.L  #GREY,D1
            TRAP    #15
            MOVE.B  #80,D0
            MOVE.L  #GREY,D1
            TRAP    #15

            MOVE.B  #87,D0
            MOVE.W  #00,D1
            MOVE.W  #00,D2
            MOVE.W  #640,D3
            MOVE.W  #480,D4
            TRAP    #15

            ; --- CHANGE LETTER STYLE & COLORS ---
            MOVE.B  #21,D0
            MOVE.L  #BLACK,D1               ; PEN COLOR
            MOVE.L  #$06200001,D2           ; LETTER STYLE
            TRAP    #15                     ; SET PEN COLOR & LETTER STYLE


            ; --- VISUALIZES TITLE AND SUBTITLE ---
            MOVE.W  #4<<8|2,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .TTL,A1
            MOVE.B  #13,D0
            TRAP    #15

            ; --- CHANGE LETTER STYLE & COLORS ---
            MOVE.B  #21,D0
            MOVE.L  #BLACK,D1               ; PEN COLOR
            MOVE.L  #$03120000,D2           ; LETTER STYLE
            TRAP    #15                     ; SET PEN COLOR & LETTER STYLE


            MOVE.W  #9<<8|6,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .SUBTTL,A1
            MOVE.B  #13,D0
            TRAP    #15


            ; --- CHANGE LETTER STYLE & COLORS ---
            MOVE.B  #21,D0
            MOVE.L  #RED,D1                ; PEN COLOR
            MOVE.L  #$030A0001,D2           ; LETTER STYLE
            TRAP    #15                     ; SET PEN COLOR & LETTER STYLE
            
            ; --- DRAW OPTION SQUARES AND THEIR MESSAGES ---
            MOVE.L  #RED,D1
            MOVE.B  #80,D0
            TRAP    #15
            
            MOVE.W  #STRTLX,D1
            MOVE.W  #STRTUY,D2
            MOVE.W  #STRTRX,D3
            MOVE.W  #STRTDY,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVE.W  #STRTLX,D1
            MOVE.W  #STRTUY+62,D2
            MOVE.W  #STRTRX,D3
            MOVE.W  #STRTDY+62,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVE.W  #INFOLX,D1
            MOVE.W  #INFOUY,D2
            MOVE.W  #INFORX,D3
            MOVE.W  #INFODY,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVE.W  #INFOLX,D1
            MOVE.W  #INFOUY+62,D2
            MOVE.W  #INFORX+35,D3
            MOVE.W  #INFODY+62,D4
            MOVE.B  #87,D0
            TRAP    #15

            MOVE.W  #28<<8|17,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .BTNT,A1
            MOVE.B  #13,D0
            TRAP    #15
            
            MOVE.W  #47<<8|17,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .BTNP,A1
            MOVE.B  #13,D0
            TRAP    #15
            
            MOVE.W  #29<<8|21,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .BTNE,A1
            MOVE.B  #13,D0
            TRAP    #15
            
            MOVE.W  #47<<8|21,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .BTNC,A1
            MOVE.B  #13,D0
            TRAP    #15

            MOVEM.L (A7)+,D0-D4/A1

            RTS
            
.TTL        DC.B    'CRAZY BIRD DRIVING',0   
.SUBTTL     DC.B    'THE RETURN OF THE CRAZINESS',0
.BTNT       DC.B    'START',0
.BTNE       DC.B    'EXIT',0
.BTNP       DC.B    'SCORES',0
.BTNC       DC.B    'CLEAR SCORES',0
            DS.W    0
            
            
; -----------------------------------------------------------------------------     
STAPLAYI
; PERFORMS STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - (ENDGAME) AND (SCORE)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D1/A1-A3,-(A7)
            
            ; --- INIT END GAME VALUE AND SCORES
            MOVE.B  #0,(ENDGAME)
            MOVE.B  #48,(SCOREDC)
            MOVE.B  #48,(SCOREUN)
            
            MOVE.B  #AUDMSKLP|AUDMU2ID,D1   ; CHANGE MUSIC ON BACKGROUND
            JSR     AUDSND 
            
            JSR     PLRINIT                 ; INIT PLAYER OBJECT
            
            LEA     WALLINIT,A1             ; INIT FIRST WALL OBJECT
            LEA     WALLUPD,A2
            LEA     WALLPLOT,A3
            JSR     AGLADD                  ; ADD FIRST WALL TO THE AGENTLIST
            
            MOVEM.L (A7)+,D1/A1-A3
            RTS

; -----------------------------------------------------------------------------
STAPLAYU
; PERFORMS STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     PLRUPD                  ; UPDATE PLAYER OBJECT
            JSR     AGLUPD                  ; UPDATE AGENTS
            
            CMP.B   #1,(ENDGAME)            ; CHECK IF ENDGAME
            BNE     .CONTINUE               ; NO=CONTINUE
            
            JSR     FILEWR                  ; WRITE SCORE IN FILE
            
            MOVE.W  #STAOVER,(STANEXT)      ; CHANGE TO OVER STATE
            
.CONTINUE   RTS

; -----------------------------------------------------------------------------     
STAPLAYP
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     MAPPLOT                 ; MAPPLOT
            JSR     PLRPLOT                 ; DRAW PLAYER OBJECT
            JMP     AGLPLOT                 ; DRAW AGENTS
         
; -----------------------------------------------------------------------------
STAOVERI
; PERFORMS STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVE.B  #AUDMSKNL|AUDCRUID,D1   ; CHANGE MUSIC
            JSR     AUDSND
           
            RTS
; -----------------------------------------------------------------------------     
STAOVERU
; PERFORMS STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)     ; CHECK IF SPACE PRESSED
            BEQ     .END                    ; NO=END
            MOVE.W  #STAINTRO,(STANEXT)     ; YES=CHANGE TO INTRO STATE

.END        RTS

; -----------------------------------------------------------------------------
STAOVERP
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A1,-(A7)
            
            MOVE.B  #81,D0
            MOVE.L  #GREY,D1
            TRAP    #15
            MOVE.B  #80,D0
            MOVE.L  #GREY,D1
            TRAP    #15
            
            MOVE.B  #87,D0
            MOVE.W  #00,D1
            MOVE.W  #00,D2
            MOVE.W  #640,D3
            MOVE.W  #480,D4
            TRAP    #15
            
            MOVE.B  #92,D0
            MOVE.B  #16,D1
            TRAP    #15

            LEA     IMGDATA,A1
            MOVE.W  #140,D2
            MOVE.W  #185,D3 
            
.LOOP       MOVE.B  #80,D0
            MOVE.L  (A1)+,D1 
            TRAP    #15
            
            MOVE.B  #82,D0
            CLR     D1
            MOVE.W  D3,D1
            TRAP    #15
            ADDQ.W  #1,D1
            TRAP    #15
            ADDQ.W  #1,D2
            TRAP    #15
            SUBQ.W  #1,D1
            TRAP    #15
            SUBQ.W  #1,D2

            ADDQ.W  #2,D3
            
            CMP     #441,D3
            BEQ     .SEGFILA
            BRA     .LOOP
            
.SEGFILA    MOVE.W  #185,D3
            ADDQ.W  #2,D2
            CMP     #396,D2
            BEQ     .OK
            BRA     .LOOP
.OK
            ; --- CHANGE LETTER STYLE & COLORS ---
            MOVE.B  #21,D0
            MOVE.L  #BLACK,D1               ; PEN COLOR
            MOVE.L  #$02260001,D2           ; LETTER STYLE
            TRAP    #15                     ; SET PEN COLOR & LETTER STYLE
            
            MOVE.W  #6<<8|1,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .TTL,A1
            MOVE.B  #13,D0
            TRAP    #15

            ; --- CHANGE LETTER STYLE & COLORS ---
            MOVE.B  #21,D0
            MOVE.L  #$03120000,D2           ; LETTER STYLE
            TRAP    #15                     ; SET PEN COLOR & LETTER STYLE

            MOVE.W  #7<<8|4,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .SUBTTL,A1
            MOVE.B  #13,D0
            TRAP    #15
            
            ; --- CHANGE LETTER STYLE & COLORS ---
            MOVE.B  #21,D0
            MOVE.L  #$01100000,D2           ; LETTER STYLE
            TRAP    #15                     ; SET PEN COLOR & LETTER STYLE
            
            MOVE.W  #27<<8|30,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .MSG,A1
            MOVE.B  #13,D0
            TRAP    #15
.END        
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            
            MOVE.B  #1,(REPAINT)
            MOVEM.L (A7)+,D0-D4/A1

            RTS
            
.TTL        DC.B    'YOU DIED',0   
.SUBTTL     DC.B    'WOULD YOU LIKE TO TRY IT AGAIN?',0
.MSG        DC.B    'PRESS SPACE KEY TO RETURN',0
            DS.W    0


; -----------------------------------------------------------------------------
STASCOI
; PERFORMS STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.B  #AUDMSKLP|AUDSCOID,D1
            JSR     AUDSND                  ; PLAY SCORE MUSIC
            
            RTS    

; -----------------------------------------------------------------------------     
STASCOU
; PERFORMS STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CMP.B   #0,(MSECLK)             ; CHECK IF MOUSE CLICKED
            BEQ     .END                    ; NO=END
            MOVE.B  #0,(MSECLK)             ; YES=RESTART MOUSE CLICKED
            MOVE.W  #STAINTRO,(STANEXT)     ; CHANGE TO INTRO STATE

.END        RTS

; -----------------------------------------------------------------------------
STASCOP
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)

            JSR     FILECAP                 ; STORES HEADER BYTES
            
            ; --- SET FILL COLOR ---
            MOVE.B  #81,D0
            MOVE.L  #BLACK,D1
            TRAP    #15
            
            ; --- VISUALIZATION OF HEADER ---
            LEA     TOREAD,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     FILERD                  ; STORES SCORE VALUES


            ; --- LOOP FOR SCORE VISUALIZATION ---
            CLR.W   D2                      ; COUNTER OF SCORES PER LINE
            LEA     TOREAD,A1
            CMP.B   #42,(A1)
            BEQ     .MSG
.LOOP       CMP.B   #0,(A1)
            BEQ     .MSG
            MOVE.B  #1,D0
            MOVE.W  #2,D1
            TRAP    #15                     ; VISUALIZES TWO BYTES OF SCORE
            
            ; CHECK IF TEN SCORES HAS BEEN VISUALIZATED
            CMP.W   #9,D2
            BNE     .SPACE                  ; NO=SPACE
            ; YES=VISUALIZES CR AND FL
            MOVE.B  #6,D0
            MOVE.B  #13,D1
            TRAP    #15
            MOVE.B  #6,D0
            MOVE.B  #10,D1
            TRAP    #15
            CLR.W   D2                      ; RESTART COUNTER
            BRA     .NLINE
.SPACE            
            MOVE.B  #6,D0
            MOVE.B  #32,D1
            TRAP    #15                     ; VISUALIZES SPACE
            ADDQ.W  #1,D2                   ; INCREASE COUNTER
.NLINE
            ADD.L   #2,A1                   ; POINTER TO NEXT TWO BYTES
            BRA     .LOOP
.MSG        
            BTST.B  #3,(SCRCYCCT)
            BEQ     .END
            
            MOVE.W  #23<<8|25,D1            ; SHOWS MESSAGE TO RETURN
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .INFO,A1
            MOVE.B  #14,D0
            TRAP    #15
.END    
            MOVEM.L (A7)+,D0-D2/A1
            RTS
.INFO       DC.B    'CLICK ON  THE SCREEN TO RETURN',0
            DS.W    0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
