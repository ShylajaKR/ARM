     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
         
	 MOV R0,#0 ;fib(0)=0
	 MOV R1,#1 ;fib(1)=1
	 
	 MOV R2,#5 ;no. of items to be displayed	 
	 
	 CMP R2,#02 ; If the numbers required are greater than 2 then only logic is required.
	 IT LE		;otherwise R0 and R1 already has first two numbers..	 
	 BLE stop	
	 
	 MOV R4,#01
loop ADD R3,R0,R1  ;R3 will have the series of fibbonacci numbers
	 ADD R4,R3,R4  ;R4 will have the sum of all the fibbonacci numbers
	 MOV R0,R1
	 MOV R1,R3
	 SUBS R2,R2,#01
	 CMP R2,#02
	 BNE loop
		 
stop B stop 			

     ENDFUNC
     END