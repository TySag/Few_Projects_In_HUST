
obj/user/primes:     file format elf32-i386


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
  80002c:	e8 3b 01 00 00       	call   80016c <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 28             	sub    $0x28,%esp
  80003a:	eb 01                	jmp    80003d <primeproc+0x9>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
		panic("fork: %e", id);
	if (id == 0)
		goto top;
  80003c:	90                   	nop
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800044:	00 
  800045:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004c:	00 
  80004d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800050:	89 04 24             	mov    %eax,(%esp)
  800053:	e8 4c 1b 00 00       	call   801ba4 <ipc_recv>
  800058:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("%d ", p);
  80005b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 2f 80 00 	movl   $0x802f00,(%esp)
  800069:	e8 96 02 00 00       	call   800304 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80006e:	e8 94 16 00 00       	call   801707 <fork>
  800073:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800076:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80007a:	79 23                	jns    80009f <primeproc+0x6b>
		panic("fork: %e", id);
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800083:	c7 44 24 08 04 2f 80 	movl   $0x802f04,0x8(%esp)
  80008a:	00 
  80008b:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800092:	00 
  800093:	c7 04 24 0d 2f 80 00 	movl   $0x802f0d,(%esp)
  80009a:	e8 31 01 00 00       	call   8001d0 <_panic>
	if (id == 0)
  80009f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8000a3:	74 97                	je     80003c <primeproc+0x8>
  8000a5:	eb 01                	jmp    8000a8 <primeproc+0x74>
	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
		if (i % p)
			ipc_send(id, i, 0, 0);
	}
  8000a7:	90                   	nop
	if (id == 0)
		goto top;
	
	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b7:	00 
  8000b8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8000bb:	89 04 24             	mov    %eax,(%esp)
  8000be:	e8 e1 1a 00 00       	call   801ba4 <ipc_recv>
  8000c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (i % p)
  8000c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c9:	89 c2                	mov    %eax,%edx
  8000cb:	c1 fa 1f             	sar    $0x1f,%edx
  8000ce:	f7 7d f4             	idivl  -0xc(%ebp)
  8000d1:	89 d0                	mov    %edx,%eax
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	74 d0                	je     8000a7 <primeproc+0x73>
			ipc_send(id, i, 0, 0);
  8000d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000e1:	00 
  8000e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000e9:	00 
  8000ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f1:	89 04 24             	mov    %eax,(%esp)
  8000f4:	e8 37 1b 00 00       	call   801c30 <ipc_send>
	}
  8000f9:	eb ac                	jmp    8000a7 <primeproc+0x73>

008000fb <umain>:
}

void
umain(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 28             	sub    $0x28,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  800101:	e8 01 16 00 00       	call   801707 <fork>
  800106:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800109:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80010d:	79 23                	jns    800132 <umain+0x37>
		panic("fork: %e", id);
  80010f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800116:	c7 44 24 08 04 2f 80 	movl   $0x802f04,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 0d 2f 80 00 	movl   $0x802f0d,(%esp)
  80012d:	e8 9e 00 00 00       	call   8001d0 <_panic>
	if (id == 0)
  800132:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800136:	75 05                	jne    80013d <umain+0x42>
		primeproc();
  800138:	e8 f7 fe ff ff       	call   800034 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
  80013d:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		ipc_send(id, i, 0, 0);
  800144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800147:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80014e:	00 
  80014f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800156:	00 
  800157:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80015e:	89 04 24             	mov    %eax,(%esp)
  800161:	e8 ca 1a 00 00       	call   801c30 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  800166:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		ipc_send(id, i, 0, 0);
  80016a:	eb d8                	jmp    800144 <umain+0x49>

0080016c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  800172:	e8 53 10 00 00       	call   8011ca <sys_getenvid>
  800177:	25 ff 03 00 00       	and    $0x3ff,%eax
  80017c:	c1 e0 07             	shl    $0x7,%eax
  80017f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800184:	a3 40 60 80 00       	mov    %eax,0x806040
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018d:	7e 0a                	jle    800199 <libmain+0x2d>
		binaryname = argv[0];
  80018f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800192:	8b 00                	mov    (%eax),%eax
  800194:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a3:	89 04 24             	mov    %eax,(%esp)
  8001a6:	e8 50 ff ff ff       	call   8000fb <umain>

	// exit gracefully
	exit();
  8001ab:	e8 04 00 00 00       	call   8001b4 <exit>
}
  8001b0:	c9                   	leave  
  8001b1:	c3                   	ret    
	...

008001b4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001ba:	e8 ff 1c 00 00       	call   801ebe <close_all>
	sys_env_destroy(0);
  8001bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c6:	e8 bc 0f 00 00       	call   801187 <sys_env_destroy>
}
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    
  8001cd:	00 00                	add    %al,(%eax)
	...

008001d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  8001d6:	8d 45 10             	lea    0x10(%ebp),%eax
  8001d9:	83 c0 04             	add    $0x4,%eax
  8001dc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8001df:	a1 44 60 80 00       	mov    0x806044,%eax
  8001e4:	85 c0                	test   %eax,%eax
  8001e6:	74 15                	je     8001fd <_panic+0x2d>
		cprintf("%s: ", argv0);
  8001e8:	a1 44 60 80 00       	mov    0x806044,%eax
  8001ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f1:	c7 04 24 32 2f 80 00 	movl   $0x802f32,(%esp)
  8001f8:	e8 07 01 00 00       	call   800304 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001fd:	a1 00 60 80 00       	mov    0x806000,%eax
  800202:	8b 55 0c             	mov    0xc(%ebp),%edx
  800205:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800209:	8b 55 08             	mov    0x8(%ebp),%edx
  80020c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800210:	89 44 24 04          	mov    %eax,0x4(%esp)
  800214:	c7 04 24 37 2f 80 00 	movl   $0x802f37,(%esp)
  80021b:	e8 e4 00 00 00       	call   800304 <cprintf>
	vcprintf(fmt, ap);
  800220:	8b 45 10             	mov    0x10(%ebp),%eax
  800223:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800226:	89 54 24 04          	mov    %edx,0x4(%esp)
  80022a:	89 04 24             	mov    %eax,(%esp)
  80022d:	e8 6e 00 00 00       	call   8002a0 <vcprintf>
	cprintf("\n");
  800232:	c7 04 24 53 2f 80 00 	movl   $0x802f53,(%esp)
  800239:	e8 c6 00 00 00       	call   800304 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80023e:	cc                   	int3   
  80023f:	eb fd                	jmp    80023e <_panic+0x6e>
  800241:	00 00                	add    %al,(%eax)
	...

00800244 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  80024a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024d:	8b 00                	mov    (%eax),%eax
  80024f:	8b 55 08             	mov    0x8(%ebp),%edx
  800252:	89 d1                	mov    %edx,%ecx
  800254:	8b 55 0c             	mov    0xc(%ebp),%edx
  800257:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  80025b:	8d 50 01             	lea    0x1(%eax),%edx
  80025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800261:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  800263:	8b 45 0c             	mov    0xc(%ebp),%eax
  800266:	8b 00                	mov    (%eax),%eax
  800268:	3d ff 00 00 00       	cmp    $0xff,%eax
  80026d:	75 20                	jne    80028f <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  80026f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800272:	8b 00                	mov    (%eax),%eax
  800274:	8b 55 0c             	mov    0xc(%ebp),%edx
  800277:	83 c2 08             	add    $0x8,%edx
  80027a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027e:	89 14 24             	mov    %edx,(%esp)
  800281:	e8 7b 0e 00 00       	call   801101 <sys_cputs>
		b->idx = 0;
  800286:	8b 45 0c             	mov    0xc(%ebp),%eax
  800289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80028f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800292:	8b 40 04             	mov    0x4(%eax),%eax
  800295:	8d 50 01             	lea    0x1(%eax),%edx
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b0:	00 00 00 
	b.cnt = 0;
  8002b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d5:	c7 04 24 44 02 80 00 	movl   $0x800244,(%esp)
  8002dc:	e8 f7 01 00 00       	call   8004d8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f1:	83 c0 08             	add    $0x8,%eax
  8002f4:	89 04 24             	mov    %eax,(%esp)
  8002f7:	e8 05 0e 00 00       	call   801101 <sys_cputs>

	return b.cnt;
  8002fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800302:	c9                   	leave  
  800303:	c3                   	ret    

00800304 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80030d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800316:	89 54 24 04          	mov    %edx,0x4(%esp)
  80031a:	89 04 24             	mov    %eax,(%esp)
  80031d:	e8 7e ff ff ff       	call   8002a0 <vcprintf>
  800322:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800328:	c9                   	leave  
  800329:	c3                   	ret    
	...

0080032c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	53                   	push   %ebx
  800330:	83 ec 34             	sub    $0x34,%esp
  800333:	8b 45 10             	mov    0x10(%ebp),%eax
  800336:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800339:	8b 45 14             	mov    0x14(%ebp),%eax
  80033c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033f:	8b 45 18             	mov    0x18(%ebp),%eax
  800342:	ba 00 00 00 00       	mov    $0x0,%edx
  800347:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80034a:	77 72                	ja     8003be <printnum+0x92>
  80034c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80034f:	72 05                	jb     800356 <printnum+0x2a>
  800351:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800354:	77 68                	ja     8003be <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800356:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800359:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035c:	8b 45 18             	mov    0x18(%ebp),%eax
  80035f:	ba 00 00 00 00       	mov    $0x0,%edx
  800364:	89 44 24 08          	mov    %eax,0x8(%esp)
  800368:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80036c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800372:	89 04 24             	mov    %eax,(%esp)
  800375:	89 54 24 04          	mov    %edx,0x4(%esp)
  800379:	e8 d2 28 00 00       	call   802c50 <__udivdi3>
  80037e:	8b 4d 20             	mov    0x20(%ebp),%ecx
  800381:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  800385:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  800389:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80038c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800390:	89 44 24 08          	mov    %eax,0x8(%esp)
  800394:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	89 04 24             	mov    %eax,(%esp)
  8003a5:	e8 82 ff ff ff       	call   80032c <printnum>
  8003aa:	eb 1c                	jmp    8003c8 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b3:	8b 45 20             	mov    0x20(%ebp),%eax
  8003b6:	89 04 24             	mov    %eax,(%esp)
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003be:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8003c2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003c6:	7f e4                	jg     8003ac <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003da:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003de:	89 04 24             	mov    %eax,(%esp)
  8003e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003e5:	e8 96 29 00 00       	call   802d80 <__umoddi3>
  8003ea:	05 bc 30 80 00       	add    $0x8030bc,%eax
  8003ef:	0f b6 00             	movzbl (%eax),%eax
  8003f2:	0f be c0             	movsbl %al,%eax
  8003f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003fc:	89 04 24             	mov    %eax,(%esp)
  8003ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800402:	ff d0                	call   *%eax
}
  800404:	83 c4 34             	add    $0x34,%esp
  800407:	5b                   	pop    %ebx
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80040d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800411:	7e 1c                	jle    80042f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	8d 50 08             	lea    0x8(%eax),%edx
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	8b 00                	mov    (%eax),%eax
  800425:	83 e8 08             	sub    $0x8,%eax
  800428:	8b 50 04             	mov    0x4(%eax),%edx
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	eb 40                	jmp    80046f <getuint+0x65>
	else if (lflag)
  80042f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800433:	74 1e                	je     800453 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	8d 50 04             	lea    0x4(%eax),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	89 10                	mov    %edx,(%eax)
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	8b 00                	mov    (%eax),%eax
  800447:	83 e8 04             	sub    $0x4,%eax
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	ba 00 00 00 00       	mov    $0x0,%edx
  800451:	eb 1c                	jmp    80046f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 04             	lea    0x4(%eax),%edx
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	83 e8 04             	sub    $0x4,%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80046f:	5d                   	pop    %ebp
  800470:	c3                   	ret    

00800471 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800474:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800478:	7e 1c                	jle    800496 <getint+0x25>
		return va_arg(*ap, long long);
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	8d 50 08             	lea    0x8(%eax),%edx
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	89 10                	mov    %edx,(%eax)
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	83 e8 08             	sub    $0x8,%eax
  80048f:	8b 50 04             	mov    0x4(%eax),%edx
  800492:	8b 00                	mov    (%eax),%eax
  800494:	eb 40                	jmp    8004d6 <getint+0x65>
	else if (lflag)
  800496:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049a:	74 1e                	je     8004ba <getint+0x49>
		return va_arg(*ap, long);
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 50 04             	lea    0x4(%eax),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	89 10                	mov    %edx,(%eax)
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	83 e8 04             	sub    $0x4,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 c2                	mov    %eax,%edx
  8004b5:	c1 fa 1f             	sar    $0x1f,%edx
  8004b8:	eb 1c                	jmp    8004d6 <getint+0x65>
	else
		return va_arg(*ap, int);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	89 c2                	mov    %eax,%edx
  8004d3:	c1 fa 1f             	sar    $0x1f,%edx
}
  8004d6:	5d                   	pop    %ebp
  8004d7:	c3                   	ret    

008004d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	56                   	push   %esi
  8004dc:	53                   	push   %ebx
  8004dd:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e0:	eb 17                	jmp    8004f9 <vprintfmt+0x21>
			if (ch == '\0')
  8004e2:	85 db                	test   %ebx,%ebx
  8004e4:	0f 84 d1 05 00 00    	je     800abb <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f1:	89 1c 24             	mov    %ebx,(%esp)
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fc:	0f b6 00             	movzbl (%eax),%eax
  8004ff:	0f b6 d8             	movzbl %al,%ebx
  800502:	83 fb 25             	cmp    $0x25,%ebx
  800505:	0f 95 c0             	setne  %al
  800508:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  80050c:	84 c0                	test   %al,%al
  80050e:	75 d2                	jne    8004e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800510:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800514:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80051b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800522:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800529:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800530:	eb 04                	jmp    800536 <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800532:	90                   	nop
  800533:	eb 01                	jmp    800536 <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800535:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800536:	8b 45 10             	mov    0x10(%ebp),%eax
  800539:	0f b6 00             	movzbl (%eax),%eax
  80053c:	0f b6 d8             	movzbl %al,%ebx
  80053f:	89 d8                	mov    %ebx,%eax
  800541:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800545:	83 e8 23             	sub    $0x23,%eax
  800548:	83 f8 55             	cmp    $0x55,%eax
  80054b:	0f 87 39 05 00 00    	ja     800a8a <vprintfmt+0x5b2>
  800551:	8b 04 85 04 31 80 00 	mov    0x803104(,%eax,4),%eax
  800558:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80055a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80055e:	eb d6                	jmp    800536 <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800560:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800564:	eb d0                	jmp    800536 <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800566:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80056d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800570:	89 d0                	mov    %edx,%eax
  800572:	c1 e0 02             	shl    $0x2,%eax
  800575:	01 d0                	add    %edx,%eax
  800577:	01 c0                	add    %eax,%eax
  800579:	01 d8                	add    %ebx,%eax
  80057b:	83 e8 30             	sub    $0x30,%eax
  80057e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800581:	8b 45 10             	mov    0x10(%ebp),%eax
  800584:	0f b6 00             	movzbl (%eax),%eax
  800587:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80058a:	83 fb 2f             	cmp    $0x2f,%ebx
  80058d:	7e 43                	jle    8005d2 <vprintfmt+0xfa>
  80058f:	83 fb 39             	cmp    $0x39,%ebx
  800592:	7f 3e                	jg     8005d2 <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800594:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800598:	eb d3                	jmp    80056d <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	83 c0 04             	add    $0x4,%eax
  8005a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	83 e8 04             	sub    $0x4,%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005ae:	eb 23                	jmp    8005d3 <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  8005b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b4:	0f 89 78 ff ff ff    	jns    800532 <vprintfmt+0x5a>
				width = 0;
  8005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005c1:	e9 6c ff ff ff       	jmp    800532 <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  8005c6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005cd:	e9 64 ff ff ff       	jmp    800536 <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005d2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d7:	0f 89 58 ff ff ff    	jns    800535 <vprintfmt+0x5d>
				width = precision, precision = -1;
  8005dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005ea:	e9 46 ff ff ff       	jmp    800535 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ef:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  8005f3:	e9 3e ff ff ff       	jmp    800536 <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	83 c0 04             	add    $0x4,%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	83 e8 04             	sub    $0x4,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800610:	89 04 24             	mov    %eax,(%esp)
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	ff d0                	call   *%eax
			break;
  800618:	e9 98 04 00 00       	jmp    800ab5 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  80061d:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  800624:	00 
  800625:	8b 45 10             	mov    0x10(%ebp),%eax
  800628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062c:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80062f:	89 04 24             	mov    %eax,(%esp)
  800632:	e8 d1 07 00 00       	call   800e08 <memmove>
            sel_c[3] = '\0';
  800637:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  80063b:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  80063f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800643:	3c 2f                	cmp    $0x2f,%al
  800645:	7e 4c                	jle    800693 <vprintfmt+0x1bb>
  800647:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80064b:	3c 39                	cmp    $0x39,%al
  80064d:	7f 44                	jg     800693 <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  80064f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800653:	0f be d0             	movsbl %al,%edx
  800656:	89 d0                	mov    %edx,%eax
  800658:	c1 e0 02             	shl    $0x2,%eax
  80065b:	01 d0                	add    %edx,%eax
  80065d:	01 c0                	add    %eax,%eax
  80065f:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800665:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  800669:	0f be c0             	movsbl %al,%eax
  80066c:	01 c2                	add    %eax,%edx
  80066e:	89 d0                	mov    %edx,%eax
  800670:	c1 e0 02             	shl    $0x2,%eax
  800673:	01 d0                	add    %edx,%eax
  800675:	01 c0                	add    %eax,%eax
  800677:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  80067d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  800681:	0f be c0             	movsbl %al,%eax
  800684:	01 d0                	add    %edx,%eax
  800686:	83 e8 30             	sub    $0x30,%eax
  800689:	a3 04 60 80 00       	mov    %eax,0x806004
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80068e:	e9 22 04 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  800693:	c7 44 24 04 cd 30 80 	movl   $0x8030cd,0x4(%esp)
  80069a:	00 
  80069b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80069e:	89 04 24             	mov    %eax,(%esp)
  8006a1:	e8 36 06 00 00       	call   800cdc <strcmp>
  8006a6:	85 c0                	test   %eax,%eax
  8006a8:	75 0f                	jne    8006b9 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  8006aa:	c7 05 04 60 80 00 07 	movl   $0x7,0x806004
  8006b1:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006b4:	e9 fc 03 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  8006b9:	c7 44 24 04 d1 30 80 	movl   $0x8030d1,0x4(%esp)
  8006c0:	00 
  8006c1:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006c4:	89 04 24             	mov    %eax,(%esp)
  8006c7:	e8 10 06 00 00       	call   800cdc <strcmp>
  8006cc:	85 c0                	test   %eax,%eax
  8006ce:	75 0f                	jne    8006df <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  8006d0:	c7 05 04 60 80 00 01 	movl   $0x1,0x806004
  8006d7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006da:	e9 d6 03 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  8006df:	c7 44 24 04 d5 30 80 	movl   $0x8030d5,0x4(%esp)
  8006e6:	00 
  8006e7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006ea:	89 04 24             	mov    %eax,(%esp)
  8006ed:	e8 ea 05 00 00       	call   800cdc <strcmp>
  8006f2:	85 c0                	test   %eax,%eax
  8006f4:	75 0f                	jne    800705 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  8006f6:	c7 05 04 60 80 00 02 	movl   $0x2,0x806004
  8006fd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800700:	e9 b0 03 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  800705:	c7 44 24 04 d9 30 80 	movl   $0x8030d9,0x4(%esp)
  80070c:	00 
  80070d:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800710:	89 04 24             	mov    %eax,(%esp)
  800713:	e8 c4 05 00 00       	call   800cdc <strcmp>
  800718:	85 c0                	test   %eax,%eax
  80071a:	75 0f                	jne    80072b <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  80071c:	c7 05 04 60 80 00 04 	movl   $0x4,0x806004
  800723:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800726:	e9 8a 03 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  80072b:	c7 44 24 04 dd 30 80 	movl   $0x8030dd,0x4(%esp)
  800732:	00 
  800733:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800736:	89 04 24             	mov    %eax,(%esp)
  800739:	e8 9e 05 00 00       	call   800cdc <strcmp>
  80073e:	85 c0                	test   %eax,%eax
  800740:	75 0f                	jne    800751 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  800742:	c7 05 04 60 80 00 08 	movl   $0x8,0x806004
  800749:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80074c:	e9 64 03 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  800751:	c7 44 24 04 e1 30 80 	movl   $0x8030e1,0x4(%esp)
  800758:	00 
  800759:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80075c:	89 04 24             	mov    %eax,(%esp)
  80075f:	e8 78 05 00 00       	call   800cdc <strcmp>
  800764:	85 c0                	test   %eax,%eax
  800766:	75 0f                	jne    800777 <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  800768:	c7 05 04 60 80 00 0f 	movl   $0xf,0x806004
  80076f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800772:	e9 3e 03 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  800777:	c7 44 24 04 e5 30 80 	movl   $0x8030e5,0x4(%esp)
  80077e:	00 
  80077f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800782:	89 04 24             	mov    %eax,(%esp)
  800785:	e8 52 05 00 00       	call   800cdc <strcmp>
  80078a:	85 c0                	test   %eax,%eax
  80078c:	75 0f                	jne    80079d <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  80078e:	c7 05 04 60 80 00 0c 	movl   $0xc,0x806004
  800795:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800798:	e9 18 03 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  80079d:	c7 44 24 04 e9 30 80 	movl   $0x8030e9,0x4(%esp)
  8007a4:	00 
  8007a5:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007a8:	89 04 24             	mov    %eax,(%esp)
  8007ab:	e8 2c 05 00 00       	call   800cdc <strcmp>
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	75 0f                	jne    8007c3 <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  8007b4:	c7 05 04 60 80 00 06 	movl   $0x6,0x806004
  8007bb:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007be:	e9 f2 02 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  8007c3:	c7 44 24 04 ed 30 80 	movl   $0x8030ed,0x4(%esp)
  8007ca:	00 
  8007cb:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007ce:	89 04 24             	mov    %eax,(%esp)
  8007d1:	e8 06 05 00 00       	call   800cdc <strcmp>
  8007d6:	85 c0                	test   %eax,%eax
  8007d8:	75 0f                	jne    8007e9 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  8007da:	c7 05 04 60 80 00 0b 	movl   $0xb,0x806004
  8007e1:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007e4:	e9 cc 02 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  8007e9:	c7 05 04 60 80 00 07 	movl   $0x7,0x806004
  8007f0:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007f3:	e9 bd 02 00 00       	jmp    800ab5 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800809:	85 db                	test   %ebx,%ebx
  80080b:	79 02                	jns    80080f <vprintfmt+0x337>
				err = -err;
  80080d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80080f:	83 fb 0e             	cmp    $0xe,%ebx
  800812:	7f 0b                	jg     80081f <vprintfmt+0x347>
  800814:	8b 34 9d 80 30 80 00 	mov    0x803080(,%ebx,4),%esi
  80081b:	85 f6                	test   %esi,%esi
  80081d:	75 23                	jne    800842 <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  80081f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800823:	c7 44 24 08 f1 30 80 	movl   $0x8030f1,0x8(%esp)
  80082a:	00 
  80082b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	89 04 24             	mov    %eax,(%esp)
  800838:	e8 86 02 00 00       	call   800ac3 <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80083d:	e9 73 02 00 00       	jmp    800ab5 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800842:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800846:	c7 44 24 08 fa 30 80 	movl   $0x8030fa,0x8(%esp)
  80084d:	00 
  80084e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800851:	89 44 24 04          	mov    %eax,0x4(%esp)
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	89 04 24             	mov    %eax,(%esp)
  80085b:	e8 63 02 00 00       	call   800ac3 <printfmt>
			break;
  800860:	e9 50 02 00 00       	jmp    800ab5 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	83 c0 04             	add    $0x4,%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	83 e8 04             	sub    $0x4,%eax
  800874:	8b 30                	mov    (%eax),%esi
  800876:	85 f6                	test   %esi,%esi
  800878:	75 05                	jne    80087f <vprintfmt+0x3a7>
				p = "(null)";
  80087a:	be fd 30 80 00       	mov    $0x8030fd,%esi
			if (width > 0 && padc != '-')
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7e 73                	jle    8008f8 <vprintfmt+0x420>
  800885:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800889:	74 6d                	je     8008f8 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  80088b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800892:	89 34 24             	mov    %esi,(%esp)
  800895:	e8 4c 03 00 00       	call   800be6 <strnlen>
  80089a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80089d:	eb 17                	jmp    8008b6 <vprintfmt+0x3de>
					putch(padc, putdat);
  80089f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008aa:	89 04 24             	mov    %eax,(%esp)
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7f e3                	jg     80089f <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bc:	eb 3a                	jmp    8008f8 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  8008be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008c2:	74 1f                	je     8008e3 <vprintfmt+0x40b>
  8008c4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008c7:	7e 05                	jle    8008ce <vprintfmt+0x3f6>
  8008c9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008cc:	7e 15                	jle    8008e3 <vprintfmt+0x40b>
					putch('?', putdat);
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	ff d0                	call   *%eax
  8008e1:	eb 0f                	jmp    8008f2 <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  8008e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ea:	89 1c 24             	mov    %ebx,(%esp)
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008f6:	eb 01                	jmp    8008f9 <vprintfmt+0x421>
  8008f8:	90                   	nop
  8008f9:	0f b6 06             	movzbl (%esi),%eax
  8008fc:	0f be d8             	movsbl %al,%ebx
  8008ff:	85 db                	test   %ebx,%ebx
  800901:	0f 95 c0             	setne  %al
  800904:	83 c6 01             	add    $0x1,%esi
  800907:	84 c0                	test   %al,%al
  800909:	74 29                	je     800934 <vprintfmt+0x45c>
  80090b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80090f:	78 ad                	js     8008be <vprintfmt+0x3e6>
  800911:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800915:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800919:	79 a3                	jns    8008be <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091b:	eb 17                	jmp    800934 <vprintfmt+0x45c>
				putch(' ', putdat);
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	89 44 24 04          	mov    %eax,0x4(%esp)
  800924:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800930:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e3                	jg     80091d <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  80093a:	e9 76 01 00 00       	jmp    800ab5 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800942:	89 44 24 04          	mov    %eax,0x4(%esp)
  800946:	8d 45 14             	lea    0x14(%ebp),%eax
  800949:	89 04 24             	mov    %eax,(%esp)
  80094c:	e8 20 fb ff ff       	call   800471 <getint>
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	79 26                	jns    800987 <vprintfmt+0x4af>
				putch('-', putdat);
  800961:	8b 45 0c             	mov    0xc(%ebp),%eax
  800964:	89 44 24 04          	mov    %eax,0x4(%esp)
  800968:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
				num = -(long long) num;
  800974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097a:	f7 d8                	neg    %eax
  80097c:	83 d2 00             	adc    $0x0,%edx
  80097f:	f7 da                	neg    %edx
  800981:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800984:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800987:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098e:	e9 ae 00 00 00       	jmp    800a41 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800993:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800996:	89 44 24 04          	mov    %eax,0x4(%esp)
  80099a:	8d 45 14             	lea    0x14(%ebp),%eax
  80099d:	89 04 24             	mov    %eax,(%esp)
  8009a0:	e8 65 fa ff ff       	call   80040a <getuint>
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 8a 00 00 00       	jmp    800a41 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  8009b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009be:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c1:	89 04 24             	mov    %eax,(%esp)
  8009c4:	e8 41 fa ff ff       	call   80040a <getuint>
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  8009cf:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  8009d6:	eb 69                	jmp    800a41 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8009d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009df:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	ff d0                	call   *%eax
			putch('x', putdat);
  8009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 e8 04             	sub    $0x4,%eax
  800a0d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a19:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a20:	eb 1f                	jmp    800a41 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a29:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2c:	89 04 24             	mov    %eax,(%esp)
  800a2f:	e8 d6 f9 ff ff       	call   80040a <getuint>
  800a34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a41:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a48:	89 54 24 18          	mov    %edx,0x18(%esp)
  800a4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a4f:	89 54 24 14          	mov    %edx,0x14(%esp)
  800a53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a61:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	89 04 24             	mov    %eax,(%esp)
  800a72:	e8 b5 f8 ff ff       	call   80032c <printnum>
			break;
  800a77:	eb 3c                	jmp    800ab5 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a80:	89 1c 24             	mov    %ebx,(%esp)
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	ff d0                	call   *%eax
			break;
  800a88:	eb 2b                	jmp    800ab5 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a91:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a9d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800aa1:	eb 04                	jmp    800aa7 <vprintfmt+0x5cf>
  800aa3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800aa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aaa:	83 e8 01             	sub    $0x1,%eax
  800aad:	0f b6 00             	movzbl (%eax),%eax
  800ab0:	3c 25                	cmp    $0x25,%al
  800ab2:	75 ef                	jne    800aa3 <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800ab4:	90                   	nop
		}
	}
  800ab5:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab6:	e9 3e fa ff ff       	jmp    8004f9 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800abb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800abc:	83 c4 50             	add    $0x50,%esp
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac9:	8d 45 10             	lea    0x10(%ebp),%eax
  800acc:	83 c0 04             	add    $0x4,%eax
  800acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800adc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	89 04 24             	mov    %eax,(%esp)
  800aed:	e8 e6 f9 ff ff       	call   8004d8 <vprintfmt>
	va_end(ap);
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8b 40 08             	mov    0x8(%eax),%eax
  800afd:	8d 50 01             	lea    0x1(%eax),%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 10                	mov    (%eax),%edx
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 40 04             	mov    0x4(%eax),%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	73 12                	jae    800b27 <sprintputch+0x33>
		*b->buf++ = ch;
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1d:	88 10                	mov    %dl,(%eax)
  800b1f:	8d 50 01             	lea    0x1(%eax),%edx
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	89 10                	mov    %edx,(%eax)
}
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	83 e8 01             	sub    $0x1,%eax
  800b3b:	03 45 08             	add    0x8(%ebp),%eax
  800b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4c:	74 06                	je     800b54 <vsnprintf+0x2b>
  800b4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b52:	7f 07                	jg     800b5b <vsnprintf+0x32>
		return -E_INVAL;
  800b54:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b59:	eb 2a                	jmp    800b85 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b69:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b70:	c7 04 24 f4 0a 80 00 	movl   $0x800af4,(%esp)
  800b77:	e8 5c f9 ff ff       	call   8004d8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b90:	83 c0 04             	add    $0x4,%eax
  800b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b96:	8b 45 10             	mov    0x10(%ebp),%eax
  800b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ba0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 04 24             	mov    %eax,(%esp)
  800bb1:	e8 73 ff ff ff       	call   800b29 <vsnprintf>
  800bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    
	...

00800bc0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcd:	eb 08                	jmp    800bd7 <strlen+0x17>
		n++;
  800bcf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	0f b6 00             	movzbl (%eax),%eax
  800bdd:	84 c0                	test   %al,%al
  800bdf:	75 ee                	jne    800bcf <strlen+0xf>
		n++;
	return n;
  800be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf3:	eb 0c                	jmp    800c01 <strnlen+0x1b>
		n++;
  800bf5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bfd:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 0a                	je     800c11 <strnlen+0x2b>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	0f b6 00             	movzbl (%eax),%eax
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 e4                	jne    800bf5 <strnlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c22:	90                   	nop
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	0f b6 10             	movzbl (%eax),%edx
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	88 10                	mov    %dl,(%eax)
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	0f b6 00             	movzbl (%eax),%eax
  800c34:	84 c0                	test   %al,%al
  800c36:	0f 95 c0             	setne  %al
  800c39:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c3d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800c41:	84 c0                	test   %al,%al
  800c43:	75 de                	jne    800c23 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5d:	eb 21                	jmp    800c80 <strncpy+0x36>
		*dst++ = *src;
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	0f b6 10             	movzbl (%eax),%edx
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	88 10                	mov    %dl,(%eax)
  800c6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	0f b6 00             	movzbl (%eax),%eax
  800c74:	84 c0                	test   %al,%al
  800c76:	74 04                	je     800c7c <strncpy+0x32>
			src++;
  800c78:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c86:	72 d7                	jb     800c5f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9d:	74 2f                	je     800cce <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800c9f:	eb 13                	jmp    800cb4 <strlcpy+0x27>
			*dst++ = *src++;
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	0f b6 10             	movzbl (%eax),%edx
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	88 10                	mov    %dl,(%eax)
  800cac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cb0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800cb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbc:	74 0a                	je     800cc8 <strlcpy+0x3b>
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	0f b6 00             	movzbl (%eax),%eax
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 d9                	jne    800ca1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd4:	89 d1                	mov    %edx,%ecx
  800cd6:	29 c1                	sub    %eax,%ecx
  800cd8:	89 c8                	mov    %ecx,%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cdf:	eb 08                	jmp    800ce9 <strcmp+0xd>
		p++, q++;
  800ce1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ce5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	0f b6 00             	movzbl (%eax),%eax
  800cef:	84 c0                	test   %al,%al
  800cf1:	74 10                	je     800d03 <strcmp+0x27>
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	0f b6 10             	movzbl (%eax),%edx
  800cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfc:	0f b6 00             	movzbl (%eax),%eax
  800cff:	38 c2                	cmp    %al,%dl
  800d01:	74 de                	je     800ce1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	0f b6 00             	movzbl (%eax),%eax
  800d09:	0f b6 d0             	movzbl %al,%edx
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	0f b6 00             	movzbl (%eax),%eax
  800d12:	0f b6 c0             	movzbl %al,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	29 c1                	sub    %eax,%ecx
  800d19:	89 c8                	mov    %ecx,%eax
}
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d20:	eb 0c                	jmp    800d2e <strncmp+0x11>
		n--, p++, q++;
  800d22:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d26:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d2a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d32:	74 1a                	je     800d4e <strncmp+0x31>
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	0f b6 00             	movzbl (%eax),%eax
  800d3a:	84 c0                	test   %al,%al
  800d3c:	74 10                	je     800d4e <strncmp+0x31>
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	0f b6 10             	movzbl (%eax),%edx
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	0f b6 00             	movzbl (%eax),%eax
  800d4a:	38 c2                	cmp    %al,%dl
  800d4c:	74 d4                	je     800d22 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d52:	75 07                	jne    800d5b <strncmp+0x3e>
		return 0;
  800d54:	b8 00 00 00 00       	mov    $0x0,%eax
  800d59:	eb 18                	jmp    800d73 <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	0f b6 00             	movzbl (%eax),%eax
  800d61:	0f b6 d0             	movzbl %al,%edx
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	0f b6 00             	movzbl (%eax),%eax
  800d6a:	0f b6 c0             	movzbl %al,%eax
  800d6d:	89 d1                	mov    %edx,%ecx
  800d6f:	29 c1                	sub    %eax,%ecx
  800d71:	89 c8                	mov    %ecx,%eax
}
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 04             	sub    $0x4,%esp
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d81:	eb 14                	jmp    800d97 <strchr+0x22>
		if (*s == c)
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	0f b6 00             	movzbl (%eax),%eax
  800d89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8c:	75 05                	jne    800d93 <strchr+0x1e>
			return (char *) s;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	eb 13                	jmp    800da6 <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	0f b6 00             	movzbl (%eax),%eax
  800d9d:	84 c0                	test   %al,%al
  800d9f:	75 e2                	jne    800d83 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 04             	sub    $0x4,%esp
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db4:	eb 0f                	jmp    800dc5 <strfind+0x1d>
		if (*s == c)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	0f b6 00             	movzbl (%eax),%eax
  800dbc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dbf:	74 10                	je     800dd1 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	0f b6 00             	movzbl (%eax),%eax
  800dcb:	84 c0                	test   %al,%al
  800dcd:	75 e7                	jne    800db6 <strfind+0xe>
  800dcf:	eb 01                	jmp    800dd2 <strfind+0x2a>
		if (*s == c)
			break;
  800dd1:	90                   	nop
	return (char *) s;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <memset>:


void *
memset(void *v, int c, size_t n)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de9:	eb 0e                	jmp    800df9 <memset+0x22>
		*p++ = c;
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	89 c2                	mov    %eax,%edx
  800df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df3:	88 10                	mov    %dl,(%eax)
  800df5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df9:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800dfd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e01:	79 e8                	jns    800deb <memset+0x14>
		*p++ = c;

	return v;
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e20:	73 54                	jae    800e76 <memmove+0x6e>
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e28:	01 d0                	add    %edx,%eax
  800e2a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2d:	76 47                	jbe    800e76 <memmove+0x6e>
		s += n;
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e35:	8b 45 10             	mov    0x10(%ebp),%eax
  800e38:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3b:	eb 13                	jmp    800e50 <memmove+0x48>
			*--d = *--s;
  800e3d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800e41:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e48:	0f b6 10             	movzbl (%eax),%edx
  800e4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e54:	0f 95 c0             	setne  %al
  800e57:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 de                	jne    800e3d <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e5f:	eb 25                	jmp    800e86 <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e64:	0f b6 10             	movzbl (%eax),%edx
  800e67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6a:	88 10                	mov    %dl,(%eax)
  800e6c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800e70:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e74:	eb 01                	jmp    800e77 <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e76:	90                   	nop
  800e77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7b:	0f 95 c0             	setne  %al
  800e7e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e82:	84 c0                	test   %al,%al
  800e84:	75 db                	jne    800e61 <memmove+0x59>
			*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	89 04 24             	mov    %eax,(%esp)
  800ea5:	e8 5e ff ff ff       	call   800e08 <memmove>
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ebe:	eb 32                	jmp    800ef2 <memcmp+0x46>
		if (*s1 != *s2)
  800ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec3:	0f b6 10             	movzbl (%eax),%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	0f b6 00             	movzbl (%eax),%eax
  800ecc:	38 c2                	cmp    %al,%dl
  800ece:	74 1a                	je     800eea <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	0f b6 00             	movzbl (%eax),%eax
  800ed6:	0f b6 d0             	movzbl %al,%edx
  800ed9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edc:	0f b6 00             	movzbl (%eax),%eax
  800edf:	0f b6 c0             	movzbl %al,%eax
  800ee2:	89 d1                	mov    %edx,%ecx
  800ee4:	29 c1                	sub    %eax,%ecx
  800ee6:	89 c8                	mov    %ecx,%eax
  800ee8:	eb 1c                	jmp    800f06 <memcmp+0x5a>
		s1++, s2++;
  800eea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800eee:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	0f 95 c0             	setne  %al
  800ef9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800efd:	84 c0                	test   %al,%al
  800eff:	75 bf                	jne    800ec0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	01 d0                	add    %edx,%eax
  800f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f19:	eb 11                	jmp    800f2c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	0f b6 10             	movzbl (%eax),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	38 c2                	cmp    %al,%dl
  800f26:	74 0e                	je     800f36 <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f28:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f32:	72 e7                	jb     800f1b <memfind+0x13>
  800f34:	eb 01                	jmp    800f37 <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f36:	90                   	nop
	return (void *) s;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f50:	eb 04                	jmp    800f56 <strtol+0x1a>
		s++;
  800f52:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	0f b6 00             	movzbl (%eax),%eax
  800f5c:	3c 20                	cmp    $0x20,%al
  800f5e:	74 f2                	je     800f52 <strtol+0x16>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	0f b6 00             	movzbl (%eax),%eax
  800f66:	3c 09                	cmp    $0x9,%al
  800f68:	74 e8                	je     800f52 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	0f b6 00             	movzbl (%eax),%eax
  800f70:	3c 2b                	cmp    $0x2b,%al
  800f72:	75 06                	jne    800f7a <strtol+0x3e>
		s++;
  800f74:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f78:	eb 15                	jmp    800f8f <strtol+0x53>
	else if (*s == '-')
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	0f b6 00             	movzbl (%eax),%eax
  800f80:	3c 2d                	cmp    $0x2d,%al
  800f82:	75 0b                	jne    800f8f <strtol+0x53>
		s++, neg = 1;
  800f84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f88:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f93:	74 06                	je     800f9b <strtol+0x5f>
  800f95:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f99:	75 24                	jne    800fbf <strtol+0x83>
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	0f b6 00             	movzbl (%eax),%eax
  800fa1:	3c 30                	cmp    $0x30,%al
  800fa3:	75 1a                	jne    800fbf <strtol+0x83>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	83 c0 01             	add    $0x1,%eax
  800fab:	0f b6 00             	movzbl (%eax),%eax
  800fae:	3c 78                	cmp    $0x78,%al
  800fb0:	75 0d                	jne    800fbf <strtol+0x83>
		s += 2, base = 16;
  800fb2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbd:	eb 2a                	jmp    800fe9 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  800fbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc3:	75 17                	jne    800fdc <strtol+0xa0>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	0f b6 00             	movzbl (%eax),%eax
  800fcb:	3c 30                	cmp    $0x30,%al
  800fcd:	75 0d                	jne    800fdc <strtol+0xa0>
		s++, base = 8;
  800fcf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fd3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fda:	eb 0d                	jmp    800fe9 <strtol+0xad>
	else if (base == 0)
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 07                	jne    800fe9 <strtol+0xad>
		base = 10;
  800fe2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	0f b6 00             	movzbl (%eax),%eax
  800fef:	3c 2f                	cmp    $0x2f,%al
  800ff1:	7e 1b                	jle    80100e <strtol+0xd2>
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	0f b6 00             	movzbl (%eax),%eax
  800ff9:	3c 39                	cmp    $0x39,%al
  800ffb:	7f 11                	jg     80100e <strtol+0xd2>
			dig = *s - '0';
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	0f b6 00             	movzbl (%eax),%eax
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 48                	jmp    801056 <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	0f b6 00             	movzbl (%eax),%eax
  801014:	3c 60                	cmp    $0x60,%al
  801016:	7e 1b                	jle    801033 <strtol+0xf7>
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	0f b6 00             	movzbl (%eax),%eax
  80101e:	3c 7a                	cmp    $0x7a,%al
  801020:	7f 11                	jg     801033 <strtol+0xf7>
			dig = *s - 'a' + 10;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	0f b6 00             	movzbl (%eax),%eax
  801028:	0f be c0             	movsbl %al,%eax
  80102b:	83 e8 57             	sub    $0x57,%eax
  80102e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801031:	eb 23                	jmp    801056 <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	0f b6 00             	movzbl (%eax),%eax
  801039:	3c 40                	cmp    $0x40,%al
  80103b:	7e 38                	jle    801075 <strtol+0x139>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	0f b6 00             	movzbl (%eax),%eax
  801043:	3c 5a                	cmp    $0x5a,%al
  801045:	7f 2e                	jg     801075 <strtol+0x139>
			dig = *s - 'A' + 10;
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	0f b6 00             	movzbl (%eax),%eax
  80104d:	0f be c0             	movsbl %al,%eax
  801050:	83 e8 37             	sub    $0x37,%eax
  801053:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801059:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105c:	7d 16                	jge    801074 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  80105e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	03 45 f4             	add    -0xc(%ebp),%eax
  80106c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106f:	e9 75 ff ff ff       	jmp    800fe9 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801074:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801075:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801079:	74 08                	je     801083 <strtol+0x147>
		*endptr = (char *) s;
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8b 55 08             	mov    0x8(%ebp),%edx
  801081:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801083:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801087:	74 07                	je     801090 <strtol+0x154>
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108c:	f7 d8                	neg    %eax
  80108e:	eb 03                	jmp    801093 <strtol+0x157>
  801090:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    
  801095:	00 00                	add    %al,(%eax)
	...

00801098 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	57                   	push   %edi
  80109c:	56                   	push   %esi
  80109d:	53                   	push   %ebx
  80109e:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8010a7:	8b 55 10             	mov    0x10(%ebp),%edx
  8010aa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8010ad:	8b 5d 18             	mov    0x18(%ebp),%ebx
  8010b0:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  8010b3:	8b 75 20             	mov    0x20(%ebp),%esi
  8010b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b9:	cd 30                	int    $0x30
  8010bb:	89 c3                	mov    %eax,%ebx
  8010bd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010c4:	74 30                	je     8010f6 <syscall+0x5e>
  8010c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ca:	7e 2a                	jle    8010f6 <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010cf:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010da:	c7 44 24 08 5c 32 80 	movl   $0x80325c,0x8(%esp)
  8010e1:	00 
  8010e2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e9:	00 
  8010ea:	c7 04 24 79 32 80 00 	movl   $0x803279,(%esp)
  8010f1:	e8 da f0 ff ff       	call   8001d0 <_panic>

	return ret;
  8010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8010f9:	83 c4 4c             	add    $0x4c,%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	5f                   	pop    %edi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801111:	00 
  801112:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801119:	00 
  80111a:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801121:	00 
  801122:	8b 55 0c             	mov    0xc(%ebp),%edx
  801125:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801129:	89 44 24 08          	mov    %eax,0x8(%esp)
  80112d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801134:	00 
  801135:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80113c:	e8 57 ff ff ff       	call   801098 <syscall>
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <sys_cgetc>:

int
sys_cgetc(void)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801149:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801150:	00 
  801151:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801158:	00 
  801159:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801160:	00 
  801161:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801168:	00 
  801169:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801170:	00 
  801171:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801178:	00 
  801179:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801180:	e8 13 ff ff ff       	call   801098 <syscall>
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801197:	00 
  801198:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80119f:	00 
  8011a0:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011a7:	00 
  8011a8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011af:	00 
  8011b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011bb:	00 
  8011bc:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8011c3:	e8 d0 fe ff ff       	call   801098 <syscall>
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8011d0:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8011d7:	00 
  8011d8:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8011df:	00 
  8011e0:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011e7:	00 
  8011e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011ef:	00 
  8011f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011f7:	00 
  8011f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011ff:	00 
  801200:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801207:	e8 8c fe ff ff       	call   801098 <syscall>
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <sys_yield>:

void
sys_yield(void)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801214:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80121b:	00 
  80121c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801223:	00 
  801224:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80122b:	00 
  80122c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801233:	00 
  801234:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80123b:	00 
  80123c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801243:	00 
  801244:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  80124b:	e8 48 fe ff ff       	call   801098 <syscall>
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801258:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80125b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801268:	00 
  801269:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801270:	00 
  801271:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801275:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801279:	89 44 24 08          	mov    %eax,0x8(%esp)
  80127d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801284:	00 
  801285:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  80128c:	e8 07 fe ff ff       	call   801098 <syscall>
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	56                   	push   %esi
  801297:	53                   	push   %ebx
  801298:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80129b:	8b 75 18             	mov    0x18(%ebp),%esi
  80129e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	89 74 24 18          	mov    %esi,0x18(%esp)
  8012ae:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8012b2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8012b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012c5:	00 
  8012c6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8012cd:	e8 c6 fd ff ff       	call   801098 <syscall>
}
  8012d2:	83 c4 20             	add    $0x20,%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5d                   	pop    %ebp
  8012d8:	c3                   	ret    

008012d9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8012df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012ec:	00 
  8012ed:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012f4:	00 
  8012f5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012fc:	00 
  8012fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801301:	89 44 24 08          	mov    %eax,0x8(%esp)
  801305:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80130c:	00 
  80130d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  801314:	e8 7f fd ff ff       	call   801098 <syscall>
}
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80132e:	00 
  80132f:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801336:	00 
  801337:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80133e:	00 
  80133f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801343:	89 44 24 08          	mov    %eax,0x8(%esp)
  801347:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80134e:	00 
  80134f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  801356:	e8 3d fd ff ff       	call   801098 <syscall>
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801363:	8b 55 0c             	mov    0xc(%ebp),%edx
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801370:	00 
  801371:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801378:	00 
  801379:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801380:	00 
  801381:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801385:	89 44 24 08          	mov    %eax,0x8(%esp)
  801389:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801390:	00 
  801391:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  801398:	e8 fb fc ff ff       	call   801098 <syscall>
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8013a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013b2:	00 
  8013b3:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013ba:	00 
  8013bb:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013c2:	00 
  8013c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013d2:	00 
  8013d3:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  8013da:	e8 b9 fc ff ff       	call   801098 <syscall>
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8013e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013f4:	00 
  8013f5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013fc:	00 
  8013fd:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801404:	00 
  801405:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801409:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801414:	00 
  801415:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80141c:	e8 77 fc ff ff       	call   801098 <syscall>
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801429:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80142c:	8b 55 10             	mov    0x10(%ebp),%edx
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801439:	00 
  80143a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  80143e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801442:	8b 55 0c             	mov    0xc(%ebp),%edx
  801445:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801449:	89 44 24 08          	mov    %eax,0x8(%esp)
  80144d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801454:	00 
  801455:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  80145c:	e8 37 fc ff ff       	call   801098 <syscall>
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801473:	00 
  801474:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80147b:	00 
  80147c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801483:	00 
  801484:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80148b:	00 
  80148c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801490:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801497:	00 
  801498:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  80149f:	e8 f4 fb ff ff       	call   801098 <syscall>
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    
	...

008014a8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 38             	sub    $0x38,%esp
	void *addr = (void *) utf->utf_fault_va;
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8b 00                	mov    (%eax),%eax
  8014b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t err = utf->utf_err;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	8b 40 04             	mov    0x4(%eax),%eax
  8014bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	// LAB 4: Your code here.
	//FEC_WR pf caused by a write
	//
	//if((err & FEC_WR)==0) cprintf("err : %08x\n", err);
	//if((vpt[VPN(addr)] & PTE_COW) == 0) cprintf("pte : %x\n", vpt[VPN(addr)]);
    if((err & FEC_WR) == 0 || (vpd[VPD(addr)] & PTE_P) == 0 || (vpt[VPN(addr)] & PTE_COW) == 0){
  8014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c2:	83 e0 02             	and    $0x2,%eax
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	74 2a                	je     8014f3 <pgfault+0x4b>
  8014c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cc:	c1 e8 16             	shr    $0x16,%eax
  8014cf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014d6:	83 e0 01             	and    $0x1,%eax
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	74 16                	je     8014f3 <pgfault+0x4b>
  8014dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e0:	c1 e8 0c             	shr    $0xc,%eax
  8014e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ea:	25 00 08 00 00       	and    $0x800,%eax
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	75 1c                	jne    80150f <pgfault+0x67>
		//cprintf("\n%e %e %e\n",(err & FEC_WR), (vpd[VPD(addr)] & PTE_P), (vpt[VPN(addr)] & PTE_COW));
		panic("pgfault: not a write or attempting to access a non_COW page\n");
  8014f3:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  8014fa:	00 
  8014fb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  801502:	00 
  801503:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  80150a:	e8 c1 ec ff ff       	call   8001d0 <_panic>
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((r = sys_page_alloc(0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0){
  80150f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801516:	00 
  801517:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80151e:	00 
  80151f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801526:	e8 27 fd ff ff       	call   801252 <sys_page_alloc>
  80152b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80152e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801532:	79 23                	jns    801557 <pgfault+0xaf>
		panic("pgfault page allocation failed : %e\n", r);
  801534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801537:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80153b:	c7 44 24 08 d0 32 80 	movl   $0x8032d0,0x8(%esp)
  801542:	00 
  801543:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  80154a:	00 
  80154b:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  801552:	e8 79 ec ff ff       	call   8001d0 <_panic>
	}
	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80155d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801560:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	memmove(PFTEMP, addr, PGSIZE);
  801568:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80156f:	00 
  801570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801573:	89 44 24 04          	mov    %eax,0x4(%esp)
  801577:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80157e:	e8 85 f8 ff ff       	call   800e08 <memmove>
	
	if((r = sys_page_map(0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0){
  801583:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80158a:	00 
  80158b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801592:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801599:	00 
  80159a:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015a1:	00 
  8015a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a9:	e8 e5 fc ff ff       	call   801293 <sys_page_map>
  8015ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015b5:	79 23                	jns    8015da <pgfault+0x132>
		panic("pgfault: page mapping failed %e\n", r);
  8015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015be:	c7 44 24 08 f8 32 80 	movl   $0x8032f8,0x8(%esp)
  8015c5:	00 
  8015c6:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8015cd:	00 
  8015ce:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  8015d5:	e8 f6 eb ff ff       	call   8001d0 <_panic>
	}
	//panic("pgfault not implemented");
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
// COW's copy
static int
duppage(envid_t envid, unsigned pn)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 38             	sub    $0x38,%esp
	int r;
	void *addr;
	pte_t pte;
    addr = (void *)((uint32_t)pn * PGSIZE);
  8015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e5:	c1 e0 0c             	shl    $0xc,%eax
  8015e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pte = vpt[VPN(addr)];//the pt
  8015eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ee:	c1 e8 0c             	shr    $0xc,%eax
  8015f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    if((pte & PTE_W) > 0||(pte & PTE_COW) > 0){
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	83 e0 02             	and    $0x2,%eax
  801601:	85 c0                	test   %eax,%eax
  801603:	75 10                	jne    801615 <duppage+0x39>
  801605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801608:	25 00 08 00 00       	and    $0x800,%eax
  80160d:	85 c0                	test   %eax,%eax
  80160f:	0f 84 9d 00 00 00    	je     8016b2 <duppage+0xd6>
		//two change ok
		if((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0){
  801615:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80161c:	00 
  80161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801620:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	89 44 24 08          	mov    %eax,0x8(%esp)
  80162b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801632:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801639:	e8 55 fc ff ff       	call   801293 <sys_page_map>
  80163e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801641:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801645:	79 1c                	jns    801663 <duppage+0x87>
			panic("sys page map envid --> 0 failed ,parent copy to child\n");
  801647:	c7 44 24 08 1c 33 80 	movl   $0x80331c,0x8(%esp)
  80164e:	00 
  80164f:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801656:	00 
  801657:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  80165e:	e8 6d eb ff ff       	call   8001d0 <_panic>
			}
		if((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0){
  801663:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80166a:	00 
  80166b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801672:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801679:	00 
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801681:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801688:	e8 06 fc ff ff       	call   801293 <sys_page_map>
  80168d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801690:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801694:	79 6a                	jns    801700 <duppage+0x124>
			panic("sys page map 0 --> 0 failed ,parent copy it self\n");
  801696:	c7 44 24 08 54 33 80 	movl   $0x803354,0x8(%esp)
  80169d:	00 
  80169e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8016a5:	00 
  8016a6:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  8016ad:	e8 1e eb ff ff       	call   8001d0 <_panic>
			}
	}
	else{//the read, can't change  |PTE_COW
		if((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U)) < 0){
  8016b2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8016b9:	00 
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d6:	e8 b8 fb ff ff       	call   801293 <sys_page_map>
  8016db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e2:	79 1c                	jns    801700 <duppage+0x124>
			panic("sys page map envid --> 0 failed ,parent copy to child\n");
  8016e4:	c7 44 24 08 1c 33 80 	movl   $0x80331c,0x8(%esp)
  8016eb:	00 
  8016ec:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  8016f3:	00 
  8016f4:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  8016fb:	e8 d0 ea ff ff       	call   8001d0 <_panic>
			}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	53                   	push   %ebx
  80170b:	83 ec 34             	sub    $0x34,%esp
	// LAB 4: Your code here.
	//
	//set_pgfault_handler
	set_pgfault_handler(pgfault);
  80170e:	c7 04 24 a8 14 80 00 	movl   $0x8014a8,(%esp)
  801715:	e8 76 14 00 00       	call   802b90 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80171a:	c7 45 e4 07 00 00 00 	movl   $0x7,-0x1c(%ebp)
  801721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801724:	cd 30                	int    $0x30
  801726:	89 c3                	mov    %eax,%ebx
  801728:	89 5d e8             	mov    %ebx,-0x18(%ebp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80172b:	8b 45 e8             	mov    -0x18(%ebp),%eax
	//new a child
	envid_t newenv;
	uint32_t addr;
	int r;
	
	newenv = sys_exofork();//new envid
  80172e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("finish create a env %d\n", newenv);
	if(newenv < 0) panic("envid < 0 ,failed in exofork\n");
  801731:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801735:	79 1c                	jns    801753 <fork+0x4c>
  801737:	c7 44 24 08 86 33 80 	movl   $0x803386,0x8(%esp)
  80173e:	00 
  80173f:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  801746:	00 
  801747:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  80174e:	e8 7d ea ff ff       	call   8001d0 <_panic>
	if(newenv == 0){
  801753:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801757:	75 21                	jne    80177a <fork+0x73>
		//ENVX get the id's low 10 bit
		env = &envs[ENVX(sys_getenvid())];
  801759:	e8 6c fa ff ff       	call   8011ca <sys_getenvid>
  80175e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801763:	c1 e0 07             	shl    $0x7,%eax
  801766:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80176b:	a3 40 60 80 00       	mov    %eax,0x806040
		return 0;
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
  801775:	e9 f8 00 00 00       	jmp    801872 <fork+0x16b>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  80177a:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  801781:	eb 58                	jmp    8017db <fork+0xd4>
		/*pte = vpt[VPN(addr)];
		pde = vpd[VPD(addr)];
		if((pde & PTE_P) > 0 && (pte & PTE_P) > 0 && (pte & PTE_U) > 0){
			duppage(newenv, VPN(addr));
			}*/
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
  801783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801786:	c1 e8 16             	shr    $0x16,%eax
  801789:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801790:	83 e0 01             	and    $0x1,%eax
  801793:	84 c0                	test   %al,%al
  801795:	74 3d                	je     8017d4 <fork+0xcd>
  801797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179a:	c1 e8 0c             	shr    $0xc,%eax
  80179d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017a4:	83 e0 01             	and    $0x1,%eax
  8017a7:	84 c0                	test   %al,%al
  8017a9:	74 29                	je     8017d4 <fork+0xcd>
  8017ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ae:	c1 e8 0c             	shr    $0xc,%eax
  8017b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017b8:	83 e0 04             	and    $0x4,%eax
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	74 15                	je     8017d4 <fork+0xcd>
	        duppage (newenv, VPN(addr));
  8017bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c2:	c1 e8 0c             	shr    $0xc,%eax
  8017c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cc:	89 04 24             	mov    %eax,(%esp)
  8017cf:	e8 08 fe ff ff       	call   8015dc <duppage>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  8017d4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8017db:	81 7d f4 ff ef bf ee 	cmpl   $0xeebfefff,-0xc(%ebp)
  8017e2:	76 9f                	jbe    801783 <fork+0x7c>
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
	        duppage (newenv, VPN(addr));
		}
	//cprintf("finish map PGSIZE\n");
	//user exception stack
	if((r = sys_page_alloc(newenv, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0){
  8017e4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8017eb:	00 
  8017ec:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8017f3:	ee 
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f7:	89 04 24             	mov    %eax,(%esp)
  8017fa:	e8 53 fa ff ff       	call   801252 <sys_page_alloc>
  8017ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801802:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801806:	79 1c                	jns    801824 <fork+0x11d>
		panic("fork alloc page failed\n");
  801808:	c7 44 24 08 a4 33 80 	movl   $0x8033a4,0x8(%esp)
  80180f:	00 
  801810:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  801817:	00 
  801818:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  80181f:	e8 ac e9 ff ff       	call   8001d0 <_panic>
		}
	//
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(newenv, _pgfault_upcall);
  801824:	c7 44 24 04 24 2c 80 	movl   $0x802c24,0x4(%esp)
  80182b:	00 
  80182c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182f:	89 04 24             	mov    %eax,(%esp)
  801832:	e8 aa fb ff ff       	call   8013e1 <sys_env_set_pgfault_upcall>
	//panic("fork not implemented");
	//set it runable
	if((r = sys_env_set_status(newenv, ENV_RUNNABLE)) < 0){
  801837:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80183e:	00 
  80183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801842:	89 04 24             	mov    %eax,(%esp)
  801845:	e8 13 fb ff ff       	call   80135d <sys_env_set_status>
  80184a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80184d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801851:	79 1c                	jns    80186f <fork+0x168>
		panic("set runnable failed\n");
  801853:	c7 44 24 08 bc 33 80 	movl   $0x8033bc,0x8(%esp)
  80185a:	00 
  80185b:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  801862:	00 
  801863:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  80186a:	e8 61 e9 ff ff       	call   8001d0 <_panic>
		}
	
	return newenv;
  80186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801872:	83 c4 34             	add    $0x34,%esp
  801875:	5b                   	pop    %ebx
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    

00801878 <sduppage>:

// Challenge!

static int
sduppage(envid_t envid, unsigned pn, int need_cow)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 38             	sub    $0x38,%esp
	int r;
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  80187e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801881:	c1 e0 0c             	shl    $0xc,%eax
  801884:	89 45 f4             	mov    %eax,-0xc(%ebp)
	pte_t pte = vpt[VPN(addr)];
  801887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188a:	c1 e8 0c             	shr    $0xc,%eax
  80188d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801894:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(need_cow || (pte & PTE_COW) > 0) {
  801897:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189b:	75 10                	jne    8018ad <sduppage+0x35>
  80189d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a0:	25 00 08 00 00       	and    $0x800,%eax
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	0f 84 af 00 00 00    	je     80195c <sduppage+0xe4>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8018ad:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8018b4:	00 
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d1:	e8 bd f9 ff ff       	call   801293 <sys_page_map>
  8018d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018dd:	79 23                	jns    801902 <sduppage+0x8a>
		    panic ("duppage: page re-mapping failed at 1 : %e", r);
  8018df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018e6:	c7 44 24 08 d4 33 80 	movl   $0x8033d4,0x8(%esp)
  8018ed:	00 
  8018ee:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  8018f5:	00 
  8018f6:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  8018fd:	e8 ce e8 ff ff       	call   8001d0 <_panic>
        if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  801902:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801909:	00 
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801911:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801918:	00 
  801919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801920:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801927:	e8 67 f9 ff ff       	call   801293 <sys_page_map>
  80192c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80192f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801933:	0f 89 d7 00 00 00    	jns    801a10 <sduppage+0x198>
            panic ("duppage: page re-mapping failed at 2 : %e", r);
  801939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801940:	c7 44 24 08 00 34 80 	movl   $0x803400,0x8(%esp)
  801947:	00 
  801948:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  80194f:	00 
  801950:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  801957:	e8 74 e8 ff ff       	call   8001d0 <_panic>
    }else if ((pte & PTE_W) > 0) {
  80195c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195f:	83 e0 02             	and    $0x2,%eax
  801962:	85 c0                	test   %eax,%eax
  801964:	74 55                	je     8019bb <sduppage+0x143>
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_W|PTE_P)) < 0)
  801966:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80196d:	00 
  80196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801971:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 44 24 08          	mov    %eax,0x8(%esp)
  80197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801983:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198a:	e8 04 f9 ff ff       	call   801293 <sys_page_map>
  80198f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801992:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801996:	79 78                	jns    801a10 <sduppage+0x198>
		    panic ("duppage: page re-mapping failed at 3 : %e", r);
  801998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80199f:	c7 44 24 08 2c 34 80 	movl   $0x80342c,0x8(%esp)
  8019a6:	00 
  8019a7:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  8019ae:	00 
  8019af:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  8019b6:	e8 15 e8 ff ff       	call   8001d0 <_panic>
    }else {
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8019bb:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8019c2:	00 
  8019c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019df:	e8 af f8 ff ff       	call   801293 <sys_page_map>
  8019e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019eb:	79 23                	jns    801a10 <sduppage+0x198>
		    panic ("duppage: page re-mapping failed at 4 : %e", r);
  8019ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019f4:	c7 44 24 08 58 34 80 	movl   $0x803458,0x8(%esp)
  8019fb:	00 
  8019fc:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  801a03:	00 
  801a04:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  801a0b:	e8 c0 e7 ff ff       	call   8001d0 <_panic>
    }
    return 0;
  801a10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sfork>:


int
sfork(void)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	53                   	push   %ebx
  801a1b:	83 ec 44             	sub    $0x44,%esp
	//panic("sfork not implemented");
	//set_pgfault_handler
	set_pgfault_handler(pgfault);
  801a1e:	c7 04 24 a8 14 80 00 	movl   $0x8014a8,(%esp)
  801a25:	e8 66 11 00 00       	call   802b90 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801a2a:	c7 45 d4 07 00 00 00 	movl   $0x7,-0x2c(%ebp)
  801a31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a34:	cd 30                	int    $0x30
  801a36:	89 c3                	mov    %eax,%ebx
  801a38:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	//new a child
	envid_t newenv;
	uint32_t addr;
	int r;
	
	newenv = sys_exofork();//new envid
  801a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//cprintf("finish create a env %d\n", newenv);
	if(newenv < 0) panic("envid < 0 ,failed in exofork\n");
  801a41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a45:	79 1c                	jns    801a63 <sfork+0x4c>
  801a47:	c7 44 24 08 86 33 80 	movl   $0x803386,0x8(%esp)
  801a4e:	00 
  801a4f:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  801a56:	00 
  801a57:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  801a5e:	e8 6d e7 ff ff       	call   8001d0 <_panic>
	if(newenv == 0){
  801a63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a67:	75 21                	jne    801a8a <sfork+0x73>
		//ENVX get the id's low 10 bit
		env = &envs[ENVX(sys_getenvid())];
  801a69:	e8 5c f7 ff ff       	call   8011ca <sys_getenvid>
  801a6e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a73:	c1 e0 07             	shl    $0x7,%eax
  801a76:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a7b:	a3 40 60 80 00       	mov    %eax,0x806040
		return 0;
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
  801a85:	e9 11 01 00 00       	jmp    801b9b <sfork+0x184>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	int mark_COW = 1;
  801a8a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  801a91:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  801a98:	eb 6a                	jmp    801b04 <sfork+0xed>
		/*pte = vpt[VPN(addr)];
		pde = vpd[VPD(addr)];
		if((pde & PTE_P) > 0 && (pte & PTE_P) > 0 && (pte & PTE_U) > 0){
			duppage(newenv, VPN(addr));
			}*/
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
  801a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9d:	c1 e8 16             	shr    $0x16,%eax
  801aa0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801aa7:	83 e0 01             	and    $0x1,%eax
  801aaa:	84 c0                	test   %al,%al
  801aac:	74 48                	je     801af6 <sfork+0xdf>
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	c1 e8 0c             	shr    $0xc,%eax
  801ab4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801abb:	83 e0 01             	and    $0x1,%eax
  801abe:	84 c0                	test   %al,%al
  801ac0:	74 34                	je     801af6 <sfork+0xdf>
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	c1 e8 0c             	shr    $0xc,%eax
  801ac8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801acf:	83 e0 04             	and    $0x4,%eax
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	74 20                	je     801af6 <sfork+0xdf>
	        sduppage (newenv, VPN(addr), mark_COW);
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	89 c2                	mov    %eax,%edx
  801adb:	c1 ea 0c             	shr    $0xc,%edx
  801ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aec:	89 04 24             	mov    %eax,(%esp)
  801aef:	e8 84 fd ff ff       	call   801878 <sduppage>
  801af4:	eb 07                	jmp    801afd <sfork+0xe6>
		else mark_COW = 0;
  801af6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	int mark_COW = 1;
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  801afd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801b04:	81 7d f4 ff ef bf ee 	cmpl   $0xeebfefff,-0xc(%ebp)
  801b0b:	76 8d                	jbe    801a9a <sfork+0x83>
	        sduppage (newenv, VPN(addr), mark_COW);
		else mark_COW = 0;
	}
	//cprintf("finish map PGSIZE\n");
	//user exception stack
	if((r = sys_page_alloc(newenv, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0){
  801b0d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801b14:	00 
  801b15:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801b1c:	ee 
  801b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b20:	89 04 24             	mov    %eax,(%esp)
  801b23:	e8 2a f7 ff ff       	call   801252 <sys_page_alloc>
  801b28:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b2b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b2f:	79 1c                	jns    801b4d <sfork+0x136>
		panic("fork alloc page failed\n");
  801b31:	c7 44 24 08 a4 33 80 	movl   $0x8033a4,0x8(%esp)
  801b38:	00 
  801b39:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  801b40:	00 
  801b41:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  801b48:	e8 83 e6 ff ff       	call   8001d0 <_panic>
		}
	//
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(newenv, _pgfault_upcall);
  801b4d:	c7 44 24 04 24 2c 80 	movl   $0x802c24,0x4(%esp)
  801b54:	00 
  801b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b58:	89 04 24             	mov    %eax,(%esp)
  801b5b:	e8 81 f8 ff ff       	call   8013e1 <sys_env_set_pgfault_upcall>
	//panic("fork not implemented");
	//set it runable
	if((r = sys_env_set_status(newenv, ENV_RUNNABLE)) < 0){
  801b60:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b67:	00 
  801b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6b:	89 04 24             	mov    %eax,(%esp)
  801b6e:	e8 ea f7 ff ff       	call   80135d <sys_env_set_status>
  801b73:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b7a:	79 1c                	jns    801b98 <sfork+0x181>
		panic("set runnable failed\n");
  801b7c:	c7 44 24 08 bc 33 80 	movl   $0x8033bc,0x8(%esp)
  801b83:	00 
  801b84:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801b8b:	00 
  801b8c:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  801b93:	e8 38 e6 ff ff       	call   8001d0 <_panic>
		}
	
	return newenv;
  801b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801b9b:	83 c4 44             	add    $0x44,%esp
  801b9e:	5b                   	pop    %ebx
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    
  801ba1:	00 00                	add    %al,(%eax)
	...

00801ba4 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  801baa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bae:	75 11                	jne    801bc1 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  801bb0:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  801bb7:	e8 a7 f8 ff ff       	call   801463 <sys_ipc_recv>
  801bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bbf:	eb 0e                	jmp    801bcf <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  801bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc4:	89 04 24             	mov    %eax,(%esp)
  801bc7:	e8 97 f8 ff ff       	call   801463 <sys_ipc_recv>
  801bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  801bcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bd3:	79 1c                	jns    801bf1 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  801bd5:	c7 44 24 08 82 34 80 	movl   $0x803482,0x8(%esp)
  801bdc:	00 
  801bdd:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801be4:	00 
  801be5:	c7 04 24 98 34 80 00 	movl   $0x803498,(%esp)
  801bec:	e8 df e5 ff ff       	call   8001d0 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  801bf1:	e8 d4 f5 ff ff       	call   8011ca <sys_getenvid>
  801bf6:	25 ff 03 00 00       	and    $0x3ff,%eax
  801bfb:	c1 e0 07             	shl    $0x7,%eax
  801bfe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  801c06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c0a:	74 0b                	je     801c17 <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  801c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0f:	8b 50 74             	mov    0x74(%eax),%edx
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  801c17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c1b:	74 0b                	je     801c28 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  801c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c20:	8b 50 78             	mov    0x78(%eax),%edx
  801c23:	8b 45 10             	mov    0x10(%ebp),%eax
  801c26:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  801c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2b:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  801c36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c3a:	75 26                	jne    801c62 <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  801c3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c43:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  801c4a:	ee 
  801c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	89 04 24             	mov    %eax,(%esp)
  801c58:	e8 c6 f7 ff ff       	call   801423 <sys_ipc_try_send>
  801c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c60:	eb 23                	jmp    801c85 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  801c62:	8b 45 14             	mov    0x14(%ebp),%eax
  801c65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	89 04 24             	mov    %eax,(%esp)
  801c7d:	e8 a1 f7 ff ff       	call   801423 <sys_ipc_try_send>
  801c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  801c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c89:	79 29                	jns    801cb4 <ipc_send+0x84>
  801c8b:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  801c8f:	74 23                	je     801cb4 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  801c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c94:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c98:	c7 44 24 08 a2 34 80 	movl   $0x8034a2,0x8(%esp)
  801c9f:	00 
  801ca0:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801ca7:	00 
  801ca8:	c7 04 24 98 34 80 00 	movl   $0x803498,(%esp)
  801caf:	e8 1c e5 ff ff       	call   8001d0 <_panic>
	    sys_yield();
  801cb4:	e8 55 f5 ff ff       	call   80120e <sys_yield>
	}while(r < 0);
  801cb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cbd:	0f 88 73 ff ff ff    	js     801c36 <ipc_send+0x6>
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    
  801cc5:	00 00                	add    %al,(%eax)
	...

00801cc8 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	89 04 24             	mov    %eax,(%esp)
  801cd4:	e8 0a 00 00 00       	call   801ce3 <fd2num>
  801cd9:	05 40 03 00 00       	add    $0x340,%eax
  801cde:	c1 e0 16             	shl    $0x16,%eax
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	05 00 00 40 30       	add    $0x30400000,%eax
  801cee:	c1 e8 0c             	shr    $0xc,%eax
}
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801cf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d00:	eb 49                	jmp    801d4b <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  801d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d05:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801d0a:	c1 e0 0c             	shl    $0xc,%eax
  801d0d:	89 c2                	mov    %eax,%edx
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	8b 00                	mov    (%eax),%eax
  801d19:	c1 e8 16             	shr    $0x16,%eax
  801d1c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d23:	83 e0 01             	and    $0x1,%eax
  801d26:	85 c0                	test   %eax,%eax
  801d28:	74 16                	je     801d40 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	c1 e8 0c             	shr    $0xc,%eax
  801d32:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d39:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	75 07                	jne    801d47 <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
  801d45:	eb 18                	jmp    801d5f <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801d47:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801d4b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  801d4f:	7e b1                	jle    801d02 <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  801d5a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  801d67:	c7 44 24 08 b8 34 80 	movl   $0x8034b8,0x8(%esp)
  801d6e:	00 
  801d6f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801d76:	00 
  801d77:	c7 04 24 d2 34 80 00 	movl   $0x8034d2,(%esp)
  801d7e:	e8 4d e4 ff ff       	call   8001d0 <_panic>

00801d83 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	89 04 24             	mov    %eax,(%esp)
  801d8f:	e8 4f ff ff ff       	call   801ce3 <fd2num>
  801d94:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801d97:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d9b:	89 04 24             	mov    %eax,(%esp)
  801d9e:	e8 be ff ff ff       	call   801d61 <fd_lookup>
  801da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801daa:	78 08                	js     801db4 <fd_close+0x31>
	    || fd != fd2)
  801dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801daf:	39 45 08             	cmp    %eax,0x8(%ebp)
  801db2:	74 12                	je     801dc6 <fd_close+0x43>
		return (must_exist ? r : 0);
  801db4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801db8:	74 05                	je     801dbf <fd_close+0x3c>
  801dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbd:	eb 05                	jmp    801dc4 <fd_close+0x41>
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	eb 44                	jmp    801e0a <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	8b 00                	mov    (%eax),%eax
  801dcb:	8d 55 ec             	lea    -0x14(%ebp),%edx
  801dce:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dd2:	89 04 24             	mov    %eax,(%esp)
  801dd5:	e8 32 00 00 00       	call   801e0c <dev_lookup>
  801dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de1:	78 11                	js     801df4 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  801de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de6:	8b 50 10             	mov    0x10(%eax),%edx
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	89 04 24             	mov    %eax,(%esp)
  801def:	ff d2                	call   *%edx
  801df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e02:	e8 d2 f4 ff ff       	call   8012d9 <sys_page_unmap>
	return r;
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  801e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e19:	eb 2b                	jmp    801e46 <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	8b 04 85 08 60 80 00 	mov    0x806008(,%eax,4),%eax
  801e25:	8b 00                	mov    (%eax),%eax
  801e27:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e2a:	75 16                	jne    801e42 <dev_lookup+0x36>
			*dev = devtab[i];
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 14 85 08 60 80 00 	mov    0x806008(,%eax,4),%edx
  801e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e39:	89 10                	mov    %edx,(%eax)
			return 0;
  801e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e40:	eb 3f                	jmp    801e81 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	8b 04 85 08 60 80 00 	mov    0x806008(,%eax,4),%eax
  801e50:	85 c0                	test   %eax,%eax
  801e52:	75 c7                	jne    801e1b <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801e54:	a1 40 60 80 00       	mov    0x806040,%eax
  801e59:	8b 40 4c             	mov    0x4c(%eax),%eax
  801e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e5f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e67:	c7 04 24 dc 34 80 00 	movl   $0x8034dc,(%esp)
  801e6e:	e8 91 e4 ff ff       	call   800304 <cprintf>
	*dev = 0;
  801e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801e7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <close>:

int
close(int fdnum)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e89:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	89 04 24             	mov    %eax,(%esp)
  801e96:	e8 c6 fe ff ff       	call   801d61 <fd_lookup>
  801e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea2:	79 05                	jns    801ea9 <close+0x26>
		return r;
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	eb 13                	jmp    801ebc <close+0x39>
	else
		return fd_close(fd, 1);
  801ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801eb3:	00 
  801eb4:	89 04 24             	mov    %eax,(%esp)
  801eb7:	e8 c7 fe ff ff       	call   801d83 <fd_close>
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <close_all>:

void
close_all(void)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ec4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ecb:	eb 0f                	jmp    801edc <close_all+0x1e>
		close(i);
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed0:	89 04 24             	mov    %eax,(%esp)
  801ed3:	e8 ab ff ff ff       	call   801e83 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ed8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801edc:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  801ee0:	7e eb                	jle    801ecd <close_all+0xf>
		close(i);
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801eea:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	89 04 24             	mov    %eax,(%esp)
  801ef7:	e8 65 fe ff ff       	call   801d61 <fd_lookup>
  801efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f03:	79 08                	jns    801f0d <dup+0x29>
		return r;
  801f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f08:	e9 54 01 00 00       	jmp    802061 <dup+0x17d>
	close(newfdnum);
  801f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f10:	89 04 24             	mov    %eax,(%esp)
  801f13:	e8 6b ff ff ff       	call   801e83 <close>

	newfd = INDEX2FD(newfdnum);
  801f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1b:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801f20:	c1 e0 0c             	shl    $0xc,%eax
  801f23:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  801f26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f29:	89 04 24             	mov    %eax,(%esp)
  801f2c:	e8 97 fd ff ff       	call   801cc8 <fd2data>
  801f31:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f37:	89 04 24             	mov    %eax,(%esp)
  801f3a:	e8 89 fd ff ff       	call   801cc8 <fd2data>
  801f3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801f42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f45:	c1 e8 0c             	shr    $0xc,%eax
  801f48:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f4f:	89 c2                	mov    %eax,%edx
  801f51:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801f57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f5a:	89 54 24 10          	mov    %edx,0x10(%esp)
  801f5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f61:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f65:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f6c:	00 
  801f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f78:	e8 16 f3 ff ff       	call   801293 <sys_page_map>
  801f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f84:	0f 88 8e 00 00 00    	js     802018 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  801f8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f8d:	c1 e8 16             	shr    $0x16,%eax
  801f90:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	74 78                	je     802013 <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801f9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fa2:	eb 66                	jmp    80200a <dup+0x126>
			pte = vpt[VPN(ova + i)];
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	03 45 e8             	add    -0x18(%ebp),%eax
  801faa:	c1 e8 0c             	shr    $0xc,%eax
  801fad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  801fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fba:	83 e0 01             	and    $0x1,%eax
  801fbd:	84 c0                	test   %al,%al
  801fbf:	74 42                	je     802003 <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801fc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fc4:	89 c1                	mov    %eax,%ecx
  801fc6:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	89 c2                	mov    %eax,%edx
  801fd1:	03 55 e4             	add    -0x1c(%ebp),%edx
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	03 45 e8             	add    -0x18(%ebp),%eax
  801fda:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801fde:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fe2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fe9:	00 
  801fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff5:	e8 99 f2 ff ff       	call   801293 <sys_page_map>
  801ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ffd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802001:	78 18                	js     80201b <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  802003:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80200a:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  802011:	7e 91                	jle    801fa4 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  802013:	8b 45 0c             	mov    0xc(%ebp),%eax
  802016:	eb 49                	jmp    802061 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  802018:	90                   	nop
  802019:	eb 01                	jmp    80201c <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  80201b:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80201c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802023:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202a:	e8 aa f2 ff ff       	call   8012d9 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80202f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802036:	eb 1d                	jmp    802055 <dup+0x171>
		sys_page_unmap(0, nva + i);
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	03 45 e4             	add    -0x1c(%ebp),%eax
  80203e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802042:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802049:	e8 8b f2 ff ff       	call   8012d9 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80204e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802055:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  80205c:	7e da                	jle    802038 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  80205e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802069:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80206c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	89 04 24             	mov    %eax,(%esp)
  802076:	e8 e6 fc ff ff       	call   801d61 <fd_lookup>
  80207b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802082:	78 1d                	js     8020a1 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802087:	8b 00                	mov    (%eax),%eax
  802089:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80208c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802090:	89 04 24             	mov    %eax,(%esp)
  802093:	e8 74 fd ff ff       	call   801e0c <dev_lookup>
  802098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209f:	79 05                	jns    8020a6 <read+0x43>
		return r;
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	eb 75                	jmp    80211b <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ac:	83 e0 03             	and    $0x3,%eax
  8020af:	83 f8 01             	cmp    $0x1,%eax
  8020b2:	75 26                	jne    8020da <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8020b4:	a1 40 60 80 00       	mov    0x806040,%eax
  8020b9:	8b 40 4c             	mov    0x4c(%eax),%eax
  8020bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c7:	c7 04 24 fb 34 80 00 	movl   $0x8034fb,(%esp)
  8020ce:	e8 31 e2 ff ff       	call   800304 <cprintf>
		return -E_INVAL;
  8020d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020d8:	eb 41                	jmp    80211b <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8020da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020dd:	8b 48 08             	mov    0x8(%eax),%ecx
  8020e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e3:	8b 50 04             	mov    0x4(%eax),%edx
  8020e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020ed:	8b 55 10             	mov    0x10(%ebp),%edx
  8020f0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020fb:	89 04 24             	mov    %eax,(%esp)
  8020fe:	ff d1                	call   *%ecx
  802100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  802103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802107:	78 0f                	js     802118 <read+0xb5>
		fd->fd_offset += r;
  802109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80210f:	8b 52 04             	mov    0x4(%edx),%edx
  802112:	03 55 f4             	add    -0xc(%ebp),%edx
  802115:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80212a:	eb 3b                	jmp    802167 <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80212c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212f:	8b 55 10             	mov    0x10(%ebp),%edx
  802132:	29 c2                	sub    %eax,%edx
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	03 45 0c             	add    0xc(%ebp),%eax
  80213a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80213e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	89 04 24             	mov    %eax,(%esp)
  802148:	e8 16 ff ff ff       	call   802063 <read>
  80214d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  802150:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802154:	79 05                	jns    80215b <readn+0x3e>
			return m;
  802156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802159:	eb 1a                	jmp    802175 <readn+0x58>
		if (m == 0)
  80215b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215f:	74 10                	je     802171 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	01 45 f4             	add    %eax,-0xc(%ebp)
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80216d:	72 bd                	jb     80212c <readn+0xf>
  80216f:	eb 01                	jmp    802172 <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802171:	90                   	nop
	}
	return tot;
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80217d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802180:	89 44 24 04          	mov    %eax,0x4(%esp)
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	89 04 24             	mov    %eax,(%esp)
  80218a:	e8 d2 fb ff ff       	call   801d61 <fd_lookup>
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802192:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802196:	78 1d                	js     8021b5 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8021a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021a4:	89 04 24             	mov    %eax,(%esp)
  8021a7:	e8 60 fc ff ff       	call   801e0c <dev_lookup>
  8021ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b3:	79 05                	jns    8021ba <write+0x43>
		return r;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	eb 74                	jmp    80222e <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bd:	8b 40 08             	mov    0x8(%eax),%eax
  8021c0:	83 e0 03             	and    $0x3,%eax
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	75 26                	jne    8021ed <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8021c7:	a1 40 60 80 00       	mov    0x806040,%eax
  8021cc:	8b 40 4c             	mov    0x4c(%eax),%eax
  8021cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021da:	c7 04 24 17 35 80 00 	movl   $0x803517,(%esp)
  8021e1:	e8 1e e1 ff ff       	call   800304 <cprintf>
		return -E_INVAL;
  8021e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021eb:	eb 41                	jmp    80222e <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8021ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f0:	8b 48 0c             	mov    0xc(%eax),%ecx
  8021f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f6:	8b 50 04             	mov    0x4(%eax),%edx
  8021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802200:	8b 55 10             	mov    0x10(%ebp),%edx
  802203:	89 54 24 08          	mov    %edx,0x8(%esp)
  802207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80220e:	89 04 24             	mov    %eax,(%esp)
  802211:	ff d1                	call   *%ecx
  802213:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  802216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221a:	7e 0f                	jle    80222b <write+0xb4>
		fd->fd_offset += r;
  80221c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802222:	8b 52 04             	mov    0x4(%edx),%edx
  802225:	03 55 f4             	add    -0xc(%ebp),%edx
  802228:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <seek>:

int
seek(int fdnum, off_t offset)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802236:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802239:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	89 04 24             	mov    %eax,(%esp)
  802243:	e8 19 fb ff ff       	call   801d61 <fd_lookup>
  802248:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224f:	79 05                	jns    802256 <seek+0x26>
		return r;
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	eb 0e                	jmp    802264 <seek+0x34>
	fd->fd_offset = offset;
  802256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80225f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80226c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80226f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	89 04 24             	mov    %eax,(%esp)
  802279:	e8 e3 fa ff ff       	call   801d61 <fd_lookup>
  80227e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	78 1d                	js     8022a4 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80228f:	89 54 24 04          	mov    %edx,0x4(%esp)
  802293:	89 04 24             	mov    %eax,(%esp)
  802296:	e8 71 fb ff ff       	call   801e0c <dev_lookup>
  80229b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a2:	79 05                	jns    8022a9 <ftruncate+0x43>
		return r;
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	eb 48                	jmp    8022f1 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ac:	8b 40 08             	mov    0x8(%eax),%eax
  8022af:	83 e0 03             	and    $0x3,%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	75 26                	jne    8022dc <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8022b6:	a1 40 60 80 00       	mov    0x806040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022bb:	8b 40 4c             	mov    0x4c(%eax),%eax
  8022be:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c9:	c7 04 24 34 35 80 00 	movl   $0x803534,(%esp)
  8022d0:	e8 2f e0 ff ff       	call   800304 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8022d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022da:	eb 15                	jmp    8022f1 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8022dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022df:	8b 48 1c             	mov    0x1c(%eax),%ecx
  8022e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ec:	89 04 24             	mov    %eax,(%esp)
  8022ef:	ff d1                	call   *%ecx
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	89 04 24             	mov    %eax,(%esp)
  802306:	e8 56 fa ff ff       	call   801d61 <fd_lookup>
  80230b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802312:	78 1d                	js     802331 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802317:	8b 00                	mov    (%eax),%eax
  802319:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80231c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802320:	89 04 24             	mov    %eax,(%esp)
  802323:	e8 e4 fa ff ff       	call   801e0c <dev_lookup>
  802328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232f:	79 05                	jns    802336 <fstat+0x43>
		return r;
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	eb 41                	jmp    802377 <fstat+0x84>
	stat->st_name[0] = 0;
  802336:	8b 45 0c             	mov    0xc(%ebp),%eax
  802339:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  80233c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  802346:	00 00 00 
	stat->st_isdir = 0;
  802349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  802353:	00 00 00 
	stat->st_dev = dev;
  802356:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235c:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 48 14             	mov    0x14(%eax),%ecx
  802368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802372:	89 04 24             	mov    %eax,(%esp)
  802375:	ff d1                	call   *%ecx
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80237f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802386:	00 
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	89 04 24             	mov    %eax,(%esp)
  80238d:	e8 36 00 00 00       	call   8023c8 <open>
  802392:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802395:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802399:	79 05                	jns    8023a0 <stat+0x27>
		return fd;
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	eb 23                	jmp    8023c3 <stat+0x4a>
	r = fstat(fd, stat);
  8023a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	89 04 24             	mov    %eax,(%esp)
  8023ad:	e8 41 ff ff ff       	call   8022f3 <fstat>
  8023b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	89 04 24             	mov    %eax,(%esp)
  8023bb:	e8 c3 fa ff ff       	call   801e83 <close>
	return r;
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    
  8023c5:	00 00                	add    %al,(%eax)
	...

008023c8 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  8023ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023d1:	89 04 24             	mov    %eax,(%esp)
  8023d4:	e8 1a f9 ff ff       	call   801cf3 <fd_alloc>
  8023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e0:	79 05                	jns    8023e7 <open+0x1f>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	eb 73                	jmp    80245a <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	89 04 24             	mov    %eax,(%esp)
  8023fb:	e8 54 05 00 00       	call   802954 <fsipc_open>
  802400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802407:	79 05                	jns    80240e <open+0x46>
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	eb 4c                	jmp    80245a <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  80240e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802411:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  802417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80241e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802425:	00 
  802426:	89 04 24             	mov    %eax,(%esp)
  802429:	e8 25 03 00 00       	call   802753 <fmap>
  80242e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802435:	79 18                	jns    80244f <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  802437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802441:	00 
  802442:	89 04 24             	mov    %eax,(%esp)
  802445:	e8 39 f9 ff ff       	call   801d83 <fd_close>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	eb 0b                	jmp    80245a <open+0x92>
	return fd2num(fd);
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	89 04 24             	mov    %eax,(%esp)
  802455:	e8 89 f8 ff ff       	call   801ce3 <fd2num>
	//panic("open() unimplemented!");
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80246b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  802472:	00 
  802473:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80247a:	00 
  80247b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	89 04 24             	mov    %eax,(%esp)
  802485:	e8 72 03 00 00       	call   8027fc <funmap>
  80248a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802491:	79 05                	jns    802498 <file_close+0x3c>
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	eb 21                	jmp    8024b9 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	8b 40 0c             	mov    0xc(%eax),%eax
  80249e:	89 04 24             	mov    %eax,(%esp)
  8024a1:	e8 e3 05 00 00       	call   802a89 <fsipc_close>
  8024a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ad:	79 05                	jns    8024b4 <file_close+0x58>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	eb 05                	jmp    8024b9 <file_close+0x5d>
	return 0;
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8024c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8024ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  8024cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024d3:	76 07                	jbe    8024dc <file_read+0x21>
		return 0;
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024da:	eb 43                	jmp    80251f <file_read+0x64>
	if (offset + n > size)
  8024dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024df:	03 45 10             	add    0x10(%ebp),%eax
  8024e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024e5:	76 0f                	jbe    8024f6 <file_read+0x3b>
		n = size - offset;
  8024e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ed:	89 d1                	mov    %edx,%ecx
  8024ef:	29 c1                	sub    %eax,%ecx
  8024f1:	89 c8                	mov    %ecx,%eax
  8024f3:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	89 04 24             	mov    %eax,(%esp)
  8024fc:	e8 c7 f7 ff ff       	call   801cc8 <fd2data>
  802501:	8b 55 14             	mov    0x14(%ebp),%edx
  802504:	01 c2                	add    %eax,%edx
  802506:	8b 45 10             	mov    0x10(%ebp),%eax
  802509:	89 44 24 08          	mov    %eax,0x8(%esp)
  80250d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802511:	8b 45 0c             	mov    0xc(%ebp),%eax
  802514:	89 04 24             	mov    %eax,(%esp)
  802517:	e8 ec e8 ff ff       	call   800e08 <memmove>
	return n;
  80251c:	8b 45 10             	mov    0x10(%ebp),%eax
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
  802524:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802527:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80252a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	89 04 24             	mov    %eax,(%esp)
  802534:	e8 28 f8 ff ff       	call   801d61 <fd_lookup>
  802539:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802540:	79 05                	jns    802547 <read_map+0x26>
		return r;
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	eb 74                	jmp    8025bb <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  802547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254a:	8b 10                	mov    (%eax),%edx
  80254c:	a1 20 60 80 00       	mov    0x806020,%eax
  802551:	39 c2                	cmp    %eax,%edx
  802553:	74 07                	je     80255c <read_map+0x3b>
		return -E_INVAL;
  802555:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80255a:	eb 5f                	jmp    8025bb <read_map+0x9a>
	va = fd2data(fd) + offset;
  80255c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255f:	89 04 24             	mov    %eax,(%esp)
  802562:	e8 61 f7 ff ff       	call   801cc8 <fd2data>
  802567:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256a:	01 d0                	add    %edx,%eax
  80256c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  80256f:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  802576:	7e 07                	jle    80257f <read_map+0x5e>
		return -E_NO_DISK;
  802578:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80257d:	eb 3c                	jmp    8025bb <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	c1 e8 16             	shr    $0x16,%eax
  802585:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80258c:	83 e0 01             	and    $0x1,%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	74 14                	je     8025a7 <read_map+0x86>
  802593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802596:	c1 e8 0c             	shr    $0xc,%eax
  802599:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8025a0:	83 e0 01             	and    $0x1,%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	75 07                	jne    8025ae <read_map+0x8d>
		return -E_NO_DISK;
  8025a7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8025ac:	eb 0d                	jmp    8025bb <read_map+0x9a>
	*blk = (void*) va;
  8025ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b4:	89 10                	mov    %edx,(%eax)
	return 0;
  8025b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  8025c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8025c6:	03 45 10             	add    0x10(%ebp),%eax
  8025c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  8025cc:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  8025d3:	76 07                	jbe    8025dc <file_write+0x1f>
		return -E_NO_DISK;
  8025d5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8025da:	eb 57                	jmp    802633 <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8025e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025e8:	73 20                	jae    80260a <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	89 04 24             	mov    %eax,(%esp)
  8025f7:	e8 88 00 00 00       	call   802684 <file_trunc>
  8025fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802603:	79 05                	jns    80260a <file_write+0x4d>
			return r;
  802605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802608:	eb 29                	jmp    802633 <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	89 04 24             	mov    %eax,(%esp)
  802610:	e8 b3 f6 ff ff       	call   801cc8 <fd2data>
  802615:	8b 55 14             	mov    0x14(%ebp),%edx
  802618:	01 c2                	add    %eax,%edx
  80261a:	8b 45 10             	mov    0x10(%ebp),%eax
  80261d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802621:	8b 45 0c             	mov    0xc(%ebp),%eax
  802624:	89 44 24 04          	mov    %eax,0x4(%esp)
  802628:	89 14 24             	mov    %edx,(%esp)
  80262b:	e8 d8 e7 ff ff       	call   800e08 <memmove>
	return n;
  802630:	8b 45 10             	mov    0x10(%ebp),%eax
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	8d 50 10             	lea    0x10(%eax),%edx
  802641:	8b 45 0c             	mov    0xc(%ebp),%eax
  802644:	89 54 24 04          	mov    %edx,0x4(%esp)
  802648:	89 04 24             	mov    %eax,(%esp)
  80264b:	e8 c6 e5 ff ff       	call   800c16 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  802659:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265c:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  80266b:	83 f8 01             	cmp    $0x1,%eax
  80266e:	0f 94 c0             	sete   %al
  802671:	0f b6 d0             	movzbl %al,%edx
  802674:	8b 45 0c             	mov    0xc(%ebp),%eax
  802677:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  80268a:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  802691:	7e 0a                	jle    80269d <file_trunc+0x19>
		return -E_NO_DISK;
  802693:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802698:	e9 b4 00 00 00       	jmp    802751 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8026af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026bc:	89 04 24             	mov    %eax,(%esp)
  8026bf:	e8 82 03 00 00       	call   802a46 <fsipc_set_size>
  8026c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026cb:	79 05                	jns    8026d2 <file_trunc+0x4e>
		return r;
  8026cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d0:	eb 7f                	jmp    802751 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8026db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026de:	74 24                	je     802704 <file_trunc+0x80>
  8026e0:	c7 44 24 0c 60 35 80 	movl   $0x803560,0xc(%esp)
  8026e7:	00 
  8026e8:	c7 44 24 08 83 35 80 	movl   $0x803583,0x8(%esp)
  8026ef:	00 
  8026f0:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8026f7:	00 
  8026f8:	c7 04 24 98 35 80 00 	movl   $0x803598,(%esp)
  8026ff:	e8 cc da ff ff       	call   8001d0 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  802704:	8b 45 0c             	mov    0xc(%ebp),%eax
  802707:	89 44 24 08          	mov    %eax,0x8(%esp)
  80270b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	89 04 24             	mov    %eax,(%esp)
  802718:	e8 36 00 00 00       	call   802753 <fmap>
  80271d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802720:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802724:	79 05                	jns    80272b <file_trunc+0xa7>
		return r;
  802726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802729:	eb 26                	jmp    802751 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  80272b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802732:	00 
  802733:	8b 45 0c             	mov    0xc(%ebp),%eax
  802736:	89 44 24 08          	mov    %eax,0x8(%esp)
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	89 04 24             	mov    %eax,(%esp)
  802747:	e8 b0 00 00 00       	call   8027fc <funmap>

	return 0;
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802751:	c9                   	leave  
  802752:	c3                   	ret    

00802753 <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
  802756:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	89 04 24             	mov    %eax,(%esp)
  80275f:	e8 64 f5 ff ff       	call   801cc8 <fd2data>
  802764:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  802767:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80276e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802771:	03 45 ec             	add    -0x14(%ebp),%eax
  802774:	83 e8 01             	sub    $0x1,%eax
  802777:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80277a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277d:	ba 00 00 00 00       	mov    $0x0,%edx
  802782:	f7 75 ec             	divl   -0x14(%ebp)
  802785:	89 d0                	mov    %edx,%eax
  802787:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80278a:	89 d1                	mov    %edx,%ecx
  80278c:	29 c1                	sub    %eax,%ecx
  80278e:	89 c8                	mov    %ecx,%eax
  802790:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802793:	eb 58                	jmp    8027ed <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80279b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80279e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027af:	89 04 24             	mov    %eax,(%esp)
  8027b2:	e8 04 02 00 00       	call   8029bb <fsipc_map>
  8027b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8027ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027be:	79 26                	jns    8027e6 <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8027ca:	00 
  8027cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ce:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	89 04 24             	mov    %eax,(%esp)
  8027dc:	e8 1b 00 00 00       	call   8027fc <funmap>
			return r;
  8027e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e4:	eb 14                	jmp    8027fa <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  8027e6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8027ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027f3:	77 a0                	ja     802795 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	89 04 24             	mov    %eax,(%esp)
  802808:	e8 bb f4 ff ff       	call   801cc8 <fd2data>
  80280d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	c1 e8 16             	shr    $0x16,%eax
  802816:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80281d:	83 e0 01             	and    $0x1,%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	75 0a                	jne    80282e <funmap+0x32>
		return 0;
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
  802829:	e9 bf 00 00 00       	jmp    8028ed <funmap+0xf1>

	ret = 0;
  80282e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  802835:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80283c:	8b 45 10             	mov    0x10(%ebp),%eax
  80283f:	03 45 e8             	add    -0x18(%ebp),%eax
  802842:	83 e8 01             	sub    $0x1,%eax
  802845:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284b:	ba 00 00 00 00       	mov    $0x0,%edx
  802850:	f7 75 e8             	divl   -0x18(%ebp)
  802853:	89 d0                	mov    %edx,%eax
  802855:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802858:	89 d1                	mov    %edx,%ecx
  80285a:	29 c1                	sub    %eax,%ecx
  80285c:	89 c8                	mov    %ecx,%eax
  80285e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802861:	eb 7b                	jmp    8028de <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802869:	01 d0                	add    %edx,%eax
  80286b:	c1 e8 0c             	shr    $0xc,%eax
  80286e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802875:	83 e0 01             	and    $0x1,%eax
  802878:	84 c0                	test   %al,%al
  80287a:	74 5b                	je     8028d7 <funmap+0xdb>
			if (dirty
  80287c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  802880:	74 3d                	je     8028bf <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802888:	01 d0                	add    %edx,%eax
  80288a:	c1 e8 0c             	shr    $0xc,%eax
  80288d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802894:	83 e0 40             	and    $0x40,%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 24                	je     8028bf <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  80289b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028a8:	89 04 24             	mov    %eax,(%esp)
  8028ab:	e8 13 02 00 00       	call   802ac3 <fsipc_dirty>
  8028b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8028b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028b7:	79 06                	jns    8028bf <funmap+0xc3>
				ret = r;
  8028b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c5:	01 d0                	add    %edx,%eax
  8028c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d2:	e8 02 ea ff ff       	call   8012d9 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8028d7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8028de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8028e4:	0f 87 79 ff ff ff    	ja     802863 <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8028ed:	c9                   	leave  
  8028ee:	c3                   	ret    

008028ef <remove>:

// Delete a file
int
remove(const char *path)
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
  8028f2:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	89 04 24             	mov    %eax,(%esp)
  8028fb:	e8 06 02 00 00       	call   802b06 <fsipc_remove>
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  802908:	e8 56 02 00 00       	call   802b63 <fsipc_sync>
}
  80290d:	c9                   	leave  
  80290e:	c3                   	ret    
	...

00802910 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
  802913:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  802916:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80291b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802922:	00 
  802923:	8b 55 0c             	mov    0xc(%ebp),%edx
  802926:	89 54 24 08          	mov    %edx,0x8(%esp)
  80292a:	8b 55 08             	mov    0x8(%ebp),%edx
  80292d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802931:	89 04 24             	mov    %eax,(%esp)
  802934:	e8 f7 f2 ff ff       	call   801c30 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802939:	8b 45 14             	mov    0x14(%ebp),%eax
  80293c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802940:	8b 45 10             	mov    0x10(%ebp),%eax
  802943:	89 44 24 04          	mov    %eax,0x4(%esp)
  802947:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80294a:	89 04 24             	mov    %eax,(%esp)
  80294d:	e8 52 f2 ff ff       	call   801ba4 <ipc_recv>
}
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
  802957:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  80295a:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	89 04 24             	mov    %eax,(%esp)
  802967:	e8 54 e2 ff ff       	call   800bc0 <strlen>
  80296c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802971:	7e 07                	jle    80297a <fsipc_open+0x26>
		return -E_BAD_PATH;
  802973:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802978:	eb 3f                	jmp    8029b9 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 55 08             	mov    0x8(%ebp),%edx
  802980:	89 54 24 04          	mov    %edx,0x4(%esp)
  802984:	89 04 24             	mov    %eax,(%esp)
  802987:	e8 8a e2 ff ff       	call   800c16 <strcpy>
	req->req_omode = omode;
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802992:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  802998:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80299b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80299f:	8b 45 10             	mov    0x10(%ebp),%eax
  8029a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8029b4:	e8 57 ff ff ff       	call   802910 <fsipc>
}
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
  8029be:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  8029c1:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ce:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d6:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  8029d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8029dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8029e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ee:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8029f5:	e8 16 ff ff ff       	call   802910 <fsipc>
  8029fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a01:	79 05                	jns    802a08 <fsipc_map+0x4d>
		return r;
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	eb 3c                	jmp    802a44 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  802a08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0b:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  802a10:	83 f8 05             	cmp    $0x5,%eax
  802a13:	74 2a                	je     802a3f <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  802a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a18:	8b 55 10             	mov    0x10(%ebp),%edx
  802a1b:	89 54 24 10          	mov    %edx,0x10(%esp)
  802a1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a23:	c7 44 24 08 a4 35 80 	movl   $0x8035a4,0x8(%esp)
  802a2a:	00 
  802a2b:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  802a32:	00 
  802a33:	c7 04 24 da 35 80 00 	movl   $0x8035da,(%esp)
  802a3a:	e8 91 d7 ff ff       	call   8001d0 <_panic>
	return 0;
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a44:	c9                   	leave  
  802a45:	c3                   	ret    

00802a46 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802a4c:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 55 08             	mov    0x8(%ebp),%edx
  802a59:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a61:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802a64:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802a6b:	00 
  802a6c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a73:	00 
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a7b:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  802a82:	e8 89 fe ff ff       	call   802910 <fsipc>
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  802a8f:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9c:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  802a9e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802aa5:	00 
  802aa6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802aad:	00 
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  802abc:	e8 4f fe ff ff       	call   802910 <fsipc>
}
  802ac1:	c9                   	leave  
  802ac2:	c3                   	ret    

00802ac3 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  802ac3:	55                   	push   %ebp
  802ac4:	89 e5                	mov    %esp,%ebp
  802ac6:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  802ac9:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad6:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ade:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  802ae1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802ae8:	00 
  802ae9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802af0:	00 
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  802aff:	e8 0c fe ff ff       	call   802910 <fsipc>
}
  802b04:	c9                   	leave  
  802b05:	c3                   	ret    

00802b06 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
  802b09:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802b0c:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	89 04 24             	mov    %eax,(%esp)
  802b19:	e8 a2 e0 ff ff       	call   800bc0 <strlen>
  802b1e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b23:	7e 07                	jle    802b2c <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802b25:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802b2a:	eb 35                	jmp    802b61 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b32:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b36:	89 04 24             	mov    %eax,(%esp)
  802b39:	e8 d8 e0 ff ff       	call   800c16 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  802b3e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802b45:	00 
  802b46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802b4d:	00 
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b55:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  802b5c:	e8 af fd ff ff       	call   802910 <fsipc>
}
  802b61:	c9                   	leave  
  802b62:	c3                   	ret    

00802b63 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802b63:	55                   	push   %ebp
  802b64:	89 e5                	mov    %esp,%ebp
  802b66:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802b69:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802b70:	00 
  802b71:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802b78:	00 
  802b79:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802b80:	00 
  802b81:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  802b88:	e8 83 fd ff ff       	call   802910 <fsipc>
}
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    
	...

00802b90 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
  802b93:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b96:	a1 48 60 80 00       	mov    0x806048,%eax
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	75 7b                	jne    802c1a <set_pgfault_handler+0x8a>
		// First time through!
		// LAB 4: Your code here.
		envid_t env_id = sys_getenvid();//0env_id
  802b9f:	e8 26 e6 ff ff       	call   8011ca <sys_getenvid>
  802ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if((r = sys_page_alloc(env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_P|PTE_W)) < 0){
  802ba7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802bae:	00 
  802baf:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802bb6:	ee 
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	89 04 24             	mov    %eax,(%esp)
  802bbd:	e8 90 e6 ff ff       	call   801252 <sys_page_alloc>
  802bc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802bc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc9:	79 1c                	jns    802be7 <set_pgfault_handler+0x57>
			panic("set_pgfault_handler not implemented\n");
  802bcb:	c7 44 24 08 e8 35 80 	movl   $0x8035e8,0x8(%esp)
  802bd2:	00 
  802bd3:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  802bda:	00 
  802bdb:	c7 04 24 0d 36 80 00 	movl   $0x80360d,(%esp)
  802be2:	e8 e9 d5 ff ff       	call   8001d0 <_panic>
			return;
		}//env_id
		
		if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0){
  802be7:	c7 44 24 04 24 2c 80 	movl   $0x802c24,0x4(%esp)
  802bee:	00 
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	89 04 24             	mov    %eax,(%esp)
  802bf5:	e8 e7 e7 ff ff       	call   8013e1 <sys_env_set_pgfault_upcall>
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	79 1c                	jns    802c1a <set_pgfault_handler+0x8a>
			panic("sys_env_set_pgfault_upcall not implemented\n");
  802bfe:	c7 44 24 08 1c 36 80 	movl   $0x80361c,0x8(%esp)
  802c05:	00 
  802c06:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802c0d:	00 
  802c0e:	c7 04 24 0d 36 80 00 	movl   $0x80360d,(%esp)
  802c15:	e8 b6 d5 ff ff       	call   8001d0 <_panic>
			return;
		}
		//sys_env_set_pgfault_upcall(0, _pgfault_upcall);
	}
	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	a3 48 60 80 00       	mov    %eax,0x806048
}
  802c22:	c9                   	leave  
  802c23:	c3                   	ret    

00802c24 <_pgfault_upcall>:
  802c24:	54                   	push   %esp
  802c25:	a1 48 60 80 00       	mov    0x806048,%eax
  802c2a:	ff d0                	call   *%eax
  802c2c:	83 c4 04             	add    $0x4,%esp
  802c2f:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c33:	83 e8 04             	sub    $0x4,%eax
  802c36:	89 44 24 30          	mov    %eax,0x30(%esp)
  802c3a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
  802c3e:	89 18                	mov    %ebx,(%eax)
  802c40:	83 c4 08             	add    $0x8,%esp
  802c43:	61                   	popa   
  802c44:	83 c4 04             	add    $0x4,%esp
  802c47:	9d                   	popf   
  802c48:	5c                   	pop    %esp
  802c49:	c3                   	ret    
  802c4a:	00 00                	add    %al,(%eax)
  802c4c:	00 00                	add    %al,(%eax)
	...

00802c50 <__udivdi3>:
  802c50:	83 ec 1c             	sub    $0x1c,%esp
  802c53:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802c57:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  802c5b:	8b 44 24 20          	mov    0x20(%esp),%eax
  802c5f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802c63:	89 74 24 10          	mov    %esi,0x10(%esp)
  802c67:	8b 74 24 24          	mov    0x24(%esp),%esi
  802c6b:	85 ff                	test   %edi,%edi
  802c6d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802c71:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c75:	89 cd                	mov    %ecx,%ebp
  802c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c7b:	75 33                	jne    802cb0 <__udivdi3+0x60>
  802c7d:	39 f1                	cmp    %esi,%ecx
  802c7f:	77 57                	ja     802cd8 <__udivdi3+0x88>
  802c81:	85 c9                	test   %ecx,%ecx
  802c83:	75 0b                	jne    802c90 <__udivdi3+0x40>
  802c85:	b8 01 00 00 00       	mov    $0x1,%eax
  802c8a:	31 d2                	xor    %edx,%edx
  802c8c:	f7 f1                	div    %ecx
  802c8e:	89 c1                	mov    %eax,%ecx
  802c90:	89 f0                	mov    %esi,%eax
  802c92:	31 d2                	xor    %edx,%edx
  802c94:	f7 f1                	div    %ecx
  802c96:	89 c6                	mov    %eax,%esi
  802c98:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c9c:	f7 f1                	div    %ecx
  802c9e:	89 f2                	mov    %esi,%edx
  802ca0:	8b 74 24 10          	mov    0x10(%esp),%esi
  802ca4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802ca8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802cac:	83 c4 1c             	add    $0x1c,%esp
  802caf:	c3                   	ret    
  802cb0:	31 d2                	xor    %edx,%edx
  802cb2:	31 c0                	xor    %eax,%eax
  802cb4:	39 f7                	cmp    %esi,%edi
  802cb6:	77 e8                	ja     802ca0 <__udivdi3+0x50>
  802cb8:	0f bd cf             	bsr    %edi,%ecx
  802cbb:	83 f1 1f             	xor    $0x1f,%ecx
  802cbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802cc2:	75 2c                	jne    802cf0 <__udivdi3+0xa0>
  802cc4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802cc8:	76 04                	jbe    802cce <__udivdi3+0x7e>
  802cca:	39 f7                	cmp    %esi,%edi
  802ccc:	73 d2                	jae    802ca0 <__udivdi3+0x50>
  802cce:	31 d2                	xor    %edx,%edx
  802cd0:	b8 01 00 00 00       	mov    $0x1,%eax
  802cd5:	eb c9                	jmp    802ca0 <__udivdi3+0x50>
  802cd7:	90                   	nop
  802cd8:	89 f2                	mov    %esi,%edx
  802cda:	f7 f1                	div    %ecx
  802cdc:	31 d2                	xor    %edx,%edx
  802cde:	8b 74 24 10          	mov    0x10(%esp),%esi
  802ce2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802ce6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802cea:	83 c4 1c             	add    $0x1c,%esp
  802ced:	c3                   	ret    
  802cee:	66 90                	xchg   %ax,%ax
  802cf0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cf5:	b8 20 00 00 00       	mov    $0x20,%eax
  802cfa:	89 ea                	mov    %ebp,%edx
  802cfc:	2b 44 24 04          	sub    0x4(%esp),%eax
  802d00:	d3 e7                	shl    %cl,%edi
  802d02:	89 c1                	mov    %eax,%ecx
  802d04:	d3 ea                	shr    %cl,%edx
  802d06:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d0b:	09 fa                	or     %edi,%edx
  802d0d:	89 f7                	mov    %esi,%edi
  802d0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802d13:	89 f2                	mov    %esi,%edx
  802d15:	8b 74 24 08          	mov    0x8(%esp),%esi
  802d19:	d3 e5                	shl    %cl,%ebp
  802d1b:	89 c1                	mov    %eax,%ecx
  802d1d:	d3 ef                	shr    %cl,%edi
  802d1f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d24:	d3 e2                	shl    %cl,%edx
  802d26:	89 c1                	mov    %eax,%ecx
  802d28:	d3 ee                	shr    %cl,%esi
  802d2a:	09 d6                	or     %edx,%esi
  802d2c:	89 fa                	mov    %edi,%edx
  802d2e:	89 f0                	mov    %esi,%eax
  802d30:	f7 74 24 0c          	divl   0xc(%esp)
  802d34:	89 d7                	mov    %edx,%edi
  802d36:	89 c6                	mov    %eax,%esi
  802d38:	f7 e5                	mul    %ebp
  802d3a:	39 d7                	cmp    %edx,%edi
  802d3c:	72 22                	jb     802d60 <__udivdi3+0x110>
  802d3e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802d42:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d47:	d3 e5                	shl    %cl,%ebp
  802d49:	39 c5                	cmp    %eax,%ebp
  802d4b:	73 04                	jae    802d51 <__udivdi3+0x101>
  802d4d:	39 d7                	cmp    %edx,%edi
  802d4f:	74 0f                	je     802d60 <__udivdi3+0x110>
  802d51:	89 f0                	mov    %esi,%eax
  802d53:	31 d2                	xor    %edx,%edx
  802d55:	e9 46 ff ff ff       	jmp    802ca0 <__udivdi3+0x50>
  802d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d60:	8d 46 ff             	lea    -0x1(%esi),%eax
  802d63:	31 d2                	xor    %edx,%edx
  802d65:	8b 74 24 10          	mov    0x10(%esp),%esi
  802d69:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d6d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d71:	83 c4 1c             	add    $0x1c,%esp
  802d74:	c3                   	ret    
	...

00802d80 <__umoddi3>:
  802d80:	83 ec 1c             	sub    $0x1c,%esp
  802d83:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802d87:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  802d8b:	8b 44 24 20          	mov    0x20(%esp),%eax
  802d8f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802d93:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802d97:	8b 74 24 24          	mov    0x24(%esp),%esi
  802d9b:	85 ed                	test   %ebp,%ebp
  802d9d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802da1:	89 44 24 08          	mov    %eax,0x8(%esp)
  802da5:	89 cf                	mov    %ecx,%edi
  802da7:	89 04 24             	mov    %eax,(%esp)
  802daa:	89 f2                	mov    %esi,%edx
  802dac:	75 1a                	jne    802dc8 <__umoddi3+0x48>
  802dae:	39 f1                	cmp    %esi,%ecx
  802db0:	76 4e                	jbe    802e00 <__umoddi3+0x80>
  802db2:	f7 f1                	div    %ecx
  802db4:	89 d0                	mov    %edx,%eax
  802db6:	31 d2                	xor    %edx,%edx
  802db8:	8b 74 24 10          	mov    0x10(%esp),%esi
  802dbc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802dc0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802dc4:	83 c4 1c             	add    $0x1c,%esp
  802dc7:	c3                   	ret    
  802dc8:	39 f5                	cmp    %esi,%ebp
  802dca:	77 54                	ja     802e20 <__umoddi3+0xa0>
  802dcc:	0f bd c5             	bsr    %ebp,%eax
  802dcf:	83 f0 1f             	xor    $0x1f,%eax
  802dd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dd6:	75 60                	jne    802e38 <__umoddi3+0xb8>
  802dd8:	3b 0c 24             	cmp    (%esp),%ecx
  802ddb:	0f 87 07 01 00 00    	ja     802ee8 <__umoddi3+0x168>
  802de1:	89 f2                	mov    %esi,%edx
  802de3:	8b 34 24             	mov    (%esp),%esi
  802de6:	29 ce                	sub    %ecx,%esi
  802de8:	19 ea                	sbb    %ebp,%edx
  802dea:	89 34 24             	mov    %esi,(%esp)
  802ded:	8b 04 24             	mov    (%esp),%eax
  802df0:	8b 74 24 10          	mov    0x10(%esp),%esi
  802df4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802df8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802dfc:	83 c4 1c             	add    $0x1c,%esp
  802dff:	c3                   	ret    
  802e00:	85 c9                	test   %ecx,%ecx
  802e02:	75 0b                	jne    802e0f <__umoddi3+0x8f>
  802e04:	b8 01 00 00 00       	mov    $0x1,%eax
  802e09:	31 d2                	xor    %edx,%edx
  802e0b:	f7 f1                	div    %ecx
  802e0d:	89 c1                	mov    %eax,%ecx
  802e0f:	89 f0                	mov    %esi,%eax
  802e11:	31 d2                	xor    %edx,%edx
  802e13:	f7 f1                	div    %ecx
  802e15:	8b 04 24             	mov    (%esp),%eax
  802e18:	f7 f1                	div    %ecx
  802e1a:	eb 98                	jmp    802db4 <__umoddi3+0x34>
  802e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e20:	89 f2                	mov    %esi,%edx
  802e22:	8b 74 24 10          	mov    0x10(%esp),%esi
  802e26:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802e2a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802e2e:	83 c4 1c             	add    $0x1c,%esp
  802e31:	c3                   	ret    
  802e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e38:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e3d:	89 e8                	mov    %ebp,%eax
  802e3f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e44:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802e48:	89 fa                	mov    %edi,%edx
  802e4a:	d3 e0                	shl    %cl,%eax
  802e4c:	89 e9                	mov    %ebp,%ecx
  802e4e:	d3 ea                	shr    %cl,%edx
  802e50:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e55:	09 c2                	or     %eax,%edx
  802e57:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e5b:	89 14 24             	mov    %edx,(%esp)
  802e5e:	89 f2                	mov    %esi,%edx
  802e60:	d3 e7                	shl    %cl,%edi
  802e62:	89 e9                	mov    %ebp,%ecx
  802e64:	d3 ea                	shr    %cl,%edx
  802e66:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e6f:	d3 e6                	shl    %cl,%esi
  802e71:	89 e9                	mov    %ebp,%ecx
  802e73:	d3 e8                	shr    %cl,%eax
  802e75:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e7a:	09 f0                	or     %esi,%eax
  802e7c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802e80:	f7 34 24             	divl   (%esp)
  802e83:	d3 e6                	shl    %cl,%esi
  802e85:	89 74 24 08          	mov    %esi,0x8(%esp)
  802e89:	89 d6                	mov    %edx,%esi
  802e8b:	f7 e7                	mul    %edi
  802e8d:	39 d6                	cmp    %edx,%esi
  802e8f:	89 c1                	mov    %eax,%ecx
  802e91:	89 d7                	mov    %edx,%edi
  802e93:	72 3f                	jb     802ed4 <__umoddi3+0x154>
  802e95:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802e99:	72 35                	jb     802ed0 <__umoddi3+0x150>
  802e9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e9f:	29 c8                	sub    %ecx,%eax
  802ea1:	19 fe                	sbb    %edi,%esi
  802ea3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802ea8:	89 f2                	mov    %esi,%edx
  802eaa:	d3 e8                	shr    %cl,%eax
  802eac:	89 e9                	mov    %ebp,%ecx
  802eae:	d3 e2                	shl    %cl,%edx
  802eb0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802eb5:	09 d0                	or     %edx,%eax
  802eb7:	89 f2                	mov    %esi,%edx
  802eb9:	d3 ea                	shr    %cl,%edx
  802ebb:	8b 74 24 10          	mov    0x10(%esp),%esi
  802ebf:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802ec3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802ec7:	83 c4 1c             	add    $0x1c,%esp
  802eca:	c3                   	ret    
  802ecb:	90                   	nop
  802ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ed0:	39 d6                	cmp    %edx,%esi
  802ed2:	75 c7                	jne    802e9b <__umoddi3+0x11b>
  802ed4:	89 d7                	mov    %edx,%edi
  802ed6:	89 c1                	mov    %eax,%ecx
  802ed8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  802edc:	1b 3c 24             	sbb    (%esp),%edi
  802edf:	eb ba                	jmp    802e9b <__umoddi3+0x11b>
  802ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ee8:	39 f5                	cmp    %esi,%ebp
  802eea:	0f 82 f1 fe ff ff    	jb     802de1 <__umoddi3+0x61>
  802ef0:	e9 f8 fe ff ff       	jmp    802ded <__umoddi3+0x6d>
