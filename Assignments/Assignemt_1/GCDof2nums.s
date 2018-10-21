AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
         
	MOV R1,#12  		; R1 and R2 registers contains the numbers for which GCD have to be found out.
	MOV R2,#12
	
loop CMP R1,R2
	 BEQ stop			;If both the numbers are same then either of the one is GCD so stop the execution
	 
	 ITTEE PL
	 SUBPL R1,R1,R2		;R1-R2 if R1 is greater
	 MOVPL R3,R1
	 SUBMI R2,R2,R1		;R2-R1 if R2 is greater
	 MOVMI R3,R2
	
	 CMP R1,R2			;When both become equal then stop
	 BNE loop
		 
stop B stop 			;R3 will have the final GCD result of two numbers if they are not same.

     ENDFUNC
     END