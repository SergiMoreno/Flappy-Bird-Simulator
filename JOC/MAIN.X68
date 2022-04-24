; =============================================================================
; TITLE    : EXAMPLE GAME (MAIN PROGRAM)
; AUTHOR   : SERGI MORENO PEREZ
;            ANTONI PAYERAS MUNAR
;            DANIEL SUAU VALLES
; HISTORY  : 10-OCT-2020 - CREATION
;            11-OCT-2020 - MINOR CHANGES
;            23-DEC-2020 - GAME IMPLEMENTATION
; =============================================================================
            
            ORG     $1000
            
; --- CODE INCLUDES -----------------------------------------------------------
            
            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "PLAYER.X68"            ; PLAYER MANAGEMENT
            INCLUDE "AUDIO.X68"             ; AUDIO MANAGEMENT
            INCLUDE "FILE.X68"              ; FILES MANAGMENT
            INCLUDE "WALLS.X68"             ; WALLS MANAGEMENT
            INCLUDE "CONST.X68"             ; GAME CONSTANTS
            INCLUDE "STATES.X68"            ; GAME STATES MANAGEMENT
            INCLUDE "RANDOM.X68"            ; RANDOM
            INCLUDE "AGENTLST.X68"          ; AGENTS MANAGEMENT
            INCLUDE "MAP.X68"               ; GAME BACKGROUND
            INCLUDE "DATA/IMGDATA.X68"           ; CODED GAME OVER IMAGE
            
; --- INITIALIZE --------------------------------------------------------------
            
START       JSR     SYSINIT                 ; INITIALIZE SYSTEM-RELATED STUFF
            
            ; TO DO : ADD YOUR GAME INITIALIZATION HERE          
            JSR     STAINIT
            JSR     AUDINIT                 ; AUDIO INITIALIZATION
            
; --- UPDATE ------------------------------------------------------------------
            
.LOOP       
            TRAP    #KBDTRAP                ; READ KEYBOARD
            
            ; TO DO : ADD YOUR GAME UPDATE HERE
            JSR     STAUPD
            
; --- WAIT SYNCH --------------------------------------------------------------
            
.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)
            
; --- PLOT --------------------------------------------------------------------
            
            ; TO DO : ADD YOUR GAME PLOT HERE
            CMP.B   #1,(REPAINT)
            BEQ     .LOOP
            JSR     STAPLOT
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP                   ; MAIN LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START













*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~0~
*~Tab size~4~
