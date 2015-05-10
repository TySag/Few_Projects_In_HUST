
obj/user/icode:     file format elf32-i386


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
  80002c:	e8 37 01 00 00       	call   800168 <libmain>
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
  800037:	81 ec 38 02 00 00    	sub    $0x238,%esp
	int fd, n, r;
	char buf[512+1];

	cprintf("icode startup\n");
  80003d:	c7 04 24 c0 28 80 00 	movl   $0x8028c0,(%esp)
  800044:	e8 b7 02 00 00       	call   800300 <cprintf>

	cprintf("icode: open /motd\n");
  800049:	c7 04 24 cf 28 80 00 	movl   $0x8028cf,(%esp)
  800050:	e8 ab 02 00 00       	call   800300 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800055:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80005c:	00 
  80005d:	c7 04 24 e2 28 80 00 	movl   $0x8028e2,(%esp)
  800064:	e8 3b 1b 00 00       	call   801ba4 <open>
  800069:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80006c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800070:	79 23                	jns    800095 <umain+0x61>
		panic("icode: open /motd: %e", fd);
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800079:	c7 44 24 08 e8 28 80 	movl   $0x8028e8,0x8(%esp)
  800080:	00 
  800081:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800088:	00 
  800089:	c7 04 24 fe 28 80 00 	movl   $0x8028fe,(%esp)
  800090:	e8 37 01 00 00       	call   8001cc <_panic>

	cprintf("icode: read /motd\n");
  800095:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  80009c:	e8 5f 02 00 00       	call   800300 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a1:	eb 15                	jmp    8000b8 <umain+0x84>
		sys_cputs(buf, n);
  8000a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000aa:	8d 85 eb fd ff ff    	lea    -0x215(%ebp),%eax
  8000b0:	89 04 24             	mov    %eax,(%esp)
  8000b3:	e8 45 10 00 00       	call   8010fd <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000b8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000bf:	00 
  8000c0:	8d 85 eb fd ff ff    	lea    -0x215(%ebp),%eax
  8000c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cd:	89 04 24             	mov    %eax,(%esp)
  8000d0:	e8 6a 17 00 00       	call   80183f <read>
  8000d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8000d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8000dc:	7f c5                	jg     8000a3 <umain+0x6f>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000de:	c7 04 24 1e 29 80 00 	movl   $0x80291e,(%esp)
  8000e5:	e8 16 02 00 00       	call   800300 <cprintf>
	close(fd);
  8000ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 6a 15 00 00       	call   80165f <close>

	cprintf("icode: spawn /init\n");
  8000f5:	c7 04 24 32 29 80 00 	movl   $0x802932,(%esp)
  8000fc:	e8 ff 01 00 00       	call   800300 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  800101:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800108:	00 
  800109:	c7 44 24 0c 46 29 80 	movl   $0x802946,0xc(%esp)
  800110:	00 
  800111:	c7 44 24 08 4f 29 80 	movl   $0x80294f,0x8(%esp)
  800118:	00 
  800119:	c7 44 24 04 58 29 80 	movl   $0x802958,0x4(%esp)
  800120:	00 
  800121:	c7 04 24 5d 29 80 00 	movl   $0x80295d,(%esp)
  800128:	e8 64 22 00 00       	call   802391 <spawnl>
  80012d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800130:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800134:	79 23                	jns    800159 <umain+0x125>
		panic("icode: spawn /init: %e", r);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013d:	c7 44 24 08 63 29 80 	movl   $0x802963,0x8(%esp)
  800144:	00 
  800145:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  80014c:	00 
  80014d:	c7 04 24 fe 28 80 00 	movl   $0x8028fe,(%esp)
  800154:	e8 73 00 00 00       	call   8001cc <_panic>

	cprintf("icode: exiting\n");
  800159:	c7 04 24 7a 29 80 00 	movl   $0x80297a,(%esp)
  800160:	e8 9b 01 00 00       	call   800300 <cprintf>
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    
	...

00800168 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  80016e:	e8 53 10 00 00       	call   8011c6 <sys_getenvid>
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	c1 e0 07             	shl    $0x7,%eax
  80017b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800180:	a3 40 50 80 00       	mov    %eax,0x805040
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800189:	7e 0a                	jle    800195 <libmain+0x2d>
		binaryname = argv[0];
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	umain(argc, argv);
  800195:	8b 45 0c             	mov    0xc(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	8b 45 08             	mov    0x8(%ebp),%eax
  80019f:	89 04 24             	mov    %eax,(%esp)
  8001a2:	e8 8d fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8001a7:	e8 04 00 00 00       	call   8001b0 <exit>
}
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    
	...

008001b0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b6:	e8 df 14 00 00       	call   80169a <close_all>
	sys_env_destroy(0);
  8001bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c2:	e8 bc 0f 00 00       	call   801183 <sys_env_destroy>
}
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    
  8001c9:	00 00                	add    %al,(%eax)
	...

008001cc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  8001d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8001d5:	83 c0 04             	add    $0x4,%eax
  8001d8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8001db:	a1 44 50 80 00       	mov    0x805044,%eax
  8001e0:	85 c0                	test   %eax,%eax
  8001e2:	74 15                	je     8001f9 <_panic+0x2d>
		cprintf("%s: ", argv0);
  8001e4:	a1 44 50 80 00       	mov    0x805044,%eax
  8001e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ed:	c7 04 24 a1 29 80 00 	movl   $0x8029a1,(%esp)
  8001f4:	e8 07 01 00 00       	call   800300 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001f9:	a1 00 50 80 00       	mov    0x805000,%eax
  8001fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800201:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800205:	8b 55 08             	mov    0x8(%ebp),%edx
  800208:	89 54 24 08          	mov    %edx,0x8(%esp)
  80020c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800210:	c7 04 24 a6 29 80 00 	movl   $0x8029a6,(%esp)
  800217:	e8 e4 00 00 00       	call   800300 <cprintf>
	vcprintf(fmt, ap);
  80021c:	8b 45 10             	mov    0x10(%ebp),%eax
  80021f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800222:	89 54 24 04          	mov    %edx,0x4(%esp)
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 6e 00 00 00       	call   80029c <vcprintf>
	cprintf("\n");
  80022e:	c7 04 24 c2 29 80 00 	movl   $0x8029c2,(%esp)
  800235:	e8 c6 00 00 00       	call   800300 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80023a:	cc                   	int3   
  80023b:	eb fd                	jmp    80023a <_panic+0x6e>
  80023d:	00 00                	add    %al,(%eax)
	...

00800240 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  800246:	8b 45 0c             	mov    0xc(%ebp),%eax
  800249:	8b 00                	mov    (%eax),%eax
  80024b:	8b 55 08             	mov    0x8(%ebp),%edx
  80024e:	89 d1                	mov    %edx,%ecx
  800250:	8b 55 0c             	mov    0xc(%ebp),%edx
  800253:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  800257:	8d 50 01             	lea    0x1(%eax),%edx
  80025a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025d:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800262:	8b 00                	mov    (%eax),%eax
  800264:	3d ff 00 00 00       	cmp    $0xff,%eax
  800269:	75 20                	jne    80028b <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  80026b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026e:	8b 00                	mov    (%eax),%eax
  800270:	8b 55 0c             	mov    0xc(%ebp),%edx
  800273:	83 c2 08             	add    $0x8,%edx
  800276:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027a:	89 14 24             	mov    %edx,(%esp)
  80027d:	e8 7b 0e 00 00       	call   8010fd <sys_cputs>
		b->idx = 0;
  800282:	8b 45 0c             	mov    0xc(%ebp),%eax
  800285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80028b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028e:	8b 40 04             	mov    0x4(%eax),%eax
  800291:	8d 50 01             	lea    0x1(%eax),%edx
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	89 50 04             	mov    %edx,0x4(%eax)
}
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ac:	00 00 00 
	b.cnt = 0;
  8002af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d1:	c7 04 24 40 02 80 00 	movl   $0x800240,(%esp)
  8002d8:	e8 f7 01 00 00       	call   8004d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002dd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ed:	83 c0 08             	add    $0x8,%eax
  8002f0:	89 04 24             	mov    %eax,(%esp)
  8002f3:	e8 05 0e 00 00       	call   8010fd <sys_cputs>

	return b.cnt;
  8002f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800306:	8d 45 0c             	lea    0xc(%ebp),%eax
  800309:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030c:	8b 45 08             	mov    0x8(%ebp),%eax
  80030f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800312:	89 54 24 04          	mov    %edx,0x4(%esp)
  800316:	89 04 24             	mov    %eax,(%esp)
  800319:	e8 7e ff ff ff       	call   80029c <vcprintf>
  80031e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800321:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800324:	c9                   	leave  
  800325:	c3                   	ret    
	...

00800328 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	53                   	push   %ebx
  80032c:	83 ec 34             	sub    $0x34,%esp
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800335:	8b 45 14             	mov    0x14(%ebp),%eax
  800338:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033b:	8b 45 18             	mov    0x18(%ebp),%eax
  80033e:	ba 00 00 00 00       	mov    $0x0,%edx
  800343:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800346:	77 72                	ja     8003ba <printnum+0x92>
  800348:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80034b:	72 05                	jb     800352 <printnum+0x2a>
  80034d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800350:	77 68                	ja     8003ba <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800352:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800355:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800358:	8b 45 18             	mov    0x18(%ebp),%eax
  80035b:	ba 00 00 00 00       	mov    $0x0,%edx
  800360:	89 44 24 08          	mov    %eax,0x8(%esp)
  800364:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036e:	89 04 24             	mov    %eax,(%esp)
  800371:	89 54 24 04          	mov    %edx,0x4(%esp)
  800375:	e8 86 22 00 00       	call   802600 <__udivdi3>
  80037a:	8b 4d 20             	mov    0x20(%ebp),%ecx
  80037d:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  800381:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  800385:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800388:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80038c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800390:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800394:	8b 45 0c             	mov    0xc(%ebp),%eax
  800397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	89 04 24             	mov    %eax,(%esp)
  8003a1:	e8 82 ff ff ff       	call   800328 <printnum>
  8003a6:	eb 1c                	jmp    8003c4 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	8b 45 20             	mov    0x20(%ebp),%eax
  8003b2:	89 04 24             	mov    %eax,(%esp)
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ba:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8003be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003c2:	7f e4                	jg     8003a8 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003d6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003da:	89 04 24             	mov    %eax,(%esp)
  8003dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003e1:	e8 4a 23 00 00       	call   802730 <__umoddi3>
  8003e6:	05 3c 2b 80 00       	add    $0x802b3c,%eax
  8003eb:	0f b6 00             	movzbl (%eax),%eax
  8003ee:	0f be c0             	movsbl %al,%eax
  8003f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	ff d0                	call   *%eax
}
  800400:	83 c4 34             	add    $0x34,%esp
  800403:	5b                   	pop    %ebx
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800409:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80040d:	7e 1c                	jle    80042b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	8d 50 08             	lea    0x8(%eax),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	89 10                	mov    %edx,(%eax)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	83 e8 08             	sub    $0x8,%eax
  800424:	8b 50 04             	mov    0x4(%eax),%edx
  800427:	8b 00                	mov    (%eax),%eax
  800429:	eb 40                	jmp    80046b <getuint+0x65>
	else if (lflag)
  80042b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042f:	74 1e                	je     80044f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	8d 50 04             	lea    0x4(%eax),%edx
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	89 10                	mov    %edx,(%eax)
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	83 e8 04             	sub    $0x4,%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	ba 00 00 00 00       	mov    $0x0,%edx
  80044d:	eb 1c                	jmp    80046b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	8d 50 04             	lea    0x4(%eax),%edx
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	89 10                	mov    %edx,(%eax)
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	83 e8 04             	sub    $0x4,%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80046b:	5d                   	pop    %ebp
  80046c:	c3                   	ret    

0080046d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800470:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800474:	7e 1c                	jle    800492 <getint+0x25>
		return va_arg(*ap, long long);
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 50 08             	lea    0x8(%eax),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	89 10                	mov    %edx,(%eax)
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	83 e8 08             	sub    $0x8,%eax
  80048b:	8b 50 04             	mov    0x4(%eax),%edx
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	eb 40                	jmp    8004d2 <getint+0x65>
	else if (lflag)
  800492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800496:	74 1e                	je     8004b6 <getint+0x49>
		return va_arg(*ap, long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 04             	lea    0x4(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 04             	sub    $0x4,%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	89 c2                	mov    %eax,%edx
  8004b1:	c1 fa 1f             	sar    $0x1f,%edx
  8004b4:	eb 1c                	jmp    8004d2 <getint+0x65>
	else
		return va_arg(*ap, int);
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	8d 50 04             	lea    0x4(%eax),%edx
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 10                	mov    %edx,(%eax)
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	83 e8 04             	sub    $0x4,%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	c1 fa 1f             	sar    $0x1f,%edx
}
  8004d2:	5d                   	pop    %ebp
  8004d3:	c3                   	ret    

008004d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	56                   	push   %esi
  8004d8:	53                   	push   %ebx
  8004d9:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004dc:	eb 17                	jmp    8004f5 <vprintfmt+0x21>
			if (ch == '\0')
  8004de:	85 db                	test   %ebx,%ebx
  8004e0:	0f 84 d1 05 00 00    	je     800ab7 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  8004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ed:	89 1c 24             	mov    %ebx,(%esp)
  8004f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f3:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f8:	0f b6 00             	movzbl (%eax),%eax
  8004fb:	0f b6 d8             	movzbl %al,%ebx
  8004fe:	83 fb 25             	cmp    $0x25,%ebx
  800501:	0f 95 c0             	setne  %al
  800504:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800508:	84 c0                	test   %al,%al
  80050a:	75 d2                	jne    8004de <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80050c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800510:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800517:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80051e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800525:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80052c:	eb 04                	jmp    800532 <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80052e:	90                   	nop
  80052f:	eb 01                	jmp    800532 <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800531:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800532:	8b 45 10             	mov    0x10(%ebp),%eax
  800535:	0f b6 00             	movzbl (%eax),%eax
  800538:	0f b6 d8             	movzbl %al,%ebx
  80053b:	89 d8                	mov    %ebx,%eax
  80053d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800541:	83 e8 23             	sub    $0x23,%eax
  800544:	83 f8 55             	cmp    $0x55,%eax
  800547:	0f 87 39 05 00 00    	ja     800a86 <vprintfmt+0x5b2>
  80054d:	8b 04 85 84 2b 80 00 	mov    0x802b84(,%eax,4),%eax
  800554:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800556:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80055a:	eb d6                	jmp    800532 <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80055c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800560:	eb d0                	jmp    800532 <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800562:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800569:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80056c:	89 d0                	mov    %edx,%eax
  80056e:	c1 e0 02             	shl    $0x2,%eax
  800571:	01 d0                	add    %edx,%eax
  800573:	01 c0                	add    %eax,%eax
  800575:	01 d8                	add    %ebx,%eax
  800577:	83 e8 30             	sub    $0x30,%eax
  80057a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80057d:	8b 45 10             	mov    0x10(%ebp),%eax
  800580:	0f b6 00             	movzbl (%eax),%eax
  800583:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800586:	83 fb 2f             	cmp    $0x2f,%ebx
  800589:	7e 43                	jle    8005ce <vprintfmt+0xfa>
  80058b:	83 fb 39             	cmp    $0x39,%ebx
  80058e:	7f 3e                	jg     8005ce <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800590:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800594:	eb d3                	jmp    800569 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	83 c0 04             	add    $0x4,%eax
  80059c:	89 45 14             	mov    %eax,0x14(%ebp)
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	83 e8 04             	sub    $0x4,%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005aa:	eb 23                	jmp    8005cf <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  8005ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b0:	0f 89 78 ff ff ff    	jns    80052e <vprintfmt+0x5a>
				width = 0;
  8005b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005bd:	e9 6c ff ff ff       	jmp    80052e <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  8005c2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005c9:	e9 64 ff ff ff       	jmp    800532 <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005ce:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d3:	0f 89 58 ff ff ff    	jns    800531 <vprintfmt+0x5d>
				width = precision, precision = -1;
  8005d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005e6:	e9 46 ff ff ff       	jmp    800531 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005eb:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  8005ef:	e9 3e ff ff ff       	jmp    800532 <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	83 c0 04             	add    $0x4,%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	83 e8 04             	sub    $0x4,%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8b 55 0c             	mov    0xc(%ebp),%edx
  800608:	89 54 24 04          	mov    %edx,0x4(%esp)
  80060c:	89 04 24             	mov    %eax,(%esp)
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	ff d0                	call   *%eax
			break;
  800614:	e9 98 04 00 00       	jmp    800ab1 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  800619:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  800620:	00 
  800621:	8b 45 10             	mov    0x10(%ebp),%eax
  800624:	89 44 24 04          	mov    %eax,0x4(%esp)
  800628:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80062b:	89 04 24             	mov    %eax,(%esp)
  80062e:	e8 d1 07 00 00       	call   800e04 <memmove>
            sel_c[3] = '\0';
  800633:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  800637:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  80063b:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80063f:	3c 2f                	cmp    $0x2f,%al
  800641:	7e 4c                	jle    80068f <vprintfmt+0x1bb>
  800643:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800647:	3c 39                	cmp    $0x39,%al
  800649:	7f 44                	jg     80068f <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  80064b:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80064f:	0f be d0             	movsbl %al,%edx
  800652:	89 d0                	mov    %edx,%eax
  800654:	c1 e0 02             	shl    $0x2,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	01 c0                	add    %eax,%eax
  80065b:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800661:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  800665:	0f be c0             	movsbl %al,%eax
  800668:	01 c2                	add    %eax,%edx
  80066a:	89 d0                	mov    %edx,%eax
  80066c:	c1 e0 02             	shl    $0x2,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	01 c0                	add    %eax,%eax
  800673:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800679:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  80067d:	0f be c0             	movsbl %al,%eax
  800680:	01 d0                	add    %edx,%eax
  800682:	83 e8 30             	sub    $0x30,%eax
  800685:	a3 04 50 80 00       	mov    %eax,0x805004
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80068a:	e9 22 04 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  80068f:	c7 44 24 04 4d 2b 80 	movl   $0x802b4d,0x4(%esp)
  800696:	00 
  800697:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80069a:	89 04 24             	mov    %eax,(%esp)
  80069d:	e8 36 06 00 00       	call   800cd8 <strcmp>
  8006a2:	85 c0                	test   %eax,%eax
  8006a4:	75 0f                	jne    8006b5 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  8006a6:	c7 05 04 50 80 00 07 	movl   $0x7,0x805004
  8006ad:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006b0:	e9 fc 03 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  8006b5:	c7 44 24 04 51 2b 80 	movl   $0x802b51,0x4(%esp)
  8006bc:	00 
  8006bd:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006c0:	89 04 24             	mov    %eax,(%esp)
  8006c3:	e8 10 06 00 00       	call   800cd8 <strcmp>
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	75 0f                	jne    8006db <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  8006cc:	c7 05 04 50 80 00 01 	movl   $0x1,0x805004
  8006d3:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006d6:	e9 d6 03 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  8006db:	c7 44 24 04 55 2b 80 	movl   $0x802b55,0x4(%esp)
  8006e2:	00 
  8006e3:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8006e6:	89 04 24             	mov    %eax,(%esp)
  8006e9:	e8 ea 05 00 00       	call   800cd8 <strcmp>
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	75 0f                	jne    800701 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  8006f2:	c7 05 04 50 80 00 02 	movl   $0x2,0x805004
  8006f9:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8006fc:	e9 b0 03 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  800701:	c7 44 24 04 59 2b 80 	movl   $0x802b59,0x4(%esp)
  800708:	00 
  800709:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80070c:	89 04 24             	mov    %eax,(%esp)
  80070f:	e8 c4 05 00 00       	call   800cd8 <strcmp>
  800714:	85 c0                	test   %eax,%eax
  800716:	75 0f                	jne    800727 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  800718:	c7 05 04 50 80 00 04 	movl   $0x4,0x805004
  80071f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800722:	e9 8a 03 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  800727:	c7 44 24 04 5d 2b 80 	movl   $0x802b5d,0x4(%esp)
  80072e:	00 
  80072f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800732:	89 04 24             	mov    %eax,(%esp)
  800735:	e8 9e 05 00 00       	call   800cd8 <strcmp>
  80073a:	85 c0                	test   %eax,%eax
  80073c:	75 0f                	jne    80074d <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  80073e:	c7 05 04 50 80 00 08 	movl   $0x8,0x805004
  800745:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800748:	e9 64 03 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  80074d:	c7 44 24 04 61 2b 80 	movl   $0x802b61,0x4(%esp)
  800754:	00 
  800755:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800758:	89 04 24             	mov    %eax,(%esp)
  80075b:	e8 78 05 00 00       	call   800cd8 <strcmp>
  800760:	85 c0                	test   %eax,%eax
  800762:	75 0f                	jne    800773 <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  800764:	c7 05 04 50 80 00 0f 	movl   $0xf,0x805004
  80076b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80076e:	e9 3e 03 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  800773:	c7 44 24 04 65 2b 80 	movl   $0x802b65,0x4(%esp)
  80077a:	00 
  80077b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80077e:	89 04 24             	mov    %eax,(%esp)
  800781:	e8 52 05 00 00       	call   800cd8 <strcmp>
  800786:	85 c0                	test   %eax,%eax
  800788:	75 0f                	jne    800799 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  80078a:	c7 05 04 50 80 00 0c 	movl   $0xc,0x805004
  800791:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800794:	e9 18 03 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  800799:	c7 44 24 04 69 2b 80 	movl   $0x802b69,0x4(%esp)
  8007a0:	00 
  8007a1:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007a4:	89 04 24             	mov    %eax,(%esp)
  8007a7:	e8 2c 05 00 00       	call   800cd8 <strcmp>
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	75 0f                	jne    8007bf <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  8007b0:	c7 05 04 50 80 00 06 	movl   $0x6,0x805004
  8007b7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007ba:	e9 f2 02 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  8007bf:	c7 44 24 04 6d 2b 80 	movl   $0x802b6d,0x4(%esp)
  8007c6:	00 
  8007c7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007ca:	89 04 24             	mov    %eax,(%esp)
  8007cd:	e8 06 05 00 00       	call   800cd8 <strcmp>
  8007d2:	85 c0                	test   %eax,%eax
  8007d4:	75 0f                	jne    8007e5 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  8007d6:	c7 05 04 50 80 00 0b 	movl   $0xb,0x805004
  8007dd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007e0:	e9 cc 02 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  8007e5:	c7 05 04 50 80 00 07 	movl   $0x7,0x805004
  8007ec:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007ef:	e9 bd 02 00 00       	jmp    800ab1 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	83 c0 04             	add    $0x4,%eax
  8007fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	83 e8 04             	sub    $0x4,%eax
  800803:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800805:	85 db                	test   %ebx,%ebx
  800807:	79 02                	jns    80080b <vprintfmt+0x337>
				err = -err;
  800809:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80080b:	83 fb 0e             	cmp    $0xe,%ebx
  80080e:	7f 0b                	jg     80081b <vprintfmt+0x347>
  800810:	8b 34 9d 00 2b 80 00 	mov    0x802b00(,%ebx,4),%esi
  800817:	85 f6                	test   %esi,%esi
  800819:	75 23                	jne    80083e <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  80081b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80081f:	c7 44 24 08 71 2b 80 	movl   $0x802b71,0x8(%esp)
  800826:	00 
  800827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	89 04 24             	mov    %eax,(%esp)
  800834:	e8 86 02 00 00       	call   800abf <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800839:	e9 73 02 00 00       	jmp    800ab1 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80083e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800842:	c7 44 24 08 7a 2b 80 	movl   $0x802b7a,0x8(%esp)
  800849:	00 
  80084a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	89 04 24             	mov    %eax,(%esp)
  800857:	e8 63 02 00 00       	call   800abf <printfmt>
			break;
  80085c:	e9 50 02 00 00       	jmp    800ab1 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 c0 04             	add    $0x4,%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 e8 04             	sub    $0x4,%eax
  800870:	8b 30                	mov    (%eax),%esi
  800872:	85 f6                	test   %esi,%esi
  800874:	75 05                	jne    80087b <vprintfmt+0x3a7>
				p = "(null)";
  800876:	be 7d 2b 80 00       	mov    $0x802b7d,%esi
			if (width > 0 && padc != '-')
  80087b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087f:	7e 73                	jle    8008f4 <vprintfmt+0x420>
  800881:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800885:	74 6d                	je     8008f4 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  800887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80088e:	89 34 24             	mov    %esi,(%esp)
  800891:	e8 4c 03 00 00       	call   800be2 <strnlen>
  800896:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800899:	eb 17                	jmp    8008b2 <vprintfmt+0x3de>
					putch(padc, putdat);
  80089b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80089f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a6:	89 04 24             	mov    %eax,(%esp)
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ae:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b6:	7f e3                	jg     80089b <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b8:	eb 3a                	jmp    8008f4 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008be:	74 1f                	je     8008df <vprintfmt+0x40b>
  8008c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008c3:	7e 05                	jle    8008ca <vprintfmt+0x3f6>
  8008c5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008c8:	7e 15                	jle    8008df <vprintfmt+0x40b>
					putch('?', putdat);
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	ff d0                	call   *%eax
  8008dd:	eb 0f                	jmp    8008ee <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  8008df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e6:	89 1c 24             	mov    %ebx,(%esp)
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ee:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008f2:	eb 01                	jmp    8008f5 <vprintfmt+0x421>
  8008f4:	90                   	nop
  8008f5:	0f b6 06             	movzbl (%esi),%eax
  8008f8:	0f be d8             	movsbl %al,%ebx
  8008fb:	85 db                	test   %ebx,%ebx
  8008fd:	0f 95 c0             	setne  %al
  800900:	83 c6 01             	add    $0x1,%esi
  800903:	84 c0                	test   %al,%al
  800905:	74 29                	je     800930 <vprintfmt+0x45c>
  800907:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80090b:	78 ad                	js     8008ba <vprintfmt+0x3e6>
  80090d:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800911:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800915:	79 a3                	jns    8008ba <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800917:	eb 17                	jmp    800930 <vprintfmt+0x45c>
				putch(' ', putdat);
  800919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800920:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800930:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800934:	7f e3                	jg     800919 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  800936:	e9 76 01 00 00       	jmp    800ab1 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80093e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800942:	8d 45 14             	lea    0x14(%ebp),%eax
  800945:	89 04 24             	mov    %eax,(%esp)
  800948:	e8 20 fb ff ff       	call   80046d <getint>
  80094d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800950:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800959:	85 d2                	test   %edx,%edx
  80095b:	79 26                	jns    800983 <vprintfmt+0x4af>
				putch('-', putdat);
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	89 44 24 04          	mov    %eax,0x4(%esp)
  800964:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	ff d0                	call   *%eax
				num = -(long long) num;
  800970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800973:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800976:	f7 d8                	neg    %eax
  800978:	83 d2 00             	adc    $0x0,%edx
  80097b:	f7 da                	neg    %edx
  80097d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800980:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800983:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098a:	e9 ae 00 00 00       	jmp    800a3d <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80098f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800992:	89 44 24 04          	mov    %eax,0x4(%esp)
  800996:	8d 45 14             	lea    0x14(%ebp),%eax
  800999:	89 04 24             	mov    %eax,(%esp)
  80099c:	e8 65 fa ff ff       	call   800406 <getuint>
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ae:	e9 8a 00 00 00       	jmp    800a3d <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  8009b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	89 04 24             	mov    %eax,(%esp)
  8009c0:	e8 41 fa ff ff       	call   800406 <getuint>
  8009c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  8009cb:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  8009d2:	eb 69                	jmp    800a3d <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8009d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009db:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
			putch('x', putdat);
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ee:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	83 c0 04             	add    $0x4,%eax
  800a00:	89 45 14             	mov    %eax,0x14(%ebp)
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	83 e8 04             	sub    $0x4,%eax
  800a09:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a1c:	eb 1f                	jmp    800a3d <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a25:	8d 45 14             	lea    0x14(%ebp),%eax
  800a28:	89 04 24             	mov    %eax,(%esp)
  800a2b:	e8 d6 f9 ff ff       	call   800406 <getuint>
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a3d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a44:	89 54 24 18          	mov    %edx,0x18(%esp)
  800a48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a4b:	89 54 24 14          	mov    %edx,0x14(%esp)
  800a4f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a59:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	89 04 24             	mov    %eax,(%esp)
  800a6e:	e8 b5 f8 ff ff       	call   800328 <printnum>
			break;
  800a73:	eb 3c                	jmp    800ab1 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7c:	89 1c 24             	mov    %ebx,(%esp)
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
			break;
  800a84:	eb 2b                	jmp    800ab1 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a99:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a9d:	eb 04                	jmp    800aa3 <vprintfmt+0x5cf>
  800a9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa6:	83 e8 01             	sub    $0x1,%eax
  800aa9:	0f b6 00             	movzbl (%eax),%eax
  800aac:	3c 25                	cmp    $0x25,%al
  800aae:	75 ef                	jne    800a9f <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800ab0:	90                   	nop
		}
	}
  800ab1:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab2:	e9 3e fa ff ff       	jmp    8004f5 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800ab7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ab8:	83 c4 50             	add    $0x50,%esp
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ac8:	83 c0 04             	add    $0x4,%eax
  800acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ace:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ad8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	89 04 24             	mov    %eax,(%esp)
  800ae9:	e8 e6 f9 ff ff       	call   8004d4 <vprintfmt>
	va_end(ap);
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af6:	8b 40 08             	mov    0x8(%eax),%eax
  800af9:	8d 50 01             	lea    0x1(%eax),%edx
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	8b 10                	mov    (%eax),%edx
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 40 04             	mov    0x4(%eax),%eax
  800b0d:	39 c2                	cmp    %eax,%edx
  800b0f:	73 12                	jae    800b23 <sprintputch+0x33>
		*b->buf++ = ch;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8b 55 08             	mov    0x8(%ebp),%edx
  800b19:	88 10                	mov    %dl,(%eax)
  800b1b:	8d 50 01             	lea    0x1(%eax),%edx
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	89 10                	mov    %edx,(%eax)
}
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	83 e8 01             	sub    $0x1,%eax
  800b37:	03 45 08             	add    0x8(%ebp),%eax
  800b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b48:	74 06                	je     800b50 <vsnprintf+0x2b>
  800b4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4e:	7f 07                	jg     800b57 <vsnprintf+0x32>
		return -E_INVAL;
  800b50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b55:	eb 2a                	jmp    800b81 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b57:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b61:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b6c:	c7 04 24 f0 0a 80 00 	movl   $0x800af0,(%esp)
  800b73:	e8 5c f9 ff ff       	call   8004d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b89:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8c:	83 c0 04             	add    $0x4,%eax
  800b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b92:	8b 45 10             	mov    0x10(%ebp),%eax
  800b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b98:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	89 04 24             	mov    %eax,(%esp)
  800bad:	e8 73 ff ff ff       	call   800b25 <vsnprintf>
  800bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    
	...

00800bbc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc9:	eb 08                	jmp    800bd3 <strlen+0x17>
		n++;
  800bcb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	0f b6 00             	movzbl (%eax),%eax
  800bd9:	84 c0                	test   %al,%al
  800bdb:	75 ee                	jne    800bcb <strlen+0xf>
		n++;
	return n;
  800bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bef:	eb 0c                	jmp    800bfd <strnlen+0x1b>
		n++;
  800bf1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bf9:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800bfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c01:	74 0a                	je     800c0d <strnlen+0x2b>
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	0f b6 00             	movzbl (%eax),%eax
  800c09:	84 c0                	test   %al,%al
  800c0b:	75 e4                	jne    800bf1 <strnlen+0xf>
		n++;
	return n;
  800c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c1e:	90                   	nop
  800c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c22:	0f b6 10             	movzbl (%eax),%edx
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	0f b6 00             	movzbl (%eax),%eax
  800c30:	84 c0                	test   %al,%al
  800c32:	0f 95 c0             	setne  %al
  800c35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c39:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800c3d:	84 c0                	test   %al,%al
  800c3f:	75 de                	jne    800c1f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c59:	eb 21                	jmp    800c7c <strncpy+0x36>
		*dst++ = *src;
  800c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5e:	0f b6 10             	movzbl (%eax),%edx
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	88 10                	mov    %dl,(%eax)
  800c66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	0f b6 00             	movzbl (%eax),%eax
  800c70:	84 c0                	test   %al,%al
  800c72:	74 04                	je     800c78 <strncpy+0x32>
			src++;
  800c74:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c78:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c82:	72 d7                	jb     800c5b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c84:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c99:	74 2f                	je     800cca <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800c9b:	eb 13                	jmp    800cb0 <strlcpy+0x27>
			*dst++ = *src++;
  800c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca0:	0f b6 10             	movzbl (%eax),%edx
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	88 10                	mov    %dl,(%eax)
  800ca8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cac:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800cb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb8:	74 0a                	je     800cc4 <strlcpy+0x3b>
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	0f b6 00             	movzbl (%eax),%eax
  800cc0:	84 c0                	test   %al,%al
  800cc2:	75 d9                	jne    800c9d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd0:	89 d1                	mov    %edx,%ecx
  800cd2:	29 c1                	sub    %eax,%ecx
  800cd4:	89 c8                	mov    %ecx,%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cdb:	eb 08                	jmp    800ce5 <strcmp+0xd>
		p++, q++;
  800cdd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ce1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	0f b6 00             	movzbl (%eax),%eax
  800ceb:	84 c0                	test   %al,%al
  800ced:	74 10                	je     800cff <strcmp+0x27>
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	0f b6 10             	movzbl (%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	0f b6 00             	movzbl (%eax),%eax
  800cfb:	38 c2                	cmp    %al,%dl
  800cfd:	74 de                	je     800cdd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	0f b6 00             	movzbl (%eax),%eax
  800d05:	0f b6 d0             	movzbl %al,%edx
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	0f b6 00             	movzbl (%eax),%eax
  800d0e:	0f b6 c0             	movzbl %al,%eax
  800d11:	89 d1                	mov    %edx,%ecx
  800d13:	29 c1                	sub    %eax,%ecx
  800d15:	89 c8                	mov    %ecx,%eax
}
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1c:	eb 0c                	jmp    800d2a <strncmp+0x11>
		n--, p++, q++;
  800d1e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d22:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d26:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2e:	74 1a                	je     800d4a <strncmp+0x31>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	0f b6 00             	movzbl (%eax),%eax
  800d36:	84 c0                	test   %al,%al
  800d38:	74 10                	je     800d4a <strncmp+0x31>
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	0f b6 10             	movzbl (%eax),%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 00             	movzbl (%eax),%eax
  800d46:	38 c2                	cmp    %al,%dl
  800d48:	74 d4                	je     800d1e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4e:	75 07                	jne    800d57 <strncmp+0x3e>
		return 0;
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	eb 18                	jmp    800d6f <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	0f b6 00             	movzbl (%eax),%eax
  800d5d:	0f b6 d0             	movzbl %al,%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	0f b6 00             	movzbl (%eax),%eax
  800d66:	0f b6 c0             	movzbl %al,%eax
  800d69:	89 d1                	mov    %edx,%ecx
  800d6b:	29 c1                	sub    %eax,%ecx
  800d6d:	89 c8                	mov    %ecx,%eax
}
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	83 ec 04             	sub    $0x4,%esp
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7d:	eb 14                	jmp    800d93 <strchr+0x22>
		if (*s == c)
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	0f b6 00             	movzbl (%eax),%eax
  800d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d88:	75 05                	jne    800d8f <strchr+0x1e>
			return (char *) s;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	eb 13                	jmp    800da2 <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d8f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	0f b6 00             	movzbl (%eax),%eax
  800d99:	84 c0                	test   %al,%al
  800d9b:	75 e2                	jne    800d7f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db0:	eb 0f                	jmp    800dc1 <strfind+0x1d>
		if (*s == c)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	0f b6 00             	movzbl (%eax),%eax
  800db8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dbb:	74 10                	je     800dcd <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dbd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	0f b6 00             	movzbl (%eax),%eax
  800dc7:	84 c0                	test   %al,%al
  800dc9:	75 e7                	jne    800db2 <strfind+0xe>
  800dcb:	eb 01                	jmp    800dce <strfind+0x2a>
		if (*s == c)
			break;
  800dcd:	90                   	nop
	return (char *) s;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memset>:


void *
memset(void *v, int c, size_t n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de5:	eb 0e                	jmp    800df5 <memset+0x22>
		*p++ = c;
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	89 c2                	mov    %eax,%edx
  800dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800def:	88 10                	mov    %dl,(%eax)
  800df1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df5:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800df9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dfd:	79 e8                	jns    800de7 <memset+0x14>
		*p++ = c;

	return v;
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e19:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1c:	73 54                	jae    800e72 <memmove+0x6e>
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	01 d0                	add    %edx,%eax
  800e26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e29:	76 47                	jbe    800e72 <memmove+0x6e>
		s += n;
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e37:	eb 13                	jmp    800e4c <memmove+0x48>
			*--d = *--s;
  800e39:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800e3d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e44:	0f b6 10             	movzbl (%eax),%edx
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e50:	0f 95 c0             	setne  %al
  800e53:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e57:	84 c0                	test   %al,%al
  800e59:	75 de                	jne    800e39 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e5b:	eb 25                	jmp    800e82 <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e60:	0f b6 10             	movzbl (%eax),%edx
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	88 10                	mov    %dl,(%eax)
  800e68:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800e6c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e70:	eb 01                	jmp    800e73 <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e72:	90                   	nop
  800e73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e77:	0f 95 c0             	setne  %al
  800e7a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e7e:	84 c0                	test   %al,%al
  800e80:	75 db                	jne    800e5d <memmove+0x59>
			*d++ = *s++;

	return dst;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e90:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 04 24             	mov    %eax,(%esp)
  800ea1:	e8 5e ff ff ff       	call   800e04 <memmove>
}
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eba:	eb 32                	jmp    800eee <memcmp+0x46>
		if (*s1 != *s2)
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebf:	0f b6 10             	movzbl (%eax),%edx
  800ec2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec5:	0f b6 00             	movzbl (%eax),%eax
  800ec8:	38 c2                	cmp    %al,%dl
  800eca:	74 1a                	je     800ee6 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecf:	0f b6 00             	movzbl (%eax),%eax
  800ed2:	0f b6 d0             	movzbl %al,%edx
  800ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed8:	0f b6 00             	movzbl (%eax),%eax
  800edb:	0f b6 c0             	movzbl %al,%eax
  800ede:	89 d1                	mov    %edx,%ecx
  800ee0:	29 c1                	sub    %eax,%ecx
  800ee2:	89 c8                	mov    %ecx,%eax
  800ee4:	eb 1c                	jmp    800f02 <memcmp+0x5a>
		s1++, s2++;
  800ee6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800eea:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800eee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef2:	0f 95 c0             	setne  %al
  800ef5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800ef9:	84 c0                	test   %al,%al
  800efb:	75 bf                	jne    800ebc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800efd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    

00800f04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f10:	01 d0                	add    %edx,%eax
  800f12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f15:	eb 11                	jmp    800f28 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	0f b6 10             	movzbl (%eax),%edx
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	38 c2                	cmp    %al,%dl
  800f22:	74 0e                	je     800f32 <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f24:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f2e:	72 e7                	jb     800f17 <memfind+0x13>
  800f30:	eb 01                	jmp    800f33 <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f32:	90                   	nop
	return (void *) s;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f45:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4c:	eb 04                	jmp    800f52 <strtol+0x1a>
		s++;
  800f4e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	0f b6 00             	movzbl (%eax),%eax
  800f58:	3c 20                	cmp    $0x20,%al
  800f5a:	74 f2                	je     800f4e <strtol+0x16>
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	0f b6 00             	movzbl (%eax),%eax
  800f62:	3c 09                	cmp    $0x9,%al
  800f64:	74 e8                	je     800f4e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	0f b6 00             	movzbl (%eax),%eax
  800f6c:	3c 2b                	cmp    $0x2b,%al
  800f6e:	75 06                	jne    800f76 <strtol+0x3e>
		s++;
  800f70:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f74:	eb 15                	jmp    800f8b <strtol+0x53>
	else if (*s == '-')
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	0f b6 00             	movzbl (%eax),%eax
  800f7c:	3c 2d                	cmp    $0x2d,%al
  800f7e:	75 0b                	jne    800f8b <strtol+0x53>
		s++, neg = 1;
  800f80:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f84:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8f:	74 06                	je     800f97 <strtol+0x5f>
  800f91:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f95:	75 24                	jne    800fbb <strtol+0x83>
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	0f b6 00             	movzbl (%eax),%eax
  800f9d:	3c 30                	cmp    $0x30,%al
  800f9f:	75 1a                	jne    800fbb <strtol+0x83>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	83 c0 01             	add    $0x1,%eax
  800fa7:	0f b6 00             	movzbl (%eax),%eax
  800faa:	3c 78                	cmp    $0x78,%al
  800fac:	75 0d                	jne    800fbb <strtol+0x83>
		s += 2, base = 16;
  800fae:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fb9:	eb 2a                	jmp    800fe5 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  800fbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbf:	75 17                	jne    800fd8 <strtol+0xa0>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	0f b6 00             	movzbl (%eax),%eax
  800fc7:	3c 30                	cmp    $0x30,%al
  800fc9:	75 0d                	jne    800fd8 <strtol+0xa0>
		s++, base = 8;
  800fcb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fcf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd6:	eb 0d                	jmp    800fe5 <strtol+0xad>
	else if (base == 0)
  800fd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdc:	75 07                	jne    800fe5 <strtol+0xad>
		base = 10;
  800fde:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	0f b6 00             	movzbl (%eax),%eax
  800feb:	3c 2f                	cmp    $0x2f,%al
  800fed:	7e 1b                	jle    80100a <strtol+0xd2>
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	0f b6 00             	movzbl (%eax),%eax
  800ff5:	3c 39                	cmp    $0x39,%al
  800ff7:	7f 11                	jg     80100a <strtol+0xd2>
			dig = *s - '0';
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	0f b6 00             	movzbl (%eax),%eax
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 30             	sub    $0x30,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 48                	jmp    801052 <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	0f b6 00             	movzbl (%eax),%eax
  801010:	3c 60                	cmp    $0x60,%al
  801012:	7e 1b                	jle    80102f <strtol+0xf7>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	0f b6 00             	movzbl (%eax),%eax
  80101a:	3c 7a                	cmp    $0x7a,%al
  80101c:	7f 11                	jg     80102f <strtol+0xf7>
			dig = *s - 'a' + 10;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	0f b6 00             	movzbl (%eax),%eax
  801024:	0f be c0             	movsbl %al,%eax
  801027:	83 e8 57             	sub    $0x57,%eax
  80102a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102d:	eb 23                	jmp    801052 <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	0f b6 00             	movzbl (%eax),%eax
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 38                	jle    801071 <strtol+0x139>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	0f b6 00             	movzbl (%eax),%eax
  80103f:	3c 5a                	cmp    $0x5a,%al
  801041:	7f 2e                	jg     801071 <strtol+0x139>
			dig = *s - 'A' + 10;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	0f b6 00             	movzbl (%eax),%eax
  801049:	0f be c0             	movsbl %al,%eax
  80104c:	83 e8 37             	sub    $0x37,%eax
  80104f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801055:	3b 45 10             	cmp    0x10(%ebp),%eax
  801058:	7d 16                	jge    801070 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  80105a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80105e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801061:	0f af 45 10          	imul   0x10(%ebp),%eax
  801065:	03 45 f4             	add    -0xc(%ebp),%eax
  801068:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106b:	e9 75 ff ff ff       	jmp    800fe5 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801070:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801071:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801075:	74 08                	je     80107f <strtol+0x147>
		*endptr = (char *) s;
  801077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107a:	8b 55 08             	mov    0x8(%ebp),%edx
  80107d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801083:	74 07                	je     80108c <strtol+0x154>
  801085:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801088:	f7 d8                	neg    %eax
  80108a:	eb 03                	jmp    80108f <strtol+0x157>
  80108c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    
  801091:	00 00                	add    %al,(%eax)
	...

00801094 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8010a3:	8b 55 10             	mov    0x10(%ebp),%edx
  8010a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8010a9:	8b 5d 18             	mov    0x18(%ebp),%ebx
  8010ac:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  8010af:	8b 75 20             	mov    0x20(%ebp),%esi
  8010b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b5:	cd 30                	int    $0x30
  8010b7:	89 c3                	mov    %eax,%ebx
  8010b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010c0:	74 30                	je     8010f2 <syscall+0x5e>
  8010c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010c6:	7e 2a                	jle    8010f2 <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010cb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010d6:	c7 44 24 08 dc 2c 80 	movl   $0x802cdc,0x8(%esp)
  8010dd:	00 
  8010de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e5:	00 
  8010e6:	c7 04 24 f9 2c 80 00 	movl   $0x802cf9,(%esp)
  8010ed:	e8 da f0 ff ff       	call   8001cc <_panic>

	return ret;
  8010f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8010f5:	83 c4 4c             	add    $0x4c,%esp
  8010f8:	5b                   	pop    %ebx
  8010f9:	5e                   	pop    %esi
  8010fa:	5f                   	pop    %edi
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80110d:	00 
  80110e:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801115:	00 
  801116:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80111d:	00 
  80111e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801121:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801125:	89 44 24 08          	mov    %eax,0x8(%esp)
  801129:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801130:	00 
  801131:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801138:	e8 57 ff ff ff       	call   801094 <syscall>
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <sys_cgetc>:

int
sys_cgetc(void)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801145:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80114c:	00 
  80114d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801154:	00 
  801155:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80115c:	00 
  80115d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801164:	00 
  801165:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80116c:	00 
  80116d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801174:	00 
  801175:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80117c:	e8 13 ff ff ff       	call   801094 <syscall>
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801193:	00 
  801194:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80119b:	00 
  80119c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011a3:	00 
  8011a4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011ab:	00 
  8011ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011b7:	00 
  8011b8:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8011bf:	e8 d0 fe ff ff       	call   801094 <syscall>
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8011cc:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8011d3:	00 
  8011d4:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8011db:	00 
  8011dc:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011f3:	00 
  8011f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011fb:	00 
  8011fc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801203:	e8 8c fe ff ff       	call   801094 <syscall>
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <sys_yield>:

void
sys_yield(void)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801210:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801217:	00 
  801218:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80121f:	00 
  801220:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801227:	00 
  801228:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80122f:	00 
  801230:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801237:	00 
  801238:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80123f:	00 
  801240:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  801247:	e8 48 fe ff ff       	call   801094 <syscall>
}
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801254:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801264:	00 
  801265:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80126c:	00 
  80126d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801271:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801275:	89 44 24 08          	mov    %eax,0x8(%esp)
  801279:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801280:	00 
  801281:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  801288:	e8 07 fe ff ff       	call   801094 <syscall>
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	56                   	push   %esi
  801293:	53                   	push   %ebx
  801294:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  801297:	8b 75 18             	mov    0x18(%ebp),%esi
  80129a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80129d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	89 74 24 18          	mov    %esi,0x18(%esp)
  8012aa:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8012ae:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8012b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012c1:	00 
  8012c2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8012c9:	e8 c6 fd ff ff       	call   801094 <syscall>
}
  8012ce:	83 c4 20             	add    $0x20,%esp
  8012d1:	5b                   	pop    %ebx
  8012d2:	5e                   	pop    %esi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8012db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012e8:	00 
  8012e9:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012f0:	00 
  8012f1:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012f8:	00 
  8012f9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801301:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801308:	00 
  801309:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  801310:	e8 7f fd ff ff       	call   801094 <syscall>
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80132a:	00 
  80132b:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801332:	00 
  801333:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80133a:	00 
  80133b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80133f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801343:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80134a:	00 
  80134b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  801352:	e8 3d fd ff ff       	call   801094 <syscall>
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80135f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80136c:	00 
  80136d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801374:	00 
  801375:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80137c:	00 
  80137d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801381:	89 44 24 08          	mov    %eax,0x8(%esp)
  801385:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80138c:	00 
  80138d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  801394:	e8 fb fc ff ff       	call   801094 <syscall>
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8013a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013ae:	00 
  8013af:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013b6:	00 
  8013b7:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013be:	00 
  8013bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013ce:	00 
  8013cf:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  8013d6:	e8 b9 fc ff ff       	call   801094 <syscall>
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8013e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013f0:	00 
  8013f1:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013f8:	00 
  8013f9:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801400:	00 
  801401:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801405:	89 44 24 08          	mov    %eax,0x8(%esp)
  801409:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801410:	00 
  801411:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801418:	e8 77 fc ff ff       	call   801094 <syscall>
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801425:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801428:	8b 55 10             	mov    0x10(%ebp),%edx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801435:	00 
  801436:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  80143a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801445:	89 44 24 08          	mov    %eax,0x8(%esp)
  801449:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801450:	00 
  801451:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  801458:	e8 37 fc ff ff       	call   801094 <syscall>
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80146f:	00 
  801470:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801477:	00 
  801478:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80147f:	00 
  801480:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801487:	00 
  801488:	89 44 24 08          	mov    %eax,0x8(%esp)
  80148c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801493:	00 
  801494:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  80149b:	e8 f4 fb ff ff       	call   801094 <syscall>
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    
	...

008014a4 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	89 04 24             	mov    %eax,(%esp)
  8014b0:	e8 0a 00 00 00       	call   8014bf <fd2num>
  8014b5:	05 40 03 00 00       	add    $0x340,%eax
  8014ba:	c1 e0 16             	shl    $0x16,%eax
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <fd2num>:

int
fd2num(struct Fd *fd)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	05 00 00 40 30       	add    $0x30400000,%eax
  8014ca:	c1 e8 0c             	shr    $0xc,%eax
}
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  8014d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014dc:	eb 49                	jmp    801527 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  8014de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e1:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  8014e6:	c1 e0 0c             	shl    $0xc,%eax
  8014e9:	89 c2                	mov    %eax,%edx
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8b 00                	mov    (%eax),%eax
  8014f5:	c1 e8 16             	shr    $0x16,%eax
  8014f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ff:	83 e0 01             	and    $0x1,%eax
  801502:	85 c0                	test   %eax,%eax
  801504:	74 16                	je     80151c <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8b 00                	mov    (%eax),%eax
  80150b:	c1 e8 0c             	shr    $0xc,%eax
  80150e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801515:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801518:	85 c0                	test   %eax,%eax
  80151a:	75 07                	jne    801523 <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
  801521:	eb 18                	jmp    80153b <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801523:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801527:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  80152b:	7e b1                	jle    8014de <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  801536:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  801543:	c7 44 24 08 08 2d 80 	movl   $0x802d08,0x8(%esp)
  80154a:	00 
  80154b:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801552:	00 
  801553:	c7 04 24 22 2d 80 00 	movl   $0x802d22,(%esp)
  80155a:	e8 6d ec ff ff       	call   8001cc <_panic>

0080155f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	89 04 24             	mov    %eax,(%esp)
  80156b:	e8 4f ff ff ff       	call   8014bf <fd2num>
  801570:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801573:	89 54 24 04          	mov    %edx,0x4(%esp)
  801577:	89 04 24             	mov    %eax,(%esp)
  80157a:	e8 be ff ff ff       	call   80153d <fd_lookup>
  80157f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801586:	78 08                	js     801590 <fd_close+0x31>
	    || fd != fd2)
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	39 45 08             	cmp    %eax,0x8(%ebp)
  80158e:	74 12                	je     8015a2 <fd_close+0x43>
		return (must_exist ? r : 0);
  801590:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801594:	74 05                	je     80159b <fd_close+0x3c>
  801596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801599:	eb 05                	jmp    8015a0 <fd_close+0x41>
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a0:	eb 44                	jmp    8015e6 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8b 00                	mov    (%eax),%eax
  8015a7:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8015aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015ae:	89 04 24             	mov    %eax,(%esp)
  8015b1:	e8 32 00 00 00       	call   8015e8 <dev_lookup>
  8015b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015bd:	78 11                	js     8015d0 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  8015bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c2:	8b 50 10             	mov    0x10(%eax),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	89 04 24             	mov    %eax,(%esp)
  8015cb:	ff d2                	call   *%edx
  8015cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015de:	e8 f2 fc ff ff       	call   8012d5 <sys_page_unmap>
	return r;
  8015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  8015ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015f5:	eb 2b                	jmp    801622 <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  8015f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fa:	8b 04 85 08 50 80 00 	mov    0x805008(,%eax,4),%eax
  801601:	8b 00                	mov    (%eax),%eax
  801603:	3b 45 08             	cmp    0x8(%ebp),%eax
  801606:	75 16                	jne    80161e <dev_lookup+0x36>
			*dev = devtab[i];
  801608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160b:	8b 14 85 08 50 80 00 	mov    0x805008(,%eax,4),%edx
  801612:	8b 45 0c             	mov    0xc(%ebp),%eax
  801615:	89 10                	mov    %edx,(%eax)
			return 0;
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
  80161c:	eb 3f                	jmp    80165d <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80161e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801625:	8b 04 85 08 50 80 00 	mov    0x805008(,%eax,4),%eax
  80162c:	85 c0                	test   %eax,%eax
  80162e:	75 c7                	jne    8015f7 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801630:	a1 40 50 80 00       	mov    0x805040,%eax
  801635:	8b 40 4c             	mov    0x4c(%eax),%eax
  801638:	8b 55 08             	mov    0x8(%ebp),%edx
  80163b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80163f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801643:	c7 04 24 2c 2d 80 00 	movl   $0x802d2c,(%esp)
  80164a:	e8 b1 ec ff ff       	call   800300 <cprintf>
	*dev = 0;
  80164f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801652:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801658:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <close>:

int
close(int fdnum)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801665:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801668:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	89 04 24             	mov    %eax,(%esp)
  801672:	e8 c6 fe ff ff       	call   80153d <fd_lookup>
  801677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80167a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80167e:	79 05                	jns    801685 <close+0x26>
		return r;
  801680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801683:	eb 13                	jmp    801698 <close+0x39>
	else
		return fd_close(fd, 1);
  801685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801688:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80168f:	00 
  801690:	89 04 24             	mov    %eax,(%esp)
  801693:	e8 c7 fe ff ff       	call   80155f <fd_close>
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <close_all>:

void
close_all(void)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016a7:	eb 0f                	jmp    8016b8 <close_all+0x1e>
		close(i);
  8016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ac:	89 04 24             	mov    %eax,(%esp)
  8016af:	e8 ab ff ff ff       	call   80165f <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8016b8:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  8016bc:	7e eb                	jle    8016a9 <close_all+0xf>
		close(i);
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8016c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	89 04 24             	mov    %eax,(%esp)
  8016d3:	e8 65 fe ff ff       	call   80153d <fd_lookup>
  8016d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016df:	79 08                	jns    8016e9 <dup+0x29>
		return r;
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	e9 54 01 00 00       	jmp    80183d <dup+0x17d>
	close(newfdnum);
  8016e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ec:	89 04 24             	mov    %eax,(%esp)
  8016ef:	e8 6b ff ff ff       	call   80165f <close>

	newfd = INDEX2FD(newfdnum);
  8016f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f7:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  8016fc:	c1 e0 0c             	shl    $0xc,%eax
  8016ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  801702:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801705:	89 04 24             	mov    %eax,(%esp)
  801708:	e8 97 fd ff ff       	call   8014a4 <fd2data>
  80170d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801713:	89 04 24             	mov    %eax,(%esp)
  801716:	e8 89 fd ff ff       	call   8014a4 <fd2data>
  80171b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80171e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801721:	c1 e8 0c             	shr    $0xc,%eax
  801724:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80172b:	89 c2                	mov    %eax,%edx
  80172d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801733:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801736:	89 54 24 10          	mov    %edx,0x10(%esp)
  80173a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80173d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801741:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801748:	00 
  801749:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801754:	e8 36 fb ff ff       	call   80128f <sys_page_map>
  801759:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80175c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801760:	0f 88 8e 00 00 00    	js     8017f4 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  801766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801769:	c1 e8 16             	shr    $0x16,%eax
  80176c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801773:	85 c0                	test   %eax,%eax
  801775:	74 78                	je     8017ef <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80177e:	eb 66                	jmp    8017e6 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  801780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801783:	03 45 e8             	add    -0x18(%ebp),%eax
  801786:	c1 e8 0c             	shr    $0xc,%eax
  801789:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801790:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  801793:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801796:	83 e0 01             	and    $0x1,%eax
  801799:	84 c0                	test   %al,%al
  80179b:	74 42                	je     8017df <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  80179d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a0:	89 c1                	mov    %eax,%ecx
  8017a2:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8017a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ab:	89 c2                	mov    %eax,%edx
  8017ad:	03 55 e4             	add    -0x1c(%ebp),%edx
  8017b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b3:	03 45 e8             	add    -0x18(%ebp),%eax
  8017b6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8017ba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017be:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017c5:	00 
  8017c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d1:	e8 b9 fa ff ff       	call   80128f <sys_page_map>
  8017d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017dd:	78 18                	js     8017f7 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8017df:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8017e6:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  8017ed:	7e 91                	jle    801780 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  8017ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f2:	eb 49                	jmp    80183d <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  8017f4:	90                   	nop
  8017f5:	eb 01                	jmp    8017f8 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  8017f7:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801806:	e8 ca fa ff ff       	call   8012d5 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80180b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801812:	eb 1d                	jmp    801831 <dup+0x171>
		sys_page_unmap(0, nva + i);
  801814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801817:	03 45 e4             	add    -0x1c(%ebp),%eax
  80181a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801825:	e8 ab fa ff ff       	call   8012d5 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80182a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801831:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801838:	7e da                	jle    801814 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  80183a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801845:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	89 04 24             	mov    %eax,(%esp)
  801852:	e8 e6 fc ff ff       	call   80153d <fd_lookup>
  801857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80185e:	78 1d                	js     80187d <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801863:	8b 00                	mov    (%eax),%eax
  801865:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801868:	89 54 24 04          	mov    %edx,0x4(%esp)
  80186c:	89 04 24             	mov    %eax,(%esp)
  80186f:	e8 74 fd ff ff       	call   8015e8 <dev_lookup>
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80187b:	79 05                	jns    801882 <read+0x43>
		return r;
  80187d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801880:	eb 75                	jmp    8018f7 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801885:	8b 40 08             	mov    0x8(%eax),%eax
  801888:	83 e0 03             	and    $0x3,%eax
  80188b:	83 f8 01             	cmp    $0x1,%eax
  80188e:	75 26                	jne    8018b6 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801890:	a1 40 50 80 00       	mov    0x805040,%eax
  801895:	8b 40 4c             	mov    0x4c(%eax),%eax
  801898:	8b 55 08             	mov    0x8(%ebp),%edx
  80189b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80189f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a3:	c7 04 24 4b 2d 80 00 	movl   $0x802d4b,(%esp)
  8018aa:	e8 51 ea ff ff       	call   800300 <cprintf>
		return -E_INVAL;
  8018af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b4:	eb 41                	jmp    8018f7 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8018b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b9:	8b 48 08             	mov    0x8(%eax),%ecx
  8018bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bf:	8b 50 04             	mov    0x4(%eax),%edx
  8018c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8018c9:	8b 55 10             	mov    0x10(%ebp),%edx
  8018cc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018d7:	89 04 24             	mov    %eax,(%esp)
  8018da:	ff d1                	call   *%ecx
  8018dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  8018df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018e3:	78 0f                	js     8018f4 <read+0xb5>
		fd->fd_offset += r;
  8018e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018eb:	8b 52 04             	mov    0x4(%edx),%edx
  8018ee:	03 55 f4             	add    -0xc(%ebp),%edx
  8018f1:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  8018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801906:	eb 3b                	jmp    801943 <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190b:	8b 55 10             	mov    0x10(%ebp),%edx
  80190e:	29 c2                	sub    %eax,%edx
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	03 45 0c             	add    0xc(%ebp),%eax
  801916:	89 54 24 08          	mov    %edx,0x8(%esp)
  80191a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	89 04 24             	mov    %eax,(%esp)
  801924:	e8 16 ff ff ff       	call   80183f <read>
  801929:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  80192c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801930:	79 05                	jns    801937 <readn+0x3e>
			return m;
  801932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801935:	eb 1a                	jmp    801951 <readn+0x58>
		if (m == 0)
  801937:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80193b:	74 10                	je     80194d <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80193d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801940:	01 45 f4             	add    %eax,-0xc(%ebp)
  801943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801946:	3b 45 10             	cmp    0x10(%ebp),%eax
  801949:	72 bd                	jb     801908 <readn+0xf>
  80194b:	eb 01                	jmp    80194e <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80194d:	90                   	nop
	}
	return tot;
  80194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801959:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80195c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	89 04 24             	mov    %eax,(%esp)
  801966:	e8 d2 fb ff ff       	call   80153d <fd_lookup>
  80196b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80196e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801972:	78 1d                	js     801991 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801977:	8b 00                	mov    (%eax),%eax
  801979:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80197c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801980:	89 04 24             	mov    %eax,(%esp)
  801983:	e8 60 fc ff ff       	call   8015e8 <dev_lookup>
  801988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80198b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80198f:	79 05                	jns    801996 <write+0x43>
		return r;
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	eb 74                	jmp    801a0a <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801999:	8b 40 08             	mov    0x8(%eax),%eax
  80199c:	83 e0 03             	and    $0x3,%eax
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	75 26                	jne    8019c9 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8019a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8019a8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b6:	c7 04 24 67 2d 80 00 	movl   $0x802d67,(%esp)
  8019bd:	e8 3e e9 ff ff       	call   800300 <cprintf>
		return -E_INVAL;
  8019c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019c7:	eb 41                	jmp    801a0a <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cc:	8b 48 0c             	mov    0xc(%eax),%ecx
  8019cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d2:	8b 50 04             	mov    0x4(%eax),%edx
  8019d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019dc:	8b 55 10             	mov    0x10(%ebp),%edx
  8019df:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019ea:	89 04 24             	mov    %eax,(%esp)
  8019ed:	ff d1                	call   *%ecx
  8019ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  8019f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f6:	7e 0f                	jle    801a07 <write+0xb4>
		fd->fd_offset += r;
  8019f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019fe:	8b 52 04             	mov    0x4(%edx),%edx
  801a01:	03 55 f4             	add    -0xc(%ebp),%edx
  801a04:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <seek>:

int
seek(int fdnum, off_t offset)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a12:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	89 04 24             	mov    %eax,(%esp)
  801a1f:	e8 19 fb ff ff       	call   80153d <fd_lookup>
  801a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a2b:	79 05                	jns    801a32 <seek+0x26>
		return r;
  801a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a30:	eb 0e                	jmp    801a40 <seek+0x34>
	fd->fd_offset = offset;
  801a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a48:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	89 04 24             	mov    %eax,(%esp)
  801a55:	e8 e3 fa ff ff       	call   80153d <fd_lookup>
  801a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a61:	78 1d                	js     801a80 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a66:	8b 00                	mov    (%eax),%eax
  801a68:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801a6b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a6f:	89 04 24             	mov    %eax,(%esp)
  801a72:	e8 71 fb ff ff       	call   8015e8 <dev_lookup>
  801a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a7e:	79 05                	jns    801a85 <ftruncate+0x43>
		return r;
  801a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a83:	eb 48                	jmp    801acd <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a88:	8b 40 08             	mov    0x8(%eax),%eax
  801a8b:	83 e0 03             	and    $0x3,%eax
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	75 26                	jne    801ab8 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801a92:	a1 40 50 80 00       	mov    0x805040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a97:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a9a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a9d:	89 54 24 08          	mov    %edx,0x8(%esp)
  801aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa5:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  801aac:	e8 4f e8 ff ff       	call   800300 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801ab1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ab6:	eb 15                	jmp    801acd <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abb:	8b 48 1c             	mov    0x1c(%eax),%ecx
  801abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ac8:	89 04 24             	mov    %eax,(%esp)
  801acb:	ff d1                	call   *%ecx
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	89 04 24             	mov    %eax,(%esp)
  801ae2:	e8 56 fa ff ff       	call   80153d <fd_lookup>
  801ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aee:	78 1d                	js     801b0d <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af3:	8b 00                	mov    (%eax),%eax
  801af5:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801af8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801afc:	89 04 24             	mov    %eax,(%esp)
  801aff:	e8 e4 fa ff ff       	call   8015e8 <dev_lookup>
  801b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b0b:	79 05                	jns    801b12 <fstat+0x43>
		return r;
  801b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b10:	eb 41                	jmp    801b53 <fstat+0x84>
	stat->st_name[0] = 0;
  801b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b15:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801b22:	00 00 00 
	stat->st_isdir = 0;
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  801b2f:	00 00 00 
	stat->st_dev = dev;
  801b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  801b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b41:	8b 48 14             	mov    0x14(%eax),%ecx
  801b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b4e:	89 04 24             	mov    %eax,(%esp)
  801b51:	ff d1                	call   *%ecx
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b62:	00 
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	89 04 24             	mov    %eax,(%esp)
  801b69:	e8 36 00 00 00       	call   801ba4 <open>
  801b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b75:	79 05                	jns    801b7c <stat+0x27>
		return fd;
  801b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7a:	eb 23                	jmp    801b9f <stat+0x4a>
	r = fstat(fd, stat);
  801b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	89 04 24             	mov    %eax,(%esp)
  801b89:	e8 41 ff ff ff       	call   801acf <fstat>
  801b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  801b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b94:	89 04 24             	mov    %eax,(%esp)
  801b97:	e8 c3 fa ff ff       	call   80165f <close>
	return r;
  801b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    
  801ba1:	00 00                	add    %al,(%eax)
	...

00801ba4 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801baa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bad:	89 04 24             	mov    %eax,(%esp)
  801bb0:	e8 1a f9 ff ff       	call   8014cf <fd_alloc>
  801bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bbc:	79 05                	jns    801bc3 <open+0x1f>
  801bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc1:	eb 73                	jmp    801c36 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  801bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	89 04 24             	mov    %eax,(%esp)
  801bd7:	e8 54 05 00 00       	call   802130 <fsipc_open>
  801bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be3:	79 05                	jns    801bea <open+0x46>
  801be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be8:	eb 4c                	jmp    801c36 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bed:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c01:	00 
  801c02:	89 04 24             	mov    %eax,(%esp)
  801c05:	e8 25 03 00 00       	call   801f2f <fmap>
  801c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c11:	79 18                	jns    801c2b <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  801c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c16:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c1d:	00 
  801c1e:	89 04 24             	mov    %eax,(%esp)
  801c21:	e8 39 f9 ff ff       	call   80155f <fd_close>
  801c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c29:	eb 0b                	jmp    801c36 <open+0x92>
	return fd2num(fd);
  801c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2e:	89 04 24             	mov    %eax,(%esp)
  801c31:	e8 89 f8 ff ff       	call   8014bf <fd2num>
	//panic("open() unimplemented!");
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801c47:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801c4e:	00 
  801c4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c56:	00 
  801c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 72 03 00 00       	call   801fd8 <funmap>
  801c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c6d:	79 05                	jns    801c74 <file_close+0x3c>
  801c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c72:	eb 21                	jmp    801c95 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7a:	89 04 24             	mov    %eax,(%esp)
  801c7d:	e8 e3 05 00 00       	call   802265 <fsipc_close>
  801c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c89:	79 05                	jns    801c90 <file_close+0x58>
  801c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8e:	eb 05                	jmp    801c95 <file_close+0x5d>
	return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801caf:	76 07                	jbe    801cb8 <file_read+0x21>
		return 0;
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb6:	eb 43                	jmp    801cfb <file_read+0x64>
	if (offset + n > size)
  801cb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbb:	03 45 10             	add    0x10(%ebp),%eax
  801cbe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cc1:	76 0f                	jbe    801cd2 <file_read+0x3b>
		n = size - offset;
  801cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc9:	89 d1                	mov    %edx,%ecx
  801ccb:	29 c1                	sub    %eax,%ecx
  801ccd:	89 c8                	mov    %ecx,%eax
  801ccf:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	89 04 24             	mov    %eax,(%esp)
  801cd8:	e8 c7 f7 ff ff       	call   8014a4 <fd2data>
  801cdd:	8b 55 14             	mov    0x14(%ebp),%edx
  801ce0:	01 c2                	add    %eax,%edx
  801ce2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce5:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ce9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf0:	89 04 24             	mov    %eax,(%esp)
  801cf3:	e8 0c f1 ff ff       	call   800e04 <memmove>
	return n;
  801cf8:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	89 04 24             	mov    %eax,(%esp)
  801d10:	e8 28 f8 ff ff       	call   80153d <fd_lookup>
  801d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d1c:	79 05                	jns    801d23 <read_map+0x26>
		return r;
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	eb 74                	jmp    801d97 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  801d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d26:	8b 10                	mov    (%eax),%edx
  801d28:	a1 20 50 80 00       	mov    0x805020,%eax
  801d2d:	39 c2                	cmp    %eax,%edx
  801d2f:	74 07                	je     801d38 <read_map+0x3b>
		return -E_INVAL;
  801d31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d36:	eb 5f                	jmp    801d97 <read_map+0x9a>
	va = fd2data(fd) + offset;
  801d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3b:	89 04 24             	mov    %eax,(%esp)
  801d3e:	e8 61 f7 ff ff       	call   8014a4 <fd2data>
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	01 d0                	add    %edx,%eax
  801d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  801d4b:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  801d52:	7e 07                	jle    801d5b <read_map+0x5e>
		return -E_NO_DISK;
  801d54:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801d59:	eb 3c                	jmp    801d97 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5e:	c1 e8 16             	shr    $0x16,%eax
  801d61:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d68:	83 e0 01             	and    $0x1,%eax
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	74 14                	je     801d83 <read_map+0x86>
  801d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d72:	c1 e8 0c             	shr    $0xc,%eax
  801d75:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d7c:	83 e0 01             	and    $0x1,%eax
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	75 07                	jne    801d8a <read_map+0x8d>
		return -E_NO_DISK;
  801d83:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801d88:	eb 0d                	jmp    801d97 <read_map+0x9a>
	*blk = (void*) va;
  801d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d90:	89 10                	mov    %edx,(%eax)
	return 0;
  801d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  801d9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801da2:	03 45 10             	add    0x10(%ebp),%eax
  801da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  801da8:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  801daf:	76 07                	jbe    801db8 <file_write+0x1f>
		return -E_NO_DISK;
  801db1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801db6:	eb 57                	jmp    801e0f <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801dc1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801dc4:	73 20                	jae    801de6 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  801dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	89 04 24             	mov    %eax,(%esp)
  801dd3:	e8 88 00 00 00       	call   801e60 <file_trunc>
  801dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ddb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ddf:	79 05                	jns    801de6 <file_write+0x4d>
			return r;
  801de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de4:	eb 29                	jmp    801e0f <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	89 04 24             	mov    %eax,(%esp)
  801dec:	e8 b3 f6 ff ff       	call   8014a4 <fd2data>
  801df1:	8b 55 14             	mov    0x14(%ebp),%edx
  801df4:	01 c2                	add    %eax,%edx
  801df6:	8b 45 10             	mov    0x10(%ebp),%eax
  801df9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	89 14 24             	mov    %edx,(%esp)
  801e07:	e8 f8 ef ff ff       	call   800e04 <memmove>
	return n;
  801e0c:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	8d 50 10             	lea    0x10(%eax),%edx
  801e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e20:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e24:	89 04 24             	mov    %eax,(%esp)
  801e27:	e8 e6 ed ff ff       	call   800c12 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e38:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  801e47:	83 f8 01             	cmp    $0x1,%eax
  801e4a:	0f 94 c0             	sete   %al
  801e4d:	0f b6 d0             	movzbl %al,%edx
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  801e66:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  801e6d:	7e 0a                	jle    801e79 <file_trunc+0x19>
		return -E_NO_DISK;
  801e6f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801e74:	e9 b4 00 00 00       	jmp    801f2d <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e94:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e98:	89 04 24             	mov    %eax,(%esp)
  801e9b:	e8 82 03 00 00       	call   802222 <fsipc_set_size>
  801ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ea3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ea7:	79 05                	jns    801eae <file_trunc+0x4e>
		return r;
  801ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eac:	eb 7f                	jmp    801f2d <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801eb7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801eba:	74 24                	je     801ee0 <file_trunc+0x80>
  801ebc:	c7 44 24 0c b0 2d 80 	movl   $0x802db0,0xc(%esp)
  801ec3:	00 
  801ec4:	c7 44 24 08 d3 2d 80 	movl   $0x802dd3,0x8(%esp)
  801ecb:	00 
  801ecc:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801ed3:	00 
  801ed4:	c7 04 24 e8 2d 80 00 	movl   $0x802de8,(%esp)
  801edb:	e8 ec e2 ff ff       	call   8001cc <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	89 04 24             	mov    %eax,(%esp)
  801ef4:	e8 36 00 00 00       	call   801f2f <fmap>
  801ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801efc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f00:	79 05                	jns    801f07 <file_trunc+0xa7>
		return r;
  801f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f05:	eb 26                	jmp    801f2d <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  801f07:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f0e:	00 
  801f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f12:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	89 04 24             	mov    %eax,(%esp)
  801f23:	e8 b0 00 00 00       	call   801fd8 <funmap>

	return 0;
  801f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	89 04 24             	mov    %eax,(%esp)
  801f3b:	e8 64 f5 ff ff       	call   8014a4 <fd2data>
  801f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  801f43:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4d:	03 45 ec             	add    -0x14(%ebp),%eax
  801f50:	83 e8 01             	sub    $0x1,%eax
  801f53:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f59:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5e:	f7 75 ec             	divl   -0x14(%ebp)
  801f61:	89 d0                	mov    %edx,%eax
  801f63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f66:	89 d1                	mov    %edx,%ecx
  801f68:	29 c1                	sub    %eax,%ecx
  801f6a:	89 c8                	mov    %ecx,%eax
  801f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6f:	eb 58                	jmp    801fc9 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f77:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	8b 40 0c             	mov    0xc(%eax),%eax
  801f83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f87:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f8b:	89 04 24             	mov    %eax,(%esp)
  801f8e:	e8 04 02 00 00       	call   802197 <fsipc_map>
  801f93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f9a:	79 26                	jns    801fc2 <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fa6:	00 
  801fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faa:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	89 04 24             	mov    %eax,(%esp)
  801fb8:	e8 1b 00 00 00       	call   801fd8 <funmap>
			return r;
  801fbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc0:	eb 14                	jmp    801fd6 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  801fc2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fcf:	77 a0                	ja     801f71 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	89 04 24             	mov    %eax,(%esp)
  801fe4:	e8 bb f4 ff ff       	call   8014a4 <fd2data>
  801fe9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  801fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fef:	c1 e8 16             	shr    $0x16,%eax
  801ff2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ff9:	83 e0 01             	and    $0x1,%eax
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	75 0a                	jne    80200a <funmap+0x32>
		return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	e9 bf 00 00 00       	jmp    8020c9 <funmap+0xf1>

	ret = 0;
  80200a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  802011:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802018:	8b 45 10             	mov    0x10(%ebp),%eax
  80201b:	03 45 e8             	add    -0x18(%ebp),%eax
  80201e:	83 e8 01             	sub    $0x1,%eax
  802021:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802027:	ba 00 00 00 00       	mov    $0x0,%edx
  80202c:	f7 75 e8             	divl   -0x18(%ebp)
  80202f:	89 d0                	mov    %edx,%eax
  802031:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802034:	89 d1                	mov    %edx,%ecx
  802036:	29 c1                	sub    %eax,%ecx
  802038:	89 c8                	mov    %ecx,%eax
  80203a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203d:	eb 7b                	jmp    8020ba <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802045:	01 d0                	add    %edx,%eax
  802047:	c1 e8 0c             	shr    $0xc,%eax
  80204a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802051:	83 e0 01             	and    $0x1,%eax
  802054:	84 c0                	test   %al,%al
  802056:	74 5b                	je     8020b3 <funmap+0xdb>
			if (dirty
  802058:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  80205c:	74 3d                	je     80209b <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802064:	01 d0                	add    %edx,%eax
  802066:	c1 e8 0c             	shr    $0xc,%eax
  802069:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802070:	83 e0 40             	and    $0x40,%eax
  802073:	85 c0                	test   %eax,%eax
  802075:	74 24                	je     80209b <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  802077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	8b 40 0c             	mov    0xc(%eax),%eax
  802080:	89 54 24 04          	mov    %edx,0x4(%esp)
  802084:	89 04 24             	mov    %eax,(%esp)
  802087:	e8 13 02 00 00       	call   80229f <fsipc_dirty>
  80208c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80208f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802093:	79 06                	jns    80209b <funmap+0xc3>
				ret = r;
  802095:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802098:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ae:	e8 22 f2 ff ff       	call   8012d5 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8020b3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8020ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020c0:	0f 87 79 ff ff ff    	ja     80203f <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  8020c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <remove>:

// Delete a file
int
remove(const char *path)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	89 04 24             	mov    %eax,(%esp)
  8020d7:	e8 06 02 00 00       	call   8022e2 <fsipc_remove>
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  8020e4:	e8 56 02 00 00       	call   80233f <fsipc_sync>
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    
	...

008020ec <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  8020f2:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  8020f7:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020fe:	00 
  8020ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802102:	89 54 24 08          	mov    %edx,0x8(%esp)
  802106:	8b 55 08             	mov    0x8(%ebp),%edx
  802109:	89 54 24 04          	mov    %edx,0x4(%esp)
  80210d:	89 04 24             	mov    %eax,(%esp)
  802110:	e8 47 04 00 00       	call   80255c <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802115:	8b 45 14             	mov    0x14(%ebp),%eax
  802118:	89 44 24 08          	mov    %eax,0x8(%esp)
  80211c:	8b 45 10             	mov    0x10(%ebp),%eax
  80211f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802123:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802126:	89 04 24             	mov    %eax,(%esp)
  802129:	e8 a2 03 00 00       	call   8024d0 <ipc_recv>
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  802136:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	89 04 24             	mov    %eax,(%esp)
  802143:	e8 74 ea ff ff       	call   800bbc <strlen>
  802148:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80214d:	7e 07                	jle    802156 <fsipc_open+0x26>
		return -E_BAD_PATH;
  80214f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802154:	eb 3f                	jmp    802195 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	8b 55 08             	mov    0x8(%ebp),%edx
  80215c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802160:	89 04 24             	mov    %eax,(%esp)
  802163:	e8 aa ea ff ff       	call   800c12 <strcpy>
	req->req_omode = omode;
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216e:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  802174:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802177:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80217b:	8b 45 10             	mov    0x10(%ebp),%eax
  80217e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	89 44 24 04          	mov    %eax,0x4(%esp)
  802189:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802190:	e8 57 ff ff ff       	call   8020ec <fsipc>
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  80219d:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021aa:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b2:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  8021b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ca:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8021d1:	e8 16 ff ff ff       	call   8020ec <fsipc>
  8021d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021dd:	79 05                	jns    8021e4 <fsipc_map+0x4d>
		return r;
  8021df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e2:	eb 3c                	jmp    802220 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  8021e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e7:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  8021ec:	83 f8 05             	cmp    $0x5,%eax
  8021ef:	74 2a                	je     80221b <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  8021f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f4:	8b 55 10             	mov    0x10(%ebp),%edx
  8021f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8021fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021ff:	c7 44 24 08 f4 2d 80 	movl   $0x802df4,0x8(%esp)
  802206:	00 
  802207:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  80220e:	00 
  80220f:	c7 04 24 2a 2e 80 00 	movl   $0x802e2a,(%esp)
  802216:	e8 b1 df ff ff       	call   8001cc <_panic>
	return 0;
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802228:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	8b 55 08             	mov    0x8(%ebp),%edx
  802235:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223d:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802240:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802247:	00 
  802248:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80224f:	00 
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	89 44 24 04          	mov    %eax,0x4(%esp)
  802257:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80225e:	e8 89 fe ff ff       	call   8020ec <fsipc>
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  80226b:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 55 08             	mov    0x8(%ebp),%edx
  802278:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  80227a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802281:	00 
  802282:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802289:	00 
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802291:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  802298:	e8 4f fe ff ff       	call   8020ec <fsipc>
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  8022a5:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b2:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ba:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8022bd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022c4:	00 
  8022c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022cc:	00 
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8022db:	e8 0c fe ff ff       	call   8020ec <fsipc>
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  8022e8:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	89 04 24             	mov    %eax,(%esp)
  8022f5:	e8 c2 e8 ff ff       	call   800bbc <strlen>
  8022fa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8022ff:	7e 07                	jle    802308 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802301:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802306:	eb 35                	jmp    80233d <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 55 08             	mov    0x8(%ebp),%edx
  80230e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802312:	89 04 24             	mov    %eax,(%esp)
  802315:	e8 f8 e8 ff ff       	call   800c12 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  80231a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802321:	00 
  802322:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802329:	00 
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802331:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  802338:	e8 af fd ff ff       	call   8020ec <fsipc>
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802345:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80234c:	00 
  80234d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802354:	00 
  802355:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  80235c:	00 
  80235d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  802364:	e8 83 fd ff ff       	call   8020ec <fsipc>
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    
	...

0080236c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	81 ec 68 02 00 00    	sub    $0x268,%esp
	//   - Start the child process running with sys_env_set_status().

	// LAB 5: Your code here.
	
	(void) child;
	panic("spawn unimplemented!");
  802375:	c7 44 24 08 36 2e 80 	movl   $0x802e36,0x8(%esp)
  80237c:	00 
  80237d:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  802384:	00 
  802385:	c7 04 24 4b 2e 80 00 	movl   $0x802e4b,(%esp)
  80238c:	e8 3b de ff ff       	call   8001cc <_panic>

00802391 <spawnl>:
}

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
  802394:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  802397:	8d 45 0c             	lea    0xc(%ebp),%eax
  80239a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	89 04 24             	mov    %eax,(%esp)
  8023a4:	e8 c3 ff ff ff       	call   80236c <spawn>
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 48             	sub    $0x48,%esp
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8023b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (argc = 0; argv[argc] != 0; argc++)
  8023b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023bf:	eb 20                	jmp    8023e1 <init_stack+0x36>
		string_size += strlen(argv[argc]) + 1;
  8023c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c4:	c1 e0 02             	shl    $0x2,%eax
  8023c7:	03 45 0c             	add    0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	89 04 24             	mov    %eax,(%esp)
  8023cf:	e8 e8 e7 ff ff       	call   800bbc <strlen>
  8023d4:	03 45 f4             	add    -0xc(%ebp),%eax
  8023d7:	83 c0 01             	add    $0x1,%eax
  8023da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8023dd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8023e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e4:	c1 e0 02             	shl    $0x2,%eax
  8023e7:	03 45 0c             	add    0xc(%ebp),%eax
  8023ea:	8b 00                	mov    (%eax),%eax
  8023ec:	85 c0                	test   %eax,%eax
  8023ee:	75 d1                	jne    8023c1 <init_stack+0x16>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	f7 d8                	neg    %eax
  8023f5:	05 00 10 40 00       	add    $0x401000,%eax
  8023fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8023fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802406:	83 e0 fc             	and    $0xfffffffc,%eax
  802409:	89 c2                	mov    %eax,%edx
  80240b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240e:	f7 d0                	not    %eax
  802410:	c1 e0 02             	shl    $0x2,%eax
  802413:	01 d0                	add    %edx,%eax
  802415:	89 45 e0             	mov    %eax,-0x20(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241b:	83 e8 08             	sub    $0x8,%eax
  80241e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802423:	77 0a                	ja     80242f <init_stack+0x84>
		return -E_NO_MEM;
  802425:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80242a:	e9 9d 00 00 00       	jmp    8024cc <init_stack+0x121>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80242f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802436:	00 
  802437:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80243e:	00 
  80243f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802446:	e8 03 ee ff ff       	call   80124e <sys_page_alloc>
  80244b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80244e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802452:	79 05                	jns    802459 <init_stack+0xae>
		return r;
  802454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802457:	eb 73                	jmp    8024cc <init_stack+0x121>
		
		}*/
	
	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802459:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802460:	00 
  802461:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802468:	ee 
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802470:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802477:	00 
  802478:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80247f:	e8 0b ee ff ff       	call   80128f <sys_page_map>
  802484:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802487:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80248b:	78 24                	js     8024b1 <init_stack+0x106>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80248d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802494:	00 
  802495:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80249c:	e8 34 ee ff ff       	call   8012d5 <sys_page_unmap>
  8024a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8024a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024a8:	78 0a                	js     8024b4 <init_stack+0x109>
		goto error;

	return 0;
  8024aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8024af:	eb 1b                	jmp    8024cc <init_stack+0x121>
		}*/
	
	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  8024b1:	90                   	nop
  8024b2:	eb 01                	jmp    8024b5 <init_stack+0x10a>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  8024b4:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8024b5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8024bc:	00 
  8024bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c4:	e8 0c ee ff ff       	call   8012d5 <sys_page_unmap>
	return r;
  8024c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    
	...

008024d0 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  8024d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024da:	75 11                	jne    8024ed <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  8024dc:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  8024e3:	e8 77 ef ff ff       	call   80145f <sys_ipc_recv>
  8024e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024eb:	eb 0e                	jmp    8024fb <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  8024ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f0:	89 04 24             	mov    %eax,(%esp)
  8024f3:	e8 67 ef ff ff       	call   80145f <sys_ipc_recv>
  8024f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  8024fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ff:	79 1c                	jns    80251d <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  802501:	c7 44 24 08 57 2e 80 	movl   $0x802e57,0x8(%esp)
  802508:	00 
  802509:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  802510:	00 
  802511:	c7 04 24 6d 2e 80 00 	movl   $0x802e6d,(%esp)
  802518:	e8 af dc ff ff       	call   8001cc <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  80251d:	e8 a4 ec ff ff       	call   8011c6 <sys_getenvid>
  802522:	25 ff 03 00 00       	and    $0x3ff,%eax
  802527:	c1 e0 07             	shl    $0x7,%eax
  80252a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80252f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  802532:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802536:	74 0b                	je     802543 <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  802538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253b:	8b 50 74             	mov    0x74(%eax),%edx
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  802543:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802547:	74 0b                	je     802554 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  802549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254c:	8b 50 78             	mov    0x78(%eax),%edx
  80254f:	8b 45 10             	mov    0x10(%ebp),%eax
  802552:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  802554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802557:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  802562:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802566:	75 26                	jne    80258e <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  802568:	8b 45 14             	mov    0x14(%ebp),%eax
  80256b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80256f:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  802576:	ee 
  802577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	89 04 24             	mov    %eax,(%esp)
  802584:	e8 96 ee ff ff       	call   80141f <sys_ipc_try_send>
  802589:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258c:	eb 23                	jmp    8025b1 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  80258e:	8b 45 14             	mov    0x14(%ebp),%eax
  802591:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802595:	8b 45 10             	mov    0x10(%ebp),%eax
  802598:	89 44 24 08          	mov    %eax,0x8(%esp)
  80259c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	89 04 24             	mov    %eax,(%esp)
  8025a9:	e8 71 ee ff ff       	call   80141f <sys_ipc_try_send>
  8025ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  8025b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b5:	79 29                	jns    8025e0 <ipc_send+0x84>
  8025b7:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  8025bb:	74 23                	je     8025e0 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025c4:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  8025cb:	00 
  8025cc:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8025d3:	00 
  8025d4:	c7 04 24 6d 2e 80 00 	movl   $0x802e6d,(%esp)
  8025db:	e8 ec db ff ff       	call   8001cc <_panic>
	    sys_yield();
  8025e0:	e8 25 ec ff ff       	call   80120a <sys_yield>
	}while(r < 0);
  8025e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e9:	0f 88 73 ff ff ff    	js     802562 <ipc_send+0x6>
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    
	...

00802600 <__udivdi3>:
  802600:	83 ec 1c             	sub    $0x1c,%esp
  802603:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802607:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80260b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80260f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802613:	89 74 24 10          	mov    %esi,0x10(%esp)
  802617:	8b 74 24 24          	mov    0x24(%esp),%esi
  80261b:	85 ff                	test   %edi,%edi
  80261d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802621:	89 44 24 08          	mov    %eax,0x8(%esp)
  802625:	89 cd                	mov    %ecx,%ebp
  802627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262b:	75 33                	jne    802660 <__udivdi3+0x60>
  80262d:	39 f1                	cmp    %esi,%ecx
  80262f:	77 57                	ja     802688 <__udivdi3+0x88>
  802631:	85 c9                	test   %ecx,%ecx
  802633:	75 0b                	jne    802640 <__udivdi3+0x40>
  802635:	b8 01 00 00 00       	mov    $0x1,%eax
  80263a:	31 d2                	xor    %edx,%edx
  80263c:	f7 f1                	div    %ecx
  80263e:	89 c1                	mov    %eax,%ecx
  802640:	89 f0                	mov    %esi,%eax
  802642:	31 d2                	xor    %edx,%edx
  802644:	f7 f1                	div    %ecx
  802646:	89 c6                	mov    %eax,%esi
  802648:	8b 44 24 04          	mov    0x4(%esp),%eax
  80264c:	f7 f1                	div    %ecx
  80264e:	89 f2                	mov    %esi,%edx
  802650:	8b 74 24 10          	mov    0x10(%esp),%esi
  802654:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802658:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80265c:	83 c4 1c             	add    $0x1c,%esp
  80265f:	c3                   	ret    
  802660:	31 d2                	xor    %edx,%edx
  802662:	31 c0                	xor    %eax,%eax
  802664:	39 f7                	cmp    %esi,%edi
  802666:	77 e8                	ja     802650 <__udivdi3+0x50>
  802668:	0f bd cf             	bsr    %edi,%ecx
  80266b:	83 f1 1f             	xor    $0x1f,%ecx
  80266e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802672:	75 2c                	jne    8026a0 <__udivdi3+0xa0>
  802674:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802678:	76 04                	jbe    80267e <__udivdi3+0x7e>
  80267a:	39 f7                	cmp    %esi,%edi
  80267c:	73 d2                	jae    802650 <__udivdi3+0x50>
  80267e:	31 d2                	xor    %edx,%edx
  802680:	b8 01 00 00 00       	mov    $0x1,%eax
  802685:	eb c9                	jmp    802650 <__udivdi3+0x50>
  802687:	90                   	nop
  802688:	89 f2                	mov    %esi,%edx
  80268a:	f7 f1                	div    %ecx
  80268c:	31 d2                	xor    %edx,%edx
  80268e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802692:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802696:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80269a:	83 c4 1c             	add    $0x1c,%esp
  80269d:	c3                   	ret    
  80269e:	66 90                	xchg   %ax,%ax
  8026a0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026a5:	b8 20 00 00 00       	mov    $0x20,%eax
  8026aa:	89 ea                	mov    %ebp,%edx
  8026ac:	2b 44 24 04          	sub    0x4(%esp),%eax
  8026b0:	d3 e7                	shl    %cl,%edi
  8026b2:	89 c1                	mov    %eax,%ecx
  8026b4:	d3 ea                	shr    %cl,%edx
  8026b6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026bb:	09 fa                	or     %edi,%edx
  8026bd:	89 f7                	mov    %esi,%edi
  8026bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026c3:	89 f2                	mov    %esi,%edx
  8026c5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8026c9:	d3 e5                	shl    %cl,%ebp
  8026cb:	89 c1                	mov    %eax,%ecx
  8026cd:	d3 ef                	shr    %cl,%edi
  8026cf:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026d4:	d3 e2                	shl    %cl,%edx
  8026d6:	89 c1                	mov    %eax,%ecx
  8026d8:	d3 ee                	shr    %cl,%esi
  8026da:	09 d6                	or     %edx,%esi
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	89 f0                	mov    %esi,%eax
  8026e0:	f7 74 24 0c          	divl   0xc(%esp)
  8026e4:	89 d7                	mov    %edx,%edi
  8026e6:	89 c6                	mov    %eax,%esi
  8026e8:	f7 e5                	mul    %ebp
  8026ea:	39 d7                	cmp    %edx,%edi
  8026ec:	72 22                	jb     802710 <__udivdi3+0x110>
  8026ee:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8026f2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026f7:	d3 e5                	shl    %cl,%ebp
  8026f9:	39 c5                	cmp    %eax,%ebp
  8026fb:	73 04                	jae    802701 <__udivdi3+0x101>
  8026fd:	39 d7                	cmp    %edx,%edi
  8026ff:	74 0f                	je     802710 <__udivdi3+0x110>
  802701:	89 f0                	mov    %esi,%eax
  802703:	31 d2                	xor    %edx,%edx
  802705:	e9 46 ff ff ff       	jmp    802650 <__udivdi3+0x50>
  80270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802710:	8d 46 ff             	lea    -0x1(%esi),%eax
  802713:	31 d2                	xor    %edx,%edx
  802715:	8b 74 24 10          	mov    0x10(%esp),%esi
  802719:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80271d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802721:	83 c4 1c             	add    $0x1c,%esp
  802724:	c3                   	ret    
	...

00802730 <__umoddi3>:
  802730:	83 ec 1c             	sub    $0x1c,%esp
  802733:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802737:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80273b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80273f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802743:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802747:	8b 74 24 24          	mov    0x24(%esp),%esi
  80274b:	85 ed                	test   %ebp,%ebp
  80274d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802751:	89 44 24 08          	mov    %eax,0x8(%esp)
  802755:	89 cf                	mov    %ecx,%edi
  802757:	89 04 24             	mov    %eax,(%esp)
  80275a:	89 f2                	mov    %esi,%edx
  80275c:	75 1a                	jne    802778 <__umoddi3+0x48>
  80275e:	39 f1                	cmp    %esi,%ecx
  802760:	76 4e                	jbe    8027b0 <__umoddi3+0x80>
  802762:	f7 f1                	div    %ecx
  802764:	89 d0                	mov    %edx,%eax
  802766:	31 d2                	xor    %edx,%edx
  802768:	8b 74 24 10          	mov    0x10(%esp),%esi
  80276c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802770:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802774:	83 c4 1c             	add    $0x1c,%esp
  802777:	c3                   	ret    
  802778:	39 f5                	cmp    %esi,%ebp
  80277a:	77 54                	ja     8027d0 <__umoddi3+0xa0>
  80277c:	0f bd c5             	bsr    %ebp,%eax
  80277f:	83 f0 1f             	xor    $0x1f,%eax
  802782:	89 44 24 04          	mov    %eax,0x4(%esp)
  802786:	75 60                	jne    8027e8 <__umoddi3+0xb8>
  802788:	3b 0c 24             	cmp    (%esp),%ecx
  80278b:	0f 87 07 01 00 00    	ja     802898 <__umoddi3+0x168>
  802791:	89 f2                	mov    %esi,%edx
  802793:	8b 34 24             	mov    (%esp),%esi
  802796:	29 ce                	sub    %ecx,%esi
  802798:	19 ea                	sbb    %ebp,%edx
  80279a:	89 34 24             	mov    %esi,(%esp)
  80279d:	8b 04 24             	mov    (%esp),%eax
  8027a0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027a4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027a8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027ac:	83 c4 1c             	add    $0x1c,%esp
  8027af:	c3                   	ret    
  8027b0:	85 c9                	test   %ecx,%ecx
  8027b2:	75 0b                	jne    8027bf <__umoddi3+0x8f>
  8027b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b9:	31 d2                	xor    %edx,%edx
  8027bb:	f7 f1                	div    %ecx
  8027bd:	89 c1                	mov    %eax,%ecx
  8027bf:	89 f0                	mov    %esi,%eax
  8027c1:	31 d2                	xor    %edx,%edx
  8027c3:	f7 f1                	div    %ecx
  8027c5:	8b 04 24             	mov    (%esp),%eax
  8027c8:	f7 f1                	div    %ecx
  8027ca:	eb 98                	jmp    802764 <__umoddi3+0x34>
  8027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d0:	89 f2                	mov    %esi,%edx
  8027d2:	8b 74 24 10          	mov    0x10(%esp),%esi
  8027d6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8027da:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8027de:	83 c4 1c             	add    $0x1c,%esp
  8027e1:	c3                   	ret    
  8027e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027e8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027ed:	89 e8                	mov    %ebp,%eax
  8027ef:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027f4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8027f8:	89 fa                	mov    %edi,%edx
  8027fa:	d3 e0                	shl    %cl,%eax
  8027fc:	89 e9                	mov    %ebp,%ecx
  8027fe:	d3 ea                	shr    %cl,%edx
  802800:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802805:	09 c2                	or     %eax,%edx
  802807:	8b 44 24 08          	mov    0x8(%esp),%eax
  80280b:	89 14 24             	mov    %edx,(%esp)
  80280e:	89 f2                	mov    %esi,%edx
  802810:	d3 e7                	shl    %cl,%edi
  802812:	89 e9                	mov    %ebp,%ecx
  802814:	d3 ea                	shr    %cl,%edx
  802816:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80281b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80281f:	d3 e6                	shl    %cl,%esi
  802821:	89 e9                	mov    %ebp,%ecx
  802823:	d3 e8                	shr    %cl,%eax
  802825:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80282a:	09 f0                	or     %esi,%eax
  80282c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802830:	f7 34 24             	divl   (%esp)
  802833:	d3 e6                	shl    %cl,%esi
  802835:	89 74 24 08          	mov    %esi,0x8(%esp)
  802839:	89 d6                	mov    %edx,%esi
  80283b:	f7 e7                	mul    %edi
  80283d:	39 d6                	cmp    %edx,%esi
  80283f:	89 c1                	mov    %eax,%ecx
  802841:	89 d7                	mov    %edx,%edi
  802843:	72 3f                	jb     802884 <__umoddi3+0x154>
  802845:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802849:	72 35                	jb     802880 <__umoddi3+0x150>
  80284b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80284f:	29 c8                	sub    %ecx,%eax
  802851:	19 fe                	sbb    %edi,%esi
  802853:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802858:	89 f2                	mov    %esi,%edx
  80285a:	d3 e8                	shr    %cl,%eax
  80285c:	89 e9                	mov    %ebp,%ecx
  80285e:	d3 e2                	shl    %cl,%edx
  802860:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802865:	09 d0                	or     %edx,%eax
  802867:	89 f2                	mov    %esi,%edx
  802869:	d3 ea                	shr    %cl,%edx
  80286b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80286f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802873:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802877:	83 c4 1c             	add    $0x1c,%esp
  80287a:	c3                   	ret    
  80287b:	90                   	nop
  80287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802880:	39 d6                	cmp    %edx,%esi
  802882:	75 c7                	jne    80284b <__umoddi3+0x11b>
  802884:	89 d7                	mov    %edx,%edi
  802886:	89 c1                	mov    %eax,%ecx
  802888:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80288c:	1b 3c 24             	sbb    (%esp),%edi
  80288f:	eb ba                	jmp    80284b <__umoddi3+0x11b>
  802891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802898:	39 f5                	cmp    %esi,%ebp
  80289a:	0f 82 f1 fe ff ff    	jb     802791 <__umoddi3+0x61>
  8028a0:	e9 f8 fe ff ff       	jmp    80279d <__umoddi3+0x6d>
