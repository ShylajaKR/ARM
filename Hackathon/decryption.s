	AREA	Decryption, CODE, READONLY
	export __main
	ENTRY
__main  function
	
		LDR R1,=0;            //BASE ADDRESS OF Input ARRAY
		LDR R12,= 5;                 //ARRAY SIZE
		LDR R11,= 1;                  //STORES CONSTANT 1
		LDR R10,= 0;                  //COUNTER for input array THAT IS ciphered text array
		LDR R0,= 0;            // offset value to access elements of the input array
		LDR R9,=5;            //BASE ADDRESS OF OUTput ARRAY
		LDR R8,=0;             //OFFSET VALUE for OUTput array
		
		
loop1 	STR R11, [R1,#4];          //STORES THE VALUE OF R11 IN memory (R1+4)
		ADD R10,R10,#01;              //COUNTER INCREAMENTED
		CMP R10,R12;
		BLT loop1
		
		
		LDR R3,= 1;            ;INITIALIZATION VECTOR 
LOOP	LDRB R4, [R6, R3];   ;R4=ciphered_text[i-1]
		LDRB R2, [R6, R11];   ;R2=C[i]
		EOR R7, R4, R2;       ;R7 = Pi = (Ci XOR Ci-1) WHERE R4 = Ci and R3 = C(i-1)
		ADD R3,R3,#1;
		ADD R11,R11,#1;
		MOV R0,R7;            ;r3 STORES C(i-1)
		BL printMsg                ;prints the decoded value everytime the loop runs
		STR R7, [R9,R8];           ;Stores the previous ciphered text
		CMP R3,R12;
		BNE LOOP
		
;;;;STORES INDIVIDUAL OUTPUT IN R7 AND COMPLETE OUTPUT IN ARRAY WITH STARTING ADDRESS R9
	
stop 	B  stop ; stop program
		endfunc
		end