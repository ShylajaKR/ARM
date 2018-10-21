 AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
         
	 MOV R0,#10
	 MOV R1,#0x0B
	 MOV R2,#05
	 
	 CMP R0,R1		;Compare first 2 numbers.Whichever is greater store it in R3.
	 ITE PL
	 MOVPL R3,R0 	;R0 is greater
	 MOVMI R3,R1 	;R1 is greater
	 
	 CMP R3,R2		;Compare R3 (greater of the first two) with the last number.
	 ITE PL
	 MOVPL R4,R3	;R3 is greater
	 MOVMI R4,R2 	;R2 is greater
	 
	 ;R4 has the final result	 
		   
stop B stop 

     ENDFUNC
     END