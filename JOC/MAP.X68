; =============================================================================
; MAP MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
MAPPLOT
; DRAW MAPPLOT
; INPUT    - NONE
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
    
    MOVEM.L D0-D4,-(A7)
    
    ; --- SET COLORS ---
    MOVE.B  #80,D0
    MOVE.L  #BLACK,D1
    TRAP    #15
    MOVE.B  #81,D0
    MOVE.L  #BLUE,D1
    TRAP    #15

    ; --- DRAW BLUE BACKGROUND SKY ---
    MOVE.W  #0,D1
    MOVE.W  #0,D2
    MOVE.W  #640,D3
    MOVE.W  #480,D4
    MOVE.B  #87,D0
    TRAP    #15

    ; --- SET COLORS ---
    MOVE.B  #80,D0
    MOVE.L  #WHITE,D1
    TRAP    #15
    MOVE.B  #81,D0
    MOVE.L  #WHITE,D1
    TRAP    #15

    ; --- DRAW FIRST CLOUD ---  
    MOVE.B  #88,D0
    MOVE.W  #50,D1
    MOVE.W  #60,D2
    MOVE.W  #130,D3
    MOVE.W  #140,D4
    TRAP    #15

    MOVE.W  #100,D1
    MOVE.W  #80,D2
    MOVE.W  #160,D3
    MOVE.W  #130,D4
    TRAP    #15

    MOVE.W  #140,D1
    MOVE.W  #65,D2
    MOVE.W  #230,D3
    MOVE.W  #145,D4
    TRAP    #15
    
    MOVE.W  #90,D1
    MOVE.W  #40,D2
    MOVE.W  #170,D3
    MOVE.W  #100,D4
    TRAP    #15

    ; --- DRAW SECOND CLOUD ---
    MOVE.W  #340,D1
    MOVE.W  #100,D2
    MOVE.W  #430,D3
    MOVE.W  #180,D4
    TRAP    #15

    MOVE.W  #400,D1
    MOVE.W  #120,D2
    MOVE.W  #460,D3
    MOVE.W  #170,D4
    TRAP    #15

    MOVE.W  #440,D1
    MOVE.W  #105,D2
    MOVE.W  #520,D3
    MOVE.W  #175,D4
    TRAP    #15
    
    MOVE.W  #390,D1
    MOVE.W  #85,D2
    MOVE.W  #480,D3
    MOVE.W  #140,D4
    TRAP    #15

    MOVEM.L (A7)+,D0-D4

    RTS







*~Font name~Fixedsys~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
