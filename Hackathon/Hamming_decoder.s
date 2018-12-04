     AREA     appcode, CODE, READONLY
	 IMPORT printMsg
     EXPORT __main
	 ENTRY 
		 
__main  FUNCTION
	
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
	 BEQ jump
	 MOV R5,#01
	 
	 ;C2 can detect the error in the bit position which has 1 in the second position. They are 3,6,7,10,11 bit positions
jump  AND R6,R0,#0x00000200
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
	  BEQ jump1
	  MOV R6,#01
	  
	  ;C3 can detect the error in the bit position which has 1 in the third position. They are 5,6,7,12 bit positions
jump1  AND R7,R0,#0x00000080
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
	   BGT loop
	   B stop
	   
loop   ADD R5,R1,R2
	   ADD R6,R3,R4
	   ADD R7,R5,R6 ;R7 has the final position where the bit is erroneous
	   
	   SUB R9,R7,#1
	   LSR R10,R8,R9 ;complement the bit position where error is found
	   EOR R1,R0,R10  ;Final result is stored in R1 (corrected one)
	   MOV R0,R1
	   BL printMsg
 
stop B stop ; stop program
	 ENDFUNC	 
	 END