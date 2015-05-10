
obj/user/cat:     file format elf32-i386


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
  80002c:	e8 77 01 00 00       	call   8001a8 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 38             	sub    $0x38,%esp
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003a:	eb 50                	jmp    80008c <cat+0x58>
		if ((r = write(1, buf, n)) != n)
  80003c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80003f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800043:	c7 44 24 04 40 50 80 	movl   $0x805040,0x4(%esp)
  80004a:	00 
  80004b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800052:	e8 3c 19 00 00       	call   801993 <write>
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80005a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80005d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800060:	74 2a                	je     80008c <cat+0x58>
			panic("write error copying %s: %e", s, r);
  800062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800065:	89 44 24 10          	mov    %eax,0x10(%esp)
  800069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80006c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800070:	c7 44 24 08 80 27 80 	movl   $0x802780,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80007f:	00 
  800080:	c7 04 24 9b 27 80 00 	movl   $0x80279b,(%esp)
  800087:	e8 80 01 00 00       	call   80020c <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80008c:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 40 50 80 	movl   $0x805040,0x4(%esp)
  80009b:	00 
  80009c:	8b 45 08             	mov    0x8(%ebp),%eax
  80009f:	89 04 24             	mov    %eax,(%esp)
  8000a2:	e8 d8 17 00 00       	call   80187f <read>
  8000a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8000ae:	7f 8c                	jg     80003c <cat+0x8>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8000b4:	79 2a                	jns    8000e0 <cat+0xac>
		panic("error reading %s: %e", s, n);
  8000b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c4:	c7 44 24 08 a6 27 80 	movl   $0x8027a6,0x8(%esp)
  8000cb:	00 
  8000cc:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000d3:	00 
  8000d4:	c7 04 24 9b 27 80 00 	movl   $0x80279b,(%esp)
  8000db:	e8 2c 01 00 00       	call   80020c <_panic>
}
  8000e0:	c9                   	leave  
  8000e1:	c3                   	ret    

008000e2 <umain>:

void
umain(int argc, char **argv)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	83 ec 38             	sub    $0x38,%esp
	int f, i;

	argv0 = "cat";
  8000e8:	c7 05 44 70 80 00 bb 	movl   $0x8027bb,0x807044
  8000ef:	27 80 00 
	if (argc == 1)
  8000f2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000f6:	75 19                	jne    800111 <umain+0x2f>
		cat(0, "<stdin>");
  8000f8:	c7 44 24 04 bf 27 80 	movl   $0x8027bf,0x4(%esp)
  8000ff:	00 
  800100:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800107:	e8 28 ff ff ff       	call   800034 <cat>
  80010c:	e9 94 00 00 00       	jmp    8001a5 <umain+0xc3>
	else
		for (i = 1; i < argc; i++) {
  800111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  800118:	eb 7f                	jmp    800199 <umain+0xb7>
			f = open(argv[i], O_RDONLY);
  80011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80011d:	c1 e0 02             	shl    $0x2,%eax
  800120:	03 45 0c             	add    0xc(%ebp),%eax
  800123:	8b 00                	mov    (%eax),%eax
  800125:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80012c:	00 
  80012d:	89 04 24             	mov    %eax,(%esp)
  800130:	e8 af 1a 00 00       	call   801be4 <open>
  800135:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (f < 0)
  800138:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80013c:	79 32                	jns    800170 <umain+0x8e>
				panic("can't open %s: %e", argv[i], f);
  80013e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800141:	c1 e0 02             	shl    $0x2,%eax
  800144:	03 45 0c             	add    0xc(%ebp),%eax
  800147:	8b 00                	mov    (%eax),%eax
  800149:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80014c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800150:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800154:	c7 44 24 08 c7 27 80 	movl   $0x8027c7,0x8(%esp)
  80015b:	00 
  80015c:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  800163:	00 
  800164:	c7 04 24 9b 27 80 00 	movl   $0x80279b,(%esp)
  80016b:	e8 9c 00 00 00       	call   80020c <_panic>
			else {
				cat(f, argv[i]);
  800170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800173:	c1 e0 02             	shl    $0x2,%eax
  800176:	03 45 0c             	add    0xc(%ebp),%eax
  800179:	8b 00                	mov    (%eax),%eax
  80017b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800182:	89 04 24             	mov    %eax,(%esp)
  800185:	e8 aa fe ff ff       	call   800034 <cat>
				close(f);
  80018a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80018d:	89 04 24             	mov    %eax,(%esp)
  800190:	e8 0a 15 00 00       	call   80169f <close>

	argv0 = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800195:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80019c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80019f:	0f 8c 75 ff ff ff    	jl     80011a <umain+0x38>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    
	...

008001a8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  8001ae:	e8 53 10 00 00       	call   801206 <sys_getenvid>
  8001b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b8:	c1 e0 07             	shl    $0x7,%eax
  8001bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c0:	a3 40 70 80 00       	mov    %eax,0x807040
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c9:	7e 0a                	jle    8001d5 <libmain+0x2d>
		binaryname = argv[0];
  8001cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ce:	8b 00                	mov    (%eax),%eax
  8001d0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	umain(argc, argv);
  8001d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001df:	89 04 24             	mov    %eax,(%esp)
  8001e2:	e8 fb fe ff ff       	call   8000e2 <umain>

	// exit gracefully
	exit();
  8001e7:	e8 04 00 00 00       	call   8001f0 <exit>
}
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    
	...

008001f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001f6:	e8 df 14 00 00       	call   8016da <close_all>
	sys_env_destroy(0);
  8001fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800202:	e8 bc 0f 00 00       	call   8011c3 <sys_env_destroy>
}
  800207:	c9                   	leave  
  800208:	c3                   	ret    
  800209:	00 00                	add    %al,(%eax)
	...

0080020c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800212:	8d 45 10             	lea    0x10(%ebp),%eax
  800215:	83 c0 04             	add    $0x4,%eax
  800218:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  80021b:	a1 44 70 80 00       	mov    0x807044,%eax
  800220:	85 c0                	test   %eax,%eax
  800222:	74 15                	je     800239 <_panic+0x2d>
		cprintf("%s: ", argv0);
  800224:	a1 44 70 80 00       	mov    0x807044,%eax
  800229:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022d:	c7 04 24 f0 27 80 00 	movl   $0x8027f0,(%esp)
  800234:	e8 07 01 00 00       	call   800340 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800239:	a1 00 50 80 00       	mov    0x805000,%eax
  80023e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800241:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800245:	8b 55 08             	mov    0x8(%ebp),%edx
  800248:	89 54 24 08          	mov    %edx,0x8(%esp)
  80024c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800250:	c7 04 24 f5 27 80 00 	movl   $0x8027f5,(%esp)
  800257:	e8 e4 00 00 00       	call   800340 <cprintf>
	vcprintf(fmt, ap);
  80025c:	8b 45 10             	mov    0x10(%ebp),%eax
  80025f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800262:	89 54 24 04          	mov    %edx,0x4(%esp)
  800266:	89 04 24             	mov    %eax,(%esp)
  800269:	e8 6e 00 00 00       	call   8002dc <vcprintf>
	cprintf("\n");
  80026e:	c7 04 24 11 28 80 00 	movl   $0x802811,(%esp)
  800275:	e8 c6 00 00 00       	call   800340 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027a:	cc                   	int3   
  80027b:	eb fd                	jmp    80027a <_panic+0x6e>
  80027d:	00 00                	add    %al,(%eax)
	...

00800280 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  800286:	8b 45 0c             	mov    0xc(%ebp),%eax
  800289:	8b 00                	mov    (%eax),%eax
  80028b:	8b 55 08             	mov    0x8(%ebp),%edx
  80028e:	89 d1                	mov    %edx,%ecx
  800290:	8b 55 0c             	mov    0xc(%ebp),%edx
  800293:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  800297:	8d 50 01             	lea    0x1(%eax),%edx
  80029a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029d:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  80029f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a2:	8b 00                	mov    (%eax),%eax
  8002a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a9:	75 20                	jne    8002cb <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  8002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b3:	83 c2 08             	add    $0x8,%edx
  8002b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ba:	89 14 24             	mov    %edx,(%esp)
  8002bd:	e8 7b 0e 00 00       	call   80113d <sys_cputs>
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	c9                   	leave  
  8002db:	c3                   	ret    

008002dc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ec:	00 00 00 
	b.cnt = 0;
  8002ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800300:	8b 45 08             	mov    0x8(%ebp),%eax
  800303:	89 44 24 08          	mov    %eax,0x8(%esp)
  800307:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800311:	c7 04 24 80 02 80 00 	movl   $0x800280,(%esp)
  800318:	e8 f7 01 00 00       	call   800514 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80031d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800323:	89 44 24 04          	mov    %eax,0x4(%esp)
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	83 c0 08             	add    $0x8,%eax
  800330:	89 04 24             	mov    %eax,(%esp)
  800333:	e8 05 0e 00 00       	call   80113d <sys_cputs>

	return b.cnt;
  800338:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80033e:	c9                   	leave  
  80033f:	c3                   	ret    

00800340 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800346:	8d 45 0c             	lea    0xc(%ebp),%eax
  800349:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800352:	89 54 24 04          	mov    %edx,0x4(%esp)
  800356:	89 04 24             	mov    %eax,(%esp)
  800359:	e8 7e ff ff ff       	call   8002dc <vcprintf>
  80035e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800364:	c9                   	leave  
  800365:	c3                   	ret    
	...

00800368 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	53                   	push   %ebx
  80036c:	83 ec 34             	sub    $0x34,%esp
  80036f:	8b 45 10             	mov    0x10(%ebp),%eax
  800372:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800375:	8b 45 14             	mov    0x14(%ebp),%eax
  800378:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80037b:	8b 45 18             	mov    0x18(%ebp),%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
  800383:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800386:	77 72                	ja     8003fa <printnum+0x92>
  800388:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80038b:	72 05                	jb     800392 <printnum+0x2a>
  80038d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800390:	77 68                	ja     8003fa <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800392:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800395:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800398:	8b 45 18             	mov    0x18(%ebp),%eax
  80039b:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ae:	89 04 24             	mov    %eax,(%esp)
  8003b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003b5:	e8 16 21 00 00       	call   8024d0 <__udivdi3>
  8003ba:	8b 4d 20             	mov    0x20(%ebp),%ecx
  8003bd:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  8003c1:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8003c5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003db:	8b 45 08             	mov    0x8(%ebp),%eax
  8003de:	89 04 24             	mov    %eax,(%esp)
  8003e1:	e8 82 ff ff ff       	call   800368 <printnum>
  8003e6:	eb 1c                	jmp    800404 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ef:	8b 45 20             	mov    0x20(%ebp),%eax
  8003f2:	89 04 24             	mov    %eax,(%esp)
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003fa:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8003fe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800402:	7f e4                	jg     8003e8 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800404:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800407:	bb 00 00 00 00       	mov    $0x0,%ebx
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800412:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800416:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80041a:	89 04 24             	mov    %eax,(%esp)
  80041d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800421:	e8 da 21 00 00       	call   802600 <__umoddi3>
  800426:	05 7c 29 80 00       	add    $0x80297c,%eax
  80042b:	0f b6 00             	movzbl (%eax),%eax
  80042e:	0f be c0             	movsbl %al,%eax
  800431:	8b 55 0c             	mov    0xc(%ebp),%edx
  800434:	89 54 24 04          	mov    %edx,0x4(%esp)
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	ff d0                	call   *%eax
}
  800440:	83 c4 34             	add    $0x34,%esp
  800443:	5b                   	pop    %ebx
  800444:	5d                   	pop    %ebp
  800445:	c3                   	ret    

00800446 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800449:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80044d:	7e 1c                	jle    80046b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	8d 50 08             	lea    0x8(%eax),%edx
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	89 10                	mov    %edx,(%eax)
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	83 e8 08             	sub    $0x8,%eax
  800464:	8b 50 04             	mov    0x4(%eax),%edx
  800467:	8b 00                	mov    (%eax),%eax
  800469:	eb 40                	jmp    8004ab <getuint+0x65>
	else if (lflag)
  80046b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80046f:	74 1e                	je     80048f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	8d 50 04             	lea    0x4(%eax),%edx
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	89 10                	mov    %edx,(%eax)
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	83 e8 04             	sub    $0x4,%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	ba 00 00 00 00       	mov    $0x0,%edx
  80048d:	eb 1c                	jmp    8004ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	8d 50 04             	lea    0x4(%eax),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	89 10                	mov    %edx,(%eax)
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	83 e8 04             	sub    $0x4,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ab:	5d                   	pop    %ebp
  8004ac:	c3                   	ret    

008004ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b4:	7e 1c                	jle    8004d2 <getint+0x25>
		return va_arg(*ap, long long);
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	8d 50 08             	lea    0x8(%eax),%edx
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 10                	mov    %edx,(%eax)
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	83 e8 08             	sub    $0x8,%eax
  8004cb:	8b 50 04             	mov    0x4(%eax),%edx
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	eb 40                	jmp    800512 <getint+0x65>
	else if (lflag)
  8004d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d6:	74 1e                	je     8004f6 <getint+0x49>
		return va_arg(*ap, long);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	89 c2                	mov    %eax,%edx
  8004f1:	c1 fa 1f             	sar    $0x1f,%edx
  8004f4:	eb 1c                	jmp    800512 <getint+0x65>
	else
		return va_arg(*ap, int);
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	8d 50 04             	lea    0x4(%eax),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	89 10                	mov    %edx,(%eax)
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 e8 04             	sub    $0x4,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 c2                	mov    %eax,%edx
  80050f:	c1 fa 1f             	sar    $0x1f,%edx
}
  800512:	5d                   	pop    %ebp
  800513:	c3                   	ret    

00800514 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800514:	55                   	push   %ebp
  800515:	89 e5                	mov    %esp,%ebp
  800517:	56                   	push   %esi
  800518:	53                   	push   %ebx
  800519:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80051c:	eb 17                	jmp    800535 <vprintfmt+0x21>
			if (ch == '\0')
  80051e:	85 db                	test   %ebx,%ebx
  800520:	0f 84 d1 05 00 00    	je     800af7 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  800526:	8b 45 0c             	mov    0xc(%ebp),%eax
  800529:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052d:	89 1c 24             	mov    %ebx,(%esp)
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800535:	8b 45 10             	mov    0x10(%ebp),%eax
  800538:	0f b6 00             	movzbl (%eax),%eax
  80053b:	0f b6 d8             	movzbl %al,%ebx
  80053e:	83 fb 25             	cmp    $0x25,%ebx
  800541:	0f 95 c0             	setne  %al
  800544:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800548:	84 c0                	test   %al,%al
  80054a:	75 d2                	jne    80051e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80054c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800550:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800557:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800565:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80056c:	eb 04                	jmp    800572 <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80056e:	90                   	nop
  80056f:	eb 01                	jmp    800572 <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800571:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800572:	8b 45 10             	mov    0x10(%ebp),%eax
  800575:	0f b6 00             	movzbl (%eax),%eax
  800578:	0f b6 d8             	movzbl %al,%ebx
  80057b:	89 d8                	mov    %ebx,%eax
  80057d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800581:	83 e8 23             	sub    $0x23,%eax
  800584:	83 f8 55             	cmp    $0x55,%eax
  800587:	0f 87 39 05 00 00    	ja     800ac6 <vprintfmt+0x5b2>
  80058d:	8b 04 85 c4 29 80 00 	mov    0x8029c4(,%eax,4),%eax
  800594:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800596:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059a:	eb d6                	jmp    800572 <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a0:	eb d0                	jmp    800572 <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ac:	89 d0                	mov    %edx,%eax
  8005ae:	c1 e0 02             	shl    $0x2,%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	01 c0                	add    %eax,%eax
  8005b5:	01 d8                	add    %ebx,%eax
  8005b7:	83 e8 30             	sub    $0x30,%eax
  8005ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c0:	0f b6 00             	movzbl (%eax),%eax
  8005c3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c6:	83 fb 2f             	cmp    $0x2f,%ebx
  8005c9:	7e 43                	jle    80060e <vprintfmt+0xfa>
  8005cb:	83 fb 39             	cmp    $0x39,%ebx
  8005ce:	7f 3e                	jg     80060e <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d4:	eb d3                	jmp    8005a9 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	83 c0 04             	add    $0x4,%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	83 e8 04             	sub    $0x4,%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005ea:	eb 23                	jmp    80060f <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  8005ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f0:	0f 89 78 ff ff ff    	jns    80056e <vprintfmt+0x5a>
				width = 0;
  8005f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fd:	e9 6c ff ff ff       	jmp    80056e <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  800602:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800609:	e9 64 ff ff ff       	jmp    800572 <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800613:	0f 89 58 ff ff ff    	jns    800571 <vprintfmt+0x5d>
				width = precision, precision = -1;
  800619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800626:	e9 46 ff ff ff       	jmp    800571 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80062b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  80062f:	e9 3e ff ff ff       	jmp    800572 <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	83 c0 04             	add    $0x4,%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	83 e8 04             	sub    $0x4,%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	8b 55 0c             	mov    0xc(%ebp),%edx
  800648:	89 54 24 04          	mov    %edx,0x4(%esp)
  80064c:	89 04 24             	mov    %eax,(%esp)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
			break;
  800654:	e9 98 04 00 00       	jmp    800af1 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  800659:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  800660:	00 
  800661:	8b 45 10             	mov    0x10(%ebp),%eax
  800664:	89 44 24 04          	mov    %eax,0x4(%esp)
  800668:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80066b:	89 04 24             	mov    %eax,(%esp)
  80066e:	e8 d1 07 00 00       	call   800e44 <memmove>
            sel_c[3] = '\0';
  800673:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  800677:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  80067b:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80067f:	3c 2f                	cmp    $0x2f,%al
  800681:	7e 4c                	jle    8006cf <vprintfmt+0x1bb>
  800683:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800687:	3c 39                	cmp    $0x39,%al
  800689:	7f 44                	jg     8006cf <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  80068b:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80068f:	0f be d0             	movsbl %al,%edx
  800692:	89 d0                	mov    %edx,%eax
  800694:	c1 e0 02             	shl    $0x2,%eax
  800697:	01 d0                	add    %edx,%eax
  800699:	01 c0                	add    %eax,%eax
  80069b:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8006a1:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  8006a5:	0f be c0             	movsbl %al,%eax
  8006a8:	01 c2                	add    %eax,%edx
  8006aa:	89 d0                	mov    %edx,%eax
  8006ac:	c1 e0 02             	shl    $0x2,%eax
  8006af:	01 d0                	add    %edx,%eax
  8006b1:	01 c0                	add    %eax,%eax
  8006b3:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8006b9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  8006bd:	0f be c0             	movsbl %al,%eax
  8006c0:	01 d0                	add    %edx,%eax
  8006c2:	83 e8 30             	sub    $0x30,%eax
  8006c5:	a3 04 50 80 00       	mov    %eax,0x805004
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006ca:	e9 22 04 00 00       	jmp    800af1 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  8006cf:	c7 44 24 04 8d 29 80 	movl   $0x80298d,0x4(%esp)
  8006d6:	00 
  8006d7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006da:	89 04 24             	mov    %eax,(%esp)
  8006dd:	e8 36 06 00 00       	call   800d18 <strcmp>
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	75 0f                	jne    8006f5 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  8006e6:	c7 05 04 50 80 00 07 	movl   $0x7,0x805004
  8006ed:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006f0:	e9 fc 03 00 00       	jmp    800af1 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  8006f5:	c7 44 24 04 91 29 80 	movl   $0x802991,0x4(%esp)
  8006fc:	00 
  8006fd:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800700:	89 04 24             	mov    %eax,(%esp)
  800703:	e8 10 06 00 00       	call   800d18 <strcmp>
  800708:	85 c0                	test   %eax,%eax
  80070a:	75 0f                	jne    80071b <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  80070c:	c7 05 04 50 80 00 01 	movl   $0x1,0x805004
  800713:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800716:	e9 d6 03 00 00       	jmp    800af1 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  80071b:	c7 44 24 04 95 29 80 	movl   $0x802995,0x4(%esp)
  800722:	00 
  800723:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800726:	89 04 24             	mov    %eax,(%esp)
  800729:	e8 ea 05 00 00       	call   800d18 <strcmp>
  80072e:	85 c0                	test   %eax,%eax
  800730:	75 0f                	jne    800741 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  800732:	c7 05 04 50 80 00 02 	movl   $0x2,0x805004
  800739:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80073c:	e9 b0 03 00 00       	jmp    800af1 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  800741:	c7 44 24 04 99 29 80 	movl   $0x802999,0x4(%esp)
  800748:	00 
  800749:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80074c:	89 04 24             	mov    %eax,(%esp)
  80074f:	e8 c4 05 00 00       	call   800d18 <strcmp>
  800754:	85 c0                	test   %eax,%eax
  800756:	75 0f                	jne    800767 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  800758:	c7 05 04 50 80 00 04 	movl   $0x4,0x805004
  80075f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800762:	e9 8a 03 00 00       	jmp    800af1 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  800767:	c7 44 24 04 9d 29 80 	movl   $0x80299d,0x4(%esp)
  80076e:	00 
  80076f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800772:	89 04 24             	mov    %eax,(%esp)
  800775:	e8 9e 05 00 00       	call   800d18 <strcmp>
  80077a:	85 c0                	test   %eax,%eax
  80077c:	75 0f                	jne    80078d <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  80077e:	c7 05 04 50 80 00 08 	movl   $0x8,0x805004
  800785:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800788:	e9 64 03 00 00       	jmp    800af1 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  80078d:	c7 44 24 04 a1 29 80 	movl   $0x8029a1,0x4(%esp)
  800794:	00 
  800795:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800798:	89 04 24             	mov    %eax,(%esp)
  80079b:	e8 78 05 00 00       	call   800d18 <strcmp>
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	75 0f                	jne    8007b3 <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  8007a4:	c7 05 04 50 80 00 0f 	movl   $0xf,0x805004
  8007ab:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007ae:	e9 3e 03 00 00       	jmp    800af1 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  8007b3:	c7 44 24 04 a5 29 80 	movl   $0x8029a5,0x4(%esp)
  8007ba:	00 
  8007bb:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007be:	89 04 24             	mov    %eax,(%esp)
  8007c1:	e8 52 05 00 00       	call   800d18 <strcmp>
  8007c6:	85 c0                	test   %eax,%eax
  8007c8:	75 0f                	jne    8007d9 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  8007ca:	c7 05 04 50 80 00 0c 	movl   $0xc,0x805004
  8007d1:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007d4:	e9 18 03 00 00       	jmp    800af1 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  8007d9:	c7 44 24 04 a9 29 80 	movl   $0x8029a9,0x4(%esp)
  8007e0:	00 
  8007e1:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007e4:	89 04 24             	mov    %eax,(%esp)
  8007e7:	e8 2c 05 00 00       	call   800d18 <strcmp>
  8007ec:	85 c0                	test   %eax,%eax
  8007ee:	75 0f                	jne    8007ff <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  8007f0:	c7 05 04 50 80 00 06 	movl   $0x6,0x805004
  8007f7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007fa:	e9 f2 02 00 00       	jmp    800af1 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  8007ff:	c7 44 24 04 ad 29 80 	movl   $0x8029ad,0x4(%esp)
  800806:	00 
  800807:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80080a:	89 04 24             	mov    %eax,(%esp)
  80080d:	e8 06 05 00 00       	call   800d18 <strcmp>
  800812:	85 c0                	test   %eax,%eax
  800814:	75 0f                	jne    800825 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  800816:	c7 05 04 50 80 00 0b 	movl   $0xb,0x805004
  80081d:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800820:	e9 cc 02 00 00       	jmp    800af1 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  800825:	c7 05 04 50 80 00 07 	movl   $0x7,0x805004
  80082c:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80082f:	e9 bd 02 00 00       	jmp    800af1 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	83 c0 04             	add    $0x4,%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 e8 04             	sub    $0x4,%eax
  800843:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800845:	85 db                	test   %ebx,%ebx
  800847:	79 02                	jns    80084b <vprintfmt+0x337>
				err = -err;
  800849:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084b:	83 fb 0e             	cmp    $0xe,%ebx
  80084e:	7f 0b                	jg     80085b <vprintfmt+0x347>
  800850:	8b 34 9d 40 29 80 00 	mov    0x802940(,%ebx,4),%esi
  800857:	85 f6                	test   %esi,%esi
  800859:	75 23                	jne    80087e <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  80085b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80085f:	c7 44 24 08 b1 29 80 	movl   $0x8029b1,0x8(%esp)
  800866:	00 
  800867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	89 04 24             	mov    %eax,(%esp)
  800874:	e8 86 02 00 00       	call   800aff <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800879:	e9 73 02 00 00       	jmp    800af1 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800882:	c7 44 24 08 ba 29 80 	movl   $0x8029ba,0x8(%esp)
  800889:	00 
  80088a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	89 04 24             	mov    %eax,(%esp)
  800897:	e8 63 02 00 00       	call   800aff <printfmt>
			break;
  80089c:	e9 50 02 00 00       	jmp    800af1 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	83 c0 04             	add    $0x4,%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 e8 04             	sub    $0x4,%eax
  8008b0:	8b 30                	mov    (%eax),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 05                	jne    8008bb <vprintfmt+0x3a7>
				p = "(null)";
  8008b6:	be bd 29 80 00       	mov    $0x8029bd,%esi
			if (width > 0 && padc != '-')
  8008bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bf:	7e 73                	jle    800934 <vprintfmt+0x420>
  8008c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c5:	74 6d                	je     800934 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ce:	89 34 24             	mov    %esi,(%esp)
  8008d1:	e8 4c 03 00 00       	call   800c22 <strnlen>
  8008d6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d9:	eb 17                	jmp    8008f2 <vprintfmt+0x3de>
					putch(padc, putdat);
  8008db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008e6:	89 04 24             	mov    %eax,(%esp)
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ee:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f6:	7f e3                	jg     8008db <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f8:	eb 3a                	jmp    800934 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  8008fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008fe:	74 1f                	je     80091f <vprintfmt+0x40b>
  800900:	83 fb 1f             	cmp    $0x1f,%ebx
  800903:	7e 05                	jle    80090a <vprintfmt+0x3f6>
  800905:	83 fb 7e             	cmp    $0x7e,%ebx
  800908:	7e 15                	jle    80091f <vprintfmt+0x40b>
					putch('?', putdat);
  80090a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800911:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	ff d0                	call   *%eax
  80091d:	eb 0f                	jmp    80092e <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800922:	89 44 24 04          	mov    %eax,0x4(%esp)
  800926:	89 1c 24             	mov    %ebx,(%esp)
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800932:	eb 01                	jmp    800935 <vprintfmt+0x421>
  800934:	90                   	nop
  800935:	0f b6 06             	movzbl (%esi),%eax
  800938:	0f be d8             	movsbl %al,%ebx
  80093b:	85 db                	test   %ebx,%ebx
  80093d:	0f 95 c0             	setne  %al
  800940:	83 c6 01             	add    $0x1,%esi
  800943:	84 c0                	test   %al,%al
  800945:	74 29                	je     800970 <vprintfmt+0x45c>
  800947:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80094b:	78 ad                	js     8008fa <vprintfmt+0x3e6>
  80094d:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800951:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800955:	79 a3                	jns    8008fa <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800957:	eb 17                	jmp    800970 <vprintfmt+0x45c>
				putch(' ', putdat);
  800959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800960:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800970:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800974:	7f e3                	jg     800959 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  800976:	e9 76 01 00 00       	jmp    800af1 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80097b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800982:	8d 45 14             	lea    0x14(%ebp),%eax
  800985:	89 04 24             	mov    %eax,(%esp)
  800988:	e8 20 fb ff ff       	call   8004ad <getint>
  80098d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800990:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800999:	85 d2                	test   %edx,%edx
  80099b:	79 26                	jns    8009c3 <vprintfmt+0x4af>
				putch('-', putdat);
  80099d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	ff d0                	call   *%eax
				num = -(long long) num;
  8009b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b6:	f7 d8                	neg    %eax
  8009b8:	83 d2 00             	adc    $0x0,%edx
  8009bb:	f7 da                	neg    %edx
  8009bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ca:	e9 ae 00 00 00       	jmp    800a7d <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d9:	89 04 24             	mov    %eax,(%esp)
  8009dc:	e8 65 fa ff ff       	call   800446 <getuint>
  8009e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009e7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ee:	e9 8a 00 00 00       	jmp    800a7d <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  8009f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fd:	89 04 24             	mov    %eax,(%esp)
  800a00:	e8 41 fa ff ff       	call   800446 <getuint>
  800a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  800a0b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  800a12:	eb 69                	jmp    800a7d <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
			putch('x', putdat);
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3d:	83 c0 04             	add    $0x4,%eax
  800a40:	89 45 14             	mov    %eax,0x14(%ebp)
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 e8 04             	sub    $0x4,%eax
  800a49:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a55:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a5c:	eb 1f                	jmp    800a7d <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a65:	8d 45 14             	lea    0x14(%ebp),%eax
  800a68:	89 04 24             	mov    %eax,(%esp)
  800a6b:	e8 d6 f9 ff ff       	call   800446 <getuint>
  800a70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a76:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a7d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a84:	89 54 24 18          	mov    %edx,0x18(%esp)
  800a88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a8b:	89 54 24 14          	mov    %edx,0x14(%esp)
  800a8f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a99:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a9d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 04 24             	mov    %eax,(%esp)
  800aae:	e8 b5 f8 ff ff       	call   800368 <printnum>
			break;
  800ab3:	eb 3c                	jmp    800af1 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abc:	89 1c 24             	mov    %ebx,(%esp)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
			break;
  800ac4:	eb 2b                	jmp    800af1 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800acd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800add:	eb 04                	jmp    800ae3 <vprintfmt+0x5cf>
  800adf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800ae3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae6:	83 e8 01             	sub    $0x1,%eax
  800ae9:	0f b6 00             	movzbl (%eax),%eax
  800aec:	3c 25                	cmp    $0x25,%al
  800aee:	75 ef                	jne    800adf <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800af0:	90                   	nop
		}
	}
  800af1:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800af2:	e9 3e fa ff ff       	jmp    800535 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800af7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af8:	83 c4 50             	add    $0x50,%esp
  800afb:	5b                   	pop    %ebx
  800afc:	5e                   	pop    %esi
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800b05:	8d 45 10             	lea    0x10(%ebp),%eax
  800b08:	83 c0 04             	add    $0x4,%eax
  800b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b14:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b18:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	89 04 24             	mov    %eax,(%esp)
  800b29:	e8 e6 f9 ff ff       	call   800514 <vprintfmt>
	va_end(ap);
}
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 04             	mov    0x4(%eax),%eax
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	73 12                	jae    800b63 <sprintputch+0x33>
		*b->buf++ = ch;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8b 55 08             	mov    0x8(%ebp),%edx
  800b59:	88 10                	mov    %dl,(%eax)
  800b5b:	8d 50 01             	lea    0x1(%eax),%edx
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
}
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	83 e8 01             	sub    $0x1,%eax
  800b77:	03 45 08             	add    0x8(%ebp),%eax
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b88:	74 06                	je     800b90 <vsnprintf+0x2b>
  800b8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8e:	7f 07                	jg     800b97 <vsnprintf+0x32>
		return -E_INVAL;
  800b90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b95:	eb 2a                	jmp    800bc1 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bac:	c7 04 24 30 0b 80 00 	movl   $0x800b30,(%esp)
  800bb3:	e8 5c f9 ff ff       	call   800514 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	89 04 24             	mov    %eax,(%esp)
  800bed:	e8 73 ff ff ff       	call   800b65 <vsnprintf>
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    
	...

00800bfc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c09:	eb 08                	jmp    800c13 <strlen+0x17>
		n++;
  800c0b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	0f b6 00             	movzbl (%eax),%eax
  800c19:	84 c0                	test   %al,%al
  800c1b:	75 ee                	jne    800c0b <strlen+0xf>
		n++;
	return n;
  800c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2f:	eb 0c                	jmp    800c3d <strnlen+0x1b>
		n++;
  800c31:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c39:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800c3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c41:	74 0a                	je     800c4d <strnlen+0x2b>
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	0f b6 00             	movzbl (%eax),%eax
  800c49:	84 c0                	test   %al,%al
  800c4b:	75 e4                	jne    800c31 <strnlen+0xf>
		n++;
	return n;
  800c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c5e:	90                   	nop
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	0f b6 10             	movzbl (%eax),%edx
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	88 10                	mov    %dl,(%eax)
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	0f b6 00             	movzbl (%eax),%eax
  800c70:	84 c0                	test   %al,%al
  800c72:	0f 95 c0             	setne  %al
  800c75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c79:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800c7d:	84 c0                	test   %al,%al
  800c7f:	75 de                	jne    800c5f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c99:	eb 21                	jmp    800cbc <strncpy+0x36>
		*dst++ = *src;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	0f b6 10             	movzbl (%eax),%edx
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	88 10                	mov    %dl,(%eax)
  800ca6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	0f b6 00             	movzbl (%eax),%eax
  800cb0:	84 c0                	test   %al,%al
  800cb2:	74 04                	je     800cb8 <strncpy+0x32>
			src++;
  800cb4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc2:	72 d7                	jb     800c9b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd9:	74 2f                	je     800d0a <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800cdb:	eb 13                	jmp    800cf0 <strlcpy+0x27>
			*dst++ = *src++;
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	0f b6 10             	movzbl (%eax),%edx
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	88 10                	mov    %dl,(%eax)
  800ce8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cec:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf8:	74 0a                	je     800d04 <strlcpy+0x3b>
  800cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfd:	0f b6 00             	movzbl (%eax),%eax
  800d00:	84 c0                	test   %al,%al
  800d02:	75 d9                	jne    800cdd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	89 d1                	mov    %edx,%ecx
  800d12:	29 c1                	sub    %eax,%ecx
  800d14:	89 c8                	mov    %ecx,%eax
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    

00800d18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d1b:	eb 08                	jmp    800d25 <strcmp+0xd>
		p++, q++;
  800d1d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d21:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	0f b6 00             	movzbl (%eax),%eax
  800d2b:	84 c0                	test   %al,%al
  800d2d:	74 10                	je     800d3f <strcmp+0x27>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	0f b6 10             	movzbl (%eax),%edx
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	0f b6 00             	movzbl (%eax),%eax
  800d3b:	38 c2                	cmp    %al,%dl
  800d3d:	74 de                	je     800d1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	0f b6 00             	movzbl (%eax),%eax
  800d45:	0f b6 d0             	movzbl %al,%edx
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	0f b6 00             	movzbl (%eax),%eax
  800d4e:	0f b6 c0             	movzbl %al,%eax
  800d51:	89 d1                	mov    %edx,%ecx
  800d53:	29 c1                	sub    %eax,%ecx
  800d55:	89 c8                	mov    %ecx,%eax
}
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d5c:	eb 0c                	jmp    800d6a <strncmp+0x11>
		n--, p++, q++;
  800d5e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d66:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 1a                	je     800d8a <strncmp+0x31>
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	0f b6 00             	movzbl (%eax),%eax
  800d76:	84 c0                	test   %al,%al
  800d78:	74 10                	je     800d8a <strncmp+0x31>
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	0f b6 10             	movzbl (%eax),%edx
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	0f b6 00             	movzbl (%eax),%eax
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 d4                	je     800d5e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8e:	75 07                	jne    800d97 <strncmp+0x3e>
		return 0;
  800d90:	b8 00 00 00 00       	mov    $0x0,%eax
  800d95:	eb 18                	jmp    800daf <strncmp+0x56>
	else
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

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 14                	jmp    800dd3 <strchr+0x22>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	0f b6 00             	movzbl (%eax),%eax
  800dc5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc8:	75 05                	jne    800dcf <strchr+0x1e>
			return (char *) s;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	eb 13                	jmp    800de2 <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dcf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	0f b6 00             	movzbl (%eax),%eax
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 e2                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 04             	sub    $0x4,%esp
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df0:	eb 0f                	jmp    800e01 <strfind+0x1d>
		if (*s == c)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	0f b6 00             	movzbl (%eax),%eax
  800df8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dfb:	74 10                	je     800e0d <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dfd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	0f b6 00             	movzbl (%eax),%eax
  800e07:	84 c0                	test   %al,%al
  800e09:	75 e7                	jne    800df2 <strfind+0xe>
  800e0b:	eb 01                	jmp    800e0e <strfind+0x2a>
		if (*s == c)
			break;
  800e0d:	90                   	nop
	return (char *) s;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <memset>:


void *
memset(void *v, int c, size_t n)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e25:	eb 0e                	jmp    800e35 <memset+0x22>
		*p++ = c;
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	89 c2                	mov    %eax,%edx
  800e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2f:	88 10                	mov    %dl,(%eax)
  800e31:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e35:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800e39:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e3d:	79 e8                	jns    800e27 <memset+0x14>
		*p++ = c;

	return v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e59:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5c:	73 54                	jae    800eb2 <memmove+0x6e>
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e64:	01 d0                	add    %edx,%eax
  800e66:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e69:	76 47                	jbe    800eb2 <memmove+0x6e>
		s += n;
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e77:	eb 13                	jmp    800e8c <memmove+0x48>
			*--d = *--s;
  800e79:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800e7d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	0f b6 10             	movzbl (%eax),%edx
  800e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e90:	0f 95 c0             	setne  %al
  800e93:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e97:	84 c0                	test   %al,%al
  800e99:	75 de                	jne    800e79 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9b:	eb 25                	jmp    800ec2 <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea0:	0f b6 10             	movzbl (%eax),%edx
  800ea3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea6:	88 10                	mov    %dl,(%eax)
  800ea8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800eac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800eb0:	eb 01                	jmp    800eb3 <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb2:	90                   	nop
  800eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb7:	0f 95 c0             	setne  %al
  800eba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800ebe:	84 c0                	test   %al,%al
  800ec0:	75 db                	jne    800e9d <memmove+0x59>
			*d++ = *s++;

	return dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	89 04 24             	mov    %eax,(%esp)
  800ee1:	e8 5e ff ff ff       	call   800e44 <memmove>
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800efa:	eb 32                	jmp    800f2e <memcmp+0x46>
		if (*s1 != *s2)
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	0f b6 10             	movzbl (%eax),%edx
  800f02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f05:	0f b6 00             	movzbl (%eax),%eax
  800f08:	38 c2                	cmp    %al,%dl
  800f0a:	74 1a                	je     800f26 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	0f b6 00             	movzbl (%eax),%eax
  800f12:	0f b6 d0             	movzbl %al,%edx
  800f15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f18:	0f b6 00             	movzbl (%eax),%eax
  800f1b:	0f b6 c0             	movzbl %al,%eax
  800f1e:	89 d1                	mov    %edx,%ecx
  800f20:	29 c1                	sub    %eax,%ecx
  800f22:	89 c8                	mov    %ecx,%eax
  800f24:	eb 1c                	jmp    800f42 <memcmp+0x5a>
		s1++, s2++;
  800f26:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800f2a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	0f 95 c0             	setne  %al
  800f35:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800f39:	84 c0                	test   %al,%al
  800f3b:	75 bf                	jne    800efc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	01 d0                	add    %edx,%eax
  800f52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f55:	eb 11                	jmp    800f68 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	0f b6 10             	movzbl (%eax),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	38 c2                	cmp    %al,%dl
  800f62:	74 0e                	je     800f72 <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f64:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f6e:	72 e7                	jb     800f57 <memfind+0x13>
  800f70:	eb 01                	jmp    800f73 <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f72:	90                   	nop
	return (void *) s;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f85:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f8c:	eb 04                	jmp    800f92 <strtol+0x1a>
		s++;
  800f8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	0f b6 00             	movzbl (%eax),%eax
  800f98:	3c 20                	cmp    $0x20,%al
  800f9a:	74 f2                	je     800f8e <strtol+0x16>
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	0f b6 00             	movzbl (%eax),%eax
  800fa2:	3c 09                	cmp    $0x9,%al
  800fa4:	74 e8                	je     800f8e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	0f b6 00             	movzbl (%eax),%eax
  800fac:	3c 2b                	cmp    $0x2b,%al
  800fae:	75 06                	jne    800fb6 <strtol+0x3e>
		s++;
  800fb0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fb4:	eb 15                	jmp    800fcb <strtol+0x53>
	else if (*s == '-')
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	0f b6 00             	movzbl (%eax),%eax
  800fbc:	3c 2d                	cmp    $0x2d,%al
  800fbe:	75 0b                	jne    800fcb <strtol+0x53>
		s++, neg = 1;
  800fc0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x5f>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 24                	jne    800ffb <strtol+0x83>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	0f b6 00             	movzbl (%eax),%eax
  800fdd:	3c 30                	cmp    $0x30,%al
  800fdf:	75 1a                	jne    800ffb <strtol+0x83>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	83 c0 01             	add    $0x1,%eax
  800fe7:	0f b6 00             	movzbl (%eax),%eax
  800fea:	3c 78                	cmp    $0x78,%al
  800fec:	75 0d                	jne    800ffb <strtol+0x83>
		s += 2, base = 16;
  800fee:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ff2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff9:	eb 2a                	jmp    801025 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  800ffb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fff:	75 17                	jne    801018 <strtol+0xa0>
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	0f b6 00             	movzbl (%eax),%eax
  801007:	3c 30                	cmp    $0x30,%al
  801009:	75 0d                	jne    801018 <strtol+0xa0>
		s++, base = 8;
  80100b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80100f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801016:	eb 0d                	jmp    801025 <strtol+0xad>
	else if (base == 0)
  801018:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101c:	75 07                	jne    801025 <strtol+0xad>
		base = 10;
  80101e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	0f b6 00             	movzbl (%eax),%eax
  80102b:	3c 2f                	cmp    $0x2f,%al
  80102d:	7e 1b                	jle    80104a <strtol+0xd2>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	0f b6 00             	movzbl (%eax),%eax
  801035:	3c 39                	cmp    $0x39,%al
  801037:	7f 11                	jg     80104a <strtol+0xd2>
			dig = *s - '0';
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	0f b6 00             	movzbl (%eax),%eax
  80103f:	0f be c0             	movsbl %al,%eax
  801042:	83 e8 30             	sub    $0x30,%eax
  801045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801048:	eb 48                	jmp    801092 <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	0f b6 00             	movzbl (%eax),%eax
  801050:	3c 60                	cmp    $0x60,%al
  801052:	7e 1b                	jle    80106f <strtol+0xf7>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	0f b6 00             	movzbl (%eax),%eax
  80105a:	3c 7a                	cmp    $0x7a,%al
  80105c:	7f 11                	jg     80106f <strtol+0xf7>
			dig = *s - 'a' + 10;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	0f b6 00             	movzbl (%eax),%eax
  801064:	0f be c0             	movsbl %al,%eax
  801067:	83 e8 57             	sub    $0x57,%eax
  80106a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106d:	eb 23                	jmp    801092 <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	0f b6 00             	movzbl (%eax),%eax
  801075:	3c 40                	cmp    $0x40,%al
  801077:	7e 38                	jle    8010b1 <strtol+0x139>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	0f b6 00             	movzbl (%eax),%eax
  80107f:	3c 5a                	cmp    $0x5a,%al
  801081:	7f 2e                	jg     8010b1 <strtol+0x139>
			dig = *s - 'A' + 10;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	0f b6 00             	movzbl (%eax),%eax
  801089:	0f be c0             	movsbl %al,%eax
  80108c:	83 e8 37             	sub    $0x37,%eax
  80108f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801095:	3b 45 10             	cmp    0x10(%ebp),%eax
  801098:	7d 16                	jge    8010b0 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  80109a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010a5:	03 45 f4             	add    -0xc(%ebp),%eax
  8010a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010ab:	e9 75 ff ff ff       	jmp    801025 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010b0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b5:	74 08                	je     8010bf <strtol+0x147>
		*endptr = (char *) s;
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c3:	74 07                	je     8010cc <strtol+0x154>
  8010c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c8:	f7 d8                	neg    %eax
  8010ca:	eb 03                	jmp    8010cf <strtol+0x157>
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    
  8010d1:	00 00                	add    %al,(%eax)
	...

008010d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	57                   	push   %edi
  8010d8:	56                   	push   %esi
  8010d9:	53                   	push   %ebx
  8010da:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8010e3:	8b 55 10             	mov    0x10(%ebp),%edx
  8010e6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8010e9:	8b 5d 18             	mov    0x18(%ebp),%ebx
  8010ec:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  8010ef:	8b 75 20             	mov    0x20(%ebp),%esi
  8010f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010f5:	cd 30                	int    $0x30
  8010f7:	89 c3                	mov    %eax,%ebx
  8010f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801100:	74 30                	je     801132 <syscall+0x5e>
  801102:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801106:	7e 2a                	jle    801132 <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  801108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80110b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801116:	c7 44 24 08 1c 2b 80 	movl   $0x802b1c,0x8(%esp)
  80111d:	00 
  80111e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801125:	00 
  801126:	c7 04 24 39 2b 80 00 	movl   $0x802b39,(%esp)
  80112d:	e8 da f0 ff ff       	call   80020c <_panic>

	return ret;
  801132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801135:	83 c4 4c             	add    $0x4c,%esp
  801138:	5b                   	pop    %ebx
  801139:	5e                   	pop    %esi
  80113a:	5f                   	pop    %edi
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80114d:	00 
  80114e:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801155:	00 
  801156:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80115d:	00 
  80115e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801161:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801165:	89 44 24 08          	mov    %eax,0x8(%esp)
  801169:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801170:	00 
  801171:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801178:	e8 57 ff ff ff       	call   8010d4 <syscall>
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sys_cgetc>:

int
sys_cgetc(void)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801185:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80118c:	00 
  80118d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801194:	00 
  801195:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80119c:	00 
  80119d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011a4:	00 
  8011a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011ac:	00 
  8011ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011b4:	00 
  8011b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8011bc:	e8 13 ff ff ff       	call   8010d4 <syscall>
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8011d3:	00 
  8011d4:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8011db:	00 
  8011dc:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011eb:	00 
  8011ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011f0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011f7:	00 
  8011f8:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8011ff:	e8 d0 fe ff ff       	call   8010d4 <syscall>
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80120c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801213:	00 
  801214:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80121b:	00 
  80121c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801223:	00 
  801224:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80122b:	00 
  80122c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801233:	00 
  801234:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80123b:	00 
  80123c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801243:	e8 8c fe ff ff       	call   8010d4 <syscall>
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <sys_yield>:

void
sys_yield(void)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801250:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801257:	00 
  801258:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80125f:	00 
  801260:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801267:	00 
  801268:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80126f:	00 
  801270:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801277:	00 
  801278:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80127f:	00 
  801280:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  801287:	e8 48 fe ff ff       	call   8010d4 <syscall>
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801294:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801297:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012a4:	00 
  8012a5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012ac:	00 
  8012ad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8012b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012c0:	00 
  8012c1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8012c8:	e8 07 fe ff ff       	call   8010d4 <syscall>
}
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	56                   	push   %esi
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8012d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8012da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	89 74 24 18          	mov    %esi,0x18(%esp)
  8012ea:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8012ee:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8012f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801301:	00 
  801302:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  801309:	e8 c6 fd ff ff       	call   8010d4 <syscall>
}
  80130e:	83 c4 20             	add    $0x20,%esp
  801311:	5b                   	pop    %ebx
  801312:	5e                   	pop    %esi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    

00801315 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80131b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801328:	00 
  801329:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801330:	00 
  801331:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801338:	00 
  801339:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80133d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801341:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801348:	00 
  801349:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  801350:	e8 7f fd ff ff       	call   8010d4 <syscall>
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  80135d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80136a:	00 
  80136b:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801372:	00 
  801373:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80137a:	00 
  80137b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80137f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801383:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80138a:	00 
  80138b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  801392:	e8 3d fd ff ff       	call   8010d4 <syscall>
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80139f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013ac:	00 
  8013ad:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013b4:	00 
  8013b5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013bc:	00 
  8013bd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013cc:	00 
  8013cd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8013d4:	e8 fb fc ff ff       	call   8010d4 <syscall>
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8013e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013ee:	00 
  8013ef:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013f6:	00 
  8013f7:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013fe:	00 
  8013ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801403:	89 44 24 08          	mov    %eax,0x8(%esp)
  801407:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80140e:	00 
  80140f:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  801416:	e8 b9 fc ff ff       	call   8010d4 <syscall>
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  801423:	8b 55 0c             	mov    0xc(%ebp),%edx
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801430:	00 
  801431:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801438:	00 
  801439:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801440:	00 
  801441:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801445:	89 44 24 08          	mov    %eax,0x8(%esp)
  801449:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801450:	00 
  801451:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801458:	e8 77 fc ff ff       	call   8010d4 <syscall>
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801465:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801468:	8b 55 10             	mov    0x10(%ebp),%edx
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801475:	00 
  801476:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  80147a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80147e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801481:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801485:	89 44 24 08          	mov    %eax,0x8(%esp)
  801489:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801490:	00 
  801491:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  801498:	e8 37 fc ff ff       	call   8010d4 <syscall>
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8014af:	00 
  8014b0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8014b7:	00 
  8014b8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8014bf:	00 
  8014c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8014c7:	00 
  8014c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014d3:	00 
  8014d4:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  8014db:	e8 f4 fb ff ff       	call   8010d4 <syscall>
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    
	...

008014e4 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	89 04 24             	mov    %eax,(%esp)
  8014f0:	e8 0a 00 00 00       	call   8014ff <fd2num>
  8014f5:	05 40 03 00 00       	add    $0x340,%eax
  8014fa:	c1 e0 16             	shl    $0x16,%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <fd2num>:

int
fd2num(struct Fd *fd)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	05 00 00 40 30       	add    $0x30400000,%eax
  80150a:	c1 e8 0c             	shr    $0xc,%eax
}
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    

0080150f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801515:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80151c:	eb 49                	jmp    801567 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  80151e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801521:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801526:	c1 e0 0c             	shl    $0xc,%eax
  801529:	89 c2                	mov    %eax,%edx
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8b 00                	mov    (%eax),%eax
  801535:	c1 e8 16             	shr    $0x16,%eax
  801538:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80153f:	83 e0 01             	and    $0x1,%eax
  801542:	85 c0                	test   %eax,%eax
  801544:	74 16                	je     80155c <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8b 00                	mov    (%eax),%eax
  80154b:	c1 e8 0c             	shr    $0xc,%eax
  80154e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801555:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801558:	85 c0                	test   %eax,%eax
  80155a:	75 07                	jne    801563 <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	eb 18                	jmp    80157b <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801563:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801567:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  80156b:	7e b1                	jle    80151e <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  801576:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  801583:	c7 44 24 08 48 2b 80 	movl   $0x802b48,0x8(%esp)
  80158a:	00 
  80158b:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801592:	00 
  801593:	c7 04 24 62 2b 80 00 	movl   $0x802b62,(%esp)
  80159a:	e8 6d ec ff ff       	call   80020c <_panic>

0080159f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	89 04 24             	mov    %eax,(%esp)
  8015ab:	e8 4f ff ff ff       	call   8014ff <fd2num>
  8015b0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8015b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015b7:	89 04 24             	mov    %eax,(%esp)
  8015ba:	e8 be ff ff ff       	call   80157d <fd_lookup>
  8015bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015c6:	78 08                	js     8015d0 <fd_close+0x31>
	    || fd != fd2)
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	39 45 08             	cmp    %eax,0x8(%ebp)
  8015ce:	74 12                	je     8015e2 <fd_close+0x43>
		return (must_exist ? r : 0);
  8015d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d4:	74 05                	je     8015db <fd_close+0x3c>
  8015d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d9:	eb 05                	jmp    8015e0 <fd_close+0x41>
  8015db:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e0:	eb 44                	jmp    801626 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8015ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015ee:	89 04 24             	mov    %eax,(%esp)
  8015f1:	e8 32 00 00 00       	call   801628 <dev_lookup>
  8015f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015fd:	78 11                	js     801610 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  8015ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801602:	8b 50 10             	mov    0x10(%eax),%edx
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	89 04 24             	mov    %eax,(%esp)
  80160b:	ff d2                	call   *%edx
  80160d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	89 44 24 04          	mov    %eax,0x4(%esp)
  801617:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80161e:	e8 f2 fc ff ff       	call   801315 <sys_page_unmap>
	return r;
  801623:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  80162e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801635:	eb 2b                	jmp    801662 <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  801637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163a:	8b 04 85 08 50 80 00 	mov    0x805008(,%eax,4),%eax
  801641:	8b 00                	mov    (%eax),%eax
  801643:	3b 45 08             	cmp    0x8(%ebp),%eax
  801646:	75 16                	jne    80165e <dev_lookup+0x36>
			*dev = devtab[i];
  801648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164b:	8b 14 85 08 50 80 00 	mov    0x805008(,%eax,4),%edx
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	89 10                	mov    %edx,(%eax)
			return 0;
  801657:	b8 00 00 00 00       	mov    $0x0,%eax
  80165c:	eb 3f                	jmp    80169d <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80165e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801665:	8b 04 85 08 50 80 00 	mov    0x805008(,%eax,4),%eax
  80166c:	85 c0                	test   %eax,%eax
  80166e:	75 c7                	jne    801637 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801670:	a1 40 70 80 00       	mov    0x807040,%eax
  801675:	8b 40 4c             	mov    0x4c(%eax),%eax
  801678:	8b 55 08             	mov    0x8(%ebp),%edx
  80167b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80167f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801683:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  80168a:	e8 b1 ec ff ff       	call   800340 <cprintf>
	*dev = 0;
  80168f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801698:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <close>:

int
close(int fdnum)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	89 04 24             	mov    %eax,(%esp)
  8016b2:	e8 c6 fe ff ff       	call   80157d <fd_lookup>
  8016b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016be:	79 05                	jns    8016c5 <close+0x26>
		return r;
  8016c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c3:	eb 13                	jmp    8016d8 <close+0x39>
	else
		return fd_close(fd, 1);
  8016c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016cf:	00 
  8016d0:	89 04 24             	mov    %eax,(%esp)
  8016d3:	e8 c7 fe ff ff       	call   80159f <fd_close>
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <close_all>:

void
close_all(void)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016e7:	eb 0f                	jmp    8016f8 <close_all+0x1e>
		close(i);
  8016e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ec:	89 04 24             	mov    %eax,(%esp)
  8016ef:	e8 ab ff ff ff       	call   80169f <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8016f8:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  8016fc:	7e eb                	jle    8016e9 <close_all+0xf>
		close(i);
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801706:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801709:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 04 24             	mov    %eax,(%esp)
  801713:	e8 65 fe ff ff       	call   80157d <fd_lookup>
  801718:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80171b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80171f:	79 08                	jns    801729 <dup+0x29>
		return r;
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	e9 54 01 00 00       	jmp    80187d <dup+0x17d>
	close(newfdnum);
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172c:	89 04 24             	mov    %eax,(%esp)
  80172f:	e8 6b ff ff ff       	call   80169f <close>

	newfd = INDEX2FD(newfdnum);
  801734:	8b 45 0c             	mov    0xc(%ebp),%eax
  801737:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  80173c:	c1 e0 0c             	shl    $0xc,%eax
  80173f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  801742:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801745:	89 04 24             	mov    %eax,(%esp)
  801748:	e8 97 fd ff ff       	call   8014e4 <fd2data>
  80174d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801753:	89 04 24             	mov    %eax,(%esp)
  801756:	e8 89 fd ff ff       	call   8014e4 <fd2data>
  80175b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80175e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801761:	c1 e8 0c             	shr    $0xc,%eax
  801764:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80176b:	89 c2                	mov    %eax,%edx
  80176d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801773:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801776:	89 54 24 10          	mov    %edx,0x10(%esp)
  80177a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80177d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801781:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801788:	00 
  801789:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801794:	e8 36 fb ff ff       	call   8012cf <sys_page_map>
  801799:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80179c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017a0:	0f 88 8e 00 00 00    	js     801834 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  8017a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a9:	c1 e8 16             	shr    $0x16,%eax
  8017ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	74 78                	je     80182f <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8017b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017be:	eb 66                	jmp    801826 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  8017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c3:	03 45 e8             	add    -0x18(%ebp),%eax
  8017c6:	c1 e8 0c             	shr    $0xc,%eax
  8017c9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  8017d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d6:	83 e0 01             	and    $0x1,%eax
  8017d9:	84 c0                	test   %al,%al
  8017db:	74 42                	je     80181f <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  8017dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017e0:	89 c1                	mov    %eax,%ecx
  8017e2:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	89 c2                	mov    %eax,%edx
  8017ed:	03 55 e4             	add    -0x1c(%ebp),%edx
  8017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f3:	03 45 e8             	add    -0x18(%ebp),%eax
  8017f6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8017fa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801805:	00 
  801806:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801811:	e8 b9 fa ff ff       	call   8012cf <sys_page_map>
  801816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801819:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80181d:	78 18                	js     801837 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  80181f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801826:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  80182d:	7e 91                	jle    8017c0 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  80182f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801832:	eb 49                	jmp    80187d <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  801834:	90                   	nop
  801835:	eb 01                	jmp    801838 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  801837:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801838:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801846:	e8 ca fa ff ff       	call   801315 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80184b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801852:	eb 1d                	jmp    801871 <dup+0x171>
		sys_page_unmap(0, nva + i);
  801854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801857:	03 45 e4             	add    -0x1c(%ebp),%eax
  80185a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801865:	e8 ab fa ff ff       	call   801315 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80186a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801871:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801878:	7e da                	jle    801854 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  80187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801885:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801888:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	89 04 24             	mov    %eax,(%esp)
  801892:	e8 e6 fc ff ff       	call   80157d <fd_lookup>
  801897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80189a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80189e:	78 1d                	js     8018bd <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a3:	8b 00                	mov    (%eax),%eax
  8018a5:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8018a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018ac:	89 04 24             	mov    %eax,(%esp)
  8018af:	e8 74 fd ff ff       	call   801628 <dev_lookup>
  8018b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018bb:	79 05                	jns    8018c2 <read+0x43>
		return r;
  8018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c0:	eb 75                	jmp    801937 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c5:	8b 40 08             	mov    0x8(%eax),%eax
  8018c8:	83 e0 03             	and    $0x3,%eax
  8018cb:	83 f8 01             	cmp    $0x1,%eax
  8018ce:	75 26                	jne    8018f6 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8018d0:	a1 40 70 80 00       	mov    0x807040,%eax
  8018d5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e3:	c7 04 24 8b 2b 80 00 	movl   $0x802b8b,(%esp)
  8018ea:	e8 51 ea ff ff       	call   800340 <cprintf>
		return -E_INVAL;
  8018ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f4:	eb 41                	jmp    801937 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f9:	8b 48 08             	mov    0x8(%eax),%ecx
  8018fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ff:	8b 50 04             	mov    0x4(%eax),%edx
  801902:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801905:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801909:	8b 55 10             	mov    0x10(%ebp),%edx
  80190c:	89 54 24 08          	mov    %edx,0x8(%esp)
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	89 54 24 04          	mov    %edx,0x4(%esp)
  801917:	89 04 24             	mov    %eax,(%esp)
  80191a:	ff d1                	call   *%ecx
  80191c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  80191f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801923:	78 0f                	js     801934 <read+0xb5>
		fd->fd_offset += r;
  801925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801928:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80192b:	8b 52 04             	mov    0x4(%edx),%edx
  80192e:	03 55 f4             	add    -0xc(%ebp),%edx
  801931:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801934:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80193f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801946:	eb 3b                	jmp    801983 <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	8b 55 10             	mov    0x10(%ebp),%edx
  80194e:	29 c2                	sub    %eax,%edx
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	03 45 0c             	add    0xc(%ebp),%eax
  801956:	89 54 24 08          	mov    %edx,0x8(%esp)
  80195a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	89 04 24             	mov    %eax,(%esp)
  801964:	e8 16 ff ff ff       	call   80187f <read>
  801969:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  80196c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801970:	79 05                	jns    801977 <readn+0x3e>
			return m;
  801972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801975:	eb 1a                	jmp    801991 <readn+0x58>
		if (m == 0)
  801977:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80197b:	74 10                	je     80198d <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80197d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801980:	01 45 f4             	add    %eax,-0xc(%ebp)
  801983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801986:	3b 45 10             	cmp    0x10(%ebp),%eax
  801989:	72 bd                	jb     801948 <readn+0xf>
  80198b:	eb 01                	jmp    80198e <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80198d:	90                   	nop
	}
	return tot;
  80198e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801999:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80199c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	89 04 24             	mov    %eax,(%esp)
  8019a6:	e8 d2 fb ff ff       	call   80157d <fd_lookup>
  8019ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019b2:	78 1d                	js     8019d1 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b7:	8b 00                	mov    (%eax),%eax
  8019b9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8019bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019c0:	89 04 24             	mov    %eax,(%esp)
  8019c3:	e8 60 fc ff ff       	call   801628 <dev_lookup>
  8019c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019cf:	79 05                	jns    8019d6 <write+0x43>
		return r;
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	eb 74                	jmp    801a4a <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d9:	8b 40 08             	mov    0x8(%eax),%eax
  8019dc:	83 e0 03             	and    $0x3,%eax
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 26                	jne    801a09 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8019e3:	a1 40 70 80 00       	mov    0x807040,%eax
  8019e8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f6:	c7 04 24 a7 2b 80 00 	movl   $0x802ba7,(%esp)
  8019fd:	e8 3e e9 ff ff       	call   800340 <cprintf>
		return -E_INVAL;
  801a02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a07:	eb 41                	jmp    801a4a <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0c:	8b 48 0c             	mov    0xc(%eax),%ecx
  801a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a12:	8b 50 04             	mov    0x4(%eax),%edx
  801a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a18:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a1c:	8b 55 10             	mov    0x10(%ebp),%edx
  801a1f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a26:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a2a:	89 04 24             	mov    %eax,(%esp)
  801a2d:	ff d1                	call   *%ecx
  801a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  801a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a36:	7e 0f                	jle    801a47 <write+0xb4>
		fd->fd_offset += r;
  801a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a3e:	8b 52 04             	mov    0x4(%edx),%edx
  801a41:	03 55 f4             	add    -0xc(%ebp),%edx
  801a44:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <seek>:

int
seek(int fdnum, off_t offset)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a52:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	89 04 24             	mov    %eax,(%esp)
  801a5f:	e8 19 fb ff ff       	call   80157d <fd_lookup>
  801a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a6b:	79 05                	jns    801a72 <seek+0x26>
		return r;
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	eb 0e                	jmp    801a80 <seek+0x34>
	fd->fd_offset = offset;
  801a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	89 04 24             	mov    %eax,(%esp)
  801a95:	e8 e3 fa ff ff       	call   80157d <fd_lookup>
  801a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aa1:	78 1d                	js     801ac0 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa6:	8b 00                	mov    (%eax),%eax
  801aa8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801aab:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aaf:	89 04 24             	mov    %eax,(%esp)
  801ab2:	e8 71 fb ff ff       	call   801628 <dev_lookup>
  801ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801abe:	79 05                	jns    801ac5 <ftruncate+0x43>
		return r;
  801ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac3:	eb 48                	jmp    801b0d <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac8:	8b 40 08             	mov    0x8(%eax),%eax
  801acb:	83 e0 03             	and    $0x3,%eax
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	75 26                	jne    801af8 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801ad2:	a1 40 70 80 00       	mov    0x807040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ad7:	8b 40 4c             	mov    0x4c(%eax),%eax
  801ada:	8b 55 08             	mov    0x8(%ebp),%edx
  801add:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae5:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  801aec:	e8 4f e8 ff ff       	call   800340 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801af1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af6:	eb 15                	jmp    801b0d <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afb:	8b 48 1c             	mov    0x1c(%eax),%ecx
  801afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b04:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b08:	89 04 24             	mov    %eax,(%esp)
  801b0b:	ff d1                	call   *%ecx
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b15:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	89 04 24             	mov    %eax,(%esp)
  801b22:	e8 56 fa ff ff       	call   80157d <fd_lookup>
  801b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b2e:	78 1d                	js     801b4d <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b33:	8b 00                	mov    (%eax),%eax
  801b35:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b38:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b3c:	89 04 24             	mov    %eax,(%esp)
  801b3f:	e8 e4 fa ff ff       	call   801628 <dev_lookup>
  801b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b4b:	79 05                	jns    801b52 <fstat+0x43>
		return r;
  801b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b50:	eb 41                	jmp    801b93 <fstat+0x84>
	stat->st_name[0] = 0;
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801b62:	00 00 00 
	stat->st_isdir = 0;
  801b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b68:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  801b6f:	00 00 00 
	stat->st_dev = dev;
  801b72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b78:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  801b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b81:	8b 48 14             	mov    0x14(%eax),%ecx
  801b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	ff d1                	call   *%ecx
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ba2:	00 
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	89 04 24             	mov    %eax,(%esp)
  801ba9:	e8 36 00 00 00       	call   801be4 <open>
  801bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb5:	79 05                	jns    801bbc <stat+0x27>
		return fd;
  801bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bba:	eb 23                	jmp    801bdf <stat+0x4a>
	r = fstat(fd, stat);
  801bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc6:	89 04 24             	mov    %eax,(%esp)
  801bc9:	e8 41 ff ff ff       	call   801b0f <fstat>
  801bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	89 04 24             	mov    %eax,(%esp)
  801bd7:	e8 c3 fa ff ff       	call   80169f <close>
	return r;
  801bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    
  801be1:	00 00                	add    %al,(%eax)
	...

00801be4 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801bea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bed:	89 04 24             	mov    %eax,(%esp)
  801bf0:	e8 1a f9 ff ff       	call   80150f <fd_alloc>
  801bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bfc:	79 05                	jns    801c03 <open+0x1f>
  801bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c01:	eb 73                	jmp    801c76 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  801c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	89 04 24             	mov    %eax,(%esp)
  801c17:	e8 54 05 00 00       	call   802170 <fsipc_open>
  801c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c23:	79 05                	jns    801c2a <open+0x46>
  801c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c28:	eb 4c                	jmp    801c76 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c36:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c3a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c41:	00 
  801c42:	89 04 24             	mov    %eax,(%esp)
  801c45:	e8 25 03 00 00       	call   801f6f <fmap>
  801c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c51:	79 18                	jns    801c6b <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  801c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c5d:	00 
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 39 f9 ff ff       	call   80159f <fd_close>
  801c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c69:	eb 0b                	jmp    801c76 <open+0x92>
	return fd2num(fd);
  801c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6e:	89 04 24             	mov    %eax,(%esp)
  801c71:	e8 89 f8 ff ff       	call   8014ff <fd2num>
	//panic("open() unimplemented!");
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801c87:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801c8e:	00 
  801c8f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c96:	00 
  801c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	89 04 24             	mov    %eax,(%esp)
  801ca1:	e8 72 03 00 00       	call   802018 <funmap>
  801ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cad:	79 05                	jns    801cb4 <file_close+0x3c>
  801caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb2:	eb 21                	jmp    801cd5 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cba:	89 04 24             	mov    %eax,(%esp)
  801cbd:	e8 e3 05 00 00       	call   8022a5 <fsipc_close>
  801cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cc9:	79 05                	jns    801cd0 <file_close+0x58>
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	eb 05                	jmp    801cd5 <file_close+0x5d>
	return 0;
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cef:	76 07                	jbe    801cf8 <file_read+0x21>
		return 0;
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf6:	eb 43                	jmp    801d3b <file_read+0x64>
	if (offset + n > size)
  801cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfb:	03 45 10             	add    0x10(%ebp),%eax
  801cfe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d01:	76 0f                	jbe    801d12 <file_read+0x3b>
		n = size - offset;
  801d03:	8b 45 14             	mov    0x14(%ebp),%eax
  801d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d09:	89 d1                	mov    %edx,%ecx
  801d0b:	29 c1                	sub    %eax,%ecx
  801d0d:	89 c8                	mov    %ecx,%eax
  801d0f:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	89 04 24             	mov    %eax,(%esp)
  801d18:	e8 c7 f7 ff ff       	call   8014e4 <fd2data>
  801d1d:	8b 55 14             	mov    0x14(%ebp),%edx
  801d20:	01 c2                	add    %eax,%edx
  801d22:	8b 45 10             	mov    0x10(%ebp),%eax
  801d25:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d29:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d30:	89 04 24             	mov    %eax,(%esp)
  801d33:	e8 0c f1 ff ff       	call   800e44 <memmove>
	return n;
  801d38:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d43:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	89 04 24             	mov    %eax,(%esp)
  801d50:	e8 28 f8 ff ff       	call   80157d <fd_lookup>
  801d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5c:	79 05                	jns    801d63 <read_map+0x26>
		return r;
  801d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d61:	eb 74                	jmp    801dd7 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  801d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d66:	8b 10                	mov    (%eax),%edx
  801d68:	a1 20 50 80 00       	mov    0x805020,%eax
  801d6d:	39 c2                	cmp    %eax,%edx
  801d6f:	74 07                	je     801d78 <read_map+0x3b>
		return -E_INVAL;
  801d71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d76:	eb 5f                	jmp    801dd7 <read_map+0x9a>
	va = fd2data(fd) + offset;
  801d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7b:	89 04 24             	mov    %eax,(%esp)
  801d7e:	e8 61 f7 ff ff       	call   8014e4 <fd2data>
  801d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d86:	01 d0                	add    %edx,%eax
  801d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  801d8b:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  801d92:	7e 07                	jle    801d9b <read_map+0x5e>
		return -E_NO_DISK;
  801d94:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801d99:	eb 3c                	jmp    801dd7 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9e:	c1 e8 16             	shr    $0x16,%eax
  801da1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801da8:	83 e0 01             	and    $0x1,%eax
  801dab:	85 c0                	test   %eax,%eax
  801dad:	74 14                	je     801dc3 <read_map+0x86>
  801daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db2:	c1 e8 0c             	shr    $0xc,%eax
  801db5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801dbc:	83 e0 01             	and    $0x1,%eax
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	75 07                	jne    801dca <read_map+0x8d>
		return -E_NO_DISK;
  801dc3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801dc8:	eb 0d                	jmp    801dd7 <read_map+0x9a>
	*blk = (void*) va;
  801dca:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd0:	89 10                	mov    %edx,(%eax)
	return 0;
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  801ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  801de2:	03 45 10             	add    0x10(%ebp),%eax
  801de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  801de8:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  801def:	76 07                	jbe    801df8 <file_write+0x1f>
		return -E_NO_DISK;
  801df1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801df6:	eb 57                	jmp    801e4f <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801e01:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e04:	73 20                	jae    801e26 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	89 04 24             	mov    %eax,(%esp)
  801e13:	e8 88 00 00 00       	call   801ea0 <file_trunc>
  801e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e1f:	79 05                	jns    801e26 <file_write+0x4d>
			return r;
  801e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e24:	eb 29                	jmp    801e4f <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	89 04 24             	mov    %eax,(%esp)
  801e2c:	e8 b3 f6 ff ff       	call   8014e4 <fd2data>
  801e31:	8b 55 14             	mov    0x14(%ebp),%edx
  801e34:	01 c2                	add    %eax,%edx
  801e36:	8b 45 10             	mov    0x10(%ebp),%eax
  801e39:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e44:	89 14 24             	mov    %edx,(%esp)
  801e47:	e8 f8 ef ff ff       	call   800e44 <memmove>
	return n;
  801e4c:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	8d 50 10             	lea    0x10(%eax),%edx
  801e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e60:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e64:	89 04 24             	mov    %eax,(%esp)
  801e67:	e8 e6 ed ff ff       	call   800c52 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e78:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  801e87:	83 f8 01             	cmp    $0x1,%eax
  801e8a:	0f 94 c0             	sete   %al
  801e8d:	0f b6 d0             	movzbl %al,%edx
  801e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e93:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  801ea6:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  801ead:	7e 0a                	jle    801eb9 <file_trunc+0x19>
		return -E_NO_DISK;
  801eaf:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801eb4:	e9 b4 00 00 00       	jmp    801f6d <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ed8:	89 04 24             	mov    %eax,(%esp)
  801edb:	e8 82 03 00 00       	call   802262 <fsipc_set_size>
  801ee0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ee3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ee7:	79 05                	jns    801eee <file_trunc+0x4e>
		return r;
  801ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eec:	eb 7f                	jmp    801f6d <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801ef7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801efa:	74 24                	je     801f20 <file_trunc+0x80>
  801efc:	c7 44 24 0c f0 2b 80 	movl   $0x802bf0,0xc(%esp)
  801f03:	00 
  801f04:	c7 44 24 08 13 2c 80 	movl   $0x802c13,0x8(%esp)
  801f0b:	00 
  801f0c:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801f13:	00 
  801f14:	c7 04 24 28 2c 80 00 	movl   $0x802c28,(%esp)
  801f1b:	e8 ec e2 ff ff       	call   80020c <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f23:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	89 04 24             	mov    %eax,(%esp)
  801f34:	e8 36 00 00 00       	call   801f6f <fmap>
  801f39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f40:	79 05                	jns    801f47 <file_trunc+0xa7>
		return r;
  801f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f45:	eb 26                	jmp    801f6d <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  801f47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f4e:	00 
  801f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	89 04 24             	mov    %eax,(%esp)
  801f63:	e8 b0 00 00 00       	call   802018 <funmap>

	return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	89 04 24             	mov    %eax,(%esp)
  801f7b:	e8 64 f5 ff ff       	call   8014e4 <fd2data>
  801f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  801f83:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8d:	03 45 ec             	add    -0x14(%ebp),%eax
  801f90:	83 e8 01             	sub    $0x1,%eax
  801f93:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f99:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9e:	f7 75 ec             	divl   -0x14(%ebp)
  801fa1:	89 d0                	mov    %edx,%eax
  801fa3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fa6:	89 d1                	mov    %edx,%ecx
  801fa8:	29 c1                	sub    %eax,%ecx
  801faa:	89 c8                	mov    %ecx,%eax
  801fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801faf:	eb 58                	jmp    802009 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fb7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fc7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fcb:	89 04 24             	mov    %eax,(%esp)
  801fce:	e8 04 02 00 00       	call   8021d7 <fsipc_map>
  801fd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fda:	79 26                	jns    802002 <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  801fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fe6:	00 
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	89 04 24             	mov    %eax,(%esp)
  801ff8:	e8 1b 00 00 00       	call   802018 <funmap>
			return r;
  801ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802000:	eb 14                	jmp    802016 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  802002:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802009:	8b 45 10             	mov    0x10(%ebp),%eax
  80200c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80200f:	77 a0                	ja     801fb1 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	89 04 24             	mov    %eax,(%esp)
  802024:	e8 bb f4 ff ff       	call   8014e4 <fd2data>
  802029:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  80202c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202f:	c1 e8 16             	shr    $0x16,%eax
  802032:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802039:	83 e0 01             	and    $0x1,%eax
  80203c:	85 c0                	test   %eax,%eax
  80203e:	75 0a                	jne    80204a <funmap+0x32>
		return 0;
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	e9 bf 00 00 00       	jmp    802109 <funmap+0xf1>

	ret = 0;
  80204a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  802051:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802058:	8b 45 10             	mov    0x10(%ebp),%eax
  80205b:	03 45 e8             	add    -0x18(%ebp),%eax
  80205e:	83 e8 01             	sub    $0x1,%eax
  802061:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802067:	ba 00 00 00 00       	mov    $0x0,%edx
  80206c:	f7 75 e8             	divl   -0x18(%ebp)
  80206f:	89 d0                	mov    %edx,%eax
  802071:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802074:	89 d1                	mov    %edx,%ecx
  802076:	29 c1                	sub    %eax,%ecx
  802078:	89 c8                	mov    %ecx,%eax
  80207a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207d:	eb 7b                	jmp    8020fa <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802085:	01 d0                	add    %edx,%eax
  802087:	c1 e8 0c             	shr    $0xc,%eax
  80208a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802091:	83 e0 01             	and    $0x1,%eax
  802094:	84 c0                	test   %al,%al
  802096:	74 5b                	je     8020f3 <funmap+0xdb>
			if (dirty
  802098:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  80209c:	74 3d                	je     8020db <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020a4:	01 d0                	add    %edx,%eax
  8020a6:	c1 e8 0c             	shr    $0xc,%eax
  8020a9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020b0:	83 e0 40             	and    $0x40,%eax
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	74 24                	je     8020db <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  8020b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020c4:	89 04 24             	mov    %eax,(%esp)
  8020c7:	e8 13 02 00 00       	call   8022df <fsipc_dirty>
  8020cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8020cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020d3:	79 06                	jns    8020db <funmap+0xc3>
				ret = r;
  8020d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e1:	01 d0                	add    %edx,%eax
  8020e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ee:	e8 22 f2 ff ff       	call   801315 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8020f3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8020fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802100:	0f 87 79 ff ff ff    	ja     80207f <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  802106:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <remove>:

// Delete a file
int
remove(const char *path)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	89 04 24             	mov    %eax,(%esp)
  802117:	e8 06 02 00 00       	call   802322 <fsipc_remove>
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  802124:	e8 56 02 00 00       	call   80237f <fsipc_sync>
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    
	...

0080212c <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  802132:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  802137:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80213e:	00 
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	89 54 24 08          	mov    %edx,0x8(%esp)
  802146:	8b 55 08             	mov    0x8(%ebp),%edx
  802149:	89 54 24 04          	mov    %edx,0x4(%esp)
  80214d:	89 04 24             	mov    %eax,(%esp)
  802150:	e8 e3 02 00 00       	call   802438 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802155:	8b 45 14             	mov    0x14(%ebp),%eax
  802158:	89 44 24 08          	mov    %eax,0x8(%esp)
  80215c:	8b 45 10             	mov    0x10(%ebp),%eax
  80215f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802163:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802166:	89 04 24             	mov    %eax,(%esp)
  802169:	e8 3e 02 00 00       	call   8023ac <ipc_recv>
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  802176:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	89 04 24             	mov    %eax,(%esp)
  802183:	e8 74 ea ff ff       	call   800bfc <strlen>
  802188:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80218d:	7e 07                	jle    802196 <fsipc_open+0x26>
		return -E_BAD_PATH;
  80218f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802194:	eb 3f                	jmp    8021d5 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	8b 55 08             	mov    0x8(%ebp),%edx
  80219c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021a0:	89 04 24             	mov    %eax,(%esp)
  8021a3:	e8 aa ea ff ff       	call   800c52 <strcpy>
	req->req_omode = omode;
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ae:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8021b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8021be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8021d0:	e8 57 ff ff ff       	call   80212c <fsipc>
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  8021dd:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ea:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f2:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  8021f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  802203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802211:	e8 16 ff ff ff       	call   80212c <fsipc>
  802216:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802219:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221d:	79 05                	jns    802224 <fsipc_map+0x4d>
		return r;
  80221f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802222:	eb 3c                	jmp    802260 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  802224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802227:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  80222c:	83 f8 05             	cmp    $0x5,%eax
  80222f:	74 2a                	je     80225b <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  802231:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802234:	8b 55 10             	mov    0x10(%ebp),%edx
  802237:	89 54 24 10          	mov    %edx,0x10(%esp)
  80223b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80223f:	c7 44 24 08 34 2c 80 	movl   $0x802c34,0x8(%esp)
  802246:	00 
  802247:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  80224e:	00 
  80224f:	c7 04 24 6a 2c 80 00 	movl   $0x802c6a,(%esp)
  802256:	e8 b1 df ff ff       	call   80020c <_panic>
	return 0;
  80225b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
  802265:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802268:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 55 08             	mov    0x8(%ebp),%edx
  802275:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802280:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802287:	00 
  802288:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80228f:	00 
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	89 44 24 04          	mov    %eax,0x4(%esp)
  802297:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80229e:	e8 89 fe ff ff       	call   80212c <fsipc>
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  8022ab:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b8:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  8022ba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022c1:	00 
  8022c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022c9:	00 
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8022d8:	e8 4f fe ff ff       	call   80212c <fsipc>
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  8022e5:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f2:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fa:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8022fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802304:	00 
  802305:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80230c:	00 
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	89 44 24 04          	mov    %eax,0x4(%esp)
  802314:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  80231b:	e8 0c fe ff ff       	call   80212c <fsipc>
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802328:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	89 04 24             	mov    %eax,(%esp)
  802335:	e8 c2 e8 ff ff       	call   800bfc <strlen>
  80233a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80233f:	7e 07                	jle    802348 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802341:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802346:	eb 35                	jmp    80237d <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 55 08             	mov    0x8(%ebp),%edx
  80234e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802352:	89 04 24             	mov    %eax,(%esp)
  802355:	e8 f8 e8 ff ff       	call   800c52 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  80235a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802361:	00 
  802362:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802369:	00 
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802371:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  802378:	e8 af fd ff ff       	call   80212c <fsipc>
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802385:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80238c:	00 
  80238d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802394:	00 
  802395:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  80239c:	00 
  80239d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8023a4:	e8 83 fd ff ff       	call   80212c <fsipc>
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    
	...

008023ac <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  8023b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023b6:	75 11                	jne    8023c9 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  8023b8:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  8023bf:	e8 db f0 ff ff       	call   80149f <sys_ipc_recv>
  8023c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c7:	eb 0e                	jmp    8023d7 <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  8023c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cc:	89 04 24             	mov    %eax,(%esp)
  8023cf:	e8 cb f0 ff ff       	call   80149f <sys_ipc_recv>
  8023d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  8023d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023db:	79 1c                	jns    8023f9 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  8023dd:	c7 44 24 08 76 2c 80 	movl   $0x802c76,0x8(%esp)
  8023e4:	00 
  8023e5:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8023ec:	00 
  8023ed:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  8023f4:	e8 13 de ff ff       	call   80020c <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  8023f9:	e8 08 ee ff ff       	call   801206 <sys_getenvid>
  8023fe:	25 ff 03 00 00       	and    $0x3ff,%eax
  802403:	c1 e0 07             	shl    $0x7,%eax
  802406:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80240b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  80240e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802412:	74 0b                	je     80241f <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	8b 50 74             	mov    0x74(%eax),%edx
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  80241f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802423:	74 0b                	je     802430 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  802425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802428:	8b 50 78             	mov    0x78(%eax),%edx
  80242b:	8b 45 10             	mov    0x10(%ebp),%eax
  80242e:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  80243e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802442:	75 26                	jne    80246a <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  802444:	8b 45 14             	mov    0x14(%ebp),%eax
  802447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80244b:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  802452:	ee 
  802453:	8b 45 0c             	mov    0xc(%ebp),%eax
  802456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	89 04 24             	mov    %eax,(%esp)
  802460:	e8 fa ef ff ff       	call   80145f <sys_ipc_try_send>
  802465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802468:	eb 23                	jmp    80248d <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  80246a:	8b 45 14             	mov    0x14(%ebp),%eax
  80246d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802471:	8b 45 10             	mov    0x10(%ebp),%eax
  802474:	89 44 24 08          	mov    %eax,0x8(%esp)
  802478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	89 04 24             	mov    %eax,(%esp)
  802485:	e8 d5 ef ff ff       	call   80145f <sys_ipc_try_send>
  80248a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  80248d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802491:	79 29                	jns    8024bc <ipc_send+0x84>
  802493:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  802497:	74 23                	je     8024bc <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024a0:	c7 44 24 08 96 2c 80 	movl   $0x802c96,0x8(%esp)
  8024a7:	00 
  8024a8:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8024af:	00 
  8024b0:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  8024b7:	e8 50 dd ff ff       	call   80020c <_panic>
	    sys_yield();
  8024bc:	e8 89 ed ff ff       	call   80124a <sys_yield>
	}while(r < 0);
  8024c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c5:	0f 88 73 ff ff ff    	js     80243e <ipc_send+0x6>
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    
  8024cd:	00 00                	add    %al,(%eax)
	...

008024d0 <__udivdi3>:
  8024d0:	83 ec 1c             	sub    $0x1c,%esp
  8024d3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8024d7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8024db:	8b 44 24 20          	mov    0x20(%esp),%eax
  8024df:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8024e3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8024e7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8024eb:	85 ff                	test   %edi,%edi
  8024ed:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8024f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f5:	89 cd                	mov    %ecx,%ebp
  8024f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fb:	75 33                	jne    802530 <__udivdi3+0x60>
  8024fd:	39 f1                	cmp    %esi,%ecx
  8024ff:	77 57                	ja     802558 <__udivdi3+0x88>
  802501:	85 c9                	test   %ecx,%ecx
  802503:	75 0b                	jne    802510 <__udivdi3+0x40>
  802505:	b8 01 00 00 00       	mov    $0x1,%eax
  80250a:	31 d2                	xor    %edx,%edx
  80250c:	f7 f1                	div    %ecx
  80250e:	89 c1                	mov    %eax,%ecx
  802510:	89 f0                	mov    %esi,%eax
  802512:	31 d2                	xor    %edx,%edx
  802514:	f7 f1                	div    %ecx
  802516:	89 c6                	mov    %eax,%esi
  802518:	8b 44 24 04          	mov    0x4(%esp),%eax
  80251c:	f7 f1                	div    %ecx
  80251e:	89 f2                	mov    %esi,%edx
  802520:	8b 74 24 10          	mov    0x10(%esp),%esi
  802524:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802528:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80252c:	83 c4 1c             	add    $0x1c,%esp
  80252f:	c3                   	ret    
  802530:	31 d2                	xor    %edx,%edx
  802532:	31 c0                	xor    %eax,%eax
  802534:	39 f7                	cmp    %esi,%edi
  802536:	77 e8                	ja     802520 <__udivdi3+0x50>
  802538:	0f bd cf             	bsr    %edi,%ecx
  80253b:	83 f1 1f             	xor    $0x1f,%ecx
  80253e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802542:	75 2c                	jne    802570 <__udivdi3+0xa0>
  802544:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802548:	76 04                	jbe    80254e <__udivdi3+0x7e>
  80254a:	39 f7                	cmp    %esi,%edi
  80254c:	73 d2                	jae    802520 <__udivdi3+0x50>
  80254e:	31 d2                	xor    %edx,%edx
  802550:	b8 01 00 00 00       	mov    $0x1,%eax
  802555:	eb c9                	jmp    802520 <__udivdi3+0x50>
  802557:	90                   	nop
  802558:	89 f2                	mov    %esi,%edx
  80255a:	f7 f1                	div    %ecx
  80255c:	31 d2                	xor    %edx,%edx
  80255e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802562:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802566:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80256a:	83 c4 1c             	add    $0x1c,%esp
  80256d:	c3                   	ret    
  80256e:	66 90                	xchg   %ax,%ax
  802570:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802575:	b8 20 00 00 00       	mov    $0x20,%eax
  80257a:	89 ea                	mov    %ebp,%edx
  80257c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802580:	d3 e7                	shl    %cl,%edi
  802582:	89 c1                	mov    %eax,%ecx
  802584:	d3 ea                	shr    %cl,%edx
  802586:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258b:	09 fa                	or     %edi,%edx
  80258d:	89 f7                	mov    %esi,%edi
  80258f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802593:	89 f2                	mov    %esi,%edx
  802595:	8b 74 24 08          	mov    0x8(%esp),%esi
  802599:	d3 e5                	shl    %cl,%ebp
  80259b:	89 c1                	mov    %eax,%ecx
  80259d:	d3 ef                	shr    %cl,%edi
  80259f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025a4:	d3 e2                	shl    %cl,%edx
  8025a6:	89 c1                	mov    %eax,%ecx
  8025a8:	d3 ee                	shr    %cl,%esi
  8025aa:	09 d6                	or     %edx,%esi
  8025ac:	89 fa                	mov    %edi,%edx
  8025ae:	89 f0                	mov    %esi,%eax
  8025b0:	f7 74 24 0c          	divl   0xc(%esp)
  8025b4:	89 d7                	mov    %edx,%edi
  8025b6:	89 c6                	mov    %eax,%esi
  8025b8:	f7 e5                	mul    %ebp
  8025ba:	39 d7                	cmp    %edx,%edi
  8025bc:	72 22                	jb     8025e0 <__udivdi3+0x110>
  8025be:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8025c2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025c7:	d3 e5                	shl    %cl,%ebp
  8025c9:	39 c5                	cmp    %eax,%ebp
  8025cb:	73 04                	jae    8025d1 <__udivdi3+0x101>
  8025cd:	39 d7                	cmp    %edx,%edi
  8025cf:	74 0f                	je     8025e0 <__udivdi3+0x110>
  8025d1:	89 f0                	mov    %esi,%eax
  8025d3:	31 d2                	xor    %edx,%edx
  8025d5:	e9 46 ff ff ff       	jmp    802520 <__udivdi3+0x50>
  8025da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025e0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025e9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025ed:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025f1:	83 c4 1c             	add    $0x1c,%esp
  8025f4:	c3                   	ret    
	...

00802600 <__umoddi3>:
  802600:	83 ec 1c             	sub    $0x1c,%esp
  802603:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802607:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80260b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80260f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802613:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802617:	8b 74 24 24          	mov    0x24(%esp),%esi
  80261b:	85 ed                	test   %ebp,%ebp
  80261d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802621:	89 44 24 08          	mov    %eax,0x8(%esp)
  802625:	89 cf                	mov    %ecx,%edi
  802627:	89 04 24             	mov    %eax,(%esp)
  80262a:	89 f2                	mov    %esi,%edx
  80262c:	75 1a                	jne    802648 <__umoddi3+0x48>
  80262e:	39 f1                	cmp    %esi,%ecx
  802630:	76 4e                	jbe    802680 <__umoddi3+0x80>
  802632:	f7 f1                	div    %ecx
  802634:	89 d0                	mov    %edx,%eax
  802636:	31 d2                	xor    %edx,%edx
  802638:	8b 74 24 10          	mov    0x10(%esp),%esi
  80263c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802640:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802644:	83 c4 1c             	add    $0x1c,%esp
  802647:	c3                   	ret    
  802648:	39 f5                	cmp    %esi,%ebp
  80264a:	77 54                	ja     8026a0 <__umoddi3+0xa0>
  80264c:	0f bd c5             	bsr    %ebp,%eax
  80264f:	83 f0 1f             	xor    $0x1f,%eax
  802652:	89 44 24 04          	mov    %eax,0x4(%esp)
  802656:	75 60                	jne    8026b8 <__umoddi3+0xb8>
  802658:	3b 0c 24             	cmp    (%esp),%ecx
  80265b:	0f 87 07 01 00 00    	ja     802768 <__umoddi3+0x168>
  802661:	89 f2                	mov    %esi,%edx
  802663:	8b 34 24             	mov    (%esp),%esi
  802666:	29 ce                	sub    %ecx,%esi
  802668:	19 ea                	sbb    %ebp,%edx
  80266a:	89 34 24             	mov    %esi,(%esp)
  80266d:	8b 04 24             	mov    (%esp),%eax
  802670:	8b 74 24 10          	mov    0x10(%esp),%esi
  802674:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802678:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80267c:	83 c4 1c             	add    $0x1c,%esp
  80267f:	c3                   	ret    
  802680:	85 c9                	test   %ecx,%ecx
  802682:	75 0b                	jne    80268f <__umoddi3+0x8f>
  802684:	b8 01 00 00 00       	mov    $0x1,%eax
  802689:	31 d2                	xor    %edx,%edx
  80268b:	f7 f1                	div    %ecx
  80268d:	89 c1                	mov    %eax,%ecx
  80268f:	89 f0                	mov    %esi,%eax
  802691:	31 d2                	xor    %edx,%edx
  802693:	f7 f1                	div    %ecx
  802695:	8b 04 24             	mov    (%esp),%eax
  802698:	f7 f1                	div    %ecx
  80269a:	eb 98                	jmp    802634 <__umoddi3+0x34>
  80269c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a0:	89 f2                	mov    %esi,%edx
  8026a2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026a6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026aa:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026ae:	83 c4 1c             	add    $0x1c,%esp
  8026b1:	c3                   	ret    
  8026b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026b8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026bd:	89 e8                	mov    %ebp,%eax
  8026bf:	bd 20 00 00 00       	mov    $0x20,%ebp
  8026c4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8026c8:	89 fa                	mov    %edi,%edx
  8026ca:	d3 e0                	shl    %cl,%eax
  8026cc:	89 e9                	mov    %ebp,%ecx
  8026ce:	d3 ea                	shr    %cl,%edx
  8026d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026d5:	09 c2                	or     %eax,%edx
  8026d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026db:	89 14 24             	mov    %edx,(%esp)
  8026de:	89 f2                	mov    %esi,%edx
  8026e0:	d3 e7                	shl    %cl,%edi
  8026e2:	89 e9                	mov    %ebp,%ecx
  8026e4:	d3 ea                	shr    %cl,%edx
  8026e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ef:	d3 e6                	shl    %cl,%esi
  8026f1:	89 e9                	mov    %ebp,%ecx
  8026f3:	d3 e8                	shr    %cl,%eax
  8026f5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026fa:	09 f0                	or     %esi,%eax
  8026fc:	8b 74 24 08          	mov    0x8(%esp),%esi
  802700:	f7 34 24             	divl   (%esp)
  802703:	d3 e6                	shl    %cl,%esi
  802705:	89 74 24 08          	mov    %esi,0x8(%esp)
  802709:	89 d6                	mov    %edx,%esi
  80270b:	f7 e7                	mul    %edi
  80270d:	39 d6                	cmp    %edx,%esi
  80270f:	89 c1                	mov    %eax,%ecx
  802711:	89 d7                	mov    %edx,%edi
  802713:	72 3f                	jb     802754 <__umoddi3+0x154>
  802715:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802719:	72 35                	jb     802750 <__umoddi3+0x150>
  80271b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80271f:	29 c8                	sub    %ecx,%eax
  802721:	19 fe                	sbb    %edi,%esi
  802723:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802728:	89 f2                	mov    %esi,%edx
  80272a:	d3 e8                	shr    %cl,%eax
  80272c:	89 e9                	mov    %ebp,%ecx
  80272e:	d3 e2                	shl    %cl,%edx
  802730:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802735:	09 d0                	or     %edx,%eax
  802737:	89 f2                	mov    %esi,%edx
  802739:	d3 ea                	shr    %cl,%edx
  80273b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80273f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802743:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802747:	83 c4 1c             	add    $0x1c,%esp
  80274a:	c3                   	ret    
  80274b:	90                   	nop
  80274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802750:	39 d6                	cmp    %edx,%esi
  802752:	75 c7                	jne    80271b <__umoddi3+0x11b>
  802754:	89 d7                	mov    %edx,%edi
  802756:	89 c1                	mov    %eax,%ecx
  802758:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80275c:	1b 3c 24             	sbb    (%esp),%edi
  80275f:	eb ba                	jmp    80271b <__umoddi3+0x11b>
  802761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802768:	39 f5                	cmp    %esi,%ebp
  80276a:	0f 82 f1 fe ff ff    	jb     802661 <__umoddi3+0x61>
  802770:	e9 f8 fe ff ff       	jmp    80266d <__umoddi3+0x6d>
