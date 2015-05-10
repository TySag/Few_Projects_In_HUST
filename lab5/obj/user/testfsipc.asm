
obj/user/testfsipc:     file format elf32-i386


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
  80002c:	e8 9f 02 00 00       	call   8002d0 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <strecmp>:
#include <inc/lib.h>

int
strecmp(const char *a, const char *b)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
	while (*b)
  800037:	eb 24                	jmp    80005d <strecmp+0x29>
		if (*a++ != *b++)
  800039:	8b 45 08             	mov    0x8(%ebp),%eax
  80003c:	0f b6 10             	movzbl (%eax),%edx
  80003f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800042:	0f b6 00             	movzbl (%eax),%eax
  800045:	38 c2                	cmp    %al,%dl
  800047:	0f 95 c0             	setne  %al
  80004a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80004e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800052:	84 c0                	test   %al,%al
  800054:	74 07                	je     80005d <strecmp+0x29>
			return 1;
  800056:	b8 01 00 00 00       	mov    $0x1,%eax
  80005b:	eb 0f                	jmp    80006c <strecmp+0x38>
#include <inc/lib.h>

int
strecmp(const char *a, const char *b)
{
	while (*b)
  80005d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800060:	0f b6 00             	movzbl (%eax),%eax
  800063:	84 c0                	test   %al,%al
  800065:	75 d2                	jne    800039 <strecmp+0x5>
		if (*a++ != *b++)
			return 1;
	return 0;
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80006c:	5d                   	pop    %ebp
  80006d:	c3                   	ret    

0080006e <umain>:

#define FVA (struct Fd*)0xCCCCC000

void
umain(void)
{
  80006e:	55                   	push   %ebp
  80006f:	89 e5                	mov    %esp,%ebp
  800071:	83 ec 38             	sub    $0x38,%esp
	int r;
	int fileid;
	struct Fd *fd;

	if ((r = fsipc_open("/not-found", O_RDONLY, FVA)) < 0 && r != -E_NOT_FOUND)
  800074:	c7 44 24 08 00 c0 cc 	movl   $0xccccc000,0x8(%esp)
  80007b:	cc 
  80007c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800083:	00 
  800084:	c7 04 24 e6 28 80 00 	movl   $0x8028e6,(%esp)
  80008b:	e8 08 22 00 00       	call   802298 <fsipc_open>
  800090:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800093:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800097:	79 29                	jns    8000c2 <umain+0x54>
  800099:	83 7d f4 f5          	cmpl   $0xfffffff5,-0xc(%ebp)
  80009d:	74 23                	je     8000c2 <umain+0x54>
		panic("serve_open /not-found: %e", r);
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a6:	c7 44 24 08 f1 28 80 	movl   $0x8028f1,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  8000bd:	e8 72 02 00 00       	call   800334 <_panic>
	else if (r == 0)
  8000c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8000c6:	75 1c                	jne    8000e4 <umain+0x76>
		panic("serve_open /not-found succeeded!");
  8000c8:	c7 44 24 08 1c 29 80 	movl   $0x80291c,0x8(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8000d7:	00 
  8000d8:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  8000df:	e8 50 02 00 00       	call   800334 <_panic>

	if ((r = fsipc_open("/newmotd", O_RDONLY, FVA)) < 0)
  8000e4:	c7 44 24 08 00 c0 cc 	movl   $0xccccc000,0x8(%esp)
  8000eb:	cc 
  8000ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000f3:	00 
  8000f4:	c7 04 24 3d 29 80 00 	movl   $0x80293d,(%esp)
  8000fb:	e8 98 21 00 00       	call   802298 <fsipc_open>
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800107:	79 23                	jns    80012c <umain+0xbe>
		panic("serve_open /newmotd: %e", r);
  800109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80010c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800110:	c7 44 24 08 46 29 80 	movl   $0x802946,0x8(%esp)
  800117:	00 
  800118:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80011f:	00 
  800120:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  800127:	e8 08 02 00 00       	call   800334 <_panic>
	fd = (struct Fd*) FVA;
  80012c:	c7 45 f0 00 c0 cc cc 	movl   $0xccccc000,-0x10(%ebp)
	if (strlen(msg) != fd->fd_file.file.f_size)
  800133:	a1 00 50 80 00       	mov    0x805000,%eax
  800138:	89 04 24             	mov    %eax,(%esp)
  80013b:	e8 e4 0b 00 00       	call   800d24 <strlen>
  800140:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800143:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
  800149:	39 d0                	cmp    %edx,%eax
  80014b:	74 3a                	je     800187 <umain+0x119>
		panic("serve_open returned size %d wanted %d\n", fd->fd_file.file.f_size, strlen(msg));
  80014d:	a1 00 50 80 00       	mov    0x805000,%eax
  800152:	89 04 24             	mov    %eax,(%esp)
  800155:	e8 ca 0b 00 00       	call   800d24 <strlen>
  80015a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80015d:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
  800163:	89 44 24 10          	mov    %eax,0x10(%esp)
  800167:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80016b:	c7 44 24 08 60 29 80 	movl   $0x802960,0x8(%esp)
  800172:	00 
  800173:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  80017a:	00 
  80017b:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  800182:	e8 ad 01 00 00       	call   800334 <_panic>
	cprintf("serve_open is good\n");
  800187:	c7 04 24 87 29 80 00 	movl   $0x802987,(%esp)
  80018e:	e8 d5 02 00 00       	call   800468 <cprintf>

	if ((r = fsipc_map(fd->fd_file.id, 0, UTEMP)) < 0)
  800193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800196:	8b 40 0c             	mov    0xc(%eax),%eax
  800199:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
  8001a0:	00 
  8001a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001a8:	00 
  8001a9:	89 04 24             	mov    %eax,(%esp)
  8001ac:	e8 4e 21 00 00       	call   8022ff <fsipc_map>
  8001b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8001b8:	79 23                	jns    8001dd <umain+0x16f>
		panic("serve_map: %e", r);
  8001ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c1:	c7 44 24 08 9b 29 80 	movl   $0x80299b,0x8(%esp)
  8001c8:	00 
  8001c9:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001d0:	00 
  8001d1:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  8001d8:	e8 57 01 00 00       	call   800334 <_panic>
	if (strecmp(UTEMP, msg) != 0)
  8001dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8001e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e6:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8001ed:	e8 42 fe ff ff       	call   800034 <strecmp>
  8001f2:	85 c0                	test   %eax,%eax
  8001f4:	74 1c                	je     800212 <umain+0x1a4>
		panic("serve_map returned wrong data");
  8001f6:	c7 44 24 08 a9 29 80 	movl   $0x8029a9,0x8(%esp)
  8001fd:	00 
  8001fe:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  800205:	00 
  800206:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  80020d:	e8 22 01 00 00       	call   800334 <_panic>
	cprintf("serve_map is good\n");
  800212:	c7 04 24 c7 29 80 00 	movl   $0x8029c7,(%esp)
  800219:	e8 4a 02 00 00       	call   800468 <cprintf>

	if ((r = fsipc_close(fd->fd_file.id)) < 0)
  80021e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800221:	8b 40 0c             	mov    0xc(%eax),%eax
  800224:	89 04 24             	mov    %eax,(%esp)
  800227:	e8 a1 21 00 00       	call   8023cd <fsipc_close>
  80022c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80022f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800233:	79 23                	jns    800258 <umain+0x1ea>
		panic("serve_close: %e", r);
  800235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800238:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80023c:	c7 44 24 08 da 29 80 	movl   $0x8029da,0x8(%esp)
  800243:	00 
  800244:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  80024b:	00 
  80024c:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  800253:	e8 dc 00 00 00       	call   800334 <_panic>
	cprintf("serve_close is good\n");
  800258:	c7 04 24 ea 29 80 00 	movl   $0x8029ea,(%esp)
  80025f:	e8 04 02 00 00       	call   800468 <cprintf>
	fileid = fd->fd_file.id;
  800264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800267:	8b 40 0c             	mov    0xc(%eax),%eax
  80026a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_page_unmap(0, (void*) FVA);
  80026d:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  800274:	cc 
  800275:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80027c:	e8 bc 11 00 00       	call   80143d <sys_page_unmap>

	if ((r = fsipc_map(fileid, 0, UTEMP)) != -E_INVAL)
  800281:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
  800288:	00 
  800289:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800290:	00 
  800291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800294:	89 04 24             	mov    %eax,(%esp)
  800297:	e8 63 20 00 00       	call   8022ff <fsipc_map>
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80029f:	83 7d f4 fd          	cmpl   $0xfffffffd,-0xc(%ebp)
  8002a3:	74 1c                	je     8002c1 <umain+0x253>
		panic("serve_map does not handle stale fileids correctly");
  8002a5:	c7 44 24 08 00 2a 80 	movl   $0x802a00,0x8(%esp)
  8002ac:	00 
  8002ad:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8002b4:	00 
  8002b5:	c7 04 24 0b 29 80 00 	movl   $0x80290b,(%esp)
  8002bc:	e8 73 00 00 00       	call   800334 <_panic>
	cprintf("stale fileid is good\n");
  8002c1:	c7 04 24 32 2a 80 00 	movl   $0x802a32,(%esp)
  8002c8:	e8 9b 01 00 00       	call   800468 <cprintf>
}
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    
	...

008002d0 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  8002d6:	e8 53 10 00 00       	call   80132e <sys_getenvid>
  8002db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e0:	c1 e0 07             	shl    $0x7,%eax
  8002e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e8:	a3 40 50 80 00       	mov    %eax,0x805040
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002f1:	7e 0a                	jle    8002fd <libmain+0x2d>
		binaryname = argv[0];
  8002f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f6:	8b 00                	mov    (%eax),%eax
  8002f8:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	umain(argc, argv);
  8002fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800300:	89 44 24 04          	mov    %eax,0x4(%esp)
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	89 04 24             	mov    %eax,(%esp)
  80030a:	e8 5f fd ff ff       	call   80006e <umain>

	// exit gracefully
	exit();
  80030f:	e8 04 00 00 00       	call   800318 <exit>
}
  800314:	c9                   	leave  
  800315:	c3                   	ret    
	...

00800318 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80031e:	e8 df 14 00 00       	call   801802 <close_all>
	sys_env_destroy(0);
  800323:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80032a:	e8 bc 0f 00 00       	call   8012eb <sys_env_destroy>
}
  80032f:	c9                   	leave  
  800330:	c3                   	ret    
  800331:	00 00                	add    %al,(%eax)
	...

00800334 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  80033a:	8d 45 10             	lea    0x10(%ebp),%eax
  80033d:	83 c0 04             	add    $0x4,%eax
  800340:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  800343:	a1 44 50 80 00       	mov    0x805044,%eax
  800348:	85 c0                	test   %eax,%eax
  80034a:	74 15                	je     800361 <_panic+0x2d>
		cprintf("%s: ", argv0);
  80034c:	a1 44 50 80 00       	mov    0x805044,%eax
  800351:	89 44 24 04          	mov    %eax,0x4(%esp)
  800355:	c7 04 24 5f 2a 80 00 	movl   $0x802a5f,(%esp)
  80035c:	e8 07 01 00 00       	call   800468 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800361:	a1 04 50 80 00       	mov    0x805004,%eax
  800366:	8b 55 0c             	mov    0xc(%ebp),%edx
  800369:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80036d:	8b 55 08             	mov    0x8(%ebp),%edx
  800370:	89 54 24 08          	mov    %edx,0x8(%esp)
  800374:	89 44 24 04          	mov    %eax,0x4(%esp)
  800378:	c7 04 24 64 2a 80 00 	movl   $0x802a64,(%esp)
  80037f:	e8 e4 00 00 00       	call   800468 <cprintf>
	vcprintf(fmt, ap);
  800384:	8b 45 10             	mov    0x10(%ebp),%eax
  800387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80038a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80038e:	89 04 24             	mov    %eax,(%esp)
  800391:	e8 6e 00 00 00       	call   800404 <vcprintf>
	cprintf("\n");
  800396:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  80039d:	e8 c6 00 00 00       	call   800468 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003a2:	cc                   	int3   
  8003a3:	eb fd                	jmp    8003a2 <_panic+0x6e>
  8003a5:	00 00                	add    %al,(%eax)
	...

008003a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  8003ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b6:	89 d1                	mov    %edx,%ecx
  8003b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  8003bf:	8d 50 01             	lea    0x1(%eax),%edx
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c5:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  8003c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d1:	75 20                	jne    8003f3 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  8003d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003db:	83 c2 08             	add    $0x8,%edx
  8003de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e2:	89 14 24             	mov    %edx,(%esp)
  8003e5:	e8 7b 0e 00 00       	call   801265 <sys_cputs>
		b->idx = 0;
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f6:	8b 40 04             	mov    0x4(%eax),%eax
  8003f9:	8d 50 01             	lea    0x1(%eax),%edx
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800402:	c9                   	leave  
  800403:	c3                   	ret    

00800404 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80040d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800414:	00 00 00 
	b.cnt = 0;
  800417:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80041e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800421:	8b 45 0c             	mov    0xc(%ebp),%eax
  800424:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80042f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800435:	89 44 24 04          	mov    %eax,0x4(%esp)
  800439:	c7 04 24 a8 03 80 00 	movl   $0x8003a8,(%esp)
  800440:	e8 f7 01 00 00       	call   80063c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800445:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80044b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80044f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800455:	83 c0 08             	add    $0x8,%eax
  800458:	89 04 24             	mov    %eax,(%esp)
  80045b:	e8 05 0e 00 00       	call   801265 <sys_cputs>

	return b.cnt;
  800460:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80046e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800471:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80047a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80047e:	89 04 24             	mov    %eax,(%esp)
  800481:	e8 7e ff ff ff       	call   800404 <vcprintf>
  800486:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800489:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    
	...

00800490 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	53                   	push   %ebx
  800494:	83 ec 34             	sub    $0x34,%esp
  800497:	8b 45 10             	mov    0x10(%ebp),%eax
  80049a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80049d:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ae:	77 72                	ja     800522 <printnum+0x92>
  8004b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004b3:	72 05                	jb     8004ba <printnum+0x2a>
  8004b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004b8:	77 68                	ja     800522 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004cc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004d6:	89 04 24             	mov    %eax,(%esp)
  8004d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004dd:	e8 1e 21 00 00       	call   802600 <__udivdi3>
  8004e2:	8b 4d 20             	mov    0x20(%ebp),%ecx
  8004e5:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  8004e9:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8004ed:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004f0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	89 04 24             	mov    %eax,(%esp)
  800509:	e8 82 ff ff ff       	call   800490 <printnum>
  80050e:	eb 1c                	jmp    80052c <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800510:	8b 45 0c             	mov    0xc(%ebp),%eax
  800513:	89 44 24 04          	mov    %eax,0x4(%esp)
  800517:	8b 45 20             	mov    0x20(%ebp),%eax
  80051a:	89 04 24             	mov    %eax,(%esp)
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800522:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800526:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80052a:	7f e4                	jg     800510 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80052f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80053e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800542:	89 04 24             	mov    %eax,(%esp)
  800545:	89 54 24 04          	mov    %edx,0x4(%esp)
  800549:	e8 e2 21 00 00       	call   802730 <__umoddi3>
  80054e:	05 fc 2b 80 00       	add    $0x802bfc,%eax
  800553:	0f b6 00             	movzbl (%eax),%eax
  800556:	0f be c0             	movsbl %al,%eax
  800559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800560:	89 04 24             	mov    %eax,(%esp)
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	ff d0                	call   *%eax
}
  800568:	83 c4 34             	add    $0x34,%esp
  80056b:	5b                   	pop    %ebx
  80056c:	5d                   	pop    %ebp
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 40                	jmp    80063a <getint+0x65>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1e                	je     80061e <getint+0x49>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	89 c2                	mov    %eax,%edx
  800619:	c1 fa 1f             	sar    $0x1f,%edx
  80061c:	eb 1c                	jmp    80063a <getint+0x65>
	else
		return va_arg(*ap, int);
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	8d 50 04             	lea    0x4(%eax),%edx
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	89 10                	mov    %edx,(%eax)
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	83 e8 04             	sub    $0x4,%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	89 c2                	mov    %eax,%edx
  800637:	c1 fa 1f             	sar    $0x1f,%edx
}
  80063a:	5d                   	pop    %ebp
  80063b:	c3                   	ret    

0080063c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063c:	55                   	push   %ebp
  80063d:	89 e5                	mov    %esp,%ebp
  80063f:	56                   	push   %esi
  800640:	53                   	push   %ebx
  800641:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800644:	eb 17                	jmp    80065d <vprintfmt+0x21>
			if (ch == '\0')
  800646:	85 db                	test   %ebx,%ebx
  800648:	0f 84 d1 05 00 00    	je     800c1f <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  80064e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800651:	89 44 24 04          	mov    %eax,0x4(%esp)
  800655:	89 1c 24             	mov    %ebx,(%esp)
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065d:	8b 45 10             	mov    0x10(%ebp),%eax
  800660:	0f b6 00             	movzbl (%eax),%eax
  800663:	0f b6 d8             	movzbl %al,%ebx
  800666:	83 fb 25             	cmp    $0x25,%ebx
  800669:	0f 95 c0             	setne  %al
  80066c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800670:	84 c0                	test   %al,%al
  800672:	75 d2                	jne    800646 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800674:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800678:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80067f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800686:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80068d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800694:	eb 04                	jmp    80069a <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800696:	90                   	nop
  800697:	eb 01                	jmp    80069a <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800699:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069a:	8b 45 10             	mov    0x10(%ebp),%eax
  80069d:	0f b6 00             	movzbl (%eax),%eax
  8006a0:	0f b6 d8             	movzbl %al,%ebx
  8006a3:	89 d8                	mov    %ebx,%eax
  8006a5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8006a9:	83 e8 23             	sub    $0x23,%eax
  8006ac:	83 f8 55             	cmp    $0x55,%eax
  8006af:	0f 87 39 05 00 00    	ja     800bee <vprintfmt+0x5b2>
  8006b5:	8b 04 85 44 2c 80 00 	mov    0x802c44(,%eax,4),%eax
  8006bc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006be:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006c2:	eb d6                	jmp    80069a <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006c4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006c8:	eb d0                	jmp    80069a <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d4:	89 d0                	mov    %edx,%eax
  8006d6:	c1 e0 02             	shl    $0x2,%eax
  8006d9:	01 d0                	add    %edx,%eax
  8006db:	01 c0                	add    %eax,%eax
  8006dd:	01 d8                	add    %ebx,%eax
  8006df:	83 e8 30             	sub    $0x30,%eax
  8006e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e8:	0f b6 00             	movzbl (%eax),%eax
  8006eb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006ee:	83 fb 2f             	cmp    $0x2f,%ebx
  8006f1:	7e 43                	jle    800736 <vprintfmt+0xfa>
  8006f3:	83 fb 39             	cmp    $0x39,%ebx
  8006f6:	7f 3e                	jg     800736 <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006fc:	eb d3                	jmp    8006d1 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	83 c0 04             	add    $0x4,%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	83 e8 04             	sub    $0x4,%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800712:	eb 23                	jmp    800737 <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  800714:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800718:	0f 89 78 ff ff ff    	jns    800696 <vprintfmt+0x5a>
				width = 0;
  80071e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800725:	e9 6c ff ff ff       	jmp    800696 <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  80072a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800731:	e9 64 ff ff ff       	jmp    80069a <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800736:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800737:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073b:	0f 89 58 ff ff ff    	jns    800699 <vprintfmt+0x5d>
				width = precision, precision = -1;
  800741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800744:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800747:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80074e:	e9 46 ff ff ff       	jmp    800699 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800753:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  800757:	e9 3e ff ff ff       	jmp    80069a <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	83 c0 04             	add    $0x4,%eax
  800762:	89 45 14             	mov    %eax,0x14(%ebp)
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	83 e8 04             	sub    $0x4,%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800770:	89 54 24 04          	mov    %edx,0x4(%esp)
  800774:	89 04 24             	mov    %eax,(%esp)
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	ff d0                	call   *%eax
			break;
  80077c:	e9 98 04 00 00       	jmp    800c19 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  800781:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  800788:	00 
  800789:	8b 45 10             	mov    0x10(%ebp),%eax
  80078c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800790:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800793:	89 04 24             	mov    %eax,(%esp)
  800796:	e8 d1 07 00 00       	call   800f6c <memmove>
            sel_c[3] = '\0';
  80079b:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  80079f:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  8007a3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8007a7:	3c 2f                	cmp    $0x2f,%al
  8007a9:	7e 4c                	jle    8007f7 <vprintfmt+0x1bb>
  8007ab:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8007af:	3c 39                	cmp    $0x39,%al
  8007b1:	7f 44                	jg     8007f7 <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  8007b3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8007b7:	0f be d0             	movsbl %al,%edx
  8007ba:	89 d0                	mov    %edx,%eax
  8007bc:	c1 e0 02             	shl    $0x2,%eax
  8007bf:	01 d0                	add    %edx,%eax
  8007c1:	01 c0                	add    %eax,%eax
  8007c3:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8007c9:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  8007cd:	0f be c0             	movsbl %al,%eax
  8007d0:	01 c2                	add    %eax,%edx
  8007d2:	89 d0                	mov    %edx,%eax
  8007d4:	c1 e0 02             	shl    $0x2,%eax
  8007d7:	01 d0                	add    %edx,%eax
  8007d9:	01 c0                	add    %eax,%eax
  8007db:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  8007e1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  8007e5:	0f be c0             	movsbl %al,%eax
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	83 e8 30             	sub    $0x30,%eax
  8007ed:	a3 08 50 80 00       	mov    %eax,0x805008
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8007f2:	e9 22 04 00 00       	jmp    800c19 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  8007f7:	c7 44 24 04 0d 2c 80 	movl   $0x802c0d,0x4(%esp)
  8007fe:	00 
  8007ff:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800802:	89 04 24             	mov    %eax,(%esp)
  800805:	e8 36 06 00 00       	call   800e40 <strcmp>
  80080a:	85 c0                	test   %eax,%eax
  80080c:	75 0f                	jne    80081d <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  80080e:	c7 05 08 50 80 00 07 	movl   $0x7,0x805008
  800815:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800818:	e9 fc 03 00 00       	jmp    800c19 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  80081d:	c7 44 24 04 11 2c 80 	movl   $0x802c11,0x4(%esp)
  800824:	00 
  800825:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800828:	89 04 24             	mov    %eax,(%esp)
  80082b:	e8 10 06 00 00       	call   800e40 <strcmp>
  800830:	85 c0                	test   %eax,%eax
  800832:	75 0f                	jne    800843 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  800834:	c7 05 08 50 80 00 01 	movl   $0x1,0x805008
  80083b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80083e:	e9 d6 03 00 00       	jmp    800c19 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  800843:	c7 44 24 04 15 2c 80 	movl   $0x802c15,0x4(%esp)
  80084a:	00 
  80084b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80084e:	89 04 24             	mov    %eax,(%esp)
  800851:	e8 ea 05 00 00       	call   800e40 <strcmp>
  800856:	85 c0                	test   %eax,%eax
  800858:	75 0f                	jne    800869 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  80085a:	c7 05 08 50 80 00 02 	movl   $0x2,0x805008
  800861:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800864:	e9 b0 03 00 00       	jmp    800c19 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  800869:	c7 44 24 04 19 2c 80 	movl   $0x802c19,0x4(%esp)
  800870:	00 
  800871:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800874:	89 04 24             	mov    %eax,(%esp)
  800877:	e8 c4 05 00 00       	call   800e40 <strcmp>
  80087c:	85 c0                	test   %eax,%eax
  80087e:	75 0f                	jne    80088f <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  800880:	c7 05 08 50 80 00 04 	movl   $0x4,0x805008
  800887:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80088a:	e9 8a 03 00 00       	jmp    800c19 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  80088f:	c7 44 24 04 1d 2c 80 	movl   $0x802c1d,0x4(%esp)
  800896:	00 
  800897:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80089a:	89 04 24             	mov    %eax,(%esp)
  80089d:	e8 9e 05 00 00       	call   800e40 <strcmp>
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	75 0f                	jne    8008b5 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  8008a6:	c7 05 08 50 80 00 08 	movl   $0x8,0x805008
  8008ad:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8008b0:	e9 64 03 00 00       	jmp    800c19 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  8008b5:	c7 44 24 04 21 2c 80 	movl   $0x802c21,0x4(%esp)
  8008bc:	00 
  8008bd:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8008c0:	89 04 24             	mov    %eax,(%esp)
  8008c3:	e8 78 05 00 00       	call   800e40 <strcmp>
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	75 0f                	jne    8008db <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  8008cc:	c7 05 08 50 80 00 0f 	movl   $0xf,0x805008
  8008d3:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8008d6:	e9 3e 03 00 00       	jmp    800c19 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  8008db:	c7 44 24 04 25 2c 80 	movl   $0x802c25,0x4(%esp)
  8008e2:	00 
  8008e3:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8008e6:	89 04 24             	mov    %eax,(%esp)
  8008e9:	e8 52 05 00 00       	call   800e40 <strcmp>
  8008ee:	85 c0                	test   %eax,%eax
  8008f0:	75 0f                	jne    800901 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  8008f2:	c7 05 08 50 80 00 0c 	movl   $0xc,0x805008
  8008f9:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8008fc:	e9 18 03 00 00       	jmp    800c19 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  800901:	c7 44 24 04 29 2c 80 	movl   $0x802c29,0x4(%esp)
  800908:	00 
  800909:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80090c:	89 04 24             	mov    %eax,(%esp)
  80090f:	e8 2c 05 00 00       	call   800e40 <strcmp>
  800914:	85 c0                	test   %eax,%eax
  800916:	75 0f                	jne    800927 <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  800918:	c7 05 08 50 80 00 06 	movl   $0x6,0x805008
  80091f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800922:	e9 f2 02 00 00       	jmp    800c19 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  800927:	c7 44 24 04 2d 2c 80 	movl   $0x802c2d,0x4(%esp)
  80092e:	00 
  80092f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800932:	89 04 24             	mov    %eax,(%esp)
  800935:	e8 06 05 00 00       	call   800e40 <strcmp>
  80093a:	85 c0                	test   %eax,%eax
  80093c:	75 0f                	jne    80094d <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  80093e:	c7 05 08 50 80 00 0b 	movl   $0xb,0x805008
  800945:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800948:	e9 cc 02 00 00       	jmp    800c19 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  80094d:	c7 05 08 50 80 00 07 	movl   $0x7,0x805008
  800954:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800957:	e9 bd 02 00 00       	jmp    800c19 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	83 c0 04             	add    $0x4,%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80096d:	85 db                	test   %ebx,%ebx
  80096f:	79 02                	jns    800973 <vprintfmt+0x337>
				err = -err;
  800971:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800973:	83 fb 0e             	cmp    $0xe,%ebx
  800976:	7f 0b                	jg     800983 <vprintfmt+0x347>
  800978:	8b 34 9d c0 2b 80 00 	mov    0x802bc0(,%ebx,4),%esi
  80097f:	85 f6                	test   %esi,%esi
  800981:	75 23                	jne    8009a6 <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  800983:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800987:	c7 44 24 08 31 2c 80 	movl   $0x802c31,0x8(%esp)
  80098e:	00 
  80098f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800992:	89 44 24 04          	mov    %eax,0x4(%esp)
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	89 04 24             	mov    %eax,(%esp)
  80099c:	e8 86 02 00 00       	call   800c27 <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009a1:	e9 73 02 00 00       	jmp    800c19 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009a6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009aa:	c7 44 24 08 3a 2c 80 	movl   $0x802c3a,0x8(%esp)
  8009b1:	00 
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	89 04 24             	mov    %eax,(%esp)
  8009bf:	e8 63 02 00 00       	call   800c27 <printfmt>
			break;
  8009c4:	e9 50 02 00 00       	jmp    800c19 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	83 c0 04             	add    $0x4,%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	83 e8 04             	sub    $0x4,%eax
  8009d8:	8b 30                	mov    (%eax),%esi
  8009da:	85 f6                	test   %esi,%esi
  8009dc:	75 05                	jne    8009e3 <vprintfmt+0x3a7>
				p = "(null)";
  8009de:	be 3d 2c 80 00       	mov    $0x802c3d,%esi
			if (width > 0 && padc != '-')
  8009e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e7:	7e 73                	jle    800a5c <vprintfmt+0x420>
  8009e9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ed:	74 6d                	je     800a5c <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f6:	89 34 24             	mov    %esi,(%esp)
  8009f9:	e8 4c 03 00 00       	call   800d4a <strnlen>
  8009fe:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a01:	eb 17                	jmp    800a1a <vprintfmt+0x3de>
					putch(padc, putdat);
  800a03:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a0e:	89 04 24             	mov    %eax,(%esp)
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a16:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1e:	7f e3                	jg     800a03 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a20:	eb 3a                	jmp    800a5c <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  800a22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a26:	74 1f                	je     800a47 <vprintfmt+0x40b>
  800a28:	83 fb 1f             	cmp    $0x1f,%ebx
  800a2b:	7e 05                	jle    800a32 <vprintfmt+0x3f6>
  800a2d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a30:	7e 15                	jle    800a47 <vprintfmt+0x40b>
					putch('?', putdat);
  800a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a35:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a39:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	ff d0                	call   *%eax
  800a45:	eb 0f                	jmp    800a56 <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a4e:	89 1c 24             	mov    %ebx,(%esp)
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a56:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a5a:	eb 01                	jmp    800a5d <vprintfmt+0x421>
  800a5c:	90                   	nop
  800a5d:	0f b6 06             	movzbl (%esi),%eax
  800a60:	0f be d8             	movsbl %al,%ebx
  800a63:	85 db                	test   %ebx,%ebx
  800a65:	0f 95 c0             	setne  %al
  800a68:	83 c6 01             	add    $0x1,%esi
  800a6b:	84 c0                	test   %al,%al
  800a6d:	74 29                	je     800a98 <vprintfmt+0x45c>
  800a6f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a73:	78 ad                	js     800a22 <vprintfmt+0x3e6>
  800a75:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800a79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a7d:	79 a3                	jns    800a22 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a7f:	eb 17                	jmp    800a98 <vprintfmt+0x45c>
				putch(' ', putdat);
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a88:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a94:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800a98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9c:	7f e3                	jg     800a81 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  800a9e:	e9 76 01 00 00       	jmp    800c19 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aaa:	8d 45 14             	lea    0x14(%ebp),%eax
  800aad:	89 04 24             	mov    %eax,(%esp)
  800ab0:	e8 20 fb ff ff       	call   8005d5 <getint>
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac1:	85 d2                	test   %edx,%edx
  800ac3:	79 26                	jns    800aeb <vprintfmt+0x4af>
				putch('-', putdat);
  800ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800acc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
				num = -(long long) num;
  800ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ade:	f7 d8                	neg    %eax
  800ae0:	83 d2 00             	adc    $0x0,%edx
  800ae3:	f7 da                	neg    %edx
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aeb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af2:	e9 ae 00 00 00       	jmp    800ba5 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	89 04 24             	mov    %eax,(%esp)
  800b04:	e8 65 fa ff ff       	call   80056e <getuint>
  800b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b16:	e9 8a 00 00 00       	jmp    800ba5 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  800b1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b22:	8d 45 14             	lea    0x14(%ebp),%eax
  800b25:	89 04 24             	mov    %eax,(%esp)
  800b28:	e8 41 fa ff ff       	call   80056e <getuint>
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  800b33:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  800b3a:	eb 69                	jmp    800ba5 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b43:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	ff d0                	call   *%eax
			putch('x', putdat);
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b56:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	83 c0 04             	add    $0x4,%eax
  800b68:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	83 e8 04             	sub    $0x4,%eax
  800b71:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b84:	eb 1f                	jmp    800ba5 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b8d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b90:	89 04 24             	mov    %eax,(%esp)
  800b93:	e8 d6 f9 ff ff       	call   80056e <getuint>
  800b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ba5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bac:	89 54 24 18          	mov    %edx,0x18(%esp)
  800bb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800bb3:	89 54 24 14          	mov    %edx,0x14(%esp)
  800bb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 04 24             	mov    %eax,(%esp)
  800bd6:	e8 b5 f8 ff ff       	call   800490 <printnum>
			break;
  800bdb:	eb 3c                	jmp    800c19 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be4:	89 1c 24             	mov    %ebx,(%esp)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	ff d0                	call   *%eax
			break;
  800bec:	eb 2b                	jmp    800c19 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c01:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c05:	eb 04                	jmp    800c0b <vprintfmt+0x5cf>
  800c07:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	83 e8 01             	sub    $0x1,%eax
  800c11:	0f b6 00             	movzbl (%eax),%eax
  800c14:	3c 25                	cmp    $0x25,%al
  800c16:	75 ef                	jne    800c07 <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800c18:	90                   	nop
		}
	}
  800c19:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c1a:	e9 3e fa ff ff       	jmp    80065d <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800c1f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c20:	83 c4 50             	add    $0x50,%esp
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c30:	83 c0 04             	add    $0x4,%eax
  800c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c36:	8b 45 10             	mov    0x10(%ebp),%eax
  800c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c40:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	89 04 24             	mov    %eax,(%esp)
  800c51:	e8 e6 f9 ff ff       	call   80063c <vprintfmt>
	va_end(ap);
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5e:	8b 40 08             	mov    0x8(%eax),%eax
  800c61:	8d 50 01             	lea    0x1(%eax),%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	8b 10                	mov    (%eax),%edx
  800c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c72:	8b 40 04             	mov    0x4(%eax),%eax
  800c75:	39 c2                	cmp    %eax,%edx
  800c77:	73 12                	jae    800c8b <sprintputch+0x33>
		*b->buf++ = ch;
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8b 00                	mov    (%eax),%eax
  800c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c81:	88 10                	mov    %dl,(%eax)
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 10                	mov    %edx,(%eax)
}
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	83 e8 01             	sub    $0x1,%eax
  800c9f:	03 45 08             	add    0x8(%ebp),%eax
  800ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cb0:	74 06                	je     800cb8 <vsnprintf+0x2b>
  800cb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb6:	7f 07                	jg     800cbf <vsnprintf+0x32>
		return -E_INVAL;
  800cb8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cbd:	eb 2a                	jmp    800ce9 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ccd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd4:	c7 04 24 58 0c 80 00 	movl   $0x800c58,(%esp)
  800cdb:	e8 5c f9 ff ff       	call   80063c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ce9:	c9                   	leave  
  800cea:	c3                   	ret    

00800ceb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cf1:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf4:	83 c0 04             	add    $0x4,%eax
  800cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d00:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d04:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 04 24             	mov    %eax,(%esp)
  800d15:	e8 73 ff ff ff       	call   800c8d <vsnprintf>
  800d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    
	...

00800d24 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d31:	eb 08                	jmp    800d3b <strlen+0x17>
		n++;
  800d33:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d37:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	0f b6 00             	movzbl (%eax),%eax
  800d41:	84 c0                	test   %al,%al
  800d43:	75 ee                	jne    800d33 <strlen+0xf>
		n++;
	return n;
  800d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d48:	c9                   	leave  
  800d49:	c3                   	ret    

00800d4a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d57:	eb 0c                	jmp    800d65 <strnlen+0x1b>
		n++;
  800d59:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d61:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 0a                	je     800d75 <strnlen+0x2b>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	0f b6 00             	movzbl (%eax),%eax
  800d71:	84 c0                	test   %al,%al
  800d73:	75 e4                	jne    800d59 <strnlen+0xf>
		n++;
	return n;
  800d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d86:	90                   	nop
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	0f b6 10             	movzbl (%eax),%edx
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	88 10                	mov    %dl,(%eax)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	0f b6 00             	movzbl (%eax),%eax
  800d98:	84 c0                	test   %al,%al
  800d9a:	0f 95 c0             	setne  %al
  800d9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800da1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800da5:	84 c0                	test   %al,%al
  800da7:	75 de                	jne    800d87 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc1:	eb 21                	jmp    800de4 <strncpy+0x36>
		*dst++ = *src;
  800dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc6:	0f b6 10             	movzbl (%eax),%edx
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	88 10                	mov    %dl,(%eax)
  800dce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	0f b6 00             	movzbl (%eax),%eax
  800dd8:	84 c0                	test   %al,%al
  800dda:	74 04                	je     800de0 <strncpy+0x32>
			src++;
  800ddc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dea:	72 d7                	jb     800dc3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e01:	74 2f                	je     800e32 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800e03:	eb 13                	jmp    800e18 <strlcpy+0x27>
			*dst++ = *src++;
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	0f b6 10             	movzbl (%eax),%edx
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	88 10                	mov    %dl,(%eax)
  800e10:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e14:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e18:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e20:	74 0a                	je     800e2c <strlcpy+0x3b>
  800e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e25:	0f b6 00             	movzbl (%eax),%eax
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 d9                	jne    800e05 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e38:	89 d1                	mov    %edx,%ecx
  800e3a:	29 c1                	sub    %eax,%ecx
  800e3c:	89 c8                	mov    %ecx,%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e43:	eb 08                	jmp    800e4d <strcmp+0xd>
		p++, q++;
  800e45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e49:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	0f b6 00             	movzbl (%eax),%eax
  800e53:	84 c0                	test   %al,%al
  800e55:	74 10                	je     800e67 <strcmp+0x27>
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	0f b6 10             	movzbl (%eax),%edx
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	0f b6 00             	movzbl (%eax),%eax
  800e63:	38 c2                	cmp    %al,%dl
  800e65:	74 de                	je     800e45 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	0f b6 00             	movzbl (%eax),%eax
  800e6d:	0f b6 d0             	movzbl %al,%edx
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	0f b6 00             	movzbl (%eax),%eax
  800e76:	0f b6 c0             	movzbl %al,%eax
  800e79:	89 d1                	mov    %edx,%ecx
  800e7b:	29 c1                	sub    %eax,%ecx
  800e7d:	89 c8                	mov    %ecx,%eax
}
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e84:	eb 0c                	jmp    800e92 <strncmp+0x11>
		n--, p++, q++;
  800e86:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800e8a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e8e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e96:	74 1a                	je     800eb2 <strncmp+0x31>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	0f b6 00             	movzbl (%eax),%eax
  800e9e:	84 c0                	test   %al,%al
  800ea0:	74 10                	je     800eb2 <strncmp+0x31>
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	0f b6 10             	movzbl (%eax),%edx
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	0f b6 00             	movzbl (%eax),%eax
  800eae:	38 c2                	cmp    %al,%dl
  800eb0:	74 d4                	je     800e86 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb6:	75 07                	jne    800ebf <strncmp+0x3e>
		return 0;
  800eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebd:	eb 18                	jmp    800ed7 <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	0f b6 00             	movzbl (%eax),%eax
  800ec5:	0f b6 d0             	movzbl %al,%edx
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	0f b6 00             	movzbl (%eax),%eax
  800ece:	0f b6 c0             	movzbl %al,%eax
  800ed1:	89 d1                	mov    %edx,%ecx
  800ed3:	29 c1                	sub    %eax,%ecx
  800ed5:	89 c8                	mov    %ecx,%eax
}
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 04             	sub    $0x4,%esp
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee5:	eb 14                	jmp    800efb <strchr+0x22>
		if (*s == c)
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	0f b6 00             	movzbl (%eax),%eax
  800eed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef0:	75 05                	jne    800ef7 <strchr+0x1e>
			return (char *) s;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	eb 13                	jmp    800f0a <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	0f b6 00             	movzbl (%eax),%eax
  800f01:	84 c0                	test   %al,%al
  800f03:	75 e2                	jne    800ee7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 04             	sub    $0x4,%esp
  800f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f15:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f18:	eb 0f                	jmp    800f29 <strfind+0x1d>
		if (*s == c)
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	0f b6 00             	movzbl (%eax),%eax
  800f20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f23:	74 10                	je     800f35 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	0f b6 00             	movzbl (%eax),%eax
  800f2f:	84 c0                	test   %al,%al
  800f31:	75 e7                	jne    800f1a <strfind+0xe>
  800f33:	eb 01                	jmp    800f36 <strfind+0x2a>
		if (*s == c)
			break;
  800f35:	90                   	nop
	return (char *) s;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <memset>:


void *
memset(void *v, int c, size_t n)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f4d:	eb 0e                	jmp    800f5d <memset+0x22>
		*p++ = c;
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	88 10                	mov    %dl,(%eax)
  800f59:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f5d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800f61:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f65:	79 e8                	jns    800f4f <memset+0x14>
		*p++ = c;

	return v;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6a:	c9                   	leave  
  800f6b:	c3                   	ret    

00800f6c <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	73 54                	jae    800fda <memmove+0x6e>
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8c:	01 d0                	add    %edx,%eax
  800f8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f91:	76 47                	jbe    800fda <memmove+0x6e>
		s += n;
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9f:	eb 13                	jmp    800fb4 <memmove+0x48>
			*--d = *--s;
  800fa1:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  800fa5:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  800fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fac:	0f b6 10             	movzbl (%eax),%edx
  800faf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb8:	0f 95 c0             	setne  %al
  800fbb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 de                	jne    800fa1 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc3:	eb 25                	jmp    800fea <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc8:	0f b6 10             	movzbl (%eax),%edx
  800fcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fce:	88 10                	mov    %dl,(%eax)
  800fd0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800fd4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800fd8:	eb 01                	jmp    800fdb <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fda:	90                   	nop
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	0f 95 c0             	setne  %al
  800fe2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800fe6:	84 c0                	test   %al,%al
  800fe8:	75 db                	jne    800fc5 <memmove+0x59>
			*d++ = *s++;

	return dst;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	89 04 24             	mov    %eax,(%esp)
  801009:	e8 5e ff ff ff       	call   800f6c <memmove>
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801022:	eb 32                	jmp    801056 <memcmp+0x46>
		if (*s1 != *s2)
  801024:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801027:	0f b6 10             	movzbl (%eax),%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	0f b6 00             	movzbl (%eax),%eax
  801030:	38 c2                	cmp    %al,%dl
  801032:	74 1a                	je     80104e <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801037:	0f b6 00             	movzbl (%eax),%eax
  80103a:	0f b6 d0             	movzbl %al,%edx
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	0f b6 00             	movzbl (%eax),%eax
  801043:	0f b6 c0             	movzbl %al,%eax
  801046:	89 d1                	mov    %edx,%ecx
  801048:	29 c1                	sub    %eax,%ecx
  80104a:	89 c8                	mov    %ecx,%eax
  80104c:	eb 1c                	jmp    80106a <memcmp+0x5a>
		s1++, s2++;
  80104e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801052:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801056:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105a:	0f 95 c0             	setne  %al
  80105d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  801061:	84 c0                	test   %al,%al
  801063:	75 bf                	jne    801024 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	01 d0                	add    %edx,%eax
  80107a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80107d:	eb 11                	jmp    801090 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	0f b6 10             	movzbl (%eax),%edx
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	38 c2                	cmp    %al,%dl
  80108a:	74 0e                	je     80109a <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801096:	72 e7                	jb     80107f <memfind+0x13>
  801098:	eb 01                	jmp    80109b <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80109a:	90                   	nop
	return (void *) s;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109e:	c9                   	leave  
  80109f:	c3                   	ret    

008010a0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b4:	eb 04                	jmp    8010ba <strtol+0x1a>
		s++;
  8010b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	0f b6 00             	movzbl (%eax),%eax
  8010c0:	3c 20                	cmp    $0x20,%al
  8010c2:	74 f2                	je     8010b6 <strtol+0x16>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	0f b6 00             	movzbl (%eax),%eax
  8010ca:	3c 09                	cmp    $0x9,%al
  8010cc:	74 e8                	je     8010b6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	0f b6 00             	movzbl (%eax),%eax
  8010d4:	3c 2b                	cmp    $0x2b,%al
  8010d6:	75 06                	jne    8010de <strtol+0x3e>
		s++;
  8010d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8010dc:	eb 15                	jmp    8010f3 <strtol+0x53>
	else if (*s == '-')
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	0f b6 00             	movzbl (%eax),%eax
  8010e4:	3c 2d                	cmp    $0x2d,%al
  8010e6:	75 0b                	jne    8010f3 <strtol+0x53>
		s++, neg = 1;
  8010e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8010ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f7:	74 06                	je     8010ff <strtol+0x5f>
  8010f9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010fd:	75 24                	jne    801123 <strtol+0x83>
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	0f b6 00             	movzbl (%eax),%eax
  801105:	3c 30                	cmp    $0x30,%al
  801107:	75 1a                	jne    801123 <strtol+0x83>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	83 c0 01             	add    $0x1,%eax
  80110f:	0f b6 00             	movzbl (%eax),%eax
  801112:	3c 78                	cmp    $0x78,%al
  801114:	75 0d                	jne    801123 <strtol+0x83>
		s += 2, base = 16;
  801116:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80111a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801121:	eb 2a                	jmp    80114d <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  801123:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801127:	75 17                	jne    801140 <strtol+0xa0>
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	0f b6 00             	movzbl (%eax),%eax
  80112f:	3c 30                	cmp    $0x30,%al
  801131:	75 0d                	jne    801140 <strtol+0xa0>
		s++, base = 8;
  801133:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801137:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80113e:	eb 0d                	jmp    80114d <strtol+0xad>
	else if (base == 0)
  801140:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801144:	75 07                	jne    80114d <strtol+0xad>
		base = 10;
  801146:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	0f b6 00             	movzbl (%eax),%eax
  801153:	3c 2f                	cmp    $0x2f,%al
  801155:	7e 1b                	jle    801172 <strtol+0xd2>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	0f b6 00             	movzbl (%eax),%eax
  80115d:	3c 39                	cmp    $0x39,%al
  80115f:	7f 11                	jg     801172 <strtol+0xd2>
			dig = *s - '0';
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	0f b6 00             	movzbl (%eax),%eax
  801167:	0f be c0             	movsbl %al,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801170:	eb 48                	jmp    8011ba <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	0f b6 00             	movzbl (%eax),%eax
  801178:	3c 60                	cmp    $0x60,%al
  80117a:	7e 1b                	jle    801197 <strtol+0xf7>
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	0f b6 00             	movzbl (%eax),%eax
  801182:	3c 7a                	cmp    $0x7a,%al
  801184:	7f 11                	jg     801197 <strtol+0xf7>
			dig = *s - 'a' + 10;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	0f b6 00             	movzbl (%eax),%eax
  80118c:	0f be c0             	movsbl %al,%eax
  80118f:	83 e8 57             	sub    $0x57,%eax
  801192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801195:	eb 23                	jmp    8011ba <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	0f b6 00             	movzbl (%eax),%eax
  80119d:	3c 40                	cmp    $0x40,%al
  80119f:	7e 38                	jle    8011d9 <strtol+0x139>
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	0f b6 00             	movzbl (%eax),%eax
  8011a7:	3c 5a                	cmp    $0x5a,%al
  8011a9:	7f 2e                	jg     8011d9 <strtol+0x139>
			dig = *s - 'A' + 10;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	0f b6 00             	movzbl (%eax),%eax
  8011b1:	0f be c0             	movsbl %al,%eax
  8011b4:	83 e8 37             	sub    $0x37,%eax
  8011b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011c0:	7d 16                	jge    8011d8 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  8011c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8011c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011cd:	03 45 f4             	add    -0xc(%ebp),%eax
  8011d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011d3:	e9 75 ff ff ff       	jmp    80114d <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011d8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011dd:	74 08                	je     8011e7 <strtol+0x147>
		*endptr = (char *) s;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011eb:	74 07                	je     8011f4 <strtol+0x154>
  8011ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f0:	f7 d8                	neg    %eax
  8011f2:	eb 03                	jmp    8011f7 <strtol+0x157>
  8011f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    
  8011f9:	00 00                	add    %al,(%eax)
	...

008011fc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	57                   	push   %edi
  801200:	56                   	push   %esi
  801201:	53                   	push   %ebx
  801202:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80120b:	8b 55 10             	mov    0x10(%ebp),%edx
  80120e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801211:	8b 5d 18             	mov    0x18(%ebp),%ebx
  801214:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  801217:	8b 75 20             	mov    0x20(%ebp),%esi
  80121a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80121d:	cd 30                	int    $0x30
  80121f:	89 c3                	mov    %eax,%ebx
  801221:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801224:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801228:	74 30                	je     80125a <syscall+0x5e>
  80122a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80122e:	7e 2a                	jle    80125a <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  801230:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801233:	89 44 24 10          	mov    %eax,0x10(%esp)
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80123e:	c7 44 24 08 9c 2d 80 	movl   $0x802d9c,0x8(%esp)
  801245:	00 
  801246:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80124d:	00 
  80124e:	c7 04 24 b9 2d 80 00 	movl   $0x802db9,(%esp)
  801255:	e8 da f0 ff ff       	call   800334 <_panic>

	return ret;
  80125a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80125d:	83 c4 4c             	add    $0x4c,%esp
  801260:	5b                   	pop    %ebx
  801261:	5e                   	pop    %esi
  801262:	5f                   	pop    %edi
  801263:	5d                   	pop    %ebp
  801264:	c3                   	ret    

00801265 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801275:	00 
  801276:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80127d:	00 
  80127e:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801285:	00 
  801286:	8b 55 0c             	mov    0xc(%ebp),%edx
  801289:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80128d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801291:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801298:	00 
  801299:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a0:	e8 57 ff ff ff       	call   8011fc <syscall>
}
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8012ad:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012b4:	00 
  8012b5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012bc:	00 
  8012bd:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8012c4:	00 
  8012c5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8012cc:	00 
  8012cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012d4:	00 
  8012d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8012dc:	00 
  8012dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8012e4:	e8 13 ff ff ff       	call   8011fc <syscall>
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8012fb:	00 
  8012fc:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801303:	00 
  801304:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80130b:	00 
  80130c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801313:	00 
  801314:	89 44 24 08          	mov    %eax,0x8(%esp)
  801318:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80131f:	00 
  801320:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  801327:	e8 d0 fe ff ff       	call   8011fc <syscall>
}
  80132c:	c9                   	leave  
  80132d:	c3                   	ret    

0080132e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801334:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80133b:	00 
  80133c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801343:	00 
  801344:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80134b:	00 
  80134c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801353:	00 
  801354:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80135b:	00 
  80135c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801363:	00 
  801364:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80136b:	e8 8c fe ff ff       	call   8011fc <syscall>
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_yield>:

void
sys_yield(void)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801378:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80137f:	00 
  801380:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801387:	00 
  801388:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80138f:	00 
  801390:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801397:	00 
  801398:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80139f:	00 
  8013a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8013a7:	00 
  8013a8:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8013af:	e8 48 fe ff ff       	call   8011fc <syscall>
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8013bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013cc:	00 
  8013cd:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013d4:	00 
  8013d5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8013d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8013e8:	00 
  8013e9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8013f0:	e8 07 fe ff ff       	call   8011fc <syscall>
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	56                   	push   %esi
  8013fb:	53                   	push   %ebx
  8013fc:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8013ff:	8b 75 18             	mov    0x18(%ebp),%esi
  801402:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801405:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801408:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	89 74 24 18          	mov    %esi,0x18(%esp)
  801412:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  801416:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80141a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80141e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801422:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801429:	00 
  80142a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  801431:	e8 c6 fd ff ff       	call   8011fc <syscall>
}
  801436:	83 c4 20             	add    $0x20,%esp
  801439:	5b                   	pop    %ebx
  80143a:	5e                   	pop    %esi
  80143b:	5d                   	pop    %ebp
  80143c:	c3                   	ret    

0080143d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801450:	00 
  801451:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801458:	00 
  801459:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801460:	00 
  801461:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801465:	89 44 24 08          	mov    %eax,0x8(%esp)
  801469:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801470:	00 
  801471:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  801478:	e8 7f fd ff ff       	call   8011fc <syscall>
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  801485:	8b 55 0c             	mov    0xc(%ebp),%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801492:	00 
  801493:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80149a:	00 
  80149b:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8014a2:	00 
  8014a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014b2:	00 
  8014b3:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  8014ba:	e8 3d fd ff ff       	call   8011fc <syscall>
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8014d4:	00 
  8014d5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8014dc:	00 
  8014dd:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8014e4:	00 
  8014e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014f4:	00 
  8014f5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8014fc:	e8 fb fc ff ff       	call   8011fc <syscall>
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  801509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801516:	00 
  801517:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80151e:	00 
  80151f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801526:	00 
  801527:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80152b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80152f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801536:	00 
  801537:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  80153e:	e8 b9 fc ff ff       	call   8011fc <syscall>
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80154b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801558:	00 
  801559:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801560:	00 
  801561:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801568:	00 
  801569:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80156d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801571:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801578:	00 
  801579:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801580:	e8 77 fc ff ff       	call   8011fc <syscall>
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  80158d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801590:	8b 55 10             	mov    0x10(%ebp),%edx
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80159d:	00 
  80159e:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8015a2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015b8:	00 
  8015b9:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  8015c0:	e8 37 fc ff ff       	call   8011fc <syscall>
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8015d7:	00 
  8015d8:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8015df:	00 
  8015e0:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8015e7:	00 
  8015e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8015ef:	00 
  8015f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015fb:	00 
  8015fc:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  801603:	e8 f4 fb ff ff       	call   8011fc <syscall>
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    
	...

0080160c <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 04 24             	mov    %eax,(%esp)
  801618:	e8 0a 00 00 00       	call   801627 <fd2num>
  80161d:	05 40 03 00 00       	add    $0x340,%eax
  801622:	c1 e0 16             	shl    $0x16,%eax
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	05 00 00 40 30       	add    $0x30400000,%eax
  801632:	c1 e8 0c             	shr    $0xc,%eax
}
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    

00801637 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  80163d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801644:	eb 49                	jmp    80168f <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  801646:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801649:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  80164e:	c1 e0 0c             	shl    $0xc,%eax
  801651:	89 c2                	mov    %eax,%edx
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8b 00                	mov    (%eax),%eax
  80165d:	c1 e8 16             	shr    $0x16,%eax
  801660:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801667:	83 e0 01             	and    $0x1,%eax
  80166a:	85 c0                	test   %eax,%eax
  80166c:	74 16                	je     801684 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	8b 00                	mov    (%eax),%eax
  801673:	c1 e8 0c             	shr    $0xc,%eax
  801676:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80167d:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  801680:	85 c0                	test   %eax,%eax
  801682:	75 07                	jne    80168b <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
  801689:	eb 18                	jmp    8016a3 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  80168b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  80168f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  801693:	7e b1                	jle    801646 <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  80169e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  8016ab:	c7 44 24 08 c8 2d 80 	movl   $0x802dc8,0x8(%esp)
  8016b2:	00 
  8016b3:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8016ba:	00 
  8016bb:	c7 04 24 e2 2d 80 00 	movl   $0x802de2,(%esp)
  8016c2:	e8 6d ec ff ff       	call   800334 <_panic>

008016c7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	89 04 24             	mov    %eax,(%esp)
  8016d3:	e8 4f ff ff ff       	call   801627 <fd2num>
  8016d8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8016db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016df:	89 04 24             	mov    %eax,(%esp)
  8016e2:	e8 be ff ff ff       	call   8016a5 <fd_lookup>
  8016e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ee:	78 08                	js     8016f8 <fd_close+0x31>
	    || fd != fd2)
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	39 45 08             	cmp    %eax,0x8(%ebp)
  8016f6:	74 12                	je     80170a <fd_close+0x43>
		return (must_exist ? r : 0);
  8016f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016fc:	74 05                	je     801703 <fd_close+0x3c>
  8016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801701:	eb 05                	jmp    801708 <fd_close+0x41>
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	eb 44                	jmp    80174e <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	8b 00                	mov    (%eax),%eax
  80170f:	8d 55 ec             	lea    -0x14(%ebp),%edx
  801712:	89 54 24 04          	mov    %edx,0x4(%esp)
  801716:	89 04 24             	mov    %eax,(%esp)
  801719:	e8 32 00 00 00       	call   801750 <dev_lookup>
  80171e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801721:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801725:	78 11                	js     801738 <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  801727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172a:	8b 50 10             	mov    0x10(%eax),%edx
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	89 04 24             	mov    %eax,(%esp)
  801733:	ff d2                	call   *%edx
  801735:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801746:	e8 f2 fc ff ff       	call   80143d <sys_page_unmap>
	return r;
  80174b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  801756:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80175d:	eb 2b                	jmp    80178a <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  80175f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801762:	8b 04 85 0c 50 80 00 	mov    0x80500c(,%eax,4),%eax
  801769:	8b 00                	mov    (%eax),%eax
  80176b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80176e:	75 16                	jne    801786 <dev_lookup+0x36>
			*dev = devtab[i];
  801770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801773:	8b 14 85 0c 50 80 00 	mov    0x80500c(,%eax,4),%edx
  80177a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177d:	89 10                	mov    %edx,(%eax)
			return 0;
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	eb 3f                	jmp    8017c5 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801786:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  80178a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178d:	8b 04 85 0c 50 80 00 	mov    0x80500c(,%eax,4),%eax
  801794:	85 c0                	test   %eax,%eax
  801796:	75 c7                	jne    80175f <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801798:	a1 40 50 80 00       	mov    0x805040,%eax
  80179d:	8b 40 4c             	mov    0x4c(%eax),%eax
  8017a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ab:	c7 04 24 ec 2d 80 00 	movl   $0x802dec,(%esp)
  8017b2:	e8 b1 ec ff ff       	call   800468 <cprintf>
	*dev = 0;
  8017b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <close>:

int
close(int fdnum)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 04 24             	mov    %eax,(%esp)
  8017da:	e8 c6 fe ff ff       	call   8016a5 <fd_lookup>
  8017df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e6:	79 05                	jns    8017ed <close+0x26>
		return r;
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	eb 13                	jmp    801800 <close+0x39>
	else
		return fd_close(fd, 1);
  8017ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017f7:	00 
  8017f8:	89 04 24             	mov    %eax,(%esp)
  8017fb:	e8 c7 fe ff ff       	call   8016c7 <fd_close>
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <close_all>:

void
close_all(void)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80180f:	eb 0f                	jmp    801820 <close_all+0x1e>
		close(i);
  801811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801814:	89 04 24             	mov    %eax,(%esp)
  801817:	e8 ab ff ff ff       	call   8017c7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80181c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801820:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  801824:	7e eb                	jle    801811 <close_all+0xf>
		close(i);
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80182e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801831:	89 44 24 04          	mov    %eax,0x4(%esp)
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	89 04 24             	mov    %eax,(%esp)
  80183b:	e8 65 fe ff ff       	call   8016a5 <fd_lookup>
  801840:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801847:	79 08                	jns    801851 <dup+0x29>
		return r;
  801849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184c:	e9 54 01 00 00       	jmp    8019a5 <dup+0x17d>
	close(newfdnum);
  801851:	8b 45 0c             	mov    0xc(%ebp),%eax
  801854:	89 04 24             	mov    %eax,(%esp)
  801857:	e8 6b ff ff ff       	call   8017c7 <close>

	newfd = INDEX2FD(newfdnum);
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  801864:	c1 e0 0c             	shl    $0xc,%eax
  801867:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  80186a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80186d:	89 04 24             	mov    %eax,(%esp)
  801870:	e8 97 fd ff ff       	call   80160c <fd2data>
  801875:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  801878:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187b:	89 04 24             	mov    %eax,(%esp)
  80187e:	e8 89 fd ff ff       	call   80160c <fd2data>
  801883:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801886:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801889:	c1 e8 0c             	shr    $0xc,%eax
  80188c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801893:	89 c2                	mov    %eax,%edx
  801895:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80189b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80189e:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8018a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018b0:	00 
  8018b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018bc:	e8 36 fb ff ff       	call   8013f7 <sys_page_map>
  8018c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018c8:	0f 88 8e 00 00 00    	js     80195c <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  8018ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d1:	c1 e8 16             	shr    $0x16,%eax
  8018d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	74 78                	je     801957 <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8018df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8018e6:	eb 66                	jmp    80194e <dup+0x126>
			pte = vpt[VPN(ova + i)];
  8018e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018eb:	03 45 e8             	add    -0x18(%ebp),%eax
  8018ee:	c1 e8 0c             	shr    $0xc,%eax
  8018f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  8018fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018fe:	83 e0 01             	and    $0x1,%eax
  801901:	84 c0                	test   %al,%al
  801903:	74 42                	je     801947 <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801905:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801908:	89 c1                	mov    %eax,%ecx
  80190a:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	89 c2                	mov    %eax,%edx
  801915:	03 55 e4             	add    -0x1c(%ebp),%edx
  801918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191b:	03 45 e8             	add    -0x18(%ebp),%eax
  80191e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801922:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801926:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80192d:	00 
  80192e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801932:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801939:	e8 b9 fa ff ff       	call   8013f7 <sys_page_map>
  80193e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801941:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801945:	78 18                	js     80195f <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801947:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80194e:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801955:	7e 91                	jle    8018e8 <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	eb 49                	jmp    8019a5 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  80195c:	90                   	nop
  80195d:	eb 01                	jmp    801960 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  80195f:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801963:	89 44 24 04          	mov    %eax,0x4(%esp)
  801967:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80196e:	e8 ca fa ff ff       	call   80143d <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801973:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80197a:	eb 1d                	jmp    801999 <dup+0x171>
		sys_page_unmap(0, nva + i);
  80197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197f:	03 45 e4             	add    -0x1c(%ebp),%eax
  801982:	89 44 24 04          	mov    %eax,0x4(%esp)
  801986:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198d:	e8 ab fa ff ff       	call   80143d <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801992:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801999:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  8019a0:	7e da                	jle    80197c <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  8019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8019b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	89 04 24             	mov    %eax,(%esp)
  8019ba:	e8 e6 fc ff ff       	call   8016a5 <fd_lookup>
  8019bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019c6:	78 1d                	js     8019e5 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cb:	8b 00                	mov    (%eax),%eax
  8019cd:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8019d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019d4:	89 04 24             	mov    %eax,(%esp)
  8019d7:	e8 74 fd ff ff       	call   801750 <dev_lookup>
  8019dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019e3:	79 05                	jns    8019ea <read+0x43>
		return r;
  8019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e8:	eb 75                	jmp    801a5f <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ed:	8b 40 08             	mov    0x8(%eax),%eax
  8019f0:	83 e0 03             	and    $0x3,%eax
  8019f3:	83 f8 01             	cmp    $0x1,%eax
  8019f6:	75 26                	jne    801a1e <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8019f8:	a1 40 50 80 00       	mov    0x805040,%eax
  8019fd:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a00:	8b 55 08             	mov    0x8(%ebp),%edx
  801a03:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0b:	c7 04 24 0b 2e 80 00 	movl   $0x802e0b,(%esp)
  801a12:	e8 51 ea ff ff       	call   800468 <cprintf>
		return -E_INVAL;
  801a17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a1c:	eb 41                	jmp    801a5f <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a21:	8b 48 08             	mov    0x8(%eax),%ecx
  801a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a27:	8b 50 04             	mov    0x4(%eax),%edx
  801a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a2d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a31:	8b 55 10             	mov    0x10(%ebp),%edx
  801a34:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a3f:	89 04 24             	mov    %eax,(%esp)
  801a42:	ff d1                	call   *%ecx
  801a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  801a47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a4b:	78 0f                	js     801a5c <read+0xb5>
		fd->fd_offset += r;
  801a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a53:	8b 52 04             	mov    0x4(%edx),%edx
  801a56:	03 55 f4             	add    -0xc(%ebp),%edx
  801a59:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801a6e:	eb 3b                	jmp    801aab <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a73:	8b 55 10             	mov    0x10(%ebp),%edx
  801a76:	29 c2                	sub    %eax,%edx
  801a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7b:	03 45 0c             	add    0xc(%ebp),%eax
  801a7e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	89 04 24             	mov    %eax,(%esp)
  801a8c:	e8 16 ff ff ff       	call   8019a7 <read>
  801a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  801a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a98:	79 05                	jns    801a9f <readn+0x3e>
			return m;
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	eb 1a                	jmp    801ab9 <readn+0x58>
		if (m == 0)
  801a9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aa3:	74 10                	je     801ab5 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa8:	01 45 f4             	add    %eax,-0xc(%ebp)
  801aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aae:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ab1:	72 bd                	jb     801a70 <readn+0xf>
  801ab3:	eb 01                	jmp    801ab6 <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  801ab5:	90                   	nop
	}
	return tot;
  801ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ac1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 04 24             	mov    %eax,(%esp)
  801ace:	e8 d2 fb ff ff       	call   8016a5 <fd_lookup>
  801ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ada:	78 1d                	js     801af9 <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801adf:	8b 00                	mov    (%eax),%eax
  801ae1:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801ae4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ae8:	89 04 24             	mov    %eax,(%esp)
  801aeb:	e8 60 fc ff ff       	call   801750 <dev_lookup>
  801af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801af7:	79 05                	jns    801afe <write+0x43>
		return r;
  801af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afc:	eb 74                	jmp    801b72 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b01:	8b 40 08             	mov    0x8(%eax),%eax
  801b04:	83 e0 03             	and    $0x3,%eax
  801b07:	85 c0                	test   %eax,%eax
  801b09:	75 26                	jne    801b31 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801b0b:	a1 40 50 80 00       	mov    0x805040,%eax
  801b10:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b13:	8b 55 08             	mov    0x8(%ebp),%edx
  801b16:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1e:	c7 04 24 27 2e 80 00 	movl   $0x802e27,(%esp)
  801b25:	e8 3e e9 ff ff       	call   800468 <cprintf>
		return -E_INVAL;
  801b2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2f:	eb 41                	jmp    801b72 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b34:	8b 48 0c             	mov    0xc(%eax),%ecx
  801b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3a:	8b 50 04             	mov    0x4(%eax),%edx
  801b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b40:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801b44:	8b 55 10             	mov    0x10(%ebp),%edx
  801b47:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b52:	89 04 24             	mov    %eax,(%esp)
  801b55:	ff d1                	call   *%ecx
  801b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  801b5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b5e:	7e 0f                	jle    801b6f <write+0xb4>
		fd->fd_offset += r;
  801b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b66:	8b 52 04             	mov    0x4(%edx),%edx
  801b69:	03 55 f4             	add    -0xc(%ebp),%edx
  801b6c:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	89 04 24             	mov    %eax,(%esp)
  801b87:	e8 19 fb ff ff       	call   8016a5 <fd_lookup>
  801b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b93:	79 05                	jns    801b9a <seek+0x26>
		return r;
  801b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b98:	eb 0e                	jmp    801ba8 <seek+0x34>
	fd->fd_offset = offset;
  801b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bb0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	89 04 24             	mov    %eax,(%esp)
  801bbd:	e8 e3 fa ff ff       	call   8016a5 <fd_lookup>
  801bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bc9:	78 1d                	js     801be8 <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bce:	8b 00                	mov    (%eax),%eax
  801bd0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801bd3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bd7:	89 04 24             	mov    %eax,(%esp)
  801bda:	e8 71 fb ff ff       	call   801750 <dev_lookup>
  801bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be6:	79 05                	jns    801bed <ftruncate+0x43>
		return r;
  801be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801beb:	eb 48                	jmp    801c35 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf0:	8b 40 08             	mov    0x8(%eax),%eax
  801bf3:	83 e0 03             	and    $0x3,%eax
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	75 26                	jne    801c20 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801bfa:	a1 40 50 80 00       	mov    0x805040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bff:	8b 40 4c             	mov    0x4c(%eax),%eax
  801c02:	8b 55 08             	mov    0x8(%ebp),%edx
  801c05:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0d:	c7 04 24 44 2e 80 00 	movl   $0x802e44,(%esp)
  801c14:	e8 4f e8 ff ff       	call   800468 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801c19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c1e:	eb 15                	jmp    801c35 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c23:	8b 48 1c             	mov    0x1c(%eax),%ecx
  801c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c30:	89 04 24             	mov    %eax,(%esp)
  801c33:	ff d1                	call   *%ecx
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c3d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	89 04 24             	mov    %eax,(%esp)
  801c4a:	e8 56 fa ff ff       	call   8016a5 <fd_lookup>
  801c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c56:	78 1d                	js     801c75 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5b:	8b 00                	mov    (%eax),%eax
  801c5d:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801c60:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	e8 e4 fa ff ff       	call   801750 <dev_lookup>
  801c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c73:	79 05                	jns    801c7a <fstat+0x43>
		return r;
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	eb 41                	jmp    801cbb <fstat+0x84>
	stat->st_name[0] = 0;
  801c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7d:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801c8a:	00 00 00 
	stat->st_isdir = 0;
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  801c97:	00 00 00 
	stat->st_dev = dev;
  801c9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca0:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  801ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca9:	8b 48 14             	mov    0x14(%eax),%ecx
  801cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cb6:	89 04 24             	mov    %eax,(%esp)
  801cb9:	ff d1                	call   *%ecx
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cc3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cca:	00 
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	89 04 24             	mov    %eax,(%esp)
  801cd1:	e8 36 00 00 00       	call   801d0c <open>
  801cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cdd:	79 05                	jns    801ce4 <stat+0x27>
		return fd;
  801cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce2:	eb 23                	jmp    801d07 <stat+0x4a>
	r = fstat(fd, stat);
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cee:	89 04 24             	mov    %eax,(%esp)
  801cf1:	e8 41 ff ff ff       	call   801c37 <fstat>
  801cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	89 04 24             	mov    %eax,(%esp)
  801cff:	e8 c3 fa ff ff       	call   8017c7 <close>
	return r;
  801d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    
  801d09:	00 00                	add    %al,(%eax)
	...

00801d0c <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801d12:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d15:	89 04 24             	mov    %eax,(%esp)
  801d18:	e8 1a f9 ff ff       	call   801637 <fd_alloc>
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d24:	79 05                	jns    801d2b <open+0x1f>
  801d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d29:	eb 73                	jmp    801d9e <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  801d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	89 04 24             	mov    %eax,(%esp)
  801d3f:	e8 54 05 00 00       	call   802298 <fsipc_open>
  801d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4b:	79 05                	jns    801d52 <open+0x46>
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	eb 4c                	jmp    801d9e <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d55:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d69:	00 
  801d6a:	89 04 24             	mov    %eax,(%esp)
  801d6d:	e8 25 03 00 00       	call   802097 <fmap>
  801d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d79:	79 18                	jns    801d93 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  801d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d85:	00 
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 39 f9 ff ff       	call   8016c7 <fd_close>
  801d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d91:	eb 0b                	jmp    801d9e <open+0x92>
	return fd2num(fd);
  801d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d96:	89 04 24             	mov    %eax,(%esp)
  801d99:	e8 89 f8 ff ff       	call   801627 <fd2num>
	//panic("open() unimplemented!");
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801daf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801db6:	00 
  801db7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dbe:	00 
  801dbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	89 04 24             	mov    %eax,(%esp)
  801dc9:	e8 72 03 00 00       	call   802140 <funmap>
  801dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd5:	79 05                	jns    801ddc <file_close+0x3c>
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	eb 21                	jmp    801dfd <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	8b 40 0c             	mov    0xc(%eax),%eax
  801de2:	89 04 24             	mov    %eax,(%esp)
  801de5:	e8 e3 05 00 00       	call   8023cd <fsipc_close>
  801dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df1:	79 05                	jns    801df8 <file_close+0x58>
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df6:	eb 05                	jmp    801dfd <file_close+0x5d>
	return 0;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801e11:	8b 45 14             	mov    0x14(%ebp),%eax
  801e14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e17:	76 07                	jbe    801e20 <file_read+0x21>
		return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1e:	eb 43                	jmp    801e63 <file_read+0x64>
	if (offset + n > size)
  801e20:	8b 45 14             	mov    0x14(%ebp),%eax
  801e23:	03 45 10             	add    0x10(%ebp),%eax
  801e26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e29:	76 0f                	jbe    801e3a <file_read+0x3b>
		n = size - offset;
  801e2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e31:	89 d1                	mov    %edx,%ecx
  801e33:	29 c1                	sub    %eax,%ecx
  801e35:	89 c8                	mov    %ecx,%eax
  801e37:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	89 04 24             	mov    %eax,(%esp)
  801e40:	e8 c7 f7 ff ff       	call   80160c <fd2data>
  801e45:	8b 55 14             	mov    0x14(%ebp),%edx
  801e48:	01 c2                	add    %eax,%edx
  801e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e51:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e58:	89 04 24             	mov    %eax,(%esp)
  801e5b:	e8 0c f1 ff ff       	call   800f6c <memmove>
	return n;
  801e60:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	89 04 24             	mov    %eax,(%esp)
  801e78:	e8 28 f8 ff ff       	call   8016a5 <fd_lookup>
  801e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e84:	79 05                	jns    801e8b <read_map+0x26>
		return r;
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	eb 74                	jmp    801eff <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  801e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8e:	8b 10                	mov    (%eax),%edx
  801e90:	a1 20 50 80 00       	mov    0x805020,%eax
  801e95:	39 c2                	cmp    %eax,%edx
  801e97:	74 07                	je     801ea0 <read_map+0x3b>
		return -E_INVAL;
  801e99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e9e:	eb 5f                	jmp    801eff <read_map+0x9a>
	va = fd2data(fd) + offset;
  801ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea3:	89 04 24             	mov    %eax,(%esp)
  801ea6:	e8 61 f7 ff ff       	call   80160c <fd2data>
  801eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eae:	01 d0                	add    %edx,%eax
  801eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  801eb3:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  801eba:	7e 07                	jle    801ec3 <read_map+0x5e>
		return -E_NO_DISK;
  801ebc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801ec1:	eb 3c                	jmp    801eff <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec6:	c1 e8 16             	shr    $0x16,%eax
  801ec9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ed0:	83 e0 01             	and    $0x1,%eax
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	74 14                	je     801eeb <read_map+0x86>
  801ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eda:	c1 e8 0c             	shr    $0xc,%eax
  801edd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ee4:	83 e0 01             	and    $0x1,%eax
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	75 07                	jne    801ef2 <read_map+0x8d>
		return -E_NO_DISK;
  801eeb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801ef0:	eb 0d                	jmp    801eff <read_map+0x9a>
	*blk = (void*) va;
  801ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef8:	89 10                	mov    %edx,(%eax)
	return 0;
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  801f07:	8b 45 14             	mov    0x14(%ebp),%eax
  801f0a:	03 45 10             	add    0x10(%ebp),%eax
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  801f10:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  801f17:	76 07                	jbe    801f20 <file_write+0x1f>
		return -E_NO_DISK;
  801f19:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801f1e:	eb 57                	jmp    801f77 <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801f29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f2c:	73 20                	jae    801f4e <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	89 04 24             	mov    %eax,(%esp)
  801f3b:	e8 88 00 00 00       	call   801fc8 <file_trunc>
  801f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f47:	79 05                	jns    801f4e <file_write+0x4d>
			return r;
  801f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4c:	eb 29                	jmp    801f77 <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	89 04 24             	mov    %eax,(%esp)
  801f54:	e8 b3 f6 ff ff       	call   80160c <fd2data>
  801f59:	8b 55 14             	mov    0x14(%ebp),%edx
  801f5c:	01 c2                	add    %eax,%edx
  801f5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f61:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6c:	89 14 24             	mov    %edx,(%esp)
  801f6f:	e8 f8 ef ff ff       	call   800f6c <memmove>
	return n;
  801f74:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	8d 50 10             	lea    0x10(%eax),%edx
  801f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f8c:	89 04 24             	mov    %eax,(%esp)
  801f8f:	e8 e6 ed ff ff       	call   800d7a <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa0:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  801faf:	83 f8 01             	cmp    $0x1,%eax
  801fb2:	0f 94 c0             	sete   %al
  801fb5:	0f b6 d0             	movzbl %al,%edx
  801fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbb:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  801fce:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  801fd5:	7e 0a                	jle    801fe1 <file_trunc+0x19>
		return -E_NO_DISK;
  801fd7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801fdc:	e9 b4 00 00 00       	jmp    802095 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffc:	89 54 24 04          	mov    %edx,0x4(%esp)
  802000:	89 04 24             	mov    %eax,(%esp)
  802003:	e8 82 03 00 00       	call   80238a <fsipc_set_size>
  802008:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80200b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80200f:	79 05                	jns    802016 <file_trunc+0x4e>
		return r;
  802011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802014:	eb 7f                	jmp    802095 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80201f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802022:	74 24                	je     802048 <file_trunc+0x80>
  802024:	c7 44 24 0c 70 2e 80 	movl   $0x802e70,0xc(%esp)
  80202b:	00 
  80202c:	c7 44 24 08 93 2e 80 	movl   $0x802e93,0x8(%esp)
  802033:	00 
  802034:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80203b:	00 
  80203c:	c7 04 24 a8 2e 80 00 	movl   $0x802ea8,(%esp)
  802043:	e8 ec e2 ff ff       	call   800334 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  802048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80204f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802052:	89 44 24 04          	mov    %eax,0x4(%esp)
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	89 04 24             	mov    %eax,(%esp)
  80205c:	e8 36 00 00 00       	call   802097 <fmap>
  802061:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802064:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802068:	79 05                	jns    80206f <file_trunc+0xa7>
		return r;
  80206a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206d:	eb 26                	jmp    802095 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  80206f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802076:	00 
  802077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80207e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802081:	89 44 24 04          	mov    %eax,0x4(%esp)
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	89 04 24             	mov    %eax,(%esp)
  80208b:	e8 b0 00 00 00       	call   802140 <funmap>

	return 0;
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	89 04 24             	mov    %eax,(%esp)
  8020a3:	e8 64 f5 ff ff       	call   80160c <fd2data>
  8020a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  8020ab:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b5:	03 45 ec             	add    -0x14(%ebp),%eax
  8020b8:	83 e8 01             	sub    $0x1,%eax
  8020bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c6:	f7 75 ec             	divl   -0x14(%ebp)
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020ce:	89 d1                	mov    %edx,%ecx
  8020d0:	29 c1                	sub    %eax,%ecx
  8020d2:	89 c8                	mov    %ecx,%eax
  8020d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d7:	eb 58                	jmp    802131 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020ef:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020f3:	89 04 24             	mov    %eax,(%esp)
  8020f6:	e8 04 02 00 00       	call   8022ff <fsipc_map>
  8020fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802102:	79 26                	jns    80212a <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80210e:	00 
  80210f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802112:	89 54 24 08          	mov    %edx,0x8(%esp)
  802116:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	89 04 24             	mov    %eax,(%esp)
  802120:	e8 1b 00 00 00       	call   802140 <funmap>
			return r;
  802125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802128:	eb 14                	jmp    80213e <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80212a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802131:	8b 45 10             	mov    0x10(%ebp),%eax
  802134:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802137:	77 a0                	ja     8020d9 <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	89 04 24             	mov    %eax,(%esp)
  80214c:	e8 bb f4 ff ff       	call   80160c <fd2data>
  802151:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  802154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802157:	c1 e8 16             	shr    $0x16,%eax
  80215a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802161:	83 e0 01             	and    $0x1,%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	75 0a                	jne    802172 <funmap+0x32>
		return 0;
  802168:	b8 00 00 00 00       	mov    $0x0,%eax
  80216d:	e9 bf 00 00 00       	jmp    802231 <funmap+0xf1>

	ret = 0;
  802172:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  802179:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802180:	8b 45 10             	mov    0x10(%ebp),%eax
  802183:	03 45 e8             	add    -0x18(%ebp),%eax
  802186:	83 e8 01             	sub    $0x1,%eax
  802189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80218c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80218f:	ba 00 00 00 00       	mov    $0x0,%edx
  802194:	f7 75 e8             	divl   -0x18(%ebp)
  802197:	89 d0                	mov    %edx,%eax
  802199:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80219c:	89 d1                	mov    %edx,%ecx
  80219e:	29 c1                	sub    %eax,%ecx
  8021a0:	89 c8                	mov    %ecx,%eax
  8021a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a5:	eb 7b                	jmp    802222 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021ad:	01 d0                	add    %edx,%eax
  8021af:	c1 e8 0c             	shr    $0xc,%eax
  8021b2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8021b9:	83 e0 01             	and    $0x1,%eax
  8021bc:	84 c0                	test   %al,%al
  8021be:	74 5b                	je     80221b <funmap+0xdb>
			if (dirty
  8021c0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8021c4:	74 3d                	je     802203 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021cc:	01 d0                	add    %edx,%eax
  8021ce:	c1 e8 0c             	shr    $0xc,%eax
  8021d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8021d8:	83 e0 40             	and    $0x40,%eax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	74 24                	je     802203 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  8021df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021ec:	89 04 24             	mov    %eax,(%esp)
  8021ef:	e8 13 02 00 00       	call   802407 <fsipc_dirty>
  8021f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8021f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021fb:	79 06                	jns    802203 <funmap+0xc3>
				ret = r;
  8021fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802200:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  802203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802206:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802209:	01 d0                	add    %edx,%eax
  80220b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802216:	e8 22 f2 ff ff       	call   80143d <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  80221b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802228:	0f 87 79 ff ff ff    	ja     8021a7 <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <remove>:

// Delete a file
int
remove(const char *path)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	89 04 24             	mov    %eax,(%esp)
  80223f:	e8 06 02 00 00       	call   80244a <fsipc_remove>
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  80224c:	e8 56 02 00 00       	call   8024a7 <fsipc_sync>
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    
	...

00802254 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80225a:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80225f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802266:	00 
  802267:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
  802271:	89 54 24 04          	mov    %edx,0x4(%esp)
  802275:	89 04 24             	mov    %eax,(%esp)
  802278:	e8 e3 02 00 00       	call   802560 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  80227d:	8b 45 14             	mov    0x14(%ebp),%eax
  802280:	89 44 24 08          	mov    %eax,0x8(%esp)
  802284:	8b 45 10             	mov    0x10(%ebp),%eax
  802287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80228e:	89 04 24             	mov    %eax,(%esp)
  802291:	e8 3e 02 00 00       	call   8024d4 <ipc_recv>
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  80229e:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	89 04 24             	mov    %eax,(%esp)
  8022ab:	e8 74 ea ff ff       	call   800d24 <strlen>
  8022b0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8022b5:	7e 07                	jle    8022be <fsipc_open+0x26>
		return -E_BAD_PATH;
  8022b7:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8022bc:	eb 3f                	jmp    8022fd <fsipc_open+0x65>
	strcpy(req->req_path, path);
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022c8:	89 04 24             	mov    %eax,(%esp)
  8022cb:	e8 aa ea ff ff       	call   800d7a <strcpy>
	req->req_omode = omode;
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d6:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8022dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8022f8:	e8 57 ff ff ff       	call   802254 <fsipc>
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  802305:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 55 08             	mov    0x8(%ebp),%edx
  802312:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231a:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  80231d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802320:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802324:	8b 45 10             	mov    0x10(%ebp),%eax
  802327:	89 44 24 08          	mov    %eax,0x8(%esp)
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802332:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802339:	e8 16 ff ff ff       	call   802254 <fsipc>
  80233e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802345:	79 05                	jns    80234c <fsipc_map+0x4d>
		return r;
  802347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234a:	eb 3c                	jmp    802388 <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  80234c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234f:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  802354:	83 f8 05             	cmp    $0x5,%eax
  802357:	74 2a                	je     802383 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  802359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235c:	8b 55 10             	mov    0x10(%ebp),%edx
  80235f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802363:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802367:	c7 44 24 08 b4 2e 80 	movl   $0x802eb4,0x8(%esp)
  80236e:	00 
  80236f:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  802376:	00 
  802377:	c7 04 24 ea 2e 80 00 	movl   $0x802eea,(%esp)
  80237e:	e8 b1 df ff ff       	call   800334 <_panic>
	return 0;
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  802390:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
  80239d:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a5:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  8023a8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8023af:	00 
  8023b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023b7:	00 
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bf:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8023c6:	e8 89 fe ff ff       	call   802254 <fsipc>
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  8023d3:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e0:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  8023e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8023e9:	00 
  8023ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023f1:	00 
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  802400:	e8 4f fe ff ff       	call   802254 <fsipc>
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  80240d:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 55 08             	mov    0x8(%ebp),%edx
  80241a:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802422:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  802425:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80242c:	00 
  80242d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802434:	00 
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  802443:	e8 0c fe ff ff       	call   802254 <fsipc>
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802450:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	89 04 24             	mov    %eax,(%esp)
  80245d:	e8 c2 e8 ff ff       	call   800d24 <strlen>
  802462:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802467:	7e 07                	jle    802470 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  802469:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80246e:	eb 35                	jmp    8024a5 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 55 08             	mov    0x8(%ebp),%edx
  802476:	89 54 24 04          	mov    %edx,0x4(%esp)
  80247a:	89 04 24             	mov    %eax,(%esp)
  80247d:	e8 f8 e8 ff ff       	call   800d7a <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  802482:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802489:	00 
  80248a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802491:	00 
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	89 44 24 04          	mov    %eax,0x4(%esp)
  802499:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  8024a0:	e8 af fd ff ff       	call   802254 <fsipc>
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8024ad:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024b4:	00 
  8024b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024bc:	00 
  8024bd:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8024c4:	00 
  8024c5:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8024cc:	e8 83 fd ff ff       	call   802254 <fsipc>
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    
	...

008024d4 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  8024da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024de:	75 11                	jne    8024f1 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  8024e0:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  8024e7:	e8 db f0 ff ff       	call   8015c7 <sys_ipc_recv>
  8024ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ef:	eb 0e                	jmp    8024ff <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  8024f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f4:	89 04 24             	mov    %eax,(%esp)
  8024f7:	e8 cb f0 ff ff       	call   8015c7 <sys_ipc_recv>
  8024fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  8024ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802503:	79 1c                	jns    802521 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  802505:	c7 44 24 08 f6 2e 80 	movl   $0x802ef6,0x8(%esp)
  80250c:	00 
  80250d:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  802514:	00 
  802515:	c7 04 24 0c 2f 80 00 	movl   $0x802f0c,(%esp)
  80251c:	e8 13 de ff ff       	call   800334 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  802521:	e8 08 ee ff ff       	call   80132e <sys_getenvid>
  802526:	25 ff 03 00 00       	and    $0x3ff,%eax
  80252b:	c1 e0 07             	shl    $0x7,%eax
  80252e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802533:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  802536:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80253a:	74 0b                	je     802547 <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  80253c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253f:	8b 50 74             	mov    0x74(%eax),%edx
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  802547:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80254b:	74 0b                	je     802558 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	8b 50 78             	mov    0x78(%eax),%edx
  802553:	8b 45 10             	mov    0x10(%ebp),%eax
  802556:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  802558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255b:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  802566:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80256a:	75 26                	jne    802592 <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  80256c:	8b 45 14             	mov    0x14(%ebp),%eax
  80256f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802573:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  80257a:	ee 
  80257b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	89 04 24             	mov    %eax,(%esp)
  802588:	e8 fa ef ff ff       	call   801587 <sys_ipc_try_send>
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802590:	eb 23                	jmp    8025b5 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  802592:	8b 45 14             	mov    0x14(%ebp),%eax
  802595:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802599:	8b 45 10             	mov    0x10(%ebp),%eax
  80259c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025aa:	89 04 24             	mov    %eax,(%esp)
  8025ad:	e8 d5 ef ff ff       	call   801587 <sys_ipc_try_send>
  8025b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  8025b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b9:	79 29                	jns    8025e4 <ipc_send+0x84>
  8025bb:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  8025bf:	74 23                	je     8025e4 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025c8:	c7 44 24 08 16 2f 80 	movl   $0x802f16,0x8(%esp)
  8025cf:	00 
  8025d0:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8025d7:	00 
  8025d8:	c7 04 24 0c 2f 80 00 	movl   $0x802f0c,(%esp)
  8025df:	e8 50 dd ff ff       	call   800334 <_panic>
	    sys_yield();
  8025e4:	e8 89 ed ff ff       	call   801372 <sys_yield>
	}while(r < 0);
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	0f 88 73 ff ff ff    	js     802566 <ipc_send+0x6>
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    
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
