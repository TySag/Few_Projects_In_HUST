
obj/user/init:     file format elf32-i386


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
  80002c:	e8 33 01 00 00       	call   800164 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 10             	sub    $0x10,%esp
	int i, tot = 0;
  80003a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i = 0; i < n; i++)
  800041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800048:	eb 17                	jmp    800061 <sum+0x2d>
		tot ^= i * s[i];
  80004a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80004d:	03 45 08             	add    0x8(%ebp),%eax
  800050:	0f b6 00             	movzbl (%eax),%eax
  800053:	0f be c0             	movsbl %al,%eax
  800056:	0f af 45 fc          	imul   -0x4(%ebp),%eax
  80005a:	31 45 f8             	xor    %eax,-0x8(%ebp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80005d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800061:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800064:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800067:	7c e1                	jl     80004a <sum+0x16>
		tot ^= i * s[i];
	return tot;
  800069:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80006c:	c9                   	leave  
  80006d:	c3                   	ret    

0080006e <umain>:
		
void
umain(int argc, char **argv)
{
  80006e:	55                   	push   %ebp
  80006f:	89 e5                	mov    %esp,%ebp
  800071:	83 ec 28             	sub    $0x28,%esp
	int i, r, x, want;

	cprintf("init: running\n");
  800074:	c7 04 24 40 27 80 00 	movl   $0x802740,(%esp)
  80007b:	e8 08 02 00 00       	call   800288 <cprintf>

	want = 0xf989e;
  800080:	c7 45 f0 9e 98 0f 00 	movl   $0xf989e,-0x10(%ebp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  800087:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008e:	00 
  80008f:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800096:	e8 99 ff ff ff       	call   800034 <sum>
  80009b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80009e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000a4:	74 1c                	je     8000c2 <umain+0x54>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b4:	c7 04 24 50 27 80 00 	movl   $0x802750,(%esp)
  8000bb:	e8 c8 01 00 00       	call   800288 <cprintf>
  8000c0:	eb 0c                	jmp    8000ce <umain+0x60>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000c2:	c7 04 24 89 27 80 00 	movl   $0x802789,(%esp)
  8000c9:	e8 ba 01 00 00       	call   800288 <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ce:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000d5:	00 
  8000d6:	c7 04 24 a0 67 80 00 	movl   $0x8067a0,(%esp)
  8000dd:	e8 52 ff ff ff       	call   800034 <sum>
  8000e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8000e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000e9:	74 15                	je     800100 <umain+0x92>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f2:	c7 04 24 a0 27 80 00 	movl   $0x8027a0,(%esp)
  8000f9:	e8 8a 01 00 00       	call   800288 <cprintf>
  8000fe:	eb 0c                	jmp    80010c <umain+0x9e>
	else
		cprintf("init: bss seems okay\n");
  800100:	c7 04 24 cf 27 80 00 	movl   $0x8027cf,(%esp)
  800107:	e8 7c 01 00 00       	call   800288 <cprintf>

	cprintf("init: args:");
  80010c:	c7 04 24 e5 27 80 00 	movl   $0x8027e5,(%esp)
  800113:	e8 70 01 00 00       	call   800288 <cprintf>
	for (i = 0; i < argc; i++)
  800118:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80011f:	eb 1f                	jmp    800140 <umain+0xd2>
		cprintf(" '%s'", argv[i]);
  800121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800124:	c1 e0 02             	shl    $0x2,%eax
  800127:	03 45 0c             	add    0xc(%ebp),%eax
  80012a:	8b 00                	mov    (%eax),%eax
  80012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800130:	c7 04 24 f1 27 80 00 	movl   $0x8027f1,(%esp)
  800137:	e8 4c 01 00 00       	call   800288 <cprintf>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
	else
		cprintf("init: bss seems okay\n");

	cprintf("init: args:");
	for (i = 0; i < argc; i++)
  80013c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800143:	3b 45 08             	cmp    0x8(%ebp),%eax
  800146:	7c d9                	jl     800121 <umain+0xb3>
		cprintf(" '%s'", argv[i]);
	cprintf("\n");
  800148:	c7 04 24 f7 27 80 00 	movl   $0x8027f7,(%esp)
  80014f:	e8 34 01 00 00       	call   800288 <cprintf>

	cprintf("init: exiting\n");
  800154:	c7 04 24 f9 27 80 00 	movl   $0x8027f9,(%esp)
  80015b:	e8 28 01 00 00       	call   800288 <cprintf>
}
  800160:	c9                   	leave  
  800161:	c3                   	ret    
	...

00800164 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  80016a:	e8 df 0f 00 00       	call   80114e <sys_getenvid>
  80016f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800174:	c1 e0 07             	shl    $0x7,%eax
  800177:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017c:	a3 10 7f 80 00       	mov    %eax,0x807f10
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800181:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800185:	7e 0a                	jle    800191 <libmain+0x2d>
		binaryname = argv[0];
  800187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	a3 70 67 80 00       	mov    %eax,0x806770

	// call user main routine
	umain(argc, argv);
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	89 44 24 04          	mov    %eax,0x4(%esp)
  800198:	8b 45 08             	mov    0x8(%ebp),%eax
  80019b:	89 04 24             	mov    %eax,(%esp)
  80019e:	e8 cb fe ff ff       	call   80006e <umain>

	// exit gracefully
	exit();
  8001a3:	e8 04 00 00 00       	call   8001ac <exit>
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    
	...

008001ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b2:	e8 6b 14 00 00       	call   801622 <close_all>
	sys_env_destroy(0);
  8001b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001be:	e8 48 0f 00 00       	call   80110b <sys_env_destroy>
}
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    
  8001c5:	00 00                	add    %al,(%eax)
	...

008001c8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d6:	89 d1                	mov    %edx,%ecx
  8001d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001db:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  8001df:	8d 50 01             	lea    0x1(%eax),%edx
  8001e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e5:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  8001e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ea:	8b 00                	mov    (%eax),%eax
  8001ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f1:	75 20                	jne    800213 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  8001f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f6:	8b 00                	mov    (%eax),%eax
  8001f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fb:	83 c2 08             	add    $0x8,%edx
  8001fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800202:	89 14 24             	mov    %edx,(%esp)
  800205:	e8 7b 0e 00 00       	call   801085 <sys_cputs>
		b->idx = 0;
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800213:	8b 45 0c             	mov    0xc(%ebp),%eax
  800216:	8b 40 04             	mov    0x4(%eax),%eax
  800219:	8d 50 01             	lea    0x1(%eax),%edx
  80021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80022d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800234:	00 00 00 
	b.cnt = 0;
  800237:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80023e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800241:	8b 45 0c             	mov    0xc(%ebp),%eax
  800244:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800248:	8b 45 08             	mov    0x8(%ebp),%eax
  80024b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80024f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800255:	89 44 24 04          	mov    %eax,0x4(%esp)
  800259:	c7 04 24 c8 01 80 00 	movl   $0x8001c8,(%esp)
  800260:	e8 f7 01 00 00       	call   80045c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800265:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80026b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800275:	83 c0 08             	add    $0x8,%eax
  800278:	89 04 24             	mov    %eax,(%esp)
  80027b:	e8 05 0e 00 00       	call   801085 <sys_cputs>

	return b.cnt;
  800280:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800291:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800294:	8b 45 08             	mov    0x8(%ebp),%eax
  800297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80029a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80029e:	89 04 24             	mov    %eax,(%esp)
  8002a1:	e8 7e ff ff ff       	call   800224 <vcprintf>
  8002a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ac:	c9                   	leave  
  8002ad:	c3                   	ret    
	...

008002b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 34             	sub    $0x34,%esp
  8002b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8002c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ce:	77 72                	ja     800342 <printnum+0x92>
  8002d0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d3:	72 05                	jb     8002da <printnum+0x2a>
  8002d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002d8:	77 68                	ja     800342 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002da:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002dd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e0:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002f6:	89 04 24             	mov    %eax,(%esp)
  8002f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002fd:	e8 8e 21 00 00       	call   802490 <__udivdi3>
  800302:	8b 4d 20             	mov    0x20(%ebp),%ecx
  800305:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  800309:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  80030d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800310:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800314:	89 44 24 08          	mov    %eax,0x8(%esp)
  800318:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80031c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800323:	8b 45 08             	mov    0x8(%ebp),%eax
  800326:	89 04 24             	mov    %eax,(%esp)
  800329:	e8 82 ff ff ff       	call   8002b0 <printnum>
  80032e:	eb 1c                	jmp    80034c <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
  800333:	89 44 24 04          	mov    %eax,0x4(%esp)
  800337:	8b 45 20             	mov    0x20(%ebp),%eax
  80033a:	89 04 24             	mov    %eax,(%esp)
  80033d:	8b 45 08             	mov    0x8(%ebp),%eax
  800340:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800342:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800346:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80034a:	7f e4                	jg     800330 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80034f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800357:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80035a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80035e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800362:	89 04 24             	mov    %eax,(%esp)
  800365:	89 54 24 04          	mov    %edx,0x4(%esp)
  800369:	e8 52 22 00 00       	call   8025c0 <__umoddi3>
  80036e:	05 7c 29 80 00       	add    $0x80297c,%eax
  800373:	0f b6 00             	movzbl (%eax),%eax
  800376:	0f be c0             	movsbl %al,%eax
  800379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800380:	89 04 24             	mov    %eax,(%esp)
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	ff d0                	call   *%eax
}
  800388:	83 c4 34             	add    $0x34,%esp
  80038b:	5b                   	pop    %ebx
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800391:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800395:	7e 1c                	jle    8003b3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	8b 00                	mov    (%eax),%eax
  80039c:	8d 50 08             	lea    0x8(%eax),%edx
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	89 10                	mov    %edx,(%eax)
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	83 e8 08             	sub    $0x8,%eax
  8003ac:	8b 50 04             	mov    0x4(%eax),%edx
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	eb 40                	jmp    8003f3 <getuint+0x65>
	else if (lflag)
  8003b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003b7:	74 1e                	je     8003d7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	8d 50 04             	lea    0x4(%eax),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	89 10                	mov    %edx,(%eax)
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	83 e8 04             	sub    $0x4,%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d5:	eb 1c                	jmp    8003f3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	8d 50 04             	lea    0x4(%eax),%edx
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	89 10                	mov    %edx,(%eax)
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	83 e8 04             	sub    $0x4,%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f3:	5d                   	pop    %ebp
  8003f4:	c3                   	ret    

008003f5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003fc:	7e 1c                	jle    80041a <getint+0x25>
		return va_arg(*ap, long long);
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	8d 50 08             	lea    0x8(%eax),%edx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	89 10                	mov    %edx,(%eax)
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	83 e8 08             	sub    $0x8,%eax
  800413:	8b 50 04             	mov    0x4(%eax),%edx
  800416:	8b 00                	mov    (%eax),%eax
  800418:	eb 40                	jmp    80045a <getint+0x65>
	else if (lflag)
  80041a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80041e:	74 1e                	je     80043e <getint+0x49>
		return va_arg(*ap, long);
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	8b 00                	mov    (%eax),%eax
  800425:	8d 50 04             	lea    0x4(%eax),%edx
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	89 10                	mov    %edx,(%eax)
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	83 e8 04             	sub    $0x4,%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	89 c2                	mov    %eax,%edx
  800439:	c1 fa 1f             	sar    $0x1f,%edx
  80043c:	eb 1c                	jmp    80045a <getint+0x65>
	else
		return va_arg(*ap, int);
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	8d 50 04             	lea    0x4(%eax),%edx
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	89 10                	mov    %edx,(%eax)
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	83 e8 04             	sub    $0x4,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	89 c2                	mov    %eax,%edx
  800457:	c1 fa 1f             	sar    $0x1f,%edx
}
  80045a:	5d                   	pop    %ebp
  80045b:	c3                   	ret    

0080045c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	56                   	push   %esi
  800460:	53                   	push   %ebx
  800461:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800464:	eb 17                	jmp    80047d <vprintfmt+0x21>
			if (ch == '\0')
  800466:	85 db                	test   %ebx,%ebx
  800468:	0f 84 d1 05 00 00    	je     800a3f <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  80046e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800471:	89 44 24 04          	mov    %eax,0x4(%esp)
  800475:	89 1c 24             	mov    %ebx,(%esp)
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80047d:	8b 45 10             	mov    0x10(%ebp),%eax
  800480:	0f b6 00             	movzbl (%eax),%eax
  800483:	0f b6 d8             	movzbl %al,%ebx
  800486:	83 fb 25             	cmp    $0x25,%ebx
  800489:	0f 95 c0             	setne  %al
  80048c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800490:	84 c0                	test   %al,%al
  800492:	75 d2                	jne    800466 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800494:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800498:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80049f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004b4:	eb 04                	jmp    8004ba <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8004b6:	90                   	nop
  8004b7:	eb 01                	jmp    8004ba <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8004b9:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bd:	0f b6 00             	movzbl (%eax),%eax
  8004c0:	0f b6 d8             	movzbl %al,%ebx
  8004c3:	89 d8                	mov    %ebx,%eax
  8004c5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8004c9:	83 e8 23             	sub    $0x23,%eax
  8004cc:	83 f8 55             	cmp    $0x55,%eax
  8004cf:	0f 87 39 05 00 00    	ja     800a0e <vprintfmt+0x5b2>
  8004d5:	8b 04 85 c4 29 80 00 	mov    0x8029c4(,%eax,4),%eax
  8004dc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004de:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004e2:	eb d6                	jmp    8004ba <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004e4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004e8:	eb d0                	jmp    8004ba <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004f4:	89 d0                	mov    %edx,%eax
  8004f6:	c1 e0 02             	shl    $0x2,%eax
  8004f9:	01 d0                	add    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d8                	add    %ebx,%eax
  8004ff:	83 e8 30             	sub    $0x30,%eax
  800502:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800505:	8b 45 10             	mov    0x10(%ebp),%eax
  800508:	0f b6 00             	movzbl (%eax),%eax
  80050b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80050e:	83 fb 2f             	cmp    $0x2f,%ebx
  800511:	7e 43                	jle    800556 <vprintfmt+0xfa>
  800513:	83 fb 39             	cmp    $0x39,%ebx
  800516:	7f 3e                	jg     800556 <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800518:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80051c:	eb d3                	jmp    8004f1 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	83 c0 04             	add    $0x4,%eax
  800524:	89 45 14             	mov    %eax,0x14(%ebp)
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	83 e8 04             	sub    $0x4,%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800532:	eb 23                	jmp    800557 <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  800534:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800538:	0f 89 78 ff ff ff    	jns    8004b6 <vprintfmt+0x5a>
				width = 0;
  80053e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800545:	e9 6c ff ff ff       	jmp    8004b6 <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  80054a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800551:	e9 64 ff ff ff       	jmp    8004ba <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800556:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800557:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80055b:	0f 89 58 ff ff ff    	jns    8004b9 <vprintfmt+0x5d>
				width = precision, precision = -1;
  800561:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800567:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80056e:	e9 46 ff ff ff       	jmp    8004b9 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800573:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  800577:	e9 3e ff ff ff       	jmp    8004ba <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	83 c0 04             	add    $0x4,%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	83 e8 04             	sub    $0x4,%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800590:	89 54 24 04          	mov    %edx,0x4(%esp)
  800594:	89 04 24             	mov    %eax,(%esp)
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	ff d0                	call   *%eax
			break;
  80059c:	e9 98 04 00 00       	jmp    800a39 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  8005a1:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  8005a8:	00 
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b0:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8005b3:	89 04 24             	mov    %eax,(%esp)
  8005b6:	e8 d1 07 00 00       	call   800d8c <memmove>
            sel_c[3] = '\0';
  8005bb:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  8005bf:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  8005c3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8005c7:	3c 2f                	cmp    $0x2f,%al
  8005c9:	7e 4c                	jle    800617 <vprintfmt+0x1bb>
  8005cb:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8005cf:	3c 39                	cmp    $0x39,%al
  8005d1:	7f 44                	jg     800617 <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  8005d3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8005d7:	0f be d0             	movsbl %al,%edx
  8005da:	89 d0                	mov    %edx,%eax
  8005dc:	c1 e0 02             	shl    $0x2,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8005e9:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  8005ed:	0f be c0             	movsbl %al,%eax
  8005f0:	01 c2                	add    %eax,%edx
  8005f2:	89 d0                	mov    %edx,%eax
  8005f4:	c1 e0 02             	shl    $0x2,%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	01 c0                	add    %eax,%eax
  8005fb:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800601:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  800605:	0f be c0             	movsbl %al,%eax
  800608:	01 d0                	add    %edx,%eax
  80060a:	83 e8 30             	sub    $0x30,%eax
  80060d:	a3 74 67 80 00       	mov    %eax,0x806774
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800612:	e9 22 04 00 00       	jmp    800a39 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  800617:	c7 44 24 04 8d 29 80 	movl   $0x80298d,0x4(%esp)
  80061e:	00 
  80061f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800622:	89 04 24             	mov    %eax,(%esp)
  800625:	e8 36 06 00 00       	call   800c60 <strcmp>
  80062a:	85 c0                	test   %eax,%eax
  80062c:	75 0f                	jne    80063d <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  80062e:	c7 05 74 67 80 00 07 	movl   $0x7,0x806774
  800635:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800638:	e9 fc 03 00 00       	jmp    800a39 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  80063d:	c7 44 24 04 91 29 80 	movl   $0x802991,0x4(%esp)
  800644:	00 
  800645:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800648:	89 04 24             	mov    %eax,(%esp)
  80064b:	e8 10 06 00 00       	call   800c60 <strcmp>
  800650:	85 c0                	test   %eax,%eax
  800652:	75 0f                	jne    800663 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  800654:	c7 05 74 67 80 00 01 	movl   $0x1,0x806774
  80065b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80065e:	e9 d6 03 00 00       	jmp    800a39 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  800663:	c7 44 24 04 95 29 80 	movl   $0x802995,0x4(%esp)
  80066a:	00 
  80066b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80066e:	89 04 24             	mov    %eax,(%esp)
  800671:	e8 ea 05 00 00       	call   800c60 <strcmp>
  800676:	85 c0                	test   %eax,%eax
  800678:	75 0f                	jne    800689 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  80067a:	c7 05 74 67 80 00 02 	movl   $0x2,0x806774
  800681:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800684:	e9 b0 03 00 00       	jmp    800a39 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  800689:	c7 44 24 04 99 29 80 	movl   $0x802999,0x4(%esp)
  800690:	00 
  800691:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800694:	89 04 24             	mov    %eax,(%esp)
  800697:	e8 c4 05 00 00       	call   800c60 <strcmp>
  80069c:	85 c0                	test   %eax,%eax
  80069e:	75 0f                	jne    8006af <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  8006a0:	c7 05 74 67 80 00 04 	movl   $0x4,0x806774
  8006a7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006aa:	e9 8a 03 00 00       	jmp    800a39 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  8006af:	c7 44 24 04 9d 29 80 	movl   $0x80299d,0x4(%esp)
  8006b6:	00 
  8006b7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006ba:	89 04 24             	mov    %eax,(%esp)
  8006bd:	e8 9e 05 00 00       	call   800c60 <strcmp>
  8006c2:	85 c0                	test   %eax,%eax
  8006c4:	75 0f                	jne    8006d5 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  8006c6:	c7 05 74 67 80 00 08 	movl   $0x8,0x806774
  8006cd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006d0:	e9 64 03 00 00       	jmp    800a39 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  8006d5:	c7 44 24 04 a1 29 80 	movl   $0x8029a1,0x4(%esp)
  8006dc:	00 
  8006dd:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006e0:	89 04 24             	mov    %eax,(%esp)
  8006e3:	e8 78 05 00 00       	call   800c60 <strcmp>
  8006e8:	85 c0                	test   %eax,%eax
  8006ea:	75 0f                	jne    8006fb <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  8006ec:	c7 05 74 67 80 00 0f 	movl   $0xf,0x806774
  8006f3:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006f6:	e9 3e 03 00 00       	jmp    800a39 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  8006fb:	c7 44 24 04 a5 29 80 	movl   $0x8029a5,0x4(%esp)
  800702:	00 
  800703:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800706:	89 04 24             	mov    %eax,(%esp)
  800709:	e8 52 05 00 00       	call   800c60 <strcmp>
  80070e:	85 c0                	test   %eax,%eax
  800710:	75 0f                	jne    800721 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  800712:	c7 05 74 67 80 00 0c 	movl   $0xc,0x806774
  800719:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80071c:	e9 18 03 00 00       	jmp    800a39 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  800721:	c7 44 24 04 a9 29 80 	movl   $0x8029a9,0x4(%esp)
  800728:	00 
  800729:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80072c:	89 04 24             	mov    %eax,(%esp)
  80072f:	e8 2c 05 00 00       	call   800c60 <strcmp>
  800734:	85 c0                	test   %eax,%eax
  800736:	75 0f                	jne    800747 <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  800738:	c7 05 74 67 80 00 06 	movl   $0x6,0x806774
  80073f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800742:	e9 f2 02 00 00       	jmp    800a39 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  800747:	c7 44 24 04 ad 29 80 	movl   $0x8029ad,0x4(%esp)
  80074e:	00 
  80074f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800752:	89 04 24             	mov    %eax,(%esp)
  800755:	e8 06 05 00 00       	call   800c60 <strcmp>
  80075a:	85 c0                	test   %eax,%eax
  80075c:	75 0f                	jne    80076d <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  80075e:	c7 05 74 67 80 00 0b 	movl   $0xb,0x806774
  800765:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800768:	e9 cc 02 00 00       	jmp    800a39 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  80076d:	c7 05 74 67 80 00 07 	movl   $0x7,0x806774
  800774:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800777:	e9 bd 02 00 00       	jmp    800a39 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	83 c0 04             	add    $0x4,%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	83 e8 04             	sub    $0x4,%eax
  80078b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80078d:	85 db                	test   %ebx,%ebx
  80078f:	79 02                	jns    800793 <vprintfmt+0x337>
				err = -err;
  800791:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800793:	83 fb 0e             	cmp    $0xe,%ebx
  800796:	7f 0b                	jg     8007a3 <vprintfmt+0x347>
  800798:	8b 34 9d 40 29 80 00 	mov    0x802940(,%ebx,4),%esi
  80079f:	85 f6                	test   %esi,%esi
  8007a1:	75 23                	jne    8007c6 <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  8007a3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007a7:	c7 44 24 08 b1 29 80 	movl   $0x8029b1,0x8(%esp)
  8007ae:	00 
  8007af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 04 24             	mov    %eax,(%esp)
  8007bc:	e8 86 02 00 00       	call   800a47 <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007c1:	e9 73 02 00 00       	jmp    800a39 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007c6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007ca:	c7 44 24 08 ba 29 80 	movl   $0x8029ba,0x8(%esp)
  8007d1:	00 
  8007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	89 04 24             	mov    %eax,(%esp)
  8007df:	e8 63 02 00 00       	call   800a47 <printfmt>
			break;
  8007e4:	e9 50 02 00 00       	jmp    800a39 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	83 c0 04             	add    $0x4,%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	83 e8 04             	sub    $0x4,%eax
  8007f8:	8b 30                	mov    (%eax),%esi
  8007fa:	85 f6                	test   %esi,%esi
  8007fc:	75 05                	jne    800803 <vprintfmt+0x3a7>
				p = "(null)";
  8007fe:	be bd 29 80 00       	mov    $0x8029bd,%esi
			if (width > 0 && padc != '-')
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	7e 73                	jle    80087c <vprintfmt+0x420>
  800809:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80080d:	74 6d                	je     80087c <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  80080f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800812:	89 44 24 04          	mov    %eax,0x4(%esp)
  800816:	89 34 24             	mov    %esi,(%esp)
  800819:	e8 4c 03 00 00       	call   800b6a <strnlen>
  80081e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800821:	eb 17                	jmp    80083a <vprintfmt+0x3de>
					putch(padc, putdat);
  800823:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80082e:	89 04 24             	mov    %eax,(%esp)
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800836:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80083a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083e:	7f e3                	jg     800823 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800840:	eb 3a                	jmp    80087c <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  800842:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800846:	74 1f                	je     800867 <vprintfmt+0x40b>
  800848:	83 fb 1f             	cmp    $0x1f,%ebx
  80084b:	7e 05                	jle    800852 <vprintfmt+0x3f6>
  80084d:	83 fb 7e             	cmp    $0x7e,%ebx
  800850:	7e 15                	jle    800867 <vprintfmt+0x40b>
					putch('?', putdat);
  800852:	8b 45 0c             	mov    0xc(%ebp),%eax
  800855:	89 44 24 04          	mov    %eax,0x4(%esp)
  800859:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	ff d0                	call   *%eax
  800865:	eb 0f                	jmp    800876 <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  800867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086e:	89 1c 24             	mov    %ebx,(%esp)
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800876:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80087a:	eb 01                	jmp    80087d <vprintfmt+0x421>
  80087c:	90                   	nop
  80087d:	0f b6 06             	movzbl (%esi),%eax
  800880:	0f be d8             	movsbl %al,%ebx
  800883:	85 db                	test   %ebx,%ebx
  800885:	0f 95 c0             	setne  %al
  800888:	83 c6 01             	add    $0x1,%esi
  80088b:	84 c0                	test   %al,%al
  80088d:	74 29                	je     8008b8 <vprintfmt+0x45c>
  80088f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800893:	78 ad                	js     800842 <vprintfmt+0x3e6>
  800895:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800899:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80089d:	79 a3                	jns    800842 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089f:	eb 17                	jmp    8008b8 <vprintfmt+0x45c>
				putch(' ', putdat);
  8008a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008b4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bc:	7f e3                	jg     8008a1 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  8008be:	e9 76 01 00 00       	jmp    800a39 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8008cd:	89 04 24             	mov    %eax,(%esp)
  8008d0:	e8 20 fb ff ff       	call   8003f5 <getint>
  8008d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e1:	85 d2                	test   %edx,%edx
  8008e3:	79 26                	jns    80090b <vprintfmt+0x4af>
				putch('-', putdat);
  8008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ec:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	ff d0                	call   *%eax
				num = -(long long) num;
  8008f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fe:	f7 d8                	neg    %eax
  800900:	83 d2 00             	adc    $0x0,%edx
  800903:	f7 da                	neg    %edx
  800905:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800908:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80090b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800912:	e9 ae 00 00 00       	jmp    8009c5 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800917:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091e:	8d 45 14             	lea    0x14(%ebp),%eax
  800921:	89 04 24             	mov    %eax,(%esp)
  800924:	e8 65 fa ff ff       	call   80038e <getuint>
  800929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80092f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800936:	e9 8a 00 00 00       	jmp    8009c5 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  80093b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80093e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800942:	8d 45 14             	lea    0x14(%ebp),%eax
  800945:	89 04 24             	mov    %eax,(%esp)
  800948:	e8 41 fa ff ff       	call   80038e <getuint>
  80094d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800950:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  800953:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  80095a:	eb 69                	jmp    8009c5 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800963:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
			putch('x', putdat);
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	89 44 24 04          	mov    %eax,0x4(%esp)
  800976:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800982:	8b 45 14             	mov    0x14(%ebp),%eax
  800985:	83 c0 04             	add    $0x4,%eax
  800988:	89 45 14             	mov    %eax,0x14(%ebp)
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	83 e8 04             	sub    $0x4,%eax
  800991:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80099d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009a4:	eb 1f                	jmp    8009c5 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ad:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b0:	89 04 24             	mov    %eax,(%esp)
  8009b3:	e8 d6 f9 ff ff       	call   80038e <getuint>
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009be:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009c5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cc:	89 54 24 18          	mov    %edx,0x18(%esp)
  8009d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009d3:	89 54 24 14          	mov    %edx,0x14(%esp)
  8009d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	89 04 24             	mov    %eax,(%esp)
  8009f6:	e8 b5 f8 ff ff       	call   8002b0 <printnum>
			break;
  8009fb:	eb 3c                	jmp    800a39 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a04:	89 1c 24             	mov    %ebx,(%esp)
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
			break;
  800a0c:	eb 2b                	jmp    800a39 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a15:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a21:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a25:	eb 04                	jmp    800a2b <vprintfmt+0x5cf>
  800a27:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2e:	83 e8 01             	sub    $0x1,%eax
  800a31:	0f b6 00             	movzbl (%eax),%eax
  800a34:	3c 25                	cmp    $0x25,%al
  800a36:	75 ef                	jne    800a27 <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800a38:	90                   	nop
		}
	}
  800a39:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3a:	e9 3e fa ff ff       	jmp    80047d <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800a3f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a40:	83 c4 50             	add    $0x50,%esp
  800a43:	5b                   	pop    %ebx
  800a44:	5e                   	pop    %esi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800a4d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a50:	83 c0 04             	add    $0x4,%eax
  800a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a56:	8b 45 10             	mov    0x10(%ebp),%eax
  800a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a60:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	89 04 24             	mov    %eax,(%esp)
  800a71:	e8 e6 f9 ff ff       	call   80045c <vprintfmt>
	va_end(ap);
}
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8b 40 08             	mov    0x8(%eax),%eax
  800a81:	8d 50 01             	lea    0x1(%eax),%edx
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	8b 10                	mov    (%eax),%edx
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	8b 40 04             	mov    0x4(%eax),%eax
  800a95:	39 c2                	cmp    %eax,%edx
  800a97:	73 12                	jae    800aab <sprintputch+0x33>
		*b->buf++ = ch;
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa1:	88 10                	mov    %dl,(%eax)
  800aa3:	8d 50 01             	lea    0x1(%eax),%edx
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	89 10                	mov    %edx,(%eax)
}
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abc:	83 e8 01             	sub    $0x1,%eax
  800abf:	03 45 08             	add    0x8(%ebp),%eax
  800ac2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800acc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ad0:	74 06                	je     800ad8 <vsnprintf+0x2b>
  800ad2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad6:	7f 07                	jg     800adf <vsnprintf+0x32>
		return -E_INVAL;
  800ad8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800add:	eb 2a                	jmp    800b09 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af4:	c7 04 24 78 0a 80 00 	movl   $0x800a78,(%esp)
  800afb:	e8 5c f9 ff ff       	call   80045c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b03:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

00800b0b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b11:	8d 45 10             	lea    0x10(%ebp),%eax
  800b14:	83 c0 04             	add    $0x4,%eax
  800b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b20:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b24:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 04 24             	mov    %eax,(%esp)
  800b35:	e8 73 ff ff ff       	call   800aad <vsnprintf>
  800b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b40:	c9                   	leave  
  800b41:	c3                   	ret    
	...

00800b44 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b51:	eb 08                	jmp    800b5b <strlen+0x17>
		n++;
  800b53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	0f b6 00             	movzbl (%eax),%eax
  800b61:	84 c0                	test   %al,%al
  800b63:	75 ee                	jne    800b53 <strlen+0xf>
		n++;
	return n;
  800b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b77:	eb 0c                	jmp    800b85 <strnlen+0x1b>
		n++;
  800b79:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b81:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b89:	74 0a                	je     800b95 <strnlen+0x2b>
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	0f b6 00             	movzbl (%eax),%eax
  800b91:	84 c0                	test   %al,%al
  800b93:	75 e4                	jne    800b79 <strnlen+0xf>
		n++;
	return n;
  800b95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ba6:	90                   	nop
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	0f b6 10             	movzbl (%eax),%edx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	88 10                	mov    %dl,(%eax)
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	0f b6 00             	movzbl (%eax),%eax
  800bb8:	84 c0                	test   %al,%al
  800bba:	0f 95 c0             	setne  %al
  800bbd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bc1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800bc5:	84 c0                	test   %al,%al
  800bc7:	75 de                	jne    800ba7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be1:	eb 21                	jmp    800c04 <strncpy+0x36>
		*dst++ = *src;
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	0f b6 10             	movzbl (%eax),%edx
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	88 10                	mov    %dl,(%eax)
  800bee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf5:	0f b6 00             	movzbl (%eax),%eax
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 04                	je     800c00 <strncpy+0x32>
			src++;
  800bfc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c00:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c07:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c0a:	72 d7                	jb     800be3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c21:	74 2f                	je     800c52 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800c23:	eb 13                	jmp    800c38 <strlcpy+0x27>
			*dst++ = *src++;
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	0f b6 10             	movzbl (%eax),%edx
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	88 10                	mov    %dl,(%eax)
  800c30:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c34:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c38:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c40:	74 0a                	je     800c4c <strlcpy+0x3b>
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	0f b6 00             	movzbl (%eax),%eax
  800c48:	84 c0                	test   %al,%al
  800c4a:	75 d9                	jne    800c25 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c58:	89 d1                	mov    %edx,%ecx
  800c5a:	29 c1                	sub    %eax,%ecx
  800c5c:	89 c8                	mov    %ecx,%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c63:	eb 08                	jmp    800c6d <strcmp+0xd>
		p++, q++;
  800c65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c69:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	0f b6 00             	movzbl (%eax),%eax
  800c73:	84 c0                	test   %al,%al
  800c75:	74 10                	je     800c87 <strcmp+0x27>
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	0f b6 10             	movzbl (%eax),%edx
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	0f b6 00             	movzbl (%eax),%eax
  800c83:	38 c2                	cmp    %al,%dl
  800c85:	74 de                	je     800c65 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	0f b6 00             	movzbl (%eax),%eax
  800c8d:	0f b6 d0             	movzbl %al,%edx
  800c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c93:	0f b6 00             	movzbl (%eax),%eax
  800c96:	0f b6 c0             	movzbl %al,%eax
  800c99:	89 d1                	mov    %edx,%ecx
  800c9b:	29 c1                	sub    %eax,%ecx
  800c9d:	89 c8                	mov    %ecx,%eax
}
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ca4:	eb 0c                	jmp    800cb2 <strncmp+0x11>
		n--, p++, q++;
  800ca6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800caa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 1a                	je     800cd2 <strncmp+0x31>
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	0f b6 00             	movzbl (%eax),%eax
  800cbe:	84 c0                	test   %al,%al
  800cc0:	74 10                	je     800cd2 <strncmp+0x31>
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	0f b6 10             	movzbl (%eax),%edx
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	0f b6 00             	movzbl (%eax),%eax
  800cce:	38 c2                	cmp    %al,%dl
  800cd0:	74 d4                	je     800ca6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd6:	75 07                	jne    800cdf <strncmp+0x3e>
		return 0;
  800cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdd:	eb 18                	jmp    800cf7 <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	0f b6 00             	movzbl (%eax),%eax
  800ce5:	0f b6 d0             	movzbl %al,%edx
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	0f b6 00             	movzbl (%eax),%eax
  800cee:	0f b6 c0             	movzbl %al,%eax
  800cf1:	89 d1                	mov    %edx,%ecx
  800cf3:	29 c1                	sub    %eax,%ecx
  800cf5:	89 c8                	mov    %ecx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 04             	sub    $0x4,%esp
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d05:	eb 14                	jmp    800d1b <strchr+0x22>
		if (*s == c)
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	0f b6 00             	movzbl (%eax),%eax
  800d0d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d10:	75 05                	jne    800d17 <strchr+0x1e>
			return (char *) s;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	eb 13                	jmp    800d2a <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d17:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	0f b6 00             	movzbl (%eax),%eax
  800d21:	84 c0                	test   %al,%al
  800d23:	75 e2                	jne    800d07 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 04             	sub    $0x4,%esp
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d38:	eb 0f                	jmp    800d49 <strfind+0x1d>
		if (*s == c)
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	0f b6 00             	movzbl (%eax),%eax
  800d40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d43:	74 10                	je     800d55 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	0f b6 00             	movzbl (%eax),%eax
  800d4f:	84 c0                	test   %al,%al
  800d51:	75 e7                	jne    800d3a <strfind+0xe>
  800d53:	eb 01                	jmp    800d56 <strfind+0x2a>
		if (*s == c)
			break;
  800d55:	90                   	nop
	return (char *) s;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d59:	c9                   	leave  
  800d5a:	c3                   	ret    

00800d5b <memset>:


void *
memset(void *v, int c, size_t n)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d6d:	eb 0e                	jmp    800d7d <memset+0x22>
		*p++ = c;
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	89 c2                	mov    %eax,%edx
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d77:	88 10                	mov    %dl,(%eax)
  800d79:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d7d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800d81:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d85:	79 e8                	jns    800d6f <memset+0x14>
		*p++ = c;

	return v;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800da4:	73 54                	jae    800dfa <memmove+0x6e>
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dac:	01 d0                	add    %edx,%eax
  800dae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800db1:	76 47                	jbe    800dfa <memmove+0x6e>
		s += n;
  800db3:	8b 45 10             	mov    0x10(%ebp),%eax
  800db6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800dbf:	eb 13                	jmp    800dd4 <memmove+0x48>
			*--d = *--s;
  800dc1:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800dc5:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	0f b6 10             	movzbl (%eax),%edx
  800dcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd8:	0f 95 c0             	setne  %al
  800ddb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 de                	jne    800dc1 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800de3:	eb 25                	jmp    800e0a <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de8:	0f b6 10             	movzbl (%eax),%edx
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dee:	88 10                	mov    %dl,(%eax)
  800df0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800df4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800df8:	eb 01                	jmp    800dfb <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dfa:	90                   	nop
  800dfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dff:	0f 95 c0             	setne  %al
  800e02:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e06:	84 c0                	test   %al,%al
  800e08:	75 db                	jne    800de5 <memmove+0x59>
			*d++ = *s++;

	return dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	89 04 24             	mov    %eax,(%esp)
  800e29:	e8 5e ff ff ff       	call   800d8c <memmove>
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e42:	eb 32                	jmp    800e76 <memcmp+0x46>
		if (*s1 != *s2)
  800e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e47:	0f b6 10             	movzbl (%eax),%edx
  800e4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4d:	0f b6 00             	movzbl (%eax),%eax
  800e50:	38 c2                	cmp    %al,%dl
  800e52:	74 1a                	je     800e6e <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	0f b6 00             	movzbl (%eax),%eax
  800e5a:	0f b6 d0             	movzbl %al,%edx
  800e5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e60:	0f b6 00             	movzbl (%eax),%eax
  800e63:	0f b6 c0             	movzbl %al,%eax
  800e66:	89 d1                	mov    %edx,%ecx
  800e68:	29 c1                	sub    %eax,%ecx
  800e6a:	89 c8                	mov    %ecx,%eax
  800e6c:	eb 1c                	jmp    800e8a <memcmp+0x5a>
		s1++, s2++;
  800e6e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e72:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7a:	0f 95 c0             	setne  %al
  800e7d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e81:	84 c0                	test   %al,%al
  800e83:	75 bf                	jne    800e44 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	01 d0                	add    %edx,%eax
  800e9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e9d:	eb 11                	jmp    800eb0 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	0f b6 10             	movzbl (%eax),%edx
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	38 c2                	cmp    %al,%dl
  800eaa:	74 0e                	je     800eba <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eb6:	72 e7                	jb     800e9f <memfind+0x13>
  800eb8:	eb 01                	jmp    800ebb <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eba:	90                   	nop
	return (void *) s;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ec6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ecd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed4:	eb 04                	jmp    800eda <strtol+0x1a>
		s++;
  800ed6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	0f b6 00             	movzbl (%eax),%eax
  800ee0:	3c 20                	cmp    $0x20,%al
  800ee2:	74 f2                	je     800ed6 <strtol+0x16>
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	0f b6 00             	movzbl (%eax),%eax
  800eea:	3c 09                	cmp    $0x9,%al
  800eec:	74 e8                	je     800ed6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	0f b6 00             	movzbl (%eax),%eax
  800ef4:	3c 2b                	cmp    $0x2b,%al
  800ef6:	75 06                	jne    800efe <strtol+0x3e>
		s++;
  800ef8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800efc:	eb 15                	jmp    800f13 <strtol+0x53>
	else if (*s == '-')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	0f b6 00             	movzbl (%eax),%eax
  800f04:	3c 2d                	cmp    $0x2d,%al
  800f06:	75 0b                	jne    800f13 <strtol+0x53>
		s++, neg = 1;
  800f08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f0c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 06                	je     800f1f <strtol+0x5f>
  800f19:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f1d:	75 24                	jne    800f43 <strtol+0x83>
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	0f b6 00             	movzbl (%eax),%eax
  800f25:	3c 30                	cmp    $0x30,%al
  800f27:	75 1a                	jne    800f43 <strtol+0x83>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	83 c0 01             	add    $0x1,%eax
  800f2f:	0f b6 00             	movzbl (%eax),%eax
  800f32:	3c 78                	cmp    $0x78,%al
  800f34:	75 0d                	jne    800f43 <strtol+0x83>
		s += 2, base = 16;
  800f36:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f3a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f41:	eb 2a                	jmp    800f6d <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	75 17                	jne    800f60 <strtol+0xa0>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	0f b6 00             	movzbl (%eax),%eax
  800f4f:	3c 30                	cmp    $0x30,%al
  800f51:	75 0d                	jne    800f60 <strtol+0xa0>
		s++, base = 8;
  800f53:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f57:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f5e:	eb 0d                	jmp    800f6d <strtol+0xad>
	else if (base == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strtol+0xad>
		base = 10;
  800f66:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	0f b6 00             	movzbl (%eax),%eax
  800f73:	3c 2f                	cmp    $0x2f,%al
  800f75:	7e 1b                	jle    800f92 <strtol+0xd2>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	0f b6 00             	movzbl (%eax),%eax
  800f7d:	3c 39                	cmp    $0x39,%al
  800f7f:	7f 11                	jg     800f92 <strtol+0xd2>
			dig = *s - '0';
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	0f b6 00             	movzbl (%eax),%eax
  800f87:	0f be c0             	movsbl %al,%eax
  800f8a:	83 e8 30             	sub    $0x30,%eax
  800f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f90:	eb 48                	jmp    800fda <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	0f b6 00             	movzbl (%eax),%eax
  800f98:	3c 60                	cmp    $0x60,%al
  800f9a:	7e 1b                	jle    800fb7 <strtol+0xf7>
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	0f b6 00             	movzbl (%eax),%eax
  800fa2:	3c 7a                	cmp    $0x7a,%al
  800fa4:	7f 11                	jg     800fb7 <strtol+0xf7>
			dig = *s - 'a' + 10;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	0f b6 00             	movzbl (%eax),%eax
  800fac:	0f be c0             	movsbl %al,%eax
  800faf:	83 e8 57             	sub    $0x57,%eax
  800fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb5:	eb 23                	jmp    800fda <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	0f b6 00             	movzbl (%eax),%eax
  800fbd:	3c 40                	cmp    $0x40,%al
  800fbf:	7e 38                	jle    800ff9 <strtol+0x139>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	0f b6 00             	movzbl (%eax),%eax
  800fc7:	3c 5a                	cmp    $0x5a,%al
  800fc9:	7f 2e                	jg     800ff9 <strtol+0x139>
			dig = *s - 'A' + 10;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	0f b6 00             	movzbl (%eax),%eax
  800fd1:	0f be c0             	movsbl %al,%eax
  800fd4:	83 e8 37             	sub    $0x37,%eax
  800fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fe0:	7d 16                	jge    800ff8 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  800fe2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fed:	03 45 f4             	add    -0xc(%ebp),%eax
  800ff0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ff3:	e9 75 ff ff ff       	jmp    800f6d <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ff8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	74 08                	je     801007 <strtol+0x147>
		*endptr = (char *) s;
  800fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801002:	8b 55 08             	mov    0x8(%ebp),%edx
  801005:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801007:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80100b:	74 07                	je     801014 <strtol+0x154>
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	f7 d8                	neg    %eax
  801012:	eb 03                	jmp    801017 <strtol+0x157>
  801014:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    
  801019:	00 00                	add    %al,(%eax)
	...

0080101c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
  801022:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80102b:	8b 55 10             	mov    0x10(%ebp),%edx
  80102e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801031:	8b 5d 18             	mov    0x18(%ebp),%ebx
  801034:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  801037:	8b 75 20             	mov    0x20(%ebp),%esi
  80103a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80103d:	cd 30                	int    $0x30
  80103f:	89 c3                	mov    %eax,%ebx
  801041:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801044:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801048:	74 30                	je     80107a <syscall+0x5e>
  80104a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80104e:	7e 2a                	jle    80107a <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  801050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801053:	89 44 24 10          	mov    %eax,0x10(%esp)
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80105e:	c7 44 24 08 1c 2b 80 	movl   $0x802b1c,0x8(%esp)
  801065:	00 
  801066:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80106d:	00 
  80106e:	c7 04 24 39 2b 80 00 	movl   $0x802b39,(%esp)
  801075:	e8 7a 12 00 00       	call   8022f4 <_panic>

	return ret;
  80107a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80107d:	83 c4 4c             	add    $0x4c,%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801095:	00 
  801096:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80109d:	00 
  80109e:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8010a5:	00 
  8010a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8010ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010b8:	00 
  8010b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010c0:	e8 57 ff ff ff       	call   80101c <syscall>
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8010cd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8010d4:	00 
  8010d5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8010dc:	00 
  8010dd:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8010e4:	00 
  8010e5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8010ec:	00 
  8010ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010f4:	00 
  8010f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010fc:	00 
  8010fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801104:	e8 13 ff ff ff       	call   80101c <syscall>
}
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80111b:	00 
  80111c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801123:	00 
  801124:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80112b:	00 
  80112c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801133:	00 
  801134:	89 44 24 08          	mov    %eax,0x8(%esp)
  801138:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80113f:	00 
  801140:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  801147:	e8 d0 fe ff ff       	call   80101c <syscall>
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801154:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80115b:	00 
  80115c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801163:	00 
  801164:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80116b:	00 
  80116c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801173:	00 
  801174:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80117b:	00 
  80117c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801183:	00 
  801184:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80118b:	e8 8c fe ff ff       	call   80101c <syscall>
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <sys_yield>:

void
sys_yield(void)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801198:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80119f:	00 
  8011a0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8011a7:	00 
  8011a8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011af:	00 
  8011b0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011b7:	00 
  8011b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011bf:	00 
  8011c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011c7:	00 
  8011c8:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8011cf:	e8 48 fe ff ff       	call   80101c <syscall>
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8011dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8011ec:	00 
  8011ed:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8011f4:	00 
  8011f5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8011f9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801201:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801208:	00 
  801209:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  801210:	e8 07 fe ff ff       	call   80101c <syscall>
}
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	56                   	push   %esi
  80121b:	53                   	push   %ebx
  80121c:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80121f:	8b 75 18             	mov    0x18(%ebp),%esi
  801222:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801225:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	89 74 24 18          	mov    %esi,0x18(%esp)
  801232:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  801236:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80123a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80123e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801242:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801249:	00 
  80124a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  801251:	e8 c6 fd ff ff       	call   80101c <syscall>
}
  801256:	83 c4 20             	add    $0x20,%esp
  801259:	5b                   	pop    %ebx
  80125a:	5e                   	pop    %esi
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    

0080125d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  801263:	8b 55 0c             	mov    0xc(%ebp),%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801270:	00 
  801271:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801278:	00 
  801279:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801280:	00 
  801281:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801285:	89 44 24 08          	mov    %eax,0x8(%esp)
  801289:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801290:	00 
  801291:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  801298:	e8 7f fd ff ff       	call   80101c <syscall>
}
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  8012a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012b2:	00 
  8012b3:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012ba:	00 
  8012bb:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012c2:	00 
  8012c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012d2:	00 
  8012d3:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  8012da:	e8 3d fd ff ff       	call   80101c <syscall>
}
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8012e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012f4:	00 
  8012f5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012fc:	00 
  8012fd:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801304:	00 
  801305:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801309:	89 44 24 08          	mov    %eax,0x8(%esp)
  80130d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801314:	00 
  801315:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  80131c:	e8 fb fc ff ff       	call   80101c <syscall>
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  801329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801336:	00 
  801337:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80133e:	00 
  80133f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801346:	00 
  801347:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80134b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80134f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801356:	00 
  801357:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  80135e:	e8 b9 fc ff ff       	call   80101c <syscall>
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80136b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801378:	00 
  801379:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801380:	00 
  801381:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801388:	00 
  801389:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80138d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801391:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801398:	00 
  801399:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  8013a0:	e8 77 fc ff ff       	call   80101c <syscall>
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8013ad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013b0:	8b 55 10             	mov    0x10(%ebp),%edx
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013bd:	00 
  8013be:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8013c2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8013d8:	00 
  8013d9:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  8013e0:	e8 37 fc ff ff       	call   80101c <syscall>
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013f7:	00 
  8013f8:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013ff:	00 
  801400:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801407:	00 
  801408:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80140f:	00 
  801410:	89 44 24 08          	mov    %eax,0x8(%esp)
  801414:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80141b:	00 
  80141c:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  801423:	e8 f4 fb ff ff       	call   80101c <syscall>
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    
	...

0080142c <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	89 04 24             	mov    %eax,(%esp)
  801438:	e8 0a 00 00 00       	call   801447 <fd2num>
  80143d:	05 40 03 00 00       	add    $0x340,%eax
  801442:	c1 e0 16             	shl    $0x16,%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	05 00 00 40 30       	add    $0x30400000,%eax
  801452:	c1 e8 0c             	shr    $0xc,%eax
}
  801455:	5d                   	pop    %ebp
  801456:	c3                   	ret    

00801457 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  80145d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801464:	eb 49                	jmp    8014af <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  801466:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801469:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  80146e:	c1 e0 0c             	shl    $0xc,%eax
  801471:	89 c2                	mov    %eax,%edx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8b 00                	mov    (%eax),%eax
  80147d:	c1 e8 16             	shr    $0x16,%eax
  801480:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801487:	83 e0 01             	and    $0x1,%eax
  80148a:	85 c0                	test   %eax,%eax
  80148c:	74 16                	je     8014a4 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8b 00                	mov    (%eax),%eax
  801493:	c1 e8 0c             	shr    $0xc,%eax
  801496:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80149d:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	75 07                	jne    8014ab <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a9:	eb 18                	jmp    8014c3 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  8014ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8014af:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  8014b3:	7e b1                	jle    801466 <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  8014be:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  8014cb:	c7 44 24 08 48 2b 80 	movl   $0x802b48,0x8(%esp)
  8014d2:	00 
  8014d3:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8014da:	00 
  8014db:	c7 04 24 62 2b 80 00 	movl   $0x802b62,(%esp)
  8014e2:	e8 0d 0e 00 00       	call   8022f4 <_panic>

008014e7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	89 04 24             	mov    %eax,(%esp)
  8014f3:	e8 4f ff ff ff       	call   801447 <fd2num>
  8014f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8014fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014ff:	89 04 24             	mov    %eax,(%esp)
  801502:	e8 be ff ff ff       	call   8014c5 <fd_lookup>
  801507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80150e:	78 08                	js     801518 <fd_close+0x31>
	    || fd != fd2)
  801510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801513:	39 45 08             	cmp    %eax,0x8(%ebp)
  801516:	74 12                	je     80152a <fd_close+0x43>
		return (must_exist ? r : 0);
  801518:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151c:	74 05                	je     801523 <fd_close+0x3c>
  80151e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801521:	eb 05                	jmp    801528 <fd_close+0x41>
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	eb 44                	jmp    80156e <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8b 00                	mov    (%eax),%eax
  80152f:	8d 55 ec             	lea    -0x14(%ebp),%edx
  801532:	89 54 24 04          	mov    %edx,0x4(%esp)
  801536:	89 04 24             	mov    %eax,(%esp)
  801539:	e8 32 00 00 00       	call   801570 <dev_lookup>
  80153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801545:	78 11                	js     801558 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  801547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154a:	8b 50 10             	mov    0x10(%eax),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	89 04 24             	mov    %eax,(%esp)
  801553:	ff d2                	call   *%edx
  801555:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801566:	e8 f2 fc ff ff       	call   80125d <sys_page_unmap>
	return r;
  80156b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  801576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80157d:	eb 2b                	jmp    8015aa <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  80157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801582:	8b 04 85 78 67 80 00 	mov    0x806778(,%eax,4),%eax
  801589:	8b 00                	mov    (%eax),%eax
  80158b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80158e:	75 16                	jne    8015a6 <dev_lookup+0x36>
			*dev = devtab[i];
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	8b 14 85 78 67 80 00 	mov    0x806778(,%eax,4),%edx
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	89 10                	mov    %edx,(%eax)
			return 0;
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a4:	eb 3f                	jmp    8015e5 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	8b 04 85 78 67 80 00 	mov    0x806778(,%eax,4),%eax
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	75 c7                	jne    80157f <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8015b8:	a1 10 7f 80 00       	mov    0x807f10,%eax
  8015bd:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cb:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  8015d2:	e8 b1 ec ff ff       	call   800288 <cprintf>
	*dev = 0;
  8015d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <close>:

int
close(int fdnum)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	89 04 24             	mov    %eax,(%esp)
  8015fa:	e8 c6 fe ff ff       	call   8014c5 <fd_lookup>
  8015ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801606:	79 05                	jns    80160d <close+0x26>
		return r;
  801608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160b:	eb 13                	jmp    801620 <close+0x39>
	else
		return fd_close(fd, 1);
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801617:	00 
  801618:	89 04 24             	mov    %eax,(%esp)
  80161b:	e8 c7 fe ff ff       	call   8014e7 <fd_close>
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <close_all>:

void
close_all(void)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801628:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80162f:	eb 0f                	jmp    801640 <close_all+0x1e>
		close(i);
  801631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801634:	89 04 24             	mov    %eax,(%esp)
  801637:	e8 ab ff ff ff       	call   8015e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80163c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801640:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  801644:	7e eb                	jle    801631 <close_all+0xf>
		close(i);
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80164e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801651:	89 44 24 04          	mov    %eax,0x4(%esp)
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	89 04 24             	mov    %eax,(%esp)
  80165b:	e8 65 fe ff ff       	call   8014c5 <fd_lookup>
  801660:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801663:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801667:	79 08                	jns    801671 <dup+0x29>
		return r;
  801669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166c:	e9 54 01 00 00       	jmp    8017c5 <dup+0x17d>
	close(newfdnum);
  801671:	8b 45 0c             	mov    0xc(%ebp),%eax
  801674:	89 04 24             	mov    %eax,(%esp)
  801677:	e8 6b ff ff ff       	call   8015e7 <close>

	newfd = INDEX2FD(newfdnum);
  80167c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167f:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801684:	c1 e0 0c             	shl    $0xc,%eax
  801687:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  80168a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80168d:	89 04 24             	mov    %eax,(%esp)
  801690:	e8 97 fd ff ff       	call   80142c <fd2data>
  801695:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801698:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169b:	89 04 24             	mov    %eax,(%esp)
  80169e:	e8 89 fd ff ff       	call   80142c <fd2data>
  8016a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8016a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016a9:	c1 e8 0c             	shr    $0xc,%eax
  8016ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016b3:	89 c2                	mov    %eax,%edx
  8016b5:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016be:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016c5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016d0:	00 
  8016d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016dc:	e8 36 fb ff ff       	call   801217 <sys_page_map>
  8016e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016e8:	0f 88 8e 00 00 00    	js     80177c <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  8016ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f1:	c1 e8 16             	shr    $0x16,%eax
  8016f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	74 78                	je     801777 <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8016ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801706:	eb 66                	jmp    80176e <dup+0x126>
			pte = vpt[VPN(ova + i)];
  801708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170b:	03 45 e8             	add    -0x18(%ebp),%eax
  80170e:	c1 e8 0c             	shr    $0xc,%eax
  801711:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801718:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  80171b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80171e:	83 e0 01             	and    $0x1,%eax
  801721:	84 c0                	test   %al,%al
  801723:	74 42                	je     801767 <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801725:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801728:	89 c1                	mov    %eax,%ecx
  80172a:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801733:	89 c2                	mov    %eax,%edx
  801735:	03 55 e4             	add    -0x1c(%ebp),%edx
  801738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173b:	03 45 e8             	add    -0x18(%ebp),%eax
  80173e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801742:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801746:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80174d:	00 
  80174e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801752:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801759:	e8 b9 fa ff ff       	call   801217 <sys_page_map>
  80175e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801761:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801765:	78 18                	js     80177f <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801767:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80176e:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801775:	7e 91                	jle    801708 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	eb 49                	jmp    8017c5 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  80177c:	90                   	nop
  80177d:	eb 01                	jmp    801780 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  80177f:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801783:	89 44 24 04          	mov    %eax,0x4(%esp)
  801787:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80178e:	e8 ca fa ff ff       	call   80125d <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801793:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80179a:	eb 1d                	jmp    8017b9 <dup+0x171>
		sys_page_unmap(0, nva + i);
  80179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179f:	03 45 e4             	add    -0x1c(%ebp),%eax
  8017a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017ad:	e8 ab fa ff ff       	call   80125d <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8017b2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8017b9:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  8017c0:	7e da                	jle    80179c <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  8017c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 04 24             	mov    %eax,(%esp)
  8017da:	e8 e6 fc ff ff       	call   8014c5 <fd_lookup>
  8017df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e6:	78 1d                	js     801805 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017eb:	8b 00                	mov    (%eax),%eax
  8017ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8017f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017f4:	89 04 24             	mov    %eax,(%esp)
  8017f7:	e8 74 fd ff ff       	call   801570 <dev_lookup>
  8017fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801803:	79 05                	jns    80180a <read+0x43>
		return r;
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	eb 75                	jmp    80187f <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80180a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180d:	8b 40 08             	mov    0x8(%eax),%eax
  801810:	83 e0 03             	and    $0x3,%eax
  801813:	83 f8 01             	cmp    $0x1,%eax
  801816:	75 26                	jne    80183e <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801818:	a1 10 7f 80 00       	mov    0x807f10,%eax
  80181d:	8b 40 4c             	mov    0x4c(%eax),%eax
  801820:	8b 55 08             	mov    0x8(%ebp),%edx
  801823:	89 54 24 08          	mov    %edx,0x8(%esp)
  801827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182b:	c7 04 24 8b 2b 80 00 	movl   $0x802b8b,(%esp)
  801832:	e8 51 ea ff ff       	call   800288 <cprintf>
		return -E_INVAL;
  801837:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183c:	eb 41                	jmp    80187f <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	8b 48 08             	mov    0x8(%eax),%ecx
  801844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801847:	8b 50 04             	mov    0x4(%eax),%edx
  80184a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801851:	8b 55 10             	mov    0x10(%ebp),%edx
  801854:	89 54 24 08          	mov    %edx,0x8(%esp)
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80185f:	89 04 24             	mov    %eax,(%esp)
  801862:	ff d1                	call   *%ecx
  801864:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  801867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80186b:	78 0f                	js     80187c <read+0xb5>
		fd->fd_offset += r;
  80186d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801870:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801873:	8b 52 04             	mov    0x4(%edx),%edx
  801876:	03 55 f4             	add    -0xc(%ebp),%edx
  801879:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  80187c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801887:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80188e:	eb 3b                	jmp    8018cb <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801893:	8b 55 10             	mov    0x10(%ebp),%edx
  801896:	29 c2                	sub    %eax,%edx
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189b:	03 45 0c             	add    0xc(%ebp),%eax
  80189e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	89 04 24             	mov    %eax,(%esp)
  8018ac:	e8 16 ff ff ff       	call   8017c7 <read>
  8018b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  8018b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018b8:	79 05                	jns    8018bf <readn+0x3e>
			return m;
  8018ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bd:	eb 1a                	jmp    8018d9 <readn+0x58>
		if (m == 0)
  8018bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018c3:	74 10                	je     8018d5 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c8:	01 45 f4             	add    %eax,-0xc(%ebp)
  8018cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ce:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018d1:	72 bd                	jb     801890 <readn+0xf>
  8018d3:	eb 01                	jmp    8018d6 <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8018d5:	90                   	nop
	}
	return tot;
  8018d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	89 04 24             	mov    %eax,(%esp)
  8018ee:	e8 d2 fb ff ff       	call   8014c5 <fd_lookup>
  8018f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018fa:	78 1d                	js     801919 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801904:	89 54 24 04          	mov    %edx,0x4(%esp)
  801908:	89 04 24             	mov    %eax,(%esp)
  80190b:	e8 60 fc ff ff       	call   801570 <dev_lookup>
  801910:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801913:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801917:	79 05                	jns    80191e <write+0x43>
		return r;
  801919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191c:	eb 74                	jmp    801992 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80191e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801921:	8b 40 08             	mov    0x8(%eax),%eax
  801924:	83 e0 03             	and    $0x3,%eax
  801927:	85 c0                	test   %eax,%eax
  801929:	75 26                	jne    801951 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  80192b:	a1 10 7f 80 00       	mov    0x807f10,%eax
  801930:	8b 40 4c             	mov    0x4c(%eax),%eax
  801933:	8b 55 08             	mov    0x8(%ebp),%edx
  801936:	89 54 24 08          	mov    %edx,0x8(%esp)
  80193a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193e:	c7 04 24 a7 2b 80 00 	movl   $0x802ba7,(%esp)
  801945:	e8 3e e9 ff ff       	call   800288 <cprintf>
		return -E_INVAL;
  80194a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80194f:	eb 41                	jmp    801992 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	8b 48 0c             	mov    0xc(%eax),%ecx
  801957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195a:	8b 50 04             	mov    0x4(%eax),%edx
  80195d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801960:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801964:	8b 55 10             	mov    0x10(%ebp),%edx
  801967:	89 54 24 08          	mov    %edx,0x8(%esp)
  80196b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	ff d1                	call   *%ecx
  801977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  80197a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80197e:	7e 0f                	jle    80198f <write+0xb4>
		fd->fd_offset += r;
  801980:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801983:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801986:	8b 52 04             	mov    0x4(%edx),%edx
  801989:	03 55 f4             	add    -0xc(%ebp),%edx
  80198c:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  80198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <seek>:

int
seek(int fdnum, off_t offset)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80199a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80199d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	89 04 24             	mov    %eax,(%esp)
  8019a7:	e8 19 fb ff ff       	call   8014c5 <fd_lookup>
  8019ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019b3:	79 05                	jns    8019ba <seek+0x26>
		return r;
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	eb 0e                	jmp    8019c8 <seek+0x34>
	fd->fd_offset = offset;
  8019ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	89 04 24             	mov    %eax,(%esp)
  8019dd:	e8 e3 fa ff ff       	call   8014c5 <fd_lookup>
  8019e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019e9:	78 1d                	js     801a08 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ee:	8b 00                	mov    (%eax),%eax
  8019f0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8019f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019f7:	89 04 24             	mov    %eax,(%esp)
  8019fa:	e8 71 fb ff ff       	call   801570 <dev_lookup>
  8019ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a06:	79 05                	jns    801a0d <ftruncate+0x43>
		return r;
  801a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0b:	eb 48                	jmp    801a55 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a10:	8b 40 08             	mov    0x8(%eax),%eax
  801a13:	83 e0 03             	and    $0x3,%eax
  801a16:	85 c0                	test   %eax,%eax
  801a18:	75 26                	jne    801a40 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801a1a:	a1 10 7f 80 00       	mov    0x807f10,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a1f:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a22:	8b 55 08             	mov    0x8(%ebp),%edx
  801a25:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2d:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  801a34:	e8 4f e8 ff ff       	call   800288 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801a39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a3e:	eb 15                	jmp    801a55 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a43:	8b 48 1c             	mov    0x1c(%eax),%ecx
  801a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a50:	89 04 24             	mov    %eax,(%esp)
  801a53:	ff d1                	call   *%ecx
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	89 04 24             	mov    %eax,(%esp)
  801a6a:	e8 56 fa ff ff       	call   8014c5 <fd_lookup>
  801a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a76:	78 1d                	js     801a95 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7b:	8b 00                	mov    (%eax),%eax
  801a7d:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801a80:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a84:	89 04 24             	mov    %eax,(%esp)
  801a87:	e8 e4 fa ff ff       	call   801570 <dev_lookup>
  801a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a93:	79 05                	jns    801a9a <fstat+0x43>
		return r;
  801a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a98:	eb 41                	jmp    801adb <fstat+0x84>
	stat->st_name[0] = 0;
  801a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9d:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801aaa:	00 00 00 
	stat->st_isdir = 0;
  801aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  801ab7:	00 00 00 
	stat->st_dev = dev;
  801aba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac0:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  801ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac9:	8b 48 14             	mov    0x14(%eax),%ecx
  801acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ad6:	89 04 24             	mov    %eax,(%esp)
  801ad9:	ff d1                	call   *%ecx
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ae3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801aea:	00 
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	89 04 24             	mov    %eax,(%esp)
  801af1:	e8 36 00 00 00       	call   801b2c <open>
  801af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801af9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801afd:	79 05                	jns    801b04 <stat+0x27>
		return fd;
  801aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b02:	eb 23                	jmp    801b27 <stat+0x4a>
	r = fstat(fd, stat);
  801b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0e:	89 04 24             	mov    %eax,(%esp)
  801b11:	e8 41 ff ff ff       	call   801a57 <fstat>
  801b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  801b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1c:	89 04 24             	mov    %eax,(%esp)
  801b1f:	e8 c3 fa ff ff       	call   8015e7 <close>
	return r;
  801b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    
  801b29:	00 00                	add    %al,(%eax)
	...

00801b2c <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801b32:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b35:	89 04 24             	mov    %eax,(%esp)
  801b38:	e8 1a f9 ff ff       	call   801457 <fd_alloc>
  801b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b44:	79 05                	jns    801b4b <open+0x1f>
  801b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b49:	eb 73                	jmp    801bbe <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  801b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	89 04 24             	mov    %eax,(%esp)
  801b5f:	e8 54 05 00 00       	call   8020b8 <fsipc_open>
  801b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b6b:	79 05                	jns    801b72 <open+0x46>
  801b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b70:	eb 4c                	jmp    801bbe <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b75:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b89:	00 
  801b8a:	89 04 24             	mov    %eax,(%esp)
  801b8d:	e8 25 03 00 00       	call   801eb7 <fmap>
  801b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b99:	79 18                	jns    801bb3 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  801b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ba5:	00 
  801ba6:	89 04 24             	mov    %eax,(%esp)
  801ba9:	e8 39 f9 ff ff       	call   8014e7 <fd_close>
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	eb 0b                	jmp    801bbe <open+0x92>
	return fd2num(fd);
  801bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb6:	89 04 24             	mov    %eax,(%esp)
  801bb9:	e8 89 f8 ff ff       	call   801447 <fd2num>
	//panic("open() unimplemented!");
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801bcf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801bd6:	00 
  801bd7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bde:	00 
  801bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	89 04 24             	mov    %eax,(%esp)
  801be9:	e8 72 03 00 00       	call   801f60 <funmap>
  801bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bf5:	79 05                	jns    801bfc <file_close+0x3c>
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	eb 21                	jmp    801c1d <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	8b 40 0c             	mov    0xc(%eax),%eax
  801c02:	89 04 24             	mov    %eax,(%esp)
  801c05:	e8 e3 05 00 00       	call   8021ed <fsipc_close>
  801c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c11:	79 05                	jns    801c18 <file_close+0x58>
  801c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c16:	eb 05                	jmp    801c1d <file_close+0x5d>
	return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801c31:	8b 45 14             	mov    0x14(%ebp),%eax
  801c34:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c37:	76 07                	jbe    801c40 <file_read+0x21>
		return 0;
  801c39:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3e:	eb 43                	jmp    801c83 <file_read+0x64>
	if (offset + n > size)
  801c40:	8b 45 14             	mov    0x14(%ebp),%eax
  801c43:	03 45 10             	add    0x10(%ebp),%eax
  801c46:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c49:	76 0f                	jbe    801c5a <file_read+0x3b>
		n = size - offset;
  801c4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c51:	89 d1                	mov    %edx,%ecx
  801c53:	29 c1                	sub    %eax,%ecx
  801c55:	89 c8                	mov    %ecx,%eax
  801c57:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	89 04 24             	mov    %eax,(%esp)
  801c60:	e8 c7 f7 ff ff       	call   80142c <fd2data>
  801c65:	8b 55 14             	mov    0x14(%ebp),%edx
  801c68:	01 c2                	add    %eax,%edx
  801c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c71:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c78:	89 04 24             	mov    %eax,(%esp)
  801c7b:	e8 0c f1 ff ff       	call   800d8c <memmove>
	return n;
  801c80:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	89 04 24             	mov    %eax,(%esp)
  801c98:	e8 28 f8 ff ff       	call   8014c5 <fd_lookup>
  801c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ca4:	79 05                	jns    801cab <read_map+0x26>
		return r;
  801ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca9:	eb 74                	jmp    801d1f <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  801cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cae:	8b 10                	mov    (%eax),%edx
  801cb0:	a1 80 67 80 00       	mov    0x806780,%eax
  801cb5:	39 c2                	cmp    %eax,%edx
  801cb7:	74 07                	je     801cc0 <read_map+0x3b>
		return -E_INVAL;
  801cb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cbe:	eb 5f                	jmp    801d1f <read_map+0x9a>
	va = fd2data(fd) + offset;
  801cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc3:	89 04 24             	mov    %eax,(%esp)
  801cc6:	e8 61 f7 ff ff       	call   80142c <fd2data>
  801ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  801cd3:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  801cda:	7e 07                	jle    801ce3 <read_map+0x5e>
		return -E_NO_DISK;
  801cdc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801ce1:	eb 3c                	jmp    801d1f <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce6:	c1 e8 16             	shr    $0x16,%eax
  801ce9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801cf0:	83 e0 01             	and    $0x1,%eax
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	74 14                	je     801d0b <read_map+0x86>
  801cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfa:	c1 e8 0c             	shr    $0xc,%eax
  801cfd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d04:	83 e0 01             	and    $0x1,%eax
  801d07:	85 c0                	test   %eax,%eax
  801d09:	75 07                	jne    801d12 <read_map+0x8d>
		return -E_NO_DISK;
  801d0b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801d10:	eb 0d                	jmp    801d1f <read_map+0x9a>
	*blk = (void*) va;
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d18:	89 10                	mov    %edx,(%eax)
	return 0;
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  801d27:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2a:	03 45 10             	add    0x10(%ebp),%eax
  801d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  801d30:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  801d37:	76 07                	jbe    801d40 <file_write+0x1f>
		return -E_NO_DISK;
  801d39:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801d3e:	eb 57                	jmp    801d97 <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801d49:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d4c:	73 20                	jae    801d6e <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	89 04 24             	mov    %eax,(%esp)
  801d5b:	e8 88 00 00 00       	call   801de8 <file_trunc>
  801d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d67:	79 05                	jns    801d6e <file_write+0x4d>
			return r;
  801d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6c:	eb 29                	jmp    801d97 <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	89 04 24             	mov    %eax,(%esp)
  801d74:	e8 b3 f6 ff ff       	call   80142c <fd2data>
  801d79:	8b 55 14             	mov    0x14(%ebp),%edx
  801d7c:	01 c2                	add    %eax,%edx
  801d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d81:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8c:	89 14 24             	mov    %edx,(%esp)
  801d8f:	e8 f8 ef ff ff       	call   800d8c <memmove>
	return n;
  801d94:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	8d 50 10             	lea    0x10(%eax),%edx
  801da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dac:	89 04 24             	mov    %eax,(%esp)
  801daf:	e8 e6 ed ff ff       	call   800b9a <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc0:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  801dcf:	83 f8 01             	cmp    $0x1,%eax
  801dd2:	0f 94 c0             	sete   %al
  801dd5:	0f b6 d0             	movzbl %al,%edx
  801dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddb:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  801dee:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  801df5:	7e 0a                	jle    801e01 <file_trunc+0x19>
		return -E_NO_DISK;
  801df7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801dfc:	e9 b4 00 00 00       	jmp    801eb5 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	8b 40 0c             	mov    0xc(%eax),%eax
  801e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e20:	89 04 24             	mov    %eax,(%esp)
  801e23:	e8 82 03 00 00       	call   8021aa <fsipc_set_size>
  801e28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e2f:	79 05                	jns    801e36 <file_trunc+0x4e>
		return r;
  801e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e34:	eb 7f                	jmp    801eb5 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801e3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e42:	74 24                	je     801e68 <file_trunc+0x80>
  801e44:	c7 44 24 0c f0 2b 80 	movl   $0x802bf0,0xc(%esp)
  801e4b:	00 
  801e4c:	c7 44 24 08 13 2c 80 	movl   $0x802c13,0x8(%esp)
  801e53:	00 
  801e54:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801e5b:	00 
  801e5c:	c7 04 24 28 2c 80 00 	movl   $0x802c28,(%esp)
  801e63:	e8 8c 04 00 00       	call   8022f4 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	89 04 24             	mov    %eax,(%esp)
  801e7c:	e8 36 00 00 00       	call   801eb7 <fmap>
  801e81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e88:	79 05                	jns    801e8f <file_trunc+0xa7>
		return r;
  801e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8d:	eb 26                	jmp    801eb5 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  801e8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e96:	00 
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	89 04 24             	mov    %eax,(%esp)
  801eab:	e8 b0 00 00 00       	call   801f60 <funmap>

	return 0;
  801eb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	89 04 24             	mov    %eax,(%esp)
  801ec3:	e8 64 f5 ff ff       	call   80142c <fd2data>
  801ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  801ecb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	03 45 ec             	add    -0x14(%ebp),%eax
  801ed8:	83 e8 01             	sub    $0x1,%eax
  801edb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ede:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ee1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee6:	f7 75 ec             	divl   -0x14(%ebp)
  801ee9:	89 d0                	mov    %edx,%eax
  801eeb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eee:	89 d1                	mov    %edx,%ecx
  801ef0:	29 c1                	sub    %eax,%ecx
  801ef2:	89 c8                	mov    %ecx,%eax
  801ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef7:	eb 58                	jmp    801f51 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eff:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f0f:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f13:	89 04 24             	mov    %eax,(%esp)
  801f16:	e8 04 02 00 00       	call   80211f <fsipc_map>
  801f1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f22:	79 26                	jns    801f4a <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  801f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f2e:	00 
  801f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f32:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	89 04 24             	mov    %eax,(%esp)
  801f40:	e8 1b 00 00 00       	call   801f60 <funmap>
			return r;
  801f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f48:	eb 14                	jmp    801f5e <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  801f4a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801f51:	8b 45 10             	mov    0x10(%ebp),%eax
  801f54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f57:	77 a0                	ja     801ef9 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	89 04 24             	mov    %eax,(%esp)
  801f6c:	e8 bb f4 ff ff       	call   80142c <fd2data>
  801f71:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  801f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f77:	c1 e8 16             	shr    $0x16,%eax
  801f7a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f81:	83 e0 01             	and    $0x1,%eax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	75 0a                	jne    801f92 <funmap+0x32>
		return 0;
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	e9 bf 00 00 00       	jmp    802051 <funmap+0xf1>

	ret = 0;
  801f92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  801f99:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa3:	03 45 e8             	add    -0x18(%ebp),%eax
  801fa6:	83 e8 01             	sub    $0x1,%eax
  801fa9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801faf:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb4:	f7 75 e8             	divl   -0x18(%ebp)
  801fb7:	89 d0                	mov    %edx,%eax
  801fb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fbc:	89 d1                	mov    %edx,%ecx
  801fbe:	29 c1                	sub    %eax,%ecx
  801fc0:	89 c8                	mov    %ecx,%eax
  801fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc5:	eb 7b                	jmp    802042 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fcd:	01 d0                	add    %edx,%eax
  801fcf:	c1 e8 0c             	shr    $0xc,%eax
  801fd2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fd9:	83 e0 01             	and    $0x1,%eax
  801fdc:	84 c0                	test   %al,%al
  801fde:	74 5b                	je     80203b <funmap+0xdb>
			if (dirty
  801fe0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801fe4:	74 3d                	je     802023 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fec:	01 d0                	add    %edx,%eax
  801fee:	c1 e8 0c             	shr    $0xc,%eax
  801ff1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ff8:	83 e0 40             	and    $0x40,%eax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	74 24                	je     802023 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8b 40 0c             	mov    0xc(%eax),%eax
  802008:	89 54 24 04          	mov    %edx,0x4(%esp)
  80200c:	89 04 24             	mov    %eax,(%esp)
  80200f:	e8 13 02 00 00       	call   802227 <fsipc_dirty>
  802014:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802017:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80201b:	79 06                	jns    802023 <funmap+0xc3>
				ret = r;
  80201d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802026:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802036:	e8 22 f2 ff ff       	call   80125d <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  80203b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802042:	8b 45 0c             	mov    0xc(%ebp),%eax
  802045:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802048:	0f 87 79 ff ff ff    	ja     801fc7 <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  80204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <remove>:

// Delete a file
int
remove(const char *path)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	89 04 24             	mov    %eax,(%esp)
  80205f:	e8 06 02 00 00       	call   80226a <fsipc_remove>
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  80206c:	e8 56 02 00 00       	call   8022c7 <fsipc_sync>
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    
	...

00802074 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80207a:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80207f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802086:	00 
  802087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80208e:	8b 55 08             	mov    0x8(%ebp),%edx
  802091:	89 54 24 04          	mov    %edx,0x4(%esp)
  802095:	89 04 24             	mov    %eax,(%esp)
  802098:	e8 57 03 00 00       	call   8023f4 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  80209d:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ae:	89 04 24             	mov    %eax,(%esp)
  8020b1:	e8 b2 02 00 00       	call   802368 <ipc_recv>
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  8020be:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	89 04 24             	mov    %eax,(%esp)
  8020cb:	e8 74 ea ff ff       	call   800b44 <strlen>
  8020d0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020d5:	7e 07                	jle    8020de <fsipc_open+0x26>
		return -E_BAD_PATH;
  8020d7:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8020dc:	eb 3f                	jmp    80211d <fsipc_open+0x65>
	strcpy(req->req_path, path);
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e8:	89 04 24             	mov    %eax,(%esp)
  8020eb:	e8 aa ea ff ff       	call   800b9a <strcpy>
	req->req_omode = omode;
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f6:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8020fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802103:	8b 45 10             	mov    0x10(%ebp),%eax
  802106:	89 44 24 08          	mov    %eax,0x8(%esp)
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802111:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802118:	e8 57 ff ff ff       	call   802074 <fsipc>
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  802125:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80212c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212f:	8b 55 08             	mov    0x8(%ebp),%edx
  802132:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213a:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  80213d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802140:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802144:	8b 45 10             	mov    0x10(%ebp),%eax
  802147:	89 44 24 08          	mov    %eax,0x8(%esp)
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802152:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802159:	e8 16 ff ff ff       	call   802074 <fsipc>
  80215e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802161:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802165:	79 05                	jns    80216c <fsipc_map+0x4d>
		return r;
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216a:	eb 3c                	jmp    8021a8 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  80216c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216f:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  802174:	83 f8 05             	cmp    $0x5,%eax
  802177:	74 2a                	je     8021a3 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  802179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217c:	8b 55 10             	mov    0x10(%ebp),%edx
  80217f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802183:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802187:	c7 44 24 08 34 2c 80 	movl   $0x802c34,0x8(%esp)
  80218e:	00 
  80218f:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  802196:	00 
  802197:	c7 04 24 6a 2c 80 00 	movl   $0x802c6a,(%esp)
  80219e:	e8 51 01 00 00       	call   8022f4 <_panic>
	return 0;
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  8021b0:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8021bd:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c5:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  8021c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021cf:	00 
  8021d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021d7:	00 
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021df:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8021e6:	e8 89 fe ff ff       	call   802074 <fsipc>
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  8021f3:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8021fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802200:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  802202:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802209:	00 
  80220a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802211:	00 
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	89 44 24 04          	mov    %eax,0x4(%esp)
  802219:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  802220:	e8 4f fe ff ff       	call   802074 <fsipc>
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  80222d:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 55 08             	mov    0x8(%ebp),%edx
  80223a:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802242:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  802245:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80224c:	00 
  80224d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802254:	00 
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  802263:	e8 0c fe ff ff       	call   802074 <fsipc>
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802270:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	89 04 24             	mov    %eax,(%esp)
  80227d:	e8 c2 e8 ff ff       	call   800b44 <strlen>
  802282:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802287:	7e 07                	jle    802290 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802289:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80228e:	eb 35                	jmp    8022c5 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 55 08             	mov    0x8(%ebp),%edx
  802296:	89 54 24 04          	mov    %edx,0x4(%esp)
  80229a:	89 04 24             	mov    %eax,(%esp)
  80229d:	e8 f8 e8 ff ff       	call   800b9a <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8022a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022a9:	00 
  8022aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022b1:	00 
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b9:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  8022c0:	e8 af fd ff ff       	call   802074 <fsipc>
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8022cd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022d4:	00 
  8022d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022dc:	00 
  8022dd:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8022e4:	00 
  8022e5:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8022ec:	e8 83 fd ff ff       	call   802074 <fsipc>
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    
	...

008022f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  8022fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8022fd:	83 c0 04             	add    $0x4,%eax
  802300:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  802303:	a1 14 7f 80 00       	mov    0x807f14,%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	74 15                	je     802321 <_panic+0x2d>
		cprintf("%s: ", argv0);
  80230c:	a1 14 7f 80 00       	mov    0x807f14,%eax
  802311:	89 44 24 04          	mov    %eax,0x4(%esp)
  802315:	c7 04 24 76 2c 80 00 	movl   $0x802c76,(%esp)
  80231c:	e8 67 df ff ff       	call   800288 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802321:	a1 70 67 80 00       	mov    0x806770,%eax
  802326:	8b 55 0c             	mov    0xc(%ebp),%edx
  802329:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80232d:	8b 55 08             	mov    0x8(%ebp),%edx
  802330:	89 54 24 08          	mov    %edx,0x8(%esp)
  802334:	89 44 24 04          	mov    %eax,0x4(%esp)
  802338:	c7 04 24 7b 2c 80 00 	movl   $0x802c7b,(%esp)
  80233f:	e8 44 df ff ff       	call   800288 <cprintf>
	vcprintf(fmt, ap);
  802344:	8b 45 10             	mov    0x10(%ebp),%eax
  802347:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80234e:	89 04 24             	mov    %eax,(%esp)
  802351:	e8 ce de ff ff       	call   800224 <vcprintf>
	cprintf("\n");
  802356:	c7 04 24 97 2c 80 00 	movl   $0x802c97,(%esp)
  80235d:	e8 26 df ff ff       	call   800288 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802362:	cc                   	int3   
  802363:	eb fd                	jmp    802362 <_panic+0x6e>
  802365:	00 00                	add    %al,(%eax)
	...

00802368 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  80236e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802372:	75 11                	jne    802385 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  802374:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  80237b:	e8 67 f0 ff ff       	call   8013e7 <sys_ipc_recv>
  802380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802383:	eb 0e                	jmp    802393 <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	89 04 24             	mov    %eax,(%esp)
  80238b:	e8 57 f0 ff ff       	call   8013e7 <sys_ipc_recv>
  802390:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  802393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802397:	79 1c                	jns    8023b5 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  802399:	c7 44 24 08 99 2c 80 	movl   $0x802c99,0x8(%esp)
  8023a0:	00 
  8023a1:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8023a8:	00 
  8023a9:	c7 04 24 af 2c 80 00 	movl   $0x802caf,(%esp)
  8023b0:	e8 3f ff ff ff       	call   8022f4 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  8023b5:	e8 94 ed ff ff       	call   80114e <sys_getenvid>
  8023ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023bf:	c1 e0 07             	shl    $0x7,%eax
  8023c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  8023ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ce:	74 0b                	je     8023db <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  8023d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d3:	8b 50 74             	mov    0x74(%eax),%edx
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  8023db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023df:	74 0b                	je     8023ec <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  8023e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e4:	8b 50 78             	mov    0x78(%eax),%edx
  8023e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ea:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  8023ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ef:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  8023fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023fe:	75 26                	jne    802426 <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  802400:	8b 45 14             	mov    0x14(%ebp),%eax
  802403:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802407:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  80240e:	ee 
  80240f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802412:	89 44 24 04          	mov    %eax,0x4(%esp)
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	89 04 24             	mov    %eax,(%esp)
  80241c:	e8 86 ef ff ff       	call   8013a7 <sys_ipc_try_send>
  802421:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802424:	eb 23                	jmp    802449 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  802426:	8b 45 14             	mov    0x14(%ebp),%eax
  802429:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80242d:	8b 45 10             	mov    0x10(%ebp),%eax
  802430:	89 44 24 08          	mov    %eax,0x8(%esp)
  802434:	8b 45 0c             	mov    0xc(%ebp),%eax
  802437:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	89 04 24             	mov    %eax,(%esp)
  802441:	e8 61 ef ff ff       	call   8013a7 <sys_ipc_try_send>
  802446:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  802449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244d:	79 29                	jns    802478 <ipc_send+0x84>
  80244f:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  802453:	74 23                	je     802478 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80245c:	c7 44 24 08 b9 2c 80 	movl   $0x802cb9,0x8(%esp)
  802463:	00 
  802464:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80246b:	00 
  80246c:	c7 04 24 af 2c 80 00 	movl   $0x802caf,(%esp)
  802473:	e8 7c fe ff ff       	call   8022f4 <_panic>
	    sys_yield();
  802478:	e8 15 ed ff ff       	call   801192 <sys_yield>
	}while(r < 0);
  80247d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802481:	0f 88 73 ff ff ff    	js     8023fa <ipc_send+0x6>
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    
  802489:	00 00                	add    %al,(%eax)
  80248b:	00 00                	add    %al,(%eax)
  80248d:	00 00                	add    %al,(%eax)
	...

00802490 <__udivdi3>:
  802490:	83 ec 1c             	sub    $0x1c,%esp
  802493:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802497:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80249b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80249f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8024a3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8024a7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8024ab:	85 ff                	test   %edi,%edi
  8024ad:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8024b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024b5:	89 cd                	mov    %ecx,%ebp
  8024b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024bb:	75 33                	jne    8024f0 <__udivdi3+0x60>
  8024bd:	39 f1                	cmp    %esi,%ecx
  8024bf:	77 57                	ja     802518 <__udivdi3+0x88>
  8024c1:	85 c9                	test   %ecx,%ecx
  8024c3:	75 0b                	jne    8024d0 <__udivdi3+0x40>
  8024c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ca:	31 d2                	xor    %edx,%edx
  8024cc:	f7 f1                	div    %ecx
  8024ce:	89 c1                	mov    %eax,%ecx
  8024d0:	89 f0                	mov    %esi,%eax
  8024d2:	31 d2                	xor    %edx,%edx
  8024d4:	f7 f1                	div    %ecx
  8024d6:	89 c6                	mov    %eax,%esi
  8024d8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024dc:	f7 f1                	div    %ecx
  8024de:	89 f2                	mov    %esi,%edx
  8024e0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024e4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024e8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024ec:	83 c4 1c             	add    $0x1c,%esp
  8024ef:	c3                   	ret    
  8024f0:	31 d2                	xor    %edx,%edx
  8024f2:	31 c0                	xor    %eax,%eax
  8024f4:	39 f7                	cmp    %esi,%edi
  8024f6:	77 e8                	ja     8024e0 <__udivdi3+0x50>
  8024f8:	0f bd cf             	bsr    %edi,%ecx
  8024fb:	83 f1 1f             	xor    $0x1f,%ecx
  8024fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802502:	75 2c                	jne    802530 <__udivdi3+0xa0>
  802504:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802508:	76 04                	jbe    80250e <__udivdi3+0x7e>
  80250a:	39 f7                	cmp    %esi,%edi
  80250c:	73 d2                	jae    8024e0 <__udivdi3+0x50>
  80250e:	31 d2                	xor    %edx,%edx
  802510:	b8 01 00 00 00       	mov    $0x1,%eax
  802515:	eb c9                	jmp    8024e0 <__udivdi3+0x50>
  802517:	90                   	nop
  802518:	89 f2                	mov    %esi,%edx
  80251a:	f7 f1                	div    %ecx
  80251c:	31 d2                	xor    %edx,%edx
  80251e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802522:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802526:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80252a:	83 c4 1c             	add    $0x1c,%esp
  80252d:	c3                   	ret    
  80252e:	66 90                	xchg   %ax,%ax
  802530:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802535:	b8 20 00 00 00       	mov    $0x20,%eax
  80253a:	89 ea                	mov    %ebp,%edx
  80253c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802540:	d3 e7                	shl    %cl,%edi
  802542:	89 c1                	mov    %eax,%ecx
  802544:	d3 ea                	shr    %cl,%edx
  802546:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80254b:	09 fa                	or     %edi,%edx
  80254d:	89 f7                	mov    %esi,%edi
  80254f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802553:	89 f2                	mov    %esi,%edx
  802555:	8b 74 24 08          	mov    0x8(%esp),%esi
  802559:	d3 e5                	shl    %cl,%ebp
  80255b:	89 c1                	mov    %eax,%ecx
  80255d:	d3 ef                	shr    %cl,%edi
  80255f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802564:	d3 e2                	shl    %cl,%edx
  802566:	89 c1                	mov    %eax,%ecx
  802568:	d3 ee                	shr    %cl,%esi
  80256a:	09 d6                	or     %edx,%esi
  80256c:	89 fa                	mov    %edi,%edx
  80256e:	89 f0                	mov    %esi,%eax
  802570:	f7 74 24 0c          	divl   0xc(%esp)
  802574:	89 d7                	mov    %edx,%edi
  802576:	89 c6                	mov    %eax,%esi
  802578:	f7 e5                	mul    %ebp
  80257a:	39 d7                	cmp    %edx,%edi
  80257c:	72 22                	jb     8025a0 <__udivdi3+0x110>
  80257e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802582:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802587:	d3 e5                	shl    %cl,%ebp
  802589:	39 c5                	cmp    %eax,%ebp
  80258b:	73 04                	jae    802591 <__udivdi3+0x101>
  80258d:	39 d7                	cmp    %edx,%edi
  80258f:	74 0f                	je     8025a0 <__udivdi3+0x110>
  802591:	89 f0                	mov    %esi,%eax
  802593:	31 d2                	xor    %edx,%edx
  802595:	e9 46 ff ff ff       	jmp    8024e0 <__udivdi3+0x50>
  80259a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025a0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8025a3:	31 d2                	xor    %edx,%edx
  8025a5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025a9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025ad:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025b1:	83 c4 1c             	add    $0x1c,%esp
  8025b4:	c3                   	ret    
	...

008025c0 <__umoddi3>:
  8025c0:	83 ec 1c             	sub    $0x1c,%esp
  8025c3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8025c7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8025cb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8025cf:	89 74 24 10          	mov    %esi,0x10(%esp)
  8025d3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8025d7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8025db:	85 ed                	test   %ebp,%ebp
  8025dd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8025e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025e5:	89 cf                	mov    %ecx,%edi
  8025e7:	89 04 24             	mov    %eax,(%esp)
  8025ea:	89 f2                	mov    %esi,%edx
  8025ec:	75 1a                	jne    802608 <__umoddi3+0x48>
  8025ee:	39 f1                	cmp    %esi,%ecx
  8025f0:	76 4e                	jbe    802640 <__umoddi3+0x80>
  8025f2:	f7 f1                	div    %ecx
  8025f4:	89 d0                	mov    %edx,%eax
  8025f6:	31 d2                	xor    %edx,%edx
  8025f8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025fc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802600:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802604:	83 c4 1c             	add    $0x1c,%esp
  802607:	c3                   	ret    
  802608:	39 f5                	cmp    %esi,%ebp
  80260a:	77 54                	ja     802660 <__umoddi3+0xa0>
  80260c:	0f bd c5             	bsr    %ebp,%eax
  80260f:	83 f0 1f             	xor    $0x1f,%eax
  802612:	89 44 24 04          	mov    %eax,0x4(%esp)
  802616:	75 60                	jne    802678 <__umoddi3+0xb8>
  802618:	3b 0c 24             	cmp    (%esp),%ecx
  80261b:	0f 87 07 01 00 00    	ja     802728 <__umoddi3+0x168>
  802621:	89 f2                	mov    %esi,%edx
  802623:	8b 34 24             	mov    (%esp),%esi
  802626:	29 ce                	sub    %ecx,%esi
  802628:	19 ea                	sbb    %ebp,%edx
  80262a:	89 34 24             	mov    %esi,(%esp)
  80262d:	8b 04 24             	mov    (%esp),%eax
  802630:	8b 74 24 10          	mov    0x10(%esp),%esi
  802634:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802638:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80263c:	83 c4 1c             	add    $0x1c,%esp
  80263f:	c3                   	ret    
  802640:	85 c9                	test   %ecx,%ecx
  802642:	75 0b                	jne    80264f <__umoddi3+0x8f>
  802644:	b8 01 00 00 00       	mov    $0x1,%eax
  802649:	31 d2                	xor    %edx,%edx
  80264b:	f7 f1                	div    %ecx
  80264d:	89 c1                	mov    %eax,%ecx
  80264f:	89 f0                	mov    %esi,%eax
  802651:	31 d2                	xor    %edx,%edx
  802653:	f7 f1                	div    %ecx
  802655:	8b 04 24             	mov    (%esp),%eax
  802658:	f7 f1                	div    %ecx
  80265a:	eb 98                	jmp    8025f4 <__umoddi3+0x34>
  80265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802660:	89 f2                	mov    %esi,%edx
  802662:	8b 74 24 10          	mov    0x10(%esp),%esi
  802666:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80266a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80266e:	83 c4 1c             	add    $0x1c,%esp
  802671:	c3                   	ret    
  802672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802678:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80267d:	89 e8                	mov    %ebp,%eax
  80267f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802684:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802688:	89 fa                	mov    %edi,%edx
  80268a:	d3 e0                	shl    %cl,%eax
  80268c:	89 e9                	mov    %ebp,%ecx
  80268e:	d3 ea                	shr    %cl,%edx
  802690:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802695:	09 c2                	or     %eax,%edx
  802697:	8b 44 24 08          	mov    0x8(%esp),%eax
  80269b:	89 14 24             	mov    %edx,(%esp)
  80269e:	89 f2                	mov    %esi,%edx
  8026a0:	d3 e7                	shl    %cl,%edi
  8026a2:	89 e9                	mov    %ebp,%ecx
  8026a4:	d3 ea                	shr    %cl,%edx
  8026a6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026af:	d3 e6                	shl    %cl,%esi
  8026b1:	89 e9                	mov    %ebp,%ecx
  8026b3:	d3 e8                	shr    %cl,%eax
  8026b5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ba:	09 f0                	or     %esi,%eax
  8026bc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8026c0:	f7 34 24             	divl   (%esp)
  8026c3:	d3 e6                	shl    %cl,%esi
  8026c5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026c9:	89 d6                	mov    %edx,%esi
  8026cb:	f7 e7                	mul    %edi
  8026cd:	39 d6                	cmp    %edx,%esi
  8026cf:	89 c1                	mov    %eax,%ecx
  8026d1:	89 d7                	mov    %edx,%edi
  8026d3:	72 3f                	jb     802714 <__umoddi3+0x154>
  8026d5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8026d9:	72 35                	jb     802710 <__umoddi3+0x150>
  8026db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026df:	29 c8                	sub    %ecx,%eax
  8026e1:	19 fe                	sbb    %edi,%esi
  8026e3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026e8:	89 f2                	mov    %esi,%edx
  8026ea:	d3 e8                	shr    %cl,%eax
  8026ec:	89 e9                	mov    %ebp,%ecx
  8026ee:	d3 e2                	shl    %cl,%edx
  8026f0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026f5:	09 d0                	or     %edx,%eax
  8026f7:	89 f2                	mov    %esi,%edx
  8026f9:	d3 ea                	shr    %cl,%edx
  8026fb:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026ff:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802703:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802707:	83 c4 1c             	add    $0x1c,%esp
  80270a:	c3                   	ret    
  80270b:	90                   	nop
  80270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802710:	39 d6                	cmp    %edx,%esi
  802712:	75 c7                	jne    8026db <__umoddi3+0x11b>
  802714:	89 d7                	mov    %edx,%edi
  802716:	89 c1                	mov    %eax,%ecx
  802718:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80271c:	1b 3c 24             	sbb    (%esp),%edi
  80271f:	eb ba                	jmp    8026db <__umoddi3+0x11b>
  802721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802728:	39 f5                	cmp    %esi,%ebp
  80272a:	0f 82 f1 fe ff ff    	jb     802621 <__umoddi3+0x61>
  802730:	e9 f8 fe ff ff       	jmp    80262d <__umoddi3+0x6d>
