
obj/user/num:     file format elf32-i386


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
  80002c:	e8 cf 01 00 00       	call   800200 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <num>:
int bol = 1;
int line = 0;

void
num(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 38             	sub    $0x38,%esp
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003a:	e9 9d 00 00 00       	jmp    8000dc <num+0xa8>
		if (bol) {
  80003f:	a1 00 50 80 00       	mov    0x805000,%eax
  800044:	85 c0                	test   %eax,%eax
  800046:	74 34                	je     80007c <num+0x48>
			fprintf(1, "%5d ", ++line);
  800048:	a1 40 50 80 00       	mov    0x805040,%eax
  80004d:	83 c0 01             	add    $0x1,%eax
  800050:	a3 40 50 80 00       	mov    %eax,0x805040
  800055:	a1 40 50 80 00       	mov    0x805040,%eax
  80005a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80005e:	c7 44 24 04 80 29 80 	movl   $0x802980,0x4(%esp)
  800065:	00 
  800066:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80006d:	e8 52 22 00 00       	call   8022c4 <fprintf>
			bol = 0;
  800072:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  800079:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  80007c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800083:	00 
  800084:	8d 45 ef             	lea    -0x11(%ebp),%eax
  800087:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800092:	e8 54 19 00 00       	call   8019eb <write>
  800097:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80009a:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80009e:	74 2a                	je     8000ca <num+0x96>
			panic("write error copying %s: %e", s, r);
  8000a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000ae:	c7 44 24 08 85 29 80 	movl   $0x802985,0x8(%esp)
  8000b5:	00 
  8000b6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000bd:	00 
  8000be:	c7 04 24 a0 29 80 00 	movl   $0x8029a0,(%esp)
  8000c5:	e8 9a 01 00 00       	call   800264 <_panic>
		if (c == '\n')
  8000ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  8000ce:	3c 0a                	cmp    $0xa,%al
  8000d0:	75 0a                	jne    8000dc <num+0xa8>
			bol = 1;
  8000d2:	c7 05 00 50 80 00 01 	movl   $0x1,0x805000
  8000d9:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000e3:	00 
  8000e4:	8d 45 ef             	lea    -0x11(%ebp),%eax
  8000e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ee:	89 04 24             	mov    %eax,(%esp)
  8000f1:	e8 e1 17 00 00       	call   8018d7 <read>
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8000fd:	0f 8f 3c ff ff ff    	jg     80003f <num+0xb>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  800103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800107:	79 2a                	jns    800133 <num+0xff>
		panic("error reading %s: %e", s, n);
  800109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80010c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 ab 29 80 	movl   $0x8029ab,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 a0 29 80 00 	movl   $0x8029a0,(%esp)
  80012e:	e8 31 01 00 00       	call   800264 <_panic>
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <umain>:

void
umain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 38             	sub    $0x38,%esp
	int f, i;

	argv0 = "num";
  80013b:	c7 05 48 50 80 00 c0 	movl   $0x8029c0,0x805048
  800142:	29 80 00 
	if (argc == 1)
  800145:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800149:	75 19                	jne    800164 <umain+0x2f>
		num(0, "<stdin>");
  80014b:	c7 44 24 04 c4 29 80 	movl   $0x8029c4,0x4(%esp)
  800152:	00 
  800153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015a:	e8 d5 fe ff ff       	call   800034 <num>
  80015f:	e9 94 00 00 00       	jmp    8001f8 <umain+0xc3>
	else
		for (i = 1; i < argc; i++) {
  800164:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  80016b:	eb 7f                	jmp    8001ec <umain+0xb7>
			f = open(argv[i], O_RDONLY);
  80016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800170:	c1 e0 02             	shl    $0x2,%eax
  800173:	03 45 0c             	add    0xc(%ebp),%eax
  800176:	8b 00                	mov    (%eax),%eax
  800178:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80017f:	00 
  800180:	89 04 24             	mov    %eax,(%esp)
  800183:	e8 b4 1a 00 00       	call   801c3c <open>
  800188:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (f < 0)
  80018b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80018f:	79 32                	jns    8001c3 <umain+0x8e>
				panic("can't open %s: %e", argv[i], f);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	c1 e0 02             	shl    $0x2,%eax
  800197:	03 45 0c             	add    0xc(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80019f:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a7:	c7 44 24 08 cc 29 80 	movl   $0x8029cc,0x8(%esp)
  8001ae:	00 
  8001af:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  8001b6:	00 
  8001b7:	c7 04 24 a0 29 80 00 	movl   $0x8029a0,(%esp)
  8001be:	e8 a1 00 00 00       	call   800264 <_panic>
			else {
				num(f, argv[i]);
  8001c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001c6:	c1 e0 02             	shl    $0x2,%eax
  8001c9:	03 45 0c             	add    0xc(%ebp),%eax
  8001cc:	8b 00                	mov    (%eax),%eax
  8001ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 57 fe ff ff       	call   800034 <num>
				close(f);
  8001dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e0:	89 04 24             	mov    %eax,(%esp)
  8001e3:	e8 0f 15 00 00       	call   8016f7 <close>

	argv0 = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8001ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8001f2:	0f 8c 75 ff ff ff    	jl     80016d <umain+0x38>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001f8:	e8 4b 00 00 00       	call   800248 <exit>
}
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    
	...

00800200 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  800206:	e8 53 10 00 00       	call   80125e <sys_getenvid>
  80020b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800210:	c1 e0 07             	shl    $0x7,%eax
  800213:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800218:	a3 44 50 80 00       	mov    %eax,0x805044
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800221:	7e 0a                	jle    80022d <libmain+0x2d>
		binaryname = argv[0];
  800223:	8b 45 0c             	mov    0xc(%ebp),%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	umain(argc, argv);
  80022d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800230:	89 44 24 04          	mov    %eax,0x4(%esp)
  800234:	8b 45 08             	mov    0x8(%ebp),%eax
  800237:	89 04 24             	mov    %eax,(%esp)
  80023a:	e8 f6 fe ff ff       	call   800135 <umain>

	// exit gracefully
	exit();
  80023f:	e8 04 00 00 00       	call   800248 <exit>
}
  800244:	c9                   	leave  
  800245:	c3                   	ret    
	...

00800248 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80024e:	e8 df 14 00 00       	call   801732 <close_all>
	sys_env_destroy(0);
  800253:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80025a:	e8 bc 0f 00 00       	call   80121b <sys_env_destroy>
}
  80025f:	c9                   	leave  
  800260:	c3                   	ret    
  800261:	00 00                	add    %al,(%eax)
	...

00800264 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  80026a:	8d 45 10             	lea    0x10(%ebp),%eax
  80026d:	83 c0 04             	add    $0x4,%eax
  800270:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800273:	a1 48 50 80 00       	mov    0x805048,%eax
  800278:	85 c0                	test   %eax,%eax
  80027a:	74 15                	je     800291 <_panic+0x2d>
		cprintf("%s: ", argv0);
  80027c:	a1 48 50 80 00       	mov    0x805048,%eax
  800281:	89 44 24 04          	mov    %eax,0x4(%esp)
  800285:	c7 04 24 f5 29 80 00 	movl   $0x8029f5,(%esp)
  80028c:	e8 07 01 00 00       	call   800398 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800291:	a1 04 50 80 00       	mov    0x805004,%eax
  800296:	8b 55 0c             	mov    0xc(%ebp),%edx
  800299:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80029d:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a8:	c7 04 24 fa 29 80 00 	movl   $0x8029fa,(%esp)
  8002af:	e8 e4 00 00 00       	call   800398 <cprintf>
	vcprintf(fmt, ap);
  8002b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002be:	89 04 24             	mov    %eax,(%esp)
  8002c1:	e8 6e 00 00 00       	call   800334 <vcprintf>
	cprintf("\n");
  8002c6:	c7 04 24 16 2a 80 00 	movl   $0x802a16,(%esp)
  8002cd:	e8 c6 00 00 00       	call   800398 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d2:	cc                   	int3   
  8002d3:	eb fd                	jmp    8002d2 <_panic+0x6e>
  8002d5:	00 00                	add    %al,(%eax)
	...

008002d8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  8002de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e6:	89 d1                	mov    %edx,%ecx
  8002e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002eb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  8002ef:	8d 50 01             	lea    0x1(%eax),%edx
  8002f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f5:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	8b 00                	mov    (%eax),%eax
  8002fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800301:	75 20                	jne    800323 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  800303:	8b 45 0c             	mov    0xc(%ebp),%eax
  800306:	8b 00                	mov    (%eax),%eax
  800308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80030b:	83 c2 08             	add    $0x8,%edx
  80030e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800312:	89 14 24             	mov    %edx,(%esp)
  800315:	e8 7b 0e 00 00       	call   801195 <sys_cputs>
		b->idx = 0;
  80031a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800323:	8b 45 0c             	mov    0xc(%ebp),%eax
  800326:	8b 40 04             	mov    0x4(%eax),%eax
  800329:	8d 50 01             	lea    0x1(%eax),%edx
  80032c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800332:	c9                   	leave  
  800333:	c3                   	ret    

00800334 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80033d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800344:	00 00 00 
	b.cnt = 0;
  800347:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80034e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800358:	8b 45 08             	mov    0x8(%ebp),%eax
  80035b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80035f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800365:	89 44 24 04          	mov    %eax,0x4(%esp)
  800369:	c7 04 24 d8 02 80 00 	movl   $0x8002d8,(%esp)
  800370:	e8 f7 01 00 00       	call   80056c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800375:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80037b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800385:	83 c0 08             	add    $0x8,%eax
  800388:	89 04 24             	mov    %eax,(%esp)
  80038b:	e8 05 0e 00 00       	call   801195 <sys_cputs>

	return b.cnt;
  800390:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80039e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003ae:	89 04 24             	mov    %eax,(%esp)
  8003b1:	e8 7e ff ff ff       	call   800334 <vcprintf>
  8003b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003bc:	c9                   	leave  
  8003bd:	c3                   	ret    
	...

008003c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	53                   	push   %ebx
  8003c4:	83 ec 34             	sub    $0x34,%esp
  8003c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003de:	77 72                	ja     800452 <printnum+0x92>
  8003e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003e3:	72 05                	jb     8003ea <printnum+0x2a>
  8003e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003e8:	77 68                	ja     800452 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800406:	89 04 24             	mov    %eax,(%esp)
  800409:	89 54 24 04          	mov    %edx,0x4(%esp)
  80040d:	e8 be 22 00 00       	call   8026d0 <__udivdi3>
  800412:	8b 4d 20             	mov    0x20(%ebp),%ecx
  800415:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  800419:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  80041d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800420:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800424:	89 44 24 08          	mov    %eax,0x8(%esp)
  800428:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80042c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	89 04 24             	mov    %eax,(%esp)
  800439:	e8 82 ff ff ff       	call   8003c0 <printnum>
  80043e:	eb 1c                	jmp    80045c <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800440:	8b 45 0c             	mov    0xc(%ebp),%eax
  800443:	89 44 24 04          	mov    %eax,0x4(%esp)
  800447:	8b 45 20             	mov    0x20(%ebp),%eax
  80044a:	89 04 24             	mov    %eax,(%esp)
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800452:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800456:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80045a:	7f e4                	jg     800440 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80046a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80046e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800472:	89 04 24             	mov    %eax,(%esp)
  800475:	89 54 24 04          	mov    %edx,0x4(%esp)
  800479:	e8 82 23 00 00       	call   802800 <__umoddi3>
  80047e:	05 7c 2b 80 00       	add    $0x802b7c,%eax
  800483:	0f b6 00             	movzbl (%eax),%eax
  800486:	0f be c0             	movsbl %al,%eax
  800489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800490:	89 04 24             	mov    %eax,(%esp)
  800493:	8b 45 08             	mov    0x8(%ebp),%eax
  800496:	ff d0                	call   *%eax
}
  800498:	83 c4 34             	add    $0x34,%esp
  80049b:	5b                   	pop    %ebx
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004a5:	7e 1c                	jle    8004c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 50 08             	lea    0x8(%eax),%edx
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	89 10                	mov    %edx,(%eax)
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	83 e8 08             	sub    $0x8,%eax
  8004bc:	8b 50 04             	mov    0x4(%eax),%edx
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	eb 40                	jmp    800503 <getuint+0x65>
	else if (lflag)
  8004c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004c7:	74 1e                	je     8004e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	8d 50 04             	lea    0x4(%eax),%edx
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	89 10                	mov    %edx,(%eax)
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	83 e8 04             	sub    $0x4,%eax
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e5:	eb 1c                	jmp    800503 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	8d 50 04             	lea    0x4(%eax),%edx
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	89 10                	mov    %edx,(%eax)
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	83 e8 04             	sub    $0x4,%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800503:	5d                   	pop    %ebp
  800504:	c3                   	ret    

00800505 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800508:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80050c:	7e 1c                	jle    80052a <getint+0x25>
		return va_arg(*ap, long long);
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	8d 50 08             	lea    0x8(%eax),%edx
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	89 10                	mov    %edx,(%eax)
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	83 e8 08             	sub    $0x8,%eax
  800523:	8b 50 04             	mov    0x4(%eax),%edx
  800526:	8b 00                	mov    (%eax),%eax
  800528:	eb 40                	jmp    80056a <getint+0x65>
	else if (lflag)
  80052a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80052e:	74 1e                	je     80054e <getint+0x49>
		return va_arg(*ap, long);
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	8d 50 04             	lea    0x4(%eax),%edx
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	89 10                	mov    %edx,(%eax)
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 e8 04             	sub    $0x4,%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	89 c2                	mov    %eax,%edx
  800549:	c1 fa 1f             	sar    $0x1f,%edx
  80054c:	eb 1c                	jmp    80056a <getint+0x65>
	else
		return va_arg(*ap, int);
  80054e:	8b 45 08             	mov    0x8(%ebp),%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	8d 50 04             	lea    0x4(%eax),%edx
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	89 10                	mov    %edx,(%eax)
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	83 e8 04             	sub    $0x4,%eax
  800563:	8b 00                	mov    (%eax),%eax
  800565:	89 c2                	mov    %eax,%edx
  800567:	c1 fa 1f             	sar    $0x1f,%edx
}
  80056a:	5d                   	pop    %ebp
  80056b:	c3                   	ret    

0080056c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	56                   	push   %esi
  800570:	53                   	push   %ebx
  800571:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800574:	eb 17                	jmp    80058d <vprintfmt+0x21>
			if (ch == '\0')
  800576:	85 db                	test   %ebx,%ebx
  800578:	0f 84 d1 05 00 00    	je     800b4f <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  80057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800581:	89 44 24 04          	mov    %eax,0x4(%esp)
  800585:	89 1c 24             	mov    %ebx,(%esp)
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80058d:	8b 45 10             	mov    0x10(%ebp),%eax
  800590:	0f b6 00             	movzbl (%eax),%eax
  800593:	0f b6 d8             	movzbl %al,%ebx
  800596:	83 fb 25             	cmp    $0x25,%ebx
  800599:	0f 95 c0             	setne  %al
  80059c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8005a0:	84 c0                	test   %al,%al
  8005a2:	75 d2                	jne    800576 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005a4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005a8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005af:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005c4:	eb 04                	jmp    8005ca <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8005c6:	90                   	nop
  8005c7:	eb 01                	jmp    8005ca <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8005c9:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	0f b6 00             	movzbl (%eax),%eax
  8005d0:	0f b6 d8             	movzbl %al,%ebx
  8005d3:	89 d8                	mov    %ebx,%eax
  8005d5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8005d9:	83 e8 23             	sub    $0x23,%eax
  8005dc:	83 f8 55             	cmp    $0x55,%eax
  8005df:	0f 87 39 05 00 00    	ja     800b1e <vprintfmt+0x5b2>
  8005e5:	8b 04 85 c4 2b 80 00 	mov    0x802bc4(,%eax,4),%eax
  8005ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005f2:	eb d6                	jmp    8005ca <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005f8:	eb d0                	jmp    8005ca <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800601:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800604:	89 d0                	mov    %edx,%eax
  800606:	c1 e0 02             	shl    $0x2,%eax
  800609:	01 d0                	add    %edx,%eax
  80060b:	01 c0                	add    %eax,%eax
  80060d:	01 d8                	add    %ebx,%eax
  80060f:	83 e8 30             	sub    $0x30,%eax
  800612:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800615:	8b 45 10             	mov    0x10(%ebp),%eax
  800618:	0f b6 00             	movzbl (%eax),%eax
  80061b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80061e:	83 fb 2f             	cmp    $0x2f,%ebx
  800621:	7e 43                	jle    800666 <vprintfmt+0xfa>
  800623:	83 fb 39             	cmp    $0x39,%ebx
  800626:	7f 3e                	jg     800666 <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800628:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80062c:	eb d3                	jmp    800601 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	83 c0 04             	add    $0x4,%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	83 e8 04             	sub    $0x4,%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800642:	eb 23                	jmp    800667 <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  800644:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800648:	0f 89 78 ff ff ff    	jns    8005c6 <vprintfmt+0x5a>
				width = 0;
  80064e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800655:	e9 6c ff ff ff       	jmp    8005c6 <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  80065a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800661:	e9 64 ff ff ff       	jmp    8005ca <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800666:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800667:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066b:	0f 89 58 ff ff ff    	jns    8005c9 <vprintfmt+0x5d>
				width = precision, precision = -1;
  800671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800674:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800677:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80067e:	e9 46 ff ff ff       	jmp    8005c9 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800683:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  800687:	e9 3e ff ff ff       	jmp    8005ca <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	83 c0 04             	add    $0x4,%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	83 e8 04             	sub    $0x4,%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006a4:	89 04 24             	mov    %eax,(%esp)
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	ff d0                	call   *%eax
			break;
  8006ac:	e9 98 04 00 00       	jmp    800b49 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  8006b1:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  8006b8:	00 
  8006b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c0:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006c3:	89 04 24             	mov    %eax,(%esp)
  8006c6:	e8 d1 07 00 00       	call   800e9c <memmove>
            sel_c[3] = '\0';
  8006cb:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  8006cf:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  8006d3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8006d7:	3c 2f                	cmp    $0x2f,%al
  8006d9:	7e 4c                	jle    800727 <vprintfmt+0x1bb>
  8006db:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8006df:	3c 39                	cmp    $0x39,%al
  8006e1:	7f 44                	jg     800727 <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  8006e3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8006e7:	0f be d0             	movsbl %al,%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	01 c0                	add    %eax,%eax
  8006f3:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8006f9:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  8006fd:	0f be c0             	movsbl %al,%eax
  800700:	01 c2                	add    %eax,%edx
  800702:	89 d0                	mov    %edx,%eax
  800704:	c1 e0 02             	shl    $0x2,%eax
  800707:	01 d0                	add    %edx,%eax
  800709:	01 c0                	add    %eax,%eax
  80070b:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800711:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  800715:	0f be c0             	movsbl %al,%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	83 e8 30             	sub    $0x30,%eax
  80071d:	a3 08 50 80 00       	mov    %eax,0x805008
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800722:	e9 22 04 00 00       	jmp    800b49 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  800727:	c7 44 24 04 8d 2b 80 	movl   $0x802b8d,0x4(%esp)
  80072e:	00 
  80072f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800732:	89 04 24             	mov    %eax,(%esp)
  800735:	e8 36 06 00 00       	call   800d70 <strcmp>
  80073a:	85 c0                	test   %eax,%eax
  80073c:	75 0f                	jne    80074d <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  80073e:	c7 05 08 50 80 00 07 	movl   $0x7,0x805008
  800745:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800748:	e9 fc 03 00 00       	jmp    800b49 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  80074d:	c7 44 24 04 91 2b 80 	movl   $0x802b91,0x4(%esp)
  800754:	00 
  800755:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800758:	89 04 24             	mov    %eax,(%esp)
  80075b:	e8 10 06 00 00       	call   800d70 <strcmp>
  800760:	85 c0                	test   %eax,%eax
  800762:	75 0f                	jne    800773 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  800764:	c7 05 08 50 80 00 01 	movl   $0x1,0x805008
  80076b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80076e:	e9 d6 03 00 00       	jmp    800b49 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  800773:	c7 44 24 04 95 2b 80 	movl   $0x802b95,0x4(%esp)
  80077a:	00 
  80077b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80077e:	89 04 24             	mov    %eax,(%esp)
  800781:	e8 ea 05 00 00       	call   800d70 <strcmp>
  800786:	85 c0                	test   %eax,%eax
  800788:	75 0f                	jne    800799 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  80078a:	c7 05 08 50 80 00 02 	movl   $0x2,0x805008
  800791:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800794:	e9 b0 03 00 00       	jmp    800b49 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  800799:	c7 44 24 04 99 2b 80 	movl   $0x802b99,0x4(%esp)
  8007a0:	00 
  8007a1:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007a4:	89 04 24             	mov    %eax,(%esp)
  8007a7:	e8 c4 05 00 00       	call   800d70 <strcmp>
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	75 0f                	jne    8007bf <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  8007b0:	c7 05 08 50 80 00 04 	movl   $0x4,0x805008
  8007b7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007ba:	e9 8a 03 00 00       	jmp    800b49 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  8007bf:	c7 44 24 04 9d 2b 80 	movl   $0x802b9d,0x4(%esp)
  8007c6:	00 
  8007c7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007ca:	89 04 24             	mov    %eax,(%esp)
  8007cd:	e8 9e 05 00 00       	call   800d70 <strcmp>
  8007d2:	85 c0                	test   %eax,%eax
  8007d4:	75 0f                	jne    8007e5 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  8007d6:	c7 05 08 50 80 00 08 	movl   $0x8,0x805008
  8007dd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007e0:	e9 64 03 00 00       	jmp    800b49 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  8007e5:	c7 44 24 04 a1 2b 80 	movl   $0x802ba1,0x4(%esp)
  8007ec:	00 
  8007ed:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007f0:	89 04 24             	mov    %eax,(%esp)
  8007f3:	e8 78 05 00 00       	call   800d70 <strcmp>
  8007f8:	85 c0                	test   %eax,%eax
  8007fa:	75 0f                	jne    80080b <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  8007fc:	c7 05 08 50 80 00 0f 	movl   $0xf,0x805008
  800803:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800806:	e9 3e 03 00 00       	jmp    800b49 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  80080b:	c7 44 24 04 a5 2b 80 	movl   $0x802ba5,0x4(%esp)
  800812:	00 
  800813:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800816:	89 04 24             	mov    %eax,(%esp)
  800819:	e8 52 05 00 00       	call   800d70 <strcmp>
  80081e:	85 c0                	test   %eax,%eax
  800820:	75 0f                	jne    800831 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  800822:	c7 05 08 50 80 00 0c 	movl   $0xc,0x805008
  800829:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80082c:	e9 18 03 00 00       	jmp    800b49 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  800831:	c7 44 24 04 a9 2b 80 	movl   $0x802ba9,0x4(%esp)
  800838:	00 
  800839:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80083c:	89 04 24             	mov    %eax,(%esp)
  80083f:	e8 2c 05 00 00       	call   800d70 <strcmp>
  800844:	85 c0                	test   %eax,%eax
  800846:	75 0f                	jne    800857 <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  800848:	c7 05 08 50 80 00 06 	movl   $0x6,0x805008
  80084f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800852:	e9 f2 02 00 00       	jmp    800b49 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  800857:	c7 44 24 04 ad 2b 80 	movl   $0x802bad,0x4(%esp)
  80085e:	00 
  80085f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800862:	89 04 24             	mov    %eax,(%esp)
  800865:	e8 06 05 00 00       	call   800d70 <strcmp>
  80086a:	85 c0                	test   %eax,%eax
  80086c:	75 0f                	jne    80087d <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  80086e:	c7 05 08 50 80 00 0b 	movl   $0xb,0x805008
  800875:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800878:	e9 cc 02 00 00       	jmp    800b49 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  80087d:	c7 05 08 50 80 00 07 	movl   $0x7,0x805008
  800884:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800887:	e9 bd 02 00 00       	jmp    800b49 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	83 c0 04             	add    $0x4,%eax
  800892:	89 45 14             	mov    %eax,0x14(%ebp)
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	83 e8 04             	sub    $0x4,%eax
  80089b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80089d:	85 db                	test   %ebx,%ebx
  80089f:	79 02                	jns    8008a3 <vprintfmt+0x337>
				err = -err;
  8008a1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a3:	83 fb 0e             	cmp    $0xe,%ebx
  8008a6:	7f 0b                	jg     8008b3 <vprintfmt+0x347>
  8008a8:	8b 34 9d 40 2b 80 00 	mov    0x802b40(,%ebx,4),%esi
  8008af:	85 f6                	test   %esi,%esi
  8008b1:	75 23                	jne    8008d6 <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  8008b3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8008b7:	c7 44 24 08 b1 2b 80 	movl   $0x802bb1,0x8(%esp)
  8008be:	00 
  8008bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	89 04 24             	mov    %eax,(%esp)
  8008cc:	e8 86 02 00 00       	call   800b57 <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008d1:	e9 73 02 00 00       	jmp    800b49 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008da:	c7 44 24 08 ba 2b 80 	movl   $0x802bba,0x8(%esp)
  8008e1:	00 
  8008e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	89 04 24             	mov    %eax,(%esp)
  8008ef:	e8 63 02 00 00       	call   800b57 <printfmt>
			break;
  8008f4:	e9 50 02 00 00       	jmp    800b49 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 30                	mov    (%eax),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 05                	jne    800913 <vprintfmt+0x3a7>
				p = "(null)";
  80090e:	be bd 2b 80 00       	mov    $0x802bbd,%esi
			if (width > 0 && padc != '-')
  800913:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800917:	7e 73                	jle    80098c <vprintfmt+0x420>
  800919:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80091d:	74 6d                	je     80098c <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	89 44 24 04          	mov    %eax,0x4(%esp)
  800926:	89 34 24             	mov    %esi,(%esp)
  800929:	e8 4c 03 00 00       	call   800c7a <strnlen>
  80092e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800931:	eb 17                	jmp    80094a <vprintfmt+0x3de>
					putch(padc, putdat);
  800933:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80093e:	89 04 24             	mov    %eax,(%esp)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800946:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e3                	jg     800933 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800950:	eb 3a                	jmp    80098c <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  800952:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800956:	74 1f                	je     800977 <vprintfmt+0x40b>
  800958:	83 fb 1f             	cmp    $0x1f,%ebx
  80095b:	7e 05                	jle    800962 <vprintfmt+0x3f6>
  80095d:	83 fb 7e             	cmp    $0x7e,%ebx
  800960:	7e 15                	jle    800977 <vprintfmt+0x40b>
					putch('?', putdat);
  800962:	8b 45 0c             	mov    0xc(%ebp),%eax
  800965:	89 44 24 04          	mov    %eax,0x4(%esp)
  800969:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	ff d0                	call   *%eax
  800975:	eb 0f                	jmp    800986 <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80097e:	89 1c 24             	mov    %ebx,(%esp)
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80098a:	eb 01                	jmp    80098d <vprintfmt+0x421>
  80098c:	90                   	nop
  80098d:	0f b6 06             	movzbl (%esi),%eax
  800990:	0f be d8             	movsbl %al,%ebx
  800993:	85 db                	test   %ebx,%ebx
  800995:	0f 95 c0             	setne  %al
  800998:	83 c6 01             	add    $0x1,%esi
  80099b:	84 c0                	test   %al,%al
  80099d:	74 29                	je     8009c8 <vprintfmt+0x45c>
  80099f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a3:	78 ad                	js     800952 <vprintfmt+0x3e6>
  8009a5:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  8009a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ad:	79 a3                	jns    800952 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009af:	eb 17                	jmp    8009c8 <vprintfmt+0x45c>
				putch(' ', putdat);
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8009c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cc:	7f e3                	jg     8009b1 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  8009ce:	e9 76 01 00 00       	jmp    800b49 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009da:	8d 45 14             	lea    0x14(%ebp),%eax
  8009dd:	89 04 24             	mov    %eax,(%esp)
  8009e0:	e8 20 fb ff ff       	call   800505 <getint>
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f1:	85 d2                	test   %edx,%edx
  8009f3:	79 26                	jns    800a1b <vprintfmt+0x4af>
				putch('-', putdat);
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009fc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
				num = -(long long) num;
  800a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a0e:	f7 d8                	neg    %eax
  800a10:	83 d2 00             	adc    $0x0,%edx
  800a13:	f7 da                	neg    %edx
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 ae 00 00 00       	jmp    800ad5 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a31:	89 04 24             	mov    %eax,(%esp)
  800a34:	e8 65 fa ff ff       	call   80049e <getuint>
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a46:	e9 8a 00 00 00       	jmp    800ad5 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  800a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a52:	8d 45 14             	lea    0x14(%ebp),%eax
  800a55:	89 04 24             	mov    %eax,(%esp)
  800a58:	e8 41 fa ff ff       	call   80049e <getuint>
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  800a63:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  800a6a:	eb 69                	jmp    800ad5 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a73:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
			putch('x', putdat);
  800a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a86:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a92:	8b 45 14             	mov    0x14(%ebp),%eax
  800a95:	83 c0 04             	add    $0x4,%eax
  800a98:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	83 e8 04             	sub    $0x4,%eax
  800aa1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800aad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab4:	eb 1f                	jmp    800ad5 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ab6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac0:	89 04 24             	mov    %eax,(%esp)
  800ac3:	e8 d6 f9 ff ff       	call   80049e <getuint>
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ace:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ad5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800adc:	89 54 24 18          	mov    %edx,0x18(%esp)
  800ae0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ae3:	89 54 24 14          	mov    %edx,0x14(%esp)
  800ae7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 04 24             	mov    %eax,(%esp)
  800b06:	e8 b5 f8 ff ff       	call   8003c0 <printnum>
			break;
  800b0b:	eb 3c                	jmp    800b49 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b14:	89 1c 24             	mov    %ebx,(%esp)
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
			break;
  800b1c:	eb 2b                	jmp    800b49 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b25:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b31:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b35:	eb 04                	jmp    800b3b <vprintfmt+0x5cf>
  800b37:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3e:	83 e8 01             	sub    $0x1,%eax
  800b41:	0f b6 00             	movzbl (%eax),%eax
  800b44:	3c 25                	cmp    $0x25,%al
  800b46:	75 ef                	jne    800b37 <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800b48:	90                   	nop
		}
	}
  800b49:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4a:	e9 3e fa ff ff       	jmp    80058d <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800b4f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b50:	83 c4 50             	add    $0x50,%esp
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800b5d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b60:	83 c0 04             	add    $0x4,%eax
  800b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b66:	8b 45 10             	mov    0x10(%ebp),%eax
  800b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b70:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 04 24             	mov    %eax,(%esp)
  800b81:	e8 e6 f9 ff ff       	call   80056c <vprintfmt>
	va_end(ap);
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8b 40 08             	mov    0x8(%eax),%eax
  800b91:	8d 50 01             	lea    0x1(%eax),%edx
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8b 10                	mov    (%eax),%edx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	8b 40 04             	mov    0x4(%eax),%eax
  800ba5:	39 c2                	cmp    %eax,%edx
  800ba7:	73 12                	jae    800bbb <sprintputch+0x33>
		*b->buf++ = ch;
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8b 00                	mov    (%eax),%eax
  800bae:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb1:	88 10                	mov    %dl,(%eax)
  800bb3:	8d 50 01             	lea    0x1(%eax),%edx
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	89 10                	mov    %edx,(%eax)
}
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	83 e8 01             	sub    $0x1,%eax
  800bcf:	03 45 08             	add    0x8(%ebp),%eax
  800bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800be0:	74 06                	je     800be8 <vsnprintf+0x2b>
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	7f 07                	jg     800bef <vsnprintf+0x32>
		return -E_INVAL;
  800be8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bed:	eb 2a                	jmp    800c19 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bef:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bfd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c04:	c7 04 24 88 0b 80 00 	movl   $0x800b88,(%esp)
  800c0b:	e8 5c f9 ff ff       	call   80056c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c13:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c21:	8d 45 10             	lea    0x10(%ebp),%eax
  800c24:	83 c0 04             	add    $0x4,%eax
  800c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c30:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c34:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 04 24             	mov    %eax,(%esp)
  800c45:	e8 73 ff ff ff       	call   800bbd <vsnprintf>
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    
	...

00800c54 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c61:	eb 08                	jmp    800c6b <strlen+0x17>
		n++;
  800c63:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	0f b6 00             	movzbl (%eax),%eax
  800c71:	84 c0                	test   %al,%al
  800c73:	75 ee                	jne    800c63 <strlen+0xf>
		n++;
	return n;
  800c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c87:	eb 0c                	jmp    800c95 <strnlen+0x1b>
		n++;
  800c89:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c91:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800c95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c99:	74 0a                	je     800ca5 <strnlen+0x2b>
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	0f b6 00             	movzbl (%eax),%eax
  800ca1:	84 c0                	test   %al,%al
  800ca3:	75 e4                	jne    800c89 <strnlen+0xf>
		n++;
	return n;
  800ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb6:	90                   	nop
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	0f b6 10             	movzbl (%eax),%edx
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	88 10                	mov    %dl,(%eax)
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	0f b6 00             	movzbl (%eax),%eax
  800cc8:	84 c0                	test   %al,%al
  800cca:	0f 95 c0             	setne  %al
  800ccd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cd1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800cd5:	84 c0                	test   %al,%al
  800cd7:	75 de                	jne    800cb7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf1:	eb 21                	jmp    800d14 <strncpy+0x36>
		*dst++ = *src;
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	0f b6 10             	movzbl (%eax),%edx
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	88 10                	mov    %dl,(%eax)
  800cfe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	0f b6 00             	movzbl (%eax),%eax
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 04                	je     800d10 <strncpy+0x32>
			src++;
  800d0c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d10:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d17:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d1a:	72 d7                	jb     800cf3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d31:	74 2f                	je     800d62 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800d33:	eb 13                	jmp    800d48 <strlcpy+0x27>
			*dst++ = *src++;
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	0f b6 10             	movzbl (%eax),%edx
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	88 10                	mov    %dl,(%eax)
  800d40:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d44:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d48:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d50:	74 0a                	je     800d5c <strlcpy+0x3b>
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	0f b6 00             	movzbl (%eax),%eax
  800d58:	84 c0                	test   %al,%al
  800d5a:	75 d9                	jne    800d35 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	89 d1                	mov    %edx,%ecx
  800d6a:	29 c1                	sub    %eax,%ecx
  800d6c:	89 c8                	mov    %ecx,%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d73:	eb 08                	jmp    800d7d <strcmp+0xd>
		p++, q++;
  800d75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d79:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	0f b6 00             	movzbl (%eax),%eax
  800d83:	84 c0                	test   %al,%al
  800d85:	74 10                	je     800d97 <strcmp+0x27>
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	0f b6 10             	movzbl (%eax),%edx
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	0f b6 00             	movzbl (%eax),%eax
  800d93:	38 c2                	cmp    %al,%dl
  800d95:	74 de                	je     800d75 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	0f b6 00             	movzbl (%eax),%eax
  800d9d:	0f b6 d0             	movzbl %al,%edx
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	0f b6 00             	movzbl (%eax),%eax
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	89 d1                	mov    %edx,%ecx
  800dab:	29 c1                	sub    %eax,%ecx
  800dad:	89 c8                	mov    %ecx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db4:	eb 0c                	jmp    800dc2 <strncmp+0x11>
		n--, p++, q++;
  800db6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800dba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dbe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800dc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc6:	74 1a                	je     800de2 <strncmp+0x31>
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	0f b6 00             	movzbl (%eax),%eax
  800dce:	84 c0                	test   %al,%al
  800dd0:	74 10                	je     800de2 <strncmp+0x31>
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	0f b6 10             	movzbl (%eax),%edx
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	0f b6 00             	movzbl (%eax),%eax
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 d4                	je     800db6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800de2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de6:	75 07                	jne    800def <strncmp+0x3e>
		return 0;
  800de8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ded:	eb 18                	jmp    800e07 <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	0f b6 00             	movzbl (%eax),%eax
  800df5:	0f b6 d0             	movzbl %al,%edx
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	0f b6 00             	movzbl (%eax),%eax
  800dfe:	0f b6 c0             	movzbl %al,%eax
  800e01:	89 d1                	mov    %edx,%ecx
  800e03:	29 c1                	sub    %eax,%ecx
  800e05:	89 c8                	mov    %ecx,%eax
}
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 04             	sub    $0x4,%esp
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e15:	eb 14                	jmp    800e2b <strchr+0x22>
		if (*s == c)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	0f b6 00             	movzbl (%eax),%eax
  800e1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e20:	75 05                	jne    800e27 <strchr+0x1e>
			return (char *) s;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	eb 13                	jmp    800e3a <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e27:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	0f b6 00             	movzbl (%eax),%eax
  800e31:	84 c0                	test   %al,%al
  800e33:	75 e2                	jne    800e17 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 04             	sub    $0x4,%esp
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e48:	eb 0f                	jmp    800e59 <strfind+0x1d>
		if (*s == c)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	0f b6 00             	movzbl (%eax),%eax
  800e50:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e53:	74 10                	je     800e65 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	0f b6 00             	movzbl (%eax),%eax
  800e5f:	84 c0                	test   %al,%al
  800e61:	75 e7                	jne    800e4a <strfind+0xe>
  800e63:	eb 01                	jmp    800e66 <strfind+0x2a>
		if (*s == c)
			break;
  800e65:	90                   	nop
	return (char *) s;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e69:	c9                   	leave  
  800e6a:	c3                   	ret    

00800e6b <memset>:


void *
memset(void *v, int c, size_t n)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e77:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e7d:	eb 0e                	jmp    800e8d <memset+0x22>
		*p++ = c;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 c2                	mov    %eax,%edx
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e87:	88 10                	mov    %dl,(%eax)
  800e89:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e8d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800e91:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e95:	79 e8                	jns    800e7f <memset+0x14>
		*p++ = c;

	return v;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eb4:	73 54                	jae    800f0a <memmove+0x6e>
  800eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebc:	01 d0                	add    %edx,%eax
  800ebe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ec1:	76 47                	jbe    800f0a <memmove+0x6e>
		s += n;
  800ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ecf:	eb 13                	jmp    800ee4 <memmove+0x48>
			*--d = *--s;
  800ed1:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800ed5:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	0f b6 10             	movzbl (%eax),%edx
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ee4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee8:	0f 95 c0             	setne  %al
  800eeb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800eef:	84 c0                	test   %al,%al
  800ef1:	75 de                	jne    800ed1 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef3:	eb 25                	jmp    800f1a <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef8:	0f b6 10             	movzbl (%eax),%edx
  800efb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efe:	88 10                	mov    %dl,(%eax)
  800f00:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800f04:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800f08:	eb 01                	jmp    800f0b <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0a:	90                   	nop
  800f0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0f:	0f 95 c0             	setne  %al
  800f12:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800f16:	84 c0                	test   %al,%al
  800f18:	75 db                	jne    800ef5 <memmove+0x59>
			*d++ = *s++;

	return dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1d:	c9                   	leave  
  800f1e:	c3                   	ret    

00800f1f <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	89 04 24             	mov    %eax,(%esp)
  800f39:	e8 5e ff ff ff       	call   800e9c <memmove>
}
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f52:	eb 32                	jmp    800f86 <memcmp+0x46>
		if (*s1 != *s2)
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	0f b6 10             	movzbl (%eax),%edx
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	0f b6 00             	movzbl (%eax),%eax
  800f60:	38 c2                	cmp    %al,%dl
  800f62:	74 1a                	je     800f7e <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f67:	0f b6 00             	movzbl (%eax),%eax
  800f6a:	0f b6 d0             	movzbl %al,%edx
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	0f b6 00             	movzbl (%eax),%eax
  800f73:	0f b6 c0             	movzbl %al,%eax
  800f76:	89 d1                	mov    %edx,%ecx
  800f78:	29 c1                	sub    %eax,%ecx
  800f7a:	89 c8                	mov    %ecx,%eax
  800f7c:	eb 1c                	jmp    800f9a <memcmp+0x5a>
		s1++, s2++;
  800f7e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800f82:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8a:	0f 95 c0             	setne  %al
  800f8d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800f91:	84 c0                	test   %al,%al
  800f93:	75 bf                	jne    800f54 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fad:	eb 11                	jmp    800fc0 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	0f b6 10             	movzbl (%eax),%edx
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	38 c2                	cmp    %al,%dl
  800fba:	74 0e                	je     800fca <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fbc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc6:	72 e7                	jb     800faf <memfind+0x13>
  800fc8:	eb 01                	jmp    800fcb <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fca:	90                   	nop
	return (void *) s;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fdd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	eb 04                	jmp    800fea <strtol+0x1a>
		s++;
  800fe6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	0f b6 00             	movzbl (%eax),%eax
  800ff0:	3c 20                	cmp    $0x20,%al
  800ff2:	74 f2                	je     800fe6 <strtol+0x16>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	0f b6 00             	movzbl (%eax),%eax
  800ffa:	3c 09                	cmp    $0x9,%al
  800ffc:	74 e8                	je     800fe6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	0f b6 00             	movzbl (%eax),%eax
  801004:	3c 2b                	cmp    $0x2b,%al
  801006:	75 06                	jne    80100e <strtol+0x3e>
		s++;
  801008:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80100c:	eb 15                	jmp    801023 <strtol+0x53>
	else if (*s == '-')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	0f b6 00             	movzbl (%eax),%eax
  801014:	3c 2d                	cmp    $0x2d,%al
  801016:	75 0b                	jne    801023 <strtol+0x53>
		s++, neg = 1;
  801018:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80101c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	74 06                	je     80102f <strtol+0x5f>
  801029:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80102d:	75 24                	jne    801053 <strtol+0x83>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	0f b6 00             	movzbl (%eax),%eax
  801035:	3c 30                	cmp    $0x30,%al
  801037:	75 1a                	jne    801053 <strtol+0x83>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	83 c0 01             	add    $0x1,%eax
  80103f:	0f b6 00             	movzbl (%eax),%eax
  801042:	3c 78                	cmp    $0x78,%al
  801044:	75 0d                	jne    801053 <strtol+0x83>
		s += 2, base = 16;
  801046:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80104a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801051:	eb 2a                	jmp    80107d <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  801053:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801057:	75 17                	jne    801070 <strtol+0xa0>
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	0f b6 00             	movzbl (%eax),%eax
  80105f:	3c 30                	cmp    $0x30,%al
  801061:	75 0d                	jne    801070 <strtol+0xa0>
		s++, base = 8;
  801063:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801067:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80106e:	eb 0d                	jmp    80107d <strtol+0xad>
	else if (base == 0)
  801070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801074:	75 07                	jne    80107d <strtol+0xad>
		base = 10;
  801076:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	0f b6 00             	movzbl (%eax),%eax
  801083:	3c 2f                	cmp    $0x2f,%al
  801085:	7e 1b                	jle    8010a2 <strtol+0xd2>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	0f b6 00             	movzbl (%eax),%eax
  80108d:	3c 39                	cmp    $0x39,%al
  80108f:	7f 11                	jg     8010a2 <strtol+0xd2>
			dig = *s - '0';
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	0f b6 00             	movzbl (%eax),%eax
  801097:	0f be c0             	movsbl %al,%eax
  80109a:	83 e8 30             	sub    $0x30,%eax
  80109d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a0:	eb 48                	jmp    8010ea <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	0f b6 00             	movzbl (%eax),%eax
  8010a8:	3c 60                	cmp    $0x60,%al
  8010aa:	7e 1b                	jle    8010c7 <strtol+0xf7>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	0f b6 00             	movzbl (%eax),%eax
  8010b2:	3c 7a                	cmp    $0x7a,%al
  8010b4:	7f 11                	jg     8010c7 <strtol+0xf7>
			dig = *s - 'a' + 10;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	0f b6 00             	movzbl (%eax),%eax
  8010bc:	0f be c0             	movsbl %al,%eax
  8010bf:	83 e8 57             	sub    $0x57,%eax
  8010c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c5:	eb 23                	jmp    8010ea <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	0f b6 00             	movzbl (%eax),%eax
  8010cd:	3c 40                	cmp    $0x40,%al
  8010cf:	7e 38                	jle    801109 <strtol+0x139>
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	0f b6 00             	movzbl (%eax),%eax
  8010d7:	3c 5a                	cmp    $0x5a,%al
  8010d9:	7f 2e                	jg     801109 <strtol+0x139>
			dig = *s - 'A' + 10;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	0f b6 00             	movzbl (%eax),%eax
  8010e1:	0f be c0             	movsbl %al,%eax
  8010e4:	83 e8 37             	sub    $0x37,%eax
  8010e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ed:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010f0:	7d 16                	jge    801108 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  8010f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010fd:	03 45 f4             	add    -0xc(%ebp),%eax
  801100:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801103:	e9 75 ff ff ff       	jmp    80107d <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801108:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801109:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80110d:	74 08                	je     801117 <strtol+0x147>
		*endptr = (char *) s;
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	8b 55 08             	mov    0x8(%ebp),%edx
  801115:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801117:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80111b:	74 07                	je     801124 <strtol+0x154>
  80111d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801120:	f7 d8                	neg    %eax
  801122:	eb 03                	jmp    801127 <strtol+0x157>
  801124:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    
  801129:	00 00                	add    %al,(%eax)
	...

0080112c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80113b:	8b 55 10             	mov    0x10(%ebp),%edx
  80113e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801141:	8b 5d 18             	mov    0x18(%ebp),%ebx
  801144:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  801147:	8b 75 20             	mov    0x20(%ebp),%esi
  80114a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80114d:	cd 30                	int    $0x30
  80114f:	89 c3                	mov    %eax,%ebx
  801151:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801154:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801158:	74 30                	je     80118a <syscall+0x5e>
  80115a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80115e:	7e 2a                	jle    80118a <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  801160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801163:	89 44 24 10          	mov    %eax,0x10(%esp)
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80116e:	c7 44 24 08 1c 2d 80 	movl   $0x802d1c,0x8(%esp)
  801175:	00 
  801176:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80117d:	00 
  80117e:	c7 04 24 39 2d 80 00 	movl   $0x802d39,(%esp)
  801185:	e8 da f0 ff ff       	call   800264 <_panic>

	return ret;
  80118a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80118d:	83 c4 4c             	add    $0x4c,%esp
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5f                   	pop    %edi
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    

00801195 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8011a5:	00 
  8011a6:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8011ad:	00 
  8011ae:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011b5:	00 
  8011b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011c8:	00 
  8011c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d0:	e8 57 ff ff ff       	call   80112c <syscall>
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8011dd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8011e4:	00 
  8011e5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8011ec:	00 
  8011ed:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011f4:	00 
  8011f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011fc:	00 
  8011fd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801204:	00 
  801205:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80120c:	00 
  80120d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801214:	e8 13 ff ff ff       	call   80112c <syscall>
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80122b:	00 
  80122c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801233:	00 
  801234:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80123b:	00 
  80123c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801243:	00 
  801244:	89 44 24 08          	mov    %eax,0x8(%esp)
  801248:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80124f:	00 
  801250:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  801257:	e8 d0 fe ff ff       	call   80112c <syscall>
}
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801264:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80126b:	00 
  80126c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801273:	00 
  801274:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80127b:	00 
  80127c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801283:	00 
  801284:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80128b:	00 
  80128c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801293:	00 
  801294:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80129b:	e8 8c fe ff ff       	call   80112c <syscall>
}
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <sys_yield>:

void
sys_yield(void)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8012a8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012af:	00 
  8012b0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012b7:	00 
  8012b8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012bf:	00 
  8012c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8012c7:	00 
  8012c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012cf:	00 
  8012d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8012d7:	00 
  8012d8:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8012df:	e8 48 fe ff ff       	call   80112c <syscall>
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8012ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012fc:	00 
  8012fd:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801304:	00 
  801305:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801309:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80130d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801311:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801318:	00 
  801319:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  801320:	e8 07 fe ff ff       	call   80112c <syscall>
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
  80132c:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80132f:	8b 75 18             	mov    0x18(%ebp),%esi
  801332:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801335:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	89 74 24 18          	mov    %esi,0x18(%esp)
  801342:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  801346:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80134a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80134e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801352:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801359:	00 
  80135a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  801361:	e8 c6 fd ff ff       	call   80112c <syscall>
}
  801366:	83 c4 20             	add    $0x20,%esp
  801369:	5b                   	pop    %ebx
  80136a:	5e                   	pop    %esi
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  801373:	8b 55 0c             	mov    0xc(%ebp),%edx
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801380:	00 
  801381:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801388:	00 
  801389:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801390:	00 
  801391:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801395:	89 44 24 08          	mov    %eax,0x8(%esp)
  801399:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013a0:	00 
  8013a1:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  8013a8:	e8 7f fd ff ff       	call   80112c <syscall>
}
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  8013b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013c2:	00 
  8013c3:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013ca:	00 
  8013cb:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013d2:	00 
  8013d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013e2:	00 
  8013e3:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  8013ea:	e8 3d fd ff ff       	call   80112c <syscall>
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8013f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801404:	00 
  801405:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80140c:	00 
  80140d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801414:	00 
  801415:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801419:	89 44 24 08          	mov    %eax,0x8(%esp)
  80141d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801424:	00 
  801425:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  80142c:	e8 fb fc ff ff       	call   80112c <syscall>
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  801439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801446:	00 
  801447:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80144e:	00 
  80144f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801456:	00 
  801457:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80145b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80145f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801466:	00 
  801467:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  80146e:	e8 b9 fc ff ff       	call   80112c <syscall>
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80147b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801488:	00 
  801489:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801490:	00 
  801491:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801498:	00 
  801499:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80149d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014a8:	00 
  8014a9:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  8014b0:	e8 77 fc ff ff       	call   80112c <syscall>
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8014bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014c0:	8b 55 10             	mov    0x10(%ebp),%edx
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8014cd:	00 
  8014ce:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8014d2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014e8:	00 
  8014e9:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  8014f0:	e8 37 fc ff ff       	call   80112c <syscall>
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801507:	00 
  801508:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80150f:	00 
  801510:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801517:	00 
  801518:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80151f:	00 
  801520:	89 44 24 08          	mov    %eax,0x8(%esp)
  801524:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80152b:	00 
  80152c:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  801533:	e8 f4 fb ff ff       	call   80112c <syscall>
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    
	...

0080153c <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	89 04 24             	mov    %eax,(%esp)
  801548:	e8 0a 00 00 00       	call   801557 <fd2num>
  80154d:	05 40 03 00 00       	add    $0x340,%eax
  801552:	c1 e0 16             	shl    $0x16,%eax
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	05 00 00 40 30       	add    $0x30400000,%eax
  801562:	c1 e8 0c             	shr    $0xc,%eax
}
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  80156d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801574:	eb 49                	jmp    8015bf <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  801576:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801579:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  80157e:	c1 e0 0c             	shl    $0xc,%eax
  801581:	89 c2                	mov    %eax,%edx
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8b 00                	mov    (%eax),%eax
  80158d:	c1 e8 16             	shr    $0x16,%eax
  801590:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801597:	83 e0 01             	and    $0x1,%eax
  80159a:	85 c0                	test   %eax,%eax
  80159c:	74 16                	je     8015b4 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8b 00                	mov    (%eax),%eax
  8015a3:	c1 e8 0c             	shr    $0xc,%eax
  8015a6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ad:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	75 07                	jne    8015bb <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b9:	eb 18                	jmp    8015d3 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  8015bb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8015bf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  8015c3:	7e b1                	jle    801576 <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  8015ce:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  8015db:	c7 44 24 08 48 2d 80 	movl   $0x802d48,0x8(%esp)
  8015e2:	00 
  8015e3:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8015ea:	00 
  8015eb:	c7 04 24 62 2d 80 00 	movl   $0x802d62,(%esp)
  8015f2:	e8 6d ec ff ff       	call   800264 <_panic>

008015f7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 04 24             	mov    %eax,(%esp)
  801603:	e8 4f ff ff ff       	call   801557 <fd2num>
  801608:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80160b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80160f:	89 04 24             	mov    %eax,(%esp)
  801612:	e8 be ff ff ff       	call   8015d5 <fd_lookup>
  801617:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80161a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80161e:	78 08                	js     801628 <fd_close+0x31>
	    || fd != fd2)
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	39 45 08             	cmp    %eax,0x8(%ebp)
  801626:	74 12                	je     80163a <fd_close+0x43>
		return (must_exist ? r : 0);
  801628:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162c:	74 05                	je     801633 <fd_close+0x3c>
  80162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801631:	eb 05                	jmp    801638 <fd_close+0x41>
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
  801638:	eb 44                	jmp    80167e <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8b 00                	mov    (%eax),%eax
  80163f:	8d 55 ec             	lea    -0x14(%ebp),%edx
  801642:	89 54 24 04          	mov    %edx,0x4(%esp)
  801646:	89 04 24             	mov    %eax,(%esp)
  801649:	e8 32 00 00 00       	call   801680 <dev_lookup>
  80164e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801655:	78 11                	js     801668 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  801657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165a:	8b 50 10             	mov    0x10(%eax),%edx
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	89 04 24             	mov    %eax,(%esp)
  801663:	ff d2                	call   *%edx
  801665:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801676:	e8 f2 fc ff ff       	call   80136d <sys_page_unmap>
	return r;
  80167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  801686:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80168d:	eb 2b                	jmp    8016ba <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  80168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801692:	8b 04 85 0c 50 80 00 	mov    0x80500c(,%eax,4),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80169e:	75 16                	jne    8016b6 <dev_lookup+0x36>
			*dev = devtab[i];
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	8b 14 85 0c 50 80 00 	mov    0x80500c(,%eax,4),%edx
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	89 10                	mov    %edx,(%eax)
			return 0;
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	eb 3f                	jmp    8016f5 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	8b 04 85 0c 50 80 00 	mov    0x80500c(,%eax,4),%eax
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	75 c7                	jne    80168f <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8016c8:	a1 44 50 80 00       	mov    0x805044,%eax
  8016cd:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016db:	c7 04 24 6c 2d 80 00 	movl   $0x802d6c,(%esp)
  8016e2:	e8 b1 ec ff ff       	call   800398 <cprintf>
	*dev = 0;
  8016e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <close>:

int
close(int fdnum)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801700:	89 44 24 04          	mov    %eax,0x4(%esp)
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	89 04 24             	mov    %eax,(%esp)
  80170a:	e8 c6 fe ff ff       	call   8015d5 <fd_lookup>
  80170f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801716:	79 05                	jns    80171d <close+0x26>
		return r;
  801718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171b:	eb 13                	jmp    801730 <close+0x39>
	else
		return fd_close(fd, 1);
  80171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801720:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801727:	00 
  801728:	89 04 24             	mov    %eax,(%esp)
  80172b:	e8 c7 fe ff ff       	call   8015f7 <fd_close>
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <close_all>:

void
close_all(void)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801738:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80173f:	eb 0f                	jmp    801750 <close_all+0x1e>
		close(i);
  801741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801744:	89 04 24             	mov    %eax,(%esp)
  801747:	e8 ab ff ff ff       	call   8016f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80174c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801750:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  801754:	7e eb                	jle    801741 <close_all+0xf>
		close(i);
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80175e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801761:	89 44 24 04          	mov    %eax,0x4(%esp)
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	89 04 24             	mov    %eax,(%esp)
  80176b:	e8 65 fe ff ff       	call   8015d5 <fd_lookup>
  801770:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801777:	79 08                	jns    801781 <dup+0x29>
		return r;
  801779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177c:	e9 54 01 00 00       	jmp    8018d5 <dup+0x17d>
	close(newfdnum);
  801781:	8b 45 0c             	mov    0xc(%ebp),%eax
  801784:	89 04 24             	mov    %eax,(%esp)
  801787:	e8 6b ff ff ff       	call   8016f7 <close>

	newfd = INDEX2FD(newfdnum);
  80178c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178f:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801794:	c1 e0 0c             	shl    $0xc,%eax
  801797:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  80179a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80179d:	89 04 24             	mov    %eax,(%esp)
  8017a0:	e8 97 fd ff ff       	call   80153c <fd2data>
  8017a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  8017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ab:	89 04 24             	mov    %eax,(%esp)
  8017ae:	e8 89 fd ff ff       	call   80153c <fd2data>
  8017b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8017b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017b9:	c1 e8 0c             	shr    $0xc,%eax
  8017bc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017c3:	89 c2                	mov    %eax,%edx
  8017c5:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017ce:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017e0:	00 
  8017e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017ec:	e8 36 fb ff ff       	call   801327 <sys_page_map>
  8017f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f8:	0f 88 8e 00 00 00    	js     80188c <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  8017fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801801:	c1 e8 16             	shr    $0x16,%eax
  801804:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80180b:	85 c0                	test   %eax,%eax
  80180d:	74 78                	je     801887 <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  80180f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801816:	eb 66                	jmp    80187e <dup+0x126>
			pte = vpt[VPN(ova + i)];
  801818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181b:	03 45 e8             	add    -0x18(%ebp),%eax
  80181e:	c1 e8 0c             	shr    $0xc,%eax
  801821:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801828:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  80182b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182e:	83 e0 01             	and    $0x1,%eax
  801831:	84 c0                	test   %al,%al
  801833:	74 42                	je     801877 <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801838:	89 c1                	mov    %eax,%ecx
  80183a:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801843:	89 c2                	mov    %eax,%edx
  801845:	03 55 e4             	add    -0x1c(%ebp),%edx
  801848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184b:	03 45 e8             	add    -0x18(%ebp),%eax
  80184e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801852:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801856:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80185d:	00 
  80185e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801862:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801869:	e8 b9 fa ff ff       	call   801327 <sys_page_map>
  80186e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801871:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801875:	78 18                	js     80188f <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801877:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80187e:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801885:	7e 91                	jle    801818 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  801887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188a:	eb 49                	jmp    8018d5 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  80188c:	90                   	nop
  80188d:	eb 01                	jmp    801890 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  80188f:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801893:	89 44 24 04          	mov    %eax,0x4(%esp)
  801897:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80189e:	e8 ca fa ff ff       	call   80136d <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8018a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8018aa:	eb 1d                	jmp    8018c9 <dup+0x171>
		sys_page_unmap(0, nva + i);
  8018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018af:	03 45 e4             	add    -0x1c(%ebp),%eax
  8018b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018bd:	e8 ab fa ff ff       	call   80136d <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8018c2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8018c9:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  8018d0:	7e da                	jle    8018ac <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  8018d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018dd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	89 04 24             	mov    %eax,(%esp)
  8018ea:	e8 e6 fc ff ff       	call   8015d5 <fd_lookup>
  8018ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018f6:	78 1d                	js     801915 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018fb:	8b 00                	mov    (%eax),%eax
  8018fd:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801900:	89 54 24 04          	mov    %edx,0x4(%esp)
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	e8 74 fd ff ff       	call   801680 <dev_lookup>
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80190f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801913:	79 05                	jns    80191a <read+0x43>
		return r;
  801915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801918:	eb 75                	jmp    80198f <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80191a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191d:	8b 40 08             	mov    0x8(%eax),%eax
  801920:	83 e0 03             	and    $0x3,%eax
  801923:	83 f8 01             	cmp    $0x1,%eax
  801926:	75 26                	jne    80194e <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801928:	a1 44 50 80 00       	mov    0x805044,%eax
  80192d:	8b 40 4c             	mov    0x4c(%eax),%eax
  801930:	8b 55 08             	mov    0x8(%ebp),%edx
  801933:	89 54 24 08          	mov    %edx,0x8(%esp)
  801937:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193b:	c7 04 24 8b 2d 80 00 	movl   $0x802d8b,(%esp)
  801942:	e8 51 ea ff ff       	call   800398 <cprintf>
		return -E_INVAL;
  801947:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80194c:	eb 41                	jmp    80198f <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  80194e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801951:	8b 48 08             	mov    0x8(%eax),%ecx
  801954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801957:	8b 50 04             	mov    0x4(%eax),%edx
  80195a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801961:	8b 55 10             	mov    0x10(%ebp),%edx
  801964:	89 54 24 08          	mov    %edx,0x8(%esp)
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	ff d1                	call   *%ecx
  801974:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  801977:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80197b:	78 0f                	js     80198c <read+0xb5>
		fd->fd_offset += r;
  80197d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801980:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801983:	8b 52 04             	mov    0x4(%edx),%edx
  801986:	03 55 f4             	add    -0xc(%ebp),%edx
  801989:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  80198c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80199e:	eb 3b                	jmp    8019db <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a3:	8b 55 10             	mov    0x10(%ebp),%edx
  8019a6:	29 c2                	sub    %eax,%edx
  8019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ab:	03 45 0c             	add    0xc(%ebp),%eax
  8019ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	89 04 24             	mov    %eax,(%esp)
  8019bc:	e8 16 ff ff ff       	call   8018d7 <read>
  8019c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  8019c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019c8:	79 05                	jns    8019cf <readn+0x3e>
			return m;
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	eb 1a                	jmp    8019e9 <readn+0x58>
		if (m == 0)
  8019cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019d3:	74 10                	je     8019e5 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d8:	01 45 f4             	add    %eax,-0xc(%ebp)
  8019db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019de:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e1:	72 bd                	jb     8019a0 <readn+0xf>
  8019e3:	eb 01                	jmp    8019e6 <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8019e5:	90                   	nop
	}
	return tot;
  8019e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	89 04 24             	mov    %eax,(%esp)
  8019fe:	e8 d2 fb ff ff       	call   8015d5 <fd_lookup>
  801a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0a:	78 1d                	js     801a29 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0f:	8b 00                	mov    (%eax),%eax
  801a11:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801a14:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a18:	89 04 24             	mov    %eax,(%esp)
  801a1b:	e8 60 fc ff ff       	call   801680 <dev_lookup>
  801a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a27:	79 05                	jns    801a2e <write+0x43>
		return r;
  801a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2c:	eb 74                	jmp    801aa2 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a31:	8b 40 08             	mov    0x8(%eax),%eax
  801a34:	83 e0 03             	and    $0x3,%eax
  801a37:	85 c0                	test   %eax,%eax
  801a39:	75 26                	jne    801a61 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801a3b:	a1 44 50 80 00       	mov    0x805044,%eax
  801a40:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a43:	8b 55 08             	mov    0x8(%ebp),%edx
  801a46:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4e:	c7 04 24 a7 2d 80 00 	movl   $0x802da7,(%esp)
  801a55:	e8 3e e9 ff ff       	call   800398 <cprintf>
		return -E_INVAL;
  801a5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5f:	eb 41                	jmp    801aa2 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a64:	8b 48 0c             	mov    0xc(%eax),%ecx
  801a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a6a:	8b 50 04             	mov    0x4(%eax),%edx
  801a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a70:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a74:	8b 55 10             	mov    0x10(%ebp),%edx
  801a77:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a82:	89 04 24             	mov    %eax,(%esp)
  801a85:	ff d1                	call   *%ecx
  801a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  801a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a8e:	7e 0f                	jle    801a9f <write+0xb4>
		fd->fd_offset += r;
  801a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a96:	8b 52 04             	mov    0x4(%edx),%edx
  801a99:	03 55 f4             	add    -0xc(%ebp),%edx
  801a9c:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aaa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	89 04 24             	mov    %eax,(%esp)
  801ab7:	e8 19 fb ff ff       	call   8015d5 <fd_lookup>
  801abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801abf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ac3:	79 05                	jns    801aca <seek+0x26>
		return r;
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	eb 0e                	jmp    801ad8 <seek+0x34>
	fd->fd_offset = offset;
  801aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	89 04 24             	mov    %eax,(%esp)
  801aed:	e8 e3 fa ff ff       	call   8015d5 <fd_lookup>
  801af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801af5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801af9:	78 1d                	js     801b18 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801afe:	8b 00                	mov    (%eax),%eax
  801b00:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b03:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b07:	89 04 24             	mov    %eax,(%esp)
  801b0a:	e8 71 fb ff ff       	call   801680 <dev_lookup>
  801b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b16:	79 05                	jns    801b1d <ftruncate+0x43>
		return r;
  801b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1b:	eb 48                	jmp    801b65 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b20:	8b 40 08             	mov    0x8(%eax),%eax
  801b23:	83 e0 03             	and    $0x3,%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	75 26                	jne    801b50 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801b2a:	a1 44 50 80 00       	mov    0x805044,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b2f:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b32:	8b 55 08             	mov    0x8(%ebp),%edx
  801b35:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3d:	c7 04 24 c4 2d 80 00 	movl   $0x802dc4,(%esp)
  801b44:	e8 4f e8 ff ff       	call   800398 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801b49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b4e:	eb 15                	jmp    801b65 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b53:	8b 48 1c             	mov    0x1c(%eax),%ecx
  801b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b60:	89 04 24             	mov    %eax,(%esp)
  801b63:	ff d1                	call   *%ecx
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	89 04 24             	mov    %eax,(%esp)
  801b7a:	e8 56 fa ff ff       	call   8015d5 <fd_lookup>
  801b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b86:	78 1d                	js     801ba5 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b8b:	8b 00                	mov    (%eax),%eax
  801b8d:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b90:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b94:	89 04 24             	mov    %eax,(%esp)
  801b97:	e8 e4 fa ff ff       	call   801680 <dev_lookup>
  801b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ba3:	79 05                	jns    801baa <fstat+0x43>
		return r;
  801ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba8:	eb 41                	jmp    801beb <fstat+0x84>
	stat->st_name[0] = 0;
  801baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bad:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  801bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801bba:	00 00 00 
	stat->st_isdir = 0;
  801bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  801bc7:	00 00 00 
	stat->st_dev = dev;
  801bca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd0:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  801bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd9:	8b 48 14             	mov    0x14(%eax),%ecx
  801bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801be6:	89 04 24             	mov    %eax,(%esp)
  801be9:	ff d1                	call   *%ecx
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bf3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bfa:	00 
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	89 04 24             	mov    %eax,(%esp)
  801c01:	e8 36 00 00 00       	call   801c3c <open>
  801c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c0d:	79 05                	jns    801c14 <stat+0x27>
		return fd;
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	eb 23                	jmp    801c37 <stat+0x4a>
	r = fstat(fd, stat);
  801c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1e:	89 04 24             	mov    %eax,(%esp)
  801c21:	e8 41 ff ff ff       	call   801b67 <fstat>
  801c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	e8 c3 fa ff ff       	call   8016f7 <close>
	return r;
  801c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    
  801c39:	00 00                	add    %al,(%eax)
	...

00801c3c <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801c42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c45:	89 04 24             	mov    %eax,(%esp)
  801c48:	e8 1a f9 ff ff       	call   801567 <fd_alloc>
  801c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c54:	79 05                	jns    801c5b <open+0x1f>
  801c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c59:	eb 73                	jmp    801cce <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  801c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	89 04 24             	mov    %eax,(%esp)
  801c6f:	e8 f4 06 00 00       	call   802368 <fsipc_open>
  801c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c7b:	79 05                	jns    801c82 <open+0x46>
  801c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c80:	eb 4c                	jmp    801cce <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c85:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c99:	00 
  801c9a:	89 04 24             	mov    %eax,(%esp)
  801c9d:	e8 25 03 00 00       	call   801fc7 <fmap>
  801ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ca5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ca9:	79 18                	jns    801cc3 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  801cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801cb5:	00 
  801cb6:	89 04 24             	mov    %eax,(%esp)
  801cb9:	e8 39 f9 ff ff       	call   8015f7 <fd_close>
  801cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc1:	eb 0b                	jmp    801cce <open+0x92>
	return fd2num(fd);
  801cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc6:	89 04 24             	mov    %eax,(%esp)
  801cc9:	e8 89 f8 ff ff       	call   801557 <fd2num>
	//panic("open() unimplemented!");
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801cdf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801ce6:	00 
  801ce7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cee:	00 
  801cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	89 04 24             	mov    %eax,(%esp)
  801cf9:	e8 72 03 00 00       	call   802070 <funmap>
  801cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d05:	79 05                	jns    801d0c <file_close+0x3c>
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	eb 21                	jmp    801d2d <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d12:	89 04 24             	mov    %eax,(%esp)
  801d15:	e8 83 07 00 00       	call   80249d <fsipc_close>
  801d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d21:	79 05                	jns    801d28 <file_close+0x58>
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	eb 05                	jmp    801d2d <file_close+0x5d>
	return 0;
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801d41:	8b 45 14             	mov    0x14(%ebp),%eax
  801d44:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d47:	76 07                	jbe    801d50 <file_read+0x21>
		return 0;
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4e:	eb 43                	jmp    801d93 <file_read+0x64>
	if (offset + n > size)
  801d50:	8b 45 14             	mov    0x14(%ebp),%eax
  801d53:	03 45 10             	add    0x10(%ebp),%eax
  801d56:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d59:	76 0f                	jbe    801d6a <file_read+0x3b>
		n = size - offset;
  801d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d61:	89 d1                	mov    %edx,%ecx
  801d63:	29 c1                	sub    %eax,%ecx
  801d65:	89 c8                	mov    %ecx,%eax
  801d67:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	89 04 24             	mov    %eax,(%esp)
  801d70:	e8 c7 f7 ff ff       	call   80153c <fd2data>
  801d75:	8b 55 14             	mov    0x14(%ebp),%edx
  801d78:	01 c2                	add    %eax,%edx
  801d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d88:	89 04 24             	mov    %eax,(%esp)
  801d8b:	e8 0c f1 ff ff       	call   800e9c <memmove>
	return n;
  801d90:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	89 04 24             	mov    %eax,(%esp)
  801da8:	e8 28 f8 ff ff       	call   8015d5 <fd_lookup>
  801dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db4:	79 05                	jns    801dbb <read_map+0x26>
		return r;
  801db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db9:	eb 74                	jmp    801e2f <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  801dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbe:	8b 10                	mov    (%eax),%edx
  801dc0:	a1 20 50 80 00       	mov    0x805020,%eax
  801dc5:	39 c2                	cmp    %eax,%edx
  801dc7:	74 07                	je     801dd0 <read_map+0x3b>
		return -E_INVAL;
  801dc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dce:	eb 5f                	jmp    801e2f <read_map+0x9a>
	va = fd2data(fd) + offset;
  801dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd3:	89 04 24             	mov    %eax,(%esp)
  801dd6:	e8 61 f7 ff ff       	call   80153c <fd2data>
  801ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dde:	01 d0                	add    %edx,%eax
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  801de3:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  801dea:	7e 07                	jle    801df3 <read_map+0x5e>
		return -E_NO_DISK;
  801dec:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801df1:	eb 3c                	jmp    801e2f <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df6:	c1 e8 16             	shr    $0x16,%eax
  801df9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e00:	83 e0 01             	and    $0x1,%eax
  801e03:	85 c0                	test   %eax,%eax
  801e05:	74 14                	je     801e1b <read_map+0x86>
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	c1 e8 0c             	shr    $0xc,%eax
  801e0d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e14:	83 e0 01             	and    $0x1,%eax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	75 07                	jne    801e22 <read_map+0x8d>
		return -E_NO_DISK;
  801e1b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801e20:	eb 0d                	jmp    801e2f <read_map+0x9a>
	*blk = (void*) va;
  801e22:	8b 45 10             	mov    0x10(%ebp),%eax
  801e25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e28:	89 10                	mov    %edx,(%eax)
	return 0;
  801e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  801e37:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3a:	03 45 10             	add    0x10(%ebp),%eax
  801e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  801e40:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  801e47:	76 07                	jbe    801e50 <file_write+0x1f>
		return -E_NO_DISK;
  801e49:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801e4e:	eb 57                	jmp    801ea7 <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801e59:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e5c:	73 20                	jae    801e7e <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	89 04 24             	mov    %eax,(%esp)
  801e6b:	e8 88 00 00 00       	call   801ef8 <file_trunc>
  801e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e77:	79 05                	jns    801e7e <file_write+0x4d>
			return r;
  801e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7c:	eb 29                	jmp    801ea7 <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	89 04 24             	mov    %eax,(%esp)
  801e84:	e8 b3 f6 ff ff       	call   80153c <fd2data>
  801e89:	8b 55 14             	mov    0x14(%ebp),%edx
  801e8c:	01 c2                	add    %eax,%edx
  801e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e91:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9c:	89 14 24             	mov    %edx,(%esp)
  801e9f:	e8 f8 ef ff ff       	call   800e9c <memmove>
	return n;
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	8d 50 10             	lea    0x10(%eax),%edx
  801eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ebc:	89 04 24             	mov    %eax,(%esp)
  801ebf:	e8 e6 ed ff ff       	call   800caa <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed0:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  801edf:	83 f8 01             	cmp    $0x1,%eax
  801ee2:	0f 94 c0             	sete   %al
  801ee5:	0f b6 d0             	movzbl %al,%edx
  801ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eeb:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  801efe:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  801f05:	7e 0a                	jle    801f11 <file_trunc+0x19>
		return -E_NO_DISK;
  801f07:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801f0c:	e9 b4 00 00 00       	jmp    801fc5 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8b 40 0c             	mov    0xc(%eax),%eax
  801f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f30:	89 04 24             	mov    %eax,(%esp)
  801f33:	e8 22 05 00 00       	call   80245a <fsipc_set_size>
  801f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f3f:	79 05                	jns    801f46 <file_trunc+0x4e>
		return r;
  801f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f44:	eb 7f                	jmp    801fc5 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801f4f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f52:	74 24                	je     801f78 <file_trunc+0x80>
  801f54:	c7 44 24 0c f0 2d 80 	movl   $0x802df0,0xc(%esp)
  801f5b:	00 
  801f5c:	c7 44 24 08 13 2e 80 	movl   $0x802e13,0x8(%esp)
  801f63:	00 
  801f64:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801f6b:	00 
  801f6c:	c7 04 24 28 2e 80 00 	movl   $0x802e28,(%esp)
  801f73:	e8 ec e2 ff ff       	call   800264 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f82:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	89 04 24             	mov    %eax,(%esp)
  801f8c:	e8 36 00 00 00       	call   801fc7 <fmap>
  801f91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f98:	79 05                	jns    801f9f <file_trunc+0xa7>
		return r;
  801f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9d:	eb 26                	jmp    801fc5 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  801f9f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fa6:	00 
  801fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801faa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	89 04 24             	mov    %eax,(%esp)
  801fbb:	e8 b0 00 00 00       	call   802070 <funmap>

	return 0;
  801fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	89 04 24             	mov    %eax,(%esp)
  801fd3:	e8 64 f5 ff ff       	call   80153c <fd2data>
  801fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  801fdb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe5:	03 45 ec             	add    -0x14(%ebp),%eax
  801fe8:	83 e8 01             	sub    $0x1,%eax
  801feb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff6:	f7 75 ec             	divl   -0x14(%ebp)
  801ff9:	89 d0                	mov    %edx,%eax
  801ffb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ffe:	89 d1                	mov    %edx,%ecx
  802000:	29 c1                	sub    %eax,%ecx
  802002:	89 c8                	mov    %ecx,%eax
  802004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802007:	eb 58                	jmp    802061 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802012:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	8b 40 0c             	mov    0xc(%eax),%eax
  80201b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80201f:	89 54 24 04          	mov    %edx,0x4(%esp)
  802023:	89 04 24             	mov    %eax,(%esp)
  802026:	e8 a4 03 00 00       	call   8023cf <fsipc_map>
  80202b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80202e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802032:	79 26                	jns    80205a <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80203e:	00 
  80203f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802042:	89 54 24 08          	mov    %edx,0x8(%esp)
  802046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	89 04 24             	mov    %eax,(%esp)
  802050:	e8 1b 00 00 00       	call   802070 <funmap>
			return r;
  802055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802058:	eb 14                	jmp    80206e <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80205a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802061:	8b 45 10             	mov    0x10(%ebp),%eax
  802064:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802067:	77 a0                	ja     802009 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	89 04 24             	mov    %eax,(%esp)
  80207c:	e8 bb f4 ff ff       	call   80153c <fd2data>
  802081:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  802084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802087:	c1 e8 16             	shr    $0x16,%eax
  80208a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802091:	83 e0 01             	and    $0x1,%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	75 0a                	jne    8020a2 <funmap+0x32>
		return 0;
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
  80209d:	e9 bf 00 00 00       	jmp    802161 <funmap+0xf1>

	ret = 0;
  8020a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8020a9:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8020b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b3:	03 45 e8             	add    -0x18(%ebp),%eax
  8020b6:	83 e8 01             	sub    $0x1,%eax
  8020b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c4:	f7 75 e8             	divl   -0x18(%ebp)
  8020c7:	89 d0                	mov    %edx,%eax
  8020c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020cc:	89 d1                	mov    %edx,%ecx
  8020ce:	29 c1                	sub    %eax,%ecx
  8020d0:	89 c8                	mov    %ecx,%eax
  8020d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d5:	eb 7b                	jmp    802152 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	c1 e8 0c             	shr    $0xc,%eax
  8020e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020e9:	83 e0 01             	and    $0x1,%eax
  8020ec:	84 c0                	test   %al,%al
  8020ee:	74 5b                	je     80214b <funmap+0xdb>
			if (dirty
  8020f0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8020f4:	74 3d                	je     802133 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	c1 e8 0c             	shr    $0xc,%eax
  802101:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802108:	83 e0 40             	and    $0x40,%eax
  80210b:	85 c0                	test   %eax,%eax
  80210d:	74 24                	je     802133 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  80210f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	8b 40 0c             	mov    0xc(%eax),%eax
  802118:	89 54 24 04          	mov    %edx,0x4(%esp)
  80211c:	89 04 24             	mov    %eax,(%esp)
  80211f:	e8 b3 03 00 00       	call   8024d7 <fsipc_dirty>
  802124:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802127:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80212b:	79 06                	jns    802133 <funmap+0xc3>
				ret = r;
  80212d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802130:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802139:	01 d0                	add    %edx,%eax
  80213b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802146:	e8 22 f2 ff ff       	call   80136d <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  80214b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802152:	8b 45 0c             	mov    0xc(%ebp),%eax
  802155:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802158:	0f 87 79 ff ff ff    	ja     8020d7 <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <remove>:

// Delete a file
int
remove(const char *path)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	89 04 24             	mov    %eax,(%esp)
  80216f:	e8 a6 03 00 00       	call   80251a <fsipc_remove>
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  80217c:	e8 f6 03 00 00       	call   802577 <fsipc_sync>
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    
	...

00802184 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 28             	sub    $0x28,%esp
	if (b->error > 0) {
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8b 40 0c             	mov    0xc(%eax),%eax
  802190:	85 c0                	test   %eax,%eax
  802192:	7e 5d                	jle    8021f1 <writebuf+0x6d>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8b 40 04             	mov    0x4(%eax),%eax
  80219a:	89 c2                	mov    %eax,%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	8d 48 10             	lea    0x10(%eax),%ecx
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021af:	89 04 24             	mov    %eax,(%esp)
  8021b2:	e8 34 f8 ff ff       	call   8019eb <write>
  8021b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (result > 0)
  8021ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021be:	7e 11                	jle    8021d1 <writebuf+0x4d>
			b->result += result;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	8b 40 08             	mov    0x8(%eax),%eax
  8021c6:	89 c2                	mov    %eax,%edx
  8021c8:	03 55 f4             	add    -0xc(%ebp),%edx
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	89 50 08             	mov    %edx,0x8(%eax)
		if (result != b->idx) // error, or wrote less than supplied
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8b 40 04             	mov    0x4(%eax),%eax
  8021d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021da:	74 15                	je     8021f1 <writebuf+0x6d>
			b->error = (result < 0 ? result : 0);
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e5:	89 c2                	mov    %eax,%edx
  8021e7:	0f 4e 55 f4          	cmovle -0xc(%ebp),%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	89 50 0c             	mov    %edx,0xc(%eax)
	}
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <putch>:

static void
putch(int ch, void *thunk)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 28             	sub    $0x28,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  8021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	b->buf[b->idx++] = ch;
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	8b 40 04             	mov    0x4(%eax),%eax
  802205:	8b 55 08             	mov    0x8(%ebp),%edx
  802208:	89 d1                	mov    %edx,%ecx
  80220a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220d:	88 4c 02 10          	mov    %cl,0x10(%edx,%eax,1)
  802211:	8d 50 01             	lea    0x1(%eax),%edx
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	89 50 04             	mov    %edx,0x4(%eax)
	if (b->idx == 256) {
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 40 04             	mov    0x4(%eax),%eax
  802220:	3d 00 01 00 00       	cmp    $0x100,%eax
  802225:	75 15                	jne    80223c <putch+0x49>
		writebuf(b);
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	89 04 24             	mov    %eax,(%esp)
  80222d:	e8 52 ff ff ff       	call   802184 <writebuf>
		b->idx = 0;
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	}
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802250:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802257:	00 00 00 
	b.result = 0;
  80225a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802261:	00 00 00 
	b.error = 1;
  802264:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80226b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80226e:	8b 45 10             	mov    0x10(%ebp),%eax
  802271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802275:	8b 45 0c             	mov    0xc(%ebp),%eax
  802278:	89 44 24 08          	mov    %eax,0x8(%esp)
  80227c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802282:	89 44 24 04          	mov    %eax,0x4(%esp)
  802286:	c7 04 24 f3 21 80 00 	movl   $0x8021f3,(%esp)
  80228d:	e8 da e2 ff ff       	call   80056c <vprintfmt>
	if (b.idx > 0)
  802292:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  802298:	85 c0                	test   %eax,%eax
  80229a:	7e 0e                	jle    8022aa <vfprintf+0x6c>
		writebuf(&b);
  80229c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8022a2:	89 04 24             	mov    %eax,(%esp)
  8022a5:	e8 da fe ff ff       	call   802184 <writebuf>

	return (b.result ? b.result : b.error);
  8022aa:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 08                	je     8022bc <vfprintf+0x7e>
  8022b4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8022ba:	eb 06                	jmp    8022c2 <vfprintf+0x84>
  8022bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8022ca:	8d 45 0c             	lea    0xc(%ebp),%eax
  8022cd:	83 c0 04             	add    $0x4,%eax
  8022d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vfprintf(fd, fmt, ap);
  8022d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	89 04 24             	mov    %eax,(%esp)
  8022e7:	e8 52 ff ff ff       	call   80223e <vfprintf>
  8022ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <printf>:

int
printf(const char *fmt, ...)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8022fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8022fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vfprintf(1, fmt, ap);
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802306:	89 54 24 08          	mov    %edx,0x8(%esp)
  80230a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802315:	e8 24 ff ff ff       	call   80223e <vfprintf>
  80231a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    
	...

00802324 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80232a:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80232f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802336:	00 
  802337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80233e:	8b 55 08             	mov    0x8(%ebp),%edx
  802341:	89 54 24 04          	mov    %edx,0x4(%esp)
  802345:	89 04 24             	mov    %eax,(%esp)
  802348:	e8 e3 02 00 00       	call   802630 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  80234d:	8b 45 14             	mov    0x14(%ebp),%eax
  802350:	89 44 24 08          	mov    %eax,0x8(%esp)
  802354:	8b 45 10             	mov    0x10(%ebp),%eax
  802357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235e:	89 04 24             	mov    %eax,(%esp)
  802361:	e8 3e 02 00 00       	call   8025a4 <ipc_recv>
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  80236e:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	89 04 24             	mov    %eax,(%esp)
  80237b:	e8 d4 e8 ff ff       	call   800c54 <strlen>
  802380:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802385:	7e 07                	jle    80238e <fsipc_open+0x26>
		return -E_BAD_PATH;
  802387:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80238c:	eb 3f                	jmp    8023cd <fsipc_open+0x65>
	strcpy(req->req_path, path);
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 55 08             	mov    0x8(%ebp),%edx
  802394:	89 54 24 04          	mov    %edx,0x4(%esp)
  802398:	89 04 24             	mov    %eax,(%esp)
  80239b:	e8 0a e9 ff ff       	call   800caa <strcpy>
	req->req_omode = omode;
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a6:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8023ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8023c8:	e8 57 ff ff ff       	call   802324 <fsipc>
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  8023d5:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e2:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ea:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  8023ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8023f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802402:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802409:	e8 16 ff ff ff       	call   802324 <fsipc>
  80240e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802415:	79 05                	jns    80241c <fsipc_map+0x4d>
		return r;
  802417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241a:	eb 3c                	jmp    802458 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  80241c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241f:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  802424:	83 f8 05             	cmp    $0x5,%eax
  802427:	74 2a                	je     802453 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  802429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242c:	8b 55 10             	mov    0x10(%ebp),%edx
  80242f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802437:	c7 44 24 08 34 2e 80 	movl   $0x802e34,0x8(%esp)
  80243e:	00 
  80243f:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  802446:	00 
  802447:	c7 04 24 6a 2e 80 00 	movl   $0x802e6a,(%esp)
  80244e:	e8 11 de ff ff       	call   800264 <_panic>
	return 0;
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802460:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 55 08             	mov    0x8(%ebp),%edx
  80246d:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 55 0c             	mov    0xc(%ebp),%edx
  802475:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802478:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80247f:	00 
  802480:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802487:	00 
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  802496:	e8 89 fe ff ff       	call   802324 <fsipc>
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  8024a3:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b0:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  8024b2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024b9:	00 
  8024ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024c1:	00 
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8024d0:	e8 4f fe ff ff       	call   802324 <fsipc>
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  8024dd:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ea:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f2:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8024f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024fc:	00 
  8024fd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802504:	00 
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80250c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  802513:	e8 0c fe ff ff       	call   802324 <fsipc>
}
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802520:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	89 04 24             	mov    %eax,(%esp)
  80252d:	e8 22 e7 ff ff       	call   800c54 <strlen>
  802532:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802537:	7e 07                	jle    802540 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802539:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80253e:	eb 35                	jmp    802575 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 55 08             	mov    0x8(%ebp),%edx
  802546:	89 54 24 04          	mov    %edx,0x4(%esp)
  80254a:	89 04 24             	mov    %eax,(%esp)
  80254d:	e8 58 e7 ff ff       	call   800caa <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  802552:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802559:	00 
  80255a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802561:	00 
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	89 44 24 04          	mov    %eax,0x4(%esp)
  802569:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  802570:	e8 af fd ff ff       	call   802324 <fsipc>
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
  80257a:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  80257d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802584:	00 
  802585:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80258c:	00 
  80258d:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  802594:	00 
  802595:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80259c:	e8 83 fd ff ff       	call   802324 <fsipc>
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    
	...

008025a4 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
  8025a7:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  8025aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025ae:	75 11                	jne    8025c1 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  8025b0:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  8025b7:	e8 3b ef ff ff       	call   8014f7 <sys_ipc_recv>
  8025bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bf:	eb 0e                	jmp    8025cf <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  8025c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c4:	89 04 24             	mov    %eax,(%esp)
  8025c7:	e8 2b ef ff ff       	call   8014f7 <sys_ipc_recv>
  8025cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  8025cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d3:	79 1c                	jns    8025f1 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  8025d5:	c7 44 24 08 76 2e 80 	movl   $0x802e76,0x8(%esp)
  8025dc:	00 
  8025dd:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8025e4:	00 
  8025e5:	c7 04 24 8c 2e 80 00 	movl   $0x802e8c,(%esp)
  8025ec:	e8 73 dc ff ff       	call   800264 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  8025f1:	e8 68 ec ff ff       	call   80125e <sys_getenvid>
  8025f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8025fb:	c1 e0 07             	shl    $0x7,%eax
  8025fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802603:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  802606:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80260a:	74 0b                	je     802617 <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  80260c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260f:	8b 50 74             	mov    0x74(%eax),%edx
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  802617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80261b:	74 0b                	je     802628 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  80261d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802620:	8b 50 78             	mov    0x78(%eax),%edx
  802623:	8b 45 10             	mov    0x10(%ebp),%eax
  802626:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  802628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262b:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  802636:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80263a:	75 26                	jne    802662 <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  80263c:	8b 45 14             	mov    0x14(%ebp),%eax
  80263f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802643:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  80264a:	ee 
  80264b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80264e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	89 04 24             	mov    %eax,(%esp)
  802658:	e8 5a ee ff ff       	call   8014b7 <sys_ipc_try_send>
  80265d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802660:	eb 23                	jmp    802685 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  802662:	8b 45 14             	mov    0x14(%ebp),%eax
  802665:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802669:	8b 45 10             	mov    0x10(%ebp),%eax
  80266c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802670:	8b 45 0c             	mov    0xc(%ebp),%eax
  802673:	89 44 24 04          	mov    %eax,0x4(%esp)
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	89 04 24             	mov    %eax,(%esp)
  80267d:	e8 35 ee ff ff       	call   8014b7 <sys_ipc_try_send>
  802682:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	79 29                	jns    8026b4 <ipc_send+0x84>
  80268b:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  80268f:	74 23                	je     8026b4 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802698:	c7 44 24 08 96 2e 80 	movl   $0x802e96,0x8(%esp)
  80269f:	00 
  8026a0:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8026a7:	00 
  8026a8:	c7 04 24 8c 2e 80 00 	movl   $0x802e8c,(%esp)
  8026af:	e8 b0 db ff ff       	call   800264 <_panic>
	    sys_yield();
  8026b4:	e8 e9 eb ff ff       	call   8012a2 <sys_yield>
	}while(r < 0);
  8026b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bd:	0f 88 73 ff ff ff    	js     802636 <ipc_send+0x6>
}
  8026c3:	c9                   	leave  
  8026c4:	c3                   	ret    
	...

008026d0 <__udivdi3>:
  8026d0:	83 ec 1c             	sub    $0x1c,%esp
  8026d3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8026d7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8026db:	8b 44 24 20          	mov    0x20(%esp),%eax
  8026df:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8026e3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8026e7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8026eb:	85 ff                	test   %edi,%edi
  8026ed:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8026f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026f5:	89 cd                	mov    %ecx,%ebp
  8026f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fb:	75 33                	jne    802730 <__udivdi3+0x60>
  8026fd:	39 f1                	cmp    %esi,%ecx
  8026ff:	77 57                	ja     802758 <__udivdi3+0x88>
  802701:	85 c9                	test   %ecx,%ecx
  802703:	75 0b                	jne    802710 <__udivdi3+0x40>
  802705:	b8 01 00 00 00       	mov    $0x1,%eax
  80270a:	31 d2                	xor    %edx,%edx
  80270c:	f7 f1                	div    %ecx
  80270e:	89 c1                	mov    %eax,%ecx
  802710:	89 f0                	mov    %esi,%eax
  802712:	31 d2                	xor    %edx,%edx
  802714:	f7 f1                	div    %ecx
  802716:	89 c6                	mov    %eax,%esi
  802718:	8b 44 24 04          	mov    0x4(%esp),%eax
  80271c:	f7 f1                	div    %ecx
  80271e:	89 f2                	mov    %esi,%edx
  802720:	8b 74 24 10          	mov    0x10(%esp),%esi
  802724:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802728:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80272c:	83 c4 1c             	add    $0x1c,%esp
  80272f:	c3                   	ret    
  802730:	31 d2                	xor    %edx,%edx
  802732:	31 c0                	xor    %eax,%eax
  802734:	39 f7                	cmp    %esi,%edi
  802736:	77 e8                	ja     802720 <__udivdi3+0x50>
  802738:	0f bd cf             	bsr    %edi,%ecx
  80273b:	83 f1 1f             	xor    $0x1f,%ecx
  80273e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802742:	75 2c                	jne    802770 <__udivdi3+0xa0>
  802744:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802748:	76 04                	jbe    80274e <__udivdi3+0x7e>
  80274a:	39 f7                	cmp    %esi,%edi
  80274c:	73 d2                	jae    802720 <__udivdi3+0x50>
  80274e:	31 d2                	xor    %edx,%edx
  802750:	b8 01 00 00 00       	mov    $0x1,%eax
  802755:	eb c9                	jmp    802720 <__udivdi3+0x50>
  802757:	90                   	nop
  802758:	89 f2                	mov    %esi,%edx
  80275a:	f7 f1                	div    %ecx
  80275c:	31 d2                	xor    %edx,%edx
  80275e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802762:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802766:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80276a:	83 c4 1c             	add    $0x1c,%esp
  80276d:	c3                   	ret    
  80276e:	66 90                	xchg   %ax,%ax
  802770:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802775:	b8 20 00 00 00       	mov    $0x20,%eax
  80277a:	89 ea                	mov    %ebp,%edx
  80277c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802780:	d3 e7                	shl    %cl,%edi
  802782:	89 c1                	mov    %eax,%ecx
  802784:	d3 ea                	shr    %cl,%edx
  802786:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80278b:	09 fa                	or     %edi,%edx
  80278d:	89 f7                	mov    %esi,%edi
  80278f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802793:	89 f2                	mov    %esi,%edx
  802795:	8b 74 24 08          	mov    0x8(%esp),%esi
  802799:	d3 e5                	shl    %cl,%ebp
  80279b:	89 c1                	mov    %eax,%ecx
  80279d:	d3 ef                	shr    %cl,%edi
  80279f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027a4:	d3 e2                	shl    %cl,%edx
  8027a6:	89 c1                	mov    %eax,%ecx
  8027a8:	d3 ee                	shr    %cl,%esi
  8027aa:	09 d6                	or     %edx,%esi
  8027ac:	89 fa                	mov    %edi,%edx
  8027ae:	89 f0                	mov    %esi,%eax
  8027b0:	f7 74 24 0c          	divl   0xc(%esp)
  8027b4:	89 d7                	mov    %edx,%edi
  8027b6:	89 c6                	mov    %eax,%esi
  8027b8:	f7 e5                	mul    %ebp
  8027ba:	39 d7                	cmp    %edx,%edi
  8027bc:	72 22                	jb     8027e0 <__udivdi3+0x110>
  8027be:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8027c2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027c7:	d3 e5                	shl    %cl,%ebp
  8027c9:	39 c5                	cmp    %eax,%ebp
  8027cb:	73 04                	jae    8027d1 <__udivdi3+0x101>
  8027cd:	39 d7                	cmp    %edx,%edi
  8027cf:	74 0f                	je     8027e0 <__udivdi3+0x110>
  8027d1:	89 f0                	mov    %esi,%eax
  8027d3:	31 d2                	xor    %edx,%edx
  8027d5:	e9 46 ff ff ff       	jmp    802720 <__udivdi3+0x50>
  8027da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027e0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8027e3:	31 d2                	xor    %edx,%edx
  8027e5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027e9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027ed:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027f1:	83 c4 1c             	add    $0x1c,%esp
  8027f4:	c3                   	ret    
	...

00802800 <__umoddi3>:
  802800:	83 ec 1c             	sub    $0x1c,%esp
  802803:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802807:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80280b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80280f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802813:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802817:	8b 74 24 24          	mov    0x24(%esp),%esi
  80281b:	85 ed                	test   %ebp,%ebp
  80281d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802821:	89 44 24 08          	mov    %eax,0x8(%esp)
  802825:	89 cf                	mov    %ecx,%edi
  802827:	89 04 24             	mov    %eax,(%esp)
  80282a:	89 f2                	mov    %esi,%edx
  80282c:	75 1a                	jne    802848 <__umoddi3+0x48>
  80282e:	39 f1                	cmp    %esi,%ecx
  802830:	76 4e                	jbe    802880 <__umoddi3+0x80>
  802832:	f7 f1                	div    %ecx
  802834:	89 d0                	mov    %edx,%eax
  802836:	31 d2                	xor    %edx,%edx
  802838:	8b 74 24 10          	mov    0x10(%esp),%esi
  80283c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802840:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802844:	83 c4 1c             	add    $0x1c,%esp
  802847:	c3                   	ret    
  802848:	39 f5                	cmp    %esi,%ebp
  80284a:	77 54                	ja     8028a0 <__umoddi3+0xa0>
  80284c:	0f bd c5             	bsr    %ebp,%eax
  80284f:	83 f0 1f             	xor    $0x1f,%eax
  802852:	89 44 24 04          	mov    %eax,0x4(%esp)
  802856:	75 60                	jne    8028b8 <__umoddi3+0xb8>
  802858:	3b 0c 24             	cmp    (%esp),%ecx
  80285b:	0f 87 07 01 00 00    	ja     802968 <__umoddi3+0x168>
  802861:	89 f2                	mov    %esi,%edx
  802863:	8b 34 24             	mov    (%esp),%esi
  802866:	29 ce                	sub    %ecx,%esi
  802868:	19 ea                	sbb    %ebp,%edx
  80286a:	89 34 24             	mov    %esi,(%esp)
  80286d:	8b 04 24             	mov    (%esp),%eax
  802870:	8b 74 24 10          	mov    0x10(%esp),%esi
  802874:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802878:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80287c:	83 c4 1c             	add    $0x1c,%esp
  80287f:	c3                   	ret    
  802880:	85 c9                	test   %ecx,%ecx
  802882:	75 0b                	jne    80288f <__umoddi3+0x8f>
  802884:	b8 01 00 00 00       	mov    $0x1,%eax
  802889:	31 d2                	xor    %edx,%edx
  80288b:	f7 f1                	div    %ecx
  80288d:	89 c1                	mov    %eax,%ecx
  80288f:	89 f0                	mov    %esi,%eax
  802891:	31 d2                	xor    %edx,%edx
  802893:	f7 f1                	div    %ecx
  802895:	8b 04 24             	mov    (%esp),%eax
  802898:	f7 f1                	div    %ecx
  80289a:	eb 98                	jmp    802834 <__umoddi3+0x34>
  80289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028a0:	89 f2                	mov    %esi,%edx
  8028a2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8028a6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8028aa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8028ae:	83 c4 1c             	add    $0x1c,%esp
  8028b1:	c3                   	ret    
  8028b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028b8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028bd:	89 e8                	mov    %ebp,%eax
  8028bf:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028c4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8028c8:	89 fa                	mov    %edi,%edx
  8028ca:	d3 e0                	shl    %cl,%eax
  8028cc:	89 e9                	mov    %ebp,%ecx
  8028ce:	d3 ea                	shr    %cl,%edx
  8028d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028d5:	09 c2                	or     %eax,%edx
  8028d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028db:	89 14 24             	mov    %edx,(%esp)
  8028de:	89 f2                	mov    %esi,%edx
  8028e0:	d3 e7                	shl    %cl,%edi
  8028e2:	89 e9                	mov    %ebp,%ecx
  8028e4:	d3 ea                	shr    %cl,%edx
  8028e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028ef:	d3 e6                	shl    %cl,%esi
  8028f1:	89 e9                	mov    %ebp,%ecx
  8028f3:	d3 e8                	shr    %cl,%eax
  8028f5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028fa:	09 f0                	or     %esi,%eax
  8028fc:	8b 74 24 08          	mov    0x8(%esp),%esi
  802900:	f7 34 24             	divl   (%esp)
  802903:	d3 e6                	shl    %cl,%esi
  802905:	89 74 24 08          	mov    %esi,0x8(%esp)
  802909:	89 d6                	mov    %edx,%esi
  80290b:	f7 e7                	mul    %edi
  80290d:	39 d6                	cmp    %edx,%esi
  80290f:	89 c1                	mov    %eax,%ecx
  802911:	89 d7                	mov    %edx,%edi
  802913:	72 3f                	jb     802954 <__umoddi3+0x154>
  802915:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802919:	72 35                	jb     802950 <__umoddi3+0x150>
  80291b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80291f:	29 c8                	sub    %ecx,%eax
  802921:	19 fe                	sbb    %edi,%esi
  802923:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802928:	89 f2                	mov    %esi,%edx
  80292a:	d3 e8                	shr    %cl,%eax
  80292c:	89 e9                	mov    %ebp,%ecx
  80292e:	d3 e2                	shl    %cl,%edx
  802930:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802935:	09 d0                	or     %edx,%eax
  802937:	89 f2                	mov    %esi,%edx
  802939:	d3 ea                	shr    %cl,%edx
  80293b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80293f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802943:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802947:	83 c4 1c             	add    $0x1c,%esp
  80294a:	c3                   	ret    
  80294b:	90                   	nop
  80294c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802950:	39 d6                	cmp    %edx,%esi
  802952:	75 c7                	jne    80291b <__umoddi3+0x11b>
  802954:	89 d7                	mov    %edx,%edi
  802956:	89 c1                	mov    %eax,%ecx
  802958:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80295c:	1b 3c 24             	sbb    (%esp),%edi
  80295f:	eb ba                	jmp    80291b <__umoddi3+0x11b>
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	39 f5                	cmp    %esi,%ebp
  80296a:	0f 82 f1 fe ff ff    	jb     802861 <__umoddi3+0x61>
  802970:	e9 f8 fe ff ff       	jmp    80286d <__umoddi3+0x6d>
