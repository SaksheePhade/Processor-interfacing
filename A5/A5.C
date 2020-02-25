
#include <stdio.h>
#include <dos.h>

/* deletes file name; returns 0 on success, nonzero on failure */
int delete_file(char near *filename)
{
   union REGS regs;
   int ret;
   regs.h.ah = 0x41;
  // regs.x.cflag = 0;
   /* delete file */
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);
   /* if carry flag is set, there was an error */
   return(regs.x.cflag ? ret : 0);
}

int create_file(char near *filename)
{
   union REGS regs;
   int ret;
  // regs.x.cflag = 0;
   regs.h.ah = 0X3C;
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);
   return(regs.x.cflag ? ret : 0);
}
int create_dir(char near *filename)
{
   union REGS regs;
   int ret;
   regs.x.cflag = 0;
   regs.h.ah = 0x39;
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);
   /* if carry flag is set, there was an error */
   return(regs.x.cflag ? ret : 0);
}


int delete_dir(char near *filename)
{
   union REGS regs;
   int ret;
   regs.x.cflag = 0;
   regs.h.ah = 0x3A;
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);
   /* if carry flag is set, there was an error */
   return(regs.x.cflag ? ret : 0);
}

int open_file(char near *filename)
{
   union REGS regs;
   int ret,fhandle;
   regs.x.cflag = 0;
   regs.h.ah = 0x3D;
   regs.h.al = 2;
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);
   fhandle = regs.x.ax;
   printf("\n\tFile handle is : %d ",fhandle);
  // regs.h.ah = 0x40;
 //  regs.x.bx = fhandle;
   /* if carry flag is set, there was an error */
   return(regs.x.cflag ? ret : 0);
}

int read_file(char near *source)
{
   union REGS regs;
   int ret,fhandle;
   struct SREGS sregs;
   char buffer[100];

   regs.x.cflag = 0;
   regs.h.ah = 0x3D;
   regs.h.al = 2;
   regs.x.dx = (unsigned) source;
   intdos(&regs, &regs);			//opened file
   fhandle = regs.x.ax;

   regs.h.ah = 0x3F;                      /* delete file */
   regs.x.dx = FP_OFF(buffer);
   sregs.ds = FP_SEG(buffer);
   regs.x.bx = fhandle;
   regs.x.cx = 0xFFFF;
   ret = intdosx(&regs, &regs, &sregs);

   printf("\n\tRead the file : %s",buffer);


   /* if carry flag is set, there was an error */
	return(regs.x.cflag ? ret : 0);
}


int copy_file(char near *source,char near *dest)
{
   union REGS regs;
   int ret,fhandle1,fhandle2;
   struct SREGS sregs;
   char buffer[100],buffer2[100];

   regs.x.cflag = 0;
   regs.h.ah = 0x3D;
   regs.h.al = 2;
   regs.x.dx = (unsigned) source;
   intdos(&regs, &regs);
   fhandle1 = regs.x.ax;//opened source

   regs.x.cflag = 0;
   regs.h.ah = 0x3D;
   regs.h.al = 2;
   regs.x.dx = (unsigned) dest;
   intdos(&regs, &regs);
   fhandle2 = regs.x.ax;//opened destination

   regs.h.ah = 0x3F;
   regs.x.dx = FP_OFF(buffer);
   sregs.ds = FP_SEG(buffer);
   regs.x.bx = fhandle1;
   regs.x.cx = 0xFFFF;
   ret = intdosx(&regs, &regs, &sregs);//read first file

   printf("\n\tRead the source file : %s",buffer);

   regs.h.ah = 0x40;
   regs.x.dx = FP_OFF(buffer);
   sregs.ds = FP_SEG(buffer);
   regs.x.bx = fhandle2;
   regs.x.cx = 0xFFFF;
   ret = intdosx(&regs, &regs, &sregs);//write into second file

   regs.h.ah = 0x3F;
   regs.x.dx = FP_OFF(buffer2);
   sregs.ds = FP_SEG(buffer2);
   regs.x.bx = fhandle2;
   regs.x.cx = 0xFFFF;
   ret = intdosx(&regs, &regs, &sregs);

   printf("\n\tRead the destination file : %s",buffer);//read second file

   /* if carry flag is set, there was an error */
	return(regs.x.cflag ? ret : 0);
}


int close_file(char near *filename)
{
   union REGS regs;
   int ret,fhandle;
   regs.x.cflag = 0;
   regs.h.ah = 0x41;
   regs.x.dx = (unsigned) filename;
   ret = intdos(&regs, &regs);
   fhandle = regs.x.ax;
   printf("\n\tFile handle is : %d ",fhandle);
   /* if carry flag is set, there was an error */
   return(regs.x.cflag ? ret : 0);
}


int main(void)
{
   int err,c,choice,dir,set,open,close,w;

   do{

   printf("\n\tMENU:\n");
   printf("\n\t1.Create a file.\n\t2.Delete a file.\n\t"
		   "3.Create directory.\n\t4.Delete directory\n\t"
		   "5.Open file.\n\t6.Close opened file.\n\t"
		   "7.Copy file.\n\t8.Exit\n\t"
		   "Enter your choice: ");
   scanf("%d",&choice);
   switch(choice)
   {
	 case 1 : c = create_file("newfile.txt");
			  if(!c)
				printf("\tFile is created.\n");
			  else
				printf("\tNot created.\n");
			  break;

	 case 2 : err = delete_file("newfile.txt");
			  if (!err)
				 printf("\tAble to delete given file.\n");
			  else
				 printf("\tNot Able to delete.\n");
			  break;

	 case 3 : dir = create_dir("Sakshee");
			  if(!dir)
				 printf("\n\tCreated.");
			  else
				 printf("\n\tNot created.");
			  break;

	 case 4 : set = delete_dir("Sakshee");
			  if(!set)
				 printf("\n\tDeleted directory.");
			  else
				 printf("\n\tNot deleted directory.");

			  break;

	 case 5 : open = open_file("23244.txt");
			  if(!open)
				 printf("\n\tOpened the file.");
			  else
				 printf("\n\tNot able to open.");
			  break;

	 case 6 : close = close_file("23244.txt");
			  if(!close)
				 printf("\n\tClosed the file.");
			  else
				 printf("\n\tNot able to close.");
			  break;

	 case 7 :   create_file("second.txt");
				w = copy_file("23244.txt","second.txt");
			  if(!w)
				 printf("\n\tSuccesful.\nSource file is copied into destination file");
			  else
				 printf("\n\tUnsuccessful.");
			  break;

	 case 8 : return 0;
   }

   }while(1);
}

