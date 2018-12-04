 AREA     appcode, CODE, READONLY
	; IMPORT printMsg
     EXPORT __main
	 ENTRY	 
__main  FUNCTION	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;DRAWCROSSWIRE
	
	;Pixel cordinate will be in R11 and R12 (column,row) which is sent to memory continuously. 
	;But data is not getting updated in memory
	
	;R9 will hold the base address of the memory where the data is stored
	LDR R9,=0x0000f000
	MOV R10, #0
	
	; Column and row coordinate is read from stack
	;LDR R1,[SP],#+4 ;R1 will have col and R2 row
	;LDR R2,[SP],#+4
	
	MOV R1,#0
	MOV R2,#0
	
	MOV R11,R1
	MOV R12,R2	
	
	; condition for coordinates being (0,0)
	CMP R1,#0
	BNE jump
	MOV R3,#01
jump CMP R2,#0
	BNE jump1
	MOV R4,#01
	
jump1 ADD R5,R3,R4
	CMP R5,#02
	BNE next
	
	;If both x and y is 0 and 0
loop STR R11, [R9, R10] 
	 ADD R10,R10,#1
	 STR R12,[R9,R10]
	 ADD R11,R11,#1
	 CMP R11,#320
	 BNE loop
	 MOV R11,R1
loop1 STR R11, [R9, R10] 
	 ADD R10,R10,#1
	 ADD R12,R12,#1
	 STR R12,[R9,R10]	
	 CMP R12,#239	 
	 BNE loop1
	 B encrypt
	 
	 ;Column is 0 and row coordinate is not 0
next CMP R3,#1
	 BNE algo
	 MOV R12,#0
loop2 STR R11, [R9, R10]  
	 ADD R10,R10,#1
	 STR R12,[R9,R10]
	 ADD R12,R12,#1
	 CMP R12,R2
	 IT LT
	 BLT loop2
	 
loop3 STR R11, [R9, R10]  
	 ADD R10,R10,#1
	 STR R12,[R9,R10]
	 ADD R11,R11,#1
	 CMP R11,#320
	 BNE loop3
	 MOV R11,#0
loop4 STR R11, [R9, R10]  
	 ADD R10,R10,#1
	 ADD R12,R12,#1
	 STR R12,[R9,R10]	
	 CMP R12,#239
	 BNE loop4
	 B encrypt
	 
	 ;row is 0 and column coordinate is not zero
algo CMP R4,#1
	 BNE algo1
	 
	 MOV R11,#0
here STR R11,[R9,R10]  
	 ADD R10,R10,#1
	 STR R12,[R9,R10]
	 ADD R11,R11,#1
	 CMP R11,#320
	 BNE here
	 
	 MOV R11,R1
here1 STR R11, [R9, R10] 
	 ADD R10,R10,#1
	 ADD R12,R12,#1
	 STR R12,[R9,R10]
	 CMP R12,#239
	 BNE here1	 
	 B encrypt
	 
	;Both x and y coordinate is not zero
algo1 MOV R12,#0
algo2 STR R11, [R9, R10]  
	 ADD R10,R10,#1
	 STR R12,[R9,R10]
	 ADD R12,R12,#1
	 CMP R12,R2
	 IT LT
	 BLT algo2
	 MOV R11,#0
	 
sjmp STR R11, [R9, R10]  
	 ADD R10,R10,#1
	 STR R12,[R9,R10]
	 ADD R11,R11,#1
	 CMP R11,#320
	 BNE sjmp
	 MOV R11,R1
sjmp1 STR R11, [R9, R10]  
	 ADD R10,R10,#1
	 ADD R12,R12,#1
	 STR R12,[R9,R10]	
	 CMP R12,#239
	 BNE sjmp1
	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	ENCRYPTION
;Input array address 0x00000000
;Output array address 0x00000005
;R7 holds the output before storing it in output array

encrypt	LDR R1,=0;            //BASE ADDRESS OF Input ARRAY
		LDR R12,= 5;                 //ARRAY SIZE
		LDR R11,= 1;                  //STORES CONSTANT 1
		LDR R10,= 0;                  //COUNTER for input array
		LDR R0,= 0;            // offset value to access elements of the input array
		LDR R9,=5;            //BASE ADDRESS OF OUTput ARRAY
		LDR R8,=0;             //OFFSET VALUE for OUTput array
		
		
loopx 	STR R11, [R1,#4];          //STORES THE VALUE OF R11 IN memory (R1+4)
		ADD R10,R10,#01;              //COUNTER INCREAMENTED
		CMP R10,R12;
		BLT loopx
		
		
		LDR R0,= 1;            ;INITIALIZATION VECTOR that is C(i-1)
LOOP	LDRB R4, [R1, R3];     ;R4=plain_text[i-1]
		EOR R7, R4, R3;       ;R7 = Ci = (Pi XOR Ci-1) WHERE R4 = Pi and R3 = C(i-1)
		ADD R3,R3,#1;
		MOV R0,R7;            ;r0 STORES C(i)
;		BL printMsg                    ;pRINTS the encoded value everytime the loop runs
		STRB R7, [R9,R8];           ;Stores the output ciphered text
		CMP R3,R12;
		BNE LOOP
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	HAMMING CODE ENCODER

	MOV R0, #0;OFFSET for output array
	LDR r6, =0x00000100;Starting address for output array
	MOV R8,#0;OFFSET for input array
	LDR R9, =0x00000005;Starting address for input array SAME AS OUTPUT BASE ADDRESS FOR ENCRYPTION MODULE
jumpx LDRB R2, [R9,R8] ;INPUT DATA
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
	BNE jumpx
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	RECEIVER PART

;	DECODING

;Data is 8 bit. According to the characteristics of Hamming code, the no. of bits that has to be added to the 
	 ;data is 4. So a total of 12 bits has been sent from the encoder. 4-parity bits C1 C2 C3 C4 8-data bits
	 ;Input should be given ulta. MSB followed by LSB
	 MOV R0,#0x00000cd7 ;RO has the encoded data.. Input
	 
	 AND R1,R0,#0x00000800 ;R1 has C1
	 AND R2,R0,#0x00000400 ;R2 has C2
	 AND R3,R0,#0x00000100 ;R3 has C3
	 AND R4,R0,#0x00000010 ;R4 has C4
	 
	 ;C1 can detect the error in the bit position which has 1 in the first position. They are 3,5,7,9,11 bit positions	 
	 AND R5,R0,#0x00000200
	 AND R6,R0,#0x00000080
	 LSL R5,R5,#2
	 LSL R6,R6,#4
	 EOR R7,R5,R6
	 AND R5,R0,#0x00000020
	 AND R6,R0,#0x00000008
	 LSL R5,R5,#6
	 LSL R6,R6,#8
	 EOR R8,R5,R6
	 EOR R9,R7,R8
	 AND R5,R0,#0x00000002
	 LSL R5,R5,#10
	 EOR R10,R9,R5
	 
	 MOV R5,#0
	 CMP R1,R10
	 BEQ jumpy
	 MOV R5,#01
	 
	 ;C2 can detect the error in the bit position which has 1 in the second position. They are 3,6,7,10,11 bit positions
jumpy AND R6,R0,#0x00000200
	  AND R7,R0,#0x00000040
	  LSL R6,R6,#1
	  LSL R7,R7,#4
	  EOR R8,R6,R7
	  AND R6,R0,#0x00000020
	  AND R7,R0,#0x00000004
	  LSL R6,R6,#5
	  LSL R7,R7,#8
	  EOR R9,R6,R7
	  EOR R10,R9,R8
	  AND R6,R0,#0x00000002
	  LSL R6,R6,#9
	  EOR R7,R6,R10
	  
	  MOV R6,#0
	  CMP R2,R7
	  BEQ jumpz
	  MOV R6,#01
	  
	  ;C3 can detect the error in the bit position which has 1 in the third position. They are 5,6,7,12 bit positions
jumpz  AND R7,R0,#0x00000080
	   AND R8,R0,#0x00000040
	   LSL R7,R7,#1
	   LSL R8,R8,#2
	   EOR R9,R7,R8
	   AND R7,R0,#0x00000020
	   AND R8,R0,#0x00000001
	   LSL R7,R7,#3
	   LSL R8,R8,#8
	   EOR R10,R7,R8
	   EOR R7,R9,R10
	   	  
	   CMP R3,R7
	   ITT EQ
	   MOVEQ R7,#0
	   BEQ jump2
	   MOV R7,#01
	   
	    ;C4 can detect the error in the bit position which has 1 in the fourth position. They are 9,10,11,12 bit positions
jump2  AND R8,R0,#0x00000008
	   AND R9,R0,#0x00000004
	   LSL R8,R8,#1
	   LSL R9,R9,#2
	   EOR R10,R8,R9
	   AND R8,R0,#0x00000002
	   AND R9,R0,#0x00000001
	   LSL R8,R8,#3
	   LSL R9,R9,#4
	   EOR R11,R8,R9
	   EOR R8,R10,R11
	   
	   MOV R9,#00
	   	  
	   CMP R4,R8
	   ITT EQ
	   MOVEQ R8,#0
	   BEQ jump3
	   MOV R8,#01
	  
	   
	   ;If C1 is erroneous take its index position
jump3  CMP R5,#1
	   ITTE EQ
	   MOVEQ R1,#1
	   ADDEQ R9,R9,#1
	   MOVNE R1,#0
	   
	   ;If C2 is erroneous
	   CMP R6,#1
	   ITTE EQ
	   MOVEQ R2,#2
	   ADDEQ R9,R9,#1
	   MOVNE R2,#0
	   
	   CMP R7,#1
	   ITTE EQ
	   MOVEQ R3,#4
	   ADDEQ R9,R9,#1
	   MOVNE R3,#0
	   
	   CMP R8,#1
	   ITTE EQ
	   MOVEQ R4,#8
	   ADDEQ R9,R9,#1
	   MOVNE R4,#0
	   
	   MOV R8,#0x00000800
	   CMP R9,#1     ;If error is only in one bit then it is neglected
	   IT GT
	   BGT loopy
	   B decrypt
	   
loopy  ADD R5,R1,R2
	   ADD R6,R3,R4
	   ADD R7,R5,R6 ;R7 has the final position where the bit is erroneous
	   
	   SUB R9,R7,#1
	   LSR R10,R8,R9 ;complement the bit position where error is found
	   EOR R1,R0,R10  ;Final result is stored in R1 (corrected one)
	   MOV R0,R1
;	   BL printMsg
	   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	DECRYPTION

;Input array 0x00020000
;output array 0x00002000

decrypt	LDR R1,=0x00020000;            //BASE ADDRESS OF Input ARRAY
		LDR R12,= 5;                 //ARRAY SIZE
		LDR R11,= 1;                  //STORES CONSTANT 1
		LDR R10,= 0;                  //COUNTER for input array THAT IS ciphered text array
		LDR R0,= 0;            // offset value to access elements of the input array
		LDR R9,=0x00002000;            //BASE ADDRESS OF OUTput ARRAY
		LDR R8,=0;             //OFFSET VALUE for OUTput array
		
		
loopb 	STR R11, [R1,#4];          //STORES THE VALUE OF R11 IN memory (R1+4)
		ADD R10,R10,#01;              //COUNTER INCREAMENTED
		CMP R10,R12;
		BLT loopb
		
		
		LDR R3,= 1;            ;INITIALIZATION VECTOR 
LOOPa	LDRB R4, [R6, R3];   ;R4=ciphered_text[i-1]
		LDRB R2, [R6, R11];   ;R2=C[i]
		EOR R7, R4, R2;       ;R7 = Pi = (Ci XOR Ci-1) WHERE R4 = Ci and R3 = C(i-1)
		ADD R3,R3,#1;
		ADD R11,R11,#1;
		MOV R0,R7;            ;r3 STORES C(i-1)
;		BL printMsg                ;prints the decoded value everytime the loop runs
		STR R7, [R9,R8];           ;Stores the previous ciphered text
		CMP R3,R12;
		BNE LOOPa
		
;;;;STORES INDIVIDUAL OUTPUT IN R7 AND COMPLETE OUTPUT IN ARRAY WITH STARTING ADDRESS R9

stop B stop 			
     ENDFUNC
     END
