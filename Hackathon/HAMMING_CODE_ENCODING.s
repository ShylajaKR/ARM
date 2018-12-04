     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
		 
__main  FUNCTION
	
	MOV R0, #0;OFFSET for output array
	LDR r6, =0x00000100;Starting address for output array
	MOV R8,#0;OFFSET for input array
	LDR R9, =0x00000000;Starting address for input array SAME AS OUTPUT BASE ADDRESS FOR ENCRYPTION MODULE
jump LDRB R2, [R9,R8] ;INPUT DATA
	AND	r4, R2, #0x1		; Single out data[0]
	MOV	r5, r4, LSL #2		; Push it to the index 2 according to the rule of hamming code
	AND	r4, R2, #0xE		; Single out data[1],[2],and [3]
	ORR	r5, r5, r4, LSL #3	; Push them to [4],[5] and [6] respectively
	AND	r4, R2, #0xF0		; Do the same for the last four data bits 
	ORR	r5, r5, r4, LSL #4	
	EOR	r4, r5, r5, LSR #2	; Generating parity for check bit 0
	EOR	r4, r4, r4, LSR #5	; XOR ing [2],[5] and [8] and putting it back to the dummy register r4
	EOR	r4, r4, r4, LSR #8	
	AND	r4, r4, #0x1		; Singling out the check bit 0
	ORR	r5, r5, r4		; Putting the check bit into its place by OR operation
	EOR	r4, r5, r5, LSR #1	; Generating parity for check bit 1
	EOR	r4, r4, r4, LSR #4	;XOR ing [2],[4],[8] and [9]
	EOR	r4, r4, r4, LSR #8	
	AND	r4, r4, #0x2 ; Singling out check bit 1
	ORR	r5, r5, r4	; Combining to the result
	EOR	r4, r5, r5, LSR #1	; Generateing check bit 3
	EOR	r4, r4, r4, LSR #2	; XOR ing [4],[5],[6] and [11]
	EOR	r4, r4, r4, LSR #8	
	AND	r4, r4, #0x8 ;Singling out check bit 3
	ORR	r5, r5, r4	;combining it to the result	
	EOR	r4, r5, r5, LSR #1	; Generating check bit 7
	EOR	r4, r4, r4, LSR #2	; XOR ing data bits [8],[9],[10] and [11]
	EOR	r4, r4, r4, LSR #4	
	
	AND	r4, r4, #0x80 ; Singling out the check bit 7
	ORR	r5, r5, r4 ; Combining to the result
	STRB r5, [r6,R0] ;INPUT DATA
;Final result is in the register R5	
	ADD R8,R8,#1
	ADD R0,R0,#1
	CMP R8,#10
	BNE jump
	 
stop B stop ; stop program
	 ENDFUNC
	 
	 END