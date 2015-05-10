
obj/user/lsfd:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 b7 01 00 00       	call   8001e8 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  80003a:	c7 04 24 60 29 80 00 	movl   $0x802960,(%esp)
  800041:	e8 3a 03 00 00       	call   800380 <cprintf>
	exit();
  800046:	e8 e5 01 00 00       	call   800230 <exit>
}
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	int i, usefprint = 0;
  800056:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	struct Stat st;

	ARGBEGIN{
  80005d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800061:	75 06                	jne    800069 <umain+0x1c>
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	89 45 0c             	mov    %eax,0xc(%ebp)
  800069:	a1 44 50 80 00       	mov    0x805044,%eax
  80006e:	85 c0                	test   %eax,%eax
  800070:	75 0a                	jne    80007c <umain+0x2f>
  800072:	8b 45 0c             	mov    0xc(%ebp),%eax
  800075:	8b 00                	mov    (%eax),%eax
  800077:	a3 44 50 80 00       	mov    %eax,0x805044
  80007c:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
  800080:	8b 45 08             	mov    0x8(%ebp),%eax
  800083:	83 e8 01             	sub    $0x1,%eax
  800086:	89 45 08             	mov    %eax,0x8(%ebp)
  800089:	e9 83 00 00 00       	jmp    800111 <umain+0xc4>
  80008e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800091:	8b 00                	mov    (%eax),%eax
  800093:	83 c0 01             	add    $0x1,%eax
  800096:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800099:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009c:	0f b6 00             	movzbl (%eax),%eax
  80009f:	3c 2d                	cmp    $0x2d,%al
  8000a1:	75 1c                	jne    8000bf <umain+0x72>
  8000a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a6:	83 c0 01             	add    $0x1,%eax
  8000a9:	0f b6 00             	movzbl (%eax),%eax
  8000ac:	84 c0                	test   %al,%al
  8000ae:	75 0f                	jne    8000bf <umain+0x72>
  8000b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b3:	83 e8 01             	sub    $0x1,%eax
  8000b6:	89 45 08             	mov    %eax,0x8(%ebp)
  8000b9:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
  8000bd:	eb 7a                	jmp    800139 <umain+0xec>
  8000bf:	c6 45 eb 00          	movb   $0x0,-0x15(%ebp)
  8000c3:	eb 16                	jmp    8000db <umain+0x8e>
  8000c5:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  8000c9:	83 f8 31             	cmp    $0x31,%eax
  8000cc:	74 05                	je     8000d3 <umain+0x86>
	default:
		usage();
  8000ce:	e8 61 ff ff ff       	call   800034 <usage>
	case '1':
		usefprint = 1;
  8000d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		break;
  8000da:	90                   	nop
umain(int argc, char **argv)
{
	int i, usefprint = 0;
	struct Stat st;

	ARGBEGIN{
  8000db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000de:	0f b6 00             	movzbl (%eax),%eax
  8000e1:	84 c0                	test   %al,%al
  8000e3:	74 18                	je     8000fd <umain+0xb0>
  8000e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e8:	0f b6 00             	movzbl (%eax),%eax
  8000eb:	88 45 eb             	mov    %al,-0x15(%ebp)
  8000ee:	80 7d eb 00          	cmpb   $0x0,-0x15(%ebp)
  8000f2:	0f 95 c0             	setne  %al
  8000f5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  8000f9:	84 c0                	test   %al,%al
  8000fb:	75 c8                	jne    8000c5 <umain+0x78>
	default:
		usage();
	case '1':
		usefprint = 1;
		break;
	}ARGEND
  8000fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
umain(int argc, char **argv)
{
	int i, usefprint = 0;
	struct Stat st;

	ARGBEGIN{
  800104:	8b 45 08             	mov    0x8(%ebp),%eax
  800107:	83 e8 01             	sub    $0x1,%eax
  80010a:	89 45 08             	mov    %eax,0x8(%ebp)
  80010d:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
  800111:	8b 45 0c             	mov    0xc(%ebp),%eax
  800114:	8b 00                	mov    (%eax),%eax
  800116:	85 c0                	test   %eax,%eax
  800118:	74 1f                	je     800139 <umain+0xec>
  80011a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011d:	8b 00                	mov    (%eax),%eax
  80011f:	0f b6 00             	movzbl (%eax),%eax
  800122:	3c 2d                	cmp    $0x2d,%al
  800124:	75 13                	jne    800139 <umain+0xec>
  800126:	8b 45 0c             	mov    0xc(%ebp),%eax
  800129:	8b 00                	mov    (%eax),%eax
  80012b:	83 c0 01             	add    $0x1,%eax
  80012e:	0f b6 00             	movzbl (%eax),%eax
  800131:	84 c0                	test   %al,%al
  800133:	0f 85 55 ff ff ff    	jne    80008e <umain+0x41>
	case '1':
		usefprint = 1;
		break;
	}ARGEND

	for (i = 0; i < 32; i++)
  800139:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800140:	e9 97 00 00 00       	jmp    8001dc <umain+0x18f>
		if (fstat(i, &st) >= 0) {
  800145:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  80014b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800152:	89 04 24             	mov    %eax,(%esp)
  800155:	e8 f5 19 00 00       	call   801b4f <fstat>
  80015a:	85 c0                	test   %eax,%eax
  80015c:	78 7a                	js     8001d8 <umain+0x18b>
			if (usefprint)
  80015e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800162:	74 3f                	je     8001a3 <umain+0x156>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);	
  800164:	8b 45 e0             	mov    -0x20(%ebp),%eax
	}ARGEND

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  800167:	8b 48 04             	mov    0x4(%eax),%ecx
  80016a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80016d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800170:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  800174:	89 54 24 14          	mov    %edx,0x14(%esp)
  800178:	89 44 24 10          	mov    %eax,0x10(%esp)
					i, st.st_name, st.st_isdir,
  80017c:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800182:	89 44 24 0c          	mov    %eax,0xc(%esp)
	}ARGEND

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  800186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800189:	89 44 24 08          	mov    %eax,0x8(%esp)
  80018d:	c7 44 24 04 74 29 80 	movl   $0x802974,0x4(%esp)
  800194:	00 
  800195:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80019c:	e8 0b 21 00 00       	call   8022ac <fprintf>
  8001a1:	eb 35                	jmp    8001d8 <umain+0x18b>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);	
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  8001a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);	
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8001a6:	8b 48 04             	mov    0x4(%eax),%ecx
  8001a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001af:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8001b3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
					i, st.st_name, st.st_isdir,
  8001bb:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c1:	89 44 24 08          	mov    %eax,0x8(%esp)
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);	
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8001c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cc:	c7 04 24 74 29 80 00 	movl   $0x802974,(%esp)
  8001d3:	e8 a8 01 00 00       	call   800380 <cprintf>
	case '1':
		usefprint = 1;
		break;
	}ARGEND

	for (i = 0; i < 32; i++)
  8001d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8001dc:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  8001e0:	0f 8e 5f ff ff ff    	jle    800145 <umain+0xf8>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001e6:	c9                   	leave  
  8001e7:	c3                   	ret    

008001e8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  8001ee:	e8 53 10 00 00       	call   801246 <sys_getenvid>
  8001f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f8:	c1 e0 07             	shl    $0x7,%eax
  8001fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800200:	a3 40 50 80 00       	mov    %eax,0x805040
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800209:	7e 0a                	jle    800215 <libmain+0x2d>
		binaryname = argv[0];
  80020b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020e:	8b 00                	mov    (%eax),%eax
  800210:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	umain(argc, argv);
  800215:	8b 45 0c             	mov    0xc(%ebp),%eax
  800218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021c:	8b 45 08             	mov    0x8(%ebp),%eax
  80021f:	89 04 24             	mov    %eax,(%esp)
  800222:	e8 26 fe ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800227:	e8 04 00 00 00       	call   800230 <exit>
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    
	...

00800230 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800236:	e8 df 14 00 00       	call   80171a <close_all>
	sys_env_destroy(0);
  80023b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800242:	e8 bc 0f 00 00       	call   801203 <sys_env_destroy>
}
  800247:	c9                   	leave  
  800248:	c3                   	ret    
  800249:	00 00                	add    %al,(%eax)
	...

0080024c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800252:	8d 45 10             	lea    0x10(%ebp),%eax
  800255:	83 c0 04             	add    $0x4,%eax
  800258:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  80025b:	a1 44 50 80 00       	mov    0x805044,%eax
  800260:	85 c0                	test   %eax,%eax
  800262:	74 15                	je     800279 <_panic+0x2d>
		cprintf("%s: ", argv0);
  800264:	a1 44 50 80 00       	mov    0x805044,%eax
  800269:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026d:	c7 04 24 b3 29 80 00 	movl   $0x8029b3,(%esp)
  800274:	e8 07 01 00 00       	call   800380 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800279:	a1 00 50 80 00       	mov    0x805000,%eax
  80027e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800281:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800285:	8b 55 08             	mov    0x8(%ebp),%edx
  800288:	89 54 24 08          	mov    %edx,0x8(%esp)
  80028c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800290:	c7 04 24 b8 29 80 00 	movl   $0x8029b8,(%esp)
  800297:	e8 e4 00 00 00       	call   800380 <cprintf>
	vcprintf(fmt, ap);
  80029c:	8b 45 10             	mov    0x10(%ebp),%eax
  80029f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a6:	89 04 24             	mov    %eax,(%esp)
  8002a9:	e8 6e 00 00 00       	call   80031c <vcprintf>
	cprintf("\n");
  8002ae:	c7 04 24 d4 29 80 00 	movl   $0x8029d4,(%esp)
  8002b5:	e8 c6 00 00 00       	call   800380 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ba:	cc                   	int3   
  8002bb:	eb fd                	jmp    8002ba <_panic+0x6e>
  8002bd:	00 00                	add    %al,(%eax)
	...

008002c0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ce:	89 d1                	mov    %edx,%ecx
  8002d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  8002d7:	8d 50 01             	lea    0x1(%eax),%edx
  8002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dd:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  8002df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e2:	8b 00                	mov    (%eax),%eax
  8002e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e9:	75 20                	jne    80030b <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  8002eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ee:	8b 00                	mov    (%eax),%eax
  8002f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f3:	83 c2 08             	add    $0x8,%edx
  8002f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fa:	89 14 24             	mov    %edx,(%esp)
  8002fd:	e8 7b 0e 00 00       	call   80117d <sys_cputs>
		b->idx = 0;
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80030b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030e:	8b 40 04             	mov    0x4(%eax),%eax
  800311:	8d 50 01             	lea    0x1(%eax),%edx
  800314:	8b 45 0c             	mov    0xc(%ebp),%eax
  800317:	89 50 04             	mov    %edx,0x4(%eax)
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800325:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032c:	00 00 00 
	b.cnt = 0;
  80032f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800336:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800340:	8b 45 08             	mov    0x8(%ebp),%eax
  800343:	89 44 24 08          	mov    %eax,0x8(%esp)
  800347:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800351:	c7 04 24 c0 02 80 00 	movl   $0x8002c0,(%esp)
  800358:	e8 f7 01 00 00       	call   800554 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80035d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800363:	89 44 24 04          	mov    %eax,0x4(%esp)
  800367:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036d:	83 c0 08             	add    $0x8,%eax
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	e8 05 0e 00 00       	call   80117d <sys_cputs>

	return b.cnt;
  800378:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800386:	8d 45 0c             	lea    0xc(%ebp),%eax
  800389:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800392:	89 54 24 04          	mov    %edx,0x4(%esp)
  800396:	89 04 24             	mov    %eax,(%esp)
  800399:	e8 7e ff ff ff       	call   80031c <vcprintf>
  80039e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a4:	c9                   	leave  
  8003a5:	c3                   	ret    
	...

008003a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	53                   	push   %ebx
  8003ac:	83 ec 34             	sub    $0x34,%esp
  8003af:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003bb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003be:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c6:	77 72                	ja     80043a <printnum+0x92>
  8003c8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003cb:	72 05                	jb     8003d2 <printnum+0x2a>
  8003cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d0:	77 68                	ja     80043a <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003db:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ee:	89 04 24             	mov    %eax,(%esp)
  8003f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003f5:	e8 b6 22 00 00       	call   8026b0 <__udivdi3>
  8003fa:	8b 4d 20             	mov    0x20(%ebp),%ecx
  8003fd:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  800401:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  800405:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800408:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80040c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800410:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800414:	8b 45 0c             	mov    0xc(%ebp),%eax
  800417:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	89 04 24             	mov    %eax,(%esp)
  800421:	e8 82 ff ff ff       	call   8003a8 <printnum>
  800426:	eb 1c                	jmp    800444 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80042f:	8b 45 20             	mov    0x20(%ebp),%eax
  800432:	89 04 24             	mov    %eax,(%esp)
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80043a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  80043e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800442:	7f e4                	jg     800428 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800444:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800447:	bb 00 00 00 00       	mov    $0x0,%ebx
  80044c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800452:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800456:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80045a:	89 04 24             	mov    %eax,(%esp)
  80045d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800461:	e8 7a 23 00 00       	call   8027e0 <__umoddi3>
  800466:	05 3c 2b 80 00       	add    $0x802b3c,%eax
  80046b:	0f b6 00             	movzbl (%eax),%eax
  80046e:	0f be c0             	movsbl %al,%eax
  800471:	8b 55 0c             	mov    0xc(%ebp),%edx
  800474:	89 54 24 04          	mov    %edx,0x4(%esp)
  800478:	89 04 24             	mov    %eax,(%esp)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	ff d0                	call   *%eax
}
  800480:	83 c4 34             	add    $0x34,%esp
  800483:	5b                   	pop    %ebx
  800484:	5d                   	pop    %ebp
  800485:	c3                   	ret    

00800486 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800489:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80048d:	7e 1c                	jle    8004ab <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	8d 50 08             	lea    0x8(%eax),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	89 10                	mov    %edx,(%eax)
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	83 e8 08             	sub    $0x8,%eax
  8004a4:	8b 50 04             	mov    0x4(%eax),%edx
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	eb 40                	jmp    8004eb <getuint+0x65>
	else if (lflag)
  8004ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004af:	74 1e                	je     8004cf <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	8d 50 04             	lea    0x4(%eax),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	89 10                	mov    %edx,(%eax)
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	83 e8 04             	sub    $0x4,%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004cd:	eb 1c                	jmp    8004eb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 50 04             	lea    0x4(%eax),%edx
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	89 10                	mov    %edx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	83 e8 04             	sub    $0x4,%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004eb:	5d                   	pop    %ebp
  8004ec:	c3                   	ret    

008004ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004f4:	7e 1c                	jle    800512 <getint+0x25>
		return va_arg(*ap, long long);
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	8d 50 08             	lea    0x8(%eax),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	89 10                	mov    %edx,(%eax)
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 e8 08             	sub    $0x8,%eax
  80050b:	8b 50 04             	mov    0x4(%eax),%edx
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	eb 40                	jmp    800552 <getint+0x65>
	else if (lflag)
  800512:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800516:	74 1e                	je     800536 <getint+0x49>
		return va_arg(*ap, long);
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	8d 50 04             	lea    0x4(%eax),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 10                	mov    %edx,(%eax)
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	83 e8 04             	sub    $0x4,%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 c2                	mov    %eax,%edx
  800531:	c1 fa 1f             	sar    $0x1f,%edx
  800534:	eb 1c                	jmp    800552 <getint+0x65>
	else
		return va_arg(*ap, int);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	8b 00                	mov    (%eax),%eax
  80053b:	8d 50 04             	lea    0x4(%eax),%edx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	89 10                	mov    %edx,(%eax)
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	8b 00                	mov    (%eax),%eax
  800548:	83 e8 04             	sub    $0x4,%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	c1 fa 1f             	sar    $0x1f,%edx
}
  800552:	5d                   	pop    %ebp
  800553:	c3                   	ret    

00800554 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	56                   	push   %esi
  800558:	53                   	push   %ebx
  800559:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055c:	eb 17                	jmp    800575 <vprintfmt+0x21>
			if (ch == '\0')
  80055e:	85 db                	test   %ebx,%ebx
  800560:	0f 84 d1 05 00 00    	je     800b37 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056d:	89 1c 24             	mov    %ebx,(%esp)
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800575:	8b 45 10             	mov    0x10(%ebp),%eax
  800578:	0f b6 00             	movzbl (%eax),%eax
  80057b:	0f b6 d8             	movzbl %al,%ebx
  80057e:	83 fb 25             	cmp    $0x25,%ebx
  800581:	0f 95 c0             	setne  %al
  800584:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800588:	84 c0                	test   %al,%al
  80058a:	75 d2                	jne    80055e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800590:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800597:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005ac:	eb 04                	jmp    8005b2 <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8005ae:	90                   	nop
  8005af:	eb 01                	jmp    8005b2 <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8005b1:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b5:	0f b6 00             	movzbl (%eax),%eax
  8005b8:	0f b6 d8             	movzbl %al,%ebx
  8005bb:	89 d8                	mov    %ebx,%eax
  8005bd:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8005c1:	83 e8 23             	sub    $0x23,%eax
  8005c4:	83 f8 55             	cmp    $0x55,%eax
  8005c7:	0f 87 39 05 00 00    	ja     800b06 <vprintfmt+0x5b2>
  8005cd:	8b 04 85 84 2b 80 00 	mov    0x802b84(,%eax,4),%eax
  8005d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005da:	eb d6                	jmp    8005b2 <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005e0:	eb d0                	jmp    8005b2 <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	c1 e0 02             	shl    $0x2,%eax
  8005f1:	01 d0                	add    %edx,%eax
  8005f3:	01 c0                	add    %eax,%eax
  8005f5:	01 d8                	add    %ebx,%eax
  8005f7:	83 e8 30             	sub    $0x30,%eax
  8005fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800600:	0f b6 00             	movzbl (%eax),%eax
  800603:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800606:	83 fb 2f             	cmp    $0x2f,%ebx
  800609:	7e 43                	jle    80064e <vprintfmt+0xfa>
  80060b:	83 fb 39             	cmp    $0x39,%ebx
  80060e:	7f 3e                	jg     80064e <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800610:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800614:	eb d3                	jmp    8005e9 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	83 c0 04             	add    $0x4,%eax
  80061c:	89 45 14             	mov    %eax,0x14(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	83 e8 04             	sub    $0x4,%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80062a:	eb 23                	jmp    80064f <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  80062c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800630:	0f 89 78 ff ff ff    	jns    8005ae <vprintfmt+0x5a>
				width = 0;
  800636:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80063d:	e9 6c ff ff ff       	jmp    8005ae <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  800642:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800649:	e9 64 ff ff ff       	jmp    8005b2 <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80064e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80064f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800653:	0f 89 58 ff ff ff    	jns    8005b1 <vprintfmt+0x5d>
				width = precision, precision = -1;
  800659:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800666:	e9 46 ff ff ff       	jmp    8005b1 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80066b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  80066f:	e9 3e ff ff ff       	jmp    8005b2 <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	83 c0 04             	add    $0x4,%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	83 e8 04             	sub    $0x4,%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	8b 55 0c             	mov    0xc(%ebp),%edx
  800688:	89 54 24 04          	mov    %edx,0x4(%esp)
  80068c:	89 04 24             	mov    %eax,(%esp)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	ff d0                	call   *%eax
			break;
  800694:	e9 98 04 00 00       	jmp    800b31 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  800699:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  8006a0:	00 
  8006a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a8:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006ab:	89 04 24             	mov    %eax,(%esp)
  8006ae:	e8 d1 07 00 00       	call   800e84 <memmove>
            sel_c[3] = '\0';
  8006b3:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  8006b7:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  8006bb:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8006bf:	3c 2f                	cmp    $0x2f,%al
  8006c1:	7e 4c                	jle    80070f <vprintfmt+0x1bb>
  8006c3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8006c7:	3c 39                	cmp    $0x39,%al
  8006c9:	7f 44                	jg     80070f <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  8006cb:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8006cf:	0f be d0             	movsbl %al,%edx
  8006d2:	89 d0                	mov    %edx,%eax
  8006d4:	c1 e0 02             	shl    $0x2,%eax
  8006d7:	01 d0                	add    %edx,%eax
  8006d9:	01 c0                	add    %eax,%eax
  8006db:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8006e1:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	01 c2                	add    %eax,%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	01 c0                	add    %eax,%eax
  8006f3:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8006f9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  8006fd:	0f be c0             	movsbl %al,%eax
  800700:	01 d0                	add    %edx,%eax
  800702:	83 e8 30             	sub    $0x30,%eax
  800705:	a3 04 50 80 00       	mov    %eax,0x805004
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80070a:	e9 22 04 00 00       	jmp    800b31 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  80070f:	c7 44 24 04 4d 2b 80 	movl   $0x802b4d,0x4(%esp)
  800716:	00 
  800717:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80071a:	89 04 24             	mov    %eax,(%esp)
  80071d:	e8 36 06 00 00       	call   800d58 <strcmp>
  800722:	85 c0                	test   %eax,%eax
  800724:	75 0f                	jne    800735 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  800726:	c7 05 04 50 80 00 07 	movl   $0x7,0x805004
  80072d:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800730:	e9 fc 03 00 00       	jmp    800b31 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  800735:	c7 44 24 04 51 2b 80 	movl   $0x802b51,0x4(%esp)
  80073c:	00 
  80073d:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800740:	89 04 24             	mov    %eax,(%esp)
  800743:	e8 10 06 00 00       	call   800d58 <strcmp>
  800748:	85 c0                	test   %eax,%eax
  80074a:	75 0f                	jne    80075b <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  80074c:	c7 05 04 50 80 00 01 	movl   $0x1,0x805004
  800753:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800756:	e9 d6 03 00 00       	jmp    800b31 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  80075b:	c7 44 24 04 55 2b 80 	movl   $0x802b55,0x4(%esp)
  800762:	00 
  800763:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800766:	89 04 24             	mov    %eax,(%esp)
  800769:	e8 ea 05 00 00       	call   800d58 <strcmp>
  80076e:	85 c0                	test   %eax,%eax
  800770:	75 0f                	jne    800781 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  800772:	c7 05 04 50 80 00 02 	movl   $0x2,0x805004
  800779:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80077c:	e9 b0 03 00 00       	jmp    800b31 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  800781:	c7 44 24 04 59 2b 80 	movl   $0x802b59,0x4(%esp)
  800788:	00 
  800789:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80078c:	89 04 24             	mov    %eax,(%esp)
  80078f:	e8 c4 05 00 00       	call   800d58 <strcmp>
  800794:	85 c0                	test   %eax,%eax
  800796:	75 0f                	jne    8007a7 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  800798:	c7 05 04 50 80 00 04 	movl   $0x4,0x805004
  80079f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007a2:	e9 8a 03 00 00       	jmp    800b31 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  8007a7:	c7 44 24 04 5d 2b 80 	movl   $0x802b5d,0x4(%esp)
  8007ae:	00 
  8007af:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007b2:	89 04 24             	mov    %eax,(%esp)
  8007b5:	e8 9e 05 00 00       	call   800d58 <strcmp>
  8007ba:	85 c0                	test   %eax,%eax
  8007bc:	75 0f                	jne    8007cd <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  8007be:	c7 05 04 50 80 00 08 	movl   $0x8,0x805004
  8007c5:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007c8:	e9 64 03 00 00       	jmp    800b31 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  8007cd:	c7 44 24 04 61 2b 80 	movl   $0x802b61,0x4(%esp)
  8007d4:	00 
  8007d5:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007d8:	89 04 24             	mov    %eax,(%esp)
  8007db:	e8 78 05 00 00       	call   800d58 <strcmp>
  8007e0:	85 c0                	test   %eax,%eax
  8007e2:	75 0f                	jne    8007f3 <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  8007e4:	c7 05 04 50 80 00 0f 	movl   $0xf,0x805004
  8007eb:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007ee:	e9 3e 03 00 00       	jmp    800b31 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  8007f3:	c7 44 24 04 65 2b 80 	movl   $0x802b65,0x4(%esp)
  8007fa:	00 
  8007fb:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007fe:	89 04 24             	mov    %eax,(%esp)
  800801:	e8 52 05 00 00       	call   800d58 <strcmp>
  800806:	85 c0                	test   %eax,%eax
  800808:	75 0f                	jne    800819 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  80080a:	c7 05 04 50 80 00 0c 	movl   $0xc,0x805004
  800811:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800814:	e9 18 03 00 00       	jmp    800b31 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  800819:	c7 44 24 04 69 2b 80 	movl   $0x802b69,0x4(%esp)
  800820:	00 
  800821:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800824:	89 04 24             	mov    %eax,(%esp)
  800827:	e8 2c 05 00 00       	call   800d58 <strcmp>
  80082c:	85 c0                	test   %eax,%eax
  80082e:	75 0f                	jne    80083f <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  800830:	c7 05 04 50 80 00 06 	movl   $0x6,0x805004
  800837:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80083a:	e9 f2 02 00 00       	jmp    800b31 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  80083f:	c7 44 24 04 6d 2b 80 	movl   $0x802b6d,0x4(%esp)
  800846:	00 
  800847:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80084a:	89 04 24             	mov    %eax,(%esp)
  80084d:	e8 06 05 00 00       	call   800d58 <strcmp>
  800852:	85 c0                	test   %eax,%eax
  800854:	75 0f                	jne    800865 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  800856:	c7 05 04 50 80 00 0b 	movl   $0xb,0x805004
  80085d:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800860:	e9 cc 02 00 00       	jmp    800b31 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  800865:	c7 05 04 50 80 00 07 	movl   $0x7,0x805004
  80086c:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80086f:	e9 bd 02 00 00       	jmp    800b31 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	83 c0 04             	add    $0x4,%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	83 e8 04             	sub    $0x4,%eax
  800883:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800885:	85 db                	test   %ebx,%ebx
  800887:	79 02                	jns    80088b <vprintfmt+0x337>
				err = -err;
  800889:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088b:	83 fb 0e             	cmp    $0xe,%ebx
  80088e:	7f 0b                	jg     80089b <vprintfmt+0x347>
  800890:	8b 34 9d 00 2b 80 00 	mov    0x802b00(,%ebx,4),%esi
  800897:	85 f6                	test   %esi,%esi
  800899:	75 23                	jne    8008be <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  80089b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80089f:	c7 44 24 08 71 2b 80 	movl   $0x802b71,0x8(%esp)
  8008a6:	00 
  8008a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	89 04 24             	mov    %eax,(%esp)
  8008b4:	e8 86 02 00 00       	call   800b3f <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 73 02 00 00       	jmp    800b31 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008c2:	c7 44 24 08 7a 2b 80 	movl   $0x802b7a,0x8(%esp)
  8008c9:	00 
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 04 24             	mov    %eax,(%esp)
  8008d7:	e8 63 02 00 00       	call   800b3f <printfmt>
			break;
  8008dc:	e9 50 02 00 00       	jmp    800b31 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	83 c0 04             	add    $0x4,%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ed:	83 e8 04             	sub    $0x4,%eax
  8008f0:	8b 30                	mov    (%eax),%esi
  8008f2:	85 f6                	test   %esi,%esi
  8008f4:	75 05                	jne    8008fb <vprintfmt+0x3a7>
				p = "(null)";
  8008f6:	be 7d 2b 80 00       	mov    $0x802b7d,%esi
			if (width > 0 && padc != '-')
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7e 73                	jle    800974 <vprintfmt+0x420>
  800901:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800905:	74 6d                	je     800974 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  800907:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090e:	89 34 24             	mov    %esi,(%esp)
  800911:	e8 4c 03 00 00       	call   800c62 <strnlen>
  800916:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800919:	eb 17                	jmp    800932 <vprintfmt+0x3de>
					putch(padc, putdat);
  80091b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800922:	89 54 24 04          	mov    %edx,0x4(%esp)
  800926:	89 04 24             	mov    %eax,(%esp)
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80092e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800932:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800936:	7f e3                	jg     80091b <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800938:	eb 3a                	jmp    800974 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  80093a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80093e:	74 1f                	je     80095f <vprintfmt+0x40b>
  800940:	83 fb 1f             	cmp    $0x1f,%ebx
  800943:	7e 05                	jle    80094a <vprintfmt+0x3f6>
  800945:	83 fb 7e             	cmp    $0x7e,%ebx
  800948:	7e 15                	jle    80095f <vprintfmt+0x40b>
					putch('?', putdat);
  80094a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800951:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	ff d0                	call   *%eax
  80095d:	eb 0f                	jmp    80096e <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  80095f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800962:	89 44 24 04          	mov    %eax,0x4(%esp)
  800966:	89 1c 24             	mov    %ebx,(%esp)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80096e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800972:	eb 01                	jmp    800975 <vprintfmt+0x421>
  800974:	90                   	nop
  800975:	0f b6 06             	movzbl (%esi),%eax
  800978:	0f be d8             	movsbl %al,%ebx
  80097b:	85 db                	test   %ebx,%ebx
  80097d:	0f 95 c0             	setne  %al
  800980:	83 c6 01             	add    $0x1,%esi
  800983:	84 c0                	test   %al,%al
  800985:	74 29                	je     8009b0 <vprintfmt+0x45c>
  800987:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098b:	78 ad                	js     80093a <vprintfmt+0x3e6>
  80098d:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800991:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800995:	79 a3                	jns    80093a <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800997:	eb 17                	jmp    8009b0 <vprintfmt+0x45c>
				putch(' ', putdat);
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ac:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8009b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b4:	7f e3                	jg     800999 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  8009b6:	e9 76 01 00 00       	jmp    800b31 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c5:	89 04 24             	mov    %eax,(%esp)
  8009c8:	e8 20 fb ff ff       	call   8004ed <getint>
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	85 d2                	test   %edx,%edx
  8009db:	79 26                	jns    800a03 <vprintfmt+0x4af>
				putch('-', putdat);
  8009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
				num = -(long long) num;
  8009f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f6:	f7 d8                	neg    %eax
  8009f8:	83 d2 00             	adc    $0x0,%edx
  8009fb:	f7 da                	neg    %edx
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 ae 00 00 00       	jmp    800abd <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a16:	8d 45 14             	lea    0x14(%ebp),%eax
  800a19:	89 04 24             	mov    %eax,(%esp)
  800a1c:	e8 65 fa ff ff       	call   800486 <getuint>
  800a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a27:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a2e:	e9 8a 00 00 00       	jmp    800abd <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  800a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3d:	89 04 24             	mov    %eax,(%esp)
  800a40:	e8 41 fa ff ff       	call   800486 <getuint>
  800a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  800a4b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  800a52:	eb 69                	jmp    800abd <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a5b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	ff d0                	call   *%eax
			putch('x', putdat);
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 c0 04             	add    $0x4,%eax
  800a80:	89 45 14             	mov    %eax,0x14(%ebp)
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	83 e8 04             	sub    $0x4,%eax
  800a89:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a95:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9c:	eb 1f                	jmp    800abd <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	89 04 24             	mov    %eax,(%esp)
  800aab:	e8 d6 f9 ff ff       	call   800486 <getuint>
  800ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac4:	89 54 24 18          	mov    %edx,0x18(%esp)
  800ac8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800acb:	89 54 24 14          	mov    %edx,0x14(%esp)
  800acf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800add:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 04 24             	mov    %eax,(%esp)
  800aee:	e8 b5 f8 ff ff       	call   8003a8 <printnum>
			break;
  800af3:	eb 3c                	jmp    800b31 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800afc:	89 1c 24             	mov    %ebx,(%esp)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
			break;
  800b04:	eb 2b                	jmp    800b31 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b19:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b1d:	eb 04                	jmp    800b23 <vprintfmt+0x5cf>
  800b1f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	83 e8 01             	sub    $0x1,%eax
  800b29:	0f b6 00             	movzbl (%eax),%eax
  800b2c:	3c 25                	cmp    $0x25,%al
  800b2e:	75 ef                	jne    800b1f <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800b30:	90                   	nop
		}
	}
  800b31:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b32:	e9 3e fa ff ff       	jmp    800575 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800b37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b38:	83 c4 50             	add    $0x50,%esp
  800b3b:	5b                   	pop    %ebx
  800b3c:	5e                   	pop    %esi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800b45:	8d 45 10             	lea    0x10(%ebp),%eax
  800b48:	83 c0 04             	add    $0x4,%eax
  800b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b54:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b58:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	89 04 24             	mov    %eax,(%esp)
  800b69:	e8 e6 f9 ff ff       	call   800554 <vprintfmt>
	va_end(ap);
}
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	8b 40 08             	mov    0x8(%eax),%eax
  800b79:	8d 50 01             	lea    0x1(%eax),%edx
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8b 10                	mov    (%eax),%edx
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	8b 40 04             	mov    0x4(%eax),%eax
  800b8d:	39 c2                	cmp    %eax,%edx
  800b8f:	73 12                	jae    800ba3 <sprintputch+0x33>
		*b->buf++ = ch;
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8b 55 08             	mov    0x8(%ebp),%edx
  800b99:	88 10                	mov    %dl,(%eax)
  800b9b:	8d 50 01             	lea    0x1(%eax),%edx
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	89 10                	mov    %edx,(%eax)
}
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb4:	83 e8 01             	sub    $0x1,%eax
  800bb7:	03 45 08             	add    0x8(%ebp),%eax
  800bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc8:	74 06                	je     800bd0 <vsnprintf+0x2b>
  800bca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bce:	7f 07                	jg     800bd7 <vsnprintf+0x32>
		return -E_INVAL;
  800bd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bd5:	eb 2a                	jmp    800c01 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bde:	8b 45 10             	mov    0x10(%ebp),%eax
  800be1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bec:	c7 04 24 70 0b 80 00 	movl   $0x800b70,(%esp)
  800bf3:	e8 5c f9 ff ff       	call   800554 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bfb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c09:	8d 45 10             	lea    0x10(%ebp),%eax
  800c0c:	83 c0 04             	add    $0x4,%eax
  800c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c18:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 04 24             	mov    %eax,(%esp)
  800c2d:	e8 73 ff ff ff       	call   800ba5 <vsnprintf>
  800c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    
	...

00800c3c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c49:	eb 08                	jmp    800c53 <strlen+0x17>
		n++;
  800c4b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c4f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	0f b6 00             	movzbl (%eax),%eax
  800c59:	84 c0                	test   %al,%al
  800c5b:	75 ee                	jne    800c4b <strlen+0xf>
		n++;
	return n;
  800c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6f:	eb 0c                	jmp    800c7d <strnlen+0x1b>
		n++;
  800c71:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c79:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800c7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c81:	74 0a                	je     800c8d <strnlen+0x2b>
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	0f b6 00             	movzbl (%eax),%eax
  800c89:	84 c0                	test   %al,%al
  800c8b:	75 e4                	jne    800c71 <strnlen+0xf>
		n++;
	return n;
  800c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    

00800c92 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c9e:	90                   	nop
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	0f b6 10             	movzbl (%eax),%edx
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	88 10                	mov    %dl,(%eax)
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	0f b6 00             	movzbl (%eax),%eax
  800cb0:	84 c0                	test   %al,%al
  800cb2:	0f 95 c0             	setne  %al
  800cb5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cb9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800cbd:	84 c0                	test   %al,%al
  800cbf:	75 de                	jne    800c9f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd9:	eb 21                	jmp    800cfc <strncpy+0x36>
		*dst++ = *src;
  800cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cde:	0f b6 10             	movzbl (%eax),%edx
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	88 10                	mov    %dl,(%eax)
  800ce6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	0f b6 00             	movzbl (%eax),%eax
  800cf0:	84 c0                	test   %al,%al
  800cf2:	74 04                	je     800cf8 <strncpy+0x32>
			src++;
  800cf4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d02:	72 d7                	jb     800cdb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 2f                	je     800d4a <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800d1b:	eb 13                	jmp    800d30 <strlcpy+0x27>
			*dst++ = *src++;
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	0f b6 10             	movzbl (%eax),%edx
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	88 10                	mov    %dl,(%eax)
  800d28:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d2c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	74 0a                	je     800d44 <strlcpy+0x3b>
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	0f b6 00             	movzbl (%eax),%eax
  800d40:	84 c0                	test   %al,%al
  800d42:	75 d9                	jne    800d1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d50:	89 d1                	mov    %edx,%ecx
  800d52:	29 c1                	sub    %eax,%ecx
  800d54:	89 c8                	mov    %ecx,%eax
}
  800d56:	c9                   	leave  
  800d57:	c3                   	ret    

00800d58 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5b:	eb 08                	jmp    800d65 <strcmp+0xd>
		p++, q++;
  800d5d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d61:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	0f b6 00             	movzbl (%eax),%eax
  800d6b:	84 c0                	test   %al,%al
  800d6d:	74 10                	je     800d7f <strcmp+0x27>
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	0f b6 10             	movzbl (%eax),%edx
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	0f b6 00             	movzbl (%eax),%eax
  800d7b:	38 c2                	cmp    %al,%dl
  800d7d:	74 de                	je     800d5d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	0f b6 00             	movzbl (%eax),%eax
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	0f b6 00             	movzbl (%eax),%eax
  800d8e:	0f b6 c0             	movzbl %al,%eax
  800d91:	89 d1                	mov    %edx,%ecx
  800d93:	29 c1                	sub    %eax,%ecx
  800d95:	89 c8                	mov    %ecx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d9c:	eb 0c                	jmp    800daa <strncmp+0x11>
		n--, p++, q++;
  800d9e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800da2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800da6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 1a                	je     800dca <strncmp+0x31>
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	0f b6 00             	movzbl (%eax),%eax
  800db6:	84 c0                	test   %al,%al
  800db8:	74 10                	je     800dca <strncmp+0x31>
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	0f b6 10             	movzbl (%eax),%edx
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	0f b6 00             	movzbl (%eax),%eax
  800dc6:	38 c2                	cmp    %al,%dl
  800dc8:	74 d4                	je     800d9e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dce:	75 07                	jne    800dd7 <strncmp+0x3e>
		return 0;
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd5:	eb 18                	jmp    800def <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	0f b6 00             	movzbl (%eax),%eax
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	0f b6 00             	movzbl (%eax),%eax
  800de6:	0f b6 c0             	movzbl %al,%eax
  800de9:	89 d1                	mov    %edx,%ecx
  800deb:	29 c1                	sub    %eax,%ecx
  800ded:	89 c8                	mov    %ecx,%eax
}
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 04             	sub    $0x4,%esp
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfd:	eb 14                	jmp    800e13 <strchr+0x22>
		if (*s == c)
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	0f b6 00             	movzbl (%eax),%eax
  800e05:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e08:	75 05                	jne    800e0f <strchr+0x1e>
			return (char *) s;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	eb 13                	jmp    800e22 <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	0f b6 00             	movzbl (%eax),%eax
  800e19:	84 c0                	test   %al,%al
  800e1b:	75 e2                	jne    800dff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 04             	sub    $0x4,%esp
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e30:	eb 0f                	jmp    800e41 <strfind+0x1d>
		if (*s == c)
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	0f b6 00             	movzbl (%eax),%eax
  800e38:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e3b:	74 10                	je     800e4d <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e3d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	0f b6 00             	movzbl (%eax),%eax
  800e47:	84 c0                	test   %al,%al
  800e49:	75 e7                	jne    800e32 <strfind+0xe>
  800e4b:	eb 01                	jmp    800e4e <strfind+0x2a>
		if (*s == c)
			break;
  800e4d:	90                   	nop
	return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <memset>:


void *
memset(void *v, int c, size_t n)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e65:	eb 0e                	jmp    800e75 <memset+0x22>
		*p++ = c;
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	89 c2                	mov    %eax,%edx
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	88 10                	mov    %dl,(%eax)
  800e71:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e75:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800e79:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e7d:	79 e8                	jns    800e67 <memset+0x14>
		*p++ = c;

	return v;
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9c:	73 54                	jae    800ef2 <memmove+0x6e>
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea4:	01 d0                	add    %edx,%eax
  800ea6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ea9:	76 47                	jbe    800ef2 <memmove+0x6e>
		s += n;
  800eab:	8b 45 10             	mov    0x10(%ebp),%eax
  800eae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eb7:	eb 13                	jmp    800ecc <memmove+0x48>
			*--d = *--s;
  800eb9:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800ebd:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec4:	0f b6 10             	movzbl (%eax),%edx
  800ec7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eca:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed0:	0f 95 c0             	setne  %al
  800ed3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800ed7:	84 c0                	test   %al,%al
  800ed9:	75 de                	jne    800eb9 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800edb:	eb 25                	jmp    800f02 <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	0f b6 10             	movzbl (%eax),%edx
  800ee3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee6:	88 10                	mov    %dl,(%eax)
  800ee8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800eec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800ef0:	eb 01                	jmp    800ef3 <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ef2:	90                   	nop
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	0f 95 c0             	setne  %al
  800efa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800efe:	84 c0                	test   %al,%al
  800f00:	75 db                	jne    800edd <memmove+0x59>
			*d++ = *s++;

	return dst;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f10:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	89 04 24             	mov    %eax,(%esp)
  800f21:	e8 5e ff ff ff       	call   800e84 <memmove>
}
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f3a:	eb 32                	jmp    800f6e <memcmp+0x46>
		if (*s1 != *s2)
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	0f b6 10             	movzbl (%eax),%edx
  800f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f45:	0f b6 00             	movzbl (%eax),%eax
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 1a                	je     800f66 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4f:	0f b6 00             	movzbl (%eax),%eax
  800f52:	0f b6 d0             	movzbl %al,%edx
  800f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f58:	0f b6 00             	movzbl (%eax),%eax
  800f5b:	0f b6 c0             	movzbl %al,%eax
  800f5e:	89 d1                	mov    %edx,%ecx
  800f60:	29 c1                	sub    %eax,%ecx
  800f62:	89 c8                	mov    %ecx,%eax
  800f64:	eb 1c                	jmp    800f82 <memcmp+0x5a>
		s1++, s2++;
  800f66:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800f6a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f72:	0f 95 c0             	setne  %al
  800f75:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800f79:	84 c0                	test   %al,%al
  800f7b:	75 bf                	jne    800f3c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 11                	jmp    800fa8 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	0f b6 10             	movzbl (%eax),%edx
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	38 c2                	cmp    %al,%dl
  800fa2:	74 0e                	je     800fb2 <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fae:	72 e7                	jb     800f97 <memfind+0x13>
  800fb0:	eb 01                	jmp    800fb3 <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb2:	90                   	nop
	return (void *) s;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fcc:	eb 04                	jmp    800fd2 <strtol+0x1a>
		s++;
  800fce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	0f b6 00             	movzbl (%eax),%eax
  800fd8:	3c 20                	cmp    $0x20,%al
  800fda:	74 f2                	je     800fce <strtol+0x16>
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	0f b6 00             	movzbl (%eax),%eax
  800fe2:	3c 09                	cmp    $0x9,%al
  800fe4:	74 e8                	je     800fce <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	0f b6 00             	movzbl (%eax),%eax
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 06                	jne    800ff6 <strtol+0x3e>
		s++;
  800ff0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ff4:	eb 15                	jmp    80100b <strtol+0x53>
	else if (*s == '-')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	0f b6 00             	movzbl (%eax),%eax
  800ffc:	3c 2d                	cmp    $0x2d,%al
  800ffe:	75 0b                	jne    80100b <strtol+0x53>
		s++, neg = 1;
  801000:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801004:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80100b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100f:	74 06                	je     801017 <strtol+0x5f>
  801011:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801015:	75 24                	jne    80103b <strtol+0x83>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	0f b6 00             	movzbl (%eax),%eax
  80101d:	3c 30                	cmp    $0x30,%al
  80101f:	75 1a                	jne    80103b <strtol+0x83>
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	83 c0 01             	add    $0x1,%eax
  801027:	0f b6 00             	movzbl (%eax),%eax
  80102a:	3c 78                	cmp    $0x78,%al
  80102c:	75 0d                	jne    80103b <strtol+0x83>
		s += 2, base = 16;
  80102e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801032:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801039:	eb 2a                	jmp    801065 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  80103b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103f:	75 17                	jne    801058 <strtol+0xa0>
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	0f b6 00             	movzbl (%eax),%eax
  801047:	3c 30                	cmp    $0x30,%al
  801049:	75 0d                	jne    801058 <strtol+0xa0>
		s++, base = 8;
  80104b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80104f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801056:	eb 0d                	jmp    801065 <strtol+0xad>
	else if (base == 0)
  801058:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105c:	75 07                	jne    801065 <strtol+0xad>
		base = 10;
  80105e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	0f b6 00             	movzbl (%eax),%eax
  80106b:	3c 2f                	cmp    $0x2f,%al
  80106d:	7e 1b                	jle    80108a <strtol+0xd2>
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	0f b6 00             	movzbl (%eax),%eax
  801075:	3c 39                	cmp    $0x39,%al
  801077:	7f 11                	jg     80108a <strtol+0xd2>
			dig = *s - '0';
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	0f b6 00             	movzbl (%eax),%eax
  80107f:	0f be c0             	movsbl %al,%eax
  801082:	83 e8 30             	sub    $0x30,%eax
  801085:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801088:	eb 48                	jmp    8010d2 <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	0f b6 00             	movzbl (%eax),%eax
  801090:	3c 60                	cmp    $0x60,%al
  801092:	7e 1b                	jle    8010af <strtol+0xf7>
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	0f b6 00             	movzbl (%eax),%eax
  80109a:	3c 7a                	cmp    $0x7a,%al
  80109c:	7f 11                	jg     8010af <strtol+0xf7>
			dig = *s - 'a' + 10;
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	0f b6 00             	movzbl (%eax),%eax
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 57             	sub    $0x57,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 23                	jmp    8010d2 <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	0f b6 00             	movzbl (%eax),%eax
  8010b5:	3c 40                	cmp    $0x40,%al
  8010b7:	7e 38                	jle    8010f1 <strtol+0x139>
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	0f b6 00             	movzbl (%eax),%eax
  8010bf:	3c 5a                	cmp    $0x5a,%al
  8010c1:	7f 2e                	jg     8010f1 <strtol+0x139>
			dig = *s - 'A' + 10;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	0f b6 00             	movzbl (%eax),%eax
  8010c9:	0f be c0             	movsbl %al,%eax
  8010cc:	83 e8 37             	sub    $0x37,%eax
  8010cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d8:	7d 16                	jge    8010f0 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  8010da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8010de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e5:	03 45 f4             	add    -0xc(%ebp),%eax
  8010e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010eb:	e9 75 ff ff ff       	jmp    801065 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 08                	je     8010ff <strtol+0x147>
		*endptr = (char *) s;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 07                	je     80110c <strtol+0x154>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	f7 d8                	neg    %eax
  80110a:	eb 03                	jmp    80110f <strtol+0x157>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    
  801111:	00 00                	add    %al,(%eax)
	...

00801114 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801123:	8b 55 10             	mov    0x10(%ebp),%edx
  801126:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801129:	8b 5d 18             	mov    0x18(%ebp),%ebx
  80112c:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  80112f:	8b 75 20             	mov    0x20(%ebp),%esi
  801132:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801135:	cd 30                	int    $0x30
  801137:	89 c3                	mov    %eax,%ebx
  801139:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80113c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801140:	74 30                	je     801172 <syscall+0x5e>
  801142:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801146:	7e 2a                	jle    801172 <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  801148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80114b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801156:	c7 44 24 08 dc 2c 80 	movl   $0x802cdc,0x8(%esp)
  80115d:	00 
  80115e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801165:	00 
  801166:	c7 04 24 f9 2c 80 00 	movl   $0x802cf9,(%esp)
  80116d:	e8 da f0 ff ff       	call   80024c <_panic>

	return ret;
  801172:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801175:	83 c4 4c             	add    $0x4c,%esp
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80118d:	00 
  80118e:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801195:	00 
  801196:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80119d:	00 
  80119e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011b0:	00 
  8011b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011b8:	e8 57 ff ff ff       	call   801114 <syscall>
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <sys_cgetc>:

int
sys_cgetc(void)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8011c5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8011cc:	00 
  8011cd:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8011d4:	00 
  8011d5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011dc:	00 
  8011dd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011e4:	00 
  8011e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011ec:	00 
  8011ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011f4:	00 
  8011f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8011fc:	e8 13 ff ff ff       	call   801114 <syscall>
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801213:	00 
  801214:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80121b:	00 
  80121c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801223:	00 
  801224:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80122b:	00 
  80122c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801230:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801237:	00 
  801238:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80123f:	e8 d0 fe ff ff       	call   801114 <syscall>
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80124c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801253:	00 
  801254:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80125b:	00 
  80125c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801263:	00 
  801264:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80126b:	00 
  80126c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801283:	e8 8c fe ff ff       	call   801114 <syscall>
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_yield>:

void
sys_yield(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801290:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801297:	00 
  801298:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80129f:	00 
  8012a0:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012a7:	00 
  8012a8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8012af:	00 
  8012b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012b7:	00 
  8012b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8012bf:	00 
  8012c0:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8012c7:	e8 48 fe ff ff       	call   801114 <syscall>
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8012d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012e4:	00 
  8012e5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012ec:	00 
  8012ed:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8012f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801300:	00 
  801301:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  801308:	e8 07 fe ff ff       	call   801114 <syscall>
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	56                   	push   %esi
  801313:	53                   	push   %ebx
  801314:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  801317:	8b 75 18             	mov    0x18(%ebp),%esi
  80131a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80131d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801320:	8b 55 0c             	mov    0xc(%ebp),%edx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	89 74 24 18          	mov    %esi,0x18(%esp)
  80132a:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  80132e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801332:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801336:	89 44 24 08          	mov    %eax,0x8(%esp)
  80133a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801341:	00 
  801342:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  801349:	e8 c6 fd ff ff       	call   801114 <syscall>
}
  80134e:	83 c4 20             	add    $0x20,%esp
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    

00801355 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80135b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801368:	00 
  801369:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801370:	00 
  801371:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801378:	00 
  801379:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80137d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801381:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801388:	00 
  801389:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  801390:	e8 7f fd ff ff       	call   801114 <syscall>
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  80139d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013aa:	00 
  8013ab:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013b2:	00 
  8013b3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013ba:	00 
  8013bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013ca:	00 
  8013cb:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  8013d2:	e8 3d fd ff ff       	call   801114 <syscall>
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8013df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013ec:	00 
  8013ed:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013f4:	00 
  8013f5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013fc:	00 
  8013fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801401:	89 44 24 08          	mov    %eax,0x8(%esp)
  801405:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80140c:	00 
  80140d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  801414:	e8 fb fc ff ff       	call   801114 <syscall>
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  801421:	8b 55 0c             	mov    0xc(%ebp),%edx
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80142e:	00 
  80142f:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801436:	00 
  801437:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80143e:	00 
  80143f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801443:	89 44 24 08          	mov    %eax,0x8(%esp)
  801447:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80144e:	00 
  80144f:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  801456:	e8 b9 fc ff ff       	call   801114 <syscall>
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  801463:	8b 55 0c             	mov    0xc(%ebp),%edx
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801470:	00 
  801471:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801478:	00 
  801479:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801480:	00 
  801481:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801485:	89 44 24 08          	mov    %eax,0x8(%esp)
  801489:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801490:	00 
  801491:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801498:	e8 77 fc ff ff       	call   801114 <syscall>
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8014a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a8:	8b 55 10             	mov    0x10(%ebp),%edx
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8014b5:	00 
  8014b6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8014ba:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014d0:	00 
  8014d1:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  8014d8:	e8 37 fc ff ff       	call   801114 <syscall>
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8014ef:	00 
  8014f0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8014f7:	00 
  8014f8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8014ff:	00 
  801500:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801507:	00 
  801508:	89 44 24 08          	mov    %eax,0x8(%esp)
  80150c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801513:	00 
  801514:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  80151b:	e8 f4 fb ff ff       	call   801114 <syscall>
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    
	...

00801524 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 04 24             	mov    %eax,(%esp)
  801530:	e8 0a 00 00 00       	call   80153f <fd2num>
  801535:	05 40 03 00 00       	add    $0x340,%eax
  80153a:	c1 e0 16             	shl    $0x16,%eax
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <fd2num>:

int
fd2num(struct Fd *fd)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	05 00 00 40 30       	add    $0x30400000,%eax
  80154a:	c1 e8 0c             	shr    $0xc,%eax
}
  80154d:	5d                   	pop    %ebp
  80154e:	c3                   	ret    

0080154f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801555:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155c:	eb 49                	jmp    8015a7 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  80155e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801561:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801566:	c1 e0 0c             	shl    $0xc,%eax
  801569:	89 c2                	mov    %eax,%edx
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8b 00                	mov    (%eax),%eax
  801575:	c1 e8 16             	shr    $0x16,%eax
  801578:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80157f:	83 e0 01             	and    $0x1,%eax
  801582:	85 c0                	test   %eax,%eax
  801584:	74 16                	je     80159c <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	8b 00                	mov    (%eax),%eax
  80158b:	c1 e8 0c             	shr    $0xc,%eax
  80158e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801595:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801598:	85 c0                	test   %eax,%eax
  80159a:	75 07                	jne    8015a3 <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a1:	eb 18                	jmp    8015bb <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  8015a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8015a7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  8015ab:	7e b1                	jle    80155e <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  8015b6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  8015c3:	c7 44 24 08 08 2d 80 	movl   $0x802d08,0x8(%esp)
  8015ca:	00 
  8015cb:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8015d2:	00 
  8015d3:	c7 04 24 22 2d 80 00 	movl   $0x802d22,(%esp)
  8015da:	e8 6d ec ff ff       	call   80024c <_panic>

008015df <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	89 04 24             	mov    %eax,(%esp)
  8015eb:	e8 4f ff ff ff       	call   80153f <fd2num>
  8015f0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8015f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015f7:	89 04 24             	mov    %eax,(%esp)
  8015fa:	e8 be ff ff ff       	call   8015bd <fd_lookup>
  8015ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801606:	78 08                	js     801610 <fd_close+0x31>
	    || fd != fd2)
  801608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160b:	39 45 08             	cmp    %eax,0x8(%ebp)
  80160e:	74 12                	je     801622 <fd_close+0x43>
		return (must_exist ? r : 0);
  801610:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801614:	74 05                	je     80161b <fd_close+0x3c>
  801616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801619:	eb 05                	jmp    801620 <fd_close+0x41>
  80161b:	b8 00 00 00 00       	mov    $0x0,%eax
  801620:	eb 44                	jmp    801666 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	8b 00                	mov    (%eax),%eax
  801627:	8d 55 ec             	lea    -0x14(%ebp),%edx
  80162a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80162e:	89 04 24             	mov    %eax,(%esp)
  801631:	e8 32 00 00 00       	call   801668 <dev_lookup>
  801636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80163d:	78 11                	js     801650 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  80163f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801642:	8b 50 10             	mov    0x10(%eax),%edx
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	89 04 24             	mov    %eax,(%esp)
  80164b:	ff d2                	call   *%edx
  80164d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	89 44 24 04          	mov    %eax,0x4(%esp)
  801657:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165e:	e8 f2 fc ff ff       	call   801355 <sys_page_unmap>
	return r;
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  80166e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801675:	eb 2b                	jmp    8016a2 <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  801677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167a:	8b 04 85 08 50 80 00 	mov    0x805008(,%eax,4),%eax
  801681:	8b 00                	mov    (%eax),%eax
  801683:	3b 45 08             	cmp    0x8(%ebp),%eax
  801686:	75 16                	jne    80169e <dev_lookup+0x36>
			*dev = devtab[i];
  801688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168b:	8b 14 85 08 50 80 00 	mov    0x805008(,%eax,4),%edx
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	89 10                	mov    %edx,(%eax)
			return 0;
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
  80169c:	eb 3f                	jmp    8016dd <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80169e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8016a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a5:	8b 04 85 08 50 80 00 	mov    0x805008(,%eax,4),%eax
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	75 c7                	jne    801677 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8016b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8016b5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c3:	c7 04 24 2c 2d 80 00 	movl   $0x802d2c,(%esp)
  8016ca:	e8 b1 ec ff ff       	call   800380 <cprintf>
	*dev = 0;
  8016cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <close>:

int
close(int fdnum)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	89 04 24             	mov    %eax,(%esp)
  8016f2:	e8 c6 fe ff ff       	call   8015bd <fd_lookup>
  8016f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016fe:	79 05                	jns    801705 <close+0x26>
		return r;
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	eb 13                	jmp    801718 <close+0x39>
	else
		return fd_close(fd, 1);
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801708:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80170f:	00 
  801710:	89 04 24             	mov    %eax,(%esp)
  801713:	e8 c7 fe ff ff       	call   8015df <fd_close>
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <close_all>:

void
close_all(void)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801720:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801727:	eb 0f                	jmp    801738 <close_all+0x1e>
		close(i);
  801729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172c:	89 04 24             	mov    %eax,(%esp)
  80172f:	e8 ab ff ff ff       	call   8016df <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801734:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801738:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  80173c:	7e eb                	jle    801729 <close_all+0xf>
		close(i);
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801746:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801749:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	89 04 24             	mov    %eax,(%esp)
  801753:	e8 65 fe ff ff       	call   8015bd <fd_lookup>
  801758:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80175b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80175f:	79 08                	jns    801769 <dup+0x29>
		return r;
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801764:	e9 54 01 00 00       	jmp    8018bd <dup+0x17d>
	close(newfdnum);
  801769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176c:	89 04 24             	mov    %eax,(%esp)
  80176f:	e8 6b ff ff ff       	call   8016df <close>

	newfd = INDEX2FD(newfdnum);
  801774:	8b 45 0c             	mov    0xc(%ebp),%eax
  801777:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  80177c:	c1 e0 0c             	shl    $0xc,%eax
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  801782:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801785:	89 04 24             	mov    %eax,(%esp)
  801788:	e8 97 fd ff ff       	call   801524 <fd2data>
  80178d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801793:	89 04 24             	mov    %eax,(%esp)
  801796:	e8 89 fd ff ff       	call   801524 <fd2data>
  80179b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80179e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017a1:	c1 e8 0c             	shr    $0xc,%eax
  8017a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017ab:	89 c2                	mov    %eax,%edx
  8017ad:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017b6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017bd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017c1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017c8:	00 
  8017c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d4:	e8 36 fb ff ff       	call   80130f <sys_page_map>
  8017d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017e0:	0f 88 8e 00 00 00    	js     801874 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  8017e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e9:	c1 e8 16             	shr    $0x16,%eax
  8017ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	74 78                	je     80186f <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8017f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017fe:	eb 66                	jmp    801866 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  801800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801803:	03 45 e8             	add    -0x18(%ebp),%eax
  801806:	c1 e8 0c             	shr    $0xc,%eax
  801809:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801810:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  801813:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801816:	83 e0 01             	and    $0x1,%eax
  801819:	84 c0                	test   %al,%al
  80181b:	74 42                	je     80185f <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  80181d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801820:	89 c1                	mov    %eax,%ecx
  801822:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182b:	89 c2                	mov    %eax,%edx
  80182d:	03 55 e4             	add    -0x1c(%ebp),%edx
  801830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801833:	03 45 e8             	add    -0x18(%ebp),%eax
  801836:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80183a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80183e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801845:	00 
  801846:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801851:	e8 b9 fa ff ff       	call   80130f <sys_page_map>
  801856:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801859:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80185d:	78 18                	js     801877 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  80185f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801866:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  80186d:	7e 91                	jle    801800 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  80186f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801872:	eb 49                	jmp    8018bd <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  801874:	90                   	nop
  801875:	eb 01                	jmp    801878 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  801877:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801878:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801886:	e8 ca fa ff ff       	call   801355 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80188b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801892:	eb 1d                	jmp    8018b1 <dup+0x171>
		sys_page_unmap(0, nva + i);
  801894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801897:	03 45 e4             	add    -0x1c(%ebp),%eax
  80189a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a5:	e8 ab fa ff ff       	call   801355 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8018aa:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8018b1:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  8018b8:	7e da                	jle    801894 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  8018ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	89 04 24             	mov    %eax,(%esp)
  8018d2:	e8 e6 fc ff ff       	call   8015bd <fd_lookup>
  8018d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018de:	78 1d                	js     8018fd <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e3:	8b 00                	mov    (%eax),%eax
  8018e5:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8018e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018ec:	89 04 24             	mov    %eax,(%esp)
  8018ef:	e8 74 fd ff ff       	call   801668 <dev_lookup>
  8018f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018fb:	79 05                	jns    801902 <read+0x43>
		return r;
  8018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801900:	eb 75                	jmp    801977 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801902:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801905:	8b 40 08             	mov    0x8(%eax),%eax
  801908:	83 e0 03             	and    $0x3,%eax
  80190b:	83 f8 01             	cmp    $0x1,%eax
  80190e:	75 26                	jne    801936 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801910:	a1 40 50 80 00       	mov    0x805040,%eax
  801915:	8b 40 4c             	mov    0x4c(%eax),%eax
  801918:	8b 55 08             	mov    0x8(%ebp),%edx
  80191b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	c7 04 24 4b 2d 80 00 	movl   $0x802d4b,(%esp)
  80192a:	e8 51 ea ff ff       	call   800380 <cprintf>
		return -E_INVAL;
  80192f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801934:	eb 41                	jmp    801977 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801939:	8b 48 08             	mov    0x8(%eax),%ecx
  80193c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193f:	8b 50 04             	mov    0x4(%eax),%edx
  801942:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801945:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801949:	8b 55 10             	mov    0x10(%ebp),%edx
  80194c:	89 54 24 08          	mov    %edx,0x8(%esp)
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	89 54 24 04          	mov    %edx,0x4(%esp)
  801957:	89 04 24             	mov    %eax,(%esp)
  80195a:	ff d1                	call   *%ecx
  80195c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  80195f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801963:	78 0f                	js     801974 <read+0xb5>
		fd->fd_offset += r;
  801965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801968:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80196b:	8b 52 04             	mov    0x4(%edx),%edx
  80196e:	03 55 f4             	add    -0xc(%ebp),%edx
  801971:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801974:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80197f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801986:	eb 3b                	jmp    8019c3 <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198b:	8b 55 10             	mov    0x10(%ebp),%edx
  80198e:	29 c2                	sub    %eax,%edx
  801990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801993:	03 45 0c             	add    0xc(%ebp),%eax
  801996:	89 54 24 08          	mov    %edx,0x8(%esp)
  80199a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	89 04 24             	mov    %eax,(%esp)
  8019a4:	e8 16 ff ff ff       	call   8018bf <read>
  8019a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  8019ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019b0:	79 05                	jns    8019b7 <readn+0x3e>
			return m;
  8019b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b5:	eb 1a                	jmp    8019d1 <readn+0x58>
		if (m == 0)
  8019b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019bb:	74 10                	je     8019cd <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c0:	01 45 f4             	add    %eax,-0xc(%ebp)
  8019c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019c9:	72 bd                	jb     801988 <readn+0xf>
  8019cb:	eb 01                	jmp    8019ce <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8019cd:	90                   	nop
	}
	return tot;
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8019dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	89 04 24             	mov    %eax,(%esp)
  8019e6:	e8 d2 fb ff ff       	call   8015bd <fd_lookup>
  8019eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f2:	78 1d                	js     801a11 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8019fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a00:	89 04 24             	mov    %eax,(%esp)
  801a03:	e8 60 fc ff ff       	call   801668 <dev_lookup>
  801a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0f:	79 05                	jns    801a16 <write+0x43>
		return r;
  801a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a14:	eb 74                	jmp    801a8a <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a19:	8b 40 08             	mov    0x8(%eax),%eax
  801a1c:	83 e0 03             	and    $0x3,%eax
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	75 26                	jne    801a49 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801a23:	a1 40 50 80 00       	mov    0x805040,%eax
  801a28:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a2b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a36:	c7 04 24 67 2d 80 00 	movl   $0x802d67,(%esp)
  801a3d:	e8 3e e9 ff ff       	call   800380 <cprintf>
		return -E_INVAL;
  801a42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a47:	eb 41                	jmp    801a8a <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4c:	8b 48 0c             	mov    0xc(%eax),%ecx
  801a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a52:	8b 50 04             	mov    0x4(%eax),%edx
  801a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a5c:	8b 55 10             	mov    0x10(%ebp),%edx
  801a5f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a66:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a6a:	89 04 24             	mov    %eax,(%esp)
  801a6d:	ff d1                	call   *%ecx
  801a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  801a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a76:	7e 0f                	jle    801a87 <write+0xb4>
		fd->fd_offset += r;
  801a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a7e:	8b 52 04             	mov    0x4(%edx),%edx
  801a81:	03 55 f4             	add    -0xc(%ebp),%edx
  801a84:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <seek>:

int
seek(int fdnum, off_t offset)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a92:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	89 04 24             	mov    %eax,(%esp)
  801a9f:	e8 19 fb ff ff       	call   8015bd <fd_lookup>
  801aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aab:	79 05                	jns    801ab2 <seek+0x26>
		return r;
  801aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab0:	eb 0e                	jmp    801ac0 <seek+0x34>
	fd->fd_offset = offset;
  801ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ac8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	89 04 24             	mov    %eax,(%esp)
  801ad5:	e8 e3 fa ff ff       	call   8015bd <fd_lookup>
  801ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ae1:	78 1d                	js     801b00 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae6:	8b 00                	mov    (%eax),%eax
  801ae8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801aeb:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aef:	89 04 24             	mov    %eax,(%esp)
  801af2:	e8 71 fb ff ff       	call   801668 <dev_lookup>
  801af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801afe:	79 05                	jns    801b05 <ftruncate+0x43>
		return r;
  801b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b03:	eb 48                	jmp    801b4d <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b08:	8b 40 08             	mov    0x8(%eax),%eax
  801b0b:	83 e0 03             	and    $0x3,%eax
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	75 26                	jne    801b38 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801b12:	a1 40 50 80 00       	mov    0x805040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b17:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  801b1d:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b25:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  801b2c:	e8 4f e8 ff ff       	call   800380 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801b31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b36:	eb 15                	jmp    801b4d <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3b:	8b 48 1c             	mov    0x1c(%eax),%ecx
  801b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b48:	89 04 24             	mov    %eax,(%esp)
  801b4b:	ff d1                	call   *%ecx
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b55:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	89 04 24             	mov    %eax,(%esp)
  801b62:	e8 56 fa ff ff       	call   8015bd <fd_lookup>
  801b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b6e:	78 1d                	js     801b8d <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b73:	8b 00                	mov    (%eax),%eax
  801b75:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b78:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b7c:	89 04 24             	mov    %eax,(%esp)
  801b7f:	e8 e4 fa ff ff       	call   801668 <dev_lookup>
  801b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b8b:	79 05                	jns    801b92 <fstat+0x43>
		return r;
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	eb 41                	jmp    801bd3 <fstat+0x84>
	stat->st_name[0] = 0;
  801b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b95:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  801b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801ba2:	00 00 00 
	stat->st_isdir = 0;
  801ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  801baf:	00 00 00 
	stat->st_dev = dev;
  801bb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  801bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc1:	8b 48 14             	mov    0x14(%eax),%ecx
  801bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bca:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bce:	89 04 24             	mov    %eax,(%esp)
  801bd1:	ff d1                	call   *%ecx
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bdb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801be2:	00 
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	89 04 24             	mov    %eax,(%esp)
  801be9:	e8 36 00 00 00       	call   801c24 <open>
  801bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bf5:	79 05                	jns    801bfc <stat+0x27>
		return fd;
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	eb 23                	jmp    801c1f <stat+0x4a>
	r = fstat(fd, stat);
  801bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c06:	89 04 24             	mov    %eax,(%esp)
  801c09:	e8 41 ff ff ff       	call   801b4f <fstat>
  801c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  801c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c14:	89 04 24             	mov    %eax,(%esp)
  801c17:	e8 c3 fa ff ff       	call   8016df <close>
	return r;
  801c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    
  801c21:	00 00                	add    %al,(%eax)
	...

00801c24 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801c2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c2d:	89 04 24             	mov    %eax,(%esp)
  801c30:	e8 1a f9 ff ff       	call   80154f <fd_alloc>
  801c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c3c:	79 05                	jns    801c43 <open+0x1f>
  801c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c41:	eb 73                	jmp    801cb6 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  801c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	89 04 24             	mov    %eax,(%esp)
  801c57:	e8 f4 06 00 00       	call   802350 <fsipc_open>
  801c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c63:	79 05                	jns    801c6a <open+0x46>
  801c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c68:	eb 4c                	jmp    801cb6 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c76:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c81:	00 
  801c82:	89 04 24             	mov    %eax,(%esp)
  801c85:	e8 25 03 00 00       	call   801faf <fmap>
  801c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c91:	79 18                	jns    801cab <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  801c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c96:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c9d:	00 
  801c9e:	89 04 24             	mov    %eax,(%esp)
  801ca1:	e8 39 f9 ff ff       	call   8015df <fd_close>
  801ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca9:	eb 0b                	jmp    801cb6 <open+0x92>
	return fd2num(fd);
  801cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cae:	89 04 24             	mov    %eax,(%esp)
  801cb1:	e8 89 f8 ff ff       	call   80153f <fd2num>
	//panic("open() unimplemented!");
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801cc7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801cce:	00 
  801ccf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cd6:	00 
  801cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	89 04 24             	mov    %eax,(%esp)
  801ce1:	e8 72 03 00 00       	call   802058 <funmap>
  801ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ced:	79 05                	jns    801cf4 <file_close+0x3c>
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	eb 21                	jmp    801d15 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfa:	89 04 24             	mov    %eax,(%esp)
  801cfd:	e8 83 07 00 00       	call   802485 <fsipc_close>
  801d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d09:	79 05                	jns    801d10 <file_close+0x58>
  801d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0e:	eb 05                	jmp    801d15 <file_close+0x5d>
	return 0;
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801d29:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d2f:	76 07                	jbe    801d38 <file_read+0x21>
		return 0;
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
  801d36:	eb 43                	jmp    801d7b <file_read+0x64>
	if (offset + n > size)
  801d38:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3b:	03 45 10             	add    0x10(%ebp),%eax
  801d3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d41:	76 0f                	jbe    801d52 <file_read+0x3b>
		n = size - offset;
  801d43:	8b 45 14             	mov    0x14(%ebp),%eax
  801d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d49:	89 d1                	mov    %edx,%ecx
  801d4b:	29 c1                	sub    %eax,%ecx
  801d4d:	89 c8                	mov    %ecx,%eax
  801d4f:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	89 04 24             	mov    %eax,(%esp)
  801d58:	e8 c7 f7 ff ff       	call   801524 <fd2data>
  801d5d:	8b 55 14             	mov    0x14(%ebp),%edx
  801d60:	01 c2                	add    %eax,%edx
  801d62:	8b 45 10             	mov    0x10(%ebp),%eax
  801d65:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d69:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d70:	89 04 24             	mov    %eax,(%esp)
  801d73:	e8 0c f1 ff ff       	call   800e84 <memmove>
	return n;
  801d78:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d83:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d86:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	89 04 24             	mov    %eax,(%esp)
  801d90:	e8 28 f8 ff ff       	call   8015bd <fd_lookup>
  801d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9c:	79 05                	jns    801da3 <read_map+0x26>
		return r;
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	eb 74                	jmp    801e17 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  801da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da6:	8b 10                	mov    (%eax),%edx
  801da8:	a1 20 50 80 00       	mov    0x805020,%eax
  801dad:	39 c2                	cmp    %eax,%edx
  801daf:	74 07                	je     801db8 <read_map+0x3b>
		return -E_INVAL;
  801db1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db6:	eb 5f                	jmp    801e17 <read_map+0x9a>
	va = fd2data(fd) + offset;
  801db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbb:	89 04 24             	mov    %eax,(%esp)
  801dbe:	e8 61 f7 ff ff       	call   801524 <fd2data>
  801dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc6:	01 d0                	add    %edx,%eax
  801dc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  801dcb:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  801dd2:	7e 07                	jle    801ddb <read_map+0x5e>
		return -E_NO_DISK;
  801dd4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801dd9:	eb 3c                	jmp    801e17 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dde:	c1 e8 16             	shr    $0x16,%eax
  801de1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801de8:	83 e0 01             	and    $0x1,%eax
  801deb:	85 c0                	test   %eax,%eax
  801ded:	74 14                	je     801e03 <read_map+0x86>
  801def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df2:	c1 e8 0c             	shr    $0xc,%eax
  801df5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801dfc:	83 e0 01             	and    $0x1,%eax
  801dff:	85 c0                	test   %eax,%eax
  801e01:	75 07                	jne    801e0a <read_map+0x8d>
		return -E_NO_DISK;
  801e03:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801e08:	eb 0d                	jmp    801e17 <read_map+0x9a>
	*blk = (void*) va;
  801e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e10:	89 10                	mov    %edx,(%eax)
	return 0;
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  801e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e22:	03 45 10             	add    0x10(%ebp),%eax
  801e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  801e28:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  801e2f:	76 07                	jbe    801e38 <file_write+0x1f>
		return -E_NO_DISK;
  801e31:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801e36:	eb 57                	jmp    801e8f <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801e41:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e44:	73 20                	jae    801e66 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	89 04 24             	mov    %eax,(%esp)
  801e53:	e8 88 00 00 00       	call   801ee0 <file_trunc>
  801e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e5f:	79 05                	jns    801e66 <file_write+0x4d>
			return r;
  801e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e64:	eb 29                	jmp    801e8f <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	89 04 24             	mov    %eax,(%esp)
  801e6c:	e8 b3 f6 ff ff       	call   801524 <fd2data>
  801e71:	8b 55 14             	mov    0x14(%ebp),%edx
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 45 10             	mov    0x10(%ebp),%eax
  801e79:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e84:	89 14 24             	mov    %edx,(%esp)
  801e87:	e8 f8 ef ff ff       	call   800e84 <memmove>
	return n;
  801e8c:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	8d 50 10             	lea    0x10(%eax),%edx
  801e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea0:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ea4:	89 04 24             	mov    %eax,(%esp)
  801ea7:	e8 e6 ed ff ff       	call   800c92 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb8:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  801ec7:	83 f8 01             	cmp    $0x1,%eax
  801eca:	0f 94 c0             	sete   %al
  801ecd:	0f b6 d0             	movzbl %al,%edx
  801ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed3:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  801ee6:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  801eed:	7e 0a                	jle    801ef9 <file_trunc+0x19>
		return -E_NO_DISK;
  801eef:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801ef4:	e9 b4 00 00 00       	jmp    801fad <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	8b 40 0c             	mov    0xc(%eax),%eax
  801eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f14:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f18:	89 04 24             	mov    %eax,(%esp)
  801f1b:	e8 22 05 00 00       	call   802442 <fsipc_set_size>
  801f20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f27:	79 05                	jns    801f2e <file_trunc+0x4e>
		return r;
  801f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2c:	eb 7f                	jmp    801fad <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801f37:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f3a:	74 24                	je     801f60 <file_trunc+0x80>
  801f3c:	c7 44 24 0c b0 2d 80 	movl   $0x802db0,0xc(%esp)
  801f43:	00 
  801f44:	c7 44 24 08 d3 2d 80 	movl   $0x802dd3,0x8(%esp)
  801f4b:	00 
  801f4c:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801f53:	00 
  801f54:	c7 04 24 e8 2d 80 00 	movl   $0x802de8,(%esp)
  801f5b:	e8 ec e2 ff ff       	call   80024c <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	89 04 24             	mov    %eax,(%esp)
  801f74:	e8 36 00 00 00       	call   801faf <fmap>
  801f79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f80:	79 05                	jns    801f87 <file_trunc+0xa7>
		return r;
  801f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f85:	eb 26                	jmp    801fad <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  801f87:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f8e:	00 
  801f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	89 04 24             	mov    %eax,(%esp)
  801fa3:	e8 b0 00 00 00       	call   802058 <funmap>

	return 0;
  801fa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	89 04 24             	mov    %eax,(%esp)
  801fbb:	e8 64 f5 ff ff       	call   801524 <fd2data>
  801fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  801fc3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcd:	03 45 ec             	add    -0x14(%ebp),%eax
  801fd0:	83 e8 01             	sub    $0x1,%eax
  801fd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fde:	f7 75 ec             	divl   -0x14(%ebp)
  801fe1:	89 d0                	mov    %edx,%eax
  801fe3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fe6:	89 d1                	mov    %edx,%ecx
  801fe8:	29 c1                	sub    %eax,%ecx
  801fea:	89 c8                	mov    %ecx,%eax
  801fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fef:	eb 58                	jmp    802049 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801ffa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	8b 40 0c             	mov    0xc(%eax),%eax
  802003:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802007:	89 54 24 04          	mov    %edx,0x4(%esp)
  80200b:	89 04 24             	mov    %eax,(%esp)
  80200e:	e8 a4 03 00 00       	call   8023b7 <fsipc_map>
  802013:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802016:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80201a:	79 26                	jns    802042 <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802026:	00 
  802027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80202e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	89 04 24             	mov    %eax,(%esp)
  802038:	e8 1b 00 00 00       	call   802058 <funmap>
			return r;
  80203d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802040:	eb 14                	jmp    802056 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  802042:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802049:	8b 45 10             	mov    0x10(%ebp),%eax
  80204c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80204f:	77 a0                	ja     801ff1 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	89 04 24             	mov    %eax,(%esp)
  802064:	e8 bb f4 ff ff       	call   801524 <fd2data>
  802069:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  80206c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206f:	c1 e8 16             	shr    $0x16,%eax
  802072:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802079:	83 e0 01             	and    $0x1,%eax
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 0a                	jne    80208a <funmap+0x32>
		return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
  802085:	e9 bf 00 00 00       	jmp    802149 <funmap+0xf1>

	ret = 0;
  80208a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  802091:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802098:	8b 45 10             	mov    0x10(%ebp),%eax
  80209b:	03 45 e8             	add    -0x18(%ebp),%eax
  80209e:	83 e8 01             	sub    $0x1,%eax
  8020a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ac:	f7 75 e8             	divl   -0x18(%ebp)
  8020af:	89 d0                	mov    %edx,%eax
  8020b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020b4:	89 d1                	mov    %edx,%ecx
  8020b6:	29 c1                	sub    %eax,%ecx
  8020b8:	89 c8                	mov    %ecx,%eax
  8020ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bd:	eb 7b                	jmp    80213a <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	c1 e8 0c             	shr    $0xc,%eax
  8020ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020d1:	83 e0 01             	and    $0x1,%eax
  8020d4:	84 c0                	test   %al,%al
  8020d6:	74 5b                	je     802133 <funmap+0xdb>
			if (dirty
  8020d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8020dc:	74 3d                	je     80211b <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e4:	01 d0                	add    %edx,%eax
  8020e6:	c1 e8 0c             	shr    $0xc,%eax
  8020e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020f0:	83 e0 40             	and    $0x40,%eax
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	74 24                	je     80211b <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  8020f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802100:	89 54 24 04          	mov    %edx,0x4(%esp)
  802104:	89 04 24             	mov    %eax,(%esp)
  802107:	e8 b3 03 00 00       	call   8024bf <fsipc_dirty>
  80210c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80210f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802113:	79 06                	jns    80211b <funmap+0xc3>
				ret = r;
  802115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802118:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802121:	01 d0                	add    %edx,%eax
  802123:	89 44 24 04          	mov    %eax,0x4(%esp)
  802127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212e:	e8 22 f2 ff ff       	call   801355 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  802133:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80213a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802140:	0f 87 79 ff ff ff    	ja     8020bf <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  802146:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <remove>:

// Delete a file
int
remove(const char *path)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	89 04 24             	mov    %eax,(%esp)
  802157:	e8 a6 03 00 00       	call   802502 <fsipc_remove>
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  802164:	e8 f6 03 00 00       	call   80255f <fsipc_sync>
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    
	...

0080216c <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 28             	sub    $0x28,%esp
	if (b->error > 0) {
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	8b 40 0c             	mov    0xc(%eax),%eax
  802178:	85 c0                	test   %eax,%eax
  80217a:	7e 5d                	jle    8021d9 <writebuf+0x6d>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8b 40 04             	mov    0x4(%eax),%eax
  802182:	89 c2                	mov    %eax,%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	8d 48 10             	lea    0x10(%eax),%ecx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	89 54 24 08          	mov    %edx,0x8(%esp)
  802193:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802197:	89 04 24             	mov    %eax,(%esp)
  80219a:	e8 34 f8 ff ff       	call   8019d3 <write>
  80219f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (result > 0)
  8021a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a6:	7e 11                	jle    8021b9 <writebuf+0x4d>
			b->result += result;
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	8b 40 08             	mov    0x8(%eax),%eax
  8021ae:	89 c2                	mov    %eax,%edx
  8021b0:	03 55 f4             	add    -0xc(%ebp),%edx
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	89 50 08             	mov    %edx,0x8(%eax)
		if (result != b->idx) // error, or wrote less than supplied
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 40 04             	mov    0x4(%eax),%eax
  8021bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021c2:	74 15                	je     8021d9 <writebuf+0x6d>
			b->error = (result < 0 ? result : 0);
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cd:	89 c2                	mov    %eax,%edx
  8021cf:	0f 4e 55 f4          	cmovle -0xc(%ebp),%edx
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	89 50 0c             	mov    %edx,0xc(%eax)
	}
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <putch>:

static void
putch(int ch, void *thunk)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 28             	sub    $0x28,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  8021e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	b->buf[b->idx++] = ch;
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 40 04             	mov    0x4(%eax),%eax
  8021ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f0:	89 d1                	mov    %edx,%ecx
  8021f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f5:	88 4c 02 10          	mov    %cl,0x10(%edx,%eax,1)
  8021f9:	8d 50 01             	lea    0x1(%eax),%edx
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	89 50 04             	mov    %edx,0x4(%eax)
	if (b->idx == 256) {
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 40 04             	mov    0x4(%eax),%eax
  802208:	3d 00 01 00 00       	cmp    $0x100,%eax
  80220d:	75 15                	jne    802224 <putch+0x49>
		writebuf(b);
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	89 04 24             	mov    %eax,(%esp)
  802215:	e8 52 ff ff ff       	call   80216c <writebuf>
		b->idx = 0;
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	}
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802238:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80223f:	00 00 00 
	b.result = 0;
  802242:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802249:	00 00 00 
	b.error = 1;
  80224c:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802253:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802256:	8b 45 10             	mov    0x10(%ebp),%eax
  802259:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80225d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802260:	89 44 24 08          	mov    %eax,0x8(%esp)
  802264:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80226a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226e:	c7 04 24 db 21 80 00 	movl   $0x8021db,(%esp)
  802275:	e8 da e2 ff ff       	call   800554 <vprintfmt>
	if (b.idx > 0)
  80227a:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  802280:	85 c0                	test   %eax,%eax
  802282:	7e 0e                	jle    802292 <vfprintf+0x6c>
		writebuf(&b);
  802284:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80228a:	89 04 24             	mov    %eax,(%esp)
  80228d:	e8 da fe ff ff       	call   80216c <writebuf>

	return (b.result ? b.result : b.error);
  802292:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802298:	85 c0                	test   %eax,%eax
  80229a:	74 08                	je     8022a4 <vfprintf+0x7e>
  80229c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8022a2:	eb 06                	jmp    8022aa <vfprintf+0x84>
  8022a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8022b2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8022b5:	83 c0 04             	add    $0x4,%eax
  8022b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vfprintf(fd, fmt, ap);
  8022bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	89 04 24             	mov    %eax,(%esp)
  8022cf:	e8 52 ff ff ff       	call   802226 <vfprintf>
  8022d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8022d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <printf>:

int
printf(const char *fmt, ...)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8022e2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vfprintf(1, fmt, ap);
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8022fd:	e8 24 ff ff ff       	call   802226 <vfprintf>
  802302:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  802305:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    
	...

0080230c <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  802312:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  802317:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80231e:	00 
  80231f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802322:	89 54 24 08          	mov    %edx,0x8(%esp)
  802326:	8b 55 08             	mov    0x8(%ebp),%edx
  802329:	89 54 24 04          	mov    %edx,0x4(%esp)
  80232d:	89 04 24             	mov    %eax,(%esp)
  802330:	e8 e3 02 00 00       	call   802618 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802335:	8b 45 14             	mov    0x14(%ebp),%eax
  802338:	89 44 24 08          	mov    %eax,0x8(%esp)
  80233c:	8b 45 10             	mov    0x10(%ebp),%eax
  80233f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802343:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802346:	89 04 24             	mov    %eax,(%esp)
  802349:	e8 3e 02 00 00       	call   80258c <ipc_recv>
}
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  802356:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	89 04 24             	mov    %eax,(%esp)
  802363:	e8 d4 e8 ff ff       	call   800c3c <strlen>
  802368:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80236d:	7e 07                	jle    802376 <fsipc_open+0x26>
		return -E_BAD_PATH;
  80236f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802374:	eb 3f                	jmp    8023b5 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 55 08             	mov    0x8(%ebp),%edx
  80237c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802380:	89 04 24             	mov    %eax,(%esp)
  802383:	e8 0a e9 ff ff       	call   800c92 <strcpy>
	req->req_omode = omode;
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238e:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  802394:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802397:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80239b:	8b 45 10             	mov    0x10(%ebp),%eax
  80239e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8023b0:	e8 57 ff ff ff       	call   80230c <fsipc>
}
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  8023bd:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ca:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d2:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  8023d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8023d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8023df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ea:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8023f1:	e8 16 ff ff ff       	call   80230c <fsipc>
  8023f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023fd:	79 05                	jns    802404 <fsipc_map+0x4d>
		return r;
  8023ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802402:	eb 3c                	jmp    802440 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  802404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802407:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  80240c:	83 f8 05             	cmp    $0x5,%eax
  80240f:	74 2a                	je     80243b <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  802411:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802414:	8b 55 10             	mov    0x10(%ebp),%edx
  802417:	89 54 24 10          	mov    %edx,0x10(%esp)
  80241b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80241f:	c7 44 24 08 f4 2d 80 	movl   $0x802df4,0x8(%esp)
  802426:	00 
  802427:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  80242e:	00 
  80242f:	c7 04 24 2a 2e 80 00 	movl   $0x802e2a,(%esp)
  802436:	e8 11 de ff ff       	call   80024c <_panic>
	return 0;
  80243b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802448:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 55 08             	mov    0x8(%ebp),%edx
  802455:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245d:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802460:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802467:	00 
  802468:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80246f:	00 
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	89 44 24 04          	mov    %eax,0x4(%esp)
  802477:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80247e:	e8 89 fe ff ff       	call   80230c <fsipc>
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  80248b:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 55 08             	mov    0x8(%ebp),%edx
  802498:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  80249a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024a1:	00 
  8024a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024a9:	00 
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8024b8:	e8 4f fe ff ff       	call   80230c <fsipc>
}
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  8024c5:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d2:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024da:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8024dd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024e4:	00 
  8024e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024ec:	00 
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8024fb:	e8 0c fe ff ff       	call   80230c <fsipc>
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
  802505:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802508:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	89 04 24             	mov    %eax,(%esp)
  802515:	e8 22 e7 ff ff       	call   800c3c <strlen>
  80251a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80251f:	7e 07                	jle    802528 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802521:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802526:	eb 35                	jmp    80255d <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 55 08             	mov    0x8(%ebp),%edx
  80252e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802532:	89 04 24             	mov    %eax,(%esp)
  802535:	e8 58 e7 ff ff       	call   800c92 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  80253a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802541:	00 
  802542:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802549:	00 
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802551:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  802558:	e8 af fd ff ff       	call   80230c <fsipc>
}
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802565:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80256c:	00 
  80256d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802574:	00 
  802575:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  80257c:	00 
  80257d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  802584:	e8 83 fd ff ff       	call   80230c <fsipc>
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    
	...

0080258c <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  802592:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802596:	75 11                	jne    8025a9 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  802598:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  80259f:	e8 3b ef ff ff       	call   8014df <sys_ipc_recv>
  8025a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a7:	eb 0e                	jmp    8025b7 <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  8025a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ac:	89 04 24             	mov    %eax,(%esp)
  8025af:	e8 2b ef ff ff       	call   8014df <sys_ipc_recv>
  8025b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  8025b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bb:	79 1c                	jns    8025d9 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  8025bd:	c7 44 24 08 36 2e 80 	movl   $0x802e36,0x8(%esp)
  8025c4:	00 
  8025c5:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8025cc:	00 
  8025cd:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  8025d4:	e8 73 dc ff ff       	call   80024c <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  8025d9:	e8 68 ec ff ff       	call   801246 <sys_getenvid>
  8025de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8025e3:	c1 e0 07             	shl    $0x7,%eax
  8025e6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  8025ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f2:	74 0b                	je     8025ff <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  8025f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f7:	8b 50 74             	mov    0x74(%eax),%edx
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  8025ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802603:	74 0b                	je     802610 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  802605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802608:	8b 50 78             	mov    0x78(%eax),%edx
  80260b:	8b 45 10             	mov    0x10(%ebp),%eax
  80260e:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  802610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802613:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  802616:	c9                   	leave  
  802617:	c3                   	ret    

00802618 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802618:	55                   	push   %ebp
  802619:	89 e5                	mov    %esp,%ebp
  80261b:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  80261e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802622:	75 26                	jne    80264a <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  802624:	8b 45 14             	mov    0x14(%ebp),%eax
  802627:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80262b:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  802632:	ee 
  802633:	8b 45 0c             	mov    0xc(%ebp),%eax
  802636:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	89 04 24             	mov    %eax,(%esp)
  802640:	e8 5a ee ff ff       	call   80149f <sys_ipc_try_send>
  802645:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802648:	eb 23                	jmp    80266d <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  80264a:	8b 45 14             	mov    0x14(%ebp),%eax
  80264d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802651:	8b 45 10             	mov    0x10(%ebp),%eax
  802654:	89 44 24 08          	mov    %eax,0x8(%esp)
  802658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	89 04 24             	mov    %eax,(%esp)
  802665:	e8 35 ee ff ff       	call   80149f <sys_ipc_try_send>
  80266a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  80266d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802671:	79 29                	jns    80269c <ipc_send+0x84>
  802673:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  802677:	74 23                	je     80269c <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802680:	c7 44 24 08 56 2e 80 	movl   $0x802e56,0x8(%esp)
  802687:	00 
  802688:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80268f:	00 
  802690:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  802697:	e8 b0 db ff ff       	call   80024c <_panic>
	    sys_yield();
  80269c:	e8 e9 eb ff ff       	call   80128a <sys_yield>
	}while(r < 0);
  8026a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a5:	0f 88 73 ff ff ff    	js     80261e <ipc_send+0x6>
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    
  8026ad:	00 00                	add    %al,(%eax)
	...

008026b0 <__udivdi3>:
  8026b0:	83 ec 1c             	sub    $0x1c,%esp
  8026b3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8026b7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8026bb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8026bf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8026c3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8026c7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8026cb:	85 ff                	test   %edi,%edi
  8026cd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8026d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d5:	89 cd                	mov    %ecx,%ebp
  8026d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026db:	75 33                	jne    802710 <__udivdi3+0x60>
  8026dd:	39 f1                	cmp    %esi,%ecx
  8026df:	77 57                	ja     802738 <__udivdi3+0x88>
  8026e1:	85 c9                	test   %ecx,%ecx
  8026e3:	75 0b                	jne    8026f0 <__udivdi3+0x40>
  8026e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ea:	31 d2                	xor    %edx,%edx
  8026ec:	f7 f1                	div    %ecx
  8026ee:	89 c1                	mov    %eax,%ecx
  8026f0:	89 f0                	mov    %esi,%eax
  8026f2:	31 d2                	xor    %edx,%edx
  8026f4:	f7 f1                	div    %ecx
  8026f6:	89 c6                	mov    %eax,%esi
  8026f8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026fc:	f7 f1                	div    %ecx
  8026fe:	89 f2                	mov    %esi,%edx
  802700:	8b 74 24 10          	mov    0x10(%esp),%esi
  802704:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802708:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80270c:	83 c4 1c             	add    $0x1c,%esp
  80270f:	c3                   	ret    
  802710:	31 d2                	xor    %edx,%edx
  802712:	31 c0                	xor    %eax,%eax
  802714:	39 f7                	cmp    %esi,%edi
  802716:	77 e8                	ja     802700 <__udivdi3+0x50>
  802718:	0f bd cf             	bsr    %edi,%ecx
  80271b:	83 f1 1f             	xor    $0x1f,%ecx
  80271e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802722:	75 2c                	jne    802750 <__udivdi3+0xa0>
  802724:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802728:	76 04                	jbe    80272e <__udivdi3+0x7e>
  80272a:	39 f7                	cmp    %esi,%edi
  80272c:	73 d2                	jae    802700 <__udivdi3+0x50>
  80272e:	31 d2                	xor    %edx,%edx
  802730:	b8 01 00 00 00       	mov    $0x1,%eax
  802735:	eb c9                	jmp    802700 <__udivdi3+0x50>
  802737:	90                   	nop
  802738:	89 f2                	mov    %esi,%edx
  80273a:	f7 f1                	div    %ecx
  80273c:	31 d2                	xor    %edx,%edx
  80273e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802742:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802746:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80274a:	83 c4 1c             	add    $0x1c,%esp
  80274d:	c3                   	ret    
  80274e:	66 90                	xchg   %ax,%ax
  802750:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802755:	b8 20 00 00 00       	mov    $0x20,%eax
  80275a:	89 ea                	mov    %ebp,%edx
  80275c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802760:	d3 e7                	shl    %cl,%edi
  802762:	89 c1                	mov    %eax,%ecx
  802764:	d3 ea                	shr    %cl,%edx
  802766:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80276b:	09 fa                	or     %edi,%edx
  80276d:	89 f7                	mov    %esi,%edi
  80276f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802773:	89 f2                	mov    %esi,%edx
  802775:	8b 74 24 08          	mov    0x8(%esp),%esi
  802779:	d3 e5                	shl    %cl,%ebp
  80277b:	89 c1                	mov    %eax,%ecx
  80277d:	d3 ef                	shr    %cl,%edi
  80277f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802784:	d3 e2                	shl    %cl,%edx
  802786:	89 c1                	mov    %eax,%ecx
  802788:	d3 ee                	shr    %cl,%esi
  80278a:	09 d6                	or     %edx,%esi
  80278c:	89 fa                	mov    %edi,%edx
  80278e:	89 f0                	mov    %esi,%eax
  802790:	f7 74 24 0c          	divl   0xc(%esp)
  802794:	89 d7                	mov    %edx,%edi
  802796:	89 c6                	mov    %eax,%esi
  802798:	f7 e5                	mul    %ebp
  80279a:	39 d7                	cmp    %edx,%edi
  80279c:	72 22                	jb     8027c0 <__udivdi3+0x110>
  80279e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8027a2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027a7:	d3 e5                	shl    %cl,%ebp
  8027a9:	39 c5                	cmp    %eax,%ebp
  8027ab:	73 04                	jae    8027b1 <__udivdi3+0x101>
  8027ad:	39 d7                	cmp    %edx,%edi
  8027af:	74 0f                	je     8027c0 <__udivdi3+0x110>
  8027b1:	89 f0                	mov    %esi,%eax
  8027b3:	31 d2                	xor    %edx,%edx
  8027b5:	e9 46 ff ff ff       	jmp    802700 <__udivdi3+0x50>
  8027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027c0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8027c3:	31 d2                	xor    %edx,%edx
  8027c5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027c9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027cd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027d1:	83 c4 1c             	add    $0x1c,%esp
  8027d4:	c3                   	ret    
	...

008027e0 <__umoddi3>:
  8027e0:	83 ec 1c             	sub    $0x1c,%esp
  8027e3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8027e7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8027eb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8027ef:	89 74 24 10          	mov    %esi,0x10(%esp)
  8027f3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8027f7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8027fb:	85 ed                	test   %ebp,%ebp
  8027fd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802801:	89 44 24 08          	mov    %eax,0x8(%esp)
  802805:	89 cf                	mov    %ecx,%edi
  802807:	89 04 24             	mov    %eax,(%esp)
  80280a:	89 f2                	mov    %esi,%edx
  80280c:	75 1a                	jne    802828 <__umoddi3+0x48>
  80280e:	39 f1                	cmp    %esi,%ecx
  802810:	76 4e                	jbe    802860 <__umoddi3+0x80>
  802812:	f7 f1                	div    %ecx
  802814:	89 d0                	mov    %edx,%eax
  802816:	31 d2                	xor    %edx,%edx
  802818:	8b 74 24 10          	mov    0x10(%esp),%esi
  80281c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802820:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802824:	83 c4 1c             	add    $0x1c,%esp
  802827:	c3                   	ret    
  802828:	39 f5                	cmp    %esi,%ebp
  80282a:	77 54                	ja     802880 <__umoddi3+0xa0>
  80282c:	0f bd c5             	bsr    %ebp,%eax
  80282f:	83 f0 1f             	xor    $0x1f,%eax
  802832:	89 44 24 04          	mov    %eax,0x4(%esp)
  802836:	75 60                	jne    802898 <__umoddi3+0xb8>
  802838:	3b 0c 24             	cmp    (%esp),%ecx
  80283b:	0f 87 07 01 00 00    	ja     802948 <__umoddi3+0x168>
  802841:	89 f2                	mov    %esi,%edx
  802843:	8b 34 24             	mov    (%esp),%esi
  802846:	29 ce                	sub    %ecx,%esi
  802848:	19 ea                	sbb    %ebp,%edx
  80284a:	89 34 24             	mov    %esi,(%esp)
  80284d:	8b 04 24             	mov    (%esp),%eax
  802850:	8b 74 24 10          	mov    0x10(%esp),%esi
  802854:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802858:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80285c:	83 c4 1c             	add    $0x1c,%esp
  80285f:	c3                   	ret    
  802860:	85 c9                	test   %ecx,%ecx
  802862:	75 0b                	jne    80286f <__umoddi3+0x8f>
  802864:	b8 01 00 00 00       	mov    $0x1,%eax
  802869:	31 d2                	xor    %edx,%edx
  80286b:	f7 f1                	div    %ecx
  80286d:	89 c1                	mov    %eax,%ecx
  80286f:	89 f0                	mov    %esi,%eax
  802871:	31 d2                	xor    %edx,%edx
  802873:	f7 f1                	div    %ecx
  802875:	8b 04 24             	mov    (%esp),%eax
  802878:	f7 f1                	div    %ecx
  80287a:	eb 98                	jmp    802814 <__umoddi3+0x34>
  80287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802880:	89 f2                	mov    %esi,%edx
  802882:	8b 74 24 10          	mov    0x10(%esp),%esi
  802886:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80288a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80288e:	83 c4 1c             	add    $0x1c,%esp
  802891:	c3                   	ret    
  802892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802898:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80289d:	89 e8                	mov    %ebp,%eax
  80289f:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028a4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8028a8:	89 fa                	mov    %edi,%edx
  8028aa:	d3 e0                	shl    %cl,%eax
  8028ac:	89 e9                	mov    %ebp,%ecx
  8028ae:	d3 ea                	shr    %cl,%edx
  8028b0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028b5:	09 c2                	or     %eax,%edx
  8028b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028bb:	89 14 24             	mov    %edx,(%esp)
  8028be:	89 f2                	mov    %esi,%edx
  8028c0:	d3 e7                	shl    %cl,%edi
  8028c2:	89 e9                	mov    %ebp,%ecx
  8028c4:	d3 ea                	shr    %cl,%edx
  8028c6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028cf:	d3 e6                	shl    %cl,%esi
  8028d1:	89 e9                	mov    %ebp,%ecx
  8028d3:	d3 e8                	shr    %cl,%eax
  8028d5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028da:	09 f0                	or     %esi,%eax
  8028dc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8028e0:	f7 34 24             	divl   (%esp)
  8028e3:	d3 e6                	shl    %cl,%esi
  8028e5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028e9:	89 d6                	mov    %edx,%esi
  8028eb:	f7 e7                	mul    %edi
  8028ed:	39 d6                	cmp    %edx,%esi
  8028ef:	89 c1                	mov    %eax,%ecx
  8028f1:	89 d7                	mov    %edx,%edi
  8028f3:	72 3f                	jb     802934 <__umoddi3+0x154>
  8028f5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8028f9:	72 35                	jb     802930 <__umoddi3+0x150>
  8028fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028ff:	29 c8                	sub    %ecx,%eax
  802901:	19 fe                	sbb    %edi,%esi
  802903:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802908:	89 f2                	mov    %esi,%edx
  80290a:	d3 e8                	shr    %cl,%eax
  80290c:	89 e9                	mov    %ebp,%ecx
  80290e:	d3 e2                	shl    %cl,%edx
  802910:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802915:	09 d0                	or     %edx,%eax
  802917:	89 f2                	mov    %esi,%edx
  802919:	d3 ea                	shr    %cl,%edx
  80291b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80291f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802923:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802927:	83 c4 1c             	add    $0x1c,%esp
  80292a:	c3                   	ret    
  80292b:	90                   	nop
  80292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802930:	39 d6                	cmp    %edx,%esi
  802932:	75 c7                	jne    8028fb <__umoddi3+0x11b>
  802934:	89 d7                	mov    %edx,%edi
  802936:	89 c1                	mov    %eax,%ecx
  802938:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80293c:	1b 3c 24             	sbb    (%esp),%edi
  80293f:	eb ba                	jmp    8028fb <__umoddi3+0x11b>
  802941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802948:	39 f5                	cmp    %esi,%ebp
  80294a:	0f 82 f1 fe ff ff    	jb     802841 <__umoddi3+0x61>
  802950:	e9 f8 fe ff ff       	jmp    80284d <__umoddi3+0x6d>
