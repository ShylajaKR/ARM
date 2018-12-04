	AREA	ENcryption, CODE, READONLY
	IMPORT printMsg
	export __main
	ENTRY
__main  function
	
		LDR R1,=0;            //BASE ADDRESS OF Input ARRAY
		LDR R12,= 5;                 //ARRAY SIZE
		LDR R11,= 1;                  //STORES CONSTANT 1
		LDR R10,= 0;                  //COUNTER for input array
		LDR R0,= 0;            // offset value to access elements of the input array
		LDR R9,=5;            //BASE ADDRESS OF OUTput ARRAY
		LDR R8,=0;             //OFFSET VALUE for OUTput array
		
		
loop1 	STR R11, [R1,#4];          //STORES THE VALUE OF R11 IN memory (R1+4)
		ADD R10,R10,#01;              //COUNTER INCREAMENTED
		CMP R10,R12;
		BLT loop1
		
		
		LDR R0,= 1;            ;INITIALIZATION VECTOR that is C(i-1)
LOOP	LDRB R4, [R1, R3];     ;R4=plain_text[i-1]
		EOR R7, R4, R3;       ;R7 = Ci = (Pi XOR Ci-1) WHERE R4 = Pi and R3 = C(i-1)
		ADD R3,R3,#1;
		MOV R0,R7;            ;r0 STORES C(i)
		BL printMsg                    ;pRINTS the encoded value everytime the loop runs
		STRB R7, [R9,R8];           ;Stores the output ciphered text
		CMP R3,R12;
		BNE LOOP
		
		
	
stop 	B  stop ; stop program
		endfunc
		end