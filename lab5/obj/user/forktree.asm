
obj/user/forktree:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 48             	sub    $0x48,%esp
  80003a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80003d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800040:	8b 45 08             	mov    0x8(%ebp),%eax
  800043:	89 04 24             	mov    %eax,(%esp)
  800046:	e8 8d 0a 00 00       	call   800ad8 <strlen>
  80004b:	83 f8 02             	cmp    $0x2,%eax
  80004e:	7f 45                	jg     800095 <forkchild+0x61>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800050:	0f be 45 e4          	movsbl -0x1c(%ebp),%eax
  800054:	89 44 24 10          	mov    %eax,0x10(%esp)
  800058:	8b 45 08             	mov    0x8(%ebp),%eax
  80005b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005f:	c7 44 24 08 a0 2e 80 	movl   $0x802ea0,0x8(%esp)
  800066:	00 
  800067:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  80006e:	00 
  80006f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800072:	89 04 24             	mov    %eax,(%esp)
  800075:	e8 25 0a 00 00       	call   800a9f <snprintf>
	if (fork() == 0) {
  80007a:	e8 a0 15 00 00       	call   80161f <fork>
  80007f:	85 c0                	test   %eax,%eax
  800081:	75 13                	jne    800096 <forkchild+0x62>
		forktree(nxt);
  800083:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800086:	89 04 24             	mov    %eax,(%esp)
  800089:	e8 0a 00 00 00       	call   800098 <forktree>
		exit();
  80008e:	e8 ad 00 00 00       	call   800140 <exit>
  800093:	eb 01                	jmp    800096 <forkchild+0x62>
forkchild(const char *cur, char branch)
{
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
		return;
  800095:	90                   	nop
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
	if (fork() == 0) {
		forktree(nxt);
		exit();
	}
}
  800096:	c9                   	leave  
  800097:	c3                   	ret    

00800098 <forktree>:

void
forktree(const char *cur)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 18             	sub    $0x18,%esp
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80009e:	e8 3f 10 00 00       	call   8010e2 <sys_getenvid>
  8000a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ae:	c7 04 24 a5 2e 80 00 	movl   $0x802ea5,(%esp)
  8000b5:	e8 62 01 00 00       	call   80021c <cprintf>

	forkchild(cur, '0');
  8000ba:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8000c1:	00 
  8000c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c5:	89 04 24             	mov    %eax,(%esp)
  8000c8:	e8 67 ff ff ff       	call   800034 <forkchild>
	forkchild(cur, '1');
  8000cd:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  8000d4:	00 
  8000d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d8:	89 04 24             	mov    %eax,(%esp)
  8000db:	e8 54 ff ff ff       	call   800034 <forkchild>
}
  8000e0:	c9                   	leave  
  8000e1:	c3                   	ret    

008000e2 <umain>:

void
umain(void)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	83 ec 18             	sub    $0x18,%esp
	forktree("");
  8000e8:	c7 04 24 b6 2e 80 00 	movl   $0x802eb6,(%esp)
  8000ef:	e8 a4 ff ff ff       	call   800098 <forktree>
}
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    
	...

008000f8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  8000fe:	e8 df 0f 00 00       	call   8010e2 <sys_getenvid>
  800103:	25 ff 03 00 00       	and    $0x3ff,%eax
  800108:	c1 e0 07             	shl    $0x7,%eax
  80010b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800110:	a3 40 60 80 00       	mov    %eax,0x806040
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800119:	7e 0a                	jle    800125 <libmain+0x2d>
		binaryname = argv[0];
  80011b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011e:	8b 00                	mov    (%eax),%eax
  800120:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012c:	8b 45 08             	mov    0x8(%ebp),%eax
  80012f:	89 04 24             	mov    %eax,(%esp)
  800132:	e8 ab ff ff ff       	call   8000e2 <umain>

	// exit gracefully
	exit();
  800137:	e8 04 00 00 00       	call   800140 <exit>
}
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    
	...

00800140 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800146:	e8 67 1b 00 00       	call   801cb2 <close_all>
	sys_env_destroy(0);
  80014b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800152:	e8 48 0f 00 00       	call   80109f <sys_env_destroy>
}
  800157:	c9                   	leave  
  800158:	c3                   	ret    
  800159:	00 00                	add    %al,(%eax)
	...

0080015c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  800162:	8b 45 0c             	mov    0xc(%ebp),%eax
  800165:	8b 00                	mov    (%eax),%eax
  800167:	8b 55 08             	mov    0x8(%ebp),%edx
  80016a:	89 d1                	mov    %edx,%ecx
  80016c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  800173:	8d 50 01             	lea    0x1(%eax),%edx
  800176:	8b 45 0c             	mov    0xc(%ebp),%eax
  800179:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  80017b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80017e:	8b 00                	mov    (%eax),%eax
  800180:	3d ff 00 00 00       	cmp    $0xff,%eax
  800185:	75 20                	jne    8001a7 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  800187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018f:	83 c2 08             	add    $0x8,%edx
  800192:	89 44 24 04          	mov    %eax,0x4(%esp)
  800196:	89 14 24             	mov    %edx,(%esp)
  800199:	e8 7b 0e 00 00       	call   801019 <sys_cputs>
		b->idx = 0;
  80019e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001aa:	8b 40 04             	mov    0x4(%eax),%eax
  8001ad:	8d 50 01             	lea    0x1(%eax),%edx
  8001b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    

008001b8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c8:	00 00 00 
	b.cnt = 0;
  8001cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ed:	c7 04 24 5c 01 80 00 	movl   $0x80015c,(%esp)
  8001f4:	e8 f7 01 00 00       	call   8003f0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800203:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800209:	83 c0 08             	add    $0x8,%eax
  80020c:	89 04 24             	mov    %eax,(%esp)
  80020f:	e8 05 0e 00 00       	call   801019 <sys_cputs>

	return b.cnt;
  800214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    

0080021c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800222:	8d 45 0c             	lea    0xc(%ebp),%eax
  800225:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800228:	8b 45 08             	mov    0x8(%ebp),%eax
  80022b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80022e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800232:	89 04 24             	mov    %eax,(%esp)
  800235:	e8 7e ff ff ff       	call   8001b8 <vcprintf>
  80023a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80023d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800240:	c9                   	leave  
  800241:	c3                   	ret    
	...

00800244 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	53                   	push   %ebx
  800248:	83 ec 34             	sub    $0x34,%esp
  80024b:	8b 45 10             	mov    0x10(%ebp),%eax
  80024e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800251:	8b 45 14             	mov    0x14(%ebp),%eax
  800254:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800257:	8b 45 18             	mov    0x18(%ebp),%eax
  80025a:	ba 00 00 00 00       	mov    $0x0,%edx
  80025f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800262:	77 72                	ja     8002d6 <printnum+0x92>
  800264:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800267:	72 05                	jb     80026e <printnum+0x2a>
  800269:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80026c:	77 68                	ja     8002d6 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800271:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800274:	8b 45 18             	mov    0x18(%ebp),%eax
  800277:	ba 00 00 00 00       	mov    $0x0,%edx
  80027c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800280:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80028a:	89 04 24             	mov    %eax,(%esp)
  80028d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800291:	e8 4a 29 00 00       	call   802be0 <__udivdi3>
  800296:	8b 4d 20             	mov    0x20(%ebp),%ecx
  800299:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  80029d:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8002a1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002a4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ba:	89 04 24             	mov    %eax,(%esp)
  8002bd:	e8 82 ff ff ff       	call   800244 <printnum>
  8002c2:	eb 1c                	jmp    8002e0 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cb:	8b 45 20             	mov    0x20(%ebp),%eax
  8002ce:	89 04 24             	mov    %eax,(%esp)
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002d6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8002da:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002de:	7f e4                	jg     8002c4 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002e0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002ee:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002f6:	89 04 24             	mov    %eax,(%esp)
  8002f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002fd:	e8 0e 2a 00 00       	call   802d10 <__umoddi3>
  800302:	05 3c 30 80 00       	add    $0x80303c,%eax
  800307:	0f b6 00             	movzbl (%eax),%eax
  80030a:	0f be c0             	movsbl %al,%eax
  80030d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800310:	89 54 24 04          	mov    %edx,0x4(%esp)
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	8b 45 08             	mov    0x8(%ebp),%eax
  80031a:	ff d0                	call   *%eax
}
  80031c:	83 c4 34             	add    $0x34,%esp
  80031f:	5b                   	pop    %ebx
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800325:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800329:	7e 1c                	jle    800347 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	8d 50 08             	lea    0x8(%eax),%edx
  800333:	8b 45 08             	mov    0x8(%ebp),%eax
  800336:	89 10                	mov    %edx,(%eax)
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	8b 00                	mov    (%eax),%eax
  80033d:	83 e8 08             	sub    $0x8,%eax
  800340:	8b 50 04             	mov    0x4(%eax),%edx
  800343:	8b 00                	mov    (%eax),%eax
  800345:	eb 40                	jmp    800387 <getuint+0x65>
	else if (lflag)
  800347:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80034b:	74 1e                	je     80036b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	8b 00                	mov    (%eax),%eax
  800352:	8d 50 04             	lea    0x4(%eax),%edx
  800355:	8b 45 08             	mov    0x8(%ebp),%eax
  800358:	89 10                	mov    %edx,(%eax)
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	8b 00                	mov    (%eax),%eax
  80035f:	83 e8 04             	sub    $0x4,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	ba 00 00 00 00       	mov    $0x0,%edx
  800369:	eb 1c                	jmp    800387 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 04             	lea    0x4(%eax),%edx
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	8b 00                	mov    (%eax),%eax
  80037d:	83 e8 04             	sub    $0x4,%eax
  800380:	8b 00                	mov    (%eax),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800387:	5d                   	pop    %ebp
  800388:	c3                   	ret    

00800389 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80038c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800390:	7e 1c                	jle    8003ae <getint+0x25>
		return va_arg(*ap, long long);
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	8d 50 08             	lea    0x8(%eax),%edx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	89 10                	mov    %edx,(%eax)
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	83 e8 08             	sub    $0x8,%eax
  8003a7:	8b 50 04             	mov    0x4(%eax),%edx
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	eb 40                	jmp    8003ee <getint+0x65>
	else if (lflag)
  8003ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003b2:	74 1e                	je     8003d2 <getint+0x49>
		return va_arg(*ap, long);
  8003b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	8d 50 04             	lea    0x4(%eax),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	89 10                	mov    %edx,(%eax)
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	83 e8 04             	sub    $0x4,%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	89 c2                	mov    %eax,%edx
  8003cd:	c1 fa 1f             	sar    $0x1f,%edx
  8003d0:	eb 1c                	jmp    8003ee <getint+0x65>
	else
		return va_arg(*ap, int);
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	8d 50 04             	lea    0x4(%eax),%edx
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	89 10                	mov    %edx,(%eax)
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	83 e8 04             	sub    $0x4,%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	89 c2                	mov    %eax,%edx
  8003eb:	c1 fa 1f             	sar    $0x1f,%edx
}
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	56                   	push   %esi
  8003f4:	53                   	push   %ebx
  8003f5:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003f8:	eb 17                	jmp    800411 <vprintfmt+0x21>
			if (ch == '\0')
  8003fa:	85 db                	test   %ebx,%ebx
  8003fc:	0f 84 d1 05 00 00    	je     8009d3 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  800402:	8b 45 0c             	mov    0xc(%ebp),%eax
  800405:	89 44 24 04          	mov    %eax,0x4(%esp)
  800409:	89 1c 24             	mov    %ebx,(%esp)
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800411:	8b 45 10             	mov    0x10(%ebp),%eax
  800414:	0f b6 00             	movzbl (%eax),%eax
  800417:	0f b6 d8             	movzbl %al,%ebx
  80041a:	83 fb 25             	cmp    $0x25,%ebx
  80041d:	0f 95 c0             	setne  %al
  800420:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800424:	84 c0                	test   %al,%al
  800426:	75 d2                	jne    8003fa <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800428:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80042c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800433:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800441:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800448:	eb 04                	jmp    80044e <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80044a:	90                   	nop
  80044b:	eb 01                	jmp    80044e <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80044d:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	8b 45 10             	mov    0x10(%ebp),%eax
  800451:	0f b6 00             	movzbl (%eax),%eax
  800454:	0f b6 d8             	movzbl %al,%ebx
  800457:	89 d8                	mov    %ebx,%eax
  800459:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  80045d:	83 e8 23             	sub    $0x23,%eax
  800460:	83 f8 55             	cmp    $0x55,%eax
  800463:	0f 87 39 05 00 00    	ja     8009a2 <vprintfmt+0x5b2>
  800469:	8b 04 85 84 30 80 00 	mov    0x803084(,%eax,4),%eax
  800470:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800472:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800476:	eb d6                	jmp    80044e <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800478:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80047c:	eb d0                	jmp    80044e <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80047e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800485:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800488:	89 d0                	mov    %edx,%eax
  80048a:	c1 e0 02             	shl    $0x2,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	01 c0                	add    %eax,%eax
  800491:	01 d8                	add    %ebx,%eax
  800493:	83 e8 30             	sub    $0x30,%eax
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800499:	8b 45 10             	mov    0x10(%ebp),%eax
  80049c:	0f b6 00             	movzbl (%eax),%eax
  80049f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8004a5:	7e 43                	jle    8004ea <vprintfmt+0xfa>
  8004a7:	83 fb 39             	cmp    $0x39,%ebx
  8004aa:	7f 3e                	jg     8004ea <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ac:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004b0:	eb d3                	jmp    800485 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	83 c0 04             	add    $0x4,%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	83 e8 04             	sub    $0x4,%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004c6:	eb 23                	jmp    8004eb <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  8004c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004cc:	0f 89 78 ff ff ff    	jns    80044a <vprintfmt+0x5a>
				width = 0;
  8004d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8004d9:	e9 6c ff ff ff       	jmp    80044a <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  8004de:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004e5:	e9 64 ff ff ff       	jmp    80044e <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8004ea:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004ef:	0f 89 58 ff ff ff    	jns    80044d <vprintfmt+0x5d>
				width = precision, precision = -1;
  8004f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004fb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800502:	e9 46 ff ff ff       	jmp    80044d <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800507:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  80050b:	e9 3e ff ff ff       	jmp    80044e <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	83 c0 04             	add    $0x4,%eax
  800516:	89 45 14             	mov    %eax,0x14(%ebp)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	83 e8 04             	sub    $0x4,%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	8b 55 0c             	mov    0xc(%ebp),%edx
  800524:	89 54 24 04          	mov    %edx,0x4(%esp)
  800528:	89 04 24             	mov    %eax,(%esp)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	ff d0                	call   *%eax
			break;
  800530:	e9 98 04 00 00       	jmp    8009cd <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  800535:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  80053c:	00 
  80053d:	8b 45 10             	mov    0x10(%ebp),%eax
  800540:	89 44 24 04          	mov    %eax,0x4(%esp)
  800544:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800547:	89 04 24             	mov    %eax,(%esp)
  80054a:	e8 d1 07 00 00       	call   800d20 <memmove>
            sel_c[3] = '\0';
  80054f:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  800553:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  800557:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80055b:	3c 2f                	cmp    $0x2f,%al
  80055d:	7e 4c                	jle    8005ab <vprintfmt+0x1bb>
  80055f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800563:	3c 39                	cmp    $0x39,%al
  800565:	7f 44                	jg     8005ab <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  800567:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80056b:	0f be d0             	movsbl %al,%edx
  80056e:	89 d0                	mov    %edx,%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	01 d0                	add    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  80057d:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  800581:	0f be c0             	movsbl %al,%eax
  800584:	01 c2                	add    %eax,%edx
  800586:	89 d0                	mov    %edx,%eax
  800588:	c1 e0 02             	shl    $0x2,%eax
  80058b:	01 d0                	add    %edx,%eax
  80058d:	01 c0                	add    %eax,%eax
  80058f:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800595:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  800599:	0f be c0             	movsbl %al,%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	83 e8 30             	sub    $0x30,%eax
  8005a1:	a3 04 60 80 00       	mov    %eax,0x806004
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8005a6:	e9 22 04 00 00       	jmp    8009cd <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  8005ab:	c7 44 24 04 4d 30 80 	movl   $0x80304d,0x4(%esp)
  8005b2:	00 
  8005b3:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8005b6:	89 04 24             	mov    %eax,(%esp)
  8005b9:	e8 36 06 00 00       	call   800bf4 <strcmp>
  8005be:	85 c0                	test   %eax,%eax
  8005c0:	75 0f                	jne    8005d1 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  8005c2:	c7 05 04 60 80 00 07 	movl   $0x7,0x806004
  8005c9:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8005cc:	e9 fc 03 00 00       	jmp    8009cd <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  8005d1:	c7 44 24 04 51 30 80 	movl   $0x803051,0x4(%esp)
  8005d8:	00 
  8005d9:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8005dc:	89 04 24             	mov    %eax,(%esp)
  8005df:	e8 10 06 00 00       	call   800bf4 <strcmp>
  8005e4:	85 c0                	test   %eax,%eax
  8005e6:	75 0f                	jne    8005f7 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  8005e8:	c7 05 04 60 80 00 01 	movl   $0x1,0x806004
  8005ef:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8005f2:	e9 d6 03 00 00       	jmp    8009cd <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  8005f7:	c7 44 24 04 55 30 80 	movl   $0x803055,0x4(%esp)
  8005fe:	00 
  8005ff:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800602:	89 04 24             	mov    %eax,(%esp)
  800605:	e8 ea 05 00 00       	call   800bf4 <strcmp>
  80060a:	85 c0                	test   %eax,%eax
  80060c:	75 0f                	jne    80061d <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  80060e:	c7 05 04 60 80 00 02 	movl   $0x2,0x806004
  800615:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800618:	e9 b0 03 00 00       	jmp    8009cd <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  80061d:	c7 44 24 04 59 30 80 	movl   $0x803059,0x4(%esp)
  800624:	00 
  800625:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800628:	89 04 24             	mov    %eax,(%esp)
  80062b:	e8 c4 05 00 00       	call   800bf4 <strcmp>
  800630:	85 c0                	test   %eax,%eax
  800632:	75 0f                	jne    800643 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  800634:	c7 05 04 60 80 00 04 	movl   $0x4,0x806004
  80063b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80063e:	e9 8a 03 00 00       	jmp    8009cd <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  800643:	c7 44 24 04 5d 30 80 	movl   $0x80305d,0x4(%esp)
  80064a:	00 
  80064b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80064e:	89 04 24             	mov    %eax,(%esp)
  800651:	e8 9e 05 00 00       	call   800bf4 <strcmp>
  800656:	85 c0                	test   %eax,%eax
  800658:	75 0f                	jne    800669 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  80065a:	c7 05 04 60 80 00 08 	movl   $0x8,0x806004
  800661:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800664:	e9 64 03 00 00       	jmp    8009cd <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  800669:	c7 44 24 04 61 30 80 	movl   $0x803061,0x4(%esp)
  800670:	00 
  800671:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800674:	89 04 24             	mov    %eax,(%esp)
  800677:	e8 78 05 00 00       	call   800bf4 <strcmp>
  80067c:	85 c0                	test   %eax,%eax
  80067e:	75 0f                	jne    80068f <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  800680:	c7 05 04 60 80 00 0f 	movl   $0xf,0x806004
  800687:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80068a:	e9 3e 03 00 00       	jmp    8009cd <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  80068f:	c7 44 24 04 65 30 80 	movl   $0x803065,0x4(%esp)
  800696:	00 
  800697:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80069a:	89 04 24             	mov    %eax,(%esp)
  80069d:	e8 52 05 00 00       	call   800bf4 <strcmp>
  8006a2:	85 c0                	test   %eax,%eax
  8006a4:	75 0f                	jne    8006b5 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  8006a6:	c7 05 04 60 80 00 0c 	movl   $0xc,0x806004
  8006ad:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006b0:	e9 18 03 00 00       	jmp    8009cd <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  8006b5:	c7 44 24 04 69 30 80 	movl   $0x803069,0x4(%esp)
  8006bc:	00 
  8006bd:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006c0:	89 04 24             	mov    %eax,(%esp)
  8006c3:	e8 2c 05 00 00       	call   800bf4 <strcmp>
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	75 0f                	jne    8006db <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  8006cc:	c7 05 04 60 80 00 06 	movl   $0x6,0x806004
  8006d3:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006d6:	e9 f2 02 00 00       	jmp    8009cd <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  8006db:	c7 44 24 04 6d 30 80 	movl   $0x80306d,0x4(%esp)
  8006e2:	00 
  8006e3:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006e6:	89 04 24             	mov    %eax,(%esp)
  8006e9:	e8 06 05 00 00       	call   800bf4 <strcmp>
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	75 0f                	jne    800701 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  8006f2:	c7 05 04 60 80 00 0b 	movl   $0xb,0x806004
  8006f9:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006fc:	e9 cc 02 00 00       	jmp    8009cd <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  800701:	c7 05 04 60 80 00 07 	movl   $0x7,0x806004
  800708:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80070b:	e9 bd 02 00 00       	jmp    8009cd <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	83 c0 04             	add    $0x4,%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	83 e8 04             	sub    $0x4,%eax
  80071f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800721:	85 db                	test   %ebx,%ebx
  800723:	79 02                	jns    800727 <vprintfmt+0x337>
				err = -err;
  800725:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800727:	83 fb 0e             	cmp    $0xe,%ebx
  80072a:	7f 0b                	jg     800737 <vprintfmt+0x347>
  80072c:	8b 34 9d 00 30 80 00 	mov    0x803000(,%ebx,4),%esi
  800733:	85 f6                	test   %esi,%esi
  800735:	75 23                	jne    80075a <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  800737:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80073b:	c7 44 24 08 71 30 80 	movl   $0x803071,0x8(%esp)
  800742:	00 
  800743:	8b 45 0c             	mov    0xc(%ebp),%eax
  800746:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 04 24             	mov    %eax,(%esp)
  800750:	e8 86 02 00 00       	call   8009db <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800755:	e9 73 02 00 00       	jmp    8009cd <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80075a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80075e:	c7 44 24 08 7a 30 80 	movl   $0x80307a,0x8(%esp)
  800765:	00 
  800766:	8b 45 0c             	mov    0xc(%ebp),%eax
  800769:	89 44 24 04          	mov    %eax,0x4(%esp)
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	89 04 24             	mov    %eax,(%esp)
  800773:	e8 63 02 00 00       	call   8009db <printfmt>
			break;
  800778:	e9 50 02 00 00       	jmp    8009cd <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	83 c0 04             	add    $0x4,%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	83 e8 04             	sub    $0x4,%eax
  80078c:	8b 30                	mov    (%eax),%esi
  80078e:	85 f6                	test   %esi,%esi
  800790:	75 05                	jne    800797 <vprintfmt+0x3a7>
				p = "(null)";
  800792:	be 7d 30 80 00       	mov    $0x80307d,%esi
			if (width > 0 && padc != '-')
  800797:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80079b:	7e 73                	jle    800810 <vprintfmt+0x420>
  80079d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007a1:	74 6d                	je     800810 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007aa:	89 34 24             	mov    %esi,(%esp)
  8007ad:	e8 4c 03 00 00       	call   800afe <strnlen>
  8007b2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007b5:	eb 17                	jmp    8007ce <vprintfmt+0x3de>
					putch(padc, putdat);
  8007b7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007be:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007c2:	89 04 24             	mov    %eax,(%esp)
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ca:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d2:	7f e3                	jg     8007b7 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d4:	eb 3a                	jmp    800810 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  8007d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007da:	74 1f                	je     8007fb <vprintfmt+0x40b>
  8007dc:	83 fb 1f             	cmp    $0x1f,%ebx
  8007df:	7e 05                	jle    8007e6 <vprintfmt+0x3f6>
  8007e1:	83 fb 7e             	cmp    $0x7e,%ebx
  8007e4:	7e 15                	jle    8007fb <vprintfmt+0x40b>
					putch('?', putdat);
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ed:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	ff d0                	call   *%eax
  8007f9:	eb 0f                	jmp    80080a <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  8007fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800802:	89 1c 24             	mov    %ebx,(%esp)
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80080a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80080e:	eb 01                	jmp    800811 <vprintfmt+0x421>
  800810:	90                   	nop
  800811:	0f b6 06             	movzbl (%esi),%eax
  800814:	0f be d8             	movsbl %al,%ebx
  800817:	85 db                	test   %ebx,%ebx
  800819:	0f 95 c0             	setne  %al
  80081c:	83 c6 01             	add    $0x1,%esi
  80081f:	84 c0                	test   %al,%al
  800821:	74 29                	je     80084c <vprintfmt+0x45c>
  800823:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800827:	78 ad                	js     8007d6 <vprintfmt+0x3e6>
  800829:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80082d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800831:	79 a3                	jns    8007d6 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800833:	eb 17                	jmp    80084c <vprintfmt+0x45c>
				putch(' ', putdat);
  800835:	8b 45 0c             	mov    0xc(%ebp),%eax
  800838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800848:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80084c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800850:	7f e3                	jg     800835 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  800852:	e9 76 01 00 00       	jmp    8009cd <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800857:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085e:	8d 45 14             	lea    0x14(%ebp),%eax
  800861:	89 04 24             	mov    %eax,(%esp)
  800864:	e8 20 fb ff ff       	call   800389 <getint>
  800869:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800875:	85 d2                	test   %edx,%edx
  800877:	79 26                	jns    80089f <vprintfmt+0x4af>
				putch('-', putdat);
  800879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800880:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	ff d0                	call   *%eax
				num = -(long long) num;
  80088c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800892:	f7 d8                	neg    %eax
  800894:	83 d2 00             	adc    $0x0,%edx
  800897:	f7 da                	neg    %edx
  800899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80089f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008a6:	e9 ae 00 00 00       	jmp    800959 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b5:	89 04 24             	mov    %eax,(%esp)
  8008b8:	e8 65 fa ff ff       	call   800322 <getuint>
  8008bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ca:	e9 8a 00 00 00       	jmp    800959 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  8008cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d9:	89 04 24             	mov    %eax,(%esp)
  8008dc:	e8 41 fa ff ff       	call   800322 <getuint>
  8008e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  8008e7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  8008ee:	eb 69                	jmp    800959 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	ff d0                	call   *%eax
			putch('x', putdat);
  800903:	8b 45 0c             	mov    0xc(%ebp),%eax
  800906:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800916:	8b 45 14             	mov    0x14(%ebp),%eax
  800919:	83 c0 04             	add    $0x4,%eax
  80091c:	89 45 14             	mov    %eax,0x14(%ebp)
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	83 e8 04             	sub    $0x4,%eax
  800925:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800927:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800931:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800938:	eb 1f                	jmp    800959 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80093a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80093d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800941:	8d 45 14             	lea    0x14(%ebp),%eax
  800944:	89 04 24             	mov    %eax,(%esp)
  800947:	e8 d6 f9 ff ff       	call   800322 <getuint>
  80094c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800952:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800959:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80095d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800960:	89 54 24 18          	mov    %edx,0x18(%esp)
  800964:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800967:	89 54 24 14          	mov    %edx,0x14(%esp)
  80096b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80096f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800972:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800975:	89 44 24 08          	mov    %eax,0x8(%esp)
  800979:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80097d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800980:	89 44 24 04          	mov    %eax,0x4(%esp)
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	89 04 24             	mov    %eax,(%esp)
  80098a:	e8 b5 f8 ff ff       	call   800244 <printnum>
			break;
  80098f:	eb 3c                	jmp    8009cd <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	89 44 24 04          	mov    %eax,0x4(%esp)
  800998:	89 1c 24             	mov    %ebx,(%esp)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	ff d0                	call   *%eax
			break;
  8009a0:	eb 2b                	jmp    8009cd <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009b9:	eb 04                	jmp    8009bf <vprintfmt+0x5cf>
  8009bb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c2:	83 e8 01             	sub    $0x1,%eax
  8009c5:	0f b6 00             	movzbl (%eax),%eax
  8009c8:	3c 25                	cmp    $0x25,%al
  8009ca:	75 ef                	jne    8009bb <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  8009cc:	90                   	nop
		}
	}
  8009cd:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ce:	e9 3e fa ff ff       	jmp    800411 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  8009d3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009d4:	83 c4 50             	add    $0x50,%esp
  8009d7:	5b                   	pop    %ebx
  8009d8:	5e                   	pop    %esi
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  8009e1:	8d 45 10             	lea    0x10(%ebp),%eax
  8009e4:	83 c0 04             	add    $0x4,%eax
  8009e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	89 04 24             	mov    %eax,(%esp)
  800a05:	e8 e6 f9 ff ff       	call   8003f0 <vprintfmt>
	va_end(ap);
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a12:	8b 40 08             	mov    0x8(%eax),%eax
  800a15:	8d 50 01             	lea    0x1(%eax),%edx
  800a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	8b 10                	mov    (%eax),%edx
  800a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a26:	8b 40 04             	mov    0x4(%eax),%eax
  800a29:	39 c2                	cmp    %eax,%edx
  800a2b:	73 12                	jae    800a3f <sprintputch+0x33>
		*b->buf++ = ch;
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	8b 55 08             	mov    0x8(%ebp),%edx
  800a35:	88 10                	mov    %dl,(%eax)
  800a37:	8d 50 01             	lea    0x1(%eax),%edx
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	89 10                	mov    %edx,(%eax)
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	83 e8 01             	sub    $0x1,%eax
  800a53:	03 45 08             	add    0x8(%ebp),%eax
  800a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a64:	74 06                	je     800a6c <vsnprintf+0x2b>
  800a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a6a:	7f 07                	jg     800a73 <vsnprintf+0x32>
		return -E_INVAL;
  800a6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a71:	eb 2a                	jmp    800a9d <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a81:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a88:	c7 04 24 0c 0a 80 00 	movl   $0x800a0c,(%esp)
  800a8f:	e8 5c f9 ff ff       	call   8003f0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a97:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    

00800a9f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aa5:	8d 45 10             	lea    0x10(%ebp),%eax
  800aa8:	83 c0 04             	add    $0x4,%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800aae:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ab8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	89 04 24             	mov    %eax,(%esp)
  800ac9:	e8 73 ff ff ff       	call   800a41 <vsnprintf>
  800ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    
	...

00800ad8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ade:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae5:	eb 08                	jmp    800aef <strlen+0x17>
		n++;
  800ae7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aeb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	0f b6 00             	movzbl (%eax),%eax
  800af5:	84 c0                	test   %al,%al
  800af7:	75 ee                	jne    800ae7 <strlen+0xf>
		n++;
	return n;
  800af9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    

00800afe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0b:	eb 0c                	jmp    800b19 <strnlen+0x1b>
		n++;
  800b0d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b15:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800b19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1d:	74 0a                	je     800b29 <strnlen+0x2b>
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	0f b6 00             	movzbl (%eax),%eax
  800b25:	84 c0                	test   %al,%al
  800b27:	75 e4                	jne    800b0d <strnlen+0xf>
		n++;
	return n;
  800b29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    

00800b2e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b3a:	90                   	nop
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	0f b6 10             	movzbl (%eax),%edx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	88 10                	mov    %dl,(%eax)
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	0f b6 00             	movzbl (%eax),%eax
  800b4c:	84 c0                	test   %al,%al
  800b4e:	0f 95 c0             	setne  %al
  800b51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b55:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800b59:	84 c0                	test   %al,%al
  800b5b:	75 de                	jne    800b3b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b75:	eb 21                	jmp    800b98 <strncpy+0x36>
		*dst++ = *src;
  800b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7a:	0f b6 10             	movzbl (%eax),%edx
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	88 10                	mov    %dl,(%eax)
  800b82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	0f b6 00             	movzbl (%eax),%eax
  800b8c:	84 c0                	test   %al,%al
  800b8e:	74 04                	je     800b94 <strncpy+0x32>
			src++;
  800b90:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b94:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b9b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b9e:	72 d7                	jb     800b77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ba0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb5:	74 2f                	je     800be6 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800bb7:	eb 13                	jmp    800bcc <strlcpy+0x27>
			*dst++ = *src++;
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	0f b6 10             	movzbl (%eax),%edx
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	88 10                	mov    %dl,(%eax)
  800bc4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bc8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bcc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd4:	74 0a                	je     800be0 <strlcpy+0x3b>
  800bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd9:	0f b6 00             	movzbl (%eax),%eax
  800bdc:	84 c0                	test   %al,%al
  800bde:	75 d9                	jne    800bb9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800be6:	8b 55 08             	mov    0x8(%ebp),%edx
  800be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bec:	89 d1                	mov    %edx,%ecx
  800bee:	29 c1                	sub    %eax,%ecx
  800bf0:	89 c8                	mov    %ecx,%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bf7:	eb 08                	jmp    800c01 <strcmp+0xd>
		p++, q++;
  800bf9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bfd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	0f b6 00             	movzbl (%eax),%eax
  800c07:	84 c0                	test   %al,%al
  800c09:	74 10                	je     800c1b <strcmp+0x27>
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	0f b6 10             	movzbl (%eax),%edx
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	0f b6 00             	movzbl (%eax),%eax
  800c17:	38 c2                	cmp    %al,%dl
  800c19:	74 de                	je     800bf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	0f b6 00             	movzbl (%eax),%eax
  800c21:	0f b6 d0             	movzbl %al,%edx
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	0f b6 00             	movzbl (%eax),%eax
  800c2a:	0f b6 c0             	movzbl %al,%eax
  800c2d:	89 d1                	mov    %edx,%ecx
  800c2f:	29 c1                	sub    %eax,%ecx
  800c31:	89 c8                	mov    %ecx,%eax
}
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c38:	eb 0c                	jmp    800c46 <strncmp+0x11>
		n--, p++, q++;
  800c3a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c3e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c42:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4a:	74 1a                	je     800c66 <strncmp+0x31>
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	0f b6 00             	movzbl (%eax),%eax
  800c52:	84 c0                	test   %al,%al
  800c54:	74 10                	je     800c66 <strncmp+0x31>
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	0f b6 10             	movzbl (%eax),%edx
  800c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5f:	0f b6 00             	movzbl (%eax),%eax
  800c62:	38 c2                	cmp    %al,%dl
  800c64:	74 d4                	je     800c3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6a:	75 07                	jne    800c73 <strncmp+0x3e>
		return 0;
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c71:	eb 18                	jmp    800c8b <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	0f b6 00             	movzbl (%eax),%eax
  800c79:	0f b6 d0             	movzbl %al,%edx
  800c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7f:	0f b6 00             	movzbl (%eax),%eax
  800c82:	0f b6 c0             	movzbl %al,%eax
  800c85:	89 d1                	mov    %edx,%ecx
  800c87:	29 c1                	sub    %eax,%ecx
  800c89:	89 c8                	mov    %ecx,%eax
}
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 04             	sub    $0x4,%esp
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c99:	eb 14                	jmp    800caf <strchr+0x22>
		if (*s == c)
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	0f b6 00             	movzbl (%eax),%eax
  800ca1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca4:	75 05                	jne    800cab <strchr+0x1e>
			return (char *) s;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	eb 13                	jmp    800cbe <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	0f b6 00             	movzbl (%eax),%eax
  800cb5:	84 c0                	test   %al,%al
  800cb7:	75 e2                	jne    800c9b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 04             	sub    $0x4,%esp
  800cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ccc:	eb 0f                	jmp    800cdd <strfind+0x1d>
		if (*s == c)
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	0f b6 00             	movzbl (%eax),%eax
  800cd4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cd7:	74 10                	je     800ce9 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	0f b6 00             	movzbl (%eax),%eax
  800ce3:	84 c0                	test   %al,%al
  800ce5:	75 e7                	jne    800cce <strfind+0xe>
  800ce7:	eb 01                	jmp    800cea <strfind+0x2a>
		if (*s == c)
			break;
  800ce9:	90                   	nop
	return (char *) s;
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <memset>:


void *
memset(void *v, int c, size_t n)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d01:	eb 0e                	jmp    800d11 <memset+0x22>
		*p++ = c;
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	89 c2                	mov    %eax,%edx
  800d08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0b:	88 10                	mov    %dl,(%eax)
  800d0d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d11:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800d15:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d19:	79 e8                	jns    800d03 <memset+0x14>
		*p++ = c;

	return v;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d1e:	c9                   	leave  
  800d1f:	c3                   	ret    

00800d20 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d38:	73 54                	jae    800d8e <memmove+0x6e>
  800d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d40:	01 d0                	add    %edx,%eax
  800d42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d45:	76 47                	jbe    800d8e <memmove+0x6e>
		s += n;
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d53:	eb 13                	jmp    800d68 <memmove+0x48>
			*--d = *--s;
  800d55:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800d59:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800d5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d60:	0f b6 10             	movzbl (%eax),%edx
  800d63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d66:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6c:	0f 95 c0             	setne  %al
  800d6f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d73:	84 c0                	test   %al,%al
  800d75:	75 de                	jne    800d55 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d77:	eb 25                	jmp    800d9e <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7c:	0f b6 10             	movzbl (%eax),%edx
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d82:	88 10                	mov    %dl,(%eax)
  800d84:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800d88:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800d8c:	eb 01                	jmp    800d8f <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d8e:	90                   	nop
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	0f 95 c0             	setne  %al
  800d96:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 db                	jne    800d79 <memmove+0x59>
			*d++ = *s++;

	return dst;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	89 44 24 08          	mov    %eax,0x8(%esp)
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	89 04 24             	mov    %eax,(%esp)
  800dbd:	e8 5e ff ff ff       	call   800d20 <memmove>
}
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    

00800dc4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd6:	eb 32                	jmp    800e0a <memcmp+0x46>
		if (*s1 != *s2)
  800dd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddb:	0f b6 10             	movzbl (%eax),%edx
  800dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de1:	0f b6 00             	movzbl (%eax),%eax
  800de4:	38 c2                	cmp    %al,%dl
  800de6:	74 1a                	je     800e02 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800deb:	0f b6 00             	movzbl (%eax),%eax
  800dee:	0f b6 d0             	movzbl %al,%edx
  800df1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df4:	0f b6 00             	movzbl (%eax),%eax
  800df7:	0f b6 c0             	movzbl %al,%eax
  800dfa:	89 d1                	mov    %edx,%ecx
  800dfc:	29 c1                	sub    %eax,%ecx
  800dfe:	89 c8                	mov    %ecx,%eax
  800e00:	eb 1c                	jmp    800e1e <memcmp+0x5a>
		s1++, s2++;
  800e02:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e06:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0e:	0f 95 c0             	setne  %al
  800e11:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e15:	84 c0                	test   %al,%al
  800e17:	75 bf                	jne    800dd8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e26:	8b 45 10             	mov    0x10(%ebp),%eax
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e31:	eb 11                	jmp    800e44 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	0f b6 10             	movzbl (%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	38 c2                	cmp    %al,%dl
  800e3e:	74 0e                	je     800e4e <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e40:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e4a:	72 e7                	jb     800e33 <memfind+0x13>
  800e4c:	eb 01                	jmp    800e4f <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e4e:	90                   	nop
	return (void *) s;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e61:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e68:	eb 04                	jmp    800e6e <strtol+0x1a>
		s++;
  800e6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	0f b6 00             	movzbl (%eax),%eax
  800e74:	3c 20                	cmp    $0x20,%al
  800e76:	74 f2                	je     800e6a <strtol+0x16>
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	0f b6 00             	movzbl (%eax),%eax
  800e7e:	3c 09                	cmp    $0x9,%al
  800e80:	74 e8                	je     800e6a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	0f b6 00             	movzbl (%eax),%eax
  800e88:	3c 2b                	cmp    $0x2b,%al
  800e8a:	75 06                	jne    800e92 <strtol+0x3e>
		s++;
  800e8c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e90:	eb 15                	jmp    800ea7 <strtol+0x53>
	else if (*s == '-')
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	0f b6 00             	movzbl (%eax),%eax
  800e98:	3c 2d                	cmp    $0x2d,%al
  800e9a:	75 0b                	jne    800ea7 <strtol+0x53>
		s++, neg = 1;
  800e9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ea0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 06                	je     800eb3 <strtol+0x5f>
  800ead:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eb1:	75 24                	jne    800ed7 <strtol+0x83>
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	0f b6 00             	movzbl (%eax),%eax
  800eb9:	3c 30                	cmp    $0x30,%al
  800ebb:	75 1a                	jne    800ed7 <strtol+0x83>
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	83 c0 01             	add    $0x1,%eax
  800ec3:	0f b6 00             	movzbl (%eax),%eax
  800ec6:	3c 78                	cmp    $0x78,%al
  800ec8:	75 0d                	jne    800ed7 <strtol+0x83>
		s += 2, base = 16;
  800eca:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ece:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed5:	eb 2a                	jmp    800f01 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  800ed7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edb:	75 17                	jne    800ef4 <strtol+0xa0>
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	0f b6 00             	movzbl (%eax),%eax
  800ee3:	3c 30                	cmp    $0x30,%al
  800ee5:	75 0d                	jne    800ef4 <strtol+0xa0>
		s++, base = 8;
  800ee7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800eeb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef2:	eb 0d                	jmp    800f01 <strtol+0xad>
	else if (base == 0)
  800ef4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef8:	75 07                	jne    800f01 <strtol+0xad>
		base = 10;
  800efa:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	0f b6 00             	movzbl (%eax),%eax
  800f07:	3c 2f                	cmp    $0x2f,%al
  800f09:	7e 1b                	jle    800f26 <strtol+0xd2>
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	0f b6 00             	movzbl (%eax),%eax
  800f11:	3c 39                	cmp    $0x39,%al
  800f13:	7f 11                	jg     800f26 <strtol+0xd2>
			dig = *s - '0';
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	0f b6 00             	movzbl (%eax),%eax
  800f1b:	0f be c0             	movsbl %al,%eax
  800f1e:	83 e8 30             	sub    $0x30,%eax
  800f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f24:	eb 48                	jmp    800f6e <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	0f b6 00             	movzbl (%eax),%eax
  800f2c:	3c 60                	cmp    $0x60,%al
  800f2e:	7e 1b                	jle    800f4b <strtol+0xf7>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	0f b6 00             	movzbl (%eax),%eax
  800f36:	3c 7a                	cmp    $0x7a,%al
  800f38:	7f 11                	jg     800f4b <strtol+0xf7>
			dig = *s - 'a' + 10;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	0f b6 00             	movzbl (%eax),%eax
  800f40:	0f be c0             	movsbl %al,%eax
  800f43:	83 e8 57             	sub    $0x57,%eax
  800f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f49:	eb 23                	jmp    800f6e <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	0f b6 00             	movzbl (%eax),%eax
  800f51:	3c 40                	cmp    $0x40,%al
  800f53:	7e 38                	jle    800f8d <strtol+0x139>
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	0f b6 00             	movzbl (%eax),%eax
  800f5b:	3c 5a                	cmp    $0x5a,%al
  800f5d:	7f 2e                	jg     800f8d <strtol+0x139>
			dig = *s - 'A' + 10;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	0f b6 00             	movzbl (%eax),%eax
  800f65:	0f be c0             	movsbl %al,%eax
  800f68:	83 e8 37             	sub    $0x37,%eax
  800f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f71:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f74:	7d 16                	jge    800f8c <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  800f76:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f81:	03 45 f4             	add    -0xc(%ebp),%eax
  800f84:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f87:	e9 75 ff ff ff       	jmp    800f01 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f8c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f91:	74 08                	je     800f9b <strtol+0x147>
		*endptr = (char *) s;
  800f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f96:	8b 55 08             	mov    0x8(%ebp),%edx
  800f99:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f9f:	74 07                	je     800fa8 <strtol+0x154>
  800fa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa4:	f7 d8                	neg    %eax
  800fa6:	eb 03                	jmp    800fab <strtol+0x157>
  800fa8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    
  800fad:	00 00                	add    %al,(%eax)
	...

00800fb0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800fbf:	8b 55 10             	mov    0x10(%ebp),%edx
  800fc2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800fc5:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800fc8:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800fcb:	8b 75 20             	mov    0x20(%ebp),%esi
  800fce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fd1:	cd 30                	int    $0x30
  800fd3:	89 c3                	mov    %eax,%ebx
  800fd5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fdc:	74 30                	je     80100e <syscall+0x5e>
  800fde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe2:	7e 2a                	jle    80100e <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fe7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ff2:	c7 44 24 08 dc 31 80 	movl   $0x8031dc,0x8(%esp)
  800ff9:	00 
  800ffa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801001:	00 
  801002:	c7 04 24 f9 31 80 00 	movl   $0x8031f9,(%esp)
  801009:	e8 76 19 00 00       	call   802984 <_panic>

	return ret;
  80100e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801011:	83 c4 4c             	add    $0x4c,%esp
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5f                   	pop    %edi
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801029:	00 
  80102a:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801031:	00 
  801032:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801039:	00 
  80103a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801041:	89 44 24 08          	mov    %eax,0x8(%esp)
  801045:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80104c:	00 
  80104d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801054:	e8 57 ff ff ff       	call   800fb0 <syscall>
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <sys_cgetc>:

int
sys_cgetc(void)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801061:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801068:	00 
  801069:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801070:	00 
  801071:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801078:	00 
  801079:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801080:	00 
  801081:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801088:	00 
  801089:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801090:	00 
  801091:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801098:	e8 13 ff ff ff       	call   800fb0 <syscall>
}
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8010af:	00 
  8010b0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8010b7:	00 
  8010b8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8010bf:	00 
  8010c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8010c7:	00 
  8010c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010d3:	00 
  8010d4:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8010db:	e8 d0 fe ff ff       	call   800fb0 <syscall>
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8010e8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8010ef:	00 
  8010f0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8010f7:	00 
  8010f8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8010ff:	00 
  801100:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801107:	00 
  801108:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80110f:	00 
  801110:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801117:	00 
  801118:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80111f:	e8 8c fe ff ff       	call   800fb0 <syscall>
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <sys_yield>:

void
sys_yield(void)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80112c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801133:	00 
  801134:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80113b:	00 
  80113c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801143:	00 
  801144:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80114b:	00 
  80114c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801153:	00 
  801154:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80115b:	00 
  80115c:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  801163:	e8 48 fe ff ff       	call   800fb0 <syscall>
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801170:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801173:	8b 55 0c             	mov    0xc(%ebp),%edx
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801180:	00 
  801181:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801188:	00 
  801189:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80118d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801191:	89 44 24 08          	mov    %eax,0x8(%esp)
  801195:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80119c:	00 
  80119d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8011a4:	e8 07 fe ff ff       	call   800fb0 <syscall>
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	56                   	push   %esi
  8011af:	53                   	push   %ebx
  8011b0:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8011b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8011b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	89 74 24 18          	mov    %esi,0x18(%esp)
  8011c6:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8011ca:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8011ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011dd:	00 
  8011de:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8011e5:	e8 c6 fd ff ff       	call   800fb0 <syscall>
}
  8011ea:	83 c4 20             	add    $0x20,%esp
  8011ed:	5b                   	pop    %ebx
  8011ee:	5e                   	pop    %esi
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8011f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801204:	00 
  801205:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80120c:	00 
  80120d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801214:	00 
  801215:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801219:	89 44 24 08          	mov    %eax,0x8(%esp)
  80121d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801224:	00 
  801225:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  80122c:	e8 7f fd ff ff       	call   800fb0 <syscall>
}
  801231:	c9                   	leave  
  801232:	c3                   	ret    

00801233 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  801239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801246:	00 
  801247:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80124e:	00 
  80124f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801256:	00 
  801257:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80125b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80125f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801266:	00 
  801267:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  80126e:	e8 3d fd ff ff       	call   800fb0 <syscall>
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801288:	00 
  801289:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801290:	00 
  801291:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801298:	00 
  801299:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80129d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012a8:	00 
  8012a9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8012b0:	e8 fb fc ff ff       	call   800fb0 <syscall>
}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8012bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012ca:	00 
  8012cb:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012d2:	00 
  8012d3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012da:	00 
  8012db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012ea:	00 
  8012eb:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  8012f2:	e8 b9 fc ff ff       	call   800fb0 <syscall>
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8012ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80130c:	00 
  80130d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801314:	00 
  801315:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80131c:	00 
  80131d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801321:	89 44 24 08          	mov    %eax,0x8(%esp)
  801325:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80132c:	00 
  80132d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801334:	e8 77 fc ff ff       	call   800fb0 <syscall>
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801341:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801344:	8b 55 10             	mov    0x10(%ebp),%edx
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801351:	00 
  801352:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  801356:	89 54 24 10          	mov    %edx,0x10(%esp)
  80135a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801361:	89 44 24 08          	mov    %eax,0x8(%esp)
  801365:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80136c:	00 
  80136d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  801374:	e8 37 fc ff ff       	call   800fb0 <syscall>
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80138b:	00 
  80138c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801393:	00 
  801394:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80139b:	00 
  80139c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013a3:	00 
  8013a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013af:	00 
  8013b0:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  8013b7:	e8 f4 fb ff ff       	call   800fb0 <syscall>
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    
	...

008013c0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 38             	sub    $0x38,%esp
	void *addr = (void *) utf->utf_fault_va;
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8b 00                	mov    (%eax),%eax
  8013cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t err = utf->utf_err;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8b 40 04             	mov    0x4(%eax),%eax
  8013d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	// LAB 4: Your code here.
	//FEC_WR pf caused by a write
	//
	//if((err & FEC_WR)==0) cprintf("err : %08x\n", err);
	//if((vpt[VPN(addr)] & PTE_COW) == 0) cprintf("pte : %x\n", vpt[VPN(addr)]);
    if((err & FEC_WR) == 0 || (vpd[VPD(addr)] & PTE_P) == 0 || (vpt[VPN(addr)] & PTE_COW) == 0){
  8013d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013da:	83 e0 02             	and    $0x2,%eax
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	74 2a                	je     80140b <pgfault+0x4b>
  8013e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e4:	c1 e8 16             	shr    $0x16,%eax
  8013e7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013ee:	83 e0 01             	and    $0x1,%eax
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	74 16                	je     80140b <pgfault+0x4b>
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	c1 e8 0c             	shr    $0xc,%eax
  8013fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801402:	25 00 08 00 00       	and    $0x800,%eax
  801407:	85 c0                	test   %eax,%eax
  801409:	75 1c                	jne    801427 <pgfault+0x67>
		//cprintf("\n%e %e %e\n",(err & FEC_WR), (vpd[VPD(addr)] & PTE_P), (vpt[VPN(addr)] & PTE_COW));
		panic("pgfault: not a write or attempting to access a non_COW page\n");
  80140b:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  801412:	00 
  801413:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80141a:	00 
  80141b:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801422:	e8 5d 15 00 00       	call   802984 <_panic>
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((r = sys_page_alloc(0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0){
  801427:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80142e:	00 
  80142f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801436:	00 
  801437:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143e:	e8 27 fd ff ff       	call   80116a <sys_page_alloc>
  801443:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801446:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80144a:	79 23                	jns    80146f <pgfault+0xaf>
		panic("pgfault page allocation failed : %e\n", r);
  80144c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80144f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801453:	c7 44 24 08 50 32 80 	movl   $0x803250,0x8(%esp)
  80145a:	00 
  80145b:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801462:	00 
  801463:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  80146a:	e8 15 15 00 00       	call   802984 <_panic>
	}
	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80146f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801472:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801478:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	memmove(PFTEMP, addr, PGSIZE);
  801480:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801487:	00 
  801488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801496:	e8 85 f8 ff ff       	call   800d20 <memmove>
	
	if((r = sys_page_map(0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0){
  80149b:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014a2:	00 
  8014a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014b1:	00 
  8014b2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014b9:	00 
  8014ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c1:	e8 e5 fc ff ff       	call   8011ab <sys_page_map>
  8014c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014cd:	79 23                	jns    8014f2 <pgfault+0x132>
		panic("pgfault: page mapping failed %e\n", r);
  8014cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d6:	c7 44 24 08 78 32 80 	movl   $0x803278,0x8(%esp)
  8014dd:	00 
  8014de:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8014e5:	00 
  8014e6:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  8014ed:	e8 92 14 00 00       	call   802984 <_panic>
	}
	//panic("pgfault not implemented");
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
// COW's copy
static int
duppage(envid_t envid, unsigned pn)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 38             	sub    $0x38,%esp
	int r;
	void *addr;
	pte_t pte;
    addr = (void *)((uint32_t)pn * PGSIZE);
  8014fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fd:	c1 e0 0c             	shl    $0xc,%eax
  801500:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pte = vpt[VPN(addr)];//the pt
  801503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801506:	c1 e8 0c             	shr    $0xc,%eax
  801509:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801510:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    if((pte & PTE_W) > 0||(pte & PTE_COW) > 0){
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801516:	83 e0 02             	and    $0x2,%eax
  801519:	85 c0                	test   %eax,%eax
  80151b:	75 10                	jne    80152d <duppage+0x39>
  80151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801520:	25 00 08 00 00       	and    $0x800,%eax
  801525:	85 c0                	test   %eax,%eax
  801527:	0f 84 9d 00 00 00    	je     8015ca <duppage+0xd6>
		//two change ok
		if((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0){
  80152d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801534:	00 
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801551:	e8 55 fc ff ff       	call   8011ab <sys_page_map>
  801556:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801559:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80155d:	79 1c                	jns    80157b <duppage+0x87>
			panic("sys page map envid --> 0 failed ,parent copy to child\n");
  80155f:	c7 44 24 08 9c 32 80 	movl   $0x80329c,0x8(%esp)
  801566:	00 
  801567:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80156e:	00 
  80156f:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801576:	e8 09 14 00 00       	call   802984 <_panic>
			}
		if((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0){
  80157b:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801582:	00 
  801583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801586:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80158a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801591:	00 
  801592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801595:	89 44 24 04          	mov    %eax,0x4(%esp)
  801599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a0:	e8 06 fc ff ff       	call   8011ab <sys_page_map>
  8015a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015ac:	79 6a                	jns    801618 <duppage+0x124>
			panic("sys page map 0 --> 0 failed ,parent copy it self\n");
  8015ae:	c7 44 24 08 d4 32 80 	movl   $0x8032d4,0x8(%esp)
  8015b5:	00 
  8015b6:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8015bd:	00 
  8015be:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  8015c5:	e8 ba 13 00 00       	call   802984 <_panic>
			}
	}
	else{//the read, can't change  |PTE_COW
		if((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U)) < 0){
  8015ca:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8015d1:	00 
  8015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ee:	e8 b8 fb ff ff       	call   8011ab <sys_page_map>
  8015f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015fa:	79 1c                	jns    801618 <duppage+0x124>
			panic("sys page map envid --> 0 failed ,parent copy to child\n");
  8015fc:	c7 44 24 08 9c 32 80 	movl   $0x80329c,0x8(%esp)
  801603:	00 
  801604:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  80160b:	00 
  80160c:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801613:	e8 6c 13 00 00       	call   802984 <_panic>
			}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	53                   	push   %ebx
  801623:	83 ec 34             	sub    $0x34,%esp
	// LAB 4: Your code here.
	//
	//set_pgfault_handler
	set_pgfault_handler(pgfault);
  801626:	c7 04 24 c0 13 80 00 	movl   $0x8013c0,(%esp)
  80162d:	e8 c6 13 00 00       	call   8029f8 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801632:	c7 45 e4 07 00 00 00 	movl   $0x7,-0x1c(%ebp)
  801639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80163c:	cd 30                	int    $0x30
  80163e:	89 c3                	mov    %eax,%ebx
  801640:	89 5d e8             	mov    %ebx,-0x18(%ebp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801643:	8b 45 e8             	mov    -0x18(%ebp),%eax
	//new a child
	envid_t newenv;
	uint32_t addr;
	int r;
	
	newenv = sys_exofork();//new envid
  801646:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("finish create a env %d\n", newenv);
	if(newenv < 0) panic("envid < 0 ,failed in exofork\n");
  801649:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80164d:	79 1c                	jns    80166b <fork+0x4c>
  80164f:	c7 44 24 08 06 33 80 	movl   $0x803306,0x8(%esp)
  801656:	00 
  801657:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  80165e:	00 
  80165f:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801666:	e8 19 13 00 00       	call   802984 <_panic>
	if(newenv == 0){
  80166b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80166f:	75 21                	jne    801692 <fork+0x73>
		//ENVX get the id's low 10 bit
		env = &envs[ENVX(sys_getenvid())];
  801671:	e8 6c fa ff ff       	call   8010e2 <sys_getenvid>
  801676:	25 ff 03 00 00       	and    $0x3ff,%eax
  80167b:	c1 e0 07             	shl    $0x7,%eax
  80167e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801683:	a3 40 60 80 00       	mov    %eax,0x806040
		return 0;
  801688:	b8 00 00 00 00       	mov    $0x0,%eax
  80168d:	e9 f8 00 00 00       	jmp    80178a <fork+0x16b>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  801692:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  801699:	eb 58                	jmp    8016f3 <fork+0xd4>
		/*pte = vpt[VPN(addr)];
		pde = vpd[VPD(addr)];
		if((pde & PTE_P) > 0 && (pte & PTE_P) > 0 && (pte & PTE_U) > 0){
			duppage(newenv, VPN(addr));
			}*/
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
  80169b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169e:	c1 e8 16             	shr    $0x16,%eax
  8016a1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016a8:	83 e0 01             	and    $0x1,%eax
  8016ab:	84 c0                	test   %al,%al
  8016ad:	74 3d                	je     8016ec <fork+0xcd>
  8016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b2:	c1 e8 0c             	shr    $0xc,%eax
  8016b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016bc:	83 e0 01             	and    $0x1,%eax
  8016bf:	84 c0                	test   %al,%al
  8016c1:	74 29                	je     8016ec <fork+0xcd>
  8016c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c6:	c1 e8 0c             	shr    $0xc,%eax
  8016c9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016d0:	83 e0 04             	and    $0x4,%eax
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 15                	je     8016ec <fork+0xcd>
	        duppage (newenv, VPN(addr));
  8016d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016da:	c1 e8 0c             	shr    $0xc,%eax
  8016dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	89 04 24             	mov    %eax,(%esp)
  8016e7:	e8 08 fe ff ff       	call   8014f4 <duppage>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  8016ec:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8016f3:	81 7d f4 ff ef bf ee 	cmpl   $0xeebfefff,-0xc(%ebp)
  8016fa:	76 9f                	jbe    80169b <fork+0x7c>
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
	        duppage (newenv, VPN(addr));
		}
	//cprintf("finish map PGSIZE\n");
	//user exception stack
	if((r = sys_page_alloc(newenv, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0){
  8016fc:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801703:	00 
  801704:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80170b:	ee 
  80170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170f:	89 04 24             	mov    %eax,(%esp)
  801712:	e8 53 fa ff ff       	call   80116a <sys_page_alloc>
  801717:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80171a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80171e:	79 1c                	jns    80173c <fork+0x11d>
		panic("fork alloc page failed\n");
  801720:	c7 44 24 08 24 33 80 	movl   $0x803324,0x8(%esp)
  801727:	00 
  801728:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  80172f:	00 
  801730:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801737:	e8 48 12 00 00       	call   802984 <_panic>
		}
	//
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(newenv, _pgfault_upcall);
  80173c:	c7 44 24 04 8c 2a 80 	movl   $0x802a8c,0x4(%esp)
  801743:	00 
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801747:	89 04 24             	mov    %eax,(%esp)
  80174a:	e8 aa fb ff ff       	call   8012f9 <sys_env_set_pgfault_upcall>
	//panic("fork not implemented");
	//set it runable
	if((r = sys_env_set_status(newenv, ENV_RUNNABLE)) < 0){
  80174f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801756:	00 
  801757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175a:	89 04 24             	mov    %eax,(%esp)
  80175d:	e8 13 fb ff ff       	call   801275 <sys_env_set_status>
  801762:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801765:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801769:	79 1c                	jns    801787 <fork+0x168>
		panic("set runnable failed\n");
  80176b:	c7 44 24 08 3c 33 80 	movl   $0x80333c,0x8(%esp)
  801772:	00 
  801773:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  80177a:	00 
  80177b:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801782:	e8 fd 11 00 00       	call   802984 <_panic>
		}
	
	return newenv;
  801787:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80178a:	83 c4 34             	add    $0x34,%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <sduppage>:

// Challenge!

static int
sduppage(envid_t envid, unsigned pn, int need_cow)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 38             	sub    $0x38,%esp
	int r;
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
  801796:	8b 45 0c             	mov    0xc(%ebp),%eax
  801799:	c1 e0 0c             	shl    $0xc,%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	pte_t pte = vpt[VPN(addr)];
  80179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a2:	c1 e8 0c             	shr    $0xc,%eax
  8017a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(need_cow || (pte & PTE_COW) > 0) {
  8017af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b3:	75 10                	jne    8017c5 <sduppage+0x35>
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	25 00 08 00 00       	and    $0x800,%eax
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	0f 84 af 00 00 00    	je     801874 <sduppage+0xe4>
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  8017c5:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8017cc:	00 
  8017cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e9:	e8 bd f9 ff ff       	call   8011ab <sys_page_map>
  8017ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f5:	79 23                	jns    80181a <sduppage+0x8a>
		    panic ("duppage: page re-mapping failed at 1 : %e", r);
  8017f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017fe:	c7 44 24 08 54 33 80 	movl   $0x803354,0x8(%esp)
  801805:	00 
  801806:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  80180d:	00 
  80180e:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801815:	e8 6a 11 00 00       	call   802984 <_panic>
        if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
  80181a:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801821:	00 
  801822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801825:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801829:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801830:	00 
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	89 44 24 04          	mov    %eax,0x4(%esp)
  801838:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80183f:	e8 67 f9 ff ff       	call   8011ab <sys_page_map>
  801844:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801847:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80184b:	0f 89 d7 00 00 00    	jns    801928 <sduppage+0x198>
            panic ("duppage: page re-mapping failed at 2 : %e", r);
  801851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801854:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801858:	c7 44 24 08 80 33 80 	movl   $0x803380,0x8(%esp)
  80185f:	00 
  801860:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  801867:	00 
  801868:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  80186f:	e8 10 11 00 00       	call   802984 <_panic>
    }else if ((pte & PTE_W) > 0) {
  801874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801877:	83 e0 02             	and    $0x2,%eax
  80187a:	85 c0                	test   %eax,%eax
  80187c:	74 55                	je     8018d3 <sduppage+0x143>
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_W|PTE_P)) < 0)
  80187e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801885:	00 
  801886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801889:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	89 44 24 08          	mov    %eax,0x8(%esp)
  801894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a2:	e8 04 f9 ff ff       	call   8011ab <sys_page_map>
  8018a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018ae:	79 78                	jns    801928 <sduppage+0x198>
		    panic ("duppage: page re-mapping failed at 3 : %e", r);
  8018b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018b7:	c7 44 24 08 ac 33 80 	movl   $0x8033ac,0x8(%esp)
  8018be:	00 
  8018bf:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  8018c6:	00 
  8018c7:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  8018ce:	e8 b1 10 00 00       	call   802984 <_panic>
    }else {
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8018d3:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8018da:	00 
  8018db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f7:	e8 af f8 ff ff       	call   8011ab <sys_page_map>
  8018fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801903:	79 23                	jns    801928 <sduppage+0x198>
		    panic ("duppage: page re-mapping failed at 4 : %e", r);
  801905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801908:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80190c:	c7 44 24 08 d8 33 80 	movl   $0x8033d8,0x8(%esp)
  801913:	00 
  801914:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  80191b:	00 
  80191c:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801923:	e8 5c 10 00 00       	call   802984 <_panic>
    }
    return 0;
  801928:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sfork>:


int
sfork(void)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	53                   	push   %ebx
  801933:	83 ec 44             	sub    $0x44,%esp
	//panic("sfork not implemented");
	//set_pgfault_handler
	set_pgfault_handler(pgfault);
  801936:	c7 04 24 c0 13 80 00 	movl   $0x8013c0,(%esp)
  80193d:	e8 b6 10 00 00       	call   8029f8 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801942:	c7 45 d4 07 00 00 00 	movl   $0x7,-0x2c(%ebp)
  801949:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80194c:	cd 30                	int    $0x30
  80194e:	89 c3                	mov    %eax,%ebx
  801950:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	//new a child
	envid_t newenv;
	uint32_t addr;
	int r;
	
	newenv = sys_exofork();//new envid
  801956:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//cprintf("finish create a env %d\n", newenv);
	if(newenv < 0) panic("envid < 0 ,failed in exofork\n");
  801959:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80195d:	79 1c                	jns    80197b <sfork+0x4c>
  80195f:	c7 44 24 08 06 33 80 	movl   $0x803306,0x8(%esp)
  801966:	00 
  801967:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  80196e:	00 
  80196f:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801976:	e8 09 10 00 00       	call   802984 <_panic>
	if(newenv == 0){
  80197b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80197f:	75 21                	jne    8019a2 <sfork+0x73>
		//ENVX get the id's low 10 bit
		env = &envs[ENVX(sys_getenvid())];
  801981:	e8 5c f7 ff ff       	call   8010e2 <sys_getenvid>
  801986:	25 ff 03 00 00       	and    $0x3ff,%eax
  80198b:	c1 e0 07             	shl    $0x7,%eax
  80198e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801993:	a3 40 60 80 00       	mov    %eax,0x806040
		return 0;
  801998:	b8 00 00 00 00       	mov    $0x0,%eax
  80199d:	e9 11 01 00 00       	jmp    801ab3 <sfork+0x184>
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	int mark_COW = 1;
  8019a2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  8019a9:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8019b0:	eb 6a                	jmp    801a1c <sfork+0xed>
		/*pte = vpt[VPN(addr)];
		pde = vpd[VPD(addr)];
		if((pde & PTE_P) > 0 && (pte & PTE_P) > 0 && (pte & PTE_U) > 0){
			duppage(newenv, VPN(addr));
			}*/
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
  8019b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b5:	c1 e8 16             	shr    $0x16,%eax
  8019b8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019bf:	83 e0 01             	and    $0x1,%eax
  8019c2:	84 c0                	test   %al,%al
  8019c4:	74 48                	je     801a0e <sfork+0xdf>
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	c1 e8 0c             	shr    $0xc,%eax
  8019cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019d3:	83 e0 01             	and    $0x1,%eax
  8019d6:	84 c0                	test   %al,%al
  8019d8:	74 34                	je     801a0e <sfork+0xdf>
  8019da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019dd:	c1 e8 0c             	shr    $0xc,%eax
  8019e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019e7:	83 e0 04             	and    $0x4,%eax
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	74 20                	je     801a0e <sfork+0xdf>
	        sduppage (newenv, VPN(addr), mark_COW);
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	89 c2                	mov    %eax,%edx
  8019f3:	c1 ea 0c             	shr    $0xc,%edx
  8019f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a04:	89 04 24             	mov    %eax,(%esp)
  801a07:	e8 84 fd ff ff       	call   801790 <sduppage>
  801a0c:	eb 07                	jmp    801a15 <sfork+0xe6>
		else mark_COW = 0;
  801a0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	int mark_COW = 1;
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
  801a15:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801a1c:	81 7d f4 ff ef bf ee 	cmpl   $0xeebfefff,-0xc(%ebp)
  801a23:	76 8d                	jbe    8019b2 <sfork+0x83>
	        sduppage (newenv, VPN(addr), mark_COW);
		else mark_COW = 0;
	}
	//cprintf("finish map PGSIZE\n");
	//user exception stack
	if((r = sys_page_alloc(newenv, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0){
  801a25:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a2c:	00 
  801a2d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801a34:	ee 
  801a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a38:	89 04 24             	mov    %eax,(%esp)
  801a3b:	e8 2a f7 ff ff       	call   80116a <sys_page_alloc>
  801a40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a47:	79 1c                	jns    801a65 <sfork+0x136>
		panic("fork alloc page failed\n");
  801a49:	c7 44 24 08 24 33 80 	movl   $0x803324,0x8(%esp)
  801a50:	00 
  801a51:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  801a58:	00 
  801a59:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801a60:	e8 1f 0f 00 00       	call   802984 <_panic>
		}
	//
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(newenv, _pgfault_upcall);
  801a65:	c7 44 24 04 8c 2a 80 	movl   $0x802a8c,0x4(%esp)
  801a6c:	00 
  801a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a70:	89 04 24             	mov    %eax,(%esp)
  801a73:	e8 81 f8 ff ff       	call   8012f9 <sys_env_set_pgfault_upcall>
	//panic("fork not implemented");
	//set it runable
	if((r = sys_env_set_status(newenv, ENV_RUNNABLE)) < 0){
  801a78:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a7f:	00 
  801a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a83:	89 04 24             	mov    %eax,(%esp)
  801a86:	e8 ea f7 ff ff       	call   801275 <sys_env_set_status>
  801a8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a92:	79 1c                	jns    801ab0 <sfork+0x181>
		panic("set runnable failed\n");
  801a94:	c7 44 24 08 3c 33 80 	movl   $0x80333c,0x8(%esp)
  801a9b:	00 
  801a9c:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801aa3:	00 
  801aa4:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801aab:	e8 d4 0e 00 00       	call   802984 <_panic>
		}
	
	return newenv;
  801ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ab3:	83 c4 44             	add    $0x44,%esp
  801ab6:	5b                   	pop    %ebx
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
  801ab9:	00 00                	add    %al,(%eax)
	...

00801abc <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	89 04 24             	mov    %eax,(%esp)
  801ac8:	e8 0a 00 00 00       	call   801ad7 <fd2num>
  801acd:	05 40 03 00 00       	add    $0x340,%eax
  801ad2:	c1 e0 16             	shl    $0x16,%eax
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	05 00 00 40 30       	add    $0x30400000,%eax
  801ae2:	c1 e8 0c             	shr    $0xc,%eax
}
  801ae5:	5d                   	pop    %ebp
  801ae6:	c3                   	ret    

00801ae7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801aed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801af4:	eb 49                	jmp    801b3f <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  801af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af9:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801afe:	c1 e0 0c             	shl    $0xc,%eax
  801b01:	89 c2                	mov    %eax,%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	8b 00                	mov    (%eax),%eax
  801b0d:	c1 e8 16             	shr    $0x16,%eax
  801b10:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b17:	83 e0 01             	and    $0x1,%eax
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	74 16                	je     801b34 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	c1 e8 0c             	shr    $0xc,%eax
  801b26:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b2d:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801b30:	85 c0                	test   %eax,%eax
  801b32:	75 07                	jne    801b3b <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  801b34:	b8 00 00 00 00       	mov    $0x0,%eax
  801b39:	eb 18                	jmp    801b53 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801b3b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801b3f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  801b43:	7e b1                	jle    801af6 <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  801b4e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  801b5b:	c7 44 24 08 04 34 80 	movl   $0x803404,0x8(%esp)
  801b62:	00 
  801b63:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801b6a:	00 
  801b6b:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  801b72:	e8 0d 0e 00 00       	call   802984 <_panic>

00801b77 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	89 04 24             	mov    %eax,(%esp)
  801b83:	e8 4f ff ff ff       	call   801ad7 <fd2num>
  801b88:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b8f:	89 04 24             	mov    %eax,(%esp)
  801b92:	e8 be ff ff ff       	call   801b55 <fd_lookup>
  801b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b9e:	78 08                	js     801ba8 <fd_close+0x31>
	    || fd != fd2)
  801ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba3:	39 45 08             	cmp    %eax,0x8(%ebp)
  801ba6:	74 12                	je     801bba <fd_close+0x43>
		return (must_exist ? r : 0);
  801ba8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bac:	74 05                	je     801bb3 <fd_close+0x3c>
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	eb 05                	jmp    801bb8 <fd_close+0x41>
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb8:	eb 44                	jmp    801bfe <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 55 ec             	lea    -0x14(%ebp),%edx
  801bc2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bc6:	89 04 24             	mov    %eax,(%esp)
  801bc9:	e8 32 00 00 00       	call   801c00 <dev_lookup>
  801bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bd5:	78 11                	js     801be8 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  801bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bda:	8b 50 10             	mov    0x10(%eax),%edx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	89 04 24             	mov    %eax,(%esp)
  801be3:	ff d2                	call   *%edx
  801be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf6:	e8 f6 f5 ff ff       	call   8011f1 <sys_page_unmap>
	return r;
  801bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  801c06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c0d:	eb 2b                	jmp    801c3a <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	8b 04 85 08 60 80 00 	mov    0x806008(,%eax,4),%eax
  801c19:	8b 00                	mov    (%eax),%eax
  801c1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c1e:	75 16                	jne    801c36 <dev_lookup+0x36>
			*dev = devtab[i];
  801c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c23:	8b 14 85 08 60 80 00 	mov    0x806008(,%eax,4),%edx
  801c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2d:	89 10                	mov    %edx,(%eax)
			return 0;
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c34:	eb 3f                	jmp    801c75 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c36:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3d:	8b 04 85 08 60 80 00 	mov    0x806008(,%eax,4),%eax
  801c44:	85 c0                	test   %eax,%eax
  801c46:	75 c7                	jne    801c0f <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801c48:	a1 40 60 80 00       	mov    0x806040,%eax
  801c4d:	8b 40 4c             	mov    0x4c(%eax),%eax
  801c50:	8b 55 08             	mov    0x8(%ebp),%edx
  801c53:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5b:	c7 04 24 28 34 80 00 	movl   $0x803428,(%esp)
  801c62:	e8 b5 e5 ff ff       	call   80021c <cprintf>
	*dev = 0;
  801c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801c70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <close>:

int
close(int fdnum)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c7d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	89 04 24             	mov    %eax,(%esp)
  801c8a:	e8 c6 fe ff ff       	call   801b55 <fd_lookup>
  801c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c96:	79 05                	jns    801c9d <close+0x26>
		return r;
  801c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9b:	eb 13                	jmp    801cb0 <close+0x39>
	else
		return fd_close(fd, 1);
  801c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ca7:	00 
  801ca8:	89 04 24             	mov    %eax,(%esp)
  801cab:	e8 c7 fe ff ff       	call   801b77 <fd_close>
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <close_all>:

void
close_all(void)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801cb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cbf:	eb 0f                	jmp    801cd0 <close_all+0x1e>
		close(i);
  801cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc4:	89 04 24             	mov    %eax,(%esp)
  801cc7:	e8 ab ff ff ff       	call   801c77 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ccc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801cd0:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  801cd4:	7e eb                	jle    801cc1 <close_all+0xf>
		close(i);
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801cde:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	89 04 24             	mov    %eax,(%esp)
  801ceb:	e8 65 fe ff ff       	call   801b55 <fd_lookup>
  801cf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf7:	79 08                	jns    801d01 <dup+0x29>
		return r;
  801cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfc:	e9 54 01 00 00       	jmp    801e55 <dup+0x17d>
	close(newfdnum);
  801d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d04:	89 04 24             	mov    %eax,(%esp)
  801d07:	e8 6b ff ff ff       	call   801c77 <close>

	newfd = INDEX2FD(newfdnum);
  801d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0f:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801d14:	c1 e0 0c             	shl    $0xc,%eax
  801d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  801d1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d1d:	89 04 24             	mov    %eax,(%esp)
  801d20:	e8 97 fd ff ff       	call   801abc <fd2data>
  801d25:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	89 04 24             	mov    %eax,(%esp)
  801d2e:	e8 89 fd ff ff       	call   801abc <fd2data>
  801d33:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801d36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d39:	c1 e8 0c             	shr    $0xc,%eax
  801d3c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d43:	89 c2                	mov    %eax,%edx
  801d45:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801d4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d4e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d55:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d59:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d60:	00 
  801d61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d6c:	e8 3a f4 ff ff       	call   8011ab <sys_page_map>
  801d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d78:	0f 88 8e 00 00 00    	js     801e0c <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  801d7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d81:	c1 e8 16             	shr    $0x16,%eax
  801d84:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	74 78                	je     801e07 <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d96:	eb 66                	jmp    801dfe <dup+0x126>
			pte = vpt[VPN(ova + i)];
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	03 45 e8             	add    -0x18(%ebp),%eax
  801d9e:	c1 e8 0c             	shr    $0xc,%eax
  801da1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801da8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  801dab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dae:	83 e0 01             	and    $0x1,%eax
  801db1:	84 c0                	test   %al,%al
  801db3:	74 42                	je     801df7 <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db8:	89 c1                	mov    %eax,%ecx
  801dba:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	03 55 e4             	add    -0x1c(%ebp),%edx
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	03 45 e8             	add    -0x18(%ebp),%eax
  801dce:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801dd2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dd6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ddd:	00 
  801dde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801de9:	e8 bd f3 ff ff       	call   8011ab <sys_page_map>
  801dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801df1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801df5:	78 18                	js     801e0f <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801df7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801dfe:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801e05:	7e 91                	jle    801d98 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  801e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0a:	eb 49                	jmp    801e55 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  801e0c:	90                   	nop
  801e0d:	eb 01                	jmp    801e10 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  801e0f:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e1e:	e8 ce f3 ff ff       	call   8011f1 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801e23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e2a:	eb 1d                	jmp    801e49 <dup+0x171>
		sys_page_unmap(0, nva + i);
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	03 45 e4             	add    -0x1c(%ebp),%eax
  801e32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e3d:	e8 af f3 ff ff       	call   8011f1 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801e42:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801e49:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801e50:	7e da                	jle    801e2c <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  801e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	89 04 24             	mov    %eax,(%esp)
  801e6a:	e8 e6 fc ff ff       	call   801b55 <fd_lookup>
  801e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e76:	78 1d                	js     801e95 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7b:	8b 00                	mov    (%eax),%eax
  801e7d:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801e80:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e84:	89 04 24             	mov    %eax,(%esp)
  801e87:	e8 74 fd ff ff       	call   801c00 <dev_lookup>
  801e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e93:	79 05                	jns    801e9a <read+0x43>
		return r;
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	eb 75                	jmp    801f0f <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9d:	8b 40 08             	mov    0x8(%eax),%eax
  801ea0:	83 e0 03             	and    $0x3,%eax
  801ea3:	83 f8 01             	cmp    $0x1,%eax
  801ea6:	75 26                	jne    801ece <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801ea8:	a1 40 60 80 00       	mov    0x806040,%eax
  801ead:	8b 40 4c             	mov    0x4c(%eax),%eax
  801eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb3:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ebb:	c7 04 24 47 34 80 00 	movl   $0x803447,(%esp)
  801ec2:	e8 55 e3 ff ff       	call   80021c <cprintf>
		return -E_INVAL;
  801ec7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ecc:	eb 41                	jmp    801f0f <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed1:	8b 48 08             	mov    0x8(%eax),%ecx
  801ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed7:	8b 50 04             	mov    0x4(%eax),%edx
  801eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ee1:	8b 55 10             	mov    0x10(%ebp),%edx
  801ee4:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eeb:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eef:	89 04 24             	mov    %eax,(%esp)
  801ef2:	ff d1                	call   *%ecx
  801ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  801ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efb:	78 0f                	js     801f0c <read+0xb5>
		fd->fd_offset += r;
  801efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f03:	8b 52 04             	mov    0x4(%edx),%edx
  801f06:	03 55 f4             	add    -0xc(%ebp),%edx
  801f09:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801f17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f1e:	eb 3b                	jmp    801f5b <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 55 10             	mov    0x10(%ebp),%edx
  801f26:	29 c2                	sub    %eax,%edx
  801f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2b:	03 45 0c             	add    0xc(%ebp),%eax
  801f2e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	89 04 24             	mov    %eax,(%esp)
  801f3c:	e8 16 ff ff ff       	call   801e57 <read>
  801f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  801f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f48:	79 05                	jns    801f4f <readn+0x3e>
			return m;
  801f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4d:	eb 1a                	jmp    801f69 <readn+0x58>
		if (m == 0)
  801f4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f53:	74 10                	je     801f65 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f58:	01 45 f4             	add    %eax,-0xc(%ebp)
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f61:	72 bd                	jb     801f20 <readn+0xf>
  801f63:	eb 01                	jmp    801f66 <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  801f65:	90                   	nop
	}
	return tot;
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f71:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	89 04 24             	mov    %eax,(%esp)
  801f7e:	e8 d2 fb ff ff       	call   801b55 <fd_lookup>
  801f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8a:	78 1d                	js     801fa9 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8f:	8b 00                	mov    (%eax),%eax
  801f91:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801f94:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f98:	89 04 24             	mov    %eax,(%esp)
  801f9b:	e8 60 fc ff ff       	call   801c00 <dev_lookup>
  801fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa7:	79 05                	jns    801fae <write+0x43>
		return r;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	eb 74                	jmp    802022 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb1:	8b 40 08             	mov    0x8(%eax),%eax
  801fb4:	83 e0 03             	and    $0x3,%eax
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	75 26                	jne    801fe1 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801fbb:	a1 40 60 80 00       	mov    0x806040,%eax
  801fc0:	8b 40 4c             	mov    0x4c(%eax),%eax
  801fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fca:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fce:	c7 04 24 63 34 80 00 	movl   $0x803463,(%esp)
  801fd5:	e8 42 e2 ff ff       	call   80021c <cprintf>
		return -E_INVAL;
  801fda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fdf:	eb 41                	jmp    802022 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe4:	8b 48 0c             	mov    0xc(%eax),%ecx
  801fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fea:	8b 50 04             	mov    0x4(%eax),%edx
  801fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ff4:	8b 55 10             	mov    0x10(%ebp),%edx
  801ff7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffe:	89 54 24 04          	mov    %edx,0x4(%esp)
  802002:	89 04 24             	mov    %eax,(%esp)
  802005:	ff d1                	call   *%ecx
  802007:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  80200a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200e:	7e 0f                	jle    80201f <write+0xb4>
		fd->fd_offset += r;
  802010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802013:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802016:	8b 52 04             	mov    0x4(%edx),%edx
  802019:	03 55 f4             	add    -0xc(%ebp),%edx
  80201c:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <seek>:

int
seek(int fdnum, off_t offset)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80202a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80202d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	89 04 24             	mov    %eax,(%esp)
  802037:	e8 19 fb ff ff       	call   801b55 <fd_lookup>
  80203c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802043:	79 05                	jns    80204a <seek+0x26>
		return r;
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	eb 0e                	jmp    802058 <seek+0x34>
	fd->fd_offset = offset;
  80204a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802060:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802063:	89 44 24 04          	mov    %eax,0x4(%esp)
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	89 04 24             	mov    %eax,(%esp)
  80206d:	e8 e3 fa ff ff       	call   801b55 <fd_lookup>
  802072:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802079:	78 1d                	js     802098 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80207b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207e:	8b 00                	mov    (%eax),%eax
  802080:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802083:	89 54 24 04          	mov    %edx,0x4(%esp)
  802087:	89 04 24             	mov    %eax,(%esp)
  80208a:	e8 71 fb ff ff       	call   801c00 <dev_lookup>
  80208f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802092:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802096:	79 05                	jns    80209d <ftruncate+0x43>
		return r;
  802098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209b:	eb 48                	jmp    8020e5 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80209d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a0:	8b 40 08             	mov    0x8(%eax),%eax
  8020a3:	83 e0 03             	and    $0x3,%eax
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	75 26                	jne    8020d0 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8020aa:	a1 40 60 80 00       	mov    0x806040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8020af:	8b 40 4c             	mov    0x4c(%eax),%eax
  8020b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bd:	c7 04 24 80 34 80 00 	movl   $0x803480,(%esp)
  8020c4:	e8 53 e1 ff ff       	call   80021c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8020c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020ce:	eb 15                	jmp    8020e5 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	8b 48 1c             	mov    0x1c(%eax),%ecx
  8020d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e0:	89 04 24             	mov    %eax,(%esp)
  8020e3:	ff d1                	call   *%ecx
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	89 04 24             	mov    %eax,(%esp)
  8020fa:	e8 56 fa ff ff       	call   801b55 <fd_lookup>
  8020ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802106:	78 1d                	js     802125 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210b:	8b 00                	mov    (%eax),%eax
  80210d:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802110:	89 54 24 04          	mov    %edx,0x4(%esp)
  802114:	89 04 24             	mov    %eax,(%esp)
  802117:	e8 e4 fa ff ff       	call   801c00 <dev_lookup>
  80211c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802123:	79 05                	jns    80212a <fstat+0x43>
		return r;
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	eb 41                	jmp    80216b <fstat+0x84>
	stat->st_name[0] = 0;
  80212a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212d:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  802130:	8b 45 0c             	mov    0xc(%ebp),%eax
  802133:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  80213a:	00 00 00 
	stat->st_isdir = 0;
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  802147:	00 00 00 
	stat->st_dev = dev;
  80214a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80214d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802150:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  802156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802159:	8b 48 14             	mov    0x14(%eax),%ecx
  80215c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802162:	89 54 24 04          	mov    %edx,0x4(%esp)
  802166:	89 04 24             	mov    %eax,(%esp)
  802169:	ff d1                	call   *%ecx
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802173:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80217a:	00 
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	89 04 24             	mov    %eax,(%esp)
  802181:	e8 36 00 00 00       	call   8021bc <open>
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218d:	79 05                	jns    802194 <stat+0x27>
		return fd;
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	eb 23                	jmp    8021b7 <stat+0x4a>
	r = fstat(fd, stat);
  802194:	8b 45 0c             	mov    0xc(%ebp),%eax
  802197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	89 04 24             	mov    %eax,(%esp)
  8021a1:	e8 41 ff ff ff       	call   8020e7 <fstat>
  8021a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	89 04 24             	mov    %eax,(%esp)
  8021af:	e8 c3 fa ff ff       	call   801c77 <close>
	return r;
  8021b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    
  8021b9:	00 00                	add    %al,(%eax)
	...

008021bc <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  8021c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021c5:	89 04 24             	mov    %eax,(%esp)
  8021c8:	e8 1a f9 ff ff       	call   801ae7 <fd_alloc>
  8021cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d4:	79 05                	jns    8021db <open+0x1f>
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	eb 73                	jmp    80224e <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  8021db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	89 04 24             	mov    %eax,(%esp)
  8021ef:	e8 54 05 00 00       	call   802748 <fsipc_open>
  8021f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fb:	79 05                	jns    802202 <open+0x46>
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	eb 4c                	jmp    80224e <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  802202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802205:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80220b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802212:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802219:	00 
  80221a:	89 04 24             	mov    %eax,(%esp)
  80221d:	e8 25 03 00 00       	call   802547 <fmap>
  802222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802229:	79 18                	jns    802243 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802235:	00 
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 39 f9 ff ff       	call   801b77 <fd_close>
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	eb 0b                	jmp    80224e <open+0x92>
	return fd2num(fd);
  802243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802246:	89 04 24             	mov    %eax,(%esp)
  802249:	e8 89 f8 ff ff       	call   801ad7 <fd2num>
	//panic("open() unimplemented!");
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80225f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  802266:	00 
  802267:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80226e:	00 
  80226f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	89 04 24             	mov    %eax,(%esp)
  802279:	e8 72 03 00 00       	call   8025f0 <funmap>
  80227e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	79 05                	jns    80228c <file_close+0x3c>
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	eb 21                	jmp    8022ad <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	8b 40 0c             	mov    0xc(%eax),%eax
  802292:	89 04 24             	mov    %eax,(%esp)
  802295:	e8 e3 05 00 00       	call   80287d <fsipc_close>
  80229a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a1:	79 05                	jns    8022a8 <file_close+0x58>
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	eb 05                	jmp    8022ad <file_close+0x5d>
	return 0;
  8022a8:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8022be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  8022c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022c7:	76 07                	jbe    8022d0 <file_read+0x21>
		return 0;
  8022c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ce:	eb 43                	jmp    802313 <file_read+0x64>
	if (offset + n > size)
  8022d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d3:	03 45 10             	add    0x10(%ebp),%eax
  8022d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022d9:	76 0f                	jbe    8022ea <file_read+0x3b>
		n = size - offset;
  8022db:	8b 45 14             	mov    0x14(%ebp),%eax
  8022de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e1:	89 d1                	mov    %edx,%ecx
  8022e3:	29 c1                	sub    %eax,%ecx
  8022e5:	89 c8                	mov    %ecx,%eax
  8022e7:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	89 04 24             	mov    %eax,(%esp)
  8022f0:	e8 c7 f7 ff ff       	call   801abc <fd2data>
  8022f5:	8b 55 14             	mov    0x14(%ebp),%edx
  8022f8:	01 c2                	add    %eax,%edx
  8022fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802301:	89 54 24 04          	mov    %edx,0x4(%esp)
  802305:	8b 45 0c             	mov    0xc(%ebp),%eax
  802308:	89 04 24             	mov    %eax,(%esp)
  80230b:	e8 10 ea ff ff       	call   800d20 <memmove>
	return n;
  802310:	8b 45 10             	mov    0x10(%ebp),%eax
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80231b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80231e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	89 04 24             	mov    %eax,(%esp)
  802328:	e8 28 f8 ff ff       	call   801b55 <fd_lookup>
  80232d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802334:	79 05                	jns    80233b <read_map+0x26>
		return r;
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	eb 74                	jmp    8023af <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  80233b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233e:	8b 10                	mov    (%eax),%edx
  802340:	a1 20 60 80 00       	mov    0x806020,%eax
  802345:	39 c2                	cmp    %eax,%edx
  802347:	74 07                	je     802350 <read_map+0x3b>
		return -E_INVAL;
  802349:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80234e:	eb 5f                	jmp    8023af <read_map+0x9a>
	va = fd2data(fd) + offset;
  802350:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802353:	89 04 24             	mov    %eax,(%esp)
  802356:	e8 61 f7 ff ff       	call   801abc <fd2data>
  80235b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235e:	01 d0                	add    %edx,%eax
  802360:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  802363:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  80236a:	7e 07                	jle    802373 <read_map+0x5e>
		return -E_NO_DISK;
  80236c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802371:	eb 3c                	jmp    8023af <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	c1 e8 16             	shr    $0x16,%eax
  802379:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802380:	83 e0 01             	and    $0x1,%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	74 14                	je     80239b <read_map+0x86>
  802387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238a:	c1 e8 0c             	shr    $0xc,%eax
  80238d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802394:	83 e0 01             	and    $0x1,%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	75 07                	jne    8023a2 <read_map+0x8d>
		return -E_NO_DISK;
  80239b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8023a0:	eb 0d                	jmp    8023af <read_map+0x9a>
	*blk = (void*) va;
  8023a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a8:	89 10                	mov    %edx,(%eax)
	return 0;
  8023aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  8023b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ba:	03 45 10             	add    0x10(%ebp),%eax
  8023bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  8023c0:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  8023c7:	76 07                	jbe    8023d0 <file_write+0x1f>
		return -E_NO_DISK;
  8023c9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8023ce:	eb 57                	jmp    802427 <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8023d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023dc:	73 20                	jae    8023fe <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	89 04 24             	mov    %eax,(%esp)
  8023eb:	e8 88 00 00 00       	call   802478 <file_trunc>
  8023f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f7:	79 05                	jns    8023fe <file_write+0x4d>
			return r;
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	eb 29                	jmp    802427 <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	89 04 24             	mov    %eax,(%esp)
  802404:	e8 b3 f6 ff ff       	call   801abc <fd2data>
  802409:	8b 55 14             	mov    0x14(%ebp),%edx
  80240c:	01 c2                	add    %eax,%edx
  80240e:	8b 45 10             	mov    0x10(%ebp),%eax
  802411:	89 44 24 08          	mov    %eax,0x8(%esp)
  802415:	8b 45 0c             	mov    0xc(%ebp),%eax
  802418:	89 44 24 04          	mov    %eax,0x4(%esp)
  80241c:	89 14 24             	mov    %edx,(%esp)
  80241f:	e8 fc e8 ff ff       	call   800d20 <memmove>
	return n;
  802424:	8b 45 10             	mov    0x10(%ebp),%eax
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	8d 50 10             	lea    0x10(%eax),%edx
  802435:	8b 45 0c             	mov    0xc(%ebp),%eax
  802438:	89 54 24 04          	mov    %edx,0x4(%esp)
  80243c:	89 04 24             	mov    %eax,(%esp)
  80243f:	e8 ea e6 ff ff       	call   800b2e <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80244d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802450:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  80245f:	83 f8 01             	cmp    $0x1,%eax
  802462:	0f 94 c0             	sete   %al
  802465:	0f b6 d0             	movzbl %al,%edx
  802468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246b:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  80247e:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  802485:	7e 0a                	jle    802491 <file_trunc+0x19>
		return -E_NO_DISK;
  802487:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80248c:	e9 b4 00 00 00       	jmp    802545 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	8b 40 0c             	mov    0xc(%eax),%eax
  802497:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8024a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b0:	89 04 24             	mov    %eax,(%esp)
  8024b3:	e8 82 03 00 00       	call   80283a <fsipc_set_size>
  8024b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8024bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024bf:	79 05                	jns    8024c6 <file_trunc+0x4e>
		return r;
  8024c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c4:	eb 7f                	jmp    802545 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8024cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024d2:	74 24                	je     8024f8 <file_trunc+0x80>
  8024d4:	c7 44 24 0c ac 34 80 	movl   $0x8034ac,0xc(%esp)
  8024db:	00 
  8024dc:	c7 44 24 08 cf 34 80 	movl   $0x8034cf,0x8(%esp)
  8024e3:	00 
  8024e4:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8024eb:	00 
  8024ec:	c7 04 24 e4 34 80 00 	movl   $0x8034e4,(%esp)
  8024f3:	e8 8c 04 00 00       	call   802984 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  8024f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	89 44 24 04          	mov    %eax,0x4(%esp)
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	89 04 24             	mov    %eax,(%esp)
  80250c:	e8 36 00 00 00       	call   802547 <fmap>
  802511:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802518:	79 05                	jns    80251f <file_trunc+0xa7>
		return r;
  80251a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251d:	eb 26                	jmp    802545 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  80251f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802526:	00 
  802527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80252e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802531:	89 44 24 04          	mov    %eax,0x4(%esp)
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	89 04 24             	mov    %eax,(%esp)
  80253b:	e8 b0 00 00 00       	call   8025f0 <funmap>

	return 0;
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	89 04 24             	mov    %eax,(%esp)
  802553:	e8 64 f5 ff ff       	call   801abc <fd2data>
  802558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80255b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802562:	8b 45 0c             	mov    0xc(%ebp),%eax
  802565:	03 45 ec             	add    -0x14(%ebp),%eax
  802568:	83 e8 01             	sub    $0x1,%eax
  80256b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80256e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802571:	ba 00 00 00 00       	mov    $0x0,%edx
  802576:	f7 75 ec             	divl   -0x14(%ebp)
  802579:	89 d0                	mov    %edx,%eax
  80257b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80257e:	89 d1                	mov    %edx,%ecx
  802580:	29 c1                	sub    %eax,%ecx
  802582:	89 c8                	mov    %ecx,%eax
  802584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802587:	eb 58                	jmp    8025e1 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8b 40 0c             	mov    0xc(%eax),%eax
  80259b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80259f:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025a3:	89 04 24             	mov    %eax,(%esp)
  8025a6:	e8 04 02 00 00       	call   8027af <fsipc_map>
  8025ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8025ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025b2:	79 26                	jns    8025da <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8025be:	00 
  8025bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	89 04 24             	mov    %eax,(%esp)
  8025d0:	e8 1b 00 00 00       	call   8025f0 <funmap>
			return r;
  8025d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d8:	eb 14                	jmp    8025ee <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  8025da:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8025e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025e7:	77 a0                	ja     802589 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  8025e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  8025f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f9:	89 04 24             	mov    %eax,(%esp)
  8025fc:	e8 bb f4 ff ff       	call   801abc <fd2data>
  802601:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  802604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802607:	c1 e8 16             	shr    $0x16,%eax
  80260a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802611:	83 e0 01             	and    $0x1,%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	75 0a                	jne    802622 <funmap+0x32>
		return 0;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	e9 bf 00 00 00       	jmp    8026e1 <funmap+0xf1>

	ret = 0;
  802622:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  802629:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802630:	8b 45 10             	mov    0x10(%ebp),%eax
  802633:	03 45 e8             	add    -0x18(%ebp),%eax
  802636:	83 e8 01             	sub    $0x1,%eax
  802639:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80263c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263f:	ba 00 00 00 00       	mov    $0x0,%edx
  802644:	f7 75 e8             	divl   -0x18(%ebp)
  802647:	89 d0                	mov    %edx,%eax
  802649:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80264c:	89 d1                	mov    %edx,%ecx
  80264e:	29 c1                	sub    %eax,%ecx
  802650:	89 c8                	mov    %ecx,%eax
  802652:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802655:	eb 7b                	jmp    8026d2 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80265d:	01 d0                	add    %edx,%eax
  80265f:	c1 e8 0c             	shr    $0xc,%eax
  802662:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802669:	83 e0 01             	and    $0x1,%eax
  80266c:	84 c0                	test   %al,%al
  80266e:	74 5b                	je     8026cb <funmap+0xdb>
			if (dirty
  802670:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  802674:	74 3d                	je     8026b3 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80267c:	01 d0                	add    %edx,%eax
  80267e:	c1 e8 0c             	shr    $0xc,%eax
  802681:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802688:	83 e0 40             	and    $0x40,%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 24                	je     8026b3 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  80268f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	8b 40 0c             	mov    0xc(%eax),%eax
  802698:	89 54 24 04          	mov    %edx,0x4(%esp)
  80269c:	89 04 24             	mov    %eax,(%esp)
  80269f:	e8 13 02 00 00       	call   8028b7 <fsipc_dirty>
  8026a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8026a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026ab:	79 06                	jns    8026b3 <funmap+0xc3>
				ret = r;
  8026ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b9:	01 d0                	add    %edx,%eax
  8026bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c6:	e8 26 eb ff ff       	call   8011f1 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8026cb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8026d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026d8:	0f 87 79 ff ff ff    	ja     802657 <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  8026de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <remove>:

// Delete a file
int
remove(const char *path)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	89 04 24             	mov    %eax,(%esp)
  8026ef:	e8 06 02 00 00       	call   8028fa <fsipc_remove>
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  8026fc:	e8 56 02 00 00       	call   802957 <fsipc_sync>
}
  802701:	c9                   	leave  
  802702:	c3                   	ret    
	...

00802704 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  802704:	55                   	push   %ebp
  802705:	89 e5                	mov    %esp,%ebp
  802707:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80270a:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80270f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802716:	00 
  802717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80271e:	8b 55 08             	mov    0x8(%ebp),%edx
  802721:	89 54 24 04          	mov    %edx,0x4(%esp)
  802725:	89 04 24             	mov    %eax,(%esp)
  802728:	e8 13 04 00 00       	call   802b40 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  80272d:	8b 45 14             	mov    0x14(%ebp),%eax
  802730:	89 44 24 08          	mov    %eax,0x8(%esp)
  802734:	8b 45 10             	mov    0x10(%ebp),%eax
  802737:	89 44 24 04          	mov    %eax,0x4(%esp)
  80273b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273e:	89 04 24             	mov    %eax,(%esp)
  802741:	e8 6e 03 00 00       	call   802ab4 <ipc_recv>
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    

00802748 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  80274e:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	89 04 24             	mov    %eax,(%esp)
  80275b:	e8 78 e3 ff ff       	call   800ad8 <strlen>
  802760:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802765:	7e 07                	jle    80276e <fsipc_open+0x26>
		return -E_BAD_PATH;
  802767:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80276c:	eb 3f                	jmp    8027ad <fsipc_open+0x65>
	strcpy(req->req_path, path);
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 55 08             	mov    0x8(%ebp),%edx
  802774:	89 54 24 04          	mov    %edx,0x4(%esp)
  802778:	89 04 24             	mov    %eax,(%esp)
  80277b:	e8 ae e3 ff ff       	call   800b2e <strcpy>
	req->req_omode = omode;
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 55 0c             	mov    0xc(%ebp),%edx
  802786:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  80278c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80278f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802793:	8b 45 10             	mov    0x10(%ebp),%eax
  802796:	89 44 24 08          	mov    %eax,0x8(%esp)
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8027a8:	e8 57 ff ff ff       	call   802704 <fsipc>
}
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    

008027af <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  8027b5:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c2:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ca:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  8027cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8027d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8027d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8027e9:	e8 16 ff ff ff       	call   802704 <fsipc>
  8027ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027f5:	79 05                	jns    8027fc <fsipc_map+0x4d>
		return r;
  8027f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fa:	eb 3c                	jmp    802838 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  802804:	83 f8 05             	cmp    $0x5,%eax
  802807:	74 2a                	je     802833 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  802809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280c:	8b 55 10             	mov    0x10(%ebp),%edx
  80280f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802813:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802817:	c7 44 24 08 f0 34 80 	movl   $0x8034f0,0x8(%esp)
  80281e:	00 
  80281f:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  802826:	00 
  802827:	c7 04 24 26 35 80 00 	movl   $0x803526,(%esp)
  80282e:	e8 51 01 00 00       	call   802984 <_panic>
	return 0;
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802838:	c9                   	leave  
  802839:	c3                   	ret    

0080283a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
  80283d:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802840:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 55 08             	mov    0x8(%ebp),%edx
  80284d:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 55 0c             	mov    0xc(%ebp),%edx
  802855:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802858:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80285f:	00 
  802860:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802867:	00 
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80286f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  802876:	e8 89 fe ff ff       	call   802704 <fsipc>
}
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
  802880:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  802883:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 55 08             	mov    0x8(%ebp),%edx
  802890:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  802892:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802899:	00 
  80289a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8028a1:	00 
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8028b0:	e8 4f fe ff ff       	call   802704 <fsipc>
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  8028bd:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ca:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d2:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8028d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8028dc:	00 
  8028dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8028e4:	00 
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ec:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8028f3:	e8 0c fe ff ff       	call   802704 <fsipc>
}
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    

008028fa <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802900:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	89 04 24             	mov    %eax,(%esp)
  80290d:	e8 c6 e1 ff ff       	call   800ad8 <strlen>
  802912:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802917:	7e 07                	jle    802920 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802919:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80291e:	eb 35                	jmp    802955 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 55 08             	mov    0x8(%ebp),%edx
  802926:	89 54 24 04          	mov    %edx,0x4(%esp)
  80292a:	89 04 24             	mov    %eax,(%esp)
  80292d:	e8 fc e1 ff ff       	call   800b2e <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  802932:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802939:	00 
  80293a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802941:	00 
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	89 44 24 04          	mov    %eax,0x4(%esp)
  802949:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  802950:	e8 af fd ff ff       	call   802704 <fsipc>
}
  802955:	c9                   	leave  
  802956:	c3                   	ret    

00802957 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802957:	55                   	push   %ebp
  802958:	89 e5                	mov    %esp,%ebp
  80295a:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  80295d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802964:	00 
  802965:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80296c:	00 
  80296d:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802974:	00 
  802975:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80297c:	e8 83 fd ff ff       	call   802704 <fsipc>
}
  802981:	c9                   	leave  
  802982:	c3                   	ret    
	...

00802984 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  80298a:	8d 45 10             	lea    0x10(%ebp),%eax
  80298d:	83 c0 04             	add    $0x4,%eax
  802990:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  802993:	a1 44 60 80 00       	mov    0x806044,%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	74 15                	je     8029b1 <_panic+0x2d>
		cprintf("%s: ", argv0);
  80299c:	a1 44 60 80 00       	mov    0x806044,%eax
  8029a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a5:	c7 04 24 32 35 80 00 	movl   $0x803532,(%esp)
  8029ac:	e8 6b d8 ff ff       	call   80021c <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8029b1:	a1 00 60 80 00       	mov    0x806000,%eax
  8029b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8029bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c8:	c7 04 24 37 35 80 00 	movl   $0x803537,(%esp)
  8029cf:	e8 48 d8 ff ff       	call   80021c <cprintf>
	vcprintf(fmt, ap);
  8029d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8029d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029da:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029de:	89 04 24             	mov    %eax,(%esp)
  8029e1:	e8 d2 d7 ff ff       	call   8001b8 <vcprintf>
	cprintf("\n");
  8029e6:	c7 04 24 53 35 80 00 	movl   $0x803553,(%esp)
  8029ed:	e8 2a d8 ff ff       	call   80021c <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8029f2:	cc                   	int3   
  8029f3:	eb fd                	jmp    8029f2 <_panic+0x6e>
  8029f5:	00 00                	add    %al,(%eax)
	...

008029f8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029f8:	55                   	push   %ebp
  8029f9:	89 e5                	mov    %esp,%ebp
  8029fb:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029fe:	a1 48 60 80 00       	mov    0x806048,%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	75 7b                	jne    802a82 <set_pgfault_handler+0x8a>
		// First time through!
		// LAB 4: Your code here.
		envid_t env_id = sys_getenvid();//0env_id
  802a07:	e8 d6 e6 ff ff       	call   8010e2 <sys_getenvid>
  802a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if((r = sys_page_alloc(env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_U|PTE_P|PTE_W)) < 0){
  802a0f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a16:	00 
  802a17:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802a1e:	ee 
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	89 04 24             	mov    %eax,(%esp)
  802a25:	e8 40 e7 ff ff       	call   80116a <sys_page_alloc>
  802a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a31:	79 1c                	jns    802a4f <set_pgfault_handler+0x57>
			panic("set_pgfault_handler not implemented\n");
  802a33:	c7 44 24 08 58 35 80 	movl   $0x803558,0x8(%esp)
  802a3a:	00 
  802a3b:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  802a42:	00 
  802a43:	c7 04 24 7d 35 80 00 	movl   $0x80357d,(%esp)
  802a4a:	e8 35 ff ff ff       	call   802984 <_panic>
			return;
		}//env_id
		
		if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0){
  802a4f:	c7 44 24 04 8c 2a 80 	movl   $0x802a8c,0x4(%esp)
  802a56:	00 
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	89 04 24             	mov    %eax,(%esp)
  802a5d:	e8 97 e8 ff ff       	call   8012f9 <sys_env_set_pgfault_upcall>
  802a62:	85 c0                	test   %eax,%eax
  802a64:	79 1c                	jns    802a82 <set_pgfault_handler+0x8a>
			panic("sys_env_set_pgfault_upcall not implemented\n");
  802a66:	c7 44 24 08 8c 35 80 	movl   $0x80358c,0x8(%esp)
  802a6d:	00 
  802a6e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802a75:	00 
  802a76:	c7 04 24 7d 35 80 00 	movl   $0x80357d,(%esp)
  802a7d:	e8 02 ff ff ff       	call   802984 <_panic>
			return;
		}
		//sys_env_set_pgfault_upcall(0, _pgfault_upcall);
	}
	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	a3 48 60 80 00       	mov    %eax,0x806048
}
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a8c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a8d:	a1 48 60 80 00       	mov    0x806048,%eax
	call *%eax
  802a92:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a94:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// subtract 4 from old esp for the storage of old eip
	
	movl 0x30(%esp), %eax
  802a97:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax
  802a9b:	83 e8 04             	sub    $0x4,%eax
	movl %eax, 0x30(%esp)
  802a9e:	89 44 24 30          	mov    %eax,0x30(%esp)
	
	// put old eip in the pre-reserved 4 bytes space
	
	movl 0x28(%esp), %ebx
  802aa2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  802aa6:	89 18                	mov    %ebx,(%eax)
	
	// Restore the trap-time registers.
	// LAB 4: Your code here.
	
    addl $0x8, %esp
  802aa8:	83 c4 08             	add    $0x8,%esp
    popal
  802aab:	61                   	popa   
    
	// Restore eflags from the stack.
	// LAB 4: Your code here.
	
    addl $0x4, %esp
  802aac:	83 c4 04             	add    $0x4,%esp
    popfl
  802aaf:	9d                   	popf   
    
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	
	pop %esp
  802ab0:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
    ret
  802ab1:	c3                   	ret    
	...

00802ab4 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  802aba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802abe:	75 11                	jne    802ad1 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  802ac0:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  802ac7:	e8 af e8 ff ff       	call   80137b <sys_ipc_recv>
  802acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acf:	eb 0e                	jmp    802adf <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  802ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad4:	89 04 24             	mov    %eax,(%esp)
  802ad7:	e8 9f e8 ff ff       	call   80137b <sys_ipc_recv>
  802adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  802adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae3:	79 1c                	jns    802b01 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  802ae5:	c7 44 24 08 b8 35 80 	movl   $0x8035b8,0x8(%esp)
  802aec:	00 
  802aed:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  802af4:	00 
  802af5:	c7 04 24 ce 35 80 00 	movl   $0x8035ce,(%esp)
  802afc:	e8 83 fe ff ff       	call   802984 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  802b01:	e8 dc e5 ff ff       	call   8010e2 <sys_getenvid>
  802b06:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b0b:	c1 e0 07             	shl    $0x7,%eax
  802b0e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  802b16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1a:	74 0b                	je     802b27 <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 50 74             	mov    0x74(%eax),%edx
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  802b27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b2b:	74 0b                	je     802b38 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 50 78             	mov    0x78(%eax),%edx
  802b33:	8b 45 10             	mov    0x10(%ebp),%eax
  802b36:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  802b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3b:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  802b3e:	c9                   	leave  
  802b3f:	c3                   	ret    

00802b40 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
  802b43:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  802b46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b4a:	75 26                	jne    802b72 <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  802b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  802b4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b53:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  802b5a:	ee 
  802b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	89 04 24             	mov    %eax,(%esp)
  802b68:	e8 ce e7 ff ff       	call   80133b <sys_ipc_try_send>
  802b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b70:	eb 23                	jmp    802b95 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  802b72:	8b 45 14             	mov    0x14(%ebp),%eax
  802b75:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b79:	8b 45 10             	mov    0x10(%ebp),%eax
  802b7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	89 04 24             	mov    %eax,(%esp)
  802b8d:	e8 a9 e7 ff ff       	call   80133b <sys_ipc_try_send>
  802b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  802b95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b99:	79 29                	jns    802bc4 <ipc_send+0x84>
  802b9b:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  802b9f:	74 23                	je     802bc4 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ba8:	c7 44 24 08 d8 35 80 	movl   $0x8035d8,0x8(%esp)
  802baf:	00 
  802bb0:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  802bb7:	00 
  802bb8:	c7 04 24 ce 35 80 00 	movl   $0x8035ce,(%esp)
  802bbf:	e8 c0 fd ff ff       	call   802984 <_panic>
	    sys_yield();
  802bc4:	e8 5d e5 ff ff       	call   801126 <sys_yield>
	}while(r < 0);
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcd:	0f 88 73 ff ff ff    	js     802b46 <ipc_send+0x6>
}
  802bd3:	c9                   	leave  
  802bd4:	c3                   	ret    
	...

00802be0 <__udivdi3>:
  802be0:	83 ec 1c             	sub    $0x1c,%esp
  802be3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802be7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  802beb:	8b 44 24 20          	mov    0x20(%esp),%eax
  802bef:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802bf3:	89 74 24 10          	mov    %esi,0x10(%esp)
  802bf7:	8b 74 24 24          	mov    0x24(%esp),%esi
  802bfb:	85 ff                	test   %edi,%edi
  802bfd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802c01:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c05:	89 cd                	mov    %ecx,%ebp
  802c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c0b:	75 33                	jne    802c40 <__udivdi3+0x60>
  802c0d:	39 f1                	cmp    %esi,%ecx
  802c0f:	77 57                	ja     802c68 <__udivdi3+0x88>
  802c11:	85 c9                	test   %ecx,%ecx
  802c13:	75 0b                	jne    802c20 <__udivdi3+0x40>
  802c15:	b8 01 00 00 00       	mov    $0x1,%eax
  802c1a:	31 d2                	xor    %edx,%edx
  802c1c:	f7 f1                	div    %ecx
  802c1e:	89 c1                	mov    %eax,%ecx
  802c20:	89 f0                	mov    %esi,%eax
  802c22:	31 d2                	xor    %edx,%edx
  802c24:	f7 f1                	div    %ecx
  802c26:	89 c6                	mov    %eax,%esi
  802c28:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c2c:	f7 f1                	div    %ecx
  802c2e:	89 f2                	mov    %esi,%edx
  802c30:	8b 74 24 10          	mov    0x10(%esp),%esi
  802c34:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802c38:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802c3c:	83 c4 1c             	add    $0x1c,%esp
  802c3f:	c3                   	ret    
  802c40:	31 d2                	xor    %edx,%edx
  802c42:	31 c0                	xor    %eax,%eax
  802c44:	39 f7                	cmp    %esi,%edi
  802c46:	77 e8                	ja     802c30 <__udivdi3+0x50>
  802c48:	0f bd cf             	bsr    %edi,%ecx
  802c4b:	83 f1 1f             	xor    $0x1f,%ecx
  802c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c52:	75 2c                	jne    802c80 <__udivdi3+0xa0>
  802c54:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802c58:	76 04                	jbe    802c5e <__udivdi3+0x7e>
  802c5a:	39 f7                	cmp    %esi,%edi
  802c5c:	73 d2                	jae    802c30 <__udivdi3+0x50>
  802c5e:	31 d2                	xor    %edx,%edx
  802c60:	b8 01 00 00 00       	mov    $0x1,%eax
  802c65:	eb c9                	jmp    802c30 <__udivdi3+0x50>
  802c67:	90                   	nop
  802c68:	89 f2                	mov    %esi,%edx
  802c6a:	f7 f1                	div    %ecx
  802c6c:	31 d2                	xor    %edx,%edx
  802c6e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802c72:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802c76:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802c7a:	83 c4 1c             	add    $0x1c,%esp
  802c7d:	c3                   	ret    
  802c7e:	66 90                	xchg   %ax,%ax
  802c80:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c85:	b8 20 00 00 00       	mov    $0x20,%eax
  802c8a:	89 ea                	mov    %ebp,%edx
  802c8c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802c90:	d3 e7                	shl    %cl,%edi
  802c92:	89 c1                	mov    %eax,%ecx
  802c94:	d3 ea                	shr    %cl,%edx
  802c96:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c9b:	09 fa                	or     %edi,%edx
  802c9d:	89 f7                	mov    %esi,%edi
  802c9f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802ca3:	89 f2                	mov    %esi,%edx
  802ca5:	8b 74 24 08          	mov    0x8(%esp),%esi
  802ca9:	d3 e5                	shl    %cl,%ebp
  802cab:	89 c1                	mov    %eax,%ecx
  802cad:	d3 ef                	shr    %cl,%edi
  802caf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cb4:	d3 e2                	shl    %cl,%edx
  802cb6:	89 c1                	mov    %eax,%ecx
  802cb8:	d3 ee                	shr    %cl,%esi
  802cba:	09 d6                	or     %edx,%esi
  802cbc:	89 fa                	mov    %edi,%edx
  802cbe:	89 f0                	mov    %esi,%eax
  802cc0:	f7 74 24 0c          	divl   0xc(%esp)
  802cc4:	89 d7                	mov    %edx,%edi
  802cc6:	89 c6                	mov    %eax,%esi
  802cc8:	f7 e5                	mul    %ebp
  802cca:	39 d7                	cmp    %edx,%edi
  802ccc:	72 22                	jb     802cf0 <__udivdi3+0x110>
  802cce:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802cd2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cd7:	d3 e5                	shl    %cl,%ebp
  802cd9:	39 c5                	cmp    %eax,%ebp
  802cdb:	73 04                	jae    802ce1 <__udivdi3+0x101>
  802cdd:	39 d7                	cmp    %edx,%edi
  802cdf:	74 0f                	je     802cf0 <__udivdi3+0x110>
  802ce1:	89 f0                	mov    %esi,%eax
  802ce3:	31 d2                	xor    %edx,%edx
  802ce5:	e9 46 ff ff ff       	jmp    802c30 <__udivdi3+0x50>
  802cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cf0:	8d 46 ff             	lea    -0x1(%esi),%eax
  802cf3:	31 d2                	xor    %edx,%edx
  802cf5:	8b 74 24 10          	mov    0x10(%esp),%esi
  802cf9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802cfd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d01:	83 c4 1c             	add    $0x1c,%esp
  802d04:	c3                   	ret    
	...

00802d10 <__umoddi3>:
  802d10:	83 ec 1c             	sub    $0x1c,%esp
  802d13:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802d17:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  802d1b:	8b 44 24 20          	mov    0x20(%esp),%eax
  802d1f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802d23:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802d27:	8b 74 24 24          	mov    0x24(%esp),%esi
  802d2b:	85 ed                	test   %ebp,%ebp
  802d2d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802d31:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d35:	89 cf                	mov    %ecx,%edi
  802d37:	89 04 24             	mov    %eax,(%esp)
  802d3a:	89 f2                	mov    %esi,%edx
  802d3c:	75 1a                	jne    802d58 <__umoddi3+0x48>
  802d3e:	39 f1                	cmp    %esi,%ecx
  802d40:	76 4e                	jbe    802d90 <__umoddi3+0x80>
  802d42:	f7 f1                	div    %ecx
  802d44:	89 d0                	mov    %edx,%eax
  802d46:	31 d2                	xor    %edx,%edx
  802d48:	8b 74 24 10          	mov    0x10(%esp),%esi
  802d4c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d50:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d54:	83 c4 1c             	add    $0x1c,%esp
  802d57:	c3                   	ret    
  802d58:	39 f5                	cmp    %esi,%ebp
  802d5a:	77 54                	ja     802db0 <__umoddi3+0xa0>
  802d5c:	0f bd c5             	bsr    %ebp,%eax
  802d5f:	83 f0 1f             	xor    $0x1f,%eax
  802d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d66:	75 60                	jne    802dc8 <__umoddi3+0xb8>
  802d68:	3b 0c 24             	cmp    (%esp),%ecx
  802d6b:	0f 87 07 01 00 00    	ja     802e78 <__umoddi3+0x168>
  802d71:	89 f2                	mov    %esi,%edx
  802d73:	8b 34 24             	mov    (%esp),%esi
  802d76:	29 ce                	sub    %ecx,%esi
  802d78:	19 ea                	sbb    %ebp,%edx
  802d7a:	89 34 24             	mov    %esi,(%esp)
  802d7d:	8b 04 24             	mov    (%esp),%eax
  802d80:	8b 74 24 10          	mov    0x10(%esp),%esi
  802d84:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802d88:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802d8c:	83 c4 1c             	add    $0x1c,%esp
  802d8f:	c3                   	ret    
  802d90:	85 c9                	test   %ecx,%ecx
  802d92:	75 0b                	jne    802d9f <__umoddi3+0x8f>
  802d94:	b8 01 00 00 00       	mov    $0x1,%eax
  802d99:	31 d2                	xor    %edx,%edx
  802d9b:	f7 f1                	div    %ecx
  802d9d:	89 c1                	mov    %eax,%ecx
  802d9f:	89 f0                	mov    %esi,%eax
  802da1:	31 d2                	xor    %edx,%edx
  802da3:	f7 f1                	div    %ecx
  802da5:	8b 04 24             	mov    (%esp),%eax
  802da8:	f7 f1                	div    %ecx
  802daa:	eb 98                	jmp    802d44 <__umoddi3+0x34>
  802dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802db0:	89 f2                	mov    %esi,%edx
  802db2:	8b 74 24 10          	mov    0x10(%esp),%esi
  802db6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802dba:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802dbe:	83 c4 1c             	add    $0x1c,%esp
  802dc1:	c3                   	ret    
  802dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802dc8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802dcd:	89 e8                	mov    %ebp,%eax
  802dcf:	bd 20 00 00 00       	mov    $0x20,%ebp
  802dd4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802dd8:	89 fa                	mov    %edi,%edx
  802dda:	d3 e0                	shl    %cl,%eax
  802ddc:	89 e9                	mov    %ebp,%ecx
  802dde:	d3 ea                	shr    %cl,%edx
  802de0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802de5:	09 c2                	or     %eax,%edx
  802de7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802deb:	89 14 24             	mov    %edx,(%esp)
  802dee:	89 f2                	mov    %esi,%edx
  802df0:	d3 e7                	shl    %cl,%edi
  802df2:	89 e9                	mov    %ebp,%ecx
  802df4:	d3 ea                	shr    %cl,%edx
  802df6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802dfb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dff:	d3 e6                	shl    %cl,%esi
  802e01:	89 e9                	mov    %ebp,%ecx
  802e03:	d3 e8                	shr    %cl,%eax
  802e05:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e0a:	09 f0                	or     %esi,%eax
  802e0c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802e10:	f7 34 24             	divl   (%esp)
  802e13:	d3 e6                	shl    %cl,%esi
  802e15:	89 74 24 08          	mov    %esi,0x8(%esp)
  802e19:	89 d6                	mov    %edx,%esi
  802e1b:	f7 e7                	mul    %edi
  802e1d:	39 d6                	cmp    %edx,%esi
  802e1f:	89 c1                	mov    %eax,%ecx
  802e21:	89 d7                	mov    %edx,%edi
  802e23:	72 3f                	jb     802e64 <__umoddi3+0x154>
  802e25:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802e29:	72 35                	jb     802e60 <__umoddi3+0x150>
  802e2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e2f:	29 c8                	sub    %ecx,%eax
  802e31:	19 fe                	sbb    %edi,%esi
  802e33:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e38:	89 f2                	mov    %esi,%edx
  802e3a:	d3 e8                	shr    %cl,%eax
  802e3c:	89 e9                	mov    %ebp,%ecx
  802e3e:	d3 e2                	shl    %cl,%edx
  802e40:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e45:	09 d0                	or     %edx,%eax
  802e47:	89 f2                	mov    %esi,%edx
  802e49:	d3 ea                	shr    %cl,%edx
  802e4b:	8b 74 24 10          	mov    0x10(%esp),%esi
  802e4f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802e53:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802e57:	83 c4 1c             	add    $0x1c,%esp
  802e5a:	c3                   	ret    
  802e5b:	90                   	nop
  802e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e60:	39 d6                	cmp    %edx,%esi
  802e62:	75 c7                	jne    802e2b <__umoddi3+0x11b>
  802e64:	89 d7                	mov    %edx,%edi
  802e66:	89 c1                	mov    %eax,%ecx
  802e68:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  802e6c:	1b 3c 24             	sbb    (%esp),%edi
  802e6f:	eb ba                	jmp    802e2b <__umoddi3+0x11b>
  802e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e78:	39 f5                	cmp    %esi,%ebp
  802e7a:	0f 82 f1 fe ff ff    	jb     802d71 <__umoddi3+0x61>
  802e80:	e9 f8 fe ff ff       	jmp    802d7d <__umoddi3+0x6d>
