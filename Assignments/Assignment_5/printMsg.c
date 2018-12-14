#include "TM4C123GH6PM.h"
void printMsg(const int a)
{
	 char Msg[100];
	 char *ptr;
	 static int count=0;
	 static int init=0;
	
	 if(init==0)
	 {
		 sprintf(Msg,"X3\tX2\tX1\tOutput\n");
		 ptr = Msg ;
			while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
		}
			init=init+1;		 
	 }	
	 
	 sprintf(Msg, "%x\t", a);	 
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 
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
	 }
}

