
obj/user/pingpong:     file format elf32-i386


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
  80002c:	e8 d7 00 00 00       	call   800108 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

#include <inc/lib.h>

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 24             	sub    $0x24,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003b:	e8 ef 15 00 00       	call   80162f <fork>
  800040:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800046:	85 c0                	test   %eax,%eax
  800048:	74 42                	je     80008c <umain+0x58>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  80004d:	e8 a0 10 00 00       	call   8010f2 <sys_getenvid>
  800052:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800056:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005a:	c7 04 24 a0 2e 80 00 	movl   $0x802ea0,(%esp)
  800061:	e8 c6 01 00 00       	call   80022c <cprintf>
		ipc_send(who, 0, 0, 0);
  800066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800069:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800070:	00 
  800071:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800078:	00 
  800079:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800080:	00 
  800081:	89 04 24             	mov    %eax,(%esp)
  800084:	e8 cf 1a 00 00       	call   801b58 <ipc_send>
  800089:	eb 01                	jmp    80008c <umain+0x58>
			return;
		i++;
		ipc_send(who, i, 0, 0);
		if (i == 10)
			return;
	}
  80008b:	90                   	nop
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80008c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009b:	00 
  80009c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80009f:	89 04 24             	mov    %eax,(%esp)
  8000a2:	e8 25 1a 00 00       	call   801acc <ipc_recv>
  8000a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000aa:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  8000ad:	e8 40 10 00 00       	call   8010f2 <sys_getenvid>
  8000b2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c1:	c7 04 24 b6 2e 80 00 	movl   $0x802eb6,(%esp)
  8000c8:	e8 5f 01 00 00       	call   80022c <cprintf>
		if (i == 10)
  8000cd:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  8000d1:	74 2e                	je     800101 <umain+0xcd>
			return;
		i++;
  8000d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		ipc_send(who, i, 0, 0);
  8000d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000e1:	00 
  8000e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000e9:	00 
  8000ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  8000f1:	89 04 24             	mov    %eax,(%esp)
  8000f4:	e8 5f 1a 00 00       	call   801b58 <ipc_send>
		if (i == 10)
  8000f9:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  8000fd:	75 8c                	jne    80008b <umain+0x57>
			return;
  8000ff:	eb 01                	jmp    800102 <umain+0xce>

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
		if (i == 10)
			return;
  800101:	90                   	nop
		i++;
		ipc_send(who, i, 0, 0);
		if (i == 10)
			return;
	}
}
  800102:	83 c4 24             	add    $0x24,%esp
  800105:	5b                   	pop    %ebx
  800106:	5d                   	pop    %ebp
  800107:	c3                   	ret    

00800108 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  80010e:	e8 df 0f 00 00       	call   8010f2 <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	c1 e0 07             	shl    $0x7,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 40 60 80 00       	mov    %eax,0x806040
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800129:	7e 0a                	jle    800135 <libmain+0x2d>
		binaryname = argv[0];
  80012b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013c:	8b 45 08             	mov    0x8(%ebp),%eax
  80013f:	89 04 24             	mov    %eax,(%esp)
  800142:	e8 ed fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800147:	e8 04 00 00 00       	call   800150 <exit>
}
  80014c:	c9                   	leave  
  80014d:	c3                   	ret    
	...

00800150 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800156:	e8 8b 1c 00 00       	call   801de6 <close_all>
	sys_env_destroy(0);
  80015b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800162:	e8 48 0f 00 00       	call   8010af <sys_env_destroy>
}
  800167:	c9                   	leave  
  800168:	c3                   	ret    
  800169:	00 00                	add    %al,(%eax)
	...

0080016c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  800172:	8b 45 0c             	mov    0xc(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	8b 55 08             	mov    0x8(%ebp),%edx
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  800183:	8d 50 01             	lea    0x1(%eax),%edx
  800186:	8b 45 0c             	mov    0xc(%ebp),%eax
  800189:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	3d ff 00 00 00       	cmp    $0xff,%eax
  800195:	75 20                	jne    8001b7 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  800197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019f:	83 c2 08             	add    $0x8,%edx
  8001a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a6:	89 14 24             	mov    %edx,(%esp)
  8001a9:	e8 7b 0e 00 00       	call   801029 <sys_cputs>
		b->idx = 0;
  8001ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ba:	8b 40 04             	mov    0x4(%eax),%eax
  8001bd:	8d 50 01             	lea    0x1(%eax),%edx
  8001c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001c6:	c9                   	leave  
  8001c7:	c3                   	ret    

008001c8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d8:	00 00 00 
	b.cnt = 0;
  8001db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fd:	c7 04 24 6c 01 80 00 	movl   $0x80016c,(%esp)
  800204:	e8 f7 01 00 00       	call   800400 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800209:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80020f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800213:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800219:	83 c0 08             	add    $0x8,%eax
  80021c:	89 04 24             	mov    %eax,(%esp)
  80021f:	e8 05 0e 00 00       	call   801029 <sys_cputs>

	return b.cnt;
  800224:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800232:	8d 45 0c             	lea    0xc(%ebp),%eax
  800235:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800242:	89 04 24             	mov    %eax,(%esp)
  800245:	e8 7e ff ff ff       	call   8001c8 <vcprintf>
  80024a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80024d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800250:	c9                   	leave  
  800251:	c3                   	ret    
	...

00800254 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	53                   	push   %ebx
  800258:	83 ec 34             	sub    $0x34,%esp
  80025b:	8b 45 10             	mov    0x10(%ebp),%eax
  80025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800261:	8b 45 14             	mov    0x14(%ebp),%eax
  800264:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800267:	8b 45 18             	mov    0x18(%ebp),%eax
  80026a:	ba 00 00 00 00       	mov    $0x0,%edx
  80026f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800272:	77 72                	ja     8002e6 <printnum+0x92>
  800274:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800277:	72 05                	jb     80027e <printnum+0x2a>
  800279:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80027c:	77 68                	ja     8002e6 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800281:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800284:	8b 45 18             	mov    0x18(%ebp),%eax
  800287:	ba 00 00 00 00       	mov    $0x0,%edx
  80028c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800290:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80029a:	89 04 24             	mov    %eax,(%esp)
  80029d:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a1:	e8 4a 29 00 00       	call   802bf0 <__udivdi3>
  8002a6:	8b 4d 20             	mov    0x20(%ebp),%ecx
  8002a9:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  8002ad:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8002b1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002b4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002bc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	89 04 24             	mov    %eax,(%esp)
  8002cd:	e8 82 ff ff ff       	call   800254 <printnum>
  8002d2:	eb 1c                	jmp    8002f0 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002db:	8b 45 20             	mov    0x20(%ebp),%eax
  8002de:	89 04 24             	mov    %eax,(%esp)
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002e6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8002ea:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002ee:	7f e4                	jg     8002d4 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002fe:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800302:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800306:	89 04 24             	mov    %eax,(%esp)
  800309:	89 54 24 04          	mov    %edx,0x4(%esp)
  80030d:	e8 0e 2a 00 00       	call   802d20 <__umoddi3>
  800312:	05 3c 30 80 00       	add    $0x80303c,%eax
  800317:	0f b6 00             	movzbl (%eax),%eax
  80031a:	0f be c0             	movsbl %al,%eax
  80031d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800320:	89 54 24 04          	mov    %edx,0x4(%esp)
  800324:	89 04 24             	mov    %eax,(%esp)
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	ff d0                	call   *%eax
}
  80032c:	83 c4 34             	add    $0x34,%esp
  80032f:	5b                   	pop    %ebx
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800335:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800339:	7e 1c                	jle    800357 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	8d 50 08             	lea    0x8(%eax),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	89 10                	mov    %edx,(%eax)
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	8b 00                	mov    (%eax),%eax
  80034d:	83 e8 08             	sub    $0x8,%eax
  800350:	8b 50 04             	mov    0x4(%eax),%edx
  800353:	8b 00                	mov    (%eax),%eax
  800355:	eb 40                	jmp    800397 <getuint+0x65>
	else if (lflag)
  800357:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80035b:	74 1e                	je     80037b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	8d 50 04             	lea    0x4(%eax),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	89 10                	mov    %edx,(%eax)
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	8b 00                	mov    (%eax),%eax
  80036f:	83 e8 04             	sub    $0x4,%eax
  800372:	8b 00                	mov    (%eax),%eax
  800374:	ba 00 00 00 00       	mov    $0x0,%edx
  800379:	eb 1c                	jmp    800397 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80037b:	8b 45 08             	mov    0x8(%ebp),%eax
  80037e:	8b 00                	mov    (%eax),%eax
  800380:	8d 50 04             	lea    0x4(%eax),%edx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	89 10                	mov    %edx,(%eax)
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	83 e8 04             	sub    $0x4,%eax
  800390:	8b 00                	mov    (%eax),%eax
  800392:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80039c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003a0:	7e 1c                	jle    8003be <getint+0x25>
		return va_arg(*ap, long long);
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	8d 50 08             	lea    0x8(%eax),%edx
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	89 10                	mov    %edx,(%eax)
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	8b 00                	mov    (%eax),%eax
  8003b4:	83 e8 08             	sub    $0x8,%eax
  8003b7:	8b 50 04             	mov    0x4(%eax),%edx
  8003ba:	8b 00                	mov    (%eax),%eax
  8003bc:	eb 40                	jmp    8003fe <getint+0x65>
	else if (lflag)
  8003be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003c2:	74 1e                	je     8003e2 <getint+0x49>
		return va_arg(*ap, long);
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	8d 50 04             	lea    0x4(%eax),%edx
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	89 10                	mov    %edx,(%eax)
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	83 e8 04             	sub    $0x4,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 c2                	mov    %eax,%edx
  8003dd:	c1 fa 1f             	sar    $0x1f,%edx
  8003e0:	eb 1c                	jmp    8003fe <getint+0x65>
	else
		return va_arg(*ap, int);
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	8d 50 04             	lea    0x4(%eax),%edx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	89 10                	mov    %edx,(%eax)
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	83 e8 04             	sub    $0x4,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 c2                	mov    %eax,%edx
  8003fb:	c1 fa 1f             	sar    $0x1f,%edx
}
  8003fe:	5d                   	pop    %ebp
  8003ff:	c3                   	ret    

00800400 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	56                   	push   %esi
  800404:	53                   	push   %ebx
  800405:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800408:	eb 17                	jmp    800421 <vprintfmt+0x21>
			if (ch == '\0')
  80040a:	85 db                	test   %ebx,%ebx
  80040c:	0f 84 d1 05 00 00    	je     8009e3 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  800412:	8b 45 0c             	mov    0xc(%ebp),%eax
  800415:	89 44 24 04          	mov    %eax,0x4(%esp)
  800419:	89 1c 24             	mov    %ebx,(%esp)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800421:	8b 45 10             	mov    0x10(%ebp),%eax
  800424:	0f b6 00             	movzbl (%eax),%eax
  800427:	0f b6 d8             	movzbl %al,%ebx
  80042a:	83 fb 25             	cmp    $0x25,%ebx
  80042d:	0f 95 c0             	setne  %al
  800430:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800434:	84 c0                	test   %al,%al
  800436:	75 d2                	jne    80040a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800438:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80043c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800443:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80044a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800451:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800458:	eb 04                	jmp    80045e <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80045a:	90                   	nop
  80045b:	eb 01                	jmp    80045e <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80045d:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045e:	8b 45 10             	mov    0x10(%ebp),%eax
  800461:	0f b6 00             	movzbl (%eax),%eax
  800464:	0f b6 d8             	movzbl %al,%ebx
  800467:	89 d8                	mov    %ebx,%eax
  800469:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  80046d:	83 e8 23             	sub    $0x23,%eax
  800470:	83 f8 55             	cmp    $0x55,%eax
  800473:	0f 87 39 05 00 00    	ja     8009b2 <vprintfmt+0x5b2>
  800479:	8b 04 85 84 30 80 00 	mov    0x803084(,%eax,4),%eax
  800480:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800482:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800486:	eb d6                	jmp    80045e <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800488:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80048c:	eb d0                	jmp    80045e <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80048e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800495:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800498:	89 d0                	mov    %edx,%eax
  80049a:	c1 e0 02             	shl    $0x2,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	01 c0                	add    %eax,%eax
  8004a1:	01 d8                	add    %ebx,%eax
  8004a3:	83 e8 30             	sub    $0x30,%eax
  8004a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ac:	0f b6 00             	movzbl (%eax),%eax
  8004af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8004b5:	7e 43                	jle    8004fa <vprintfmt+0xfa>
  8004b7:	83 fb 39             	cmp    $0x39,%ebx
  8004ba:	7f 3e                	jg     8004fa <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004bc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004c0:	eb d3                	jmp    800495 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	83 c0 04             	add    $0x4,%eax
  8004c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	83 e8 04             	sub    $0x4,%eax
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004d6:	eb 23                	jmp    8004fb <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  8004d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004dc:	0f 89 78 ff ff ff    	jns    80045a <vprintfmt+0x5a>
				width = 0;
  8004e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8004e9:	e9 6c ff ff ff       	jmp    80045a <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  8004ee:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004f5:	e9 64 ff ff ff       	jmp    80045e <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8004fa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004ff:	0f 89 58 ff ff ff    	jns    80045d <vprintfmt+0x5d>
				width = precision, precision = -1;
  800505:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800508:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800512:	e9 46 ff ff ff       	jmp    80045d <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800517:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  80051b:	e9 3e ff ff ff       	jmp    80045e <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	83 c0 04             	add    $0x4,%eax
  800526:	89 45 14             	mov    %eax,0x14(%ebp)
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	83 e8 04             	sub    $0x4,%eax
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	8b 55 0c             	mov    0xc(%ebp),%edx
  800534:	89 54 24 04          	mov    %edx,0x4(%esp)
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
			break;
  800540:	e9 98 04 00 00       	jmp    8009dd <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  800545:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  80054c:	00 
  80054d:	8b 45 10             	mov    0x10(%ebp),%eax
  800550:	89 44 24 04          	mov    %eax,0x4(%esp)
  800554:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800557:	89 04 24             	mov    %eax,(%esp)
  80055a:	e8 d1 07 00 00       	call   800d30 <memmove>
            sel_c[3] = '\0';
  80055f:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  800563:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  800567:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80056b:	3c 2f                	cmp    $0x2f,%al
  80056d:	7e 4c                	jle    8005bb <vprintfmt+0x1bb>
  80056f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800573:	3c 39                	cmp    $0x39,%al
  800575:	7f 44                	jg     8005bb <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  800577:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80057b:	0f be d0             	movsbl %al,%edx
  80057e:	89 d0                	mov    %edx,%eax
  800580:	c1 e0 02             	shl    $0x2,%eax
  800583:	01 d0                	add    %edx,%eax
  800585:	01 c0                	add    %eax,%eax
  800587:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  80058d:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  800591:	0f be c0             	movsbl %al,%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	c1 e0 02             	shl    $0x2,%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	01 c0                	add    %eax,%eax
  80059f:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8005a5:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  8005a9:	0f be c0             	movsbl %al,%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	83 e8 30             	sub    $0x30,%eax
  8005b1:	a3 04 60 80 00       	mov    %eax,0x806004
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8005b6:	e9 22 04 00 00       	jmp    8009dd <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  8005bb:	c7 44 24 04 4d 30 80 	movl   $0x80304d,0x4(%esp)
  8005c2:	00 
  8005c3:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8005c6:	89 04 24             	mov    %eax,(%esp)
  8005c9:	e8 36 06 00 00       	call   800c04 <strcmp>
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	75 0f                	jne    8005e1 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  8005d2:	c7 05 04 60 80 00 07 	movl   $0x7,0x806004
  8005d9:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8005dc:	e9 fc 03 00 00       	jmp    8009dd <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  8005e1:	c7 44 24 04 51 30 80 	movl   $0x803051,0x4(%esp)
  8005e8:	00 
  8005e9:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8005ec:	89 04 24             	mov    %eax,(%esp)
  8005ef:	e8 10 06 00 00       	call   800c04 <strcmp>
  8005f4:	85 c0                	test   %eax,%eax
  8005f6:	75 0f                	jne    800607 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  8005f8:	c7 05 04 60 80 00 01 	movl   $0x1,0x806004
  8005ff:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800602:	e9 d6 03 00 00       	jmp    8009dd <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  800607:	c7 44 24 04 55 30 80 	movl   $0x803055,0x4(%esp)
  80060e:	00 
  80060f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800612:	89 04 24             	mov    %eax,(%esp)
  800615:	e8 ea 05 00 00       	call   800c04 <strcmp>
  80061a:	85 c0                	test   %eax,%eax
  80061c:	75 0f                	jne    80062d <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  80061e:	c7 05 04 60 80 00 02 	movl   $0x2,0x806004
  800625:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800628:	e9 b0 03 00 00       	jmp    8009dd <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  80062d:	c7 44 24 04 59 30 80 	movl   $0x803059,0x4(%esp)
  800634:	00 
  800635:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800638:	89 04 24             	mov    %eax,(%esp)
  80063b:	e8 c4 05 00 00       	call   800c04 <strcmp>
  800640:	85 c0                	test   %eax,%eax
  800642:	75 0f                	jne    800653 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  800644:	c7 05 04 60 80 00 04 	movl   $0x4,0x806004
  80064b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80064e:	e9 8a 03 00 00       	jmp    8009dd <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  800653:	c7 44 24 04 5d 30 80 	movl   $0x80305d,0x4(%esp)
  80065a:	00 
  80065b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80065e:	89 04 24             	mov    %eax,(%esp)
  800661:	e8 9e 05 00 00       	call   800c04 <strcmp>
  800666:	85 c0                	test   %eax,%eax
  800668:	75 0f                	jne    800679 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  80066a:	c7 05 04 60 80 00 08 	movl   $0x8,0x806004
  800671:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800674:	e9 64 03 00 00       	jmp    8009dd <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  800679:	c7 44 24 04 61 30 80 	movl   $0x803061,0x4(%esp)
  800680:	00 
  800681:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800684:	89 04 24             	mov    %eax,(%esp)
  800687:	e8 78 05 00 00       	call   800c04 <strcmp>
  80068c:	85 c0                	test   %eax,%eax
  80068e:	75 0f                	jne    80069f <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  800690:	c7 05 04 60 80 00 0f 	movl   $0xf,0x806004
  800697:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80069a:	e9 3e 03 00 00       	jmp    8009dd <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  80069f:	c7 44 24 04 65 30 80 	movl   $0x803065,0x4(%esp)
  8006a6:	00 
  8006a7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006aa:	89 04 24             	mov    %eax,(%esp)
  8006ad:	e8 52 05 00 00       	call   800c04 <strcmp>
  8006b2:	85 c0                	test   %eax,%eax
  8006b4:	75 0f                	jne    8006c5 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  8006b6:	c7 05 04 60 80 00 0c 	movl   $0xc,0x806004
  8006bd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006c0:	e9 18 03 00 00       	jmp    8009dd <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  8006c5:	c7 44 24 04 69 30 80 	movl   $0x803069,0x4(%esp)
  8006cc:	00 
  8006cd:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006d0:	89 04 24             	mov    %eax,(%esp)
  8006d3:	e8 2c 05 00 00       	call   800c04 <strcmp>
  8006d8:	85 c0                	test   %eax,%eax
  8006da:	75 0f                	jne    8006eb <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  8006dc:	c7 05 04 60 80 00 06 	movl   $0x6,0x806004
  8006e3:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006e6:	e9 f2 02 00 00       	jmp    8009dd <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  8006eb:	c7 44 24 04 6d 30 80 	movl   $0x80306d,0x4(%esp)
  8006f2:	00 
  8006f3:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006f6:	89 04 24             	mov    %eax,(%esp)
  8006f9:	e8 06 05 00 00       	call   800c04 <strcmp>
  8006fe:	85 c0                	test   %eax,%eax
  800700:	75 0f                	jne    800711 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  800702:	c7 05 04 60 80 00 0b 	movl   $0xb,0x806004
  800709:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80070c:	e9 cc 02 00 00       	jmp    8009dd <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  800711:	c7 05 04 60 80 00 07 	movl   $0x7,0x806004
  800718:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80071b:	e9 bd 02 00 00       	jmp    8009dd <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	83 c0 04             	add    $0x4,%eax
  800726:	89 45 14             	mov    %eax,0x14(%ebp)
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	83 e8 04             	sub    $0x4,%eax
  80072f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800731:	85 db                	test   %ebx,%ebx
  800733:	79 02                	jns    800737 <vprintfmt+0x337>
				err = -err;
  800735:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800737:	83 fb 0e             	cmp    $0xe,%ebx
  80073a:	7f 0b                	jg     800747 <vprintfmt+0x347>
  80073c:	8b 34 9d 00 30 80 00 	mov    0x803000(,%ebx,4),%esi
  800743:	85 f6                	test   %esi,%esi
  800745:	75 23                	jne    80076a <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  800747:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80074b:	c7 44 24 08 71 30 80 	movl   $0x803071,0x8(%esp)
  800752:	00 
  800753:	8b 45 0c             	mov    0xc(%ebp),%eax
  800756:	89 44 24 04          	mov    %eax,0x4(%esp)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	89 04 24             	mov    %eax,(%esp)
  800760:	e8 86 02 00 00       	call   8009eb <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800765:	e9 73 02 00 00       	jmp    8009dd <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80076a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80076e:	c7 44 24 08 7a 30 80 	movl   $0x80307a,0x8(%esp)
  800775:	00 
  800776:	8b 45 0c             	mov    0xc(%ebp),%eax
  800779:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	89 04 24             	mov    %eax,(%esp)
  800783:	e8 63 02 00 00       	call   8009eb <printfmt>
			break;
  800788:	e9 50 02 00 00       	jmp    8009dd <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	83 c0 04             	add    $0x4,%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	83 e8 04             	sub    $0x4,%eax
  80079c:	8b 30                	mov    (%eax),%esi
  80079e:	85 f6                	test   %esi,%esi
  8007a0:	75 05                	jne    8007a7 <vprintfmt+0x3a7>
				p = "(null)";
  8007a2:	be 7d 30 80 00       	mov    $0x80307d,%esi
			if (width > 0 && padc != '-')
  8007a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ab:	7e 73                	jle    800820 <vprintfmt+0x420>
  8007ad:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007b1:	74 6d                	je     800820 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ba:	89 34 24             	mov    %esi,(%esp)
  8007bd:	e8 4c 03 00 00       	call   800b0e <strnlen>
  8007c2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007c5:	eb 17                	jmp    8007de <vprintfmt+0x3de>
					putch(padc, putdat);
  8007c7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007d2:	89 04 24             	mov    %eax,(%esp)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007da:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e2:	7f e3                	jg     8007c7 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e4:	eb 3a                	jmp    800820 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  8007e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007ea:	74 1f                	je     80080b <vprintfmt+0x40b>
  8007ec:	83 fb 1f             	cmp    $0x1f,%ebx
  8007ef:	7e 05                	jle    8007f6 <vprintfmt+0x3f6>
  8007f1:	83 fb 7e             	cmp    $0x7e,%ebx
  8007f4:	7e 15                	jle    80080b <vprintfmt+0x40b>
					putch('?', putdat);
  8007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007fd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	ff d0                	call   *%eax
  800809:	eb 0f                	jmp    80081a <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  80080b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800812:	89 1c 24             	mov    %ebx,(%esp)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80081e:	eb 01                	jmp    800821 <vprintfmt+0x421>
  800820:	90                   	nop
  800821:	0f b6 06             	movzbl (%esi),%eax
  800824:	0f be d8             	movsbl %al,%ebx
  800827:	85 db                	test   %ebx,%ebx
  800829:	0f 95 c0             	setne  %al
  80082c:	83 c6 01             	add    $0x1,%esi
  80082f:	84 c0                	test   %al,%al
  800831:	74 29                	je     80085c <vprintfmt+0x45c>
  800833:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800837:	78 ad                	js     8007e6 <vprintfmt+0x3e6>
  800839:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80083d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800841:	79 a3                	jns    8007e6 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800843:	eb 17                	jmp    80085c <vprintfmt+0x45c>
				putch(' ', putdat);
  800845:	8b 45 0c             	mov    0xc(%ebp),%eax
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800858:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80085c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800860:	7f e3                	jg     800845 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  800862:	e9 76 01 00 00       	jmp    8009dd <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086e:	8d 45 14             	lea    0x14(%ebp),%eax
  800871:	89 04 24             	mov    %eax,(%esp)
  800874:	e8 20 fb ff ff       	call   800399 <getint>
  800879:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800885:	85 d2                	test   %edx,%edx
  800887:	79 26                	jns    8008af <vprintfmt+0x4af>
				putch('-', putdat);
  800889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800890:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	ff d0                	call   *%eax
				num = -(long long) num;
  80089c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a2:	f7 d8                	neg    %eax
  8008a4:	83 d2 00             	adc    $0x0,%edx
  8008a7:	f7 da                	neg    %edx
  8008a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008af:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008b6:	e9 ae 00 00 00       	jmp    800969 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c5:	89 04 24             	mov    %eax,(%esp)
  8008c8:	e8 65 fa ff ff       	call   800332 <getuint>
  8008cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008da:	e9 8a 00 00 00       	jmp    800969 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  8008df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e9:	89 04 24             	mov    %eax,(%esp)
  8008ec:	e8 41 fa ff ff       	call   800332 <getuint>
  8008f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  8008f7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  8008fe:	eb 69                	jmp    800969 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	89 44 24 04          	mov    %eax,0x4(%esp)
  800907:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	ff d0                	call   *%eax
			putch('x', putdat);
  800913:	8b 45 0c             	mov    0xc(%ebp),%eax
  800916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 c0 04             	add    $0x4,%eax
  80092c:	89 45 14             	mov    %eax,0x14(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800937:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800941:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800948:	eb 1f                	jmp    800969 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80094a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80094d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800951:	8d 45 14             	lea    0x14(%ebp),%eax
  800954:	89 04 24             	mov    %eax,(%esp)
  800957:	e8 d6 f9 ff ff       	call   800332 <getuint>
  80095c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800962:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800969:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80096d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800970:	89 54 24 18          	mov    %edx,0x18(%esp)
  800974:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800977:	89 54 24 14          	mov    %edx,0x14(%esp)
  80097b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80097f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800985:	89 44 24 08          	mov    %eax,0x8(%esp)
  800989:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	89 44 24 04          	mov    %eax,0x4(%esp)
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	89 04 24             	mov    %eax,(%esp)
  80099a:	e8 b5 f8 ff ff       	call   800254 <printnum>
			break;
  80099f:	eb 3c                	jmp    8009dd <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a8:	89 1c 24             	mov    %ebx,(%esp)
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	ff d0                	call   *%eax
			break;
  8009b0:	eb 2b                	jmp    8009dd <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009c9:	eb 04                	jmp    8009cf <vprintfmt+0x5cf>
  8009cb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d2:	83 e8 01             	sub    $0x1,%eax
  8009d5:	0f b6 00             	movzbl (%eax),%eax
  8009d8:	3c 25                	cmp    $0x25,%al
  8009da:	75 ef                	jne    8009cb <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  8009dc:	90                   	nop
		}
	}
  8009dd:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009de:	e9 3e fa ff ff       	jmp    800421 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  8009e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009e4:	83 c4 50             	add    $0x50,%esp
  8009e7:	5b                   	pop    %ebx
  8009e8:	5e                   	pop    %esi
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    

008009eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  8009f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8009f4:	83 c0 04             	add    $0x4,%eax
  8009f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a00:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a04:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	89 04 24             	mov    %eax,(%esp)
  800a15:	e8 e6 f9 ff ff       	call   800400 <vprintfmt>
	va_end(ap);
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a22:	8b 40 08             	mov    0x8(%eax),%eax
  800a25:	8d 50 01             	lea    0x1(%eax),%edx
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	8b 10                	mov    (%eax),%edx
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	8b 40 04             	mov    0x4(%eax),%eax
  800a39:	39 c2                	cmp    %eax,%edx
  800a3b:	73 12                	jae    800a4f <sprintputch+0x33>
		*b->buf++ = ch;
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a40:	8b 00                	mov    (%eax),%eax
  800a42:	8b 55 08             	mov    0x8(%ebp),%edx
  800a45:	88 10                	mov    %dl,(%eax)
  800a47:	8d 50 01             	lea    0x1(%eax),%edx
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	89 10                	mov    %edx,(%eax)
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	83 e8 01             	sub    $0x1,%eax
  800a63:	03 45 08             	add    0x8(%ebp),%eax
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a74:	74 06                	je     800a7c <vsnprintf+0x2b>
  800a76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7a:	7f 07                	jg     800a83 <vsnprintf+0x32>
		return -E_INVAL;
  800a7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a81:	eb 2a                	jmp    800aad <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a91:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a98:	c7 04 24 1c 0a 80 00 	movl   $0x800a1c,(%esp)
  800a9f:	e8 5c f9 ff ff       	call   800400 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aad:	c9                   	leave  
  800aae:	c3                   	ret    

00800aaf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab8:	83 c0 04             	add    $0x4,%eax
  800abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	89 04 24             	mov    %eax,(%esp)
  800ad9:	e8 73 ff ff ff       	call   800a51 <vsnprintf>
  800ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    
	...

00800ae8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800af5:	eb 08                	jmp    800aff <strlen+0x17>
		n++;
  800af7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800afb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	0f b6 00             	movzbl (%eax),%eax
  800b05:	84 c0                	test   %al,%al
  800b07:	75 ee                	jne    800af7 <strlen+0xf>
		n++;
	return n;
  800b09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1b:	eb 0c                	jmp    800b29 <strnlen+0x1b>
		n++;
  800b1d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b21:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b25:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800b29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2d:	74 0a                	je     800b39 <strnlen+0x2b>
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	0f b6 00             	movzbl (%eax),%eax
  800b35:	84 c0                	test   %al,%al
  800b37:	75 e4                	jne    800b1d <strnlen+0xf>
		n++;
	return n;
  800b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b4a:	90                   	nop
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	0f b6 10             	movzbl (%eax),%edx
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	88 10                	mov    %dl,(%eax)
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	0f b6 00             	movzbl (%eax),%eax
  800b5c:	84 c0                	test   %al,%al
  800b5e:	0f 95 c0             	setne  %al
  800b61:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b65:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800b69:	84 c0                	test   %al,%al
  800b6b:	75 de                	jne    800b4b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b70:	c9                   	leave  
  800b71:	c3                   	ret    

00800b72 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b85:	eb 21                	jmp    800ba8 <strncpy+0x36>
		*dst++ = *src;
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	0f b6 10             	movzbl (%eax),%edx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	88 10                	mov    %dl,(%eax)
  800b92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	0f b6 00             	movzbl (%eax),%eax
  800b9c:	84 c0                	test   %al,%al
  800b9e:	74 04                	je     800ba4 <strncpy+0x32>
			src++;
  800ba0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bab:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bae:	72 d7                	jb     800b87 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc5:	74 2f                	je     800bf6 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800bc7:	eb 13                	jmp    800bdc <strlcpy+0x27>
			*dst++ = *src++;
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	0f b6 10             	movzbl (%eax),%edx
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	88 10                	mov    %dl,(%eax)
  800bd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bd8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bdc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800be0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be4:	74 0a                	je     800bf0 <strlcpy+0x3b>
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	0f b6 00             	movzbl (%eax),%eax
  800bec:	84 c0                	test   %al,%al
  800bee:	75 d9                	jne    800bc9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfc:	89 d1                	mov    %edx,%ecx
  800bfe:	29 c1                	sub    %eax,%ecx
  800c00:	89 c8                	mov    %ecx,%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c07:	eb 08                	jmp    800c11 <strcmp+0xd>
		p++, q++;
  800c09:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c0d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	0f b6 00             	movzbl (%eax),%eax
  800c17:	84 c0                	test   %al,%al
  800c19:	74 10                	je     800c2b <strcmp+0x27>
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	0f b6 10             	movzbl (%eax),%edx
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	0f b6 00             	movzbl (%eax),%eax
  800c27:	38 c2                	cmp    %al,%dl
  800c29:	74 de                	je     800c09 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	0f b6 00             	movzbl (%eax),%eax
  800c31:	0f b6 d0             	movzbl %al,%edx
  800c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c37:	0f b6 00             	movzbl (%eax),%eax
  800c3a:	0f b6 c0             	movzbl %al,%eax
  800c3d:	89 d1                	mov    %edx,%ecx
  800c3f:	29 c1                	sub    %eax,%ecx
  800c41:	89 c8                	mov    %ecx,%eax
}
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c48:	eb 0c                	jmp    800c56 <strncmp+0x11>
		n--, p++, q++;
  800c4a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c4e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c52:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5a:	74 1a                	je     800c76 <strncmp+0x31>
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	0f b6 00             	movzbl (%eax),%eax
  800c62:	84 c0                	test   %al,%al
  800c64:	74 10                	je     800c76 <strncmp+0x31>
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	0f b6 10             	movzbl (%eax),%edx
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	0f b6 00             	movzbl (%eax),%eax
  800c72:	38 c2                	cmp    %al,%dl
  800c74:	74 d4                	je     800c4a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7a:	75 07                	jne    800c83 <strncmp+0x3e>
		return 0;
  800c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c81:	eb 18                	jmp    800c9b <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	0f b6 00             	movzbl (%eax),%eax
  800c89:	0f b6 d0             	movzbl %al,%edx
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	0f b6 00             	movzbl (%eax),%eax
  800c92:	0f b6 c0             	movzbl %al,%eax
  800c95:	89 d1                	mov    %edx,%ecx
  800c97:	29 c1                	sub    %eax,%ecx
  800c99:	89 c8                	mov    %ecx,%eax
}
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	83 ec 04             	sub    $0x4,%esp
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca9:	eb 14                	jmp    800cbf <strchr+0x22>
		if (*s == c)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	0f b6 00             	movzbl (%eax),%eax
  800cb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb4:	75 05                	jne    800cbb <strchr+0x1e>
			return (char *) s;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	eb 13                	jmp    800cce <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cbb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	0f b6 00             	movzbl (%eax),%eax
  800cc5:	84 c0                	test   %al,%al
  800cc7:	75 e2                	jne    800cab <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 04             	sub    $0x4,%esp
  800cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cdc:	eb 0f                	jmp    800ced <strfind+0x1d>
		if (*s == c)
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	0f b6 00             	movzbl (%eax),%eax
  800ce4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ce7:	74 10                	je     800cf9 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ce9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	0f b6 00             	movzbl (%eax),%eax
  800cf3:	84 c0                	test   %al,%al
  800cf5:	75 e7                	jne    800cde <strfind+0xe>
  800cf7:	eb 01                	jmp    800cfa <strfind+0x2a>
		if (*s == c)
			break;
  800cf9:	90                   	nop
	return (char *) s;
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <memset>:


void *
memset(void *v, int c, size_t n)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d11:	eb 0e                	jmp    800d21 <memset+0x22>
		*p++ = c;
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 c2                	mov    %eax,%edx
  800d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1b:	88 10                	mov    %dl,(%eax)
  800d1d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d21:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800d25:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d29:	79 e8                	jns    800d13 <memset+0x14>
		*p++ = c;

	return v;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d45:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d48:	73 54                	jae    800d9e <memmove+0x6e>
  800d4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d50:	01 d0                	add    %edx,%eax
  800d52:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d55:	76 47                	jbe    800d9e <memmove+0x6e>
		s += n;
  800d57:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d63:	eb 13                	jmp    800d78 <memmove+0x48>
			*--d = *--s;
  800d65:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800d69:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d70:	0f b6 10             	movzbl (%eax),%edx
  800d73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d76:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7c:	0f 95 c0             	setne  %al
  800d7f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d83:	84 c0                	test   %al,%al
  800d85:	75 de                	jne    800d65 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d87:	eb 25                	jmp    800dae <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8c:	0f b6 10             	movzbl (%eax),%edx
  800d8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d92:	88 10                	mov    %dl,(%eax)
  800d94:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800d98:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800d9c:	eb 01                	jmp    800d9f <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d9e:	90                   	nop
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	0f 95 c0             	setne  %al
  800da6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800daa:	84 c0                	test   %al,%al
  800dac:	75 db                	jne    800d89 <memmove+0x59>
			*d++ = *s++;

	return dst;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	89 04 24             	mov    %eax,(%esp)
  800dcd:	e8 5e ff ff ff       	call   800d30 <memmove>
}
  800dd2:	c9                   	leave  
  800dd3:	c3                   	ret    

00800dd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800de6:	eb 32                	jmp    800e1a <memcmp+0x46>
		if (*s1 != *s2)
  800de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800deb:	0f b6 10             	movzbl (%eax),%edx
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	0f b6 00             	movzbl (%eax),%eax
  800df4:	38 c2                	cmp    %al,%dl
  800df6:	74 1a                	je     800e12 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfb:	0f b6 00             	movzbl (%eax),%eax
  800dfe:	0f b6 d0             	movzbl %al,%edx
  800e01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e04:	0f b6 00             	movzbl (%eax),%eax
  800e07:	0f b6 c0             	movzbl %al,%eax
  800e0a:	89 d1                	mov    %edx,%ecx
  800e0c:	29 c1                	sub    %eax,%ecx
  800e0e:	89 c8                	mov    %ecx,%eax
  800e10:	eb 1c                	jmp    800e2e <memcmp+0x5a>
		s1++, s2++;
  800e12:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e16:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1e:	0f 95 c0             	setne  %al
  800e21:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e25:	84 c0                	test   %al,%al
  800e27:	75 bf                	jne    800de8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	01 d0                	add    %edx,%eax
  800e3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e41:	eb 11                	jmp    800e54 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	0f b6 10             	movzbl (%eax),%edx
  800e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4c:	38 c2                	cmp    %al,%dl
  800e4e:	74 0e                	je     800e5e <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e50:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e5a:	72 e7                	jb     800e43 <memfind+0x13>
  800e5c:	eb 01                	jmp    800e5f <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e5e:	90                   	nop
	return (void *) s;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e78:	eb 04                	jmp    800e7e <strtol+0x1a>
		s++;
  800e7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	0f b6 00             	movzbl (%eax),%eax
  800e84:	3c 20                	cmp    $0x20,%al
  800e86:	74 f2                	je     800e7a <strtol+0x16>
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	0f b6 00             	movzbl (%eax),%eax
  800e8e:	3c 09                	cmp    $0x9,%al
  800e90:	74 e8                	je     800e7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	0f b6 00             	movzbl (%eax),%eax
  800e98:	3c 2b                	cmp    $0x2b,%al
  800e9a:	75 06                	jne    800ea2 <strtol+0x3e>
		s++;
  800e9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ea0:	eb 15                	jmp    800eb7 <strtol+0x53>
	else if (*s == '-')
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	0f b6 00             	movzbl (%eax),%eax
  800ea8:	3c 2d                	cmp    $0x2d,%al
  800eaa:	75 0b                	jne    800eb7 <strtol+0x53>
		s++, neg = 1;
  800eac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800eb0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebb:	74 06                	je     800ec3 <strtol+0x5f>
  800ebd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ec1:	75 24                	jne    800ee7 <strtol+0x83>
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	0f b6 00             	movzbl (%eax),%eax
  800ec9:	3c 30                	cmp    $0x30,%al
  800ecb:	75 1a                	jne    800ee7 <strtol+0x83>
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	83 c0 01             	add    $0x1,%eax
  800ed3:	0f b6 00             	movzbl (%eax),%eax
  800ed6:	3c 78                	cmp    $0x78,%al
  800ed8:	75 0d                	jne    800ee7 <strtol+0x83>
		s += 2, base = 16;
  800eda:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ede:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ee5:	eb 2a                	jmp    800f11 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  800ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eeb:	75 17                	jne    800f04 <strtol+0xa0>
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	0f b6 00             	movzbl (%eax),%eax
  800ef3:	3c 30                	cmp    $0x30,%al
  800ef5:	75 0d                	jne    800f04 <strtol+0xa0>
		s++, base = 8;
  800ef7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800efb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f02:	eb 0d                	jmp    800f11 <strtol+0xad>
	else if (base == 0)
  800f04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f08:	75 07                	jne    800f11 <strtol+0xad>
		base = 10;
  800f0a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	0f b6 00             	movzbl (%eax),%eax
  800f17:	3c 2f                	cmp    $0x2f,%al
  800f19:	7e 1b                	jle    800f36 <strtol+0xd2>
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	0f b6 00             	movzbl (%eax),%eax
  800f21:	3c 39                	cmp    $0x39,%al
  800f23:	7f 11                	jg     800f36 <strtol+0xd2>
			dig = *s - '0';
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	0f b6 00             	movzbl (%eax),%eax
  800f2b:	0f be c0             	movsbl %al,%eax
  800f2e:	83 e8 30             	sub    $0x30,%eax
  800f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f34:	eb 48                	jmp    800f7e <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	0f b6 00             	movzbl (%eax),%eax
  800f3c:	3c 60                	cmp    $0x60,%al
  800f3e:	7e 1b                	jle    800f5b <strtol+0xf7>
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	0f b6 00             	movzbl (%eax),%eax
  800f46:	3c 7a                	cmp    $0x7a,%al
  800f48:	7f 11                	jg     800f5b <strtol+0xf7>
			dig = *s - 'a' + 10;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	0f b6 00             	movzbl (%eax),%eax
  800f50:	0f be c0             	movsbl %al,%eax
  800f53:	83 e8 57             	sub    $0x57,%eax
  800f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f59:	eb 23                	jmp    800f7e <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	0f b6 00             	movzbl (%eax),%eax
  800f61:	3c 40                	cmp    $0x40,%al
  800f63:	7e 38                	jle    800f9d <strtol+0x139>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	0f b6 00             	movzbl (%eax),%eax
  800f6b:	3c 5a                	cmp    $0x5a,%al
  800f6d:	7f 2e                	jg     800f9d <strtol+0x139>
			dig = *s - 'A' + 10;
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	0f b6 00             	movzbl (%eax),%eax
  800f75:	0f be c0             	movsbl %al,%eax
  800f78:	83 e8 37             	sub    $0x37,%eax
  800f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f81:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f84:	7d 16                	jge    800f9c <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  800f86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f91:	03 45 f4             	add    -0xc(%ebp),%eax
  800f94:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f97:	e9 75 ff ff ff       	jmp    800f11 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f9c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa1:	74 08                	je     800fab <strtol+0x147>
		*endptr = (char *) s;
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800faf:	74 07                	je     800fb8 <strtol+0x154>
  800fb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb4:	f7 d8                	neg    %eax
  800fb6:	eb 03                	jmp    800fbb <strtol+0x157>
  800fb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    
  800fbd:	00 00                	add    %al,(%eax)
	...

00800fc0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
  800fc6:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800fcf:	8b 55 10             	mov    0x10(%ebp),%edx
  800fd2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800fd5:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800fd8:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800fdb:	8b 75 20             	mov    0x20(%ebp),%esi
  800fde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fe1:	cd 30                	int    $0x30
  800fe3:	89 c3                	mov    %eax,%ebx
  800fe5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fe8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fec:	74 30                	je     80101e <syscall+0x5e>
  800fee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff2:	7e 2a                	jle    80101e <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ff7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801002:	c7 44 24 08 dc 31 80 	movl   $0x8031dc,0x8(%esp)
  801009:	00 
  80100a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801011:	00 
  801012:	c7 04 24 f9 31 80 00 	movl   $0x8031f9,(%esp)
  801019:	e8 9a 1a 00 00       	call   802ab8 <_panic>

	return ret;
  80101e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801021:	83 c4 4c             	add    $0x4c,%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801039:	00 
  80103a:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801041:	00 
  801042:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801049:	00 
  80104a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801051:	89 44 24 08          	mov    %eax,0x8(%esp)
  801055:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80105c:	00 
  80105d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801064:	e8 57 ff ff ff       	call   800fc0 <syscall>
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <sys_cgetc>:

int
sys_cgetc(void)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801071:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801078:	00 
  801079:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801080:	00 
  801081:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801088:	00 
  801089:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801090:	00 
  801091:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801098:	00 
  801099:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010a0:	00 
  8010a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8010a8:	e8 13 ff ff ff       	call   800fc0 <syscall>
}
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8010bf:	00 
  8010c0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8010c7:	00 
  8010c8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8010cf:	00 
  8010d0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8010d7:	00 
  8010d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010e3:	00 
  8010e4:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8010eb:	e8 d0 fe ff ff       	call   800fc0 <syscall>
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8010f8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8010ff:	00 
  801100:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801107:	00 
  801108:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80110f:	00 
  801110:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801117:	00 
  801118:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80111f:	00 
  801120:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801127:	00 
  801128:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80112f:	e8 8c fe ff ff       	call   800fc0 <syscall>
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <sys_yield>:

void
sys_yield(void)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80113c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801143:	00 
  801144:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80114b:	00 
  80114c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801153:	00 
  801154:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80115b:	00 
  80115c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801163:	00 
  801164:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80116b:	00 
  80116c:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  801173:	e8 48 fe ff ff       	call   800fc0 <syscall>
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801180:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801183:	8b 55 0c             	mov    0xc(%ebp),%edx
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801190:	00 
  801191:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801198:	00 
  801199:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80119d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011ac:	00 
  8011ad:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8011b4:	e8 07 fe ff ff       	call   800fc0 <syscall>
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	56                   	push   %esi
  8011bf:	53                   	push   %ebx
  8011c0:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8011c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8011c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	89 74 24 18          	mov    %esi,0x18(%esp)
  8011d6:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8011da:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8011de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011ed:	00 
  8011ee:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8011f5:	e8 c6 fd ff ff       	call   800fc0 <syscall>
}
  8011fa:	83 c4 20             	add    $0x20,%esp
  8011fd:	5b                   	pop    %ebx
  8011fe:	5e                   	pop    %esi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  801207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801214:	00 
  801215:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80121c:	00 
  80121d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801224:	00 
  801225:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801229:	89 44 24 08          	mov    %eax,0x8(%esp)
  80122d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801234:	00 
  801235:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  80123c:	e8 7f fd ff ff       	call   800fc0 <syscall>
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801256:	00 
  801257:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80125e:	00 
  80125f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801266:	00 
  801267:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80126b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80126f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801276:	00 
  801277:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  80127e:	e8 3d fd ff ff       	call   800fc0 <syscall>
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80128b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801298:	00 
  801299:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012a0:	00 
  8012a1:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012a8:	00 
  8012a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012b8:	00 
  8012b9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8012c0:	e8 fb fc ff ff       	call   800fc0 <syscall>
}
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8012cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012da:	00 
  8012db:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012e2:	00 
  8012e3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012ea:	00 
  8012eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012fa:	00 
  8012fb:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  801302:	e8 b9 fc ff ff       	call   800fc0 <syscall>
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80130f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80131c:	00 
  80131d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801324:	00 
  801325:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80132c:	00 
  80132d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801331:	89 44 24 08          	mov    %eax,0x8(%esp)
  801335:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80133c:	00 
  80133d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801344:	e8 77 fc ff ff       	call   800fc0 <syscall>
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801351:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801354:	8b 55 10             	mov    0x10(%ebp),%edx
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801361:	00 
  801362:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  801366:	89 54 24 10          	mov    %edx,0x10(%esp)
  80136a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801371:	89 44 24 08          	mov    %eax,0x8(%esp)
  801375:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80137c:	00 
  80137d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  801384:	e8 37 fc ff ff       	call   800fc0 <syscall>
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80139b:	00 
  80139c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013a3:	00 
  8013a4:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013ab:	00 
  8013ac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013b3:	00 
  8013b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013bf:	00 
  8013c0:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  8013c7:	e8 f4 fb ff ff       	call   800fc0 <syscall>
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    
	...

008013d0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 38             	sub    $0x38,%esp
	void *addr = (void *) utf->utf_fault_va;
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8b 00                	mov    (%eax),%eax
  8013db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t err = utf->utf_err;
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8b 40 04             	mov    0x4(%eax),%eax
  8013e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	// LAB 4: Your code here.
	//FEC_WR pf caused by a write
	//
	//if((err & FEC_WR)==0) cprintf("err : %08x\n", err);
	//if((vpt[VPN(addr)] & PTE_COW) == 0) cprintf("pte : %x\n", vpt[VPN(addr)]);
    if((err & FEC_WR) == 0 || (vpd[VPD(addr)] & PTE_P) == 0 || (vpt[VPN(addr)] & PTE_COW) == 0){
  8013e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ea:	83 e0 02             	and    $0x2,%eax
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	74 2a                	je     80141b <pgfault+0x4b>
  8013f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f4:	c1 e8 16             	shr    $0x16,%eax
  8013f7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013fe:	83 e0 01             	and    $0x1,%eax
  801401:	85 c0                	test   %eax,%eax
  801403:	74 16                	je     80141b <pgfault+0x4b>
  801405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801408:	c1 e8 0c             	shr    $0xc,%eax
  80140b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801412:	25 00 08 00 00       	and    $0x800,%eax
  801417:	85 c0                	test   %eax,%eax
  801419:	75 1c                	jne    801437 <pgfault+0x67>
		//cprintf("\n%e %e %e\n",(err & FEC_WR), (vpd[VPD(addr)] & PTE_P), (vpt[VPN(addr)] & PTE_COW));
		panic("pgfault: not a write or attempting to access a non_COW page\n");
  80141b:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  801422:	00 
  801423:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80142a:	00 
  80142b:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801432:	e8 81 16 00 00       	call   802ab8 <_panic>
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((r = sys_page_alloc(0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0){
  801437:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80143e:	00 
  80143f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801446:	00 
  801447:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80144e:	e8 27 fd ff ff       	call   80117a <sys_page_alloc>
  801453:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80145a:	79 23                	jns    80147f <pgfault+0xaf>
		panic("pgfault page allocation failed : %e\n", r);
  80145c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801463:	c7 44 24 08 50 32 80 	movl   $0x803250,0x8(%esp)
  80146a:	00 
  80146b:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801472:	00 
  801473:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  80147a:	e8 39 16 00 00       	call   802ab8 <_panic>
	}
	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80147f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801482:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801488:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80148d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	memmove(PFTEMP, addr, PGSIZE);
  801490:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801497:	00 
  801498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8014a6:	e8 85 f8 ff ff       	call   800d30 <memmove>
	
	if((r = sys_page_map(0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0){
  8014ab:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014b2:	00 
  8014b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014c1:	00 
  8014c2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014c9:	00 
  8014ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014d1:	e8 e5 fc ff ff       	call   8011bb <sys_page_map>
  8014d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014dd:	79 23                	jns    801502 <pgfault+0x132>
		panic("pgfault: page mapping failed %e\n", r);
  8014df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014e6:	c7 44 24 08 78 32 80 	movl   $0x803278,0x8(%esp)
  8014ed:	00 
  8014ee:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8014f5:	00 
  8014f6:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  8014fd:	e8 b6 15 00 00       	call   802ab8 <_panic>
	}
	//panic("pgfault not implemented");
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
// COW's copy
static int
duppage(envid_t envid, unsigned pn)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 38             	sub    $0x38,%esp
	int r;
	void *addr;
	pte_t pte;
    addr = (void *)((uint32_t)pn * PGSIZE);
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	c1 e0 0c             	shl    $0xc,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pte = vpt[VPN(addr)];//the pt
  801513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801516:	c1 e8 0c             	shr    $0xc,%eax
  801519:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801520:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    if((pte & PTE_W) > 0||(pte & PTE_COW) > 0){
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	83 e0 02             	and    $0x2,%eax
  801529:	85 c0                	test   %eax,%eax
  80152b:	75 10                	jne    80153d <duppage+0x39>
  80152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801530:	25 00 08 00 00       	and    $0x800,%eax
  801535:	85 c0                	test   %eax,%eax
  801537:	0f 84 9d 00 00 00    	je     8015da <duppage+0xd6>
		//two change ok
		if((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0){
  80153d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801544:	00 
  801545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801548:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801561:	e8 55 fc ff ff       	call   8011bb <sys_page_map>
  801566:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801569:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80156d:	79 1c                	jns    80158b <duppage+0x87>
			panic("sys page map envid --> 0 failed ,parent copy to child\n");
  80156f:	c7 44 24 08 9c 32 80 	movl   $0x80329c,0x8(%esp)
  801576:	00 
  801577:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80157e:	00 
  80157f:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801586:	e8 2d 15 00 00       	call   802ab8 <_panic>
			}
		if((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0){
  80158b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801592:	00 
  801593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801596:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80159a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015a1:	00 
  8015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b0:	e8 06 fc ff ff       	call   8011bb <sys_page_map>
  8015b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015bc:	79 6a                	jns    801628 <duppage+0x124>
			panic("sys page map 0 --> 0 failed ,parent copy it self\n");
  8015be:	c7 44 24 08 d4 32 80 	movl   $0x8032d4,0x8(%esp)
  8015c5:	00 
  8015c6:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8015cd:	00 
  8015ce:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  8015d5:	e8 de 14 00 00       	call   802ab8 <_panic>
			}
	}
	else{//the read, can't change  |PTE_COW
		if((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U)) < 0){
  8015da:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8015e1:	00 
  8015e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015fe:	e8 b8 fb ff ff       	call   8011bb <sys_page_map>
  801603:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801606:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160a:	79 1c                	jns    801628 <duppage+0x124>
			panic("sys page map envid --> 0 failed ,parent copy to child\n");
  80160c:	c7 44 24 08 9c 32 80 	movl   $0x80329c,0x8(%esp)
  801613:	00 
  801614:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  80161b:	00 
  80161c:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801623:	e8 90 14 00 00       	call   802ab8 <_panic>
			}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  801628:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	53                   	push   %ebx
  801633:	83 ec 34             	sub    $0x34,%esp
	// LAB 4: Your code here.
	//
	//set_pgfault_handler
	set_pgfault_handler(pgfault);
  801636:	c7 04 24 d0 13 80 00 	movl   $0x8013d0,(%esp)
  80163d:	e8 ea 14 00 00       	call   802b2c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801642:	c7 45 e4 07 00 00 00 	movl   $0x7,-0x1c(%ebp)
  801649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80164c:	cd 30                	int    $0x30
  80164e:	89 c3                	mov    %eax,%ebx
  801650:	89 5d e8             	mov    %ebx,-0x18(%ebp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801653:	8b 45 e8             	mov    -0x18(%ebp),%eax
	//new a child
	envid_t newenv;
	uint32_t addr;
	int r;
	
	newenv = sys_exofork();//new envid
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("finish create a env %d\n", newenv);
	if(newenv < 0) panic("envid < 0 ,failed in exofork\n");
  801659:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80165d:	79 1c                	jns    80167b <fork+0x4c>
  80165f:	c7 44 24 08 06 33 80 	movl   $0x803306,0x8(%esp)
  801666:	00 
  801667:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80166e:	00 
  80166f:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801676:	e8 3d 14 00 00       	call   802ab8 <_panic>
	if(newenv == 0){
  80167b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80167f:	75 21                	jne    8016a2 <fork+0x73>
		//ENVX get the id's low 10 bit
		env = &envs[ENVX(sys_getenvid())];
  801681:	e8 6c fa ff ff       	call   8010f2 <sys_getenvid>
  801686:	25 ff 03 00 00       	and    $0x3ff,%eax
  80168b:	c1 e0 07             	shl    $0x7,%eax
  80168e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801693:	a3 40 60 80 00       	mov    %eax,0x806040
		return 0;
  801698:	b8 00 00 00 00       	mov    $0x0,%eax
  80169d:	e9 f8 00 00 00       	jmp    80179a <fork+0x16b>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  8016a2:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8016a9:	eb 58                	jmp    801703 <fork+0xd4>
		/*pte = vpt[VPN(addr)];
		pde = vpd[VPD(addr)];
		if((pde & PTE_P) > 0 && (pte & PTE_P) > 0 && (pte & PTE_U) > 0){
			duppage(newenv, VPN(addr));
			}*/
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
  8016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ae:	c1 e8 16             	shr    $0x16,%eax
  8016b1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016b8:	83 e0 01             	and    $0x1,%eax
  8016bb:	84 c0                	test   %al,%al
  8016bd:	74 3d                	je     8016fc <fork+0xcd>
  8016bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c2:	c1 e8 0c             	shr    $0xc,%eax
  8016c5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016cc:	83 e0 01             	and    $0x1,%eax
  8016cf:	84 c0                	test   %al,%al
  8016d1:	74 29                	je     8016fc <fork+0xcd>
  8016d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d6:	c1 e8 0c             	shr    $0xc,%eax
  8016d9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016e0:	83 e0 04             	and    $0x4,%eax
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	74 15                	je     8016fc <fork+0xcd>
	        duppage (newenv, VPN(addr));
  8016e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ea:	c1 e8 0c             	shr    $0xc,%eax
  8016ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f4:	89 04 24             	mov    %eax,(%esp)
  8016f7:	e8 08 fe ff ff       	call   801504 <duppage>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  8016fc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801703:	81 7d f4 ff ef bf ee 	cmpl   $0xeebfefff,-0xc(%ebp)
  80170a:	76 9f                	jbe    8016ab <fork+0x7c>
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
	        duppage (newenv, VPN(addr));
		}
	//cprintf("finish map PGSIZE\n");
	//user exception stack
	if((r = sys_page_alloc(newenv, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0){
  80170c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801713:	00 
  801714:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80171b:	ee 
  80171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171f:	89 04 24             	mov    %eax,(%esp)
  801722:	e8 53 fa ff ff       	call   80117a <sys_page_alloc>
  801727:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80172a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80172e:	79 1c                	jns    80174c <fork+0x11d>
		panic("fork alloc page failed\n");
  801730:	c7 44 24 08 24 33 80 	movl   $0x803324,0x8(%esp)
  801737:	00 
  801738:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  80173f:	00 
  801740:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801747:	e8 6c 13 00 00       	call   802ab8 <_panic>
		}
	//
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(newenv, _pgfault_upcall);
  80174c:	c7 44 24 04 c0 2b 80 	movl   $0x802bc0,0x4(%esp)
  801753:	00 
  801754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801757:	89 04 24             	mov    %eax,(%esp)
  80175a:	e8 aa fb ff ff       	call   801309 <sys_env_set_pgfault_upcall>
	//panic("fork not implemented");
	//set it runable
	if((r = sys_env_set_status(newenv, ENV_RUNNABLE)) < 0){
  80175f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801766:	00 
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	89 04 24             	mov    %eax,(%esp)
  80176d:	e8 13 fb ff ff       	call   801285 <sys_env_set_status>
  801772:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801775:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801779:	79 1c                	jns    801797 <fork+0x168>
		panic("set runnable failed\n");
  80177b:	c7 44 24 08 3c 33 80 	movl   $0x80333c,0x8(%esp)
  801782:	00 
  801783:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  80178a:	00 
  80178b:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801792:	e8 21 13 00 00       	call   802ab8 <_panic>
		}
	
	return newenv;
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80179a:	83 c4 34             	add    $0x34,%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <sduppage>:

// Challenge!

static int
sduppage(envid_t envid, unsigned pn, int need_cow)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 38             	sub    $0x38,%esp
	int r;
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	c1 e0 0c             	shl    $0xc,%eax
  8017ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	pte_t pte = vpt[VPN(addr)];
  8017af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b2:	c1 e8 0c             	shr    $0xc,%eax
  8017b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(need_cow || (pte & PTE_COW) > 0) {
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	75 10                	jne    8017d5 <sduppage+0x35>
  8017c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c8:	25 00 08 00 00       	and    $0x800,%eax
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	0f 84 af 00 00 00    	je     801884 <sduppage+0xe4>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8017d5:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8017dc:	00 
  8017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f9:	e8 bd f9 ff ff       	call   8011bb <sys_page_map>
  8017fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801801:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801805:	79 23                	jns    80182a <sduppage+0x8a>
		    panic ("duppage: page re-mapping failed at 1 : %e", r);
  801807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80180e:	c7 44 24 08 54 33 80 	movl   $0x803354,0x8(%esp)
  801815:	00 
  801816:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  80181d:	00 
  80181e:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801825:	e8 8e 12 00 00       	call   802ab8 <_panic>
        if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80182a:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801831:	00 
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801839:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801840:	00 
  801841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801844:	89 44 24 04          	mov    %eax,0x4(%esp)
  801848:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184f:	e8 67 f9 ff ff       	call   8011bb <sys_page_map>
  801854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801857:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80185b:	0f 89 d7 00 00 00    	jns    801938 <sduppage+0x198>
            panic ("duppage: page re-mapping failed at 2 : %e", r);
  801861:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801864:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801868:	c7 44 24 08 80 33 80 	movl   $0x803380,0x8(%esp)
  80186f:	00 
  801870:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801877:	00 
  801878:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  80187f:	e8 34 12 00 00       	call   802ab8 <_panic>
    }else if ((pte & PTE_W) > 0) {
  801884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801887:	83 e0 02             	and    $0x2,%eax
  80188a:	85 c0                	test   %eax,%eax
  80188c:	74 55                	je     8018e3 <sduppage+0x143>
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_W|PTE_P)) < 0)
  80188e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801895:	00 
  801896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801899:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b2:	e8 04 f9 ff ff       	call   8011bb <sys_page_map>
  8018b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018be:	79 78                	jns    801938 <sduppage+0x198>
		    panic ("duppage: page re-mapping failed at 3 : %e", r);
  8018c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018c7:	c7 44 24 08 ac 33 80 	movl   $0x8033ac,0x8(%esp)
  8018ce:	00 
  8018cf:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  8018d6:	00 
  8018d7:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  8018de:	e8 d5 11 00 00       	call   802ab8 <_panic>
    }else {
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8018e3:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8018ea:	00 
  8018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801900:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801907:	e8 af f8 ff ff       	call   8011bb <sys_page_map>
  80190c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80190f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801913:	79 23                	jns    801938 <sduppage+0x198>
		    panic ("duppage: page re-mapping failed at 4 : %e", r);
  801915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801918:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80191c:	c7 44 24 08 d8 33 80 	movl   $0x8033d8,0x8(%esp)
  801923:	00 
  801924:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  80192b:	00 
  80192c:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801933:	e8 80 11 00 00       	call   802ab8 <_panic>
    }
    return 0;
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sfork>:


int
sfork(void)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	53                   	push   %ebx
  801943:	83 ec 44             	sub    $0x44,%esp
	//panic("sfork not implemented");
	//set_pgfault_handler
	set_pgfault_handler(pgfault);
  801946:	c7 04 24 d0 13 80 00 	movl   $0x8013d0,(%esp)
  80194d:	e8 da 11 00 00       	call   802b2c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801952:	c7 45 d4 07 00 00 00 	movl   $0x7,-0x2c(%ebp)
  801959:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80195c:	cd 30                	int    $0x30
  80195e:	89 c3                	mov    %eax,%ebx
  801960:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	//new a child
	envid_t newenv;
	uint32_t addr;
	int r;
	
	newenv = sys_exofork();//new envid
  801966:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//cprintf("finish create a env %d\n", newenv);
	if(newenv < 0) panic("envid < 0 ,failed in exofork\n");
  801969:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80196d:	79 1c                	jns    80198b <sfork+0x4c>
  80196f:	c7 44 24 08 06 33 80 	movl   $0x803306,0x8(%esp)
  801976:	00 
  801977:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  80197e:	00 
  80197f:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801986:	e8 2d 11 00 00       	call   802ab8 <_panic>
	if(newenv == 0){
  80198b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80198f:	75 21                	jne    8019b2 <sfork+0x73>
		//ENVX get the id's low 10 bit
		env = &envs[ENVX(sys_getenvid())];
  801991:	e8 5c f7 ff ff       	call   8010f2 <sys_getenvid>
  801996:	25 ff 03 00 00       	and    $0x3ff,%eax
  80199b:	c1 e0 07             	shl    $0x7,%eax
  80199e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8019a3:	a3 40 60 80 00       	mov    %eax,0x806040
		return 0;
  8019a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ad:	e9 11 01 00 00       	jmp    801ac3 <sfork+0x184>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	int mark_COW = 1;
  8019b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  8019b9:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8019c0:	eb 6a                	jmp    801a2c <sfork+0xed>
		/*pte = vpt[VPN(addr)];
		pde = vpd[VPD(addr)];
		if((pde & PTE_P) > 0 && (pte & PTE_P) > 0 && (pte & PTE_U) > 0){
			duppage(newenv, VPN(addr));
			}*/
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
  8019c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c5:	c1 e8 16             	shr    $0x16,%eax
  8019c8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019cf:	83 e0 01             	and    $0x1,%eax
  8019d2:	84 c0                	test   %al,%al
  8019d4:	74 48                	je     801a1e <sfork+0xdf>
  8019d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d9:	c1 e8 0c             	shr    $0xc,%eax
  8019dc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019e3:	83 e0 01             	and    $0x1,%eax
  8019e6:	84 c0                	test   %al,%al
  8019e8:	74 34                	je     801a1e <sfork+0xdf>
  8019ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ed:	c1 e8 0c             	shr    $0xc,%eax
  8019f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019f7:	83 e0 04             	and    $0x4,%eax
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	74 20                	je     801a1e <sfork+0xdf>
	        sduppage (newenv, VPN(addr), mark_COW);
  8019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a01:	89 c2                	mov    %eax,%edx
  801a03:	c1 ea 0c             	shr    $0xc,%edx
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a0d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a14:	89 04 24             	mov    %eax,(%esp)
  801a17:	e8 84 fd ff ff       	call   8017a0 <sduppage>
  801a1c:	eb 07                	jmp    801a25 <sfork+0xe6>
		else mark_COW = 0;
  801a1e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	int mark_COW = 1;
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  801a25:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801a2c:	81 7d f4 ff ef bf ee 	cmpl   $0xeebfefff,-0xc(%ebp)
  801a33:	76 8d                	jbe    8019c2 <sfork+0x83>
	        sduppage (newenv, VPN(addr), mark_COW);
		else mark_COW = 0;
	}
	//cprintf("finish map PGSIZE\n");
	//user exception stack
	if((r = sys_page_alloc(newenv, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0){
  801a35:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a3c:	00 
  801a3d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801a44:	ee 
  801a45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a48:	89 04 24             	mov    %eax,(%esp)
  801a4b:	e8 2a f7 ff ff       	call   80117a <sys_page_alloc>
  801a50:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a57:	79 1c                	jns    801a75 <sfork+0x136>
		panic("fork alloc page failed\n");
  801a59:	c7 44 24 08 24 33 80 	movl   $0x803324,0x8(%esp)
  801a60:	00 
  801a61:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  801a68:	00 
  801a69:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801a70:	e8 43 10 00 00       	call   802ab8 <_panic>
		}
	//
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(newenv, _pgfault_upcall);
  801a75:	c7 44 24 04 c0 2b 80 	movl   $0x802bc0,0x4(%esp)
  801a7c:	00 
  801a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a80:	89 04 24             	mov    %eax,(%esp)
  801a83:	e8 81 f8 ff ff       	call   801309 <sys_env_set_pgfault_upcall>
	//panic("fork not implemented");
	//set it runable
	if((r = sys_env_set_status(newenv, ENV_RUNNABLE)) < 0){
  801a88:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a8f:	00 
  801a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a93:	89 04 24             	mov    %eax,(%esp)
  801a96:	e8 ea f7 ff ff       	call   801285 <sys_env_set_status>
  801a9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801aa2:	79 1c                	jns    801ac0 <sfork+0x181>
		panic("set runnable failed\n");
  801aa4:	c7 44 24 08 3c 33 80 	movl   $0x80333c,0x8(%esp)
  801aab:	00 
  801aac:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801ab3:	00 
  801ab4:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801abb:	e8 f8 0f 00 00       	call   802ab8 <_panic>
		}
	
	return newenv;
  801ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ac3:	83 c4 44             	add    $0x44,%esp
  801ac6:	5b                   	pop    %ebx
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    
  801ac9:	00 00                	add    %al,(%eax)
	...

00801acc <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  801ad2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ad6:	75 11                	jne    801ae9 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  801ad8:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  801adf:	e8 a7 f8 ff ff       	call   80138b <sys_ipc_recv>
  801ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ae7:	eb 0e                	jmp    801af7 <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  801ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aec:	89 04 24             	mov    %eax,(%esp)
  801aef:	e8 97 f8 ff ff       	call   80138b <sys_ipc_recv>
  801af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  801af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801afb:	79 1c                	jns    801b19 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  801afd:	c7 44 24 08 02 34 80 	movl   $0x803402,0x8(%esp)
  801b04:	00 
  801b05:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801b0c:	00 
  801b0d:	c7 04 24 18 34 80 00 	movl   $0x803418,(%esp)
  801b14:	e8 9f 0f 00 00       	call   802ab8 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  801b19:	e8 d4 f5 ff ff       	call   8010f2 <sys_getenvid>
  801b1e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b23:	c1 e0 07             	shl    $0x7,%eax
  801b26:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  801b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b32:	74 0b                	je     801b3f <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  801b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b37:	8b 50 74             	mov    0x74(%eax),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  801b3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b43:	74 0b                	je     801b50 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  801b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b48:	8b 50 78             	mov    0x78(%eax),%edx
  801b4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4e:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  801b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b53:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  801b5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b62:	75 26                	jne    801b8a <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  801b64:	8b 45 14             	mov    0x14(%ebp),%eax
  801b67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6b:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  801b72:	ee 
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	89 04 24             	mov    %eax,(%esp)
  801b80:	e8 c6 f7 ff ff       	call   80134b <sys_ipc_try_send>
  801b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b88:	eb 23                	jmp    801bad <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  801b8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b91:	8b 45 10             	mov    0x10(%ebp),%eax
  801b94:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	89 04 24             	mov    %eax,(%esp)
  801ba5:	e8 a1 f7 ff ff       	call   80134b <sys_ipc_try_send>
  801baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  801bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb1:	79 29                	jns    801bdc <ipc_send+0x84>
  801bb3:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  801bb7:	74 23                	je     801bdc <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  801bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bc0:	c7 44 24 08 22 34 80 	movl   $0x803422,0x8(%esp)
  801bc7:	00 
  801bc8:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801bcf:	00 
  801bd0:	c7 04 24 18 34 80 00 	movl   $0x803418,(%esp)
  801bd7:	e8 dc 0e 00 00       	call   802ab8 <_panic>
	    sys_yield();
  801bdc:	e8 55 f5 ff ff       	call   801136 <sys_yield>
	}while(r < 0);
  801be1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be5:	0f 88 73 ff ff ff    	js     801b5e <ipc_send+0x6>
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    
  801bed:	00 00                	add    %al,(%eax)
	...

00801bf0 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	89 04 24             	mov    %eax,(%esp)
  801bfc:	e8 0a 00 00 00       	call   801c0b <fd2num>
  801c01:	05 40 03 00 00       	add    $0x340,%eax
  801c06:	c1 e0 16             	shl    $0x16,%eax
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <fd2num>:

int
fd2num(struct Fd *fd)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	05 00 00 40 30       	add    $0x30400000,%eax
  801c16:	c1 e8 0c             	shr    $0xc,%eax
}
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    

00801c1b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801c21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c28:	eb 49                	jmp    801c73 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c2d:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801c32:	c1 e0 0c             	shl    $0xc,%eax
  801c35:	89 c2                	mov    %eax,%edx
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8b 00                	mov    (%eax),%eax
  801c41:	c1 e8 16             	shr    $0x16,%eax
  801c44:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c4b:	83 e0 01             	and    $0x1,%eax
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	74 16                	je     801c68 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	8b 00                	mov    (%eax),%eax
  801c57:	c1 e8 0c             	shr    $0xc,%eax
  801c5a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c61:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801c64:	85 c0                	test   %eax,%eax
  801c66:	75 07                	jne    801c6f <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	eb 18                	jmp    801c87 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801c6f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801c73:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  801c77:	7e b1                	jle    801c2a <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  801c82:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  801c8f:	c7 44 24 08 38 34 80 	movl   $0x803438,0x8(%esp)
  801c96:	00 
  801c97:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801c9e:	00 
  801c9f:	c7 04 24 52 34 80 00 	movl   $0x803452,(%esp)
  801ca6:	e8 0d 0e 00 00       	call   802ab8 <_panic>

00801cab <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	89 04 24             	mov    %eax,(%esp)
  801cb7:	e8 4f ff ff ff       	call   801c0b <fd2num>
  801cbc:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801cbf:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cc3:	89 04 24             	mov    %eax,(%esp)
  801cc6:	e8 be ff ff ff       	call   801c89 <fd_lookup>
  801ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd2:	78 08                	js     801cdc <fd_close+0x31>
	    || fd != fd2)
  801cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd7:	39 45 08             	cmp    %eax,0x8(%ebp)
  801cda:	74 12                	je     801cee <fd_close+0x43>
		return (must_exist ? r : 0);
  801cdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ce0:	74 05                	je     801ce7 <fd_close+0x3c>
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	eb 05                	jmp    801cec <fd_close+0x41>
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cec:	eb 44                	jmp    801d32 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	8b 00                	mov    (%eax),%eax
  801cf3:	8d 55 ec             	lea    -0x14(%ebp),%edx
  801cf6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cfa:	89 04 24             	mov    %eax,(%esp)
  801cfd:	e8 32 00 00 00       	call   801d34 <dev_lookup>
  801d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d09:	78 11                	js     801d1c <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  801d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d0e:	8b 50 10             	mov    0x10(%eax),%edx
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	89 04 24             	mov    %eax,(%esp)
  801d17:	ff d2                	call   *%edx
  801d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2a:	e8 d2 f4 ff ff       	call   801201 <sys_page_unmap>
	return r;
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  801d3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d41:	eb 2b                	jmp    801d6e <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  801d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d46:	8b 04 85 08 60 80 00 	mov    0x806008(,%eax,4),%eax
  801d4d:	8b 00                	mov    (%eax),%eax
  801d4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d52:	75 16                	jne    801d6a <dev_lookup+0x36>
			*dev = devtab[i];
  801d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d57:	8b 14 85 08 60 80 00 	mov    0x806008(,%eax,4),%edx
  801d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d61:	89 10                	mov    %edx,(%eax)
			return 0;
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
  801d68:	eb 3f                	jmp    801da9 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801d6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	8b 04 85 08 60 80 00 	mov    0x806008(,%eax,4),%eax
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	75 c7                	jne    801d43 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801d7c:	a1 40 60 80 00       	mov    0x806040,%eax
  801d81:	8b 40 4c             	mov    0x4c(%eax),%eax
  801d84:	8b 55 08             	mov    0x8(%ebp),%edx
  801d87:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8f:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  801d96:	e8 91 e4 ff ff       	call   80022c <cprintf>
	*dev = 0;
  801d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801da4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <close>:

int
close(int fdnum)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801db1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	89 04 24             	mov    %eax,(%esp)
  801dbe:	e8 c6 fe ff ff       	call   801c89 <fd_lookup>
  801dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dca:	79 05                	jns    801dd1 <close+0x26>
		return r;
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	eb 13                	jmp    801de4 <close+0x39>
	else
		return fd_close(fd, 1);
  801dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ddb:	00 
  801ddc:	89 04 24             	mov    %eax,(%esp)
  801ddf:	e8 c7 fe ff ff       	call   801cab <fd_close>
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <close_all>:

void
close_all(void)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801dec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801df3:	eb 0f                	jmp    801e04 <close_all+0x1e>
		close(i);
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	89 04 24             	mov    %eax,(%esp)
  801dfb:	e8 ab ff ff ff       	call   801dab <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e00:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801e04:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  801e08:	7e eb                	jle    801df5 <close_all+0xf>
		close(i);
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e12:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	89 04 24             	mov    %eax,(%esp)
  801e1f:	e8 65 fe ff ff       	call   801c89 <fd_lookup>
  801e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2b:	79 08                	jns    801e35 <dup+0x29>
		return r;
  801e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e30:	e9 54 01 00 00       	jmp    801f89 <dup+0x17d>
	close(newfdnum);
  801e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e38:	89 04 24             	mov    %eax,(%esp)
  801e3b:	e8 6b ff ff ff       	call   801dab <close>

	newfd = INDEX2FD(newfdnum);
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801e48:	c1 e0 0c             	shl    $0xc,%eax
  801e4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  801e4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e51:	89 04 24             	mov    %eax,(%esp)
  801e54:	e8 97 fd ff ff       	call   801bf0 <fd2data>
  801e59:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5f:	89 04 24             	mov    %eax,(%esp)
  801e62:	e8 89 fd ff ff       	call   801bf0 <fd2data>
  801e67:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801e6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e6d:	c1 e8 0c             	shr    $0xc,%eax
  801e70:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e77:	89 c2                	mov    %eax,%edx
  801e79:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801e7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e82:	89 54 24 10          	mov    %edx,0x10(%esp)
  801e86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e89:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e8d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e94:	00 
  801e95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea0:	e8 16 f3 ff ff       	call   8011bb <sys_page_map>
  801ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ea8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eac:	0f 88 8e 00 00 00    	js     801f40 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  801eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eb5:	c1 e8 16             	shr    $0x16,%eax
  801eb8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	74 78                	je     801f3b <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801ec3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eca:	eb 66                	jmp    801f32 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	03 45 e8             	add    -0x18(%ebp),%eax
  801ed2:	c1 e8 0c             	shr    $0xc,%eax
  801ed5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801edc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  801edf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee2:	83 e0 01             	and    $0x1,%eax
  801ee5:	84 c0                	test   %al,%al
  801ee7:	74 42                	je     801f2b <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801ee9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eec:	89 c1                	mov    %eax,%ecx
  801eee:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	89 c2                	mov    %eax,%edx
  801ef9:	03 55 e4             	add    -0x1c(%ebp),%edx
  801efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eff:	03 45 e8             	add    -0x18(%ebp),%eax
  801f02:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801f06:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f11:	00 
  801f12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1d:	e8 99 f2 ff ff       	call   8011bb <sys_page_map>
  801f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f29:	78 18                	js     801f43 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801f2b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801f32:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801f39:	7e 91                	jle    801ecc <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  801f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3e:	eb 49                	jmp    801f89 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  801f40:	90                   	nop
  801f41:	eb 01                	jmp    801f44 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  801f43:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f52:	e8 aa f2 ff ff       	call   801201 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801f57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f5e:	eb 1d                	jmp    801f7d <dup+0x171>
		sys_page_unmap(0, nva + i);
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f63:	03 45 e4             	add    -0x1c(%ebp),%eax
  801f66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f71:	e8 8b f2 ff ff       	call   801201 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801f76:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801f7d:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801f84:	7e da                	jle    801f60 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  801f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f91:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	89 04 24             	mov    %eax,(%esp)
  801f9e:	e8 e6 fc ff ff       	call   801c89 <fd_lookup>
  801fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801faa:	78 1d                	js     801fc9 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801faf:	8b 00                	mov    (%eax),%eax
  801fb1:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801fb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fb8:	89 04 24             	mov    %eax,(%esp)
  801fbb:	e8 74 fd ff ff       	call   801d34 <dev_lookup>
  801fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc7:	79 05                	jns    801fce <read+0x43>
		return r;
  801fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcc:	eb 75                	jmp    802043 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd1:	8b 40 08             	mov    0x8(%eax),%eax
  801fd4:	83 e0 03             	and    $0x3,%eax
  801fd7:	83 f8 01             	cmp    $0x1,%eax
  801fda:	75 26                	jne    802002 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801fdc:	a1 40 60 80 00       	mov    0x806040,%eax
  801fe1:	8b 40 4c             	mov    0x4c(%eax),%eax
  801fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801feb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fef:	c7 04 24 7b 34 80 00 	movl   $0x80347b,(%esp)
  801ff6:	e8 31 e2 ff ff       	call   80022c <cprintf>
		return -E_INVAL;
  801ffb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802000:	eb 41                	jmp    802043 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  802002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802005:	8b 48 08             	mov    0x8(%eax),%ecx
  802008:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200b:	8b 50 04             	mov    0x4(%eax),%edx
  80200e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802011:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802015:	8b 55 10             	mov    0x10(%ebp),%edx
  802018:	89 54 24 08          	mov    %edx,0x8(%esp)
  80201c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201f:	89 54 24 04          	mov    %edx,0x4(%esp)
  802023:	89 04 24             	mov    %eax,(%esp)
  802026:	ff d1                	call   *%ecx
  802028:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  80202b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202f:	78 0f                	js     802040 <read+0xb5>
		fd->fd_offset += r;
  802031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802034:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802037:	8b 52 04             	mov    0x4(%edx),%edx
  80203a:	03 55 f4             	add    -0xc(%ebp),%edx
  80203d:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80204b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802052:	eb 3b                	jmp    80208f <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	8b 55 10             	mov    0x10(%ebp),%edx
  80205a:	29 c2                	sub    %eax,%edx
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	03 45 0c             	add    0xc(%ebp),%eax
  802062:	89 54 24 08          	mov    %edx,0x8(%esp)
  802066:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	89 04 24             	mov    %eax,(%esp)
  802070:	e8 16 ff ff ff       	call   801f8b <read>
  802075:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  802078:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80207c:	79 05                	jns    802083 <readn+0x3e>
			return m;
  80207e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802081:	eb 1a                	jmp    80209d <readn+0x58>
		if (m == 0)
  802083:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802087:	74 10                	je     802099 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208c:	01 45 f4             	add    %eax,-0xc(%ebp)
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	3b 45 10             	cmp    0x10(%ebp),%eax
  802095:	72 bd                	jb     802054 <readn+0xf>
  802097:	eb 01                	jmp    80209a <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802099:	90                   	nop
	}
	return tot;
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	89 04 24             	mov    %eax,(%esp)
  8020b2:	e8 d2 fb ff ff       	call   801c89 <fd_lookup>
  8020b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020be:	78 1d                	js     8020dd <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c3:	8b 00                	mov    (%eax),%eax
  8020c5:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8020c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020cc:	89 04 24             	mov    %eax,(%esp)
  8020cf:	e8 60 fc ff ff       	call   801d34 <dev_lookup>
  8020d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020db:	79 05                	jns    8020e2 <write+0x43>
		return r;
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	eb 74                	jmp    802156 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e5:	8b 40 08             	mov    0x8(%eax),%eax
  8020e8:	83 e0 03             	and    $0x3,%eax
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	75 26                	jne    802115 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8020ef:	a1 40 60 80 00       	mov    0x806040,%eax
  8020f4:	8b 40 4c             	mov    0x4c(%eax),%eax
  8020f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802102:	c7 04 24 97 34 80 00 	movl   $0x803497,(%esp)
  802109:	e8 1e e1 ff ff       	call   80022c <cprintf>
		return -E_INVAL;
  80210e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802113:	eb 41                	jmp    802156 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  802115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802118:	8b 48 0c             	mov    0xc(%eax),%ecx
  80211b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211e:	8b 50 04             	mov    0x4(%eax),%edx
  802121:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802124:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802128:	8b 55 10             	mov    0x10(%ebp),%edx
  80212b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80212f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802132:	89 54 24 04          	mov    %edx,0x4(%esp)
  802136:	89 04 24             	mov    %eax,(%esp)
  802139:	ff d1                	call   *%ecx
  80213b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  80213e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802142:	7e 0f                	jle    802153 <write+0xb4>
		fd->fd_offset += r;
  802144:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802147:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80214a:	8b 52 04             	mov    0x4(%edx),%edx
  80214d:	03 55 f4             	add    -0xc(%ebp),%edx
  802150:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <seek>:

int
seek(int fdnum, off_t offset)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80215e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802161:	89 44 24 04          	mov    %eax,0x4(%esp)
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	89 04 24             	mov    %eax,(%esp)
  80216b:	e8 19 fb ff ff       	call   801c89 <fd_lookup>
  802170:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802173:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802177:	79 05                	jns    80217e <seek+0x26>
		return r;
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	eb 0e                	jmp    80218c <seek+0x34>
	fd->fd_offset = offset;
  80217e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802194:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	89 04 24             	mov    %eax,(%esp)
  8021a1:	e8 e3 fa ff ff       	call   801c89 <fd_lookup>
  8021a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ad:	78 1d                	js     8021cc <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8021b7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021bb:	89 04 24             	mov    %eax,(%esp)
  8021be:	e8 71 fb ff ff       	call   801d34 <dev_lookup>
  8021c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ca:	79 05                	jns    8021d1 <ftruncate+0x43>
		return r;
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	eb 48                	jmp    802219 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d4:	8b 40 08             	mov    0x8(%eax),%eax
  8021d7:	83 e0 03             	and    $0x3,%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	75 26                	jne    802204 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8021de:	a1 40 60 80 00       	mov    0x806040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021e3:	8b 40 4c             	mov    0x4c(%eax),%eax
  8021e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f1:	c7 04 24 b4 34 80 00 	movl   $0x8034b4,(%esp)
  8021f8:	e8 2f e0 ff ff       	call   80022c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8021fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802202:	eb 15                	jmp    802219 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  802204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802207:	8b 48 1c             	mov    0x1c(%eax),%ecx
  80220a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802210:	89 54 24 04          	mov    %edx,0x4(%esp)
  802214:	89 04 24             	mov    %eax,(%esp)
  802217:	ff d1                	call   *%ecx
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802221:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802224:	89 44 24 04          	mov    %eax,0x4(%esp)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	89 04 24             	mov    %eax,(%esp)
  80222e:	e8 56 fa ff ff       	call   801c89 <fd_lookup>
  802233:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223a:	78 1d                	js     802259 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80223c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223f:	8b 00                	mov    (%eax),%eax
  802241:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802244:	89 54 24 04          	mov    %edx,0x4(%esp)
  802248:	89 04 24             	mov    %eax,(%esp)
  80224b:	e8 e4 fa ff ff       	call   801d34 <dev_lookup>
  802250:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802253:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802257:	79 05                	jns    80225e <fstat+0x43>
		return r;
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	eb 41                	jmp    80229f <fstat+0x84>
	stat->st_name[0] = 0;
  80225e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802261:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  802264:	8b 45 0c             	mov    0xc(%ebp),%eax
  802267:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  80226e:	00 00 00 
	stat->st_isdir = 0;
  802271:	8b 45 0c             	mov    0xc(%ebp),%eax
  802274:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  80227b:	00 00 00 
	stat->st_dev = dev;
  80227e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  80228a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228d:	8b 48 14             	mov    0x14(%eax),%ecx
  802290:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802293:	8b 55 0c             	mov    0xc(%ebp),%edx
  802296:	89 54 24 04          	mov    %edx,0x4(%esp)
  80229a:	89 04 24             	mov    %eax,(%esp)
  80229d:	ff d1                	call   *%ecx
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022ae:	00 
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	89 04 24             	mov    %eax,(%esp)
  8022b5:	e8 36 00 00 00       	call   8022f0 <open>
  8022ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c1:	79 05                	jns    8022c8 <stat+0x27>
		return fd;
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	eb 23                	jmp    8022eb <stat+0x4a>
	r = fstat(fd, stat);
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	89 04 24             	mov    %eax,(%esp)
  8022d5:	e8 41 ff ff ff       	call   80221b <fstat>
  8022da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	89 04 24             	mov    %eax,(%esp)
  8022e3:	e8 c3 fa ff ff       	call   801dab <close>
	return r;
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    
  8022ed:	00 00                	add    %al,(%eax)
	...

008022f0 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  8022f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022f9:	89 04 24             	mov    %eax,(%esp)
  8022fc:	e8 1a f9 ff ff       	call   801c1b <fd_alloc>
  802301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802304:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802308:	79 05                	jns    80230f <open+0x1f>
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	eb 73                	jmp    802382 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  80230f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802312:	89 44 24 08          	mov    %eax,0x8(%esp)
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	89 04 24             	mov    %eax,(%esp)
  802323:	e8 54 05 00 00       	call   80287c <fsipc_open>
  802328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232f:	79 05                	jns    802336 <open+0x46>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	eb 4c                	jmp    802382 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80233f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802342:	89 54 24 08          	mov    %edx,0x8(%esp)
  802346:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80234d:	00 
  80234e:	89 04 24             	mov    %eax,(%esp)
  802351:	e8 25 03 00 00       	call   80267b <fmap>
  802356:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802359:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235d:	79 18                	jns    802377 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802369:	00 
  80236a:	89 04 24             	mov    %eax,(%esp)
  80236d:	e8 39 f9 ff ff       	call   801cab <fd_close>
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	eb 0b                	jmp    802382 <open+0x92>
	return fd2num(fd);
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	89 04 24             	mov    %eax,(%esp)
  80237d:	e8 89 f8 ff ff       	call   801c0b <fd2num>
	//panic("open() unimplemented!");
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  802393:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  80239a:	00 
  80239b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023a2:	00 
  8023a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	89 04 24             	mov    %eax,(%esp)
  8023ad:	e8 72 03 00 00       	call   802724 <funmap>
  8023b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b9:	79 05                	jns    8023c0 <file_close+0x3c>
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	eb 21                	jmp    8023e1 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c6:	89 04 24             	mov    %eax,(%esp)
  8023c9:	e8 e3 05 00 00       	call   8029b1 <fsipc_close>
  8023ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d5:	79 05                	jns    8023dc <file_close+0x58>
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	eb 05                	jmp    8023e1 <file_close+0x5d>
	return 0;
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  8023f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023fb:	76 07                	jbe    802404 <file_read+0x21>
		return 0;
  8023fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802402:	eb 43                	jmp    802447 <file_read+0x64>
	if (offset + n > size)
  802404:	8b 45 14             	mov    0x14(%ebp),%eax
  802407:	03 45 10             	add    0x10(%ebp),%eax
  80240a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80240d:	76 0f                	jbe    80241e <file_read+0x3b>
		n = size - offset;
  80240f:	8b 45 14             	mov    0x14(%ebp),%eax
  802412:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802415:	89 d1                	mov    %edx,%ecx
  802417:	29 c1                	sub    %eax,%ecx
  802419:	89 c8                	mov    %ecx,%eax
  80241b:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	89 04 24             	mov    %eax,(%esp)
  802424:	e8 c7 f7 ff ff       	call   801bf0 <fd2data>
  802429:	8b 55 14             	mov    0x14(%ebp),%edx
  80242c:	01 c2                	add    %eax,%edx
  80242e:	8b 45 10             	mov    0x10(%ebp),%eax
  802431:	89 44 24 08          	mov    %eax,0x8(%esp)
  802435:	89 54 24 04          	mov    %edx,0x4(%esp)
  802439:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243c:	89 04 24             	mov    %eax,(%esp)
  80243f:	e8 ec e8 ff ff       	call   800d30 <memmove>
	return n;
  802444:	8b 45 10             	mov    0x10(%ebp),%eax
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80244f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802452:	89 44 24 04          	mov    %eax,0x4(%esp)
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	89 04 24             	mov    %eax,(%esp)
  80245c:	e8 28 f8 ff ff       	call   801c89 <fd_lookup>
  802461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	79 05                	jns    80246f <read_map+0x26>
		return r;
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	eb 74                	jmp    8024e3 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  80246f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802472:	8b 10                	mov    (%eax),%edx
  802474:	a1 20 60 80 00       	mov    0x806020,%eax
  802479:	39 c2                	cmp    %eax,%edx
  80247b:	74 07                	je     802484 <read_map+0x3b>
		return -E_INVAL;
  80247d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802482:	eb 5f                	jmp    8024e3 <read_map+0x9a>
	va = fd2data(fd) + offset;
  802484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802487:	89 04 24             	mov    %eax,(%esp)
  80248a:	e8 61 f7 ff ff       	call   801bf0 <fd2data>
  80248f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802492:	01 d0                	add    %edx,%eax
  802494:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  802497:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  80249e:	7e 07                	jle    8024a7 <read_map+0x5e>
		return -E_NO_DISK;
  8024a0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8024a5:	eb 3c                	jmp    8024e3 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  8024a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024aa:	c1 e8 16             	shr    $0x16,%eax
  8024ad:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8024b4:	83 e0 01             	and    $0x1,%eax
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	74 14                	je     8024cf <read_map+0x86>
  8024bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024be:	c1 e8 0c             	shr    $0xc,%eax
  8024c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8024c8:	83 e0 01             	and    $0x1,%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	75 07                	jne    8024d6 <read_map+0x8d>
		return -E_NO_DISK;
  8024cf:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8024d4:	eb 0d                	jmp    8024e3 <read_map+0x9a>
	*blk = (void*) va;
  8024d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024dc:	89 10                	mov    %edx,(%eax)
	return 0;
  8024de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  8024eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ee:	03 45 10             	add    0x10(%ebp),%eax
  8024f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  8024f4:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  8024fb:	76 07                	jbe    802504 <file_write+0x1f>
		return -E_NO_DISK;
  8024fd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802502:	eb 57                	jmp    80255b <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80250d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802510:	73 20                	jae    802532 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	89 44 24 04          	mov    %eax,0x4(%esp)
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	89 04 24             	mov    %eax,(%esp)
  80251f:	e8 88 00 00 00       	call   8025ac <file_trunc>
  802524:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802527:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80252b:	79 05                	jns    802532 <file_write+0x4d>
			return r;
  80252d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802530:	eb 29                	jmp    80255b <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  802532:	8b 45 08             	mov    0x8(%ebp),%eax
  802535:	89 04 24             	mov    %eax,(%esp)
  802538:	e8 b3 f6 ff ff       	call   801bf0 <fd2data>
  80253d:	8b 55 14             	mov    0x14(%ebp),%edx
  802540:	01 c2                	add    %eax,%edx
  802542:	8b 45 10             	mov    0x10(%ebp),%eax
  802545:	89 44 24 08          	mov    %eax,0x8(%esp)
  802549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802550:	89 14 24             	mov    %edx,(%esp)
  802553:	e8 d8 e7 ff ff       	call   800d30 <memmove>
	return n;
  802558:	8b 45 10             	mov    0x10(%ebp),%eax
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	8d 50 10             	lea    0x10(%eax),%edx
  802569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802570:	89 04 24             	mov    %eax,(%esp)
  802573:	e8 c6 e5 ff ff       	call   800b3e <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  802581:	8b 45 0c             	mov    0xc(%ebp),%eax
  802584:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  802593:	83 f8 01             	cmp    $0x1,%eax
  802596:	0f 94 c0             	sete   %al
  802599:	0f b6 d0             	movzbl %al,%edx
  80259c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259f:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  8025a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  8025b2:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  8025b9:	7e 0a                	jle    8025c5 <file_trunc+0x19>
		return -E_NO_DISK;
  8025bb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8025c0:	e9 b4 00 00 00       	jmp    802679 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8025d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025e4:	89 04 24             	mov    %eax,(%esp)
  8025e7:	e8 82 03 00 00       	call   80296e <fsipc_set_size>
  8025ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025f3:	79 05                	jns    8025fa <file_trunc+0x4e>
		return r;
  8025f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f8:	eb 7f                	jmp    802679 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  802603:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802606:	74 24                	je     80262c <file_trunc+0x80>
  802608:	c7 44 24 0c e0 34 80 	movl   $0x8034e0,0xc(%esp)
  80260f:	00 
  802610:	c7 44 24 08 03 35 80 	movl   $0x803503,0x8(%esp)
  802617:	00 
  802618:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80261f:	00 
  802620:	c7 04 24 18 35 80 00 	movl   $0x803518,(%esp)
  802627:	e8 8c 04 00 00       	call   802ab8 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  80262c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802636:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	89 04 24             	mov    %eax,(%esp)
  802640:	e8 36 00 00 00       	call   80267b <fmap>
  802645:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802648:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80264c:	79 05                	jns    802653 <file_trunc+0xa7>
		return r;
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	eb 26                	jmp    802679 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  802653:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80265a:	00 
  80265b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802665:	89 44 24 04          	mov    %eax,0x4(%esp)
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	89 04 24             	mov    %eax,(%esp)
  80266f:	e8 b0 00 00 00       	call   802724 <funmap>

	return 0;
  802674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	89 04 24             	mov    %eax,(%esp)
  802687:	e8 64 f5 ff ff       	call   801bf0 <fd2data>
  80268c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80268f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802696:	8b 45 0c             	mov    0xc(%ebp),%eax
  802699:	03 45 ec             	add    -0x14(%ebp),%eax
  80269c:	83 e8 01             	sub    $0x1,%eax
  80269f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026aa:	f7 75 ec             	divl   -0x14(%ebp)
  8026ad:	89 d0                	mov    %edx,%eax
  8026af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b2:	89 d1                	mov    %edx,%ecx
  8026b4:	29 c1                	sub    %eax,%ecx
  8026b6:	89 c8                	mov    %ecx,%eax
  8026b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bb:	eb 58                	jmp    802715 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8026c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026d7:	89 04 24             	mov    %eax,(%esp)
  8026da:	e8 04 02 00 00       	call   8028e3 <fsipc_map>
  8026df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8026e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026e6:	79 26                	jns    80270e <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026f2:	00 
  8026f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	89 04 24             	mov    %eax,(%esp)
  802704:	e8 1b 00 00 00       	call   802724 <funmap>
			return r;
  802709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270c:	eb 14                	jmp    802722 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80270e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802715:	8b 45 10             	mov    0x10(%ebp),%eax
  802718:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80271b:	77 a0                	ja     8026bd <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	89 04 24             	mov    %eax,(%esp)
  802730:	e8 bb f4 ff ff       	call   801bf0 <fd2data>
  802735:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  802738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273b:	c1 e8 16             	shr    $0x16,%eax
  80273e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802745:	83 e0 01             	and    $0x1,%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	75 0a                	jne    802756 <funmap+0x32>
		return 0;
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
  802751:	e9 bf 00 00 00       	jmp    802815 <funmap+0xf1>

	ret = 0;
  802756:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  80275d:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802764:	8b 45 10             	mov    0x10(%ebp),%eax
  802767:	03 45 e8             	add    -0x18(%ebp),%eax
  80276a:	83 e8 01             	sub    $0x1,%eax
  80276d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802773:	ba 00 00 00 00       	mov    $0x0,%edx
  802778:	f7 75 e8             	divl   -0x18(%ebp)
  80277b:	89 d0                	mov    %edx,%eax
  80277d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802780:	89 d1                	mov    %edx,%ecx
  802782:	29 c1                	sub    %eax,%ecx
  802784:	89 c8                	mov    %ecx,%eax
  802786:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802789:	eb 7b                	jmp    802806 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802791:	01 d0                	add    %edx,%eax
  802793:	c1 e8 0c             	shr    $0xc,%eax
  802796:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80279d:	83 e0 01             	and    $0x1,%eax
  8027a0:	84 c0                	test   %al,%al
  8027a2:	74 5b                	je     8027ff <funmap+0xdb>
			if (dirty
  8027a4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8027a8:	74 3d                	je     8027e7 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b0:	01 d0                	add    %edx,%eax
  8027b2:	c1 e8 0c             	shr    $0xc,%eax
  8027b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8027bc:	83 e0 40             	and    $0x40,%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	74 24                	je     8027e7 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  8027c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027d0:	89 04 24             	mov    %eax,(%esp)
  8027d3:	e8 13 02 00 00       	call   8029eb <fsipc_dirty>
  8027d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8027db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027df:	79 06                	jns    8027e7 <funmap+0xc3>
				ret = r;
  8027e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ed:	01 d0                	add    %edx,%eax
  8027ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027fa:	e8 02 ea ff ff       	call   801201 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8027ff:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802806:	8b 45 0c             	mov    0xc(%ebp),%eax
  802809:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80280c:	0f 87 79 ff ff ff    	ja     80278b <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  802812:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <remove>:

// Delete a file
int
remove(const char *path)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	89 04 24             	mov    %eax,(%esp)
  802823:	e8 06 02 00 00       	call   802a2e <fsipc_remove>
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  802830:	e8 56 02 00 00       	call   802a8b <fsipc_sync>
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    
	...

00802838 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80283e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  802843:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80284a:	00 
  80284b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802852:	8b 55 08             	mov    0x8(%ebp),%edx
  802855:	89 54 24 04          	mov    %edx,0x4(%esp)
  802859:	89 04 24             	mov    %eax,(%esp)
  80285c:	e8 f7 f2 ff ff       	call   801b58 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802861:	8b 45 14             	mov    0x14(%ebp),%eax
  802864:	89 44 24 08          	mov    %eax,0x8(%esp)
  802868:	8b 45 10             	mov    0x10(%ebp),%eax
  80286b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80286f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802872:	89 04 24             	mov    %eax,(%esp)
  802875:	e8 52 f2 ff ff       	call   801acc <ipc_recv>
}
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  802882:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	89 04 24             	mov    %eax,(%esp)
  80288f:	e8 54 e2 ff ff       	call   800ae8 <strlen>
  802894:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802899:	7e 07                	jle    8028a2 <fsipc_open+0x26>
		return -E_BAD_PATH;
  80289b:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8028a0:	eb 3f                	jmp    8028e1 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028ac:	89 04 24             	mov    %eax,(%esp)
  8028af:	e8 8a e2 ff ff       	call   800b3e <strcpy>
	req->req_omode = omode;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ba:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8028c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8028dc:	e8 57 ff ff ff       	call   802838 <fsipc>
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  8028e9:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f6:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028fe:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  802901:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802904:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802908:	8b 45 10             	mov    0x10(%ebp),%eax
  80290b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	89 44 24 04          	mov    %eax,0x4(%esp)
  802916:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80291d:	e8 16 ff ff ff       	call   802838 <fsipc>
  802922:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802925:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802929:	79 05                	jns    802930 <fsipc_map+0x4d>
		return r;
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	eb 3c                	jmp    80296c <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  802930:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802933:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  802938:	83 f8 05             	cmp    $0x5,%eax
  80293b:	74 2a                	je     802967 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  80293d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802940:	8b 55 10             	mov    0x10(%ebp),%edx
  802943:	89 54 24 10          	mov    %edx,0x10(%esp)
  802947:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80294b:	c7 44 24 08 24 35 80 	movl   $0x803524,0x8(%esp)
  802952:	00 
  802953:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  80295a:	00 
  80295b:	c7 04 24 5a 35 80 00 	movl   $0x80355a,(%esp)
  802962:	e8 51 01 00 00       	call   802ab8 <_panic>
	return 0;
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802974:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 55 08             	mov    0x8(%ebp),%edx
  802981:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 55 0c             	mov    0xc(%ebp),%edx
  802989:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  80298c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802993:	00 
  802994:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80299b:	00 
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a3:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8029aa:	e8 89 fe ff ff       	call   802838 <fsipc>
}
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
  8029b4:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  8029b7:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c4:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  8029c6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8029cd:	00 
  8029ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8029d5:	00 
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029dd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8029e4:	e8 4f fe ff ff       	call   802838 <fsipc>
}
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    

008029eb <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
  8029ee:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  8029f1:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fe:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a06:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  802a09:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802a10:	00 
  802a11:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a18:	00 
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a20:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  802a27:	e8 0c fe ff ff       	call   802838 <fsipc>
}
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
  802a31:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802a34:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	89 04 24             	mov    %eax,(%esp)
  802a41:	e8 a2 e0 ff ff       	call   800ae8 <strlen>
  802a46:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a4b:	7e 07                	jle    802a54 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802a4d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802a52:	eb 35                	jmp    802a89 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5a:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a5e:	89 04 24             	mov    %eax,(%esp)
  802a61:	e8 d8 e0 ff ff       	call   800b3e <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  802a66:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802a6d:	00 
  802a6e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a75:	00 
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a7d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  802a84:	e8 af fd ff ff       	call   802838 <fsipc>
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802a91:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802a98:	00 
  802a99:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802aa0:	00 
  802aa1:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802aa8:	00 
  802aa9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  802ab0:	e8 83 fd ff ff       	call   802838 <fsipc>
}
  802ab5:	c9                   	leave  
  802ab6:	c3                   	ret    
	...

00802ab8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  802abe:	8d 45 10             	lea    0x10(%ebp),%eax
  802ac1:	83 c0 04             	add    $0x4,%eax
  802ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  802ac7:	a1 44 60 80 00       	mov    0x806044,%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	74 15                	je     802ae5 <_panic+0x2d>
		cprintf("%s: ", argv0);
  802ad0:	a1 44 60 80 00       	mov    0x806044,%eax
  802ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad9:	c7 04 24 66 35 80 00 	movl   $0x803566,(%esp)
  802ae0:	e8 47 d7 ff ff       	call   80022c <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802ae5:	a1 00 60 80 00       	mov    0x806000,%eax
  802aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aed:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802af1:	8b 55 08             	mov    0x8(%ebp),%edx
  802af4:	89 54 24 08          	mov    %edx,0x8(%esp)
  802af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802afc:	c7 04 24 6b 35 80 00 	movl   $0x80356b,(%esp)
  802b03:	e8 24 d7 ff ff       	call   80022c <cprintf>
	vcprintf(fmt, ap);
  802b08:	8b 45 10             	mov    0x10(%ebp),%eax
  802b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b12:	89 04 24             	mov    %eax,(%esp)
  802b15:	e8 ae d6 ff ff       	call   8001c8 <vcprintf>
	cprintf("\n");
  802b1a:	c7 04 24 87 35 80 00 	movl   $0x803587,(%esp)
  802b21:	e8 06 d7 ff ff       	call   80022c <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802b26:	cc                   	int3   
  802b27:	eb fd                	jmp    802b26 <_panic+0x6e>
  802b29:	00 00                	add    %al,(%eax)
	...

00802b2c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
  802b2f:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b32:	a1 48 60 80 00       	mov    0x806048,%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	75 7b                	jne    802bb6 <set_pgfault_handler+0x8a>
		// First time through!
		// LAB 4: Your code here.
		envid_t env_id = sys_getenvid();//0env_id
  802b3b:	e8 b2 e5 ff ff       	call   8010f2 <sys_getenvid>
  802b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if((r = sys_page_alloc(env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_P|PTE_W)) < 0){
  802b43:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b4a:	00 
  802b4b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802b52:	ee 
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	89 04 24             	mov    %eax,(%esp)
  802b59:	e8 1c e6 ff ff       	call   80117a <sys_page_alloc>
  802b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b65:	79 1c                	jns    802b83 <set_pgfault_handler+0x57>
			panic("set_pgfault_handler not implemented\n");
  802b67:	c7 44 24 08 8c 35 80 	movl   $0x80358c,0x8(%esp)
  802b6e:	00 
  802b6f:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  802b76:	00 
  802b77:	c7 04 24 b1 35 80 00 	movl   $0x8035b1,(%esp)
  802b7e:	e8 35 ff ff ff       	call   802ab8 <_panic>
			return;
		}//env_id
		
		if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0){
  802b83:	c7 44 24 04 c0 2b 80 	movl   $0x802bc0,0x4(%esp)
  802b8a:	00 
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	89 04 24             	mov    %eax,(%esp)
  802b91:	e8 73 e7 ff ff       	call   801309 <sys_env_set_pgfault_upcall>
  802b96:	85 c0                	test   %eax,%eax
  802b98:	79 1c                	jns    802bb6 <set_pgfault_handler+0x8a>
			panic("sys_env_set_pgfault_upcall not implemented\n");
  802b9a:	c7 44 24 08 c0 35 80 	movl   $0x8035c0,0x8(%esp)
  802ba1:	00 
  802ba2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802ba9:	00 
  802baa:	c7 04 24 b1 35 80 00 	movl   $0x8035b1,(%esp)
  802bb1:	e8 02 ff ff ff       	call   802ab8 <_panic>
			return;
		}
		//sys_env_set_pgfault_upcall(0, _pgfault_upcall);
	}
	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	a3 48 60 80 00       	mov    %eax,0x806048
}
  802bbe:	c9                   	leave  
  802bbf:	c3                   	ret    

00802bc0 <_pgfault_upcall>:
  802bc0:	54                   	push   %esp
  802bc1:	a1 48 60 80 00       	mov    0x806048,%eax
  802bc6:	ff d0                	call   *%eax
  802bc8:	83 c4 04             	add    $0x4,%esp
  802bcb:	8b 44 24 30          	mov    0x30(%esp),%eax
  802bcf:	83 e8 04             	sub    $0x4,%eax
  802bd2:	89 44 24 30          	mov    %eax,0x30(%esp)
  802bd6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
  802bda:	89 18                	mov    %ebx,(%eax)
  802bdc:	83 c4 08             	add    $0x8,%esp
  802bdf:	61                   	popa   
  802be0:	83 c4 04             	add    $0x4,%esp
  802be3:	9d                   	popf   
  802be4:	5c                   	pop    %esp
  802be5:	c3                   	ret    
	...

00802bf0 <__udivdi3>:
  802bf0:	83 ec 1c             	sub    $0x1c,%esp
  802bf3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802bf7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  802bfb:	8b 44 24 20          	mov    0x20(%esp),%eax
  802bff:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802c03:	89 74 24 10          	mov    %esi,0x10(%esp)
  802c07:	8b 74 24 24          	mov    0x24(%esp),%esi
  802c0b:	85 ff                	test   %edi,%edi
  802c0d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802c11:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c15:	89 cd                	mov    %ecx,%ebp
  802c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c1b:	75 33                	jne    802c50 <__udivdi3+0x60>
  802c1d:	39 f1                	cmp    %esi,%ecx
  802c1f:	77 57                	ja     802c78 <__udivdi3+0x88>
  802c21:	85 c9                	test   %ecx,%ecx
  802c23:	75 0b                	jne    802c30 <__udivdi3+0x40>
  802c25:	b8 01 00 00 00       	mov    $0x1,%eax
  802c2a:	31 d2                	xor    %edx,%edx
  802c2c:	f7 f1                	div    %ecx
  802c2e:	89 c1                	mov    %eax,%ecx
  802c30:	89 f0                	mov    %esi,%eax
  802c32:	31 d2                	xor    %edx,%edx
  802c34:	f7 f1                	div    %ecx
  802c36:	89 c6                	mov    %eax,%esi
  802c38:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c3c:	f7 f1                	div    %ecx
  802c3e:	89 f2                	mov    %esi,%edx
  802c40:	8b 74 24 10          	mov    0x10(%esp),%esi
  802c44:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802c48:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802c4c:	83 c4 1c             	add    $0x1c,%esp
  802c4f:	c3                   	ret    
  802c50:	31 d2                	xor    %edx,%edx
  802c52:	31 c0                	xor    %eax,%eax
  802c54:	39 f7                	cmp    %esi,%edi
  802c56:	77 e8                	ja     802c40 <__udivdi3+0x50>
  802c58:	0f bd cf             	bsr    %edi,%ecx
  802c5b:	83 f1 1f             	xor    $0x1f,%ecx
  802c5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c62:	75 2c                	jne    802c90 <__udivdi3+0xa0>
  802c64:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802c68:	76 04                	jbe    802c6e <__udivdi3+0x7e>
  802c6a:	39 f7                	cmp    %esi,%edi
  802c6c:	73 d2                	jae    802c40 <__udivdi3+0x50>
  802c6e:	31 d2                	xor    %edx,%edx
  802c70:	b8 01 00 00 00       	mov    $0x1,%eax
  802c75:	eb c9                	jmp    802c40 <__udivdi3+0x50>
  802c77:	90                   	nop
  802c78:	89 f2                	mov    %esi,%edx
  802c7a:	f7 f1                	div    %ecx
  802c7c:	31 d2                	xor    %edx,%edx
  802c7e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802c82:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802c86:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802c8a:	83 c4 1c             	add    $0x1c,%esp
  802c8d:	c3                   	ret    
  802c8e:	66 90                	xchg   %ax,%ax
  802c90:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c95:	b8 20 00 00 00       	mov    $0x20,%eax
  802c9a:	89 ea                	mov    %ebp,%edx
  802c9c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802ca0:	d3 e7                	shl    %cl,%edi
  802ca2:	89 c1                	mov    %eax,%ecx
  802ca4:	d3 ea                	shr    %cl,%edx
  802ca6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cab:	09 fa                	or     %edi,%edx
  802cad:	89 f7                	mov    %esi,%edi
  802caf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802cb3:	89 f2                	mov    %esi,%edx
  802cb5:	8b 74 24 08          	mov    0x8(%esp),%esi
  802cb9:	d3 e5                	shl    %cl,%ebp
  802cbb:	89 c1                	mov    %eax,%ecx
  802cbd:	d3 ef                	shr    %cl,%edi
  802cbf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cc4:	d3 e2                	shl    %cl,%edx
  802cc6:	89 c1                	mov    %eax,%ecx
  802cc8:	d3 ee                	shr    %cl,%esi
  802cca:	09 d6                	or     %edx,%esi
  802ccc:	89 fa                	mov    %edi,%edx
  802cce:	89 f0                	mov    %esi,%eax
  802cd0:	f7 74 24 0c          	divl   0xc(%esp)
  802cd4:	89 d7                	mov    %edx,%edi
  802cd6:	89 c6                	mov    %eax,%esi
  802cd8:	f7 e5                	mul    %ebp
  802cda:	39 d7                	cmp    %edx,%edi
  802cdc:	72 22                	jb     802d00 <__udivdi3+0x110>
  802cde:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802ce2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802ce7:	d3 e5                	shl    %cl,%ebp
  802ce9:	39 c5                	cmp    %eax,%ebp
  802ceb:	73 04                	jae    802cf1 <__udivdi3+0x101>
  802ced:	39 d7                	cmp    %edx,%edi
  802cef:	74 0f                	je     802d00 <__udivdi3+0x110>
  802cf1:	89 f0                	mov    %esi,%eax
  802cf3:	31 d2                	xor    %edx,%edx
  802cf5:	e9 46 ff ff ff       	jmp    802c40 <__udivdi3+0x50>
  802cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d00:	8d 46 ff             	lea    -0x1(%esi),%eax
  802d03:	31 d2                	xor    %edx,%edx
  802d05:	8b 74 24 10          	mov    0x10(%esp),%esi
  802d09:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d0d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d11:	83 c4 1c             	add    $0x1c,%esp
  802d14:	c3                   	ret    
	...

00802d20 <__umoddi3>:
  802d20:	83 ec 1c             	sub    $0x1c,%esp
  802d23:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802d27:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  802d2b:	8b 44 24 20          	mov    0x20(%esp),%eax
  802d2f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802d33:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802d37:	8b 74 24 24          	mov    0x24(%esp),%esi
  802d3b:	85 ed                	test   %ebp,%ebp
  802d3d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d45:	89 cf                	mov    %ecx,%edi
  802d47:	89 04 24             	mov    %eax,(%esp)
  802d4a:	89 f2                	mov    %esi,%edx
  802d4c:	75 1a                	jne    802d68 <__umoddi3+0x48>
  802d4e:	39 f1                	cmp    %esi,%ecx
  802d50:	76 4e                	jbe    802da0 <__umoddi3+0x80>
  802d52:	f7 f1                	div    %ecx
  802d54:	89 d0                	mov    %edx,%eax
  802d56:	31 d2                	xor    %edx,%edx
  802d58:	8b 74 24 10          	mov    0x10(%esp),%esi
  802d5c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d60:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d64:	83 c4 1c             	add    $0x1c,%esp
  802d67:	c3                   	ret    
  802d68:	39 f5                	cmp    %esi,%ebp
  802d6a:	77 54                	ja     802dc0 <__umoddi3+0xa0>
  802d6c:	0f bd c5             	bsr    %ebp,%eax
  802d6f:	83 f0 1f             	xor    $0x1f,%eax
  802d72:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d76:	75 60                	jne    802dd8 <__umoddi3+0xb8>
  802d78:	3b 0c 24             	cmp    (%esp),%ecx
  802d7b:	0f 87 07 01 00 00    	ja     802e88 <__umoddi3+0x168>
  802d81:	89 f2                	mov    %esi,%edx
  802d83:	8b 34 24             	mov    (%esp),%esi
  802d86:	29 ce                	sub    %ecx,%esi
  802d88:	19 ea                	sbb    %ebp,%edx
  802d8a:	89 34 24             	mov    %esi,(%esp)
  802d8d:	8b 04 24             	mov    (%esp),%eax
  802d90:	8b 74 24 10          	mov    0x10(%esp),%esi
  802d94:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d98:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d9c:	83 c4 1c             	add    $0x1c,%esp
  802d9f:	c3                   	ret    
  802da0:	85 c9                	test   %ecx,%ecx
  802da2:	75 0b                	jne    802daf <__umoddi3+0x8f>
  802da4:	b8 01 00 00 00       	mov    $0x1,%eax
  802da9:	31 d2                	xor    %edx,%edx
  802dab:	f7 f1                	div    %ecx
  802dad:	89 c1                	mov    %eax,%ecx
  802daf:	89 f0                	mov    %esi,%eax
  802db1:	31 d2                	xor    %edx,%edx
  802db3:	f7 f1                	div    %ecx
  802db5:	8b 04 24             	mov    (%esp),%eax
  802db8:	f7 f1                	div    %ecx
  802dba:	eb 98                	jmp    802d54 <__umoddi3+0x34>
  802dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dc0:	89 f2                	mov    %esi,%edx
  802dc2:	8b 74 24 10          	mov    0x10(%esp),%esi
  802dc6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802dca:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802dce:	83 c4 1c             	add    $0x1c,%esp
  802dd1:	c3                   	ret    
  802dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802dd8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802ddd:	89 e8                	mov    %ebp,%eax
  802ddf:	bd 20 00 00 00       	mov    $0x20,%ebp
  802de4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802de8:	89 fa                	mov    %edi,%edx
  802dea:	d3 e0                	shl    %cl,%eax
  802dec:	89 e9                	mov    %ebp,%ecx
  802dee:	d3 ea                	shr    %cl,%edx
  802df0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802df5:	09 c2                	or     %eax,%edx
  802df7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802dfb:	89 14 24             	mov    %edx,(%esp)
  802dfe:	89 f2                	mov    %esi,%edx
  802e00:	d3 e7                	shl    %cl,%edi
  802e02:	89 e9                	mov    %ebp,%ecx
  802e04:	d3 ea                	shr    %cl,%edx
  802e06:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e0f:	d3 e6                	shl    %cl,%esi
  802e11:	89 e9                	mov    %ebp,%ecx
  802e13:	d3 e8                	shr    %cl,%eax
  802e15:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e1a:	09 f0                	or     %esi,%eax
  802e1c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802e20:	f7 34 24             	divl   (%esp)
  802e23:	d3 e6                	shl    %cl,%esi
  802e25:	89 74 24 08          	mov    %esi,0x8(%esp)
  802e29:	89 d6                	mov    %edx,%esi
  802e2b:	f7 e7                	mul    %edi
  802e2d:	39 d6                	cmp    %edx,%esi
  802e2f:	89 c1                	mov    %eax,%ecx
  802e31:	89 d7                	mov    %edx,%edi
  802e33:	72 3f                	jb     802e74 <__umoddi3+0x154>
  802e35:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802e39:	72 35                	jb     802e70 <__umoddi3+0x150>
  802e3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e3f:	29 c8                	sub    %ecx,%eax
  802e41:	19 fe                	sbb    %edi,%esi
  802e43:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e48:	89 f2                	mov    %esi,%edx
  802e4a:	d3 e8                	shr    %cl,%eax
  802e4c:	89 e9                	mov    %ebp,%ecx
  802e4e:	d3 e2                	shl    %cl,%edx
  802e50:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e55:	09 d0                	or     %edx,%eax
  802e57:	89 f2                	mov    %esi,%edx
  802e59:	d3 ea                	shr    %cl,%edx
  802e5b:	8b 74 24 10          	mov    0x10(%esp),%esi
  802e5f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802e63:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802e67:	83 c4 1c             	add    $0x1c,%esp
  802e6a:	c3                   	ret    
  802e6b:	90                   	nop
  802e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e70:	39 d6                	cmp    %edx,%esi
  802e72:	75 c7                	jne    802e3b <__umoddi3+0x11b>
  802e74:	89 d7                	mov    %edx,%edi
  802e76:	89 c1                	mov    %eax,%ecx
  802e78:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  802e7c:	1b 3c 24             	sbb    (%esp),%edi
  802e7f:	eb ba                	jmp    802e3b <__umoddi3+0x11b>
  802e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e88:	39 f5                	cmp    %esi,%ebp
  802e8a:	0f 82 f1 fe ff ff    	jb     802d81 <__umoddi3+0x61>
  802e90:	e9 f8 fe ff ff       	jmp    802d8d <__umoddi3+0x6d>
