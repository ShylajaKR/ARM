#include "TM4C123GH6PM.h"
void printMsg(const int a)
{
	 char Msg[100];
	 char *ptr;
	 static int count=0;
	 static int init=0;
	 static int disp=0;	 
	 static int head=0;
	
	 if(disp==0){
		 
	 switch(init){
		 
		 case 0:{
		 sprintf(Msg,"Logic AND gate\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
		 sprintf(Msg,"X3\tX2\tX1\tOutput\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
			break;
	 }	 
		 
	   case 1:{
		 sprintf(Msg,"Logic OR gate\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
		 sprintf(Msg,"X3\tX2\tX1\tOutput\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
			break;
	 }	 
		 
	 case 2:{
		 sprintf(Msg,"Logic NOT gate\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
		 sprintf(Msg,"X3\tX2\tX1\tOutput\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
			break;
	 }	 
	 
	 case 3:{
		 sprintf(Msg,"Logic NAND gate\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
		 sprintf(Msg,"X3\tX2\tX1\tOutput\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
			break;
	 }	 
	 
	 case 4:{
		 sprintf(Msg,"Logic NOR gate\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
		 sprintf(Msg,"X3\tX2\tX1\tOutput\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
			break;
	 }	 		
	 
	 case 5:{
		 sprintf(Msg,"Logic XOR gate\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
		 sprintf(Msg,"X3\tX2\tX1\tOutput\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
			break;
	 }	 
	 
	 case 6:{
		 sprintf(Msg,"Logic XNOR gate\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
		 sprintf(Msg,"X3\tX2\tX1\tOutput\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		  }
			break;
	 }	 
	 
  }	//switch
} //if
	 
	 sprintf(Msg, "%x\t", a);	 
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 disp=1;
	 count=count+1;
	 
	 if(count==4)
	 {
		 sprintf(Msg, "\n");
		 count=0;
		  ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
			head=head+1;
			if(head==8)
			{
				disp=0;
				head=0;
				init=init+1;
			}			
	 }
}

