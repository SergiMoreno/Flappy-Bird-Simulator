; =============================================================================
; FILES MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
FILEWR
; WRITES SCORE IN FILE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            
            MOVE.B  #59,D0                  ; CHECK IF FILE EXIST
            LEA     NAME,A1
            CLR.L   D1
            TRAP    #15
            
            TST.W   D0
            BEQ     .EXIST                  ; YES: EXIST
            
            MOVE.B  #52,D0
            TRAP    #15
            BRA     .NEXIST           

.EXIST      
            MOVE.B  #51,D0
            TRAP    #15
            
            MOVE.B  #55,D0                    
            JSR     FILEGET                 
            MOVE.L  (FILESIZE),D2           ; POINTS TO FINAL POSITION OF
            TRAP    #15                     ; EXISTING FILE
.NEXIST            
            MOVE.B  #54,D0
            LEA     SCORE,A1
            MOVE.L  #2,D2
            TRAP    #15                     ; WRITE 2 BYTES OF SCORE IN FILE
            
            MOVE.B  #56,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D2/A1
            RTS

; -----------------------------------------------------------------------------
FILECLR
; CLEAR SCORE IN FILE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            
            MOVE.B  #59,D0                  ; CHECK IF FILE EXIST
            LEA     NAME,A1
            CLR.L   D1
            TRAP    #15
            
            TST.W   D0
            BNE     .NEXIST                 ; NO=NEXIST
            
            MOVE.B  #0,(FILEXIST)
            MOVE.B  #57,D0
            TRAP    #15

.NEXIST     
            
            MOVEM.L (A7)+,D0-D2/A1
            RTS


; -----------------------------------------------------------------------------            
FILERD
; READS EXISTING SCORE FILE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            
            MOVE.B  #59,D0                  ; CHECK IF FILE EXIST
            LEA     NAME,A1
            CLR.L   D1
            TRAP    #15
            
            TST.W   D0
            BNE     .NEXIST                 ; NO=NEXIST
              
            MOVE.B  #51,D0
            LEA     NAME,A1
            TRAP    #15
            
            ; READ THE FILE
            LEA     TOREAD,A1
            MOVE.L  #2,D2
.READLOOP   MOVE.B  #53,D0
            TRAP    #15                     ; READ "READSIZE" = 2 BYTES
            ADD.L   #2,A1                   ; INCREASE POINTER FOR MORE READS           
            TST.W   D0                      ; IS IT EOF?
            BEQ     .READLOOP               ; NO: READ MORE
                                            
            SUB.L   #2,A1                   ; ONCE ALL SCORES READEN
            MOVE.B  #0,(A1)                 ; END STORING NULL CARACTER

            ; CLOSE THE FILE
            MOVE.B  #56,D0
            TRAP    #15
            BRA     .EXIST

.NEXIST  
            MOVE.B  #1,(FILEXIST)
            MOVE.W  #1<<8|3,D1
            MOVE.B  #11,D0
            TRAP    #15
            LEA     .INFO,A1
            MOVE.B  #13,D0
            TRAP    #15
.EXIST    
            MOVEM.L (A7)+,D0-D2/A1
            RTS
.INFO       DC.B    'NONE',0
            DS.W    0

; -----------------------------------------------------------------------------
FILECAP
; READ HEADER FROM EXISTING FILE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            
            MOVE.B  #51,D0
            LEA     FITX,A1
            TRAP    #15
            
            ; READS A CONSTANT NUMBER OF BYTES FROM HEADER FILE
            LEA     TOREAD,A1               
            MOVE.L  #94,D2
            MOVE.B  #53,D0
            TRAP    #15
            ADDA.L  #94,A1
            MOVE.B  #0,(A1)
            
            MOVE.B  #56,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D2/A1
            RTS

; -----------------------------------------------------------------------------            
FILEGET
; GETS BYTES SIZE OF EXISTING FILE
; INPUT    - NONE
; OUTPUT   - (FILESIZE)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A1,-(A7)
              
            MOVE.B  #51,D0
            LEA     NAME,A1
            TRAP    #15
            
            CLR.L   D3
            ; READ THE FILE
            LEA     TOREAD,A1
            MOVE.L  #2,D2
.READLOOP   MOVE.B  #53,D0
            TRAP    #15                     ; READ "READSIZE" BYTES
            ; INCREASE POINTER FOR FURTHER READS
            ADDQ.L  #2,D3
            TST.W   D0                      ; IS IT EOF?
            BEQ     .READLOOP               ; NO: READ MORE
            SUBQ.L  #2,D3
            MOVE.L  D3,(FILESIZE)           ; STORE FILESIZE
            
            ; CLOSE THE FILE
            MOVE.B  #56,D0
            TRAP    #15

.END        MOVEM.L (A7)+,D0-D3/A1
            RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
