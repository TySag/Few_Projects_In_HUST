
obj/user/writemotd:     file format elf32-i386


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
  80002c:	e8 57 02 00 00       	call   800288 <libmain>
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
  800037:	81 ec 28 02 00 00    	sub    $0x228,%esp
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80003d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800044:	00 
  800045:	c7 04 24 60 28 80 00 	movl   $0x802860,(%esp)
  80004c:	e8 73 1c 00 00       	call   801cc4 <open>
  800051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800058:	79 23                	jns    80007d <umain+0x49>
		panic("open /newmotd: %e", rfd);
  80005a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80005d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800061:	c7 44 24 08 69 28 80 	movl   $0x802869,0x8(%esp)
  800068:	00 
  800069:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800070:	00 
  800071:	c7 04 24 7b 28 80 00 	movl   $0x80287b,(%esp)
  800078:	e8 6f 02 00 00       	call   8002ec <_panic>
	if ((wfd = open("/motd", O_RDWR)) < 0)
  80007d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  80008c:	e8 33 1c 00 00       	call   801cc4 <open>
  800091:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800094:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800098:	79 23                	jns    8000bd <umain+0x89>
		panic("open /motd: %e", wfd);
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a1:	c7 44 24 08 92 28 80 	movl   $0x802892,0x8(%esp)
  8000a8:	00 
  8000a9:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  8000b0:	00 
  8000b1:	c7 04 24 7b 28 80 00 	movl   $0x80287b,(%esp)
  8000b8:	e8 2f 02 00 00       	call   8002ec <_panic>
	cprintf("file descriptors %d %d\n", rfd, wfd);
  8000bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000cb:	c7 04 24 a1 28 80 00 	movl   $0x8028a1,(%esp)
  8000d2:	e8 49 03 00 00       	call   800420 <cprintf>
	if (rfd == wfd)
  8000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000dd:	75 1c                	jne    8000fb <umain+0xc7>
		panic("open /newmotd and /motd give same file descriptor");
  8000df:	c7 44 24 08 bc 28 80 	movl   $0x8028bc,0x8(%esp)
  8000e6:	00 
  8000e7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  8000ee:	00 
  8000ef:	c7 04 24 7b 28 80 00 	movl   $0x80287b,(%esp)
  8000f6:	e8 f1 01 00 00       	call   8002ec <_panic>

	cprintf("OLD MOTD\n===\n");
  8000fb:	c7 04 24 ee 28 80 00 	movl   $0x8028ee,(%esp)
  800102:	e8 19 03 00 00       	call   800420 <cprintf>
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800107:	eb 15                	jmp    80011e <umain+0xea>
		sys_cputs(buf, n);
  800109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800110:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800116:	89 04 24             	mov    %eax,(%esp)
  800119:	e8 ff 10 00 00       	call   80121d <sys_cputs>
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  80011e:	c7 44 24 08 ff 01 00 	movl   $0x1ff,0x8(%esp)
  800125:	00 
  800126:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800133:	89 04 24             	mov    %eax,(%esp)
  800136:	e8 24 18 00 00       	call   80195f <read>
  80013b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80013e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800142:	7f c5                	jg     800109 <umain+0xd5>
		sys_cputs(buf, n);
	cprintf("===\n");
  800144:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  80014b:	e8 d0 02 00 00       	call   800420 <cprintf>
	seek(wfd, 0);
  800150:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800157:	00 
  800158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80015b:	89 04 24             	mov    %eax,(%esp)
  80015e:	e8 c9 19 00 00       	call   801b2c <seek>

	if ((r = ftruncate(wfd, 0)) < 0)
  800163:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80016a:	00 
  80016b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80016e:	89 04 24             	mov    %eax,(%esp)
  800171:	e8 ec 19 00 00       	call   801b62 <ftruncate>
  800176:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800179:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80017d:	79 23                	jns    8001a2 <umain+0x16e>
		panic("truncate /motd: %e", r);
  80017f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800182:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800186:	c7 44 24 08 01 29 80 	movl   $0x802901,0x8(%esp)
  80018d:	00 
  80018e:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800195:	00 
  800196:	c7 04 24 7b 28 80 00 	movl   $0x80287b,(%esp)
  80019d:	e8 4a 01 00 00       	call   8002ec <_panic>

	cprintf("NEW MOTD\n===\n");
  8001a2:	c7 04 24 14 29 80 00 	movl   $0x802914,(%esp)
  8001a9:	e8 72 02 00 00       	call   800420 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8001ae:	eb 5f                	jmp    80020f <umain+0x1db>
		sys_cputs(buf, n);
  8001b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 58 10 00 00       	call   80121d <sys_cputs>
		if ((r = write(wfd, buf, n)) != n)
  8001c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001cc:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8001d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001d9:	89 04 24             	mov    %eax,(%esp)
  8001dc:	e8 92 18 00 00       	call   801a73 <write>
  8001e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8001e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8001ea:	74 23                	je     80020f <umain+0x1db>
			panic("write /motd: %e", r);
  8001ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f3:	c7 44 24 08 22 29 80 	movl   $0x802922,0x8(%esp)
  8001fa:	00 
  8001fb:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  800202:	00 
  800203:	c7 04 24 7b 28 80 00 	movl   $0x80287b,(%esp)
  80020a:	e8 dd 00 00 00       	call   8002ec <_panic>

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  80020f:	c7 44 24 08 ff 01 00 	movl   $0x1ff,0x8(%esp)
  800216:	00 
  800217:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80021d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800224:	89 04 24             	mov    %eax,(%esp)
  800227:	e8 33 17 00 00       	call   80195f <read>
  80022c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80022f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800233:	0f 8f 77 ff ff ff    	jg     8001b0 <umain+0x17c>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800239:	c7 04 24 fc 28 80 00 	movl   $0x8028fc,(%esp)
  800240:	e8 db 01 00 00       	call   800420 <cprintf>

	if (n < 0)
  800245:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800249:	79 23                	jns    80026e <umain+0x23a>
		panic("read /newmotd: %e", n);
  80024b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80024e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800252:	c7 44 24 08 32 29 80 	movl   $0x802932,0x8(%esp)
  800259:	00 
  80025a:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  800261:	00 
  800262:	c7 04 24 7b 28 80 00 	movl   $0x80287b,(%esp)
  800269:	e8 7e 00 00 00       	call   8002ec <_panic>

	close(rfd);
  80026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800271:	89 04 24             	mov    %eax,(%esp)
  800274:	e8 06 15 00 00       	call   80177f <close>
	close(wfd);
  800279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027c:	89 04 24             	mov    %eax,(%esp)
  80027f:	e8 fb 14 00 00       	call   80177f <close>
}
  800284:	c9                   	leave  
  800285:	c3                   	ret    
	...

00800288 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  80028e:	e8 53 10 00 00       	call   8012e6 <sys_getenvid>
  800293:	25 ff 03 00 00       	and    $0x3ff,%eax
  800298:	c1 e0 07             	shl    $0x7,%eax
  80029b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002a0:	a3 40 50 80 00       	mov    %eax,0x805040
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a9:	7e 0a                	jle    8002b5 <libmain+0x2d>
		binaryname = argv[0];
  8002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	umain(argc, argv);
  8002b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bf:	89 04 24             	mov    %eax,(%esp)
  8002c2:	e8 6d fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8002c7:	e8 04 00 00 00       	call   8002d0 <exit>
}
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    
	...

008002d0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8002d6:	e8 df 14 00 00       	call   8017ba <close_all>
	sys_env_destroy(0);
  8002db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002e2:	e8 bc 0f 00 00       	call   8012a3 <sys_env_destroy>
}
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    
  8002e9:	00 00                	add    %al,(%eax)
	...

008002ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  8002f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f5:	83 c0 04             	add    $0x4,%eax
  8002f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8002fb:	a1 44 50 80 00       	mov    0x805044,%eax
  800300:	85 c0                	test   %eax,%eax
  800302:	74 15                	je     800319 <_panic+0x2d>
		cprintf("%s: ", argv0);
  800304:	a1 44 50 80 00       	mov    0x805044,%eax
  800309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030d:	c7 04 24 5b 29 80 00 	movl   $0x80295b,(%esp)
  800314:	e8 07 01 00 00       	call   800420 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800319:	a1 00 50 80 00       	mov    0x805000,%eax
  80031e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800321:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800325:	8b 55 08             	mov    0x8(%ebp),%edx
  800328:	89 54 24 08          	mov    %edx,0x8(%esp)
  80032c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800330:	c7 04 24 60 29 80 00 	movl   $0x802960,(%esp)
  800337:	e8 e4 00 00 00       	call   800420 <cprintf>
	vcprintf(fmt, ap);
  80033c:	8b 45 10             	mov    0x10(%ebp),%eax
  80033f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800342:	89 54 24 04          	mov    %edx,0x4(%esp)
  800346:	89 04 24             	mov    %eax,(%esp)
  800349:	e8 6e 00 00 00       	call   8003bc <vcprintf>
	cprintf("\n");
  80034e:	c7 04 24 7c 29 80 00 	movl   $0x80297c,(%esp)
  800355:	e8 c6 00 00 00       	call   800420 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80035a:	cc                   	int3   
  80035b:	eb fd                	jmp    80035a <_panic+0x6e>
  80035d:	00 00                	add    %al,(%eax)
	...

00800360 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  800366:	8b 45 0c             	mov    0xc(%ebp),%eax
  800369:	8b 00                	mov    (%eax),%eax
  80036b:	8b 55 08             	mov    0x8(%ebp),%edx
  80036e:	89 d1                	mov    %edx,%ecx
  800370:	8b 55 0c             	mov    0xc(%ebp),%edx
  800373:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  800377:	8d 50 01             	lea    0x1(%eax),%edx
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  80037f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	3d ff 00 00 00       	cmp    $0xff,%eax
  800389:	75 20                	jne    8003ab <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  80038b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	8b 55 0c             	mov    0xc(%ebp),%edx
  800393:	83 c2 08             	add    $0x8,%edx
  800396:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039a:	89 14 24             	mov    %edx,(%esp)
  80039d:	e8 7b 0e 00 00       	call   80121d <sys_cputs>
		b->idx = 0;
  8003a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ae:	8b 40 04             	mov    0x4(%eax),%eax
  8003b1:	8d 50 01             	lea    0x1(%eax),%edx
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    

008003bc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003cc:	00 00 00 
	b.cnt = 0;
  8003cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f1:	c7 04 24 60 03 80 00 	movl   $0x800360,(%esp)
  8003f8:	e8 f7 01 00 00       	call   8005f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003fd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800403:	89 44 24 04          	mov    %eax,0x4(%esp)
  800407:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040d:	83 c0 08             	add    $0x8,%eax
  800410:	89 04 24             	mov    %eax,(%esp)
  800413:	e8 05 0e 00 00       	call   80121d <sys_cputs>

	return b.cnt;
  800418:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800426:	8d 45 0c             	lea    0xc(%ebp),%eax
  800429:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800432:	89 54 24 04          	mov    %edx,0x4(%esp)
  800436:	89 04 24             	mov    %eax,(%esp)
  800439:	e8 7e ff ff ff       	call   8003bc <vcprintf>
  80043e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800444:	c9                   	leave  
  800445:	c3                   	ret    
	...

00800448 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	53                   	push   %ebx
  80044c:	83 ec 34             	sub    $0x34,%esp
  80044f:	8b 45 10             	mov    0x10(%ebp),%eax
  800452:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800455:	8b 45 14             	mov    0x14(%ebp),%eax
  800458:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80045b:	8b 45 18             	mov    0x18(%ebp),%eax
  80045e:	ba 00 00 00 00       	mov    $0x0,%edx
  800463:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800466:	77 72                	ja     8004da <printnum+0x92>
  800468:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80046b:	72 05                	jb     800472 <printnum+0x2a>
  80046d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800470:	77 68                	ja     8004da <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800472:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800475:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800478:	8b 45 18             	mov    0x18(%ebp),%eax
  80047b:	ba 00 00 00 00       	mov    $0x0,%edx
  800480:	89 44 24 08          	mov    %eax,0x8(%esp)
  800484:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80048e:	89 04 24             	mov    %eax,(%esp)
  800491:	89 54 24 04          	mov    %edx,0x4(%esp)
  800495:	e8 16 21 00 00       	call   8025b0 <__udivdi3>
  80049a:	8b 4d 20             	mov    0x20(%ebp),%ecx
  80049d:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  8004a1:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8004a5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004a8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	e8 82 ff ff ff       	call   800448 <printnum>
  8004c6:	eb 1c                	jmp    8004e4 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004cf:	8b 45 20             	mov    0x20(%ebp),%eax
  8004d2:	89 04 24             	mov    %eax,(%esp)
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004da:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8004de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004e2:	7f e4                	jg     8004c8 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004f6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004fa:	89 04 24             	mov    %eax,(%esp)
  8004fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  800501:	e8 da 21 00 00       	call   8026e0 <__umoddi3>
  800506:	05 dc 2a 80 00       	add    $0x802adc,%eax
  80050b:	0f b6 00             	movzbl (%eax),%eax
  80050e:	0f be c0             	movsbl %al,%eax
  800511:	8b 55 0c             	mov    0xc(%ebp),%edx
  800514:	89 54 24 04          	mov    %edx,0x4(%esp)
  800518:	89 04 24             	mov    %eax,(%esp)
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	ff d0                	call   *%eax
}
  800520:	83 c4 34             	add    $0x34,%esp
  800523:	5b                   	pop    %ebx
  800524:	5d                   	pop    %ebp
  800525:	c3                   	ret    

00800526 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800529:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80052d:	7e 1c                	jle    80054b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	8d 50 08             	lea    0x8(%eax),%edx
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	89 10                	mov    %edx,(%eax)
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	83 e8 08             	sub    $0x8,%eax
  800544:	8b 50 04             	mov    0x4(%eax),%edx
  800547:	8b 00                	mov    (%eax),%eax
  800549:	eb 40                	jmp    80058b <getuint+0x65>
	else if (lflag)
  80054b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80054f:	74 1e                	je     80056f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	8d 50 04             	lea    0x4(%eax),%edx
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	89 10                	mov    %edx,(%eax)
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	83 e8 04             	sub    $0x4,%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	ba 00 00 00 00       	mov    $0x0,%edx
  80056d:	eb 1c                	jmp    80058b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	8d 50 04             	lea    0x4(%eax),%edx
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	89 10                	mov    %edx,(%eax)
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	83 e8 04             	sub    $0x4,%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80058b:	5d                   	pop    %ebp
  80058c:	c3                   	ret    

0080058d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80058d:	55                   	push   %ebp
  80058e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800590:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800594:	7e 1c                	jle    8005b2 <getint+0x25>
		return va_arg(*ap, long long);
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	8d 50 08             	lea    0x8(%eax),%edx
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	89 10                	mov    %edx,(%eax)
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	83 e8 08             	sub    $0x8,%eax
  8005ab:	8b 50 04             	mov    0x4(%eax),%edx
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	eb 40                	jmp    8005f2 <getint+0x65>
	else if (lflag)
  8005b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b6:	74 1e                	je     8005d6 <getint+0x49>
		return va_arg(*ap, long);
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	8d 50 04             	lea    0x4(%eax),%edx
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	89 10                	mov    %edx,(%eax)
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	83 e8 04             	sub    $0x4,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	89 c2                	mov    %eax,%edx
  8005d1:	c1 fa 1f             	sar    $0x1f,%edx
  8005d4:	eb 1c                	jmp    8005f2 <getint+0x65>
	else
		return va_arg(*ap, int);
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	8d 50 04             	lea    0x4(%eax),%edx
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	89 10                	mov    %edx,(%eax)
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	83 e8 04             	sub    $0x4,%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	c1 fa 1f             	sar    $0x1f,%edx
}
  8005f2:	5d                   	pop    %ebp
  8005f3:	c3                   	ret    

008005f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	56                   	push   %esi
  8005f8:	53                   	push   %ebx
  8005f9:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005fc:	eb 17                	jmp    800615 <vprintfmt+0x21>
			if (ch == '\0')
  8005fe:	85 db                	test   %ebx,%ebx
  800600:	0f 84 d1 05 00 00    	je     800bd7 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060d:	89 1c 24             	mov    %ebx,(%esp)
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800615:	8b 45 10             	mov    0x10(%ebp),%eax
  800618:	0f b6 00             	movzbl (%eax),%eax
  80061b:	0f b6 d8             	movzbl %al,%ebx
  80061e:	83 fb 25             	cmp    $0x25,%ebx
  800621:	0f 95 c0             	setne  %al
  800624:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800628:	84 c0                	test   %al,%al
  80062a:	75 d2                	jne    8005fe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80062c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800630:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800637:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80063e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800645:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80064c:	eb 04                	jmp    800652 <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80064e:	90                   	nop
  80064f:	eb 01                	jmp    800652 <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800651:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800652:	8b 45 10             	mov    0x10(%ebp),%eax
  800655:	0f b6 00             	movzbl (%eax),%eax
  800658:	0f b6 d8             	movzbl %al,%ebx
  80065b:	89 d8                	mov    %ebx,%eax
  80065d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800661:	83 e8 23             	sub    $0x23,%eax
  800664:	83 f8 55             	cmp    $0x55,%eax
  800667:	0f 87 39 05 00 00    	ja     800ba6 <vprintfmt+0x5b2>
  80066d:	8b 04 85 24 2b 80 00 	mov    0x802b24(,%eax,4),%eax
  800674:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800676:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80067a:	eb d6                	jmp    800652 <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80067c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800680:	eb d0                	jmp    800652 <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800682:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	c1 e0 02             	shl    $0x2,%eax
  800691:	01 d0                	add    %edx,%eax
  800693:	01 c0                	add    %eax,%eax
  800695:	01 d8                	add    %ebx,%eax
  800697:	83 e8 30             	sub    $0x30,%eax
  80069a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80069d:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a0:	0f b6 00             	movzbl (%eax),%eax
  8006a3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006a6:	83 fb 2f             	cmp    $0x2f,%ebx
  8006a9:	7e 43                	jle    8006ee <vprintfmt+0xfa>
  8006ab:	83 fb 39             	cmp    $0x39,%ebx
  8006ae:	7f 3e                	jg     8006ee <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006b4:	eb d3                	jmp    800689 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	83 c0 04             	add    $0x4,%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006ca:	eb 23                	jmp    8006ef <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  8006cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d0:	0f 89 78 ff ff ff    	jns    80064e <vprintfmt+0x5a>
				width = 0;
  8006d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006dd:	e9 6c ff ff ff       	jmp    80064e <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  8006e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006e9:	e9 64 ff ff ff       	jmp    800652 <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f3:	0f 89 58 ff ff ff    	jns    800651 <vprintfmt+0x5d>
				width = precision, precision = -1;
  8006f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800706:	e9 46 ff ff ff       	jmp    800651 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80070b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  80070f:	e9 3e ff ff ff       	jmp    800652 <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	83 c0 04             	add    $0x4,%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	83 e8 04             	sub    $0x4,%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	8b 55 0c             	mov    0xc(%ebp),%edx
  800728:	89 54 24 04          	mov    %edx,0x4(%esp)
  80072c:	89 04 24             	mov    %eax,(%esp)
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	ff d0                	call   *%eax
			break;
  800734:	e9 98 04 00 00       	jmp    800bd1 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  800739:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  800740:	00 
  800741:	8b 45 10             	mov    0x10(%ebp),%eax
  800744:	89 44 24 04          	mov    %eax,0x4(%esp)
  800748:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80074b:	89 04 24             	mov    %eax,(%esp)
  80074e:	e8 d1 07 00 00       	call   800f24 <memmove>
            sel_c[3] = '\0';
  800753:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  800757:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  80075b:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80075f:	3c 2f                	cmp    $0x2f,%al
  800761:	7e 4c                	jle    8007af <vprintfmt+0x1bb>
  800763:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800767:	3c 39                	cmp    $0x39,%al
  800769:	7f 44                	jg     8007af <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  80076b:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80076f:	0f be d0             	movsbl %al,%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 02             	shl    $0x2,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800781:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  800785:	0f be c0             	movsbl %al,%eax
  800788:	01 c2                	add    %eax,%edx
  80078a:	89 d0                	mov    %edx,%eax
  80078c:	c1 e0 02             	shl    $0x2,%eax
  80078f:	01 d0                	add    %edx,%eax
  800791:	01 c0                	add    %eax,%eax
  800793:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800799:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  80079d:	0f be c0             	movsbl %al,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	83 e8 30             	sub    $0x30,%eax
  8007a5:	a3 04 50 80 00       	mov    %eax,0x805004
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007aa:	e9 22 04 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  8007af:	c7 44 24 04 ed 2a 80 	movl   $0x802aed,0x4(%esp)
  8007b6:	00 
  8007b7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007ba:	89 04 24             	mov    %eax,(%esp)
  8007bd:	e8 36 06 00 00       	call   800df8 <strcmp>
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	75 0f                	jne    8007d5 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  8007c6:	c7 05 04 50 80 00 07 	movl   $0x7,0x805004
  8007cd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007d0:	e9 fc 03 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  8007d5:	c7 44 24 04 f1 2a 80 	movl   $0x802af1,0x4(%esp)
  8007dc:	00 
  8007dd:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8007e0:	89 04 24             	mov    %eax,(%esp)
  8007e3:	e8 10 06 00 00       	call   800df8 <strcmp>
  8007e8:	85 c0                	test   %eax,%eax
  8007ea:	75 0f                	jne    8007fb <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  8007ec:	c7 05 04 50 80 00 01 	movl   $0x1,0x805004
  8007f3:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007f6:	e9 d6 03 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  8007fb:	c7 44 24 04 f5 2a 80 	movl   $0x802af5,0x4(%esp)
  800802:	00 
  800803:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800806:	89 04 24             	mov    %eax,(%esp)
  800809:	e8 ea 05 00 00       	call   800df8 <strcmp>
  80080e:	85 c0                	test   %eax,%eax
  800810:	75 0f                	jne    800821 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  800812:	c7 05 04 50 80 00 02 	movl   $0x2,0x805004
  800819:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80081c:	e9 b0 03 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  800821:	c7 44 24 04 f9 2a 80 	movl   $0x802af9,0x4(%esp)
  800828:	00 
  800829:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80082c:	89 04 24             	mov    %eax,(%esp)
  80082f:	e8 c4 05 00 00       	call   800df8 <strcmp>
  800834:	85 c0                	test   %eax,%eax
  800836:	75 0f                	jne    800847 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  800838:	c7 05 04 50 80 00 04 	movl   $0x4,0x805004
  80083f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800842:	e9 8a 03 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  800847:	c7 44 24 04 fd 2a 80 	movl   $0x802afd,0x4(%esp)
  80084e:	00 
  80084f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800852:	89 04 24             	mov    %eax,(%esp)
  800855:	e8 9e 05 00 00       	call   800df8 <strcmp>
  80085a:	85 c0                	test   %eax,%eax
  80085c:	75 0f                	jne    80086d <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  80085e:	c7 05 04 50 80 00 08 	movl   $0x8,0x805004
  800865:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800868:	e9 64 03 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  80086d:	c7 44 24 04 01 2b 80 	movl   $0x802b01,0x4(%esp)
  800874:	00 
  800875:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800878:	89 04 24             	mov    %eax,(%esp)
  80087b:	e8 78 05 00 00       	call   800df8 <strcmp>
  800880:	85 c0                	test   %eax,%eax
  800882:	75 0f                	jne    800893 <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  800884:	c7 05 04 50 80 00 0f 	movl   $0xf,0x805004
  80088b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80088e:	e9 3e 03 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  800893:	c7 44 24 04 05 2b 80 	movl   $0x802b05,0x4(%esp)
  80089a:	00 
  80089b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80089e:	89 04 24             	mov    %eax,(%esp)
  8008a1:	e8 52 05 00 00       	call   800df8 <strcmp>
  8008a6:	85 c0                	test   %eax,%eax
  8008a8:	75 0f                	jne    8008b9 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  8008aa:	c7 05 04 50 80 00 0c 	movl   $0xc,0x805004
  8008b1:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8008b4:	e9 18 03 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  8008b9:	c7 44 24 04 09 2b 80 	movl   $0x802b09,0x4(%esp)
  8008c0:	00 
  8008c1:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8008c4:	89 04 24             	mov    %eax,(%esp)
  8008c7:	e8 2c 05 00 00       	call   800df8 <strcmp>
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	75 0f                	jne    8008df <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  8008d0:	c7 05 04 50 80 00 06 	movl   $0x6,0x805004
  8008d7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8008da:	e9 f2 02 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  8008df:	c7 44 24 04 0d 2b 80 	movl   $0x802b0d,0x4(%esp)
  8008e6:	00 
  8008e7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8008ea:	89 04 24             	mov    %eax,(%esp)
  8008ed:	e8 06 05 00 00       	call   800df8 <strcmp>
  8008f2:	85 c0                	test   %eax,%eax
  8008f4:	75 0f                	jne    800905 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  8008f6:	c7 05 04 50 80 00 0b 	movl   $0xb,0x805004
  8008fd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800900:	e9 cc 02 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  800905:	c7 05 04 50 80 00 07 	movl   $0x7,0x805004
  80090c:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80090f:	e9 bd 02 00 00       	jmp    800bd1 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	83 c0 04             	add    $0x4,%eax
  80091a:	89 45 14             	mov    %eax,0x14(%ebp)
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	83 e8 04             	sub    $0x4,%eax
  800923:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800925:	85 db                	test   %ebx,%ebx
  800927:	79 02                	jns    80092b <vprintfmt+0x337>
				err = -err;
  800929:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80092b:	83 fb 0e             	cmp    $0xe,%ebx
  80092e:	7f 0b                	jg     80093b <vprintfmt+0x347>
  800930:	8b 34 9d a0 2a 80 00 	mov    0x802aa0(,%ebx,4),%esi
  800937:	85 f6                	test   %esi,%esi
  800939:	75 23                	jne    80095e <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  80093b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80093f:	c7 44 24 08 11 2b 80 	movl   $0x802b11,0x8(%esp)
  800946:	00 
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 04 24             	mov    %eax,(%esp)
  800954:	e8 86 02 00 00       	call   800bdf <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800959:	e9 73 02 00 00       	jmp    800bd1 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80095e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800962:	c7 44 24 08 1a 2b 80 	movl   $0x802b1a,0x8(%esp)
  800969:	00 
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	89 04 24             	mov    %eax,(%esp)
  800977:	e8 63 02 00 00       	call   800bdf <printfmt>
			break;
  80097c:	e9 50 02 00 00       	jmp    800bd1 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	83 c0 04             	add    $0x4,%eax
  800987:	89 45 14             	mov    %eax,0x14(%ebp)
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	83 e8 04             	sub    $0x4,%eax
  800990:	8b 30                	mov    (%eax),%esi
  800992:	85 f6                	test   %esi,%esi
  800994:	75 05                	jne    80099b <vprintfmt+0x3a7>
				p = "(null)";
  800996:	be 1d 2b 80 00       	mov    $0x802b1d,%esi
			if (width > 0 && padc != '-')
  80099b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099f:	7e 73                	jle    800a14 <vprintfmt+0x420>
  8009a1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a5:	74 6d                	je     800a14 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ae:	89 34 24             	mov    %esi,(%esp)
  8009b1:	e8 4c 03 00 00       	call   800d02 <strnlen>
  8009b6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009b9:	eb 17                	jmp    8009d2 <vprintfmt+0x3de>
					putch(padc, putdat);
  8009bb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009c6:	89 04 24             	mov    %eax,(%esp)
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ce:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8009d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d6:	7f e3                	jg     8009bb <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d8:	eb 3a                	jmp    800a14 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  8009da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009de:	74 1f                	je     8009ff <vprintfmt+0x40b>
  8009e0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e3:	7e 05                	jle    8009ea <vprintfmt+0x3f6>
  8009e5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e8:	7e 15                	jle    8009ff <vprintfmt+0x40b>
					putch('?', putdat);
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f1:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a06:	89 1c 24             	mov    %ebx,(%esp)
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a12:	eb 01                	jmp    800a15 <vprintfmt+0x421>
  800a14:	90                   	nop
  800a15:	0f b6 06             	movzbl (%esi),%eax
  800a18:	0f be d8             	movsbl %al,%ebx
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	0f 95 c0             	setne  %al
  800a20:	83 c6 01             	add    $0x1,%esi
  800a23:	84 c0                	test   %al,%al
  800a25:	74 29                	je     800a50 <vprintfmt+0x45c>
  800a27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2b:	78 ad                	js     8009da <vprintfmt+0x3e6>
  800a2d:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800a31:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a35:	79 a3                	jns    8009da <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a37:	eb 17                	jmp    800a50 <vprintfmt+0x45c>
				putch(' ', putdat);
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a40:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a54:	7f e3                	jg     800a39 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  800a56:	e9 76 01 00 00       	jmp    800bd1 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a62:	8d 45 14             	lea    0x14(%ebp),%eax
  800a65:	89 04 24             	mov    %eax,(%esp)
  800a68:	e8 20 fb ff ff       	call   80058d <getint>
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a79:	85 d2                	test   %edx,%edx
  800a7b:	79 26                	jns    800aa3 <vprintfmt+0x4af>
				putch('-', putdat);
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a84:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
				num = -(long long) num;
  800a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a96:	f7 d8                	neg    %eax
  800a98:	83 d2 00             	adc    $0x0,%edx
  800a9b:	f7 da                	neg    %edx
  800a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aaa:	e9 ae 00 00 00       	jmp    800b5d <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab9:	89 04 24             	mov    %eax,(%esp)
  800abc:	e8 65 fa ff ff       	call   800526 <getuint>
  800ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ac7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ace:	e9 8a 00 00 00       	jmp    800b5d <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  800ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ada:	8d 45 14             	lea    0x14(%ebp),%eax
  800add:	89 04 24             	mov    %eax,(%esp)
  800ae0:	e8 41 fa ff ff       	call   800526 <getuint>
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  800aeb:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  800af2:	eb 69                	jmp    800b5d <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800afb:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
			putch('x', putdat);
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 14             	mov    %eax,0x14(%ebp)
  800b23:	8b 45 14             	mov    0x14(%ebp),%eax
  800b26:	83 e8 04             	sub    $0x4,%eax
  800b29:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b35:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3c:	eb 1f                	jmp    800b5d <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b45:	8d 45 14             	lea    0x14(%ebp),%eax
  800b48:	89 04 24             	mov    %eax,(%esp)
  800b4b:	e8 d6 f9 ff ff       	call   800526 <getuint>
  800b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b56:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b64:	89 54 24 18          	mov    %edx,0x18(%esp)
  800b68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b6b:	89 54 24 14          	mov    %edx,0x14(%esp)
  800b6f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b79:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b7d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 04 24             	mov    %eax,(%esp)
  800b8e:	e8 b5 f8 ff ff       	call   800448 <printnum>
			break;
  800b93:	eb 3c                	jmp    800bd1 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b9c:	89 1c 24             	mov    %ebx,(%esp)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	ff d0                	call   *%eax
			break;
  800ba4:	eb 2b                	jmp    800bd1 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bad:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bbd:	eb 04                	jmp    800bc3 <vprintfmt+0x5cf>
  800bbf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	83 e8 01             	sub    $0x1,%eax
  800bc9:	0f b6 00             	movzbl (%eax),%eax
  800bcc:	3c 25                	cmp    $0x25,%al
  800bce:	75 ef                	jne    800bbf <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800bd0:	90                   	nop
		}
	}
  800bd1:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd2:	e9 3e fa ff ff       	jmp    800615 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800bd7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bd8:	83 c4 50             	add    $0x50,%esp
  800bdb:	5b                   	pop    %ebx
  800bdc:	5e                   	pop    %esi
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800be5:	8d 45 10             	lea    0x10(%ebp),%eax
  800be8:	83 c0 04             	add    $0x4,%eax
  800beb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bee:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bf8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	89 04 24             	mov    %eax,(%esp)
  800c09:	e8 e6 f9 ff ff       	call   8005f4 <vprintfmt>
	va_end(ap);
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 40 08             	mov    0x8(%eax),%eax
  800c19:	8d 50 01             	lea    0x1(%eax),%edx
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	8b 10                	mov    (%eax),%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	8b 40 04             	mov    0x4(%eax),%eax
  800c2d:	39 c2                	cmp    %eax,%edx
  800c2f:	73 12                	jae    800c43 <sprintputch+0x33>
		*b->buf++ = ch;
  800c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c34:	8b 00                	mov    (%eax),%eax
  800c36:	8b 55 08             	mov    0x8(%ebp),%edx
  800c39:	88 10                	mov    %dl,(%eax)
  800c3b:	8d 50 01             	lea    0x1(%eax),%edx
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	89 10                	mov    %edx,(%eax)
}
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c54:	83 e8 01             	sub    $0x1,%eax
  800c57:	03 45 08             	add    0x8(%ebp),%eax
  800c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c68:	74 06                	je     800c70 <vsnprintf+0x2b>
  800c6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6e:	7f 07                	jg     800c77 <vsnprintf+0x32>
		return -E_INVAL;
  800c70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c75:	eb 2a                	jmp    800ca1 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c85:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c8c:	c7 04 24 10 0c 80 00 	movl   $0x800c10,(%esp)
  800c93:	e8 5c f9 ff ff       	call   8005f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca9:	8d 45 10             	lea    0x10(%ebp),%eax
  800cac:	83 c0 04             	add    $0x4,%eax
  800caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800cbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	89 04 24             	mov    %eax,(%esp)
  800ccd:	e8 73 ff ff ff       	call   800c45 <vsnprintf>
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    
	...

00800cdc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce9:	eb 08                	jmp    800cf3 <strlen+0x17>
		n++;
  800ceb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	0f b6 00             	movzbl (%eax),%eax
  800cf9:	84 c0                	test   %al,%al
  800cfb:	75 ee                	jne    800ceb <strlen+0xf>
		n++;
	return n;
  800cfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d0f:	eb 0c                	jmp    800d1d <strnlen+0x1b>
		n++;
  800d11:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d19:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800d1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d21:	74 0a                	je     800d2d <strnlen+0x2b>
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	0f b6 00             	movzbl (%eax),%eax
  800d29:	84 c0                	test   %al,%al
  800d2b:	75 e4                	jne    800d11 <strnlen+0xf>
		n++;
	return n;
  800d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d3e:	90                   	nop
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	0f b6 10             	movzbl (%eax),%edx
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	88 10                	mov    %dl,(%eax)
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	0f b6 00             	movzbl (%eax),%eax
  800d50:	84 c0                	test   %al,%al
  800d52:	0f 95 c0             	setne  %al
  800d55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d59:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800d5d:	84 c0                	test   %al,%al
  800d5f:	75 de                	jne    800d3f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d79:	eb 21                	jmp    800d9c <strncpy+0x36>
		*dst++ = *src;
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	0f b6 10             	movzbl (%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	88 10                	mov    %dl,(%eax)
  800d86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	0f b6 00             	movzbl (%eax),%eax
  800d90:	84 c0                	test   %al,%al
  800d92:	74 04                	je     800d98 <strncpy+0x32>
			src++;
  800d94:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d98:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da2:	72 d7                	jb     800d7b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db9:	74 2f                	je     800dea <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800dbb:	eb 13                	jmp    800dd0 <strlcpy+0x27>
			*dst++ = *src++;
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	0f b6 10             	movzbl (%eax),%edx
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	88 10                	mov    %dl,(%eax)
  800dc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dcc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800dd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd8:	74 0a                	je     800de4 <strlcpy+0x3b>
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	0f b6 00             	movzbl (%eax),%eax
  800de0:	84 c0                	test   %al,%al
  800de2:	75 d9                	jne    800dbd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df0:	89 d1                	mov    %edx,%ecx
  800df2:	29 c1                	sub    %eax,%ecx
  800df4:	89 c8                	mov    %ecx,%eax
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dfb:	eb 08                	jmp    800e05 <strcmp+0xd>
		p++, q++;
  800dfd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e01:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	0f b6 00             	movzbl (%eax),%eax
  800e0b:	84 c0                	test   %al,%al
  800e0d:	74 10                	je     800e1f <strcmp+0x27>
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	0f b6 10             	movzbl (%eax),%edx
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	0f b6 00             	movzbl (%eax),%eax
  800e1b:	38 c2                	cmp    %al,%dl
  800e1d:	74 de                	je     800dfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	0f b6 00             	movzbl (%eax),%eax
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	0f b6 00             	movzbl (%eax),%eax
  800e2e:	0f b6 c0             	movzbl %al,%eax
  800e31:	89 d1                	mov    %edx,%ecx
  800e33:	29 c1                	sub    %eax,%ecx
  800e35:	89 c8                	mov    %ecx,%eax
}
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e3c:	eb 0c                	jmp    800e4a <strncmp+0x11>
		n--, p++, q++;
  800e3e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e42:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e46:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4e:	74 1a                	je     800e6a <strncmp+0x31>
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	0f b6 00             	movzbl (%eax),%eax
  800e56:	84 c0                	test   %al,%al
  800e58:	74 10                	je     800e6a <strncmp+0x31>
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	0f b6 10             	movzbl (%eax),%edx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	0f b6 00             	movzbl (%eax),%eax
  800e66:	38 c2                	cmp    %al,%dl
  800e68:	74 d4                	je     800e3e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6e:	75 07                	jne    800e77 <strncmp+0x3e>
		return 0;
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
  800e75:	eb 18                	jmp    800e8f <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	0f b6 00             	movzbl (%eax),%eax
  800e7d:	0f b6 d0             	movzbl %al,%edx
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	0f b6 00             	movzbl (%eax),%eax
  800e86:	0f b6 c0             	movzbl %al,%eax
  800e89:	89 d1                	mov    %edx,%ecx
  800e8b:	29 c1                	sub    %eax,%ecx
  800e8d:	89 c8                	mov    %ecx,%eax
}
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    

00800e91 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	83 ec 04             	sub    $0x4,%esp
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e9d:	eb 14                	jmp    800eb3 <strchr+0x22>
		if (*s == c)
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	0f b6 00             	movzbl (%eax),%eax
  800ea5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ea8:	75 05                	jne    800eaf <strchr+0x1e>
			return (char *) s;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	eb 13                	jmp    800ec2 <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eaf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	0f b6 00             	movzbl (%eax),%eax
  800eb9:	84 c0                	test   %al,%al
  800ebb:	75 e2                	jne    800e9f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed0:	eb 0f                	jmp    800ee1 <strfind+0x1d>
		if (*s == c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	0f b6 00             	movzbl (%eax),%eax
  800ed8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edb:	74 10                	je     800eed <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	0f b6 00             	movzbl (%eax),%eax
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 e7                	jne    800ed2 <strfind+0xe>
  800eeb:	eb 01                	jmp    800eee <strfind+0x2a>
		if (*s == c)
			break;
  800eed:	90                   	nop
	return (char *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memset>:


void *
memset(void *v, int c, size_t n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f05:	eb 0e                	jmp    800f15 <memset+0x22>
		*p++ = c;
  800f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0a:	89 c2                	mov    %eax,%edx
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	88 10                	mov    %dl,(%eax)
  800f11:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f15:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800f19:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1d:	79 e8                	jns    800f07 <memset+0x14>
		*p++ = c;

	return v;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f3c:	73 54                	jae    800f92 <memmove+0x6e>
  800f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f44:	01 d0                	add    %edx,%eax
  800f46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f49:	76 47                	jbe    800f92 <memmove+0x6e>
		s += n;
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f51:	8b 45 10             	mov    0x10(%ebp),%eax
  800f54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f57:	eb 13                	jmp    800f6c <memmove+0x48>
			*--d = *--s;
  800f59:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800f5d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f64:	0f b6 10             	movzbl (%eax),%edx
  800f67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f70:	0f 95 c0             	setne  %al
  800f73:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800f77:	84 c0                	test   %al,%al
  800f79:	75 de                	jne    800f59 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f7b:	eb 25                	jmp    800fa2 <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f80:	0f b6 10             	movzbl (%eax),%edx
  800f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f86:	88 10                	mov    %dl,(%eax)
  800f88:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800f8c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800f90:	eb 01                	jmp    800f93 <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f92:	90                   	nop
  800f93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f97:	0f 95 c0             	setne  %al
  800f9a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800f9e:	84 c0                	test   %al,%al
  800fa0:	75 db                	jne    800f7d <memmove+0x59>
			*d++ = *s++;

	return dst;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    

00800fa7 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	89 04 24             	mov    %eax,(%esp)
  800fc1:	e8 5e ff ff ff       	call   800f24 <memmove>
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fda:	eb 32                	jmp    80100e <memcmp+0x46>
		if (*s1 != *s2)
  800fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdf:	0f b6 10             	movzbl (%eax),%edx
  800fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe5:	0f b6 00             	movzbl (%eax),%eax
  800fe8:	38 c2                	cmp    %al,%dl
  800fea:	74 1a                	je     801006 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800fec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fef:	0f b6 00             	movzbl (%eax),%eax
  800ff2:	0f b6 d0             	movzbl %al,%edx
  800ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff8:	0f b6 00             	movzbl (%eax),%eax
  800ffb:	0f b6 c0             	movzbl %al,%eax
  800ffe:	89 d1                	mov    %edx,%ecx
  801000:	29 c1                	sub    %eax,%ecx
  801002:	89 c8                	mov    %ecx,%eax
  801004:	eb 1c                	jmp    801022 <memcmp+0x5a>
		s1++, s2++;
  801006:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  80100a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80100e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801012:	0f 95 c0             	setne  %al
  801015:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  801019:	84 c0                	test   %al,%al
  80101b:	75 bf                	jne    800fdc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801022:	c9                   	leave  
  801023:	c3                   	ret    

00801024 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80102a:	8b 45 10             	mov    0x10(%ebp),%eax
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801035:	eb 11                	jmp    801048 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	0f b6 10             	movzbl (%eax),%edx
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	38 c2                	cmp    %al,%dl
  801042:	74 0e                	je     801052 <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801044:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80104e:	72 e7                	jb     801037 <memfind+0x13>
  801050:	eb 01                	jmp    801053 <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801052:	90                   	nop
	return (void *) s;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80105e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801065:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80106c:	eb 04                	jmp    801072 <strtol+0x1a>
		s++;
  80106e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	0f b6 00             	movzbl (%eax),%eax
  801078:	3c 20                	cmp    $0x20,%al
  80107a:	74 f2                	je     80106e <strtol+0x16>
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	0f b6 00             	movzbl (%eax),%eax
  801082:	3c 09                	cmp    $0x9,%al
  801084:	74 e8                	je     80106e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	0f b6 00             	movzbl (%eax),%eax
  80108c:	3c 2b                	cmp    $0x2b,%al
  80108e:	75 06                	jne    801096 <strtol+0x3e>
		s++;
  801090:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801094:	eb 15                	jmp    8010ab <strtol+0x53>
	else if (*s == '-')
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	0f b6 00             	movzbl (%eax),%eax
  80109c:	3c 2d                	cmp    $0x2d,%al
  80109e:	75 0b                	jne    8010ab <strtol+0x53>
		s++, neg = 1;
  8010a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8010a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010af:	74 06                	je     8010b7 <strtol+0x5f>
  8010b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010b5:	75 24                	jne    8010db <strtol+0x83>
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	0f b6 00             	movzbl (%eax),%eax
  8010bd:	3c 30                	cmp    $0x30,%al
  8010bf:	75 1a                	jne    8010db <strtol+0x83>
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	83 c0 01             	add    $0x1,%eax
  8010c7:	0f b6 00             	movzbl (%eax),%eax
  8010ca:	3c 78                	cmp    $0x78,%al
  8010cc:	75 0d                	jne    8010db <strtol+0x83>
		s += 2, base = 16;
  8010ce:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010d9:	eb 2a                	jmp    801105 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  8010db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010df:	75 17                	jne    8010f8 <strtol+0xa0>
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	0f b6 00             	movzbl (%eax),%eax
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 0d                	jne    8010f8 <strtol+0xa0>
		s++, base = 8;
  8010eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xad>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xad>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	0f b6 00             	movzbl (%eax),%eax
  80110b:	3c 2f                	cmp    $0x2f,%al
  80110d:	7e 1b                	jle    80112a <strtol+0xd2>
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	0f b6 00             	movzbl (%eax),%eax
  801115:	3c 39                	cmp    $0x39,%al
  801117:	7f 11                	jg     80112a <strtol+0xd2>
			dig = *s - '0';
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	0f b6 00             	movzbl (%eax),%eax
  80111f:	0f be c0             	movsbl %al,%eax
  801122:	83 e8 30             	sub    $0x30,%eax
  801125:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801128:	eb 48                	jmp    801172 <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	0f b6 00             	movzbl (%eax),%eax
  801130:	3c 60                	cmp    $0x60,%al
  801132:	7e 1b                	jle    80114f <strtol+0xf7>
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	0f b6 00             	movzbl (%eax),%eax
  80113a:	3c 7a                	cmp    $0x7a,%al
  80113c:	7f 11                	jg     80114f <strtol+0xf7>
			dig = *s - 'a' + 10;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	0f b6 00             	movzbl (%eax),%eax
  801144:	0f be c0             	movsbl %al,%eax
  801147:	83 e8 57             	sub    $0x57,%eax
  80114a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114d:	eb 23                	jmp    801172 <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	0f b6 00             	movzbl (%eax),%eax
  801155:	3c 40                	cmp    $0x40,%al
  801157:	7e 38                	jle    801191 <strtol+0x139>
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	0f b6 00             	movzbl (%eax),%eax
  80115f:	3c 5a                	cmp    $0x5a,%al
  801161:	7f 2e                	jg     801191 <strtol+0x139>
			dig = *s - 'A' + 10;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	0f b6 00             	movzbl (%eax),%eax
  801169:	0f be c0             	movsbl %al,%eax
  80116c:	83 e8 37             	sub    $0x37,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801175:	3b 45 10             	cmp    0x10(%ebp),%eax
  801178:	7d 16                	jge    801190 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  80117a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80117e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801181:	0f af 45 10          	imul   0x10(%ebp),%eax
  801185:	03 45 f4             	add    -0xc(%ebp),%eax
  801188:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80118b:	e9 75 ff ff ff       	jmp    801105 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801190:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801191:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801195:	74 08                	je     80119f <strtol+0x147>
		*endptr = (char *) s;
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8b 55 08             	mov    0x8(%ebp),%edx
  80119d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80119f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a3:	74 07                	je     8011ac <strtol+0x154>
  8011a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a8:	f7 d8                	neg    %eax
  8011aa:	eb 03                	jmp    8011af <strtol+0x157>
  8011ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    
  8011b1:	00 00                	add    %al,(%eax)
	...

008011b4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	57                   	push   %edi
  8011b8:	56                   	push   %esi
  8011b9:	53                   	push   %ebx
  8011ba:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8011c3:	8b 55 10             	mov    0x10(%ebp),%edx
  8011c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8011c9:	8b 5d 18             	mov    0x18(%ebp),%ebx
  8011cc:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  8011cf:	8b 75 20             	mov    0x20(%ebp),%esi
  8011d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011d5:	cd 30                	int    $0x30
  8011d7:	89 c3                	mov    %eax,%ebx
  8011d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	74 30                	je     801212 <syscall+0x5e>
  8011e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e6:	7e 2a                	jle    801212 <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011f6:	c7 44 24 08 7c 2c 80 	movl   $0x802c7c,0x8(%esp)
  8011fd:	00 
  8011fe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801205:	00 
  801206:	c7 04 24 99 2c 80 00 	movl   $0x802c99,(%esp)
  80120d:	e8 da f0 ff ff       	call   8002ec <_panic>

	return ret;
  801212:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801215:	83 c4 4c             	add    $0x4c,%esp
  801218:	5b                   	pop    %ebx
  801219:	5e                   	pop    %esi
  80121a:	5f                   	pop    %edi
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80122d:	00 
  80122e:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801235:	00 
  801236:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80123d:	00 
  80123e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801241:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801245:	89 44 24 08          	mov    %eax,0x8(%esp)
  801249:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801250:	00 
  801251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801258:	e8 57 ff ff ff       	call   8011b4 <syscall>
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <sys_cgetc>:

int
sys_cgetc(void)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801265:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80126c:	00 
  80126d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801274:	00 
  801275:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80127c:	00 
  80127d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801284:	00 
  801285:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80128c:	00 
  80128d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801294:	00 
  801295:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80129c:	e8 13 ff ff ff       	call   8011b4 <syscall>
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012bb:	00 
  8012bc:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012c3:	00 
  8012c4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8012cb:	00 
  8012cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012d7:	00 
  8012d8:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8012df:	e8 d0 fe ff ff       	call   8011b4 <syscall>
}
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8012ec:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012f3:	00 
  8012f4:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012fb:	00 
  8012fc:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801303:	00 
  801304:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80130b:	00 
  80130c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801313:	00 
  801314:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80131b:	00 
  80131c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801323:	e8 8c fe ff ff       	call   8011b4 <syscall>
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <sys_yield>:

void
sys_yield(void)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801330:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801337:	00 
  801338:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80133f:	00 
  801340:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801347:	00 
  801348:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80134f:	00 
  801350:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801357:	00 
  801358:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80135f:	00 
  801360:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  801367:	e8 48 fe ff ff       	call   8011b4 <syscall>
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801374:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801384:	00 
  801385:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80138c:	00 
  80138d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801391:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801395:	89 44 24 08          	mov    %eax,0x8(%esp)
  801399:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013a0:	00 
  8013a1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8013a8:	e8 07 fe ff ff       	call   8011b4 <syscall>
}
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	56                   	push   %esi
  8013b3:	53                   	push   %ebx
  8013b4:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8013b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8013ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	89 74 24 18          	mov    %esi,0x18(%esp)
  8013ca:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8013ce:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8013d2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013e1:	00 
  8013e2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8013e9:	e8 c6 fd ff ff       	call   8011b4 <syscall>
}
  8013ee:	83 c4 20             	add    $0x20,%esp
  8013f1:	5b                   	pop    %ebx
  8013f2:	5e                   	pop    %esi
  8013f3:	5d                   	pop    %ebp
  8013f4:	c3                   	ret    

008013f5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8013fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801408:	00 
  801409:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801410:	00 
  801411:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801418:	00 
  801419:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80141d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801421:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801428:	00 
  801429:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  801430:	e8 7f fd ff ff       	call   8011b4 <syscall>
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  80143d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80144a:	00 
  80144b:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801452:	00 
  801453:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80145a:	00 
  80145b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80145f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801463:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80146a:	00 
  80146b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  801472:	e8 3d fd ff ff       	call   8011b4 <syscall>
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80147f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80148c:	00 
  80148d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801494:	00 
  801495:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80149c:	00 
  80149d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014ac:	00 
  8014ad:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8014b4:	e8 fb fc ff ff       	call   8011b4 <syscall>
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8014c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8014ce:	00 
  8014cf:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8014d6:	00 
  8014d7:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8014de:	00 
  8014df:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014ee:	00 
  8014ef:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  8014f6:	e8 b9 fc ff ff       	call   8011b4 <syscall>
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  801503:	8b 55 0c             	mov    0xc(%ebp),%edx
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801510:	00 
  801511:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801518:	00 
  801519:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801520:	00 
  801521:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801525:	89 44 24 08          	mov    %eax,0x8(%esp)
  801529:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801530:	00 
  801531:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801538:	e8 77 fc ff ff       	call   8011b4 <syscall>
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801545:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801548:	8b 55 10             	mov    0x10(%ebp),%edx
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801555:	00 
  801556:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  80155a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80155e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801561:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801565:	89 44 24 08          	mov    %eax,0x8(%esp)
  801569:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801570:	00 
  801571:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  801578:	e8 37 fc ff ff       	call   8011b4 <syscall>
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80158f:	00 
  801590:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801597:	00 
  801598:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80159f:	00 
  8015a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8015a7:	00 
  8015a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015b3:	00 
  8015b4:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  8015bb:	e8 f4 fb ff ff       	call   8011b4 <syscall>
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    
	...

008015c4 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	89 04 24             	mov    %eax,(%esp)
  8015d0:	e8 0a 00 00 00       	call   8015df <fd2num>
  8015d5:	05 40 03 00 00       	add    $0x340,%eax
  8015da:	c1 e0 16             	shl    $0x16,%eax
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <fd2num>:

int
fd2num(struct Fd *fd)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	05 00 00 40 30       	add    $0x30400000,%eax
  8015ea:	c1 e8 0c             	shr    $0xc,%eax
}
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    

008015ef <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  8015f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015fc:	eb 49                	jmp    801647 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801606:	c1 e0 0c             	shl    $0xc,%eax
  801609:	89 c2                	mov    %eax,%edx
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	8b 00                	mov    (%eax),%eax
  801615:	c1 e8 16             	shr    $0x16,%eax
  801618:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80161f:	83 e0 01             	and    $0x1,%eax
  801622:	85 c0                	test   %eax,%eax
  801624:	74 16                	je     80163c <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8b 00                	mov    (%eax),%eax
  80162b:	c1 e8 0c             	shr    $0xc,%eax
  80162e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801635:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801638:	85 c0                	test   %eax,%eax
  80163a:	75 07                	jne    801643 <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  80163c:	b8 00 00 00 00       	mov    $0x0,%eax
  801641:	eb 18                	jmp    80165b <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  801643:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801647:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  80164b:	7e b1                	jle    8015fe <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  801656:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  801663:	c7 44 24 08 a8 2c 80 	movl   $0x802ca8,0x8(%esp)
  80166a:	00 
  80166b:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801672:	00 
  801673:	c7 04 24 c2 2c 80 00 	movl   $0x802cc2,(%esp)
  80167a:	e8 6d ec ff ff       	call   8002ec <_panic>

0080167f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	89 04 24             	mov    %eax,(%esp)
  80168b:	e8 4f ff ff ff       	call   8015df <fd2num>
  801690:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801693:	89 54 24 04          	mov    %edx,0x4(%esp)
  801697:	89 04 24             	mov    %eax,(%esp)
  80169a:	e8 be ff ff ff       	call   80165d <fd_lookup>
  80169f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a6:	78 08                	js     8016b0 <fd_close+0x31>
	    || fd != fd2)
  8016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ab:	39 45 08             	cmp    %eax,0x8(%ebp)
  8016ae:	74 12                	je     8016c2 <fd_close+0x43>
		return (must_exist ? r : 0);
  8016b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b4:	74 05                	je     8016bb <fd_close+0x3c>
  8016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b9:	eb 05                	jmp    8016c0 <fd_close+0x41>
  8016bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c0:	eb 44                	jmp    801706 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8b 00                	mov    (%eax),%eax
  8016c7:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8016ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016ce:	89 04 24             	mov    %eax,(%esp)
  8016d1:	e8 32 00 00 00       	call   801708 <dev_lookup>
  8016d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016dd:	78 11                	js     8016f0 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  8016df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e2:	8b 50 10             	mov    0x10(%eax),%edx
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	89 04 24             	mov    %eax,(%esp)
  8016eb:	ff d2                	call   *%edx
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fe:	e8 f2 fc ff ff       	call   8013f5 <sys_page_unmap>
	return r;
  801703:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  80170e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801715:	eb 2b                	jmp    801742 <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  801717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171a:	8b 04 85 08 50 80 00 	mov    0x805008(,%eax,4),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	3b 45 08             	cmp    0x8(%ebp),%eax
  801726:	75 16                	jne    80173e <dev_lookup+0x36>
			*dev = devtab[i];
  801728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172b:	8b 14 85 08 50 80 00 	mov    0x805008(,%eax,4),%edx
  801732:	8b 45 0c             	mov    0xc(%ebp),%eax
  801735:	89 10                	mov    %edx,(%eax)
			return 0;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	eb 3f                	jmp    80177d <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80173e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	8b 04 85 08 50 80 00 	mov    0x805008(,%eax,4),%eax
  80174c:	85 c0                	test   %eax,%eax
  80174e:	75 c7                	jne    801717 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801750:	a1 40 50 80 00       	mov    0x805040,%eax
  801755:	8b 40 4c             	mov    0x4c(%eax),%eax
  801758:	8b 55 08             	mov    0x8(%ebp),%edx
  80175b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80175f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801763:	c7 04 24 cc 2c 80 00 	movl   $0x802ccc,(%esp)
  80176a:	e8 b1 ec ff ff       	call   800420 <cprintf>
	*dev = 0;
  80176f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801778:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <close>:

int
close(int fdnum)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801785:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	89 04 24             	mov    %eax,(%esp)
  801792:	e8 c6 fe ff ff       	call   80165d <fd_lookup>
  801797:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80179e:	79 05                	jns    8017a5 <close+0x26>
		return r;
  8017a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a3:	eb 13                	jmp    8017b8 <close+0x39>
	else
		return fd_close(fd, 1);
  8017a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017af:	00 
  8017b0:	89 04 24             	mov    %eax,(%esp)
  8017b3:	e8 c7 fe ff ff       	call   80167f <fd_close>
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <close_all>:

void
close_all(void)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017c7:	eb 0f                	jmp    8017d8 <close_all+0x1e>
		close(i);
  8017c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cc:	89 04 24             	mov    %eax,(%esp)
  8017cf:	e8 ab ff ff ff       	call   80177f <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8017d8:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  8017dc:	7e eb                	jle    8017c9 <close_all+0xf>
		close(i);
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017e6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8017e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	89 04 24             	mov    %eax,(%esp)
  8017f3:	e8 65 fe ff ff       	call   80165d <fd_lookup>
  8017f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ff:	79 08                	jns    801809 <dup+0x29>
		return r;
  801801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801804:	e9 54 01 00 00       	jmp    80195d <dup+0x17d>
	close(newfdnum);
  801809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180c:	89 04 24             	mov    %eax,(%esp)
  80180f:	e8 6b ff ff ff       	call   80177f <close>

	newfd = INDEX2FD(newfdnum);
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  80181c:	c1 e0 0c             	shl    $0xc,%eax
  80181f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  801822:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801825:	89 04 24             	mov    %eax,(%esp)
  801828:	e8 97 fd ff ff       	call   8015c4 <fd2data>
  80182d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801833:	89 04 24             	mov    %eax,(%esp)
  801836:	e8 89 fd ff ff       	call   8015c4 <fd2data>
  80183b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80183e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801841:	c1 e8 0c             	shr    $0xc,%eax
  801844:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80184b:	89 c2                	mov    %eax,%edx
  80184d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801853:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801856:	89 54 24 10          	mov    %edx,0x10(%esp)
  80185a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80185d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801861:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801868:	00 
  801869:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801874:	e8 36 fb ff ff       	call   8013af <sys_page_map>
  801879:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80187c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801880:	0f 88 8e 00 00 00    	js     801914 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  801886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801889:	c1 e8 16             	shr    $0x16,%eax
  80188c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801893:	85 c0                	test   %eax,%eax
  801895:	74 78                	je     80190f <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801897:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80189e:	eb 66                	jmp    801906 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a3:	03 45 e8             	add    -0x18(%ebp),%eax
  8018a6:	c1 e8 0c             	shr    $0xc,%eax
  8018a9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  8018b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b6:	83 e0 01             	and    $0x1,%eax
  8018b9:	84 c0                	test   %al,%al
  8018bb:	74 42                	je     8018ff <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  8018bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c0:	89 c1                	mov    %eax,%ecx
  8018c2:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8018c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cb:	89 c2                	mov    %eax,%edx
  8018cd:	03 55 e4             	add    -0x1c(%ebp),%edx
  8018d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d3:	03 45 e8             	add    -0x18(%ebp),%eax
  8018d6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8018da:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8018de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018e5:	00 
  8018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f1:	e8 b9 fa ff ff       	call   8013af <sys_page_map>
  8018f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018fd:	78 18                	js     801917 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8018ff:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801906:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  80190d:	7e 91                	jle    8018a0 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  80190f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801912:	eb 49                	jmp    80195d <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  801914:	90                   	nop
  801915:	eb 01                	jmp    801918 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  801917:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801926:	e8 ca fa ff ff       	call   8013f5 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80192b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801932:	eb 1d                	jmp    801951 <dup+0x171>
		sys_page_unmap(0, nva + i);
  801934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801937:	03 45 e4             	add    -0x1c(%ebp),%eax
  80193a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801945:	e8 ab fa ff ff       	call   8013f5 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80194a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801951:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801958:	7e da                	jle    801934 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  80195a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801965:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	e8 e6 fc ff ff       	call   80165d <fd_lookup>
  801977:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80197a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80197e:	78 1d                	js     80199d <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801980:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801983:	8b 00                	mov    (%eax),%eax
  801985:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801988:	89 54 24 04          	mov    %edx,0x4(%esp)
  80198c:	89 04 24             	mov    %eax,(%esp)
  80198f:	e8 74 fd ff ff       	call   801708 <dev_lookup>
  801994:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801997:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80199b:	79 05                	jns    8019a2 <read+0x43>
		return r;
  80199d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a0:	eb 75                	jmp    801a17 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a5:	8b 40 08             	mov    0x8(%eax),%eax
  8019a8:	83 e0 03             	and    $0x3,%eax
  8019ab:	83 f8 01             	cmp    $0x1,%eax
  8019ae:	75 26                	jne    8019d6 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8019b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8019b5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c3:	c7 04 24 eb 2c 80 00 	movl   $0x802ceb,(%esp)
  8019ca:	e8 51 ea ff ff       	call   800420 <cprintf>
		return -E_INVAL;
  8019cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d4:	eb 41                	jmp    801a17 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8019d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d9:	8b 48 08             	mov    0x8(%eax),%ecx
  8019dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019df:	8b 50 04             	mov    0x4(%eax),%edx
  8019e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019e9:	8b 55 10             	mov    0x10(%ebp),%edx
  8019ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019f7:	89 04 24             	mov    %eax,(%esp)
  8019fa:	ff d1                	call   *%ecx
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  8019ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a03:	78 0f                	js     801a14 <read+0xb5>
		fd->fd_offset += r;
  801a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a0b:	8b 52 04             	mov    0x4(%edx),%edx
  801a0e:	03 55 f4             	add    -0xc(%ebp),%edx
  801a11:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801a26:	eb 3b                	jmp    801a63 <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2b:	8b 55 10             	mov    0x10(%ebp),%edx
  801a2e:	29 c2                	sub    %eax,%edx
  801a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a33:	03 45 0c             	add    0xc(%ebp),%eax
  801a36:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	89 04 24             	mov    %eax,(%esp)
  801a44:	e8 16 ff ff ff       	call   80195f <read>
  801a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  801a4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a50:	79 05                	jns    801a57 <readn+0x3e>
			return m;
  801a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a55:	eb 1a                	jmp    801a71 <readn+0x58>
		if (m == 0)
  801a57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a5b:	74 10                	je     801a6d <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a60:	01 45 f4             	add    %eax,-0xc(%ebp)
  801a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a66:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a69:	72 bd                	jb     801a28 <readn+0xf>
  801a6b:	eb 01                	jmp    801a6e <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  801a6d:	90                   	nop
	}
	return tot;
  801a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a79:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	89 04 24             	mov    %eax,(%esp)
  801a86:	e8 d2 fb ff ff       	call   80165d <fd_lookup>
  801a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a92:	78 1d                	js     801ab1 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a97:	8b 00                	mov    (%eax),%eax
  801a99:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801a9c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aa0:	89 04 24             	mov    %eax,(%esp)
  801aa3:	e8 60 fc ff ff       	call   801708 <dev_lookup>
  801aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aaf:	79 05                	jns    801ab6 <write+0x43>
		return r;
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	eb 74                	jmp    801b2a <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab9:	8b 40 08             	mov    0x8(%eax),%eax
  801abc:	83 e0 03             	and    $0x3,%eax
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 26                	jne    801ae9 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801ac3:	a1 40 50 80 00       	mov    0x805040,%eax
  801ac8:	8b 40 4c             	mov    0x4c(%eax),%eax
  801acb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ace:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad6:	c7 04 24 07 2d 80 00 	movl   $0x802d07,(%esp)
  801add:	e8 3e e9 ff ff       	call   800420 <cprintf>
		return -E_INVAL;
  801ae2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ae7:	eb 41                	jmp    801b2a <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aec:	8b 48 0c             	mov    0xc(%eax),%ecx
  801aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af2:	8b 50 04             	mov    0x4(%eax),%edx
  801af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801afc:	8b 55 10             	mov    0x10(%ebp),%edx
  801aff:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b0a:	89 04 24             	mov    %eax,(%esp)
  801b0d:	ff d1                	call   *%ecx
  801b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  801b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b16:	7e 0f                	jle    801b27 <write+0xb4>
		fd->fd_offset += r;
  801b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b1e:	8b 52 04             	mov    0x4(%edx),%edx
  801b21:	03 55 f4             	add    -0xc(%ebp),%edx
  801b24:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <seek>:

int
seek(int fdnum, off_t offset)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b32:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	89 04 24             	mov    %eax,(%esp)
  801b3f:	e8 19 fb ff ff       	call   80165d <fd_lookup>
  801b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b4b:	79 05                	jns    801b52 <seek+0x26>
		return r;
  801b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b50:	eb 0e                	jmp    801b60 <seek+0x34>
	fd->fd_offset = offset;
  801b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b68:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	89 04 24             	mov    %eax,(%esp)
  801b75:	e8 e3 fa ff ff       	call   80165d <fd_lookup>
  801b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b81:	78 1d                	js     801ba0 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b86:	8b 00                	mov    (%eax),%eax
  801b88:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b8f:	89 04 24             	mov    %eax,(%esp)
  801b92:	e8 71 fb ff ff       	call   801708 <dev_lookup>
  801b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b9e:	79 05                	jns    801ba5 <ftruncate+0x43>
		return r;
  801ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba3:	eb 48                	jmp    801bed <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba8:	8b 40 08             	mov    0x8(%eax),%eax
  801bab:	83 e0 03             	and    $0x3,%eax
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	75 26                	jne    801bd8 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801bb2:	a1 40 50 80 00       	mov    0x805040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bb7:	8b 40 4c             	mov    0x4c(%eax),%eax
  801bba:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbd:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc5:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  801bcc:	e8 4f e8 ff ff       	call   800420 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801bd1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd6:	eb 15                	jmp    801bed <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdb:	8b 48 1c             	mov    0x1c(%eax),%ecx
  801bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801be8:	89 04 24             	mov    %eax,(%esp)
  801beb:	ff d1                	call   *%ecx
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bf5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	89 04 24             	mov    %eax,(%esp)
  801c02:	e8 56 fa ff ff       	call   80165d <fd_lookup>
  801c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c0e:	78 1d                	js     801c2d <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c13:	8b 00                	mov    (%eax),%eax
  801c15:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801c18:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c1c:	89 04 24             	mov    %eax,(%esp)
  801c1f:	e8 e4 fa ff ff       	call   801708 <dev_lookup>
  801c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c2b:	79 05                	jns    801c32 <fstat+0x43>
		return r;
  801c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c30:	eb 41                	jmp    801c73 <fstat+0x84>
	stat->st_name[0] = 0;
  801c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c35:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  801c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801c42:	00 00 00 
	stat->st_isdir = 0;
  801c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c48:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  801c4f:	00 00 00 
	stat->st_dev = dev;
  801c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c58:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  801c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c61:	8b 48 14             	mov    0x14(%eax),%ecx
  801c64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c6e:	89 04 24             	mov    %eax,(%esp)
  801c71:	ff d1                	call   *%ecx
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c82:	00 
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	89 04 24             	mov    %eax,(%esp)
  801c89:	e8 36 00 00 00       	call   801cc4 <open>
  801c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c95:	79 05                	jns    801c9c <stat+0x27>
		return fd;
  801c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9a:	eb 23                	jmp    801cbf <stat+0x4a>
	r = fstat(fd, stat);
  801c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca6:	89 04 24             	mov    %eax,(%esp)
  801ca9:	e8 41 ff ff ff       	call   801bef <fstat>
  801cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	89 04 24             	mov    %eax,(%esp)
  801cb7:	e8 c3 fa ff ff       	call   80177f <close>
	return r;
  801cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    
  801cc1:	00 00                	add    %al,(%eax)
	...

00801cc4 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801cca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ccd:	89 04 24             	mov    %eax,(%esp)
  801cd0:	e8 1a f9 ff ff       	call   8015ef <fd_alloc>
  801cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cdc:	79 05                	jns    801ce3 <open+0x1f>
  801cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce1:	eb 73                	jmp    801d56 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  801ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	89 04 24             	mov    %eax,(%esp)
  801cf7:	e8 54 05 00 00       	call   802250 <fsipc_open>
  801cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d03:	79 05                	jns    801d0a <open+0x46>
  801d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d08:	eb 4c                	jmp    801d56 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d16:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d21:	00 
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 25 03 00 00       	call   80204f <fmap>
  801d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d31:	79 18                	jns    801d4b <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  801d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d36:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d3d:	00 
  801d3e:	89 04 24             	mov    %eax,(%esp)
  801d41:	e8 39 f9 ff ff       	call   80167f <fd_close>
  801d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d49:	eb 0b                	jmp    801d56 <open+0x92>
	return fd2num(fd);
  801d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4e:	89 04 24             	mov    %eax,(%esp)
  801d51:	e8 89 f8 ff ff       	call   8015df <fd2num>
	//panic("open() unimplemented!");
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801d67:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801d6e:	00 
  801d6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d76:	00 
  801d77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	89 04 24             	mov    %eax,(%esp)
  801d81:	e8 72 03 00 00       	call   8020f8 <funmap>
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8d:	79 05                	jns    801d94 <file_close+0x3c>
  801d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d92:	eb 21                	jmp    801db5 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9a:	89 04 24             	mov    %eax,(%esp)
  801d9d:	e8 e3 05 00 00       	call   802385 <fsipc_close>
  801da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da9:	79 05                	jns    801db0 <file_close+0x58>
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	eb 05                	jmp    801db5 <file_close+0x5d>
	return 0;
  801db0:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801dcf:	76 07                	jbe    801dd8 <file_read+0x21>
		return 0;
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd6:	eb 43                	jmp    801e1b <file_read+0x64>
	if (offset + n > size)
  801dd8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ddb:	03 45 10             	add    0x10(%ebp),%eax
  801dde:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de1:	76 0f                	jbe    801df2 <file_read+0x3b>
		n = size - offset;
  801de3:	8b 45 14             	mov    0x14(%ebp),%eax
  801de6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de9:	89 d1                	mov    %edx,%ecx
  801deb:	29 c1                	sub    %eax,%ecx
  801ded:	89 c8                	mov    %ecx,%eax
  801def:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	89 04 24             	mov    %eax,(%esp)
  801df8:	e8 c7 f7 ff ff       	call   8015c4 <fd2data>
  801dfd:	8b 55 14             	mov    0x14(%ebp),%edx
  801e00:	01 c2                	add    %eax,%edx
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e09:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e10:	89 04 24             	mov    %eax,(%esp)
  801e13:	e8 0c f1 ff ff       	call   800f24 <memmove>
	return n;
  801e18:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	89 04 24             	mov    %eax,(%esp)
  801e30:	e8 28 f8 ff ff       	call   80165d <fd_lookup>
  801e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3c:	79 05                	jns    801e43 <read_map+0x26>
		return r;
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	eb 74                	jmp    801eb7 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  801e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e46:	8b 10                	mov    (%eax),%edx
  801e48:	a1 20 50 80 00       	mov    0x805020,%eax
  801e4d:	39 c2                	cmp    %eax,%edx
  801e4f:	74 07                	je     801e58 <read_map+0x3b>
		return -E_INVAL;
  801e51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e56:	eb 5f                	jmp    801eb7 <read_map+0x9a>
	va = fd2data(fd) + offset;
  801e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5b:	89 04 24             	mov    %eax,(%esp)
  801e5e:	e8 61 f7 ff ff       	call   8015c4 <fd2data>
  801e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e66:	01 d0                	add    %edx,%eax
  801e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  801e6b:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  801e72:	7e 07                	jle    801e7b <read_map+0x5e>
		return -E_NO_DISK;
  801e74:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801e79:	eb 3c                	jmp    801eb7 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7e:	c1 e8 16             	shr    $0x16,%eax
  801e81:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e88:	83 e0 01             	and    $0x1,%eax
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	74 14                	je     801ea3 <read_map+0x86>
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	c1 e8 0c             	shr    $0xc,%eax
  801e95:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e9c:	83 e0 01             	and    $0x1,%eax
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	75 07                	jne    801eaa <read_map+0x8d>
		return -E_NO_DISK;
  801ea3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801ea8:	eb 0d                	jmp    801eb7 <read_map+0x9a>
	*blk = (void*) va;
  801eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eb0:	89 10                	mov    %edx,(%eax)
	return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  801ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec2:	03 45 10             	add    0x10(%ebp),%eax
  801ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  801ec8:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  801ecf:	76 07                	jbe    801ed8 <file_write+0x1f>
		return -E_NO_DISK;
  801ed1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801ed6:	eb 57                	jmp    801f2f <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801ee1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ee4:	73 20                	jae    801f06 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  801ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	89 04 24             	mov    %eax,(%esp)
  801ef3:	e8 88 00 00 00       	call   801f80 <file_trunc>
  801ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801efb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eff:	79 05                	jns    801f06 <file_write+0x4d>
			return r;
  801f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f04:	eb 29                	jmp    801f2f <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	89 04 24             	mov    %eax,(%esp)
  801f0c:	e8 b3 f6 ff ff       	call   8015c4 <fd2data>
  801f11:	8b 55 14             	mov    0x14(%ebp),%edx
  801f14:	01 c2                	add    %eax,%edx
  801f16:	8b 45 10             	mov    0x10(%ebp),%eax
  801f19:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f24:	89 14 24             	mov    %edx,(%esp)
  801f27:	e8 f8 ef ff ff       	call   800f24 <memmove>
	return n;
  801f2c:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	8d 50 10             	lea    0x10(%eax),%edx
  801f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f40:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f44:	89 04 24             	mov    %eax,(%esp)
  801f47:	e8 e6 ed ff ff       	call   800d32 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f58:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  801f67:	83 f8 01             	cmp    $0x1,%eax
  801f6a:	0f 94 c0             	sete   %al
  801f6d:	0f b6 d0             	movzbl %al,%edx
  801f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f73:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  801f86:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  801f8d:	7e 0a                	jle    801f99 <file_trunc+0x19>
		return -E_NO_DISK;
  801f8f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801f94:	e9 b4 00 00 00       	jmp    80204d <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fb8:	89 04 24             	mov    %eax,(%esp)
  801fbb:	e8 82 03 00 00       	call   802342 <fsipc_set_size>
  801fc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fc7:	79 05                	jns    801fce <file_trunc+0x4e>
		return r;
  801fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fcc:	eb 7f                	jmp    80204d <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801fd7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fda:	74 24                	je     802000 <file_trunc+0x80>
  801fdc:	c7 44 24 0c 50 2d 80 	movl   $0x802d50,0xc(%esp)
  801fe3:	00 
  801fe4:	c7 44 24 08 73 2d 80 	movl   $0x802d73,0x8(%esp)
  801feb:	00 
  801fec:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801ff3:	00 
  801ff4:	c7 04 24 88 2d 80 00 	movl   $0x802d88,(%esp)
  801ffb:	e8 ec e2 ff ff       	call   8002ec <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	89 44 24 08          	mov    %eax,0x8(%esp)
  802007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	89 04 24             	mov    %eax,(%esp)
  802014:	e8 36 00 00 00       	call   80204f <fmap>
  802019:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80201c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802020:	79 05                	jns    802027 <file_trunc+0xa7>
		return r;
  802022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802025:	eb 26                	jmp    80204d <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  802027:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80202e:	00 
  80202f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802032:	89 44 24 08          	mov    %eax,0x8(%esp)
  802036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	89 04 24             	mov    %eax,(%esp)
  802043:	e8 b0 00 00 00       	call   8020f8 <funmap>

	return 0;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	89 04 24             	mov    %eax,(%esp)
  80205b:	e8 64 f5 ff ff       	call   8015c4 <fd2data>
  802060:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  802063:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80206a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206d:	03 45 ec             	add    -0x14(%ebp),%eax
  802070:	83 e8 01             	sub    $0x1,%eax
  802073:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802079:	ba 00 00 00 00       	mov    $0x0,%edx
  80207e:	f7 75 ec             	divl   -0x14(%ebp)
  802081:	89 d0                	mov    %edx,%eax
  802083:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802086:	89 d1                	mov    %edx,%ecx
  802088:	29 c1                	sub    %eax,%ecx
  80208a:	89 c8                	mov    %ecx,%eax
  80208c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208f:	eb 58                	jmp    8020e9 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802097:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80209a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 04 02 00 00       	call   8022b7 <fsipc_map>
  8020b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020ba:	79 26                	jns    8020e2 <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020c6:	00 
  8020c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	89 04 24             	mov    %eax,(%esp)
  8020d8:	e8 1b 00 00 00       	call   8020f8 <funmap>
			return r;
  8020dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e0:	eb 14                	jmp    8020f6 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  8020e2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8020e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020ef:	77 a0                	ja     802091 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	89 04 24             	mov    %eax,(%esp)
  802104:	e8 bb f4 ff ff       	call   8015c4 <fd2data>
  802109:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  80210c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210f:	c1 e8 16             	shr    $0x16,%eax
  802112:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802119:	83 e0 01             	and    $0x1,%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	75 0a                	jne    80212a <funmap+0x32>
		return 0;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
  802125:	e9 bf 00 00 00       	jmp    8021e9 <funmap+0xf1>

	ret = 0;
  80212a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  802131:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802138:	8b 45 10             	mov    0x10(%ebp),%eax
  80213b:	03 45 e8             	add    -0x18(%ebp),%eax
  80213e:	83 e8 01             	sub    $0x1,%eax
  802141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802147:	ba 00 00 00 00       	mov    $0x0,%edx
  80214c:	f7 75 e8             	divl   -0x18(%ebp)
  80214f:	89 d0                	mov    %edx,%eax
  802151:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802154:	89 d1                	mov    %edx,%ecx
  802156:	29 c1                	sub    %eax,%ecx
  802158:	89 c8                	mov    %ecx,%eax
  80215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215d:	eb 7b                	jmp    8021da <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802165:	01 d0                	add    %edx,%eax
  802167:	c1 e8 0c             	shr    $0xc,%eax
  80216a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802171:	83 e0 01             	and    $0x1,%eax
  802174:	84 c0                	test   %al,%al
  802176:	74 5b                	je     8021d3 <funmap+0xdb>
			if (dirty
  802178:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  80217c:	74 3d                	je     8021bb <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802184:	01 d0                	add    %edx,%eax
  802186:	c1 e8 0c             	shr    $0xc,%eax
  802189:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802190:	83 e0 40             	and    $0x40,%eax
  802193:	85 c0                	test   %eax,%eax
  802195:	74 24                	je     8021bb <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  802197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021a4:	89 04 24             	mov    %eax,(%esp)
  8021a7:	e8 13 02 00 00       	call   8023bf <fsipc_dirty>
  8021ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8021af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021b3:	79 06                	jns    8021bb <funmap+0xc3>
				ret = r;
  8021b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021c1:	01 d0                	add    %edx,%eax
  8021c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ce:	e8 22 f2 ff ff       	call   8013f5 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8021d3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8021da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021e0:	0f 87 79 ff ff ff    	ja     80215f <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  8021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <remove>:

// Delete a file
int
remove(const char *path)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	89 04 24             	mov    %eax,(%esp)
  8021f7:	e8 06 02 00 00       	call   802402 <fsipc_remove>
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  802204:	e8 56 02 00 00       	call   80245f <fsipc_sync>
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    
	...

0080220c <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  802212:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  802217:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80221e:	00 
  80221f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802222:	89 54 24 08          	mov    %edx,0x8(%esp)
  802226:	8b 55 08             	mov    0x8(%ebp),%edx
  802229:	89 54 24 04          	mov    %edx,0x4(%esp)
  80222d:	89 04 24             	mov    %eax,(%esp)
  802230:	e8 e3 02 00 00       	call   802518 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802235:	8b 45 14             	mov    0x14(%ebp),%eax
  802238:	89 44 24 08          	mov    %eax,0x8(%esp)
  80223c:	8b 45 10             	mov    0x10(%ebp),%eax
  80223f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802243:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802246:	89 04 24             	mov    %eax,(%esp)
  802249:	e8 3e 02 00 00       	call   80248c <ipc_recv>
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  802256:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	89 04 24             	mov    %eax,(%esp)
  802263:	e8 74 ea ff ff       	call   800cdc <strlen>
  802268:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80226d:	7e 07                	jle    802276 <fsipc_open+0x26>
		return -E_BAD_PATH;
  80226f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802274:	eb 3f                	jmp    8022b5 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 55 08             	mov    0x8(%ebp),%edx
  80227c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802280:	89 04 24             	mov    %eax,(%esp)
  802283:	e8 aa ea ff ff       	call   800d32 <strcpy>
	req->req_omode = omode;
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228e:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  802294:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80229b:	8b 45 10             	mov    0x10(%ebp),%eax
  80229e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8022b0:	e8 57 ff ff ff       	call   80220c <fsipc>
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  8022bd:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ca:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d2:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  8022d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ea:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022f1:	e8 16 ff ff ff       	call   80220c <fsipc>
  8022f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022fd:	79 05                	jns    802304 <fsipc_map+0x4d>
		return r;
  8022ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802302:	eb 3c                	jmp    802340 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  802304:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802307:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  80230c:	83 f8 05             	cmp    $0x5,%eax
  80230f:	74 2a                	je     80233b <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  802311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802314:	8b 55 10             	mov    0x10(%ebp),%edx
  802317:	89 54 24 10          	mov    %edx,0x10(%esp)
  80231b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80231f:	c7 44 24 08 94 2d 80 	movl   $0x802d94,0x8(%esp)
  802326:	00 
  802327:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  80232e:	00 
  80232f:	c7 04 24 ca 2d 80 00 	movl   $0x802dca,(%esp)
  802336:	e8 b1 df ff ff       	call   8002ec <_panic>
	return 0;
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802348:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 55 08             	mov    0x8(%ebp),%edx
  802355:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235d:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802360:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802367:	00 
  802368:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80236f:	00 
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	89 44 24 04          	mov    %eax,0x4(%esp)
  802377:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80237e:	e8 89 fe ff ff       	call   80220c <fsipc>
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  80238b:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 55 08             	mov    0x8(%ebp),%edx
  802398:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  80239a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8023a1:	00 
  8023a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023a9:	00 
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8023b8:	e8 4f fe ff ff       	call   80220c <fsipc>
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  8023c5:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d2:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023da:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8023dd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8023e4:	00 
  8023e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023ec:	00 
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8023fb:	e8 0c fe ff ff       	call   80220c <fsipc>
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802408:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	89 04 24             	mov    %eax,(%esp)
  802415:	e8 c2 e8 ff ff       	call   800cdc <strlen>
  80241a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80241f:	7e 07                	jle    802428 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802421:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802426:	eb 35                	jmp    80245d <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 55 08             	mov    0x8(%ebp),%edx
  80242e:	89 54 24 04          	mov    %edx,0x4(%esp)
  802432:	89 04 24             	mov    %eax,(%esp)
  802435:	e8 f8 e8 ff ff       	call   800d32 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  80243a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802441:	00 
  802442:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802449:	00 
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802451:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  802458:	e8 af fd ff ff       	call   80220c <fsipc>
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802465:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80246c:	00 
  80246d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802474:	00 
  802475:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  80247c:	00 
  80247d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  802484:	e8 83 fd ff ff       	call   80220c <fsipc>
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    
	...

0080248c <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  802492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802496:	75 11                	jne    8024a9 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  802498:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  80249f:	e8 db f0 ff ff       	call   80157f <sys_ipc_recv>
  8024a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a7:	eb 0e                	jmp    8024b7 <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  8024a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ac:	89 04 24             	mov    %eax,(%esp)
  8024af:	e8 cb f0 ff ff       	call   80157f <sys_ipc_recv>
  8024b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  8024b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bb:	79 1c                	jns    8024d9 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  8024bd:	c7 44 24 08 d6 2d 80 	movl   $0x802dd6,0x8(%esp)
  8024c4:	00 
  8024c5:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8024cc:	00 
  8024cd:	c7 04 24 ec 2d 80 00 	movl   $0x802dec,(%esp)
  8024d4:	e8 13 de ff ff       	call   8002ec <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  8024d9:	e8 08 ee ff ff       	call   8012e6 <sys_getenvid>
  8024de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8024e3:	c1 e0 07             	shl    $0x7,%eax
  8024e6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  8024ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f2:	74 0b                	je     8024ff <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  8024f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f7:	8b 50 74             	mov    0x74(%eax),%edx
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  8024ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802503:	74 0b                	je     802510 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  802505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802508:	8b 50 78             	mov    0x78(%eax),%edx
  80250b:	8b 45 10             	mov    0x10(%ebp),%eax
  80250e:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  802510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802513:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  80251e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802522:	75 26                	jne    80254a <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  802524:	8b 45 14             	mov    0x14(%ebp),%eax
  802527:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80252b:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  802532:	ee 
  802533:	8b 45 0c             	mov    0xc(%ebp),%eax
  802536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	89 04 24             	mov    %eax,(%esp)
  802540:	e8 fa ef ff ff       	call   80153f <sys_ipc_try_send>
  802545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802548:	eb 23                	jmp    80256d <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  80254a:	8b 45 14             	mov    0x14(%ebp),%eax
  80254d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802551:	8b 45 10             	mov    0x10(%ebp),%eax
  802554:	89 44 24 08          	mov    %eax,0x8(%esp)
  802558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	89 04 24             	mov    %eax,(%esp)
  802565:	e8 d5 ef ff ff       	call   80153f <sys_ipc_try_send>
  80256a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  80256d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802571:	79 29                	jns    80259c <ipc_send+0x84>
  802573:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  802577:	74 23                	je     80259c <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802580:	c7 44 24 08 f6 2d 80 	movl   $0x802df6,0x8(%esp)
  802587:	00 
  802588:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80258f:	00 
  802590:	c7 04 24 ec 2d 80 00 	movl   $0x802dec,(%esp)
  802597:	e8 50 dd ff ff       	call   8002ec <_panic>
	    sys_yield();
  80259c:	e8 89 ed ff ff       	call   80132a <sys_yield>
	}while(r < 0);
  8025a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a5:	0f 88 73 ff ff ff    	js     80251e <ipc_send+0x6>
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    
  8025ad:	00 00                	add    %al,(%eax)
	...

008025b0 <__udivdi3>:
  8025b0:	83 ec 1c             	sub    $0x1c,%esp
  8025b3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8025b7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8025bb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8025bf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8025c3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8025c7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8025cb:	85 ff                	test   %edi,%edi
  8025cd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8025d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d5:	89 cd                	mov    %ecx,%ebp
  8025d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025db:	75 33                	jne    802610 <__udivdi3+0x60>
  8025dd:	39 f1                	cmp    %esi,%ecx
  8025df:	77 57                	ja     802638 <__udivdi3+0x88>
  8025e1:	85 c9                	test   %ecx,%ecx
  8025e3:	75 0b                	jne    8025f0 <__udivdi3+0x40>
  8025e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ea:	31 d2                	xor    %edx,%edx
  8025ec:	f7 f1                	div    %ecx
  8025ee:	89 c1                	mov    %eax,%ecx
  8025f0:	89 f0                	mov    %esi,%eax
  8025f2:	31 d2                	xor    %edx,%edx
  8025f4:	f7 f1                	div    %ecx
  8025f6:	89 c6                	mov    %eax,%esi
  8025f8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025fc:	f7 f1                	div    %ecx
  8025fe:	89 f2                	mov    %esi,%edx
  802600:	8b 74 24 10          	mov    0x10(%esp),%esi
  802604:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802608:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80260c:	83 c4 1c             	add    $0x1c,%esp
  80260f:	c3                   	ret    
  802610:	31 d2                	xor    %edx,%edx
  802612:	31 c0                	xor    %eax,%eax
  802614:	39 f7                	cmp    %esi,%edi
  802616:	77 e8                	ja     802600 <__udivdi3+0x50>
  802618:	0f bd cf             	bsr    %edi,%ecx
  80261b:	83 f1 1f             	xor    $0x1f,%ecx
  80261e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802622:	75 2c                	jne    802650 <__udivdi3+0xa0>
  802624:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802628:	76 04                	jbe    80262e <__udivdi3+0x7e>
  80262a:	39 f7                	cmp    %esi,%edi
  80262c:	73 d2                	jae    802600 <__udivdi3+0x50>
  80262e:	31 d2                	xor    %edx,%edx
  802630:	b8 01 00 00 00       	mov    $0x1,%eax
  802635:	eb c9                	jmp    802600 <__udivdi3+0x50>
  802637:	90                   	nop
  802638:	89 f2                	mov    %esi,%edx
  80263a:	f7 f1                	div    %ecx
  80263c:	31 d2                	xor    %edx,%edx
  80263e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802642:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802646:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80264a:	83 c4 1c             	add    $0x1c,%esp
  80264d:	c3                   	ret    
  80264e:	66 90                	xchg   %ax,%ax
  802650:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802655:	b8 20 00 00 00       	mov    $0x20,%eax
  80265a:	89 ea                	mov    %ebp,%edx
  80265c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802660:	d3 e7                	shl    %cl,%edi
  802662:	89 c1                	mov    %eax,%ecx
  802664:	d3 ea                	shr    %cl,%edx
  802666:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80266b:	09 fa                	or     %edi,%edx
  80266d:	89 f7                	mov    %esi,%edi
  80266f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802673:	89 f2                	mov    %esi,%edx
  802675:	8b 74 24 08          	mov    0x8(%esp),%esi
  802679:	d3 e5                	shl    %cl,%ebp
  80267b:	89 c1                	mov    %eax,%ecx
  80267d:	d3 ef                	shr    %cl,%edi
  80267f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802684:	d3 e2                	shl    %cl,%edx
  802686:	89 c1                	mov    %eax,%ecx
  802688:	d3 ee                	shr    %cl,%esi
  80268a:	09 d6                	or     %edx,%esi
  80268c:	89 fa                	mov    %edi,%edx
  80268e:	89 f0                	mov    %esi,%eax
  802690:	f7 74 24 0c          	divl   0xc(%esp)
  802694:	89 d7                	mov    %edx,%edi
  802696:	89 c6                	mov    %eax,%esi
  802698:	f7 e5                	mul    %ebp
  80269a:	39 d7                	cmp    %edx,%edi
  80269c:	72 22                	jb     8026c0 <__udivdi3+0x110>
  80269e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  8026a2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026a7:	d3 e5                	shl    %cl,%ebp
  8026a9:	39 c5                	cmp    %eax,%ebp
  8026ab:	73 04                	jae    8026b1 <__udivdi3+0x101>
  8026ad:	39 d7                	cmp    %edx,%edi
  8026af:	74 0f                	je     8026c0 <__udivdi3+0x110>
  8026b1:	89 f0                	mov    %esi,%eax
  8026b3:	31 d2                	xor    %edx,%edx
  8026b5:	e9 46 ff ff ff       	jmp    802600 <__udivdi3+0x50>
  8026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026c0:	8d 46 ff             	lea    -0x1(%esi),%eax
  8026c3:	31 d2                	xor    %edx,%edx
  8026c5:	8b 74 24 10          	mov    0x10(%esp),%esi
  8026c9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026cd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026d1:	83 c4 1c             	add    $0x1c,%esp
  8026d4:	c3                   	ret    
	...

008026e0 <__umoddi3>:
  8026e0:	83 ec 1c             	sub    $0x1c,%esp
  8026e3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8026e7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8026eb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8026ef:	89 74 24 10          	mov    %esi,0x10(%esp)
  8026f3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8026f7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8026fb:	85 ed                	test   %ebp,%ebp
  8026fd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802701:	89 44 24 08          	mov    %eax,0x8(%esp)
  802705:	89 cf                	mov    %ecx,%edi
  802707:	89 04 24             	mov    %eax,(%esp)
  80270a:	89 f2                	mov    %esi,%edx
  80270c:	75 1a                	jne    802728 <__umoddi3+0x48>
  80270e:	39 f1                	cmp    %esi,%ecx
  802710:	76 4e                	jbe    802760 <__umoddi3+0x80>
  802712:	f7 f1                	div    %ecx
  802714:	89 d0                	mov    %edx,%eax
  802716:	31 d2                	xor    %edx,%edx
  802718:	8b 74 24 10          	mov    0x10(%esp),%esi
  80271c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802720:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802724:	83 c4 1c             	add    $0x1c,%esp
  802727:	c3                   	ret    
  802728:	39 f5                	cmp    %esi,%ebp
  80272a:	77 54                	ja     802780 <__umoddi3+0xa0>
  80272c:	0f bd c5             	bsr    %ebp,%eax
  80272f:	83 f0 1f             	xor    $0x1f,%eax
  802732:	89 44 24 04          	mov    %eax,0x4(%esp)
  802736:	75 60                	jne    802798 <__umoddi3+0xb8>
  802738:	3b 0c 24             	cmp    (%esp),%ecx
  80273b:	0f 87 07 01 00 00    	ja     802848 <__umoddi3+0x168>
  802741:	89 f2                	mov    %esi,%edx
  802743:	8b 34 24             	mov    (%esp),%esi
  802746:	29 ce                	sub    %ecx,%esi
  802748:	19 ea                	sbb    %ebp,%edx
  80274a:	89 34 24             	mov    %esi,(%esp)
  80274d:	8b 04 24             	mov    (%esp),%eax
  802750:	8b 74 24 10          	mov    0x10(%esp),%esi
  802754:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802758:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80275c:	83 c4 1c             	add    $0x1c,%esp
  80275f:	c3                   	ret    
  802760:	85 c9                	test   %ecx,%ecx
  802762:	75 0b                	jne    80276f <__umoddi3+0x8f>
  802764:	b8 01 00 00 00       	mov    $0x1,%eax
  802769:	31 d2                	xor    %edx,%edx
  80276b:	f7 f1                	div    %ecx
  80276d:	89 c1                	mov    %eax,%ecx
  80276f:	89 f0                	mov    %esi,%eax
  802771:	31 d2                	xor    %edx,%edx
  802773:	f7 f1                	div    %ecx
  802775:	8b 04 24             	mov    (%esp),%eax
  802778:	f7 f1                	div    %ecx
  80277a:	eb 98                	jmp    802714 <__umoddi3+0x34>
  80277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802780:	89 f2                	mov    %esi,%edx
  802782:	8b 74 24 10          	mov    0x10(%esp),%esi
  802786:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80278a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80278e:	83 c4 1c             	add    $0x1c,%esp
  802791:	c3                   	ret    
  802792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802798:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80279d:	89 e8                	mov    %ebp,%eax
  80279f:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027a4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  8027a8:	89 fa                	mov    %edi,%edx
  8027aa:	d3 e0                	shl    %cl,%eax
  8027ac:	89 e9                	mov    %ebp,%ecx
  8027ae:	d3 ea                	shr    %cl,%edx
  8027b0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027b5:	09 c2                	or     %eax,%edx
  8027b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027bb:	89 14 24             	mov    %edx,(%esp)
  8027be:	89 f2                	mov    %esi,%edx
  8027c0:	d3 e7                	shl    %cl,%edi
  8027c2:	89 e9                	mov    %ebp,%ecx
  8027c4:	d3 ea                	shr    %cl,%edx
  8027c6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027cf:	d3 e6                	shl    %cl,%esi
  8027d1:	89 e9                	mov    %ebp,%ecx
  8027d3:	d3 e8                	shr    %cl,%eax
  8027d5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027da:	09 f0                	or     %esi,%eax
  8027dc:	8b 74 24 08          	mov    0x8(%esp),%esi
  8027e0:	f7 34 24             	divl   (%esp)
  8027e3:	d3 e6                	shl    %cl,%esi
  8027e5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027e9:	89 d6                	mov    %edx,%esi
  8027eb:	f7 e7                	mul    %edi
  8027ed:	39 d6                	cmp    %edx,%esi
  8027ef:	89 c1                	mov    %eax,%ecx
  8027f1:	89 d7                	mov    %edx,%edi
  8027f3:	72 3f                	jb     802834 <__umoddi3+0x154>
  8027f5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8027f9:	72 35                	jb     802830 <__umoddi3+0x150>
  8027fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027ff:	29 c8                	sub    %ecx,%eax
  802801:	19 fe                	sbb    %edi,%esi
  802803:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802808:	89 f2                	mov    %esi,%edx
  80280a:	d3 e8                	shr    %cl,%eax
  80280c:	89 e9                	mov    %ebp,%ecx
  80280e:	d3 e2                	shl    %cl,%edx
  802810:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802815:	09 d0                	or     %edx,%eax
  802817:	89 f2                	mov    %esi,%edx
  802819:	d3 ea                	shr    %cl,%edx
  80281b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80281f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802823:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802827:	83 c4 1c             	add    $0x1c,%esp
  80282a:	c3                   	ret    
  80282b:	90                   	nop
  80282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802830:	39 d6                	cmp    %edx,%esi
  802832:	75 c7                	jne    8027fb <__umoddi3+0x11b>
  802834:	89 d7                	mov    %edx,%edi
  802836:	89 c1                	mov    %eax,%ecx
  802838:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80283c:	1b 3c 24             	sbb    (%esp),%edi
  80283f:	eb ba                	jmp    8027fb <__umoddi3+0x11b>
  802841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802848:	39 f5                	cmp    %esi,%ebp
  80284a:	0f 82 f1 fe ff ff    	jb     802741 <__umoddi3+0x61>
  802850:	e9 f8 fe ff ff       	jmp    80274d <__umoddi3+0x6d>
