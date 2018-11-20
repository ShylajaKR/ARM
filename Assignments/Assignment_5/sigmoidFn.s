     AREA     appcode, CODE, READONLY
	 IMPORT printMsg
     EXPORT __main
	 ENTRY 
	 
Sigma PROC	
	;e^x is being computed for x=7 and n=12.. Final answer is in "S24" register.
	;Hex value = 0x448560C7 Floating point value = 1067.0242919921875 and it matches the theoretical value.

	VMOV.F32 S20, #-2	;S20 contains the value of x in e^x
	VMOV.F32 S21, #25	;S21 contains the number of terms (n) for which the e^x expansion is being done
	VMOV.F32 S22, #1	;S22 is the count which is incremented until S21 value is reached. 
	VMOV.F32 S23, #1	;S23 holds the temporary result (x^n)/n factorial
	VMOV.F32 S24, #1	;S24 holds the final result of e^x of n terms
	VMOV.F32 S26, #1	;S26 has 1 in order to increment the value of S22 
Loop 
	 VCMP.F32 S21, S22; S21 has no.of terms.S22 is compared with S21 to check whether n computations has been done
	 VMRS.F32 APSR_nzcv,FPSCR; FPU affects FPSCR which is status register for floating point unit. In order to check  
	 ;whether S22 has reached S21 we have to make use of flags. Therefore FPSCR has been copied into APSR status flag
	 ;register
	 BLT sigmoid			;If S22 has become greater than S21 then branch to stop and stop the execution
	 VDIV.F32 S25, S20, S22;  S20 has x and S22 has the count. So x/1,x/2 and so on till x/n is being done and stored in S25
	 VMUL.F32 S23, S23, S25; Initially S23 has 1 so 1*(x/1) is multiplied and stored back to S23. Next iteration (x/1)*(x/2) 
	 ;is computed nothing but (x^2)/2!.. And so on till (x^n)/n!
	 VADD.F32 S24, S24, S23; S24 initially contains 1. So now 1+(x/1!) is being added and finally 1+(x/1!)+(x^2/2!)+..(x^n/n!)
	 VADD.F32 S22, S22, S26; Here S22 is incremented by 1 S22=S22+1
	 B Loop; Unconditional branch back to loop until n terms are not computed.
	 
	 ;Computing sigmoid function
sigmoid
	 VADD.F32 S27,S24,S26
	 VDIV.F32 S28,S24,S27 ;S28 will hold the sigmoid value.
	 
	 VMOV.F32 R0,S28
	 BX LR
	 ENDP
		 
__main  FUNCTION
	 ; call the sigmoid subroutine from the main function
	 BL Sigma
	 BL printMsg	 ; Refer to ARM Procedure calling standards.
	 
stop B stop ; stop program
	 ENDFUNC
	 END