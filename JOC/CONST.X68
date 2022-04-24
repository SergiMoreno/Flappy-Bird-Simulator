; =============================================================================
; GAME CONSTANTS
; =============================================================================

; --- STATES RELATED CONSTANTS ------------------------------------------------
STANONE     EQU     -1
STAINTRO    EQU     0
STAPLAY     EQU     1
STAOVER     EQU     2
STASCO      EQU     3

; --- PLAYER RELATED CONSTANTS ------------------------------------------------
PLRYINI     EQU     100                     ; INITIAL POSITION (Y COORDINATE)
PLRPOSX     EQU     SCRHEIGH/6              ; POSITION (X COORDINATE)
PLRVINIT    EQU     $FFFA0000               ; JUMPING INITIAL SPEED
PLRACCY     EQU     $00008000               ; GRAVITY ACCELERATION
PLRRAD      EQU     16                      ; RADIUS

; --- WALL RELATED CONSTANTS --------------------------------------------------
WALLID      EQU     1
WALLWDH     EQU     80                      ; WALL WIDTH
WALLSPC     EQU     202                     ; DISTANCE TO GENERATE ANOTHER WALL
WALLSPD     EQU     4                       ; WALL SPEED
WALLHLE     EQU     120                     ; WALL HOLE
WALLDEC     EQU     20                      ; WALL DECORATION
WALLSCR     EQU     94                      ; LOCATION WALL INCREMENT SCORE

; --- COLORS RELATED CONSTANTS ------------------------------------------------
WHITE       EQU     $00FFFFFF               ; WHITE COLOR
BLACK       EQU     $00000000               ; BLACK COLOR
RED         EQU     $000000FF               ; RED COLOR
YELLOW      EQU     $0000FFFF               ; YELLOW COLOR
GREEN       EQU     $0000FF00               ; GREEN COLOR
BLUE        EQU     $00FACE87               ; BLUE COLOR
GREY        EQU     $00F8F8F8               ; GREY COLOR

; --- INTRO SQUARES SIZE ------------------------------------------------------
STRTLX      EQU     200
STRTUY      EQU     265
STRTRX      EQU     295
STRTDY      EQU     295

INFOLX      EQU     360
INFOUY      EQU     265
INFORX      EQU     460
INFODY      EQU     295

; --- FILES NAME --------------------------------------------------------------
FITX        DC.B    'HEADER',0
NAME        DC.B    'SCORES',0
            DS.W    0

; --- AUDIO RELATED CONSTANTS -------------------------------------------------
AUDMU1ID    EQU     0                       ; ID OF GAME INTRO MUSIC
AUDMU2ID    EQU     1                       ; ID OF GAME PLAY MUSIC
AUDMU3ID    EQU     2                       ; ID OF VICTORY MUSIC
AUDSCOID    EQU     3                       ; ID OF SCORE SOUND
AUDCRUID    EQU     4                       ; ID OF CRUSH SOUND
AUDENDID    EQU     $FF                     ; ID TO STOP ALL SOUNDS
AUDMSKLP    EQU     $80                     ; LOOP AUDIO MASK
AUDMSKNL    EQU     $00                     ; NO LOOP AUDIO MASK








*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
