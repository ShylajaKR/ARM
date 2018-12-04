 AREA     appcode, CODE, READONLY
	 IMPORT printMsg
     EXPORT __main
	 ENTRY	 
__main  FUNCTION		 		
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
	 MOV R0,R11
	 BL printMsg
	 ADD R10,R10,#1
	 ADD R12,R12,#1
	 STR R12,[R9,R10]	
	 MOV R0,R12
	 BL printMsg
	 CMP R12,#239	 
	 BNE loop1
	 B stop
	 
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
	 B stop
	 
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
	 B stop
	 
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

stop B stop 			
     ENDFUNC
     END