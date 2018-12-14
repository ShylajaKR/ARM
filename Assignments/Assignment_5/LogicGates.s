	 AREA     appcode, CODE, READONLY
	 IMPORT printMsg
     EXPORT __main
	 ENTRY 
	 
	 ;In order to run the program choose different values for register R2
	 ;R2=0 AND gate
	 ;R2=1 OR gate
	 ;R2=2 NOT gate ;Complement of Input X1 present in register S0
	 ;R2=3 NAND gate
	 ;R2=4 NOR gate
	 ;R2=5 XOR gate
	 ;R2=6 XNOR gate
	 
Sigma PROC	
	;e^x is in "S24" register.

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
	 
	 VCMP.F32 S28,S31
	 VMRS.F32 APSR_nzcv,FPSCR
	 ITE GT
	 MOVGT R0,#1
	 MOVLE R0,#0
	 BX LR
	 ENDP
		 
__main  FUNCTION
	 ; x1 x2 x3 are the logical inputs and x4=1 bias
	 MOV R10,#8
	 MOV R9,#0 	;To run the logic 8 times for input combinations from 000 to 111
	 
back CMP R9,#4
	 ITE GE
	 VLDRGE.F32 S2,=1  ;input 3(MSB)
	 VLDRLT.F32 S2,=0  ;input 3(MSB)
	 VCMP.F32 S2,#0.0
	 VMRS.F32 APSR_nzcv,FPSCR
	 ITE EQ
	 MOVEQ R0,#0
	 MOVNE R0,#1	
     BL printMsg

	 AND R8,R9,#0x00000002
	 CMP R8,#0x00000002
	 ITE EQ
	 VLDREQ.F32 S1,=1  ;input 2
	 VLDRNE.F32 S1,=0  ;input 2
	 VCMP.F32 S1,#0.0
	 VMRS.F32 APSR_nzcv,FPSCR
	 ITE EQ
	 MOVEQ R0,#0
	 MOVNE R0,#1
     BL printMsg

	 AND R7,R9,#0x00000001
	 CMP R7,#0x00000001
	 ITE EQ
	 VLDREQ.F32 S0,=1  ;input 1
	 VLDRNE.F32 S0,=0  ;input 1(LSB)
	 VCMP.F32 S0,#0.0
	 VMRS.F32 APSR_nzcv,FPSCR
	 ITE EQ
	 MOVEQ R0,#0
	 MOVNE R0,#1
	 BL printMsg
	 
	 VMOV.F32 S3, #1 ; Bias input which is always 1
	 VMOV.F32 S31,#0.5
	 
	 
	 ;This copies the address of table to R1
	 ADR.W R1,Branchtable_byte
	 MOV R2,#0
	 
	 
	 TBB[R1,R2] ;Point to row 2 in the table pointed by R1
;Equivalent to case statements 
;w1 w2 w3 and w4..different for all the 7 gates

ANDgate	
	 VLDR.F32 S4, =0.2
	 VLDR.F32 S5, =0.2
	 VLDR.F32 S6, =0.2
	 VLDR.F32 S7, =-0.5
	 B cacl_Z

ORgate
	 VLDR.F32 S4, =0.2
	 VLDR.F32 S5, =0.2
	 VLDR.F32 S6, =0.2
	 VLDR.F32 S7, =-0.1
	 B cacl_Z
	 
NOTgate
	 VLDR.F32 S4, =-0.7
	 VLDR.F32 S5, =0
	 VLDR.F32 S6, =0
	 VLDR.F32 S7, =0.1
	 B cacl_Z
	 
NANDgate
	 VLDR.F32 S4, =-0.6
	 VLDR.F32 S5, =-0.6
	 VLDR.F32 S6, =-0.6
	 VLDR.F32 S7, =1.7
	 B cacl_Z
	 
NORgate
	 VLDR.F32 S4, =-0.5
	 VLDR.F32 S5, =-0.7
	 VLDR.F32 S6, =-0.7
	 VLDR.F32 S7, =0.1
	 B cacl_Z
	 
XORgate
	 VLDR.F32 S4, =-15
	 VLDR.F32 S5, =21
	 VLDR.F32 S6, =21
	 VLDR.F32 S7, =-10
	 B cacl_Z
	 
XNORgate 
	 VLDR.F32 S4, =-15
	 VLDR.F32 S5, =-15
	 VLDR.F32 S6, =-15
	 VLDR.F32 S7, =10
	 B cacl_Z
	 
;Table which holds the address of all the case statements
Branchtable_byte		  
    DCB   0						;0 points to AND logic function  
    DCB   ((ORgate-ANDgate)/2)	;This is the offset for OR function and similarly for all other gates
	DCB   ((NOTgate-ANDgate)/2)	
	DCB   ((NANDgate-ANDgate)/2)
	DCB   ((NORgate-ANDgate)/2)
	DCB   ((XORgate-ANDgate)/2)
	DCB   ((XNORgate-ANDgate)/2)    
	 
;Weights are used and Z is calculated in this section of the code
cacl_Z	 VMUL.F32 S8, S0,S4  ;x1*w1
		 VMUL.F32 S9, S1,S5  ;x2*w2
		 VMUL.F32 S10, S2,S6 ;x3*w3
		 VMUL.F32 S11, S3,S7 ;x4*w4
	 
		 VADD.F32 S12, S8, S9   ;(x1*w1)+(x2*w2)
		 VADD.F32 S13, S10, S11 ;(x3*w3)+(x4*w4)
	 
		 VADD.F32 S20, S12, S13 ; Z is in S20 register which is sent as input to sigmoid subroutine
	 
		 ; call the sigmoid subroutine from the main function
		 BL Sigma
		 BL printMsg	 ; Refer to ARM Procedure calling standards.
		 
		 ADD R9,R9,#1
		 CMP R9,R10
		 IT NE
		 BNE back ; If all the 8 input combinations are not computed then go back.
	 
stop B stop ; stop program
	 ENDFUNC
	 END