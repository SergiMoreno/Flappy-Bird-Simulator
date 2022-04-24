; =============================================================================
; GAME VARIABLES
; =============================================================================

; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; CURRENT GAME STATE
STANEXT     DS.W    1                       ; NEXT GAME STATE

; --- GENERAL PURPOSE VARIABLES -----------------------------------------------

GENFRMCT    DS.B    1                       ; FRAME COUNTER
            DS.W    0
REPAINT     DS.B    1                       ; CHECK TO REPAINT IMATGE
            DS.W    0

; --- PLAYER RELATED VARIABLES ------------------------------------------------

PLRPOSY     DS.L    1                       ; PLAYER Y POSITION (PIX, FIX. PNT)

PLRYSPD     DS.L    1                       ; PLAYER DOWN SPEED

; --- PLAY STATE PURPOSE VARIABLES --------------------------------------------

ENDGAME     DS.B    1                       ; FINALIZES GAME IF ENDGAME=1 
SCORE                                       ; SCORE UNITS
SCOREDC     DS.B    1                       
SCOREUN     DS.B    1                       
            DS.W    0

; --- FILE RELATED VARIABLES --------------------------------------------------

FILEXIST    DS.B    1                       ; FILEXIT=1 IF FILE EXISTS
            DS.W    0
FILESIZE    DS.L    1                       ; SIZE OF FILE
TOREAD      DS.B    100                     ; BYTES READEN FROM FILE
            DS.W    0

; --- MOUSE RELATED VARIABLES -------------------------------------------------
            
MSECLK      DS.B    1                       ; MOUSE UP CLICKED STATE = 1
            DS.W    0
            
; --- RANDOM NUMBER GENERATOR VARIABLES ---------------------------------------

RNDINDEX    DS.B    1                       ; RANDOM INDEX
            DS.W    0









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
