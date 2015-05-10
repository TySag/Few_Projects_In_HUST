
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start-0xc>:
.long MULTIBOOT_HEADER_FLAGS
.long CHECKSUM

.globl		_start
_start:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fb                   	sti    
f0100009:	4f                   	dec    %edi
f010000a:	52                   	push   %edx
f010000b:	e4 66                	in     $0x66,%al

f010000c <_start>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 

	# Establish our own GDT in place of the boot loader's temporary GDT.
	lgdt	RELOC(mygdtdesc)		# load descriptor table
f0100015:	0f 01 15 18 f0 11 00 	lgdtl  0x11f018

	# Immediately reload all segment registers (including CS!)
	# with segment selectors from the new GDT.
	movl	$DATA_SEL, %eax			# Data segment selector
f010001c:	b8 10 00 00 00       	mov    $0x10,%eax
	movw	%ax,%ds				# -> DS: Data Segment
f0100021:	8e d8                	mov    %eax,%ds
	movw	%ax,%es				# -> ES: Extra Segment
f0100023:	8e c0                	mov    %eax,%es
	movw	%ax,%ss				# -> SS: Stack Segment
f0100025:	8e d0                	mov    %eax,%ss
	ljmp	$CODE_SEL,$relocated		# reload CS by jumping
f0100027:	ea 2e 00 10 f0 08 00 	ljmp   $0x8,$0xf010002e

f010002e <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002e:	bd 00 00 00 00       	mov    $0x0,%ebp

        # Leave a few words on the stack for the user trap frame
	movl	$(bootstacktop-SIZEOF_STRUCT_TRAPFRAME),%esp
f0100033:	bc bc ef 11 f0       	mov    $0xf011efbc,%esp

	# now to C code
	call	i386_init
f0100038:	e8 b1 00 00 00       	call   f01000ee <i386_init>

f010003d <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003d:	eb fe                	jmp    f010003d <spin>
	...

f0100040 <test_backtrace>:
#include <kern/env.h>
#include <kern/trap.h>
#include <kern/sched.h>
#include <kern/picirq.h>

void test_backtrace(int arg){
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	83 ec 18             	sub    $0x18,%esp
     cprintf("entering test_backtrace %d\n", arg);
f0100046:	8b 45 08             	mov    0x8(%ebp),%eax
f0100049:	89 44 24 04          	mov    %eax,0x4(%esp)
f010004d:	c7 04 24 80 77 10 f0 	movl   $0xf0107780,(%esp)
f0100054:	e8 35 46 00 00       	call   f010468e <cprintf>
     if(arg>0) test_backtrace(arg-1);
f0100059:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f010005d:	7e 10                	jle    f010006f <test_backtrace+0x2f>
f010005f:	8b 45 08             	mov    0x8(%ebp),%eax
f0100062:	83 e8 01             	sub    $0x1,%eax
f0100065:	89 04 24             	mov    %eax,(%esp)
f0100068:	e8 d3 ff ff ff       	call   f0100040 <test_backtrace>
f010006d:	eb 1c                	jmp    f010008b <test_backtrace+0x4b>
     else mon_backtrace(0,0,0);
f010006f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100076:	00 
f0100077:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010007e:	00 
f010007f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100086:	e8 07 12 00 00       	call   f0101292 <mon_backtrace>
     cprintf("leaving test_backtrace %d\n", arg);
f010008b:	8b 45 08             	mov    0x8(%ebp),%eax
f010008e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100092:	c7 04 24 9c 77 10 f0 	movl   $0xf010779c,(%esp)
f0100099:	e8 f0 45 00 00       	call   f010468e <cprintf>
}
f010009e:	c9                   	leave  
f010009f:	c3                   	ret    

f01000a0 <selffun>:
void selffun(){
f01000a0:	55                   	push   %ebp
f01000a1:	89 e5                	mov    %esp,%ebp
f01000a3:	83 ec 28             	sub    $0x28,%esp
       unsigned int i = 0x00646c72;
f01000a6:	c7 45 f4 72 6c 64 00 	movl   $0x646c72,-0xc(%ebp)
       cprintf("++++++++++++++++++++++++++++++++++++++\n");
f01000ad:	c7 04 24 b8 77 10 f0 	movl   $0xf01077b8,(%esp)
f01000b4:	e8 d5 45 00 00       	call   f010468e <cprintf>
       cprintf("             H%x Wo%s!!\n", 57616, &i);
f01000b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01000bc:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000c0:	c7 44 24 04 10 e1 00 	movl   $0xe110,0x4(%esp)
f01000c7:	00 
f01000c8:	c7 04 24 e0 77 10 f0 	movl   $0xf01077e0,(%esp)
f01000cf:	e8 ba 45 00 00       	call   f010468e <cprintf>
       cprintf("++++++++++++++++++++++++++++++++++++++\n");
f01000d4:	c7 04 24 b8 77 10 f0 	movl   $0xf01077b8,(%esp)
f01000db:	e8 ae 45 00 00       	call   f010468e <cprintf>
       cprintf("welcome to the Jos system!\n");
f01000e0:	c7 04 24 f9 77 10 f0 	movl   $0xf01077f9,(%esp)
f01000e7:	e8 a2 45 00 00       	call   f010468e <cprintf>
}
f01000ec:	c9                   	leave  
f01000ed:	c3                   	ret    

f01000ee <i386_init>:

void
i386_init(void)
{
f01000ee:	55                   	push   %ebp
f01000ef:	89 e5                	mov    %esp,%ebp
f01000f1:	83 ec 18             	sub    $0x18,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f01000f4:	ba d0 94 1a f0       	mov    $0xf01a94d0,%edx
f01000f9:	b8 a8 85 1a f0       	mov    $0xf01a85a8,%eax
f01000fe:	89 d1                	mov    %edx,%ecx
f0100100:	29 c1                	sub    %eax,%ecx
f0100102:	89 c8                	mov    %ecx,%eax
f0100104:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100108:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010010f:	00 
f0100110:	c7 04 24 a8 85 1a f0 	movl   $0xf01a85a8,(%esp)
f0100117:	e8 d7 70 00 00       	call   f01071f3 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010011c:	e8 58 09 00 00       	call   f0100a79 <cons_init>
    cprintf("the class number is %s and used to be %d \n", "6828", 6097);
f0100121:	c7 44 24 08 d1 17 00 	movl   $0x17d1,0x8(%esp)
f0100128:	00 
f0100129:	c7 44 24 04 15 78 10 	movl   $0xf0107815,0x4(%esp)
f0100130:	f0 
f0100131:	c7 04 24 1c 78 10 f0 	movl   $0xf010781c,(%esp)
f0100138:	e8 51 45 00 00       	call   f010468e <cprintf>
	cprintf("6828 decimal is %o octal!\n", 6828);
f010013d:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f0100144:	00 
f0100145:	c7 04 24 47 78 10 f0 	movl   $0xf0107847,(%esp)
f010014c:	e8 3d 45 00 00       	call   f010468e <cprintf>

	// Lab 2 memory management initialization functions
	i386_detect_memory();
f0100151:	e8 07 15 00 00       	call   f010165d <i386_detect_memory>
	i386_vm_init();
f0100156:	e8 4f 16 00 00       	call   f01017aa <i386_vm_init>

	// Lab 3 user environment initialization functions
	env_init();
f010015b:	e8 9a 3a 00 00       	call   f0103bfa <env_init>
	idt_init();
f0100160:	e8 8d 45 00 00       	call   f01046f2 <idt_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f0100165:	e8 de 42 00 00       	call   f0104448 <pic_init>
	kclock_init();
f010016a:	e8 67 42 00 00       	call   f01043d6 <kclock_init>

	// Should always have an idle process as first one.
	ENV_CREATE(user_idle);
f010016f:	b8 96 ee 00 00       	mov    $0xee96,%eax
f0100174:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100178:	c7 04 24 4c f6 11 f0 	movl   $0xf011f64c,(%esp)
f010017f:	e8 45 3f 00 00       	call   f01040c9 <env_create>

	// Start fs.
	ENV_CREATE(fs_fs);
f0100184:	b8 4e a5 01 00       	mov    $0x1a54e,%eax
f0100189:	89 44 24 04          	mov    %eax,0x4(%esp)
f010018d:	c7 04 24 5a e0 18 f0 	movl   $0xf018e05a,(%esp)
f0100194:	e8 30 3f 00 00       	call   f01040c9 <env_create>
	// ENV_CREATE(user_pingpong);
#endif


	// Schedule and run the first user environment!
	sched_yield();
f0100199:	e8 8e 55 00 00       	call   f010572c <sched_yield>

f010019e <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f010019e:	55                   	push   %ebp
f010019f:	89 e5                	mov    %esp,%ebp
f01001a1:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	if (panicstr)
f01001a4:	a1 c0 85 1a f0       	mov    0xf01a85c0,%eax
f01001a9:	85 c0                	test   %eax,%eax
f01001ab:	75 4b                	jne    f01001f8 <_panic+0x5a>
		goto dead;
	panicstr = fmt;
f01001ad:	8b 45 10             	mov    0x10(%ebp),%eax
f01001b0:	a3 c0 85 1a f0       	mov    %eax,0xf01a85c0

	va_start(ap, fmt);
f01001b5:	8d 45 10             	lea    0x10(%ebp),%eax
f01001b8:	83 c0 04             	add    $0x4,%eax
f01001bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("kernel panic at %s:%d: ", file, line);
f01001be:	8b 45 0c             	mov    0xc(%ebp),%eax
f01001c1:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001c5:	8b 45 08             	mov    0x8(%ebp),%eax
f01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01001cc:	c7 04 24 62 78 10 f0 	movl   $0xf0107862,(%esp)
f01001d3:	e8 b6 44 00 00       	call   f010468e <cprintf>
	vcprintf(fmt, ap);
f01001d8:	8b 45 10             	mov    0x10(%ebp),%eax
f01001db:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01001de:	89 54 24 04          	mov    %edx,0x4(%esp)
f01001e2:	89 04 24             	mov    %eax,(%esp)
f01001e5:	e8 71 44 00 00       	call   f010465b <vcprintf>
	cprintf("\n");
f01001ea:	c7 04 24 7a 78 10 f0 	movl   $0xf010787a,(%esp)
f01001f1:	e8 98 44 00 00       	call   f010468e <cprintf>
f01001f6:	eb 01                	jmp    f01001f9 <_panic+0x5b>
_panic(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	if (panicstr)
		goto dead;
f01001f8:	90                   	nop
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01001f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100200:	e8 df 12 00 00       	call   f01014e4 <monitor>
f0100205:	eb f2                	jmp    f01001f9 <_panic+0x5b>

f0100207 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100207:	55                   	push   %ebp
f0100208:	89 e5                	mov    %esp,%ebp
f010020a:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
f010020d:	8d 45 10             	lea    0x10(%ebp),%eax
f0100210:	83 c0 04             	add    $0x4,%eax
f0100213:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("kernel warning at %s:%d: ", file, line);
f0100216:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100219:	89 44 24 08          	mov    %eax,0x8(%esp)
f010021d:	8b 45 08             	mov    0x8(%ebp),%eax
f0100220:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100224:	c7 04 24 7c 78 10 f0 	movl   $0xf010787c,(%esp)
f010022b:	e8 5e 44 00 00       	call   f010468e <cprintf>
	vcprintf(fmt, ap);
f0100230:	8b 45 10             	mov    0x10(%ebp),%eax
f0100233:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100236:	89 54 24 04          	mov    %edx,0x4(%esp)
f010023a:	89 04 24             	mov    %eax,(%esp)
f010023d:	e8 19 44 00 00       	call   f010465b <vcprintf>
	cprintf("\n");
f0100242:	c7 04 24 7a 78 10 f0 	movl   $0xf010787a,(%esp)
f0100249:	e8 40 44 00 00       	call   f010468e <cprintf>
	va_end(ap);
}
f010024e:	c9                   	leave  
f010024f:	c3                   	ret    

f0100250 <serial_proc_data>:

static bool serial_exists;

int
serial_proc_data(void)
{
f0100250:	55                   	push   %ebp
f0100251:	89 e5                	mov    %esp,%ebp
f0100253:	53                   	push   %ebx
f0100254:	83 ec 14             	sub    $0x14,%esp
f0100257:	c7 45 f8 fd 03 00 00 	movl   $0x3fd,-0x8(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010025e:	8b 55 f8             	mov    -0x8(%ebp),%edx
f0100261:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0100264:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100267:	ec                   	in     (%dx),%al
f0100268:	89 c3                	mov    %eax,%ebx
f010026a:	88 5d f7             	mov    %bl,-0x9(%ebp)
	return data;
f010026d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100271:	0f b6 c0             	movzbl %al,%eax
f0100274:	83 e0 01             	and    $0x1,%eax
f0100277:	85 c0                	test   %eax,%eax
f0100279:	75 07                	jne    f0100282 <serial_proc_data+0x32>
		return -1;
f010027b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100280:	eb 1d                	jmp    f010029f <serial_proc_data+0x4f>
f0100282:	c7 45 f0 f8 03 00 00 	movl   $0x3f8,-0x10(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100289:	8b 55 f0             	mov    -0x10(%ebp),%edx
f010028c:	89 55 e8             	mov    %edx,-0x18(%ebp)
f010028f:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100292:	ec                   	in     (%dx),%al
f0100293:	89 c3                	mov    %eax,%ebx
f0100295:	88 5d ef             	mov    %bl,-0x11(%ebp)
	return data;
f0100298:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
	return inb(COM1+COM_RX);
f010029c:	0f b6 c0             	movzbl %al,%eax
}
f010029f:	83 c4 14             	add    $0x14,%esp
f01002a2:	5b                   	pop    %ebx
f01002a3:	5d                   	pop    %ebp
f01002a4:	c3                   	ret    

f01002a5 <serial_intr>:

void
serial_intr(void)
{
f01002a5:	55                   	push   %ebp
f01002a6:	89 e5                	mov    %esp,%ebp
f01002a8:	83 ec 18             	sub    $0x18,%esp
	if (serial_exists)
f01002ab:	a1 e0 85 1a f0       	mov    0xf01a85e0,%eax
f01002b0:	85 c0                	test   %eax,%eax
f01002b2:	74 0c                	je     f01002c0 <serial_intr+0x1b>
		cons_intr(serial_proc_data);
f01002b4:	c7 04 24 50 02 10 f0 	movl   $0xf0100250,(%esp)
f01002bb:	e8 f3 06 00 00       	call   f01009b3 <cons_intr>
}
f01002c0:	c9                   	leave  
f01002c1:	c3                   	ret    

f01002c2 <serial_init>:

void
serial_init(void)
{
f01002c2:	55                   	push   %ebp
f01002c3:	89 e5                	mov    %esp,%ebp
f01002c5:	53                   	push   %ebx
f01002c6:	83 ec 74             	sub    $0x74,%esp
f01002c9:	c7 45 f4 fa 03 00 00 	movl   $0x3fa,-0xc(%ebp)
f01002d0:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002d4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01002d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01002db:	ee                   	out    %al,(%dx)
f01002dc:	c7 45 ec fb 03 00 00 	movl   $0x3fb,-0x14(%ebp)
f01002e3:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
f01002e7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
f01002eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
f01002ee:	ee                   	out    %al,(%dx)
f01002ef:	c7 45 e4 f8 03 00 00 	movl   $0x3f8,-0x1c(%ebp)
f01002f6:	c6 45 e3 0c          	movb   $0xc,-0x1d(%ebp)
f01002fa:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f01002fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0100301:	ee                   	out    %al,(%dx)
f0100302:	c7 45 dc f9 03 00 00 	movl   $0x3f9,-0x24(%ebp)
f0100309:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
f010030d:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
f0100311:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100314:	ee                   	out    %al,(%dx)
f0100315:	c7 45 d4 fb 03 00 00 	movl   $0x3fb,-0x2c(%ebp)
f010031c:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
f0100320:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
f0100324:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100327:	ee                   	out    %al,(%dx)
f0100328:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
f010032f:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
f0100333:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
f0100337:	8b 55 cc             	mov    -0x34(%ebp),%edx
f010033a:	ee                   	out    %al,(%dx)
f010033b:	c7 45 c4 f9 03 00 00 	movl   $0x3f9,-0x3c(%ebp)
f0100342:	c6 45 c3 01          	movb   $0x1,-0x3d(%ebp)
f0100346:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
f010034a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010034d:	ee                   	out    %al,(%dx)
f010034e:	c7 45 bc fd 03 00 00 	movl   $0x3fd,-0x44(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100355:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0100358:	89 55 a4             	mov    %edx,-0x5c(%ebp)
f010035b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
f010035e:	ec                   	in     (%dx),%al
f010035f:	89 c3                	mov    %eax,%ebx
f0100361:	88 5d bb             	mov    %bl,-0x45(%ebp)
	return data;
f0100364:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100368:	3c ff                	cmp    $0xff,%al
f010036a:	0f 95 c0             	setne  %al
f010036d:	0f b6 c0             	movzbl %al,%eax
f0100370:	a3 e0 85 1a f0       	mov    %eax,0xf01a85e0
f0100375:	c7 45 b4 fa 03 00 00 	movl   $0x3fa,-0x4c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010037c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
f010037f:	89 55 a4             	mov    %edx,-0x5c(%ebp)
f0100382:	8b 55 a4             	mov    -0x5c(%ebp),%edx
f0100385:	ec                   	in     (%dx),%al
f0100386:	89 c3                	mov    %eax,%ebx
f0100388:	88 5d b3             	mov    %bl,-0x4d(%ebp)
	return data;
f010038b:	c7 45 ac f8 03 00 00 	movl   $0x3f8,-0x54(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100392:	8b 55 ac             	mov    -0x54(%ebp),%edx
f0100395:	89 55 a4             	mov    %edx,-0x5c(%ebp)
f0100398:	8b 55 a4             	mov    -0x5c(%ebp),%edx
f010039b:	ec                   	in     (%dx),%al
f010039c:	89 c3                	mov    %eax,%ebx
f010039e:	88 5d ab             	mov    %bl,-0x55(%ebp)
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f01003a1:	a1 e0 85 1a f0       	mov    0xf01a85e0,%eax
f01003a6:	85 c0                	test   %eax,%eax
f01003a8:	74 17                	je     f01003c1 <serial_init+0xff>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f01003aa:	0f b7 05 38 f6 11 f0 	movzwl 0xf011f638,%eax
f01003b1:	0f b7 c0             	movzwl %ax,%eax
f01003b4:	25 ef ff 00 00       	and    $0xffef,%eax
f01003b9:	89 04 24             	mov    %eax,(%esp)
f01003bc:	e8 c5 41 00 00       	call   f0104586 <irq_setmask_8259A>
}
f01003c1:	83 c4 74             	add    $0x74,%esp
f01003c4:	5b                   	pop    %ebx
f01003c5:	5d                   	pop    %ebp
f01003c6:	c3                   	ret    

f01003c7 <delay>:
// page.

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f01003c7:	55                   	push   %ebp
f01003c8:	89 e5                	mov    %esp,%ebp
f01003ca:	53                   	push   %ebx
f01003cb:	83 ec 24             	sub    $0x24,%esp
f01003ce:	c7 45 f8 84 00 00 00 	movl   $0x84,-0x8(%ebp)
f01003d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
f01003d8:	89 55 d8             	mov    %edx,-0x28(%ebp)
f01003db:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01003de:	ec                   	in     (%dx),%al
f01003df:	89 c3                	mov    %eax,%ebx
f01003e1:	88 5d f7             	mov    %bl,-0x9(%ebp)
	return data;
f01003e4:	c7 45 f0 84 00 00 00 	movl   $0x84,-0x10(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01003ee:	89 55 d8             	mov    %edx,-0x28(%ebp)
f01003f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01003f4:	ec                   	in     (%dx),%al
f01003f5:	89 c3                	mov    %eax,%ebx
f01003f7:	88 5d ef             	mov    %bl,-0x11(%ebp)
	return data;
f01003fa:	c7 45 e8 84 00 00 00 	movl   $0x84,-0x18(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100401:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100404:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0100407:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010040a:	ec                   	in     (%dx),%al
f010040b:	89 c3                	mov    %eax,%ebx
f010040d:	88 5d e7             	mov    %bl,-0x19(%ebp)
	return data;
f0100410:	c7 45 e0 84 00 00 00 	movl   $0x84,-0x20(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100417:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010041a:	89 55 d8             	mov    %edx,-0x28(%ebp)
f010041d:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0100420:	ec                   	in     (%dx),%al
f0100421:	89 c3                	mov    %eax,%ebx
f0100423:	88 5d df             	mov    %bl,-0x21(%ebp)
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f0100426:	83 c4 24             	add    $0x24,%esp
f0100429:	5b                   	pop    %ebx
f010042a:	5d                   	pop    %ebp
f010042b:	c3                   	ret    

f010042c <lpt_putc>:

static void
lpt_putc(int c)
{
f010042c:	55                   	push   %ebp
f010042d:	89 e5                	mov    %esp,%ebp
f010042f:	53                   	push   %ebx
f0100430:	83 ec 34             	sub    $0x34,%esp
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100433:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
f010043a:	eb 09                	jmp    f0100445 <lpt_putc+0x19>
		delay();
f010043c:	e8 86 ff ff ff       	call   f01003c7 <delay>
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100441:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
f0100445:	c7 45 f4 79 03 00 00 	movl   $0x379,-0xc(%ebp)
f010044c:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010044f:	89 55 c8             	mov    %edx,-0x38(%ebp)
f0100452:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0100455:	ec                   	in     (%dx),%al
f0100456:	89 c3                	mov    %eax,%ebx
f0100458:	88 5d f3             	mov    %bl,-0xd(%ebp)
	return data;
f010045b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f010045f:	84 c0                	test   %al,%al
f0100461:	78 09                	js     f010046c <lpt_putc+0x40>
f0100463:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
f010046a:	7e d0                	jle    f010043c <lpt_putc+0x10>
		delay();
	outb(0x378+0, c);
f010046c:	8b 45 08             	mov    0x8(%ebp),%eax
f010046f:	0f b6 c0             	movzbl %al,%eax
f0100472:	c7 45 ec 78 03 00 00 	movl   $0x378,-0x14(%ebp)
f0100479:	88 45 eb             	mov    %al,-0x15(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010047c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
f0100480:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0100483:	ee                   	out    %al,(%dx)
f0100484:	c7 45 e4 7a 03 00 00 	movl   $0x37a,-0x1c(%ebp)
f010048b:	c6 45 e3 0d          	movb   $0xd,-0x1d(%ebp)
f010048f:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f0100493:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0100496:	ee                   	out    %al,(%dx)
f0100497:	c7 45 dc 7a 03 00 00 	movl   $0x37a,-0x24(%ebp)
f010049e:	c6 45 db 08          	movb   $0x8,-0x25(%ebp)
f01004a2:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
f01004a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01004a9:	ee                   	out    %al,(%dx)
	outb(0x378+2, 0x08|0x04|0x01);
	outb(0x378+2, 0x08);
}
f01004aa:	83 c4 34             	add    $0x34,%esp
f01004ad:	5b                   	pop    %ebx
f01004ae:	5d                   	pop    %ebp
f01004af:	c3                   	ret    

f01004b0 <cga_init>:
static uint16_t *crt_buf;
static uint16_t crt_pos;

void
cga_init(void)
{
f01004b0:	55                   	push   %ebp
f01004b1:	89 e5                	mov    %esp,%ebp
f01004b3:	53                   	push   %ebx
f01004b4:	83 ec 34             	sub    $0x34,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01004b7:	c7 45 f8 00 80 0b f0 	movl   $0xf00b8000,-0x8(%ebp)
	was = *cp;
f01004be:	8b 45 f8             	mov    -0x8(%ebp),%eax
f01004c1:	0f b7 00             	movzwl (%eax),%eax
f01004c4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
	*cp = (uint16_t) 0xA55A;
f01004c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
f01004cb:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
	if (*cp != 0xA55A) {
f01004d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
f01004d3:	0f b7 00             	movzwl (%eax),%eax
f01004d6:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01004da:	74 13                	je     f01004ef <cga_init+0x3f>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01004dc:	c7 45 f8 00 00 0b f0 	movl   $0xf00b0000,-0x8(%ebp)
		addr_6845 = MONO_BASE;
f01004e3:	c7 05 e4 85 1a f0 b4 	movl   $0x3b4,0xf01a85e4
f01004ea:	03 00 00 
f01004ed:	eb 14                	jmp    f0100503 <cga_init+0x53>
	} else {
		*cp = was;
f01004ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
f01004f2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
f01004f6:	66 89 10             	mov    %dx,(%eax)
		addr_6845 = CGA_BASE;
f01004f9:	c7 05 e4 85 1a f0 d4 	movl   $0x3d4,0xf01a85e4
f0100500:	03 00 00 
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
f0100503:	a1 e4 85 1a f0       	mov    0xf01a85e4,%eax
f0100508:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010050b:	c6 45 eb 0e          	movb   $0xe,-0x15(%ebp)
f010050f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
f0100513:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0100516:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100517:	a1 e4 85 1a f0       	mov    0xf01a85e4,%eax
f010051c:	83 c0 01             	add    $0x1,%eax
f010051f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100522:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0100525:	89 55 c8             	mov    %edx,-0x38(%ebp)
f0100528:	8b 55 c8             	mov    -0x38(%ebp),%edx
f010052b:	ec                   	in     (%dx),%al
f010052c:	89 c3                	mov    %eax,%ebx
f010052e:	88 5d e3             	mov    %bl,-0x1d(%ebp)
	return data;
f0100531:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f0100535:	0f b6 c0             	movzbl %al,%eax
f0100538:	c1 e0 08             	shl    $0x8,%eax
f010053b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	outb(addr_6845, 15);
f010053e:	a1 e4 85 1a f0       	mov    0xf01a85e4,%eax
f0100543:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100546:	c6 45 db 0f          	movb   $0xf,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010054a:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
f010054e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100551:	ee                   	out    %al,(%dx)
	pos |= inb(addr_6845 + 1);
f0100552:	a1 e4 85 1a f0       	mov    0xf01a85e4,%eax
f0100557:	83 c0 01             	add    $0x1,%eax
f010055a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010055d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100560:	89 55 c8             	mov    %edx,-0x38(%ebp)
f0100563:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0100566:	ec                   	in     (%dx),%al
f0100567:	89 c3                	mov    %eax,%ebx
f0100569:	88 5d d3             	mov    %bl,-0x2d(%ebp)
	return data;
f010056c:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
f0100570:	0f b6 c0             	movzbl %al,%eax
f0100573:	09 45 f0             	or     %eax,-0x10(%ebp)

	crt_buf = (uint16_t*) cp;
f0100576:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0100579:	a3 e8 85 1a f0       	mov    %eax,0xf01a85e8
	crt_pos = pos;
f010057e:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100581:	66 a3 ec 85 1a f0    	mov    %ax,0xf01a85ec
}
f0100587:	83 c4 34             	add    $0x34,%esp
f010058a:	5b                   	pop    %ebx
f010058b:	5d                   	pop    %ebp
f010058c:	c3                   	ret    

f010058d <SetBackColor>:

extern int ch_color;

void SetBackColor(uint16_t num){ 
f010058d:	55                   	push   %ebp
f010058e:	89 e5                	mov    %esp,%ebp
f0100590:	83 ec 04             	sub    $0x4,%esp
f0100593:	8b 45 08             	mov    0x8(%ebp),%eax
f0100596:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	BackColor = num;
f010059a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
f010059e:	66 a3 40 f0 11 f0    	mov    %ax,0xf011f040
	ch_color = (num >> 8) & 0x00FF;
f01005a4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
f01005a8:	66 c1 e8 08          	shr    $0x8,%ax
f01005ac:	0f b7 c0             	movzwl %ax,%eax
f01005af:	25 ff 00 00 00       	and    $0xff,%eax
f01005b4:	a3 48 f6 11 f0       	mov    %eax,0xf011f648
}
f01005b9:	c9                   	leave  
f01005ba:	c3                   	ret    

f01005bb <cga_putc>:

void
cga_putc(int c)
{
f01005bb:	55                   	push   %ebp
f01005bc:	89 e5                	mov    %esp,%ebp
f01005be:	53                   	push   %ebx
f01005bf:	83 ec 44             	sub    $0x44,%esp
	// if no attribute given, then use black on white
    c = c + (ch_color << 8);
f01005c2:	a1 48 f6 11 f0       	mov    0xf011f648,%eax
f01005c7:	c1 e0 08             	shl    $0x8,%eax
f01005ca:	01 45 08             	add    %eax,0x8(%ebp)
    
	if (!(c & ~0xFF))
f01005cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01005d0:	b0 00                	mov    $0x0,%al
f01005d2:	85 c0                	test   %eax,%eax
f01005d4:	75 0d                	jne    f01005e3 <cga_putc+0x28>
		c |= BackColor;//the color
f01005d6:	0f b7 05 40 f0 11 f0 	movzwl 0xf011f040,%eax
f01005dd:	0f b7 c0             	movzwl %ax,%eax
f01005e0:	09 45 08             	or     %eax,0x8(%ebp)

	switch (c & 0xff) {
f01005e3:	8b 45 08             	mov    0x8(%ebp),%eax
f01005e6:	25 ff 00 00 00       	and    $0xff,%eax
f01005eb:	83 f8 09             	cmp    $0x9,%eax
f01005ee:	0f 84 ad 00 00 00    	je     f01006a1 <cga_putc+0xe6>
f01005f4:	83 f8 09             	cmp    $0x9,%eax
f01005f7:	7f 0a                	jg     f0100603 <cga_putc+0x48>
f01005f9:	83 f8 08             	cmp    $0x8,%eax
f01005fc:	74 14                	je     f0100612 <cga_putc+0x57>
f01005fe:	e9 dc 00 00 00       	jmp    f01006df <cga_putc+0x124>
f0100603:	83 f8 0a             	cmp    $0xa,%eax
f0100606:	74 4d                	je     f0100655 <cga_putc+0x9a>
f0100608:	83 f8 0d             	cmp    $0xd,%eax
f010060b:	74 58                	je     f0100665 <cga_putc+0xaa>
f010060d:	e9 cd 00 00 00       	jmp    f01006df <cga_putc+0x124>
	case '\b':
		if (crt_pos > 0) {
f0100612:	0f b7 05 ec 85 1a f0 	movzwl 0xf01a85ec,%eax
f0100619:	66 85 c0             	test   %ax,%ax
f010061c:	0f 84 e2 00 00 00    	je     f0100704 <cga_putc+0x149>
			crt_pos--;
f0100622:	0f b7 05 ec 85 1a f0 	movzwl 0xf01a85ec,%eax
f0100629:	83 e8 01             	sub    $0x1,%eax
f010062c:	66 a3 ec 85 1a f0    	mov    %ax,0xf01a85ec
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100632:	a1 e8 85 1a f0       	mov    0xf01a85e8,%eax
f0100637:	0f b7 15 ec 85 1a f0 	movzwl 0xf01a85ec,%edx
f010063e:	0f b7 d2             	movzwl %dx,%edx
f0100641:	01 d2                	add    %edx,%edx
f0100643:	01 c2                	add    %eax,%edx
f0100645:	8b 45 08             	mov    0x8(%ebp),%eax
f0100648:	b0 00                	mov    $0x0,%al
f010064a:	83 c8 20             	or     $0x20,%eax
f010064d:	66 89 02             	mov    %ax,(%edx)
		}
		break;
f0100650:	e9 af 00 00 00       	jmp    f0100704 <cga_putc+0x149>
	case '\n':
		crt_pos += CRT_COLS;
f0100655:	0f b7 05 ec 85 1a f0 	movzwl 0xf01a85ec,%eax
f010065c:	83 c0 50             	add    $0x50,%eax
f010065f:	66 a3 ec 85 1a f0    	mov    %ax,0xf01a85ec
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f0100665:	0f b7 1d ec 85 1a f0 	movzwl 0xf01a85ec,%ebx
f010066c:	0f b7 0d ec 85 1a f0 	movzwl 0xf01a85ec,%ecx
f0100673:	0f b7 c1             	movzwl %cx,%eax
f0100676:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010067c:	c1 e8 10             	shr    $0x10,%eax
f010067f:	89 c2                	mov    %eax,%edx
f0100681:	66 c1 ea 06          	shr    $0x6,%dx
f0100685:	89 d0                	mov    %edx,%eax
f0100687:	c1 e0 02             	shl    $0x2,%eax
f010068a:	01 d0                	add    %edx,%eax
f010068c:	c1 e0 04             	shl    $0x4,%eax
f010068f:	89 ca                	mov    %ecx,%edx
f0100691:	66 29 c2             	sub    %ax,%dx
f0100694:	89 d8                	mov    %ebx,%eax
f0100696:	66 29 d0             	sub    %dx,%ax
f0100699:	66 a3 ec 85 1a f0    	mov    %ax,0xf01a85ec
		break;
f010069f:	eb 64                	jmp    f0100705 <cga_putc+0x14a>
	case '\t':
		cons_putc(' ');
f01006a1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01006a8:	e8 ae 03 00 00       	call   f0100a5b <cons_putc>
		cons_putc(' ');
f01006ad:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01006b4:	e8 a2 03 00 00       	call   f0100a5b <cons_putc>
		cons_putc(' ');
f01006b9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01006c0:	e8 96 03 00 00       	call   f0100a5b <cons_putc>
		cons_putc(' ');
f01006c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01006cc:	e8 8a 03 00 00       	call   f0100a5b <cons_putc>
		cons_putc(' ');
f01006d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01006d8:	e8 7e 03 00 00       	call   f0100a5b <cons_putc>
		break;
f01006dd:	eb 26                	jmp    f0100705 <cga_putc+0x14a>
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f01006df:	8b 15 e8 85 1a f0    	mov    0xf01a85e8,%edx
f01006e5:	0f b7 05 ec 85 1a f0 	movzwl 0xf01a85ec,%eax
f01006ec:	0f b7 c8             	movzwl %ax,%ecx
f01006ef:	01 c9                	add    %ecx,%ecx
f01006f1:	01 d1                	add    %edx,%ecx
f01006f3:	8b 55 08             	mov    0x8(%ebp),%edx
f01006f6:	66 89 11             	mov    %dx,(%ecx)
f01006f9:	83 c0 01             	add    $0x1,%eax
f01006fc:	66 a3 ec 85 1a f0    	mov    %ax,0xf01a85ec
		break;
f0100702:	eb 01                	jmp    f0100705 <cga_putc+0x14a>
	case '\b':
		if (crt_pos > 0) {
			crt_pos--;
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
		}
		break;
f0100704:	90                   	nop
		crt_buf[crt_pos++] = c;		/* write the character */
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f0100705:	0f b7 05 ec 85 1a f0 	movzwl 0xf01a85ec,%eax
f010070c:	66 3d cf 07          	cmp    $0x7cf,%ax
f0100710:	76 5b                	jbe    f010076d <cga_putc+0x1b2>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100712:	a1 e8 85 1a f0       	mov    0xf01a85e8,%eax
f0100717:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f010071d:	a1 e8 85 1a f0       	mov    0xf01a85e8,%eax
f0100722:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f0100729:	00 
f010072a:	89 54 24 04          	mov    %edx,0x4(%esp)
f010072e:	89 04 24             	mov    %eax,(%esp)
f0100731:	e8 ee 6a 00 00       	call   f0107224 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100736:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
f010073d:	eb 15                	jmp    f0100754 <cga_putc+0x199>
			crt_buf[i] = 0x0700 | ' ';
f010073f:	a1 e8 85 1a f0       	mov    0xf01a85e8,%eax
f0100744:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100747:	01 d2                	add    %edx,%edx
f0100749:	01 d0                	add    %edx,%eax
f010074b:	66 c7 00 20 07       	movw   $0x720,(%eax)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100750:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0100754:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
f010075b:	7e e2                	jle    f010073f <cga_putc+0x184>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f010075d:	0f b7 05 ec 85 1a f0 	movzwl 0xf01a85ec,%eax
f0100764:	83 e8 50             	sub    $0x50,%eax
f0100767:	66 a3 ec 85 1a f0    	mov    %ax,0xf01a85ec
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f010076d:	a1 e4 85 1a f0       	mov    0xf01a85e4,%eax
f0100772:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100775:	c6 45 ef 0e          	movb   $0xe,-0x11(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100779:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
f010077d:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100780:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100781:	0f b7 05 ec 85 1a f0 	movzwl 0xf01a85ec,%eax
f0100788:	66 c1 e8 08          	shr    $0x8,%ax
f010078c:	0f b6 c0             	movzbl %al,%eax
f010078f:	8b 15 e4 85 1a f0    	mov    0xf01a85e4,%edx
f0100795:	83 c2 01             	add    $0x1,%edx
f0100798:	89 55 e8             	mov    %edx,-0x18(%ebp)
f010079b:	88 45 e7             	mov    %al,-0x19(%ebp)
f010079e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f01007a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01007a5:	ee                   	out    %al,(%dx)
	outb(addr_6845, 15);
f01007a6:	a1 e4 85 1a f0       	mov    0xf01a85e4,%eax
f01007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01007ae:	c6 45 df 0f          	movb   $0xf,-0x21(%ebp)
f01007b2:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
f01007b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01007b9:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos);
f01007ba:	0f b7 05 ec 85 1a f0 	movzwl 0xf01a85ec,%eax
f01007c1:	0f b6 c0             	movzbl %al,%eax
f01007c4:	8b 15 e4 85 1a f0    	mov    0xf01a85e4,%edx
f01007ca:	83 c2 01             	add    $0x1,%edx
f01007cd:	89 55 d8             	mov    %edx,-0x28(%ebp)
f01007d0:	88 45 d7             	mov    %al,-0x29(%ebp)
f01007d3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
f01007d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01007da:	ee                   	out    %al,(%dx)
}
f01007db:	83 c4 44             	add    $0x44,%esp
f01007de:	5b                   	pop    %ebx
f01007df:	5d                   	pop    %ebp
f01007e0:	c3                   	ret    

f01007e1 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f01007e1:	55                   	push   %ebp
f01007e2:	89 e5                	mov    %esp,%ebp
f01007e4:	53                   	push   %ebx
f01007e5:	83 ec 44             	sub    $0x44,%esp
f01007e8:	c7 45 ec 64 00 00 00 	movl   $0x64,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
f01007f2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f01007f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01007f8:	ec                   	in     (%dx),%al
f01007f9:	89 c3                	mov    %eax,%ebx
f01007fb:	88 5d eb             	mov    %bl,-0x15(%ebp)
	return data;
f01007fe:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f0100802:	0f b6 c0             	movzbl %al,%eax
f0100805:	83 e0 01             	and    $0x1,%eax
f0100808:	85 c0                	test   %eax,%eax
f010080a:	75 0a                	jne    f0100816 <kbd_proc_data+0x35>
		return -1;
f010080c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100811:	e9 5f 01 00 00       	jmp    f0100975 <kbd_proc_data+0x194>
f0100816:	c7 45 e4 60 00 00 00 	movl   $0x60,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010081d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0100820:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0100823:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100826:	ec                   	in     (%dx),%al
f0100827:	89 c3                	mov    %eax,%ebx
f0100829:	88 5d e3             	mov    %bl,-0x1d(%ebp)
	return data;
f010082c:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax

	data = inb(KBDATAP);
f0100830:	88 45 f3             	mov    %al,-0xd(%ebp)

	if (data == 0xE0) {
f0100833:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
f0100837:	75 17                	jne    f0100850 <kbd_proc_data+0x6f>
		// E0 escape character
		shift |= E0ESC;
f0100839:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f010083e:	83 c8 40             	or     $0x40,%eax
f0100841:	a3 08 88 1a f0       	mov    %eax,0xf01a8808
		return 0;
f0100846:	b8 00 00 00 00       	mov    $0x0,%eax
f010084b:	e9 25 01 00 00       	jmp    f0100975 <kbd_proc_data+0x194>
	} else if (data & 0x80) {
f0100850:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f0100854:	84 c0                	test   %al,%al
f0100856:	79 47                	jns    f010089f <kbd_proc_data+0xbe>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f0100858:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f010085d:	83 e0 40             	and    $0x40,%eax
f0100860:	85 c0                	test   %eax,%eax
f0100862:	75 09                	jne    f010086d <kbd_proc_data+0x8c>
f0100864:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f0100868:	83 e0 7f             	and    $0x7f,%eax
f010086b:	eb 04                	jmp    f0100871 <kbd_proc_data+0x90>
f010086d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f0100871:	88 45 f3             	mov    %al,-0xd(%ebp)
		shift &= ~(shiftcode[data] | E0ESC);
f0100874:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f0100878:	0f b6 80 60 f0 11 f0 	movzbl -0xfee0fa0(%eax),%eax
f010087f:	83 c8 40             	or     $0x40,%eax
f0100882:	0f b6 c0             	movzbl %al,%eax
f0100885:	f7 d0                	not    %eax
f0100887:	89 c2                	mov    %eax,%edx
f0100889:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f010088e:	21 d0                	and    %edx,%eax
f0100890:	a3 08 88 1a f0       	mov    %eax,0xf01a8808
		return 0;
f0100895:	b8 00 00 00 00       	mov    $0x0,%eax
f010089a:	e9 d6 00 00 00       	jmp    f0100975 <kbd_proc_data+0x194>
	} else if (shift & E0ESC) {
f010089f:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f01008a4:	83 e0 40             	and    $0x40,%eax
f01008a7:	85 c0                	test   %eax,%eax
f01008a9:	74 11                	je     f01008bc <kbd_proc_data+0xdb>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f01008ab:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
		shift &= ~E0ESC;
f01008af:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f01008b4:	83 e0 bf             	and    $0xffffffbf,%eax
f01008b7:	a3 08 88 1a f0       	mov    %eax,0xf01a8808
	}

	shift |= shiftcode[data];
f01008bc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01008c0:	0f b6 80 60 f0 11 f0 	movzbl -0xfee0fa0(%eax),%eax
f01008c7:	0f b6 d0             	movzbl %al,%edx
f01008ca:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f01008cf:	09 d0                	or     %edx,%eax
f01008d1:	a3 08 88 1a f0       	mov    %eax,0xf01a8808
	shift ^= togglecode[data];
f01008d6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01008da:	0f b6 80 60 f1 11 f0 	movzbl -0xfee0ea0(%eax),%eax
f01008e1:	0f b6 d0             	movzbl %al,%edx
f01008e4:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f01008e9:	31 d0                	xor    %edx,%eax
f01008eb:	a3 08 88 1a f0       	mov    %eax,0xf01a8808

	c = charcode[shift & (CTL | SHIFT)][data];
f01008f0:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f01008f5:	83 e0 03             	and    $0x3,%eax
f01008f8:	8b 14 85 60 f5 11 f0 	mov    -0xfee0aa0(,%eax,4),%edx
f01008ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f0100903:	01 d0                	add    %edx,%eax
f0100905:	0f b6 00             	movzbl (%eax),%eax
f0100908:	0f b6 c0             	movzbl %al,%eax
f010090b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (shift & CAPSLOCK) {
f010090e:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f0100913:	83 e0 08             	and    $0x8,%eax
f0100916:	85 c0                	test   %eax,%eax
f0100918:	74 22                	je     f010093c <kbd_proc_data+0x15b>
		if ('a' <= c && c <= 'z')
f010091a:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
f010091e:	7e 0c                	jle    f010092c <kbd_proc_data+0x14b>
f0100920:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
f0100924:	7f 06                	jg     f010092c <kbd_proc_data+0x14b>
			c += 'A' - 'a';
f0100926:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
f010092a:	eb 10                	jmp    f010093c <kbd_proc_data+0x15b>
		else if ('A' <= c && c <= 'Z')
f010092c:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
f0100930:	7e 0a                	jle    f010093c <kbd_proc_data+0x15b>
f0100932:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
f0100936:	7f 04                	jg     f010093c <kbd_proc_data+0x15b>
			c += 'a' - 'A';
f0100938:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010093c:	a1 08 88 1a f0       	mov    0xf01a8808,%eax
f0100941:	f7 d0                	not    %eax
f0100943:	83 e0 06             	and    $0x6,%eax
f0100946:	85 c0                	test   %eax,%eax
f0100948:	75 28                	jne    f0100972 <kbd_proc_data+0x191>
f010094a:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
f0100951:	75 1f                	jne    f0100972 <kbd_proc_data+0x191>
		cprintf("Rebooting!\n");
f0100953:	c7 04 24 96 78 10 f0 	movl   $0xf0107896,(%esp)
f010095a:	e8 2f 3d 00 00       	call   f010468e <cprintf>
f010095f:	c7 45 dc 92 00 00 00 	movl   $0x92,-0x24(%ebp)
f0100966:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010096a:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
f010096e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100971:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100972:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0100975:	83 c4 44             	add    $0x44,%esp
f0100978:	5b                   	pop    %ebx
f0100979:	5d                   	pop    %ebp
f010097a:	c3                   	ret    

f010097b <kbd_intr>:

void
kbd_intr(void)
{
f010097b:	55                   	push   %ebp
f010097c:	89 e5                	mov    %esp,%ebp
f010097e:	83 ec 18             	sub    $0x18,%esp
	cons_intr(kbd_proc_data);
f0100981:	c7 04 24 e1 07 10 f0 	movl   $0xf01007e1,(%esp)
f0100988:	e8 26 00 00 00       	call   f01009b3 <cons_intr>
}
f010098d:	c9                   	leave  
f010098e:	c3                   	ret    

f010098f <kbd_init>:

void
kbd_init(void)
{
f010098f:	55                   	push   %ebp
f0100990:	89 e5                	mov    %esp,%ebp
f0100992:	83 ec 18             	sub    $0x18,%esp
	// Drain the kbd buffer so that Bochs generates interrupts.
	kbd_intr();
f0100995:	e8 e1 ff ff ff       	call   f010097b <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f010099a:	0f b7 05 38 f6 11 f0 	movzwl 0xf011f638,%eax
f01009a1:	0f b7 c0             	movzwl %ax,%eax
f01009a4:	25 fd ff 00 00       	and    $0xfffd,%eax
f01009a9:	89 04 24             	mov    %eax,(%esp)
f01009ac:	e8 d5 3b 00 00       	call   f0104586 <irq_setmask_8259A>
}
f01009b1:	c9                   	leave  
f01009b2:	c3                   	ret    

f01009b3 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
void
cons_intr(int (*proc)(void))
{
f01009b3:	55                   	push   %ebp
f01009b4:	89 e5                	mov    %esp,%ebp
f01009b6:	83 ec 18             	sub    $0x18,%esp
	int c;

	while ((c = (*proc)()) != -1) {
f01009b9:	eb 35                	jmp    f01009f0 <cons_intr+0x3d>
		if (c == 0)
f01009bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01009bf:	74 2e                	je     f01009ef <cons_intr+0x3c>
			continue;
		cons.buf[cons.wpos++] = c;
f01009c1:	a1 04 88 1a f0       	mov    0xf01a8804,%eax
f01009c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01009c9:	88 90 00 86 1a f0    	mov    %dl,-0xfe57a00(%eax)
f01009cf:	83 c0 01             	add    $0x1,%eax
f01009d2:	a3 04 88 1a f0       	mov    %eax,0xf01a8804
		if (cons.wpos == CONSBUFSIZE)
f01009d7:	a1 04 88 1a f0       	mov    0xf01a8804,%eax
f01009dc:	3d 00 02 00 00       	cmp    $0x200,%eax
f01009e1:	75 0d                	jne    f01009f0 <cons_intr+0x3d>
			cons.wpos = 0;
f01009e3:	c7 05 04 88 1a f0 00 	movl   $0x0,0xf01a8804
f01009ea:	00 00 00 
f01009ed:	eb 01                	jmp    f01009f0 <cons_intr+0x3d>
{
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
f01009ef:	90                   	nop
void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01009f0:	8b 45 08             	mov    0x8(%ebp),%eax
f01009f3:	ff d0                	call   *%eax
f01009f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01009f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
f01009fc:	75 bd                	jne    f01009bb <cons_intr+0x8>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f01009fe:	c9                   	leave  
f01009ff:	c3                   	ret    

f0100a00 <cons_getc>:

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f0100a00:	55                   	push   %ebp
f0100a01:	89 e5                	mov    %esp,%ebp
f0100a03:	83 ec 18             	sub    $0x18,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f0100a06:	e8 9a f8 ff ff       	call   f01002a5 <serial_intr>
	kbd_intr();
f0100a0b:	e8 6b ff ff ff       	call   f010097b <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f0100a10:	8b 15 00 88 1a f0    	mov    0xf01a8800,%edx
f0100a16:	a1 04 88 1a f0       	mov    0xf01a8804,%eax
f0100a1b:	39 c2                	cmp    %eax,%edx
f0100a1d:	74 35                	je     f0100a54 <cons_getc+0x54>
		c = cons.buf[cons.rpos++];
f0100a1f:	a1 00 88 1a f0       	mov    0xf01a8800,%eax
f0100a24:	0f b6 90 00 86 1a f0 	movzbl -0xfe57a00(%eax),%edx
f0100a2b:	0f b6 d2             	movzbl %dl,%edx
f0100a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0100a31:	83 c0 01             	add    $0x1,%eax
f0100a34:	a3 00 88 1a f0       	mov    %eax,0xf01a8800
		if (cons.rpos == CONSBUFSIZE)
f0100a39:	a1 00 88 1a f0       	mov    0xf01a8800,%eax
f0100a3e:	3d 00 02 00 00       	cmp    $0x200,%eax
f0100a43:	75 0a                	jne    f0100a4f <cons_getc+0x4f>
			cons.rpos = 0;
f0100a45:	c7 05 00 88 1a f0 00 	movl   $0x0,0xf01a8800
f0100a4c:	00 00 00 
		return c;
f0100a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100a52:	eb 05                	jmp    f0100a59 <cons_getc+0x59>
	}
	return 0;
f0100a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100a59:	c9                   	leave  
f0100a5a:	c3                   	ret    

f0100a5b <cons_putc>:

// output a character to the console
void
cons_putc(int c)
{
f0100a5b:	55                   	push   %ebp
f0100a5c:	89 e5                	mov    %esp,%ebp
f0100a5e:	83 ec 18             	sub    $0x18,%esp
	lpt_putc(c);
f0100a61:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a64:	89 04 24             	mov    %eax,(%esp)
f0100a67:	e8 c0 f9 ff ff       	call   f010042c <lpt_putc>
	cga_putc(c);
f0100a6c:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a6f:	89 04 24             	mov    %eax,(%esp)
f0100a72:	e8 44 fb ff ff       	call   f01005bb <cga_putc>
}
f0100a77:	c9                   	leave  
f0100a78:	c3                   	ret    

f0100a79 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100a79:	55                   	push   %ebp
f0100a7a:	89 e5                	mov    %esp,%ebp
f0100a7c:	83 ec 18             	sub    $0x18,%esp
	cga_init();
f0100a7f:	e8 2c fa ff ff       	call   f01004b0 <cga_init>
	kbd_init();
f0100a84:	e8 06 ff ff ff       	call   f010098f <kbd_init>
	serial_init();
f0100a89:	e8 34 f8 ff ff       	call   f01002c2 <serial_init>

	if (!serial_exists)
f0100a8e:	a1 e0 85 1a f0       	mov    0xf01a85e0,%eax
f0100a93:	85 c0                	test   %eax,%eax
f0100a95:	75 0c                	jne    f0100aa3 <cons_init+0x2a>
		cprintf("Serial port does not exist!\n");
f0100a97:	c7 04 24 a2 78 10 f0 	movl   $0xf01078a2,(%esp)
f0100a9e:	e8 eb 3b 00 00       	call   f010468e <cprintf>
}
f0100aa3:	c9                   	leave  
f0100aa4:	c3                   	ret    

f0100aa5 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100aa5:	55                   	push   %ebp
f0100aa6:	89 e5                	mov    %esp,%ebp
f0100aa8:	83 ec 18             	sub    $0x18,%esp
	cons_putc(c);
f0100aab:	8b 45 08             	mov    0x8(%ebp),%eax
f0100aae:	89 04 24             	mov    %eax,(%esp)
f0100ab1:	e8 a5 ff ff ff       	call   f0100a5b <cons_putc>
}
f0100ab6:	c9                   	leave  
f0100ab7:	c3                   	ret    

f0100ab8 <getchar>:

int
getchar(void)
{
f0100ab8:	55                   	push   %ebp
f0100ab9:	89 e5                	mov    %esp,%ebp
f0100abb:	83 ec 18             	sub    $0x18,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100abe:	e8 3d ff ff ff       	call   f0100a00 <cons_getc>
f0100ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0100ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0100aca:	74 f2                	je     f0100abe <getchar+0x6>
		/* do nothing */;
	return c;
f0100acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0100acf:	c9                   	leave  
f0100ad0:	c3                   	ret    

f0100ad1 <iscons>:

int
iscons(int fdnum)
{
f0100ad1:	55                   	push   %ebp
f0100ad2:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
f0100ad4:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0100ad9:	5d                   	pop    %ebp
f0100ada:	c3                   	ret    
	...

f0100adc <pa2page>:
	return page2ppn(pp) << PGSHIFT;
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f0100adc:	55                   	push   %ebp
f0100add:	89 e5                	mov    %esp,%ebp
f0100adf:	83 ec 18             	sub    $0x18,%esp
	if (PPN(pa) >= npage)
f0100ae2:	8b 45 08             	mov    0x8(%ebp),%eax
f0100ae5:	89 c2                	mov    %eax,%edx
f0100ae7:	c1 ea 0c             	shr    $0xc,%edx
f0100aea:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f0100aef:	39 c2                	cmp    %eax,%edx
f0100af1:	72 1c                	jb     f0100b0f <pa2page+0x33>
		panic("pa2page called with invalid pa");
f0100af3:	c7 44 24 08 c0 78 10 	movl   $0xf01078c0,0x8(%esp)
f0100afa:	f0 
f0100afb:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0100b02:	00 
f0100b03:	c7 04 24 df 78 10 f0 	movl   $0xf01078df,(%esp)
f0100b0a:	e8 8f f6 ff ff       	call   f010019e <_panic>
	return &pages[PPN(pa)];
f0100b0f:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f0100b15:	8b 45 08             	mov    0x8(%ebp),%eax
f0100b18:	89 c2                	mov    %eax,%edx
f0100b1a:	c1 ea 0c             	shr    $0xc,%edx
f0100b1d:	89 d0                	mov    %edx,%eax
f0100b1f:	01 c0                	add    %eax,%eax
f0100b21:	01 d0                	add    %edx,%eax
f0100b23:	c1 e0 02             	shl    $0x2,%eax
f0100b26:	01 c8                	add    %ecx,%eax
}
f0100b28:	c9                   	leave  
f0100b29:	c3                   	ret    

f0100b2a <StrToNum>:
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

//str -> num based also can use strtol ?
int StrToNum(char *str,int base){
f0100b2a:	55                   	push   %ebp
f0100b2b:	89 e5                	mov    %esp,%ebp
f0100b2d:	83 ec 28             	sub    $0x28,%esp
        int i,sum = 0;
f0100b30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(i=0;str[i]!='\0';i++){
f0100b37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0100b3e:	e9 8a 00 00 00       	jmp    f0100bcd <StrToNum+0xa3>
        	if(base != 10&&i<2) continue;
f0100b43:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
f0100b47:	74 06                	je     f0100b4f <StrToNum+0x25>
f0100b49:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
f0100b4d:	7e 79                	jle    f0100bc8 <StrToNum+0x9e>
              sum *= base;
f0100b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100b52:	0f af 45 0c          	imul   0xc(%ebp),%eax
f0100b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
              if(str[i]>='0'&&str[i]<='9') sum += (str[i]-'0');
f0100b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100b5c:	03 45 08             	add    0x8(%ebp),%eax
f0100b5f:	0f b6 00             	movzbl (%eax),%eax
f0100b62:	3c 2f                	cmp    $0x2f,%al
f0100b64:	7e 21                	jle    f0100b87 <StrToNum+0x5d>
f0100b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100b69:	03 45 08             	add    0x8(%ebp),%eax
f0100b6c:	0f b6 00             	movzbl (%eax),%eax
f0100b6f:	3c 39                	cmp    $0x39,%al
f0100b71:	7f 14                	jg     f0100b87 <StrToNum+0x5d>
f0100b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100b76:	03 45 08             	add    0x8(%ebp),%eax
f0100b79:	0f b6 00             	movzbl (%eax),%eax
f0100b7c:	0f be c0             	movsbl %al,%eax
f0100b7f:	83 e8 30             	sub    $0x30,%eax
f0100b82:	01 45 f0             	add    %eax,-0x10(%ebp)
f0100b85:	eb 42                	jmp    f0100bc9 <StrToNum+0x9f>
              else if(str[i]>='a'&&str[i]<='f') sum += (str[i]+10-'a');
f0100b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100b8a:	03 45 08             	add    0x8(%ebp),%eax
f0100b8d:	0f b6 00             	movzbl (%eax),%eax
f0100b90:	3c 60                	cmp    $0x60,%al
f0100b92:	7e 21                	jle    f0100bb5 <StrToNum+0x8b>
f0100b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100b97:	03 45 08             	add    0x8(%ebp),%eax
f0100b9a:	0f b6 00             	movzbl (%eax),%eax
f0100b9d:	3c 66                	cmp    $0x66,%al
f0100b9f:	7f 14                	jg     f0100bb5 <StrToNum+0x8b>
f0100ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100ba4:	03 45 08             	add    0x8(%ebp),%eax
f0100ba7:	0f b6 00             	movzbl (%eax),%eax
f0100baa:	0f be c0             	movsbl %al,%eax
f0100bad:	83 e8 57             	sub    $0x57,%eax
f0100bb0:	01 45 f0             	add    %eax,-0x10(%ebp)
f0100bb3:	eb 14                	jmp    f0100bc9 <StrToNum+0x9f>
              else {cprintf("wrong input num ! \n");return 0;}
f0100bb5:	c7 04 24 ed 78 10 f0 	movl   $0xf01078ed,(%esp)
f0100bbc:	e8 cd 3a 00 00       	call   f010468e <cprintf>
f0100bc1:	b8 00 00 00 00       	mov    $0x0,%eax
f0100bc6:	eb 19                	jmp    f0100be1 <StrToNum+0xb7>

//str -> num based also can use strtol ?
int StrToNum(char *str,int base){
        int i,sum = 0;
        for(i=0;str[i]!='\0';i++){
        	if(base != 10&&i<2) continue;
f0100bc8:	90                   	nop
};

//str -> num based also can use strtol ?
int StrToNum(char *str,int base){
        int i,sum = 0;
        for(i=0;str[i]!='\0';i++){
f0100bc9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0100bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100bd0:	03 45 08             	add    0x8(%ebp),%eax
f0100bd3:	0f b6 00             	movzbl (%eax),%eax
f0100bd6:	84 c0                	test   %al,%al
f0100bd8:	0f 85 65 ff ff ff    	jne    f0100b43 <StrToNum+0x19>
              if(str[i]>='0'&&str[i]<='9') sum += (str[i]-'0');
              else if(str[i]>='a'&&str[i]<='f') sum += (str[i]+10-'a');
              else {cprintf("wrong input num ! \n");return 0;}
        }
        //cprintf(" set to be %d\n",sum);
        return sum;
f0100bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
f0100be1:	c9                   	leave  
f0100be2:	c3                   	ret    

f0100be3 <mon_add>:
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

unsigned read_eip();

int
mon_add(int argc, char **argv, struct Trapframe *tf){
f0100be3:	55                   	push   %ebp
f0100be4:	89 e5                	mov    %esp,%ebp
f0100be6:	83 ec 28             	sub    $0x28,%esp
       int sum = 0;
f0100be9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
       int i;
       for(i=1;i<argc;i++){
f0100bf0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
f0100bf7:	eb 22                	jmp    f0100c1b <mon_add+0x38>
       	sum += StrToNum(argv[i],10);
f0100bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100bfc:	c1 e0 02             	shl    $0x2,%eax
f0100bff:	03 45 0c             	add    0xc(%ebp),%eax
f0100c02:	8b 00                	mov    (%eax),%eax
f0100c04:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
f0100c0b:	00 
f0100c0c:	89 04 24             	mov    %eax,(%esp)
f0100c0f:	e8 16 ff ff ff       	call   f0100b2a <StrToNum>
f0100c14:	01 45 f4             	add    %eax,-0xc(%ebp)

int
mon_add(int argc, char **argv, struct Trapframe *tf){
       int sum = 0;
       int i;
       for(i=1;i<argc;i++){
f0100c17:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f0100c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100c1e:	3b 45 08             	cmp    0x8(%ebp),%eax
f0100c21:	7c d6                	jl     f0100bf9 <mon_add+0x16>
       	sum += StrToNum(argv[i],10);
       }
       cprintf("the sum is %d\n",sum);
f0100c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100c26:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c2a:	c7 04 24 8b 7a 10 f0 	movl   $0xf0107a8b,(%esp)
f0100c31:	e8 58 3a 00 00       	call   f010468e <cprintf>
       return 0;
f0100c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100c3b:	c9                   	leave  
f0100c3c:	c3                   	ret    

f0100c3d <mon_mul>:
int
mon_mul(int argc, char **argv, struct Trapframe *tf){
f0100c3d:	55                   	push   %ebp
f0100c3e:	89 e5                	mov    %esp,%ebp
f0100c40:	83 ec 28             	sub    $0x28,%esp
       int sum = 1;
f0100c43:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
       int i;
       for(i=1;i<argc;i++){
f0100c4a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
f0100c51:	eb 28                	jmp    f0100c7b <mon_mul+0x3e>
       	sum *= StrToNum(argv[i],10);
f0100c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100c56:	c1 e0 02             	shl    $0x2,%eax
f0100c59:	03 45 0c             	add    0xc(%ebp),%eax
f0100c5c:	8b 00                	mov    (%eax),%eax
f0100c5e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
f0100c65:	00 
f0100c66:	89 04 24             	mov    %eax,(%esp)
f0100c69:	e8 bc fe ff ff       	call   f0100b2a <StrToNum>
f0100c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100c71:	0f af c2             	imul   %edx,%eax
f0100c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
}
int
mon_mul(int argc, char **argv, struct Trapframe *tf){
       int sum = 1;
       int i;
       for(i=1;i<argc;i++){
f0100c77:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f0100c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100c7e:	3b 45 08             	cmp    0x8(%ebp),%eax
f0100c81:	7c d0                	jl     f0100c53 <mon_mul+0x16>
       	sum *= StrToNum(argv[i],10);
       }
       cprintf("the produce is %d\n",sum);
f0100c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c8a:	c7 04 24 9a 7a 10 f0 	movl   $0xf0107a9a,(%esp)
f0100c91:	e8 f8 39 00 00       	call   f010468e <cprintf>
       return 0;
f0100c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100c9b:	c9                   	leave  
f0100c9c:	c3                   	ret    

f0100c9d <mon_setcolor>:

int
mon_setcolor(int argc, char **argv, struct Trapframe *tf){
f0100c9d:	55                   	push   %ebp
f0100c9e:	89 e5                	mov    %esp,%ebp
f0100ca0:	83 ec 18             	sub    $0x18,%esp
       if(argc<2||argc>2) cprintf("the argc wrong!\n");
f0100ca3:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
f0100ca7:	7e 06                	jle    f0100caf <mon_setcolor+0x12>
f0100ca9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100cad:	7e 0e                	jle    f0100cbd <mon_setcolor+0x20>
f0100caf:	c7 04 24 ad 7a 10 f0 	movl   $0xf0107aad,(%esp)
f0100cb6:	e8 d3 39 00 00       	call   f010468e <cprintf>
f0100cbb:	eb 3b                	jmp    f0100cf8 <mon_setcolor+0x5b>
       else {
            cprintf("set color to %s\n",argv[1]); 
f0100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100cc0:	83 c0 04             	add    $0x4,%eax
f0100cc3:	8b 00                	mov    (%eax),%eax
f0100cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100cc9:	c7 04 24 be 7a 10 f0 	movl   $0xf0107abe,(%esp)
f0100cd0:	e8 b9 39 00 00       	call   f010468e <cprintf>
            SetBackColor(StrToNum(argv[1],16));//test for strtol(argv,0,0)
f0100cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100cd8:	83 c0 04             	add    $0x4,%eax
f0100cdb:	8b 00                	mov    (%eax),%eax
f0100cdd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100ce4:	00 
f0100ce5:	89 04 24             	mov    %eax,(%esp)
f0100ce8:	e8 3d fe ff ff       	call   f0100b2a <StrToNum>
f0100ced:	0f b7 c0             	movzwl %ax,%eax
f0100cf0:	89 04 24             	mov    %eax,(%esp)
f0100cf3:	e8 95 f8 ff ff       	call   f010058d <SetBackColor>
            }
       return 0;
f0100cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100cfd:	c9                   	leave  
f0100cfe:	c3                   	ret    

f0100cff <showmappings>:

void 
showmappings(int32_t lva, int32_t hva){
f0100cff:	55                   	push   %ebp
f0100d00:	89 e5                	mov    %esp,%ebp
f0100d02:	83 ec 28             	sub    $0x28,%esp
	pte_t *pte;
	while(lva < hva){
f0100d05:	e9 d7 00 00 00       	jmp    f0100de1 <showmappings+0xe2>
		pte = pgdir_walk(boot_pgdir, (void *)lva, 0);
f0100d0a:	8b 55 08             	mov    0x8(%ebp),%edx
f0100d0d:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0100d12:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100d19:	00 
f0100d1a:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100d1e:	89 04 24             	mov    %eax,(%esp)
f0100d21:	e8 32 1b 00 00       	call   f0102858 <pgdir_walk>
f0100d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cprintf("va : 0x%x -- 0x%x : ",lva, lva + PGSIZE);
f0100d29:	8b 45 08             	mov    0x8(%ebp),%eax
f0100d2c:	05 00 10 00 00       	add    $0x1000,%eax
f0100d31:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100d35:	8b 45 08             	mov    0x8(%ebp),%eax
f0100d38:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d3c:	c7 04 24 cf 7a 10 f0 	movl   $0xf0107acf,(%esp)
f0100d43:	e8 46 39 00 00       	call   f010468e <cprintf>
		if(pte == NULL||!(*pte & PTE_P)) cprintf("Not Mapped\n");
f0100d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0100d4c:	74 0c                	je     f0100d5a <showmappings+0x5b>
f0100d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100d51:	8b 00                	mov    (%eax),%eax
f0100d53:	83 e0 01             	and    $0x1,%eax
f0100d56:	85 c0                	test   %eax,%eax
f0100d58:	75 0e                	jne    f0100d68 <showmappings+0x69>
f0100d5a:	c7 04 24 e4 7a 10 f0 	movl   $0xf0107ae4,(%esp)
f0100d61:	e8 28 39 00 00       	call   f010468e <cprintf>
f0100d66:	eb 72                	jmp    f0100dda <showmappings+0xdb>
		else{
			cprintf("pa: 0x%x  ",PTE_ADDR(*pte));
f0100d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100d6b:	8b 00                	mov    (%eax),%eax
f0100d6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d76:	c7 04 24 f0 7a 10 f0 	movl   $0xf0107af0,(%esp)
f0100d7d:	e8 0c 39 00 00       	call   f010468e <cprintf>
			if(*pte & PTE_U) cprintf("User ");
f0100d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100d85:	8b 00                	mov    (%eax),%eax
f0100d87:	83 e0 04             	and    $0x4,%eax
f0100d8a:	85 c0                	test   %eax,%eax
f0100d8c:	74 0e                	je     f0100d9c <showmappings+0x9d>
f0100d8e:	c7 04 24 fb 7a 10 f0 	movl   $0xf0107afb,(%esp)
f0100d95:	e8 f4 38 00 00       	call   f010468e <cprintf>
f0100d9a:	eb 0c                	jmp    f0100da8 <showmappings+0xa9>
			else cprintf("Kernel ");
f0100d9c:	c7 04 24 01 7b 10 f0 	movl   $0xf0107b01,(%esp)
f0100da3:	e8 e6 38 00 00       	call   f010468e <cprintf>
			if(*pte & PTE_W) cprintf("Read/Write");
f0100da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100dab:	8b 00                	mov    (%eax),%eax
f0100dad:	83 e0 02             	and    $0x2,%eax
f0100db0:	85 c0                	test   %eax,%eax
f0100db2:	74 0e                	je     f0100dc2 <showmappings+0xc3>
f0100db4:	c7 04 24 09 7b 10 f0 	movl   $0xf0107b09,(%esp)
f0100dbb:	e8 ce 38 00 00       	call   f010468e <cprintf>
f0100dc0:	eb 0c                	jmp    f0100dce <showmappings+0xcf>
			else cprintf("Read Only");
f0100dc2:	c7 04 24 14 7b 10 f0 	movl   $0xf0107b14,(%esp)
f0100dc9:	e8 c0 38 00 00       	call   f010468e <cprintf>
			cprintf("\n");
f0100dce:	c7 04 24 1e 7b 10 f0 	movl   $0xf0107b1e,(%esp)
f0100dd5:	e8 b4 38 00 00       	call   f010468e <cprintf>
		}
		lva += PGSIZE;
f0100dda:	81 45 08 00 10 00 00 	addl   $0x1000,0x8(%ebp)
}

void 
showmappings(int32_t lva, int32_t hva){
	pte_t *pte;
	while(lva < hva){
f0100de1:	8b 45 08             	mov    0x8(%ebp),%eax
f0100de4:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0100de7:	0f 8c 1d ff ff ff    	jl     f0100d0a <showmappings+0xb>
			else cprintf("Read Only");
			cprintf("\n");
		}
		lva += PGSIZE;
	}
}
f0100ded:	c9                   	leave  
f0100dee:	c3                   	ret    

f0100def <mon_showmappings>:
int
mon_showmappings(int argc, char **argv, struct Trapframe *tf){
f0100def:	55                   	push   %ebp
f0100df0:	89 e5                	mov    %esp,%ebp
f0100df2:	83 ec 38             	sub    $0x38,%esp
	if(argc != 3){
f0100df5:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100df9:	74 16                	je     f0100e11 <mon_showmappings+0x22>
		cprintf("Hit: showmappings [LOWER_ADDR] [HIGHER_ADDER]\n");
f0100dfb:	c7 04 24 20 7b 10 f0 	movl   $0xf0107b20,(%esp)
f0100e02:	e8 87 38 00 00       	call   f010468e <cprintf>
		return 0;
f0100e07:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e0c:	e9 e4 00 00 00       	jmp    f0100ef5 <mon_showmappings+0x106>
	}
	uint32_t lva = strtol(argv[1], 0, 0);
f0100e11:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100e14:	83 c0 04             	add    $0x4,%eax
f0100e17:	8b 00                	mov    (%eax),%eax
f0100e19:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100e20:	00 
f0100e21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100e28:	00 
f0100e29:	89 04 24             	mov    %eax,(%esp)
f0100e2c:	e8 27 65 00 00       	call   f0107358 <strtol>
f0100e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t hva = strtol(argv[2], 0, 0);
f0100e34:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100e37:	83 c0 08             	add    $0x8,%eax
f0100e3a:	8b 00                	mov    (%eax),%eax
f0100e3c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100e43:	00 
f0100e44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100e4b:	00 
f0100e4c:	89 04 24             	mov    %eax,(%esp)
f0100e4f:	e8 04 65 00 00       	call   f0107358 <strtol>
f0100e54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
	if(lva != ROUNDUP(lva, PGSIZE)||
f0100e57:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
f0100e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100e64:	01 d0                	add    %edx,%eax
f0100e66:	83 e8 01             	sub    $0x1,%eax
f0100e69:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0100e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0100e6f:	ba 00 00 00 00       	mov    $0x0,%edx
f0100e74:	f7 75 ec             	divl   -0x14(%ebp)
f0100e77:	89 d0                	mov    %edx,%eax
f0100e79:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0100e7c:	89 d1                	mov    %edx,%ecx
f0100e7e:	29 c1                	sub    %eax,%ecx
f0100e80:	89 c8                	mov    %ecx,%eax
f0100e82:	3b 45 f4             	cmp    -0xc(%ebp),%eax
f0100e85:	75 38                	jne    f0100ebf <mon_showmappings+0xd0>
	   hva != ROUNDUP(hva, PGSIZE)||
f0100e87:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
f0100e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e91:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100e94:	01 d0                	add    %edx,%eax
f0100e96:	83 e8 01             	sub    $0x1,%eax
f0100e99:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e9f:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ea4:	f7 75 e4             	divl   -0x1c(%ebp)
f0100ea7:	89 d0                	mov    %edx,%eax
f0100ea9:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0100eac:	89 d1                	mov    %edx,%ecx
f0100eae:	29 c1                	sub    %eax,%ecx
f0100eb0:	89 c8                	mov    %ecx,%eax
		return 0;
	}
	uint32_t lva = strtol(argv[1], 0, 0);
	uint32_t hva = strtol(argv[2], 0, 0);
	
	if(lva != ROUNDUP(lva, PGSIZE)||
f0100eb2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
f0100eb5:	75 08                	jne    f0100ebf <mon_showmappings+0xd0>
	   hva != ROUNDUP(hva, PGSIZE)||
f0100eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100eba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
f0100ebd:	76 1f                	jbe    f0100ede <mon_showmappings+0xef>
	   lva > hva){
		cprintf("showmappings : Invalid address\n");
f0100ebf:	c7 04 24 50 7b 10 f0 	movl   $0xf0107b50,(%esp)
f0100ec6:	e8 c3 37 00 00       	call   f010468e <cprintf>
		cprintf("Both address must be aligned in 4KB\n");
f0100ecb:	c7 04 24 70 7b 10 f0 	movl   $0xf0107b70,(%esp)
f0100ed2:	e8 b7 37 00 00       	call   f010468e <cprintf>
		return 0;
f0100ed7:	b8 00 00 00 00       	mov    $0x0,%eax
f0100edc:	eb 17                	jmp    f0100ef5 <mon_showmappings+0x106>
	}
	showmappings(lva, hva);
f0100ede:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100ee4:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100ee8:	89 04 24             	mov    %eax,(%esp)
f0100eeb:	e8 0f fe ff ff       	call   f0100cff <showmappings>
	return 0;
f0100ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100ef5:	c9                   	leave  
f0100ef6:	c3                   	ret    

f0100ef7 <setmappings>:

void setmappings(uint32_t va, uint32_t memsize, uint32_t pa, int perm){
f0100ef7:	55                   	push   %ebp
f0100ef8:	89 e5                	mov    %esp,%ebp
f0100efa:	53                   	push   %ebx
f0100efb:	83 ec 24             	sub    $0x24,%esp
	uint32_t offset;
	for(offset = 0; offset < memsize; offset += PGSIZE){
f0100efe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0100f05:	eb 3e                	jmp    f0100f45 <setmappings+0x4e>
		page_insert(boot_pgdir, pa2page(pa + offset), (void *)va + offset, perm);
f0100f07:	8b 45 08             	mov    0x8(%ebp),%eax
f0100f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100f0d:	01 d0                	add    %edx,%eax
f0100f0f:	89 c3                	mov    %eax,%ebx
f0100f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100f14:	8b 55 10             	mov    0x10(%ebp),%edx
f0100f17:	01 d0                	add    %edx,%eax
f0100f19:	89 04 24             	mov    %eax,(%esp)
f0100f1c:	e8 bb fb ff ff       	call   f0100adc <pa2page>
f0100f21:	8b 15 c8 94 1a f0    	mov    0xf01a94c8,%edx
f0100f27:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0100f2a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0100f2e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100f32:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100f36:	89 14 24             	mov    %edx,(%esp)
f0100f39:	e8 96 1a 00 00       	call   f01029d4 <page_insert>
	return 0;
}

void setmappings(uint32_t va, uint32_t memsize, uint32_t pa, int perm){
	uint32_t offset;
	for(offset = 0; offset < memsize; offset += PGSIZE){
f0100f3e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f0100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100f48:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0100f4b:	72 ba                	jb     f0100f07 <setmappings+0x10>
		page_insert(boot_pgdir, pa2page(pa + offset), (void *)va + offset, perm);
	}
}
f0100f4d:	83 c4 24             	add    $0x24,%esp
f0100f50:	5b                   	pop    %ebx
f0100f51:	5d                   	pop    %ebp
f0100f52:	c3                   	ret    

f0100f53 <mon_setmappings>:
int 
mon_setmappings(int argc, char **argv, struct Trapframe *tf){
f0100f53:	55                   	push   %ebp
f0100f54:	89 e5                	mov    %esp,%ebp
f0100f56:	83 ec 48             	sub    $0x48,%esp
	if (argc != 5) {
f0100f59:	83 7d 08 05          	cmpl   $0x5,0x8(%ebp)
f0100f5d:	74 46                	je     f0100fa5 <mon_setmappings+0x52>
		cprintf ("Usage: setmappings [VIRTUAL_ADDR] [PAGE_NUM] [PHYSICAL_ADDR] [PERMISSION]\n");
f0100f5f:	c7 04 24 98 7b 10 f0 	movl   $0xf0107b98,(%esp)
f0100f66:	e8 23 37 00 00       	call   f010468e <cprintf>
		cprintf ("Both virtual address and physical address must be aligned in 4KB\n");
f0100f6b:	c7 04 24 e4 7b 10 f0 	movl   $0xf0107be4,(%esp)
f0100f72:	e8 17 37 00 00       	call   f010468e <cprintf>
		cprintf ("Permission is one of 4 options ('ur', 'uw', 'kr', 'kw')\n");
f0100f77:	c7 04 24 28 7c 10 f0 	movl   $0xf0107c28,(%esp)
f0100f7e:	e8 0b 37 00 00       	call   f010468e <cprintf>
		cprintf ("u stands for user mode, k for kernel mode\n");
f0100f83:	c7 04 24 64 7c 10 f0 	movl   $0xf0107c64,(%esp)
f0100f8a:	e8 ff 36 00 00       	call   f010468e <cprintf>
		cprintf ("\nMake sure that the physical memory space has already been mounted before\n");
f0100f8f:	c7 04 24 90 7c 10 f0 	movl   $0xf0107c90,(%esp)
f0100f96:	e8 f3 36 00 00       	call   f010468e <cprintf>
		return 0;
f0100f9b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fa0:	e9 d1 01 00 00       	jmp    f0101176 <mon_setmappings+0x223>
	}
	uint32_t va = strtol(argv[1], 0, 0);
f0100fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100fa8:	83 c0 04             	add    $0x4,%eax
f0100fab:	8b 00                	mov    (%eax),%eax
f0100fad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100fb4:	00 
f0100fb5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100fbc:	00 
f0100fbd:	89 04 24             	mov    %eax,(%esp)
f0100fc0:	e8 93 63 00 00       	call   f0107358 <strtol>
f0100fc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32_t pa = strtol(argv[3], 0, 0);
f0100fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100fcb:	83 c0 0c             	add    $0xc,%eax
f0100fce:	8b 00                	mov    (%eax),%eax
f0100fd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100fd7:	00 
f0100fd8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100fdf:	00 
f0100fe0:	89 04 24             	mov    %eax,(%esp)
f0100fe3:	e8 70 63 00 00       	call   f0107358 <strtol>
f0100fe8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32_t perm = 0;
f0100feb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32_t memsize = strtol(argv[2], 0, 0) * PGSIZE;
f0100ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100ff5:	83 c0 08             	add    $0x8,%eax
f0100ff8:	8b 00                	mov    (%eax),%eax
f0100ffa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101001:	00 
f0101002:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101009:	00 
f010100a:	89 04 24             	mov    %eax,(%esp)
f010100d:	e8 46 63 00 00       	call   f0107358 <strtol>
f0101012:	c1 e0 0c             	shl    $0xc,%eax
f0101015:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	
	if(va != ROUNDUP(va, PGSIZE)||
f0101018:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
f010101f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101022:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0101025:	01 d0                	add    %edx,%eax
f0101027:	83 e8 01             	sub    $0x1,%eax
f010102a:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010102d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101030:	ba 00 00 00 00       	mov    $0x0,%edx
f0101035:	f7 75 e0             	divl   -0x20(%ebp)
f0101038:	89 d0                	mov    %edx,%eax
f010103a:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010103d:	89 d1                	mov    %edx,%ecx
f010103f:	29 c1                	sub    %eax,%ecx
f0101041:	89 c8                	mov    %ecx,%eax
f0101043:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f0101046:	75 3a                	jne    f0101082 <mon_setmappings+0x12f>
	   pa != ROUNDUP(pa, PGSIZE)||
f0101048:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
f010104f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101052:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0101055:	01 d0                	add    %edx,%eax
f0101057:	83 e8 01             	sub    $0x1,%eax
f010105a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010105d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101060:	ba 00 00 00 00       	mov    $0x0,%edx
f0101065:	f7 75 d8             	divl   -0x28(%ebp)
f0101068:	89 d0                	mov    %edx,%eax
f010106a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010106d:	89 d1                	mov    %edx,%ecx
f010106f:	29 c1                	sub    %eax,%ecx
f0101071:	89 c8                	mov    %ecx,%eax
	uint32_t va = strtol(argv[1], 0, 0);
	uint32_t pa = strtol(argv[3], 0, 0);
	uint32_t perm = 0;
	uint32_t memsize = strtol(argv[2], 0, 0) * PGSIZE;
	
	if(va != ROUNDUP(va, PGSIZE)||
f0101073:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0101076:	75 0a                	jne    f0101082 <mon_setmappings+0x12f>
	   pa != ROUNDUP(pa, PGSIZE)||
	   va > ~0 - memsize
f0101078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010107b:	f7 d0                	not    %eax
	uint32_t pa = strtol(argv[3], 0, 0);
	uint32_t perm = 0;
	uint32_t memsize = strtol(argv[2], 0, 0) * PGSIZE;
	
	if(va != ROUNDUP(va, PGSIZE)||
	   pa != ROUNDUP(pa, PGSIZE)||
f010107d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f0101080:	73 16                	jae    f0101098 <mon_setmappings+0x145>
	   va > ~0 - memsize
	  ){
		  cprintf("argc error\n");
f0101082:	c7 04 24 db 7c 10 f0 	movl   $0xf0107cdb,(%esp)
f0101089:	e8 00 36 00 00       	call   f010468e <cprintf>
		  return 0;
f010108e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101093:	e9 de 00 00 00       	jmp    f0101176 <mon_setmappings+0x223>
	}
	uint32_t offset;
	struct Page *pp;
	for(offset = 0;offset < memsize; offset += PGSIZE){
f0101098:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f010109f:	eb 5a                	jmp    f01010fb <mon_setmappings+0x1a8>
		pp = pa2page(pa + offset);
f01010a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01010a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01010a7:	01 d0                	add    %edx,%eax
f01010a9:	89 04 24             	mov    %eax,(%esp)
f01010ac:	e8 2b fa ff ff       	call   f0100adc <pa2page>
f01010b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if(pp->pp_ref == 0){
f01010b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01010b7:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f01010bb:	66 85 c0             	test   %ax,%ax
f01010be:	75 34                	jne    f01010f4 <mon_setmappings+0x1a1>
			cprintf("unmounted physical page: %x - %x\n",pa + offset, pa + offset + PGSIZE);
f01010c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01010c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01010c6:	01 d0                	add    %edx,%eax
f01010c8:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
f01010ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01010d1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f01010d4:	01 c8                	add    %ecx,%eax
f01010d6:	89 54 24 08          	mov    %edx,0x8(%esp)
f01010da:	89 44 24 04          	mov    %eax,0x4(%esp)
f01010de:	c7 04 24 e8 7c 10 f0 	movl   $0xf0107ce8,(%esp)
f01010e5:	e8 a4 35 00 00       	call   f010468e <cprintf>
			return 0;
f01010ea:	b8 00 00 00 00       	mov    $0x0,%eax
f01010ef:	e9 82 00 00 00       	jmp    f0101176 <mon_setmappings+0x223>
		  cprintf("argc error\n");
		  return 0;
	}
	uint32_t offset;
	struct Page *pp;
	for(offset = 0;offset < memsize; offset += PGSIZE){
f01010f4:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
f01010fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01010fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f0101101:	72 9e                	jb     f01010a1 <mon_setmappings+0x14e>
		if(pp->pp_ref == 0){
			cprintf("unmounted physical page: %x - %x\n",pa + offset, pa + offset + PGSIZE);
			return 0;
		}
	}
	if(argv[4][0] == 'u'){
f0101103:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101106:	83 c0 10             	add    $0x10,%eax
f0101109:	8b 00                	mov    (%eax),%eax
f010110b:	0f b6 00             	movzbl (%eax),%eax
f010110e:	3c 75                	cmp    $0x75,%al
f0101110:	75 04                	jne    f0101116 <mon_setmappings+0x1c3>
		perm |= PTE_U;
f0101112:	83 4d f4 04          	orl    $0x4,-0xc(%ebp)
	}
	if(argv[4][1] == 'w'){
f0101116:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101119:	83 c0 10             	add    $0x10,%eax
f010111c:	8b 00                	mov    (%eax),%eax
f010111e:	83 c0 01             	add    $0x1,%eax
f0101121:	0f b6 00             	movzbl (%eax),%eax
f0101124:	3c 77                	cmp    $0x77,%al
f0101126:	75 04                	jne    f010112c <mon_setmappings+0x1d9>
		perm |= PTE_W;
f0101128:	83 4d f4 02          	orl    $0x2,-0xc(%ebp)
	}
	setmappings(va, memsize, pa, perm);
f010112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010112f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101133:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101136:	89 44 24 08          	mov    %eax,0x8(%esp)
f010113a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010113d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101141:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101144:	89 04 24             	mov    %eax,(%esp)
f0101147:	e8 ab fd ff ff       	call   f0100ef7 <setmappings>
	cprintf("set memory mapping ok\n");
f010114c:	c7 04 24 0a 7d 10 f0 	movl   $0xf0107d0a,(%esp)
f0101153:	e8 36 35 00 00       	call   f010468e <cprintf>
	showmappings(va, va + memsize);
f0101158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010115b:	8b 55 ec             	mov    -0x14(%ebp),%edx
f010115e:	01 d0                	add    %edx,%eax
f0101160:	89 c2                	mov    %eax,%edx
f0101162:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101165:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101169:	89 04 24             	mov    %eax,(%esp)
f010116c:	e8 8e fb ff ff       	call   f0100cff <showmappings>
	return 0;
f0101171:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101176:	c9                   	leave  
f0101177:	c3                   	ret    

f0101178 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0101178:	55                   	push   %ebp
f0101179:	89 e5                	mov    %esp,%ebp
f010117b:	83 ec 28             	sub    $0x28,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f010117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0101185:	eb 3f                	jmp    f01011c6 <mon_help+0x4e>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0101187:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010118a:	89 d0                	mov    %edx,%eax
f010118c:	01 c0                	add    %eax,%eax
f010118e:	01 d0                	add    %edx,%eax
f0101190:	c1 e0 02             	shl    $0x2,%eax
f0101193:	05 a0 f5 11 f0       	add    $0xf011f5a0,%eax
f0101198:	8b 48 04             	mov    0x4(%eax),%ecx
f010119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010119e:	89 d0                	mov    %edx,%eax
f01011a0:	01 c0                	add    %eax,%eax
f01011a2:	01 d0                	add    %edx,%eax
f01011a4:	c1 e0 02             	shl    $0x2,%eax
f01011a7:	05 a0 f5 11 f0       	add    $0xf011f5a0,%eax
f01011ac:	8b 00                	mov    (%eax),%eax
f01011ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01011b2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01011b6:	c7 04 24 21 7d 10 f0 	movl   $0xf0107d21,(%esp)
f01011bd:	e8 cc 34 00 00       	call   f010468e <cprintf>
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f01011c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f01011c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01011c9:	83 f8 07             	cmp    $0x7,%eax
f01011cc:	76 b9                	jbe    f0101187 <mon_help+0xf>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
f01011ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01011d3:	c9                   	leave  
f01011d4:	c3                   	ret    

f01011d5 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01011d5:	55                   	push   %ebp
f01011d6:	89 e5                	mov    %esp,%ebp
f01011d8:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01011db:	c7 04 24 2a 7d 10 f0 	movl   $0xf0107d2a,(%esp)
f01011e2:	e8 a7 34 00 00       	call   f010468e <cprintf>
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
f01011e7:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f01011ee:	00 
f01011ef:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f01011f6:	f0 
f01011f7:	c7 04 24 44 7d 10 f0 	movl   $0xf0107d44,(%esp)
f01011fe:	e8 8b 34 00 00       	call   f010468e <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0101203:	c7 44 24 08 65 77 10 	movl   $0x107765,0x8(%esp)
f010120a:	00 
f010120b:	c7 44 24 04 65 77 10 	movl   $0xf0107765,0x4(%esp)
f0101212:	f0 
f0101213:	c7 04 24 68 7d 10 f0 	movl   $0xf0107d68,(%esp)
f010121a:	e8 6f 34 00 00       	call   f010468e <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010121f:	c7 44 24 08 a8 85 1a 	movl   $0x1a85a8,0x8(%esp)
f0101226:	00 
f0101227:	c7 44 24 04 a8 85 1a 	movl   $0xf01a85a8,0x4(%esp)
f010122e:	f0 
f010122f:	c7 04 24 8c 7d 10 f0 	movl   $0xf0107d8c,(%esp)
f0101236:	e8 53 34 00 00       	call   f010468e <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010123b:	c7 44 24 08 d0 94 1a 	movl   $0x1a94d0,0x8(%esp)
f0101242:	00 
f0101243:	c7 44 24 04 d0 94 1a 	movl   $0xf01a94d0,0x4(%esp)
f010124a:	f0 
f010124b:	c7 04 24 b0 7d 10 f0 	movl   $0xf0107db0,(%esp)
f0101252:	e8 37 34 00 00       	call   f010468e <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		(end-_start+1023)/1024);
f0101257:	b8 d0 94 1a f0       	mov    $0xf01a94d0,%eax
f010125c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f0101262:	b8 0c 00 10 f0       	mov    $0xf010000c,%eax
f0101267:	89 d1                	mov    %edx,%ecx
f0101269:	29 c1                	sub    %eax,%ecx
f010126b:	89 c8                	mov    %ecx,%eax
	cprintf("Special kernel symbols:\n");
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f010126d:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f0101273:	85 c0                	test   %eax,%eax
f0101275:	0f 48 c2             	cmovs  %edx,%eax
f0101278:	c1 f8 0a             	sar    $0xa,%eax
f010127b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010127f:	c7 04 24 d4 7d 10 f0 	movl   $0xf0107dd4,(%esp)
f0101286:	e8 03 34 00 00       	call   f010468e <cprintf>
		(end-_start+1023)/1024);
	return 0;
f010128b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101290:	c9                   	leave  
f0101291:	c3                   	ret    

f0101292 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0101292:	55                   	push   %ebp
f0101293:	89 e5                	mov    %esp,%ebp
f0101295:	53                   	push   %ebx
f0101296:	83 ec 44             	sub    $0x44,%esp

static __inline uint32_t
read_ebp(void)
{
        uint32_t ebp;
        __asm __volatile("movl %%ebp,%0" : "=r" (ebp));
f0101299:	89 eb                	mov    %ebp,%ebx
f010129b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
        return ebp;
f010129e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	// Your code here.
	uint32_t ebp = read_ebp(), *p, eip, i;
f01012a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Eipdebuginfo bug;
    while (ebp > 0) {
f01012a4:	e9 d0 00 00 00       	jmp    f0101379 <mon_backtrace+0xe7>
        p = (uint32_t *)ebp;
f01012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01012ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
        eip = p[1];
f01012af:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01012b2:	8b 40 04             	mov    0x4(%eax),%eax
f01012b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("ebp %x ,eip %x args", ebp, eip);
f01012b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01012bb:	89 44 24 08          	mov    %eax,0x8(%esp)
f01012bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01012c2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01012c6:	c7 04 24 fe 7d 10 f0 	movl   $0xf0107dfe,(%esp)
f01012cd:	e8 bc 33 00 00       	call   f010468e <cprintf>
        for (i = 2; i < 6; i++) {
f01012d2:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%ebp)
f01012d9:	eb 1f                	jmp    f01012fa <mon_backtrace+0x68>
             cprintf(" %08x,  ", p[i]);
f01012db:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01012de:	c1 e0 02             	shl    $0x2,%eax
f01012e1:	03 45 ec             	add    -0x14(%ebp),%eax
f01012e4:	8b 00                	mov    (%eax),%eax
f01012e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01012ea:	c7 04 24 12 7e 10 f0 	movl   $0xf0107e12,(%esp)
f01012f1:	e8 98 33 00 00       	call   f010468e <cprintf>
    struct Eipdebuginfo bug;
    while (ebp > 0) {
        p = (uint32_t *)ebp;
        eip = p[1];
        cprintf("ebp %x ,eip %x args", ebp, eip);
        for (i = 2; i < 6; i++) {
f01012f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f01012fa:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
f01012fe:	76 db                	jbe    f01012db <mon_backtrace+0x49>
             cprintf(" %08x,  ", p[i]);
        }
        debuginfo_eip(eip, &bug);
f0101300:	8d 45 cc             	lea    -0x34(%ebp),%eax
f0101303:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101307:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010130a:	89 04 24             	mov    %eax,(%esp)
f010130d:	e8 28 50 00 00       	call   f010633a <debuginfo_eip>
        cprintf("\n\t%s : %d : ", bug.eip_file, bug.eip_line);
f0101312:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0101315:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101318:	89 54 24 08          	mov    %edx,0x8(%esp)
f010131c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101320:	c7 04 24 1b 7e 10 f0 	movl   $0xf0107e1b,(%esp)
f0101327:	e8 62 33 00 00       	call   f010468e <cprintf>
        for (i = 0; i < bug.eip_fn_namelen; i++)
f010132c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101333:	eb 18                	jmp    f010134d <mon_backtrace+0xbb>
            cputchar(bug.eip_fn_name[i]);//the same to the name 
f0101335:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101338:	03 45 f0             	add    -0x10(%ebp),%eax
f010133b:	0f b6 00             	movzbl (%eax),%eax
f010133e:	0f be c0             	movsbl %al,%eax
f0101341:	89 04 24             	mov    %eax,(%esp)
f0101344:	e8 5c f7 ff ff       	call   f0100aa5 <cputchar>
        for (i = 2; i < 6; i++) {
             cprintf(" %08x,  ", p[i]);
        }
        debuginfo_eip(eip, &bug);
        cprintf("\n\t%s : %d : ", bug.eip_file, bug.eip_line);
        for (i = 0; i < bug.eip_fn_namelen; i++)
f0101349:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f010134d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101350:	3b 45 f0             	cmp    -0x10(%ebp),%eax
f0101353:	77 e0                	ja     f0101335 <mon_backtrace+0xa3>
            cputchar(bug.eip_fn_name[i]);//the same to the name 
        //cprintf(" %s ",bug.eip_fn_name);
        cprintf("+%d\n", eip - bug.eip_fn_addr);
f0101355:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101358:	8b 55 e8             	mov    -0x18(%ebp),%edx
f010135b:	89 d1                	mov    %edx,%ecx
f010135d:	29 c1                	sub    %eax,%ecx
f010135f:	89 c8                	mov    %ecx,%eax
f0101361:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101365:	c7 04 24 28 7e 10 f0 	movl   $0xf0107e28,(%esp)
f010136c:	e8 1d 33 00 00       	call   f010468e <cprintf>
        ebp = *p;
f0101371:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101374:	8b 00                	mov    (%eax),%eax
f0101376:	89 45 f4             	mov    %eax,-0xc(%ebp)
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	uint32_t ebp = read_ebp(), *p, eip, i;
    struct Eipdebuginfo bug;
    while (ebp > 0) {
f0101379:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f010137d:	0f 85 26 ff ff ff    	jne    f01012a9 <mon_backtrace+0x17>
            cputchar(bug.eip_fn_name[i]);//the same to the name 
        //cprintf(" %s ",bug.eip_fn_name);
        cprintf("+%d\n", eip - bug.eip_fn_addr);
        ebp = *p;
    }
    return 0;
f0101383:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101388:	83 c4 44             	add    $0x44,%esp
f010138b:	5b                   	pop    %ebx
f010138c:	5d                   	pop    %ebp
f010138d:	c3                   	ret    

f010138e <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
f010138e:	55                   	push   %ebp
f010138f:	89 e5                	mov    %esp,%ebp
f0101391:	83 ec 68             	sub    $0x68,%esp
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0101394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	argv[argc] = 0;
f010139b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010139e:	c7 44 85 b0 00 00 00 	movl   $0x0,-0x50(%ebp,%eax,4)
f01013a5:	00 
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f01013a6:	eb 0d                	jmp    f01013b5 <runcmd+0x27>
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
f01013a8:	90                   	nop
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f01013a9:	eb 0a                	jmp    f01013b5 <runcmd+0x27>
			*buf++ = 0;
f01013ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01013ae:	c6 00 00             	movb   $0x0,(%eax)
f01013b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f01013b5:	8b 45 08             	mov    0x8(%ebp),%eax
f01013b8:	0f b6 00             	movzbl (%eax),%eax
f01013bb:	84 c0                	test   %al,%al
f01013bd:	74 1d                	je     f01013dc <runcmd+0x4e>
f01013bf:	8b 45 08             	mov    0x8(%ebp),%eax
f01013c2:	0f b6 00             	movzbl (%eax),%eax
f01013c5:	0f be c0             	movsbl %al,%eax
f01013c8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01013cc:	c7 04 24 2d 7e 10 f0 	movl   $0xf0107e2d,(%esp)
f01013d3:	e8 b9 5d 00 00       	call   f0107191 <strchr>
f01013d8:	85 c0                	test   %eax,%eax
f01013da:	75 cf                	jne    f01013ab <runcmd+0x1d>
			*buf++ = 0;
		if (*buf == 0)
f01013dc:	8b 45 08             	mov    0x8(%ebp),%eax
f01013df:	0f b6 00             	movzbl (%eax),%eax
f01013e2:	84 c0                	test   %al,%al
f01013e4:	74 64                	je     f010144a <runcmd+0xbc>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f01013e6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
f01013ea:	75 1e                	jne    f010140a <runcmd+0x7c>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f01013ec:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f01013f3:	00 
f01013f4:	c7 04 24 32 7e 10 f0 	movl   $0xf0107e32,(%esp)
f01013fb:	e8 8e 32 00 00       	call   f010468e <cprintf>
			return 0;
f0101400:	b8 00 00 00 00       	mov    $0x0,%eax
f0101405:	e9 d8 00 00 00       	jmp    f01014e2 <runcmd+0x154>
		}
		argv[argc++] = buf;
f010140a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010140d:	8b 55 08             	mov    0x8(%ebp),%edx
f0101410:	89 54 85 b0          	mov    %edx,-0x50(%ebp,%eax,4)
f0101414:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		while (*buf && !strchr(WHITESPACE, *buf))
f0101418:	eb 04                	jmp    f010141e <runcmd+0x90>
			buf++;
f010141a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f010141e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101421:	0f b6 00             	movzbl (%eax),%eax
f0101424:	84 c0                	test   %al,%al
f0101426:	74 80                	je     f01013a8 <runcmd+0x1a>
f0101428:	8b 45 08             	mov    0x8(%ebp),%eax
f010142b:	0f b6 00             	movzbl (%eax),%eax
f010142e:	0f be c0             	movsbl %al,%eax
f0101431:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101435:	c7 04 24 2d 7e 10 f0 	movl   $0xf0107e2d,(%esp)
f010143c:	e8 50 5d 00 00       	call   f0107191 <strchr>
f0101441:	85 c0                	test   %eax,%eax
f0101443:	74 d5                	je     f010141a <runcmd+0x8c>
			buf++;
	}
f0101445:	e9 5e ff ff ff       	jmp    f01013a8 <runcmd+0x1a>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;
f010144a:	90                   	nop
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
f010144b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010144e:	c7 44 85 b0 00 00 00 	movl   $0x0,-0x50(%ebp,%eax,4)
f0101455:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0101456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f010145a:	75 07                	jne    f0101463 <runcmd+0xd5>
		return 0;
f010145c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101461:	eb 7f                	jmp    f01014e2 <runcmd+0x154>
	for (i = 0; i < NCOMMANDS; i++) {
f0101463:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f010146a:	eb 56                	jmp    f01014c2 <runcmd+0x134>
		if (strcmp(argv[0], commands[i].name) == 0)
f010146c:	8b 55 f0             	mov    -0x10(%ebp),%edx
f010146f:	89 d0                	mov    %edx,%eax
f0101471:	01 c0                	add    %eax,%eax
f0101473:	01 d0                	add    %edx,%eax
f0101475:	c1 e0 02             	shl    $0x2,%eax
f0101478:	05 a0 f5 11 f0       	add    $0xf011f5a0,%eax
f010147d:	8b 10                	mov    (%eax),%edx
f010147f:	8b 45 b0             	mov    -0x50(%ebp),%eax
f0101482:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101486:	89 04 24             	mov    %eax,(%esp)
f0101489:	e8 6a 5c 00 00       	call   f01070f8 <strcmp>
f010148e:	85 c0                	test   %eax,%eax
f0101490:	75 2c                	jne    f01014be <runcmd+0x130>
			return commands[i].func(argc, argv, tf);
f0101492:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101495:	89 d0                	mov    %edx,%eax
f0101497:	01 c0                	add    %eax,%eax
f0101499:	01 d0                	add    %edx,%eax
f010149b:	c1 e0 02             	shl    $0x2,%eax
f010149e:	05 a0 f5 11 f0       	add    $0xf011f5a0,%eax
f01014a3:	8b 50 08             	mov    0x8(%eax),%edx
f01014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01014a9:	89 44 24 08          	mov    %eax,0x8(%esp)
f01014ad:	8d 45 b0             	lea    -0x50(%ebp),%eax
f01014b0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01014b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01014b7:	89 04 24             	mov    %eax,(%esp)
f01014ba:	ff d2                	call   *%edx
f01014bc:	eb 24                	jmp    f01014e2 <runcmd+0x154>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f01014be:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f01014c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01014c5:	83 f8 07             	cmp    $0x7,%eax
f01014c8:	76 a2                	jbe    f010146c <runcmd+0xde>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f01014ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
f01014cd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01014d1:	c7 04 24 4f 7e 10 f0 	movl   $0xf0107e4f,(%esp)
f01014d8:	e8 b1 31 00 00       	call   f010468e <cprintf>
	return 0;
f01014dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01014e2:	c9                   	leave  
f01014e3:	c3                   	ret    

f01014e4 <monitor>:

void
monitor(struct Trapframe *tf)
{
f01014e4:	55                   	push   %ebp
f01014e5:	89 e5                	mov    %esp,%ebp
f01014e7:	83 ec 28             	sub    $0x28,%esp
	char *buf;

	//cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("%CredWelcome %Cwhtto %Cgrnthe %CorgJOS %Cgrykernel %Cpurmonitor!\n");
f01014ea:	c7 04 24 68 7e 10 f0 	movl   $0xf0107e68,(%esp)
f01014f1:	e8 98 31 00 00       	call   f010468e <cprintf>
	//cprintf("%x %CredWelcome\n",BackColor);
	//cprintf("%x %Cwhtto\n",BackColor);
	//cprintf("%x %Cgrnthe\n",BackColor);
	//cprintf("%x %CorgJOS\n",BackColor);
	
	cprintf("%CwhtType 'help' for a list of commands.\n");
f01014f6:	c7 04 24 ac 7e 10 f0 	movl   $0xf0107eac,(%esp)
f01014fd:	e8 8c 31 00 00       	call   f010468e <cprintf>

	if (tf != NULL)
f0101502:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0101506:	74 0e                	je     f0101516 <monitor+0x32>
		print_trapframe(tf);
f0101508:	8b 45 08             	mov    0x8(%ebp),%eax
f010150b:	89 04 24             	mov    %eax,(%esp)
f010150e:	e8 c1 3c 00 00       	call   f01051d4 <print_trapframe>
f0101513:	eb 01                	jmp    f0101516 <monitor+0x32>
	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
f0101515:	90                   	nop

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
f0101516:	c7 04 24 d6 7e 10 f0 	movl   $0xf0107ed6,(%esp)
f010151d:	e8 be 59 00 00       	call   f0106ee0 <readline>
f0101522:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (buf != NULL)
f0101525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0101529:	74 ea                	je     f0101515 <monitor+0x31>
			if (runcmd(buf, tf) < 0)
f010152b:	8b 45 08             	mov    0x8(%ebp),%eax
f010152e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101532:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101535:	89 04 24             	mov    %eax,(%esp)
f0101538:	e8 51 fe ff ff       	call   f010138e <runcmd>
f010153d:	85 c0                	test   %eax,%eax
f010153f:	79 d4                	jns    f0101515 <monitor+0x31>
				break;
f0101541:	90                   	nop
	}
}
f0101542:	c9                   	leave  
f0101543:	c3                   	ret    

f0101544 <read_eip>:
// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
f0101544:	55                   	push   %ebp
f0101545:	89 e5                	mov    %esp,%ebp
f0101547:	53                   	push   %ebx
f0101548:	83 ec 10             	sub    $0x10,%esp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f010154b:	8b 5d 04             	mov    0x4(%ebp),%ebx
f010154e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
	return callerpc;
f0101551:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
f0101554:	83 c4 10             	add    $0x10,%esp
f0101557:	5b                   	pop    %ebx
f0101558:	5d                   	pop    %ebp
f0101559:	c3                   	ret    
	...

f010155c <page2ppn>:
int	user_mem_check(struct Env *env, const void *va, size_t len, int perm);
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline ppn_t
page2ppn(struct Page *pp)
{
f010155c:	55                   	push   %ebp
f010155d:	89 e5                	mov    %esp,%ebp
	return pp - pages;
f010155f:	8b 55 08             	mov    0x8(%ebp),%edx
f0101562:	a1 cc 94 1a f0       	mov    0xf01a94cc,%eax
f0101567:	89 d1                	mov    %edx,%ecx
f0101569:	29 c1                	sub    %eax,%ecx
f010156b:	89 c8                	mov    %ecx,%eax
f010156d:	c1 f8 02             	sar    $0x2,%eax
f0101570:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
f0101576:	5d                   	pop    %ebp
f0101577:	c3                   	ret    

f0101578 <page2pa>:

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101578:	55                   	push   %ebp
f0101579:	89 e5                	mov    %esp,%ebp
f010157b:	83 ec 04             	sub    $0x4,%esp
	return page2ppn(pp) << PGSHIFT;
f010157e:	8b 45 08             	mov    0x8(%ebp),%eax
f0101581:	89 04 24             	mov    %eax,(%esp)
f0101584:	e8 d3 ff ff ff       	call   f010155c <page2ppn>
f0101589:	c1 e0 0c             	shl    $0xc,%eax
}
f010158c:	c9                   	leave  
f010158d:	c3                   	ret    

f010158e <pa2page>:

static inline struct Page*
pa2page(physaddr_t pa)
{
f010158e:	55                   	push   %ebp
f010158f:	89 e5                	mov    %esp,%ebp
f0101591:	83 ec 18             	sub    $0x18,%esp
	if (PPN(pa) >= npage)
f0101594:	8b 45 08             	mov    0x8(%ebp),%eax
f0101597:	89 c2                	mov    %eax,%edx
f0101599:	c1 ea 0c             	shr    $0xc,%edx
f010159c:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f01015a1:	39 c2                	cmp    %eax,%edx
f01015a3:	72 1c                	jb     f01015c1 <pa2page+0x33>
		panic("pa2page called with invalid pa");
f01015a5:	c7 44 24 08 dc 7e 10 	movl   $0xf0107edc,0x8(%esp)
f01015ac:	f0 
f01015ad:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f01015b4:	00 
f01015b5:	c7 04 24 fb 7e 10 f0 	movl   $0xf0107efb,(%esp)
f01015bc:	e8 dd eb ff ff       	call   f010019e <_panic>
	return &pages[PPN(pa)];
f01015c1:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f01015c7:	8b 45 08             	mov    0x8(%ebp),%eax
f01015ca:	89 c2                	mov    %eax,%edx
f01015cc:	c1 ea 0c             	shr    $0xc,%edx
f01015cf:	89 d0                	mov    %edx,%eax
f01015d1:	01 c0                	add    %eax,%eax
f01015d3:	01 d0                	add    %edx,%eax
f01015d5:	c1 e0 02             	shl    $0x2,%eax
f01015d8:	01 c8                	add    %ecx,%eax
}
f01015da:	c9                   	leave  
f01015db:	c3                   	ret    

f01015dc <page2kva>:

static inline void*
page2kva(struct Page *pp)
{
f01015dc:	55                   	push   %ebp
f01015dd:	89 e5                	mov    %esp,%ebp
f01015df:	83 ec 28             	sub    $0x28,%esp
	return KADDR(page2pa(pp));
f01015e2:	8b 45 08             	mov    0x8(%ebp),%eax
f01015e5:	89 04 24             	mov    %eax,(%esp)
f01015e8:	e8 8b ff ff ff       	call   f0101578 <page2pa>
f01015ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01015f3:	c1 e8 0c             	shr    $0xc,%eax
f01015f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01015f9:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f01015fe:	39 45 f0             	cmp    %eax,-0x10(%ebp)
f0101601:	72 23                	jb     f0101626 <page2kva+0x4a>
f0101603:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101606:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010160a:	c7 44 24 08 0c 7f 10 	movl   $0xf0107f0c,0x8(%esp)
f0101611:	f0 
f0101612:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101619:	00 
f010161a:	c7 04 24 fb 7e 10 f0 	movl   $0xf0107efb,(%esp)
f0101621:	e8 78 eb ff ff       	call   f010019e <_panic>
f0101626:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101629:	2d 00 00 00 10       	sub    $0x10000000,%eax
}
f010162e:	c9                   	leave  
f010162f:	c3                   	ret    

f0101630 <nvram_read>:
	sizeof(gdt) - 1, (unsigned long) gdt
};

static int
nvram_read(int r)
{
f0101630:	55                   	push   %ebp
f0101631:	89 e5                	mov    %esp,%ebp
f0101633:	53                   	push   %ebx
f0101634:	83 ec 14             	sub    $0x14,%esp
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0101637:	8b 45 08             	mov    0x8(%ebp),%eax
f010163a:	89 04 24             	mov    %eax,(%esp)
f010163d:	e8 1a 2d 00 00       	call   f010435c <mc146818_read>
f0101642:	89 c3                	mov    %eax,%ebx
f0101644:	8b 45 08             	mov    0x8(%ebp),%eax
f0101647:	83 c0 01             	add    $0x1,%eax
f010164a:	89 04 24             	mov    %eax,(%esp)
f010164d:	e8 0a 2d 00 00       	call   f010435c <mc146818_read>
f0101652:	c1 e0 08             	shl    $0x8,%eax
f0101655:	09 d8                	or     %ebx,%eax
}
f0101657:	83 c4 14             	add    $0x14,%esp
f010165a:	5b                   	pop    %ebx
f010165b:	5d                   	pop    %ebp
f010165c:	c3                   	ret    

f010165d <i386_detect_memory>:

void
i386_detect_memory(void)
{
f010165d:	55                   	push   %ebp
f010165e:	89 e5                	mov    %esp,%ebp
f0101660:	83 ec 28             	sub    $0x28,%esp
	// CMOS tells us how many kilobytes there are
	basemem = ROUNDDOWN(nvram_read(NVRAM_BASELO)*1024, PGSIZE);
f0101663:	c7 04 24 15 00 00 00 	movl   $0x15,(%esp)
f010166a:	e8 c1 ff ff ff       	call   f0101630 <nvram_read>
f010166f:	c1 e0 0a             	shl    $0xa,%eax
f0101672:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101675:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101678:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010167d:	a3 10 88 1a f0       	mov    %eax,0xf01a8810
	extmem = ROUNDDOWN(nvram_read(NVRAM_EXTLO)*1024, PGSIZE);
f0101682:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
f0101689:	e8 a2 ff ff ff       	call   f0101630 <nvram_read>
f010168e:	c1 e0 0a             	shl    $0xa,%eax
f0101691:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101694:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101697:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010169c:	a3 14 88 1a f0       	mov    %eax,0xf01a8814

	// Calculate the maximum physical address based on whether
	// or not there is any extended memory.  See comment in <inc/mmu.h>.
	if (extmem)
f01016a1:	a1 14 88 1a f0       	mov    0xf01a8814,%eax
f01016a6:	85 c0                	test   %eax,%eax
f01016a8:	74 11                	je     f01016bb <i386_detect_memory+0x5e>
		maxpa = EXTPHYSMEM + extmem;
f01016aa:	a1 14 88 1a f0       	mov    0xf01a8814,%eax
f01016af:	05 00 00 10 00       	add    $0x100000,%eax
f01016b4:	a3 0c 88 1a f0       	mov    %eax,0xf01a880c
f01016b9:	eb 0a                	jmp    f01016c5 <i386_detect_memory+0x68>
	else
		maxpa = basemem;
f01016bb:	a1 10 88 1a f0       	mov    0xf01a8810,%eax
f01016c0:	a3 0c 88 1a f0       	mov    %eax,0xf01a880c

	npage = maxpa / PGSIZE;
f01016c5:	a1 0c 88 1a f0       	mov    0xf01a880c,%eax
f01016ca:	c1 e8 0c             	shr    $0xc,%eax
f01016cd:	a3 c0 94 1a f0       	mov    %eax,0xf01a94c0

	cprintf("Physical memory: %dK available, ", (int)(maxpa/1024));
f01016d2:	a1 0c 88 1a f0       	mov    0xf01a880c,%eax
f01016d7:	c1 e8 0a             	shr    $0xa,%eax
f01016da:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016de:	c7 04 24 30 7f 10 f0 	movl   $0xf0107f30,(%esp)
f01016e5:	e8 a4 2f 00 00       	call   f010468e <cprintf>
	cprintf("base = %dK, extended = %dK\n", (int)(basemem/1024), (int)(extmem/1024));
f01016ea:	a1 14 88 1a f0       	mov    0xf01a8814,%eax
f01016ef:	c1 e8 0a             	shr    $0xa,%eax
f01016f2:	89 c2                	mov    %eax,%edx
f01016f4:	a1 10 88 1a f0       	mov    0xf01a8810,%eax
f01016f9:	c1 e8 0a             	shr    $0xa,%eax
f01016fc:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101700:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101704:	c7 04 24 51 7f 10 f0 	movl   $0xf0107f51,(%esp)
f010170b:	e8 7e 2f 00 00       	call   f010468e <cprintf>
}
f0101710:	c9                   	leave  
f0101711:	c3                   	ret    

f0101712 <boot_alloc>:
// This function may ONLY be used during initialization,
// before the page_free_list has been set up.
// 
static void*
boot_alloc(uint32_t n, uint32_t align)
{
f0101712:	55                   	push   %ebp
f0101713:	89 e5                	mov    %esp,%ebp
f0101715:	53                   	push   %ebx
f0101716:	83 ec 20             	sub    $0x20,%esp
	extern char end[];
	void *v = NULL;
f0101719:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	// Initialize boot_freemem if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment -
	// i.e., the first virtual address that the linker
	// did _not_ assign to any kernel code or global variables.
	if (boot_freemem == 0)
f0101720:	a1 18 88 1a f0       	mov    0xf01a8818,%eax
f0101725:	85 c0                	test   %eax,%eax
f0101727:	75 0a                	jne    f0101733 <boot_alloc+0x21>
		boot_freemem = end;
f0101729:	c7 05 18 88 1a f0 d0 	movl   $0xf01a94d0,0xf01a8818
f0101730:	94 1a f0 
	// LAB 2: Your code here:
	//	Step 1: round boot_freemem up to be aligned properly
	//	Step 2: save current value of boot_freemem as allocated chunk
	//	Step 3: increase boot_freemem to record allocation
	//	Step 4: return allocated chunk
    boot_freemem = ROUNDUP(boot_freemem,align);//4KB
f0101733:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101736:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101739:	a1 18 88 1a f0       	mov    0xf01a8818,%eax
f010173e:	03 45 f4             	add    -0xc(%ebp),%eax
f0101741:	83 e8 01             	sub    $0x1,%eax
f0101744:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101747:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010174a:	ba 00 00 00 00       	mov    $0x0,%edx
f010174f:	f7 75 f4             	divl   -0xc(%ebp)
f0101752:	89 d0                	mov    %edx,%eax
f0101754:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0101757:	89 d1                	mov    %edx,%ecx
f0101759:	29 c1                	sub    %eax,%ecx
f010175b:	89 c8                	mov    %ecx,%eax
f010175d:	a3 18 88 1a f0       	mov    %eax,0xf01a8818
	v = boot_freemem;
f0101762:	a1 18 88 1a f0       	mov    0xf01a8818,%eax
f0101767:	89 45 f8             	mov    %eax,-0x8(%ebp)
	boot_freemem += ROUNDUP(n,align);
f010176a:	8b 0d 18 88 1a f0    	mov    0xf01a8818,%ecx
f0101770:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101773:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101776:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101779:	8b 55 08             	mov    0x8(%ebp),%edx
f010177c:	01 d0                	add    %edx,%eax
f010177e:	83 e8 01             	sub    $0x1,%eax
f0101781:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0101784:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101787:	ba 00 00 00 00       	mov    $0x0,%edx
f010178c:	f7 75 ec             	divl   -0x14(%ebp)
f010178f:	89 d0                	mov    %edx,%eax
f0101791:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0101794:	89 d3                	mov    %edx,%ebx
f0101796:	29 c3                	sub    %eax,%ebx
f0101798:	89 d8                	mov    %ebx,%eax
f010179a:	01 c8                	add    %ecx,%eax
f010179c:	a3 18 88 1a f0       	mov    %eax,0xf01a8818
	return v;
f01017a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
f01017a4:	83 c4 20             	add    $0x20,%esp
f01017a7:	5b                   	pop    %ebx
f01017a8:	5d                   	pop    %ebp
f01017a9:	c3                   	ret    

f01017aa <i386_vm_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read (or write). 
void
i386_vm_init(void)
{
f01017aa:	55                   	push   %ebp
f01017ab:	89 e5                	mov    %esp,%ebp
f01017ad:	53                   	push   %ebx
f01017ae:	83 ec 74             	sub    $0x74,%esp
	// Delete this line:
	//panic("i386_vm_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	pgdir = boot_alloc(PGSIZE, PGSIZE);
f01017b1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01017b8:	00 
f01017b9:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
f01017c0:	e8 4d ff ff ff       	call   f0101712 <boot_alloc>
f01017c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	memset(pgdir, 0, PGSIZE);
f01017c8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01017cf:	00 
f01017d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01017d7:	00 
f01017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01017db:	89 04 24             	mov    %eax,(%esp)
f01017de:	e8 10 5a 00 00       	call   f01071f3 <memset>
	boot_pgdir = pgdir;
f01017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01017e6:	a3 c8 94 1a f0       	mov    %eax,0xf01a94c8
	boot_cr3 = PADDR(pgdir);
f01017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01017ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01017f1:	81 7d f0 ff ff ff ef 	cmpl   $0xefffffff,-0x10(%ebp)
f01017f8:	77 23                	ja     f010181d <i386_vm_init+0x73>
f01017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01017fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101801:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f0101808:	f0 
f0101809:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
f0101810:	00 
f0101811:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101818:	e8 81 e9 ff ff       	call   f010019e <_panic>
f010181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101820:	05 00 00 00 10       	add    $0x10000000,%eax
f0101825:	a3 c4 94 1a f0       	mov    %eax,0xf01a94c4
	// a virtual page table at virtual address VPT.
	// (For now, you don't have understand the greater purpose of the
	// following two lines.)

	// Permissions: kernel RW, user NONE
	pgdir[PDX(VPT)] = PADDR(pgdir)|PTE_W|PTE_P;//set 
f010182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010182d:	8d 90 fc 0e 00 00    	lea    0xefc(%eax),%edx
f0101833:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101836:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101839:	81 7d ec ff ff ff ef 	cmpl   $0xefffffff,-0x14(%ebp)
f0101840:	77 23                	ja     f0101865 <i386_vm_init+0xbb>
f0101842:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101845:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101849:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f0101850:	f0 
f0101851:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
f0101858:	00 
f0101859:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101860:	e8 39 e9 ff ff       	call   f010019e <_panic>
f0101865:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101868:	05 00 00 00 10       	add    $0x10000000,%eax
f010186d:	83 c8 03             	or     $0x3,%eax
f0101870:	89 02                	mov    %eax,(%edx)

	// same for UVPT
	// Permissions: kernel R, user R 
	pgdir[PDX(UVPT)] = PADDR(pgdir)|PTE_U|PTE_P;
f0101872:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101875:	8d 90 f4 0e 00 00    	lea    0xef4(%eax),%edx
f010187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010187e:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0101881:	81 7d e8 ff ff ff ef 	cmpl   $0xefffffff,-0x18(%ebp)
f0101888:	77 23                	ja     f01018ad <i386_vm_init+0x103>
f010188a:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010188d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101891:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f0101898:	f0 
f0101899:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
f01018a0:	00 
f01018a1:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01018a8:	e8 f1 e8 ff ff       	call   f010019e <_panic>
f01018ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01018b0:	05 00 00 00 10       	add    $0x10000000,%eax
f01018b5:	83 c8 05             	or     $0x5,%eax
f01018b8:	89 02                	mov    %eax,(%edx)
	// The kernel uses this structure to keep track of physical pages;
	// 'npage' equals the number of physical pages in memory.  User-level
	// programs will get read-only access to the array as well.
	// You must allocate the array yourself.
	// Your code goes here: 
    pages = boot_alloc(npage * sizeof(struct Page),PGSIZE);
f01018ba:	8b 15 c0 94 1a f0    	mov    0xf01a94c0,%edx
f01018c0:	89 d0                	mov    %edx,%eax
f01018c2:	01 c0                	add    %eax,%eax
f01018c4:	01 d0                	add    %edx,%eax
f01018c6:	c1 e0 02             	shl    $0x2,%eax
f01018c9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01018d0:	00 
f01018d1:	89 04 24             	mov    %eax,(%esp)
f01018d4:	e8 39 fe ff ff       	call   f0101712 <boot_alloc>
f01018d9:	a3 cc 94 1a f0       	mov    %eax,0xf01a94cc


	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
    envs = boot_alloc(NENV * sizeof(struct Env), PGSIZE);
f01018de:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01018e5:	00 
f01018e6:	c7 04 24 00 00 02 00 	movl   $0x20000,(%esp)
f01018ed:	e8 20 fe ff ff       	call   f0101712 <boot_alloc>
f01018f2:	a3 24 88 1a f0       	mov    %eax,0xf01a8824
	//////////////////////////////////////////////////////////////////////
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_segment or page_insert
	cprintf("++++++++++memory page check++++++++++++\n");
f01018f7:	c7 04 24 a0 7f 10 f0 	movl   $0xf0107fa0,(%esp)
f01018fe:	e8 8b 2d 00 00       	call   f010468e <cprintf>
	page_init();
f0101903:	e8 f7 0a 00 00       	call   f01023ff <page_init>

    check_page_alloc();
f0101908:	e8 5a 02 00 00       	call   f0101b67 <check_page_alloc>

	page_check();
f010190d:	e8 db 13 00 00       	call   f0102ced <page_check>
    cprintf("++++++++memory page check end++++++++++\n");
f0101912:	c7 04 24 cc 7f 10 f0 	movl   $0xf0107fcc,(%esp)
f0101919:	e8 70 2d 00 00       	call   f010468e <cprintf>
	// Permissions:
	//    - pages -- kernel RW, user NONE
	//    - the read-only version mapped at UPAGES -- kernel R, user R
	// Your code goes here:
    
    n = ROUNDUP(npage * sizeof(struct Page), PGSIZE);
f010191e:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
f0101925:	8b 15 c0 94 1a f0    	mov    0xf01a94c0,%edx
f010192b:	89 d0                	mov    %edx,%eax
f010192d:	01 c0                	add    %eax,%eax
f010192f:	01 d0                	add    %edx,%eax
f0101931:	c1 e0 02             	shl    $0x2,%eax
f0101934:	03 45 e4             	add    -0x1c(%ebp),%eax
f0101937:	83 e8 01             	sub    $0x1,%eax
f010193a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010193d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101940:	ba 00 00 00 00       	mov    $0x0,%edx
f0101945:	f7 75 e4             	divl   -0x1c(%ebp)
f0101948:	89 d0                	mov    %edx,%eax
f010194a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010194d:	89 d1                	mov    %edx,%ecx
f010194f:	29 c1                	sub    %eax,%ecx
f0101951:	89 c8                	mov    %ecx,%eax
f0101953:	89 45 dc             	mov    %eax,-0x24(%ebp)
 	boot_map_segment(pgdir, UPAGES, n, PADDR(pages), PTE_U|PTE_P);//PTE_P
f0101956:	a1 cc 94 1a f0       	mov    0xf01a94cc,%eax
f010195b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010195e:	81 7d d8 ff ff ff ef 	cmpl   $0xefffffff,-0x28(%ebp)
f0101965:	77 23                	ja     f010198a <i386_vm_init+0x1e0>
f0101967:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010196a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010196e:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f0101975:	f0 
f0101976:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
f010197d:	00 
f010197e:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101985:	e8 14 e8 ff ff       	call   f010019e <_panic>
f010198a:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010198d:	05 00 00 00 10       	add    $0x10000000,%eax
f0101992:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
f0101999:	00 
f010199a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010199e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01019a1:	89 44 24 08          	mov    %eax,0x8(%esp)
f01019a5:	c7 44 24 04 00 00 00 	movl   $0xef000000,0x4(%esp)
f01019ac:	ef 
f01019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01019b0:	89 04 24             	mov    %eax,(%esp)
f01019b3:	e8 9c 10 00 00       	call   f0102a54 <boot_map_segment>
	// Map the 'envs' array read-only by the user at linear address UENVS
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - envs itself -- kernel RW, user NONE
	//    - the image of envs mapped at UENVS  -- kernel R, user R
    boot_map_segment(pgdir, UENVS, ROUNDUP(NENV * sizeof(struct Env), PGSIZE), PADDR((uintptr_t)envs), PTE_P|PTE_U);
f01019b8:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f01019bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01019c0:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f01019c7:	77 23                	ja     f01019ec <i386_vm_init+0x242>
f01019c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01019d0:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f01019d7:	f0 
f01019d8:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
f01019df:	00 
f01019e0:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01019e7:	e8 b2 e7 ff ff       	call   f010019e <_panic>
f01019ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019ef:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx
f01019f5:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
f01019fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01019ff:	05 ff ff 01 00       	add    $0x1ffff,%eax
f0101a04:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101a07:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0101a0a:	ba 00 00 00 00       	mov    $0x0,%edx
f0101a0f:	f7 75 d0             	divl   -0x30(%ebp)
f0101a12:	89 d0                	mov    %edx,%eax
f0101a14:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0101a17:	89 d3                	mov    %edx,%ebx
f0101a19:	29 c3                	sub    %eax,%ebx
f0101a1b:	89 d8                	mov    %ebx,%eax
f0101a1d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
f0101a24:	00 
f0101a25:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0101a29:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101a2d:	c7 44 24 04 00 00 c0 	movl   $0xeec00000,0x4(%esp)
f0101a34:	ee 
f0101a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101a38:	89 04 24             	mov    %eax,(%esp)
f0101a3b:	e8 14 10 00 00       	call   f0102a54 <boot_map_segment>
	// pieces:
	//     * [KSTACKTOP-KSTKSIZE, KSTACKTOP) -- backed by physical memory
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed => faults
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
    boot_map_segment(pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W|PTE_P);//PTE_P
f0101a40:	c7 45 c8 00 70 11 f0 	movl   $0xf0117000,-0x38(%ebp)
f0101a47:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f0101a4e:	77 23                	ja     f0101a73 <i386_vm_init+0x2c9>
f0101a50:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0101a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101a57:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f0101a5e:	f0 
f0101a5f:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
f0101a66:	00 
f0101a67:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101a6e:	e8 2b e7 ff ff       	call   f010019e <_panic>
f0101a73:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0101a76:	05 00 00 00 10       	add    $0x10000000,%eax
f0101a7b:	c7 44 24 10 03 00 00 	movl   $0x3,0x10(%esp)
f0101a82:	00 
f0101a83:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101a87:	c7 44 24 08 00 80 00 	movl   $0x8000,0x8(%esp)
f0101a8e:	00 
f0101a8f:	c7 44 24 04 00 80 bf 	movl   $0xefbf8000,0x4(%esp)
f0101a96:	ef 
f0101a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101a9a:	89 04 24             	mov    %eax,(%esp)
f0101a9d:	e8 b2 0f 00 00       	call   f0102a54 <boot_map_segment>
	//      the PA range [0, 2^32 - KERNBASE)
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the amapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here: 
    boot_map_segment(pgdir, KERNBASE, 0xFFFFFFFF - KERNBASE+1, 0, PTE_W|PTE_P);//PTE_P
f0101aa2:	c7 44 24 10 03 00 00 	movl   $0x3,0x10(%esp)
f0101aa9:	00 
f0101aaa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0101ab1:	00 
f0101ab2:	c7 44 24 08 00 00 00 	movl   $0x10000000,0x8(%esp)
f0101ab9:	10 
f0101aba:	c7 44 24 04 00 00 00 	movl   $0xf0000000,0x4(%esp)
f0101ac1:	f0 
f0101ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101ac5:	89 04 24             	mov    %eax,(%esp)
f0101ac8:	e8 87 0f 00 00       	call   f0102a54 <boot_map_segment>
	
	// Check that the initial page directory has been set up correctly.
	check_boot_pgdir();
f0101acd:	e8 f3 04 00 00       	call   f0101fc5 <check_boot_pgdir>
	// mapping, even though we are turning on paging and reconfiguring
	// segmentation.

	// Map VA 0:4MB same as VA KERNBASE, i.e. to PA 0:4MB.
	// (Limits our kernel to <4MB)
	pgdir[0] = pgdir[PDX(KERNBASE)];
f0101ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101ad5:	8b 90 00 0f 00 00    	mov    0xf00(%eax),%edx
f0101adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101ade:	89 10                	mov    %edx,(%eax)

	// Install page table.
	lcr3(boot_cr3);
f0101ae0:	a1 c4 94 1a f0       	mov    0xf01a94c4,%eax
f0101ae5:	89 45 c0             	mov    %eax,-0x40(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0101ae8:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0101aeb:	0f 22 d8             	mov    %eax,%cr3

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0101aee:	0f 20 c3             	mov    %cr0,%ebx
f0101af1:	89 5d bc             	mov    %ebx,-0x44(%ebp)
	return val;
f0101af4:	8b 45 bc             	mov    -0x44(%ebp),%eax

	// Turn on paging.
	cr0 = rcr0();
f0101af7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_TS|CR0_EM|CR0_MP;
f0101afa:	81 4d c4 2f 00 05 80 	orl    $0x8005002f,-0x3c(%ebp)
	cr0 &= ~(CR0_TS|CR0_EM);
f0101b01:	83 65 c4 f3          	andl   $0xfffffff3,-0x3c(%ebp)
f0101b05:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0101b08:	89 45 b8             	mov    %eax,-0x48(%ebp)
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0101b0b:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0101b0e:	0f 22 c0             	mov    %eax,%cr0

	// Current mapping: KERNBASE+x => x => x.
	// (x < 4MB so uses paging pgdir[0])

	// Reload all segment registers.
	asm volatile("lgdt gdt_pd");
f0101b11:	0f 01 15 30 f6 11 f0 	lgdtl  0xf011f630
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f0101b18:	b8 23 00 00 00       	mov    $0x23,%eax
f0101b1d:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0101b1f:	b8 23 00 00 00       	mov    $0x23,%eax
f0101b24:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0101b26:	b8 10 00 00 00       	mov    $0x10,%eax
f0101b2b:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0101b2d:	b8 10 00 00 00       	mov    $0x10,%eax
f0101b32:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0101b34:	b8 10 00 00 00       	mov    $0x10,%eax
f0101b39:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));  // reload cs
f0101b3b:	ea 42 1b 10 f0 08 00 	ljmp   $0x8,$0xf0101b42
	asm volatile("lldt %%ax" :: "a" (0));
f0101b42:	b8 00 00 00 00       	mov    $0x0,%eax
f0101b47:	0f 00 d0             	lldt   %ax

	// Final mapping: KERNBASE+x => KERNBASE+x => x.

	// This mapping was only used after paging was turned on but
	// before the segment registers were reloaded.
	pgdir[0] = 0;
f0101b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// Flush the TLB for good measure, to kill the pgdir[0] mapping.
	lcr3(boot_cr3);
f0101b53:	a1 c4 94 1a f0       	mov    0xf01a94c4,%eax
f0101b58:	89 45 b4             	mov    %eax,-0x4c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0101b5b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
f0101b5e:	0f 22 d8             	mov    %eax,%cr3
}
f0101b61:	83 c4 74             	add    $0x74,%esp
f0101b64:	5b                   	pop    %ebx
f0101b65:	5d                   	pop    %ebp
f0101b66:	c3                   	ret    

f0101b67 <check_page_alloc>:
// Check the physical page allocator (page_alloc(), page_free(),
// and page_init()).
//
static void
check_page_alloc()
{
f0101b67:	55                   	push   %ebp
f0101b68:	89 e5                	mov    %esp,%ebp
f0101b6a:	83 ec 38             	sub    $0x38,%esp
	struct Page_list fl;
	
        // if there's a page that shouldn't be on
        // the free list, try to make sure it
        // eventually causes trouble.
	LIST_FOREACH(pp0, &page_free_list, pp_link)
f0101b6d:	a1 1c 88 1a f0       	mov    0xf01a881c,%eax
f0101b72:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101b75:	eb 2b                	jmp    f0101ba2 <check_page_alloc+0x3b>
		memset(page2kva(pp0), 0x97, 128);
f0101b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101b7a:	89 04 24             	mov    %eax,(%esp)
f0101b7d:	e8 5a fa ff ff       	call   f01015dc <page2kva>
f0101b82:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f0101b89:	00 
f0101b8a:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0101b91:	00 
f0101b92:	89 04 24             	mov    %eax,(%esp)
f0101b95:	e8 59 56 00 00       	call   f01071f3 <memset>
	struct Page_list fl;
	
        // if there's a page that shouldn't be on
        // the free list, try to make sure it
        // eventually causes trouble.
	LIST_FOREACH(pp0, &page_free_list, pp_link)
f0101b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101b9d:	8b 00                	mov    (%eax),%eax
f0101b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101ba5:	85 c0                	test   %eax,%eax
f0101ba7:	75 ce                	jne    f0101b77 <check_page_alloc+0x10>
		memset(page2kva(pp0), 0x97, 128);

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0101ba9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
f0101bb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert(page_alloc(&pp0) == 0);
f0101bbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0101bbf:	89 04 24             	mov    %eax,(%esp)
f0101bc2:	e8 ba 0b 00 00       	call   f0102781 <page_alloc>
f0101bc7:	85 c0                	test   %eax,%eax
f0101bc9:	74 24                	je     f0101bef <check_page_alloc+0x88>
f0101bcb:	c7 44 24 0c f5 7f 10 	movl   $0xf0107ff5,0xc(%esp)
f0101bd2:	f0 
f0101bd3:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101bda:	f0 
f0101bdb:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
f0101be2:	00 
f0101be3:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101bea:	e8 af e5 ff ff       	call   f010019e <_panic>
	assert(page_alloc(&pp1) == 0);
f0101bef:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0101bf2:	89 04 24             	mov    %eax,(%esp)
f0101bf5:	e8 87 0b 00 00       	call   f0102781 <page_alloc>
f0101bfa:	85 c0                	test   %eax,%eax
f0101bfc:	74 24                	je     f0101c22 <check_page_alloc+0xbb>
f0101bfe:	c7 44 24 0c 20 80 10 	movl   $0xf0108020,0xc(%esp)
f0101c05:	f0 
f0101c06:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101c0d:	f0 
f0101c0e:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
f0101c15:	00 
f0101c16:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101c1d:	e8 7c e5 ff ff       	call   f010019e <_panic>
	assert(page_alloc(&pp2) == 0);
f0101c22:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0101c25:	89 04 24             	mov    %eax,(%esp)
f0101c28:	e8 54 0b 00 00       	call   f0102781 <page_alloc>
f0101c2d:	85 c0                	test   %eax,%eax
f0101c2f:	74 24                	je     f0101c55 <check_page_alloc+0xee>
f0101c31:	c7 44 24 0c 36 80 10 	movl   $0xf0108036,0xc(%esp)
f0101c38:	f0 
f0101c39:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101c40:	f0 
f0101c41:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
f0101c48:	00 
f0101c49:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101c50:	e8 49 e5 ff ff       	call   f010019e <_panic>

	assert(pp0);
f0101c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101c58:	85 c0                	test   %eax,%eax
f0101c5a:	75 24                	jne    f0101c80 <check_page_alloc+0x119>
f0101c5c:	c7 44 24 0c 4c 80 10 	movl   $0xf010804c,0xc(%esp)
f0101c63:	f0 
f0101c64:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101c6b:	f0 
f0101c6c:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
f0101c73:	00 
f0101c74:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101c7b:	e8 1e e5 ff ff       	call   f010019e <_panic>
	assert(pp1 && pp1 != pp0);
f0101c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101c83:	85 c0                	test   %eax,%eax
f0101c85:	74 0a                	je     f0101c91 <check_page_alloc+0x12a>
f0101c87:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0101c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101c8d:	39 c2                	cmp    %eax,%edx
f0101c8f:	75 24                	jne    f0101cb5 <check_page_alloc+0x14e>
f0101c91:	c7 44 24 0c 50 80 10 	movl   $0xf0108050,0xc(%esp)
f0101c98:	f0 
f0101c99:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101ca0:	f0 
f0101ca1:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
f0101ca8:	00 
f0101ca9:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101cb0:	e8 e9 e4 ff ff       	call   f010019e <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101cb8:	85 c0                	test   %eax,%eax
f0101cba:	74 14                	je     f0101cd0 <check_page_alloc+0x169>
f0101cbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0101cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101cc2:	39 c2                	cmp    %eax,%edx
f0101cc4:	74 0a                	je     f0101cd0 <check_page_alloc+0x169>
f0101cc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0101cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101ccc:	39 c2                	cmp    %eax,%edx
f0101cce:	75 24                	jne    f0101cf4 <check_page_alloc+0x18d>
f0101cd0:	c7 44 24 0c 64 80 10 	movl   $0xf0108064,0xc(%esp)
f0101cd7:	f0 
f0101cd8:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101cdf:	f0 
f0101ce0:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
f0101ce7:	00 
f0101ce8:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101cef:	e8 aa e4 ff ff       	call   f010019e <_panic>
        assert(page2pa(pp0) < npage*PGSIZE);
f0101cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101cf7:	89 04 24             	mov    %eax,(%esp)
f0101cfa:	e8 79 f8 ff ff       	call   f0101578 <page2pa>
f0101cff:	8b 15 c0 94 1a f0    	mov    0xf01a94c0,%edx
f0101d05:	c1 e2 0c             	shl    $0xc,%edx
f0101d08:	39 d0                	cmp    %edx,%eax
f0101d0a:	72 24                	jb     f0101d30 <check_page_alloc+0x1c9>
f0101d0c:	c7 44 24 0c 84 80 10 	movl   $0xf0108084,0xc(%esp)
f0101d13:	f0 
f0101d14:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101d1b:	f0 
f0101d1c:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
f0101d23:	00 
f0101d24:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101d2b:	e8 6e e4 ff ff       	call   f010019e <_panic>
        assert(page2pa(pp1) < npage*PGSIZE);
f0101d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101d33:	89 04 24             	mov    %eax,(%esp)
f0101d36:	e8 3d f8 ff ff       	call   f0101578 <page2pa>
f0101d3b:	8b 15 c0 94 1a f0    	mov    0xf01a94c0,%edx
f0101d41:	c1 e2 0c             	shl    $0xc,%edx
f0101d44:	39 d0                	cmp    %edx,%eax
f0101d46:	72 24                	jb     f0101d6c <check_page_alloc+0x205>
f0101d48:	c7 44 24 0c a0 80 10 	movl   $0xf01080a0,0xc(%esp)
f0101d4f:	f0 
f0101d50:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101d57:	f0 
f0101d58:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
f0101d5f:	00 
f0101d60:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101d67:	e8 32 e4 ff ff       	call   f010019e <_panic>
        assert(page2pa(pp2) < npage*PGSIZE);
f0101d6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101d6f:	89 04 24             	mov    %eax,(%esp)
f0101d72:	e8 01 f8 ff ff       	call   f0101578 <page2pa>
f0101d77:	8b 15 c0 94 1a f0    	mov    0xf01a94c0,%edx
f0101d7d:	c1 e2 0c             	shl    $0xc,%edx
f0101d80:	39 d0                	cmp    %edx,%eax
f0101d82:	72 24                	jb     f0101da8 <check_page_alloc+0x241>
f0101d84:	c7 44 24 0c bc 80 10 	movl   $0xf01080bc,0xc(%esp)
f0101d8b:	f0 
f0101d8c:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101d93:	f0 
f0101d94:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
f0101d9b:	00 
f0101d9c:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101da3:	e8 f6 e3 ff ff       	call   f010019e <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101da8:	a1 1c 88 1a f0       	mov    0xf01a881c,%eax
f0101dad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INIT(&page_free_list);
f0101db0:	c7 05 1c 88 1a f0 00 	movl   $0x0,0xf01a881c
f0101db7:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101dba:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101dbd:	89 04 24             	mov    %eax,(%esp)
f0101dc0:	e8 bc 09 00 00       	call   f0102781 <page_alloc>
f0101dc5:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101dc8:	74 24                	je     f0101dee <check_page_alloc+0x287>
f0101dca:	c7 44 24 0c d8 80 10 	movl   $0xf01080d8,0xc(%esp)
f0101dd1:	f0 
f0101dd2:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101dd9:	f0 
f0101dda:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
f0101de1:	00 
f0101de2:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101de9:	e8 b0 e3 ff ff       	call   f010019e <_panic>

        // free and re-allocate?
        page_free(pp0);
f0101dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101df1:	89 04 24             	mov    %eax,(%esp)
f0101df4:	e8 db 09 00 00       	call   f01027d4 <page_free>
        page_free(pp1);
f0101df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101dfc:	89 04 24             	mov    %eax,(%esp)
f0101dff:	e8 d0 09 00 00       	call   f01027d4 <page_free>
        page_free(pp2);
f0101e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101e07:	89 04 24             	mov    %eax,(%esp)
f0101e0a:	e8 c5 09 00 00       	call   f01027d4 <page_free>
	pp0 = pp1 = pp2 = 0;
f0101e0f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
f0101e16:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101e19:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert(page_alloc(&pp0) == 0);
f0101e22:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0101e25:	89 04 24             	mov    %eax,(%esp)
f0101e28:	e8 54 09 00 00       	call   f0102781 <page_alloc>
f0101e2d:	85 c0                	test   %eax,%eax
f0101e2f:	74 24                	je     f0101e55 <check_page_alloc+0x2ee>
f0101e31:	c7 44 24 0c f5 7f 10 	movl   $0xf0107ff5,0xc(%esp)
f0101e38:	f0 
f0101e39:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101e40:	f0 
f0101e41:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
f0101e48:	00 
f0101e49:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101e50:	e8 49 e3 ff ff       	call   f010019e <_panic>
	assert(page_alloc(&pp1) == 0);
f0101e55:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0101e58:	89 04 24             	mov    %eax,(%esp)
f0101e5b:	e8 21 09 00 00       	call   f0102781 <page_alloc>
f0101e60:	85 c0                	test   %eax,%eax
f0101e62:	74 24                	je     f0101e88 <check_page_alloc+0x321>
f0101e64:	c7 44 24 0c 20 80 10 	movl   $0xf0108020,0xc(%esp)
f0101e6b:	f0 
f0101e6c:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101e73:	f0 
f0101e74:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
f0101e7b:	00 
f0101e7c:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101e83:	e8 16 e3 ff ff       	call   f010019e <_panic>
	assert(page_alloc(&pp2) == 0);
f0101e88:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0101e8b:	89 04 24             	mov    %eax,(%esp)
f0101e8e:	e8 ee 08 00 00       	call   f0102781 <page_alloc>
f0101e93:	85 c0                	test   %eax,%eax
f0101e95:	74 24                	je     f0101ebb <check_page_alloc+0x354>
f0101e97:	c7 44 24 0c 36 80 10 	movl   $0xf0108036,0xc(%esp)
f0101e9e:	f0 
f0101e9f:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101ea6:	f0 
f0101ea7:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
f0101eae:	00 
f0101eaf:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101eb6:	e8 e3 e2 ff ff       	call   f010019e <_panic>
	assert(pp0);
f0101ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101ebe:	85 c0                	test   %eax,%eax
f0101ec0:	75 24                	jne    f0101ee6 <check_page_alloc+0x37f>
f0101ec2:	c7 44 24 0c 4c 80 10 	movl   $0xf010804c,0xc(%esp)
f0101ec9:	f0 
f0101eca:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101ed1:	f0 
f0101ed2:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
f0101ed9:	00 
f0101eda:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101ee1:	e8 b8 e2 ff ff       	call   f010019e <_panic>
	assert(pp1 && pp1 != pp0);
f0101ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101ee9:	85 c0                	test   %eax,%eax
f0101eeb:	74 0a                	je     f0101ef7 <check_page_alloc+0x390>
f0101eed:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0101ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101ef3:	39 c2                	cmp    %eax,%edx
f0101ef5:	75 24                	jne    f0101f1b <check_page_alloc+0x3b4>
f0101ef7:	c7 44 24 0c 50 80 10 	movl   $0xf0108050,0xc(%esp)
f0101efe:	f0 
f0101eff:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101f06:	f0 
f0101f07:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
f0101f0e:	00 
f0101f0f:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101f16:	e8 83 e2 ff ff       	call   f010019e <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101f1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101f1e:	85 c0                	test   %eax,%eax
f0101f20:	74 14                	je     f0101f36 <check_page_alloc+0x3cf>
f0101f22:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0101f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101f28:	39 c2                	cmp    %eax,%edx
f0101f2a:	74 0a                	je     f0101f36 <check_page_alloc+0x3cf>
f0101f2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0101f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101f32:	39 c2                	cmp    %eax,%edx
f0101f34:	75 24                	jne    f0101f5a <check_page_alloc+0x3f3>
f0101f36:	c7 44 24 0c 64 80 10 	movl   $0xf0108064,0xc(%esp)
f0101f3d:	f0 
f0101f3e:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101f45:	f0 
f0101f46:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
f0101f4d:	00 
f0101f4e:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101f55:	e8 44 e2 ff ff       	call   f010019e <_panic>
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101f5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101f5d:	89 04 24             	mov    %eax,(%esp)
f0101f60:	e8 1c 08 00 00       	call   f0102781 <page_alloc>
f0101f65:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101f68:	74 24                	je     f0101f8e <check_page_alloc+0x427>
f0101f6a:	c7 44 24 0c d8 80 10 	movl   $0xf01080d8,0xc(%esp)
f0101f71:	f0 
f0101f72:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0101f79:	f0 
f0101f7a:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
f0101f81:	00 
f0101f82:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0101f89:	e8 10 e2 ff ff       	call   f010019e <_panic>

	// give free list back
	page_free_list = fl;
f0101f8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101f91:	a3 1c 88 1a f0       	mov    %eax,0xf01a881c

	// free the pages we took
	page_free(pp0);
f0101f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101f99:	89 04 24             	mov    %eax,(%esp)
f0101f9c:	e8 33 08 00 00       	call   f01027d4 <page_free>
	page_free(pp1);
f0101fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101fa4:	89 04 24             	mov    %eax,(%esp)
f0101fa7:	e8 28 08 00 00       	call   f01027d4 <page_free>
	page_free(pp2);
f0101fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101faf:	89 04 24             	mov    %eax,(%esp)
f0101fb2:	e8 1d 08 00 00       	call   f01027d4 <page_free>

	cprintf("check_page_alloc() succeeded!\n");
f0101fb7:	c7 04 24 f8 80 10 f0 	movl   $0xf01080f8,(%esp)
f0101fbe:	e8 cb 26 00 00       	call   f010468e <cprintf>
}
f0101fc3:	c9                   	leave  
f0101fc4:	c3                   	ret    

f0101fc5 <check_boot_pgdir>:
//
static physaddr_t check_va2pa(pde_t *pgdir, uintptr_t va);

static void
check_boot_pgdir(void)
{
f0101fc5:	55                   	push   %ebp
f0101fc6:	89 e5                	mov    %esp,%ebp
f0101fc8:	83 ec 48             	sub    $0x48,%esp
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = boot_pgdir;
f0101fcb:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0101fd0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// check pages array
	n = ROUNDUP(npage*sizeof(struct Page), PGSIZE);
f0101fd3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
f0101fda:	8b 15 c0 94 1a f0    	mov    0xf01a94c0,%edx
f0101fe0:	89 d0                	mov    %edx,%eax
f0101fe2:	01 c0                	add    %eax,%eax
f0101fe4:	01 d0                	add    %edx,%eax
f0101fe6:	c1 e0 02             	shl    $0x2,%eax
f0101fe9:	03 45 ec             	add    -0x14(%ebp),%eax
f0101fec:	83 e8 01             	sub    $0x1,%eax
f0101fef:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0101ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101ff5:	ba 00 00 00 00       	mov    $0x0,%edx
f0101ffa:	f7 75 ec             	divl   -0x14(%ebp)
f0101ffd:	89 d0                	mov    %edx,%eax
f0101fff:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0102002:	89 d1                	mov    %edx,%ecx
f0102004:	29 c1                	sub    %eax,%ecx
f0102006:	89 c8                	mov    %ecx,%eax
f0102008:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f010200b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102012:	e9 87 00 00 00       	jmp    f010209e <check_boot_pgdir+0xd9>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102017:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010201a:	2d 00 00 00 11       	sub    $0x11000000,%eax
f010201f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102023:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102026:	89 04 24             	mov    %eax,(%esp)
f0102029:	e8 20 03 00 00       	call   f010234e <check_va2pa>
f010202e:	8b 15 cc 94 1a f0    	mov    0xf01a94cc,%edx
f0102034:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0102037:	81 7d e0 ff ff ff ef 	cmpl   $0xefffffff,-0x20(%ebp)
f010203e:	77 23                	ja     f0102063 <check_boot_pgdir+0x9e>
f0102040:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102043:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102047:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f010204e:	f0 
f010204f:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
f0102056:	00 
f0102057:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010205e:	e8 3b e1 ff ff       	call   f010019e <_panic>
f0102063:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0102066:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f010206c:	03 55 f4             	add    -0xc(%ebp),%edx
f010206f:	39 d0                	cmp    %edx,%eax
f0102071:	74 24                	je     f0102097 <check_boot_pgdir+0xd2>
f0102073:	c7 44 24 0c 18 81 10 	movl   $0xf0108118,0xc(%esp)
f010207a:	f0 
f010207b:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102082:	f0 
f0102083:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
f010208a:	00 
f010208b:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102092:	e8 07 e1 ff ff       	call   f010019e <_panic>

	pgdir = boot_pgdir;

	// check pages array
	n = ROUNDUP(npage*sizeof(struct Page), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0102097:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f010209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01020a1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f01020a4:	0f 82 6d ff ff ff    	jb     f0102017 <check_boot_pgdir+0x52>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
	
	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
f01020aa:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
f01020b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01020b4:	05 ff ff 01 00       	add    $0x1ffff,%eax
f01020b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01020bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01020bf:	ba 00 00 00 00       	mov    $0x0,%edx
f01020c4:	f7 75 dc             	divl   -0x24(%ebp)
f01020c7:	89 d0                	mov    %edx,%eax
f01020c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01020cc:	89 d1                	mov    %edx,%ecx
f01020ce:	29 c1                	sub    %eax,%ecx
f01020d0:	89 c8                	mov    %ecx,%eax
f01020d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f01020d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01020dc:	e9 87 00 00 00       	jmp    f0102168 <check_boot_pgdir+0x1a3>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01020e4:	2d 00 00 40 11       	sub    $0x11400000,%eax
f01020e9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01020ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01020f0:	89 04 24             	mov    %eax,(%esp)
f01020f3:	e8 56 02 00 00       	call   f010234e <check_va2pa>
f01020f8:	8b 15 24 88 1a f0    	mov    0xf01a8824,%edx
f01020fe:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0102101:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102108:	77 23                	ja     f010212d <check_boot_pgdir+0x168>
f010210a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010210d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102111:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f0102118:	f0 
f0102119:	c7 44 24 04 7d 01 00 	movl   $0x17d,0x4(%esp)
f0102120:	00 
f0102121:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102128:	e8 71 e0 ff ff       	call   f010019e <_panic>
f010212d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102130:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0102136:	03 55 f4             	add    -0xc(%ebp),%edx
f0102139:	39 d0                	cmp    %edx,%eax
f010213b:	74 24                	je     f0102161 <check_boot_pgdir+0x19c>
f010213d:	c7 44 24 0c 4c 81 10 	movl   $0xf010814c,0xc(%esp)
f0102144:	f0 
f0102145:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010214c:	f0 
f010214d:	c7 44 24 04 7d 01 00 	movl   $0x17d,0x4(%esp)
f0102154:	00 
f0102155:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010215c:	e8 3d e0 ff ff       	call   f010019e <_panic>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
	
	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0102161:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f0102168:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010216b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f010216e:	0f 82 6d ff ff ff    	jb     f01020e1 <check_boot_pgdir+0x11c>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npage; i += PGSIZE)
f0102174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f010217b:	eb 47                	jmp    f01021c4 <check_boot_pgdir+0x1ff>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f010217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102180:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102185:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102189:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010218c:	89 04 24             	mov    %eax,(%esp)
f010218f:	e8 ba 01 00 00       	call   f010234e <check_va2pa>
f0102194:	3b 45 f4             	cmp    -0xc(%ebp),%eax
f0102197:	74 24                	je     f01021bd <check_boot_pgdir+0x1f8>
f0102199:	c7 44 24 0c 80 81 10 	movl   $0xf0108180,0xc(%esp)
f01021a0:	f0 
f01021a1:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01021a8:	f0 
f01021a9:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
f01021b0:	00 
f01021b1:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01021b8:	e8 e1 df ff ff       	call   f010019e <_panic>
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npage; i += PGSIZE)
f01021bd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f01021c4:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f01021c9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f01021cc:	72 af                	jb     f010217d <check_boot_pgdir+0x1b8>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01021ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01021d5:	e9 85 00 00 00       	jmp    f010225f <check_boot_pgdir+0x29a>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f01021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01021dd:	2d 00 80 40 10       	sub    $0x10408000,%eax
f01021e2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01021e9:	89 04 24             	mov    %eax,(%esp)
f01021ec:	e8 5d 01 00 00       	call   f010234e <check_va2pa>
f01021f1:	c7 45 d0 00 70 11 f0 	movl   $0xf0117000,-0x30(%ebp)
f01021f8:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f01021ff:	77 23                	ja     f0102224 <check_boot_pgdir+0x25f>
f0102201:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102204:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102208:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f010220f:	f0 
f0102210:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
f0102217:	00 
f0102218:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010221f:	e8 7a df ff ff       	call   f010019e <_panic>
f0102224:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0102227:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f010222d:	03 55 f4             	add    -0xc(%ebp),%edx
f0102230:	39 d0                	cmp    %edx,%eax
f0102232:	74 24                	je     f0102258 <check_boot_pgdir+0x293>
f0102234:	c7 44 24 0c a8 81 10 	movl   $0xf01081a8,0xc(%esp)
f010223b:	f0 
f010223c:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102243:	f0 
f0102244:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
f010224b:	00 
f010224c:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102253:	e8 46 df ff ff       	call   f010019e <_panic>
	// check phys mem
	for (i = 0; i < npage; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102258:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f010225f:	81 7d f4 ff 7f 00 00 	cmpl   $0x7fff,-0xc(%ebp)
f0102266:	0f 86 6e ff ff ff    	jbe    f01021da <check_boot_pgdir+0x215>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);

	// check for zero/non-zero in PDEs
	for (i = 0; i < NPDENTRIES; i++) {
f010226c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102273:	e9 bb 00 00 00       	jmp    f0102333 <check_boot_pgdir+0x36e>
		switch (i) {
f0102278:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010227b:	2d bb 03 00 00       	sub    $0x3bb,%eax
f0102280:	83 f8 04             	cmp    $0x4,%eax
f0102283:	77 37                	ja     f01022bc <check_boot_pgdir+0x2f7>
		case PDX(VPT):
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
			assert(pgdir[i]);
f0102285:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102288:	c1 e0 02             	shl    $0x2,%eax
f010228b:	03 45 f0             	add    -0x10(%ebp),%eax
f010228e:	8b 00                	mov    (%eax),%eax
f0102290:	85 c0                	test   %eax,%eax
f0102292:	0f 85 93 00 00 00    	jne    f010232b <check_boot_pgdir+0x366>
f0102298:	c7 44 24 0c ed 81 10 	movl   $0xf01081ed,0xc(%esp)
f010229f:	f0 
f01022a0:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01022a7:	f0 
f01022a8:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
f01022af:	00 
f01022b0:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01022b7:	e8 e2 de ff ff       	call   f010019e <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE))
f01022bc:	81 7d f4 bf 03 00 00 	cmpl   $0x3bf,-0xc(%ebp)
f01022c3:	76 33                	jbe    f01022f8 <check_boot_pgdir+0x333>
				assert(pgdir[i]);
f01022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01022c8:	c1 e0 02             	shl    $0x2,%eax
f01022cb:	03 45 f0             	add    -0x10(%ebp),%eax
f01022ce:	8b 00                	mov    (%eax),%eax
f01022d0:	85 c0                	test   %eax,%eax
f01022d2:	75 5a                	jne    f010232e <check_boot_pgdir+0x369>
f01022d4:	c7 44 24 0c ed 81 10 	movl   $0xf01081ed,0xc(%esp)
f01022db:	f0 
f01022dc:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01022e3:	f0 
f01022e4:	c7 44 24 04 93 01 00 	movl   $0x193,0x4(%esp)
f01022eb:	00 
f01022ec:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01022f3:	e8 a6 de ff ff       	call   f010019e <_panic>
			else
				assert(pgdir[i] == 0);
f01022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01022fb:	c1 e0 02             	shl    $0x2,%eax
f01022fe:	03 45 f0             	add    -0x10(%ebp),%eax
f0102301:	8b 00                	mov    (%eax),%eax
f0102303:	85 c0                	test   %eax,%eax
f0102305:	74 27                	je     f010232e <check_boot_pgdir+0x369>
f0102307:	c7 44 24 0c f6 81 10 	movl   $0xf01081f6,0xc(%esp)
f010230e:	f0 
f010230f:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102316:	f0 
f0102317:	c7 44 24 04 95 01 00 	movl   $0x195,0x4(%esp)
f010231e:	00 
f010231f:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102326:	e8 73 de ff ff       	call   f010019e <_panic>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
			assert(pgdir[i]);
			break;
f010232b:	90                   	nop
f010232c:	eb 01                	jmp    f010232f <check_boot_pgdir+0x36a>
		default:
			if (i >= PDX(KERNBASE))
				assert(pgdir[i]);
			else
				assert(pgdir[i] == 0);
			break;
f010232e:	90                   	nop
	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);

	// check for zero/non-zero in PDEs
	for (i = 0; i < NPDENTRIES; i++) {
f010232f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0102333:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
f010233a:	0f 86 38 ff ff ff    	jbe    f0102278 <check_boot_pgdir+0x2b3>
			else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_boot_pgdir() succeeded!\n");
f0102340:	c7 04 24 04 82 10 f0 	movl   $0xf0108204,(%esp)
f0102347:	e8 42 23 00 00       	call   f010468e <cprintf>
}
f010234c:	c9                   	leave  
f010234d:	c3                   	ret    

f010234e <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_boot_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f010234e:	55                   	push   %ebp
f010234f:	89 e5                	mov    %esp,%ebp
f0102351:	83 ec 28             	sub    $0x28,%esp
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0102354:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102357:	c1 e8 16             	shr    $0x16,%eax
f010235a:	c1 e0 02             	shl    $0x2,%eax
f010235d:	01 45 08             	add    %eax,0x8(%ebp)
	if (!(*pgdir & PTE_P))
f0102360:	8b 45 08             	mov    0x8(%ebp),%eax
f0102363:	8b 00                	mov    (%eax),%eax
f0102365:	83 e0 01             	and    $0x1,%eax
f0102368:	85 c0                	test   %eax,%eax
f010236a:	75 0a                	jne    f0102376 <check_va2pa+0x28>
		return ~0;
f010236c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0102371:	e9 87 00 00 00       	jmp    f01023fd <check_va2pa+0xaf>
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0102376:	8b 45 08             	mov    0x8(%ebp),%eax
f0102379:	8b 00                	mov    (%eax),%eax
f010237b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102380:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0102383:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102386:	c1 e8 0c             	shr    $0xc,%eax
f0102389:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010238c:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f0102391:	39 45 f0             	cmp    %eax,-0x10(%ebp)
f0102394:	72 23                	jb     f01023b9 <check_va2pa+0x6b>
f0102396:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102399:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010239d:	c7 44 24 08 0c 7f 10 	movl   $0xf0107f0c,0x8(%esp)
f01023a4:	f0 
f01023a5:	c7 44 24 04 a9 01 00 	movl   $0x1a9,0x4(%esp)
f01023ac:	00 
f01023ad:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01023b4:	e8 e5 dd ff ff       	call   f010019e <_panic>
f01023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01023bc:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01023c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (!(p[PTX(va)] & PTE_P))
f01023c4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01023c7:	c1 e8 0c             	shr    $0xc,%eax
f01023ca:	25 ff 03 00 00       	and    $0x3ff,%eax
f01023cf:	c1 e0 02             	shl    $0x2,%eax
f01023d2:	03 45 ec             	add    -0x14(%ebp),%eax
f01023d5:	8b 00                	mov    (%eax),%eax
f01023d7:	83 e0 01             	and    $0x1,%eax
f01023da:	85 c0                	test   %eax,%eax
f01023dc:	75 07                	jne    f01023e5 <check_va2pa+0x97>
		return ~0;
f01023de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01023e3:	eb 18                	jmp    f01023fd <check_va2pa+0xaf>
	return PTE_ADDR(p[PTX(va)]);
f01023e5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01023e8:	c1 e8 0c             	shr    $0xc,%eax
f01023eb:	25 ff 03 00 00       	and    $0x3ff,%eax
f01023f0:	c1 e0 02             	shl    $0x2,%eax
f01023f3:	03 45 ec             	add    -0x14(%ebp),%eax
f01023f6:	8b 00                	mov    (%eax),%eax
f01023f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
f01023fd:	c9                   	leave  
f01023fe:	c3                   	ret    

f01023ff <page_init>:
// to allocate and deallocate physical memory via the page_free_list,
// and NEVER use boot_alloc()
//
void
page_init(void)
{
f01023ff:	55                   	push   %ebp
f0102400:	89 e5                	mov    %esp,%ebp
f0102402:	53                   	push   %ebx
f0102403:	83 ec 24             	sub    $0x24,%esp
	//     Some of it is in use, some is free. Where is the kernel?
	//     Which pages are used for page tables and other data structures?
	//
	// Change the code to reflect this.
	int i;
	LIST_INIT(&page_free_list);
f0102406:	c7 05 1c 88 1a f0 00 	movl   $0x0,0xf01a881c
f010240d:	00 00 00 
	for (i = 0; i < npage; i++) { // all set
f0102410:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102417:	e9 91 00 00 00       	jmp    f01024ad <page_init+0xae>
		pages[i].pp_ref = 0;
f010241c:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f0102422:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0102425:	89 d0                	mov    %edx,%eax
f0102427:	01 c0                	add    %eax,%eax
f0102429:	01 d0                	add    %edx,%eax
f010242b:	c1 e0 02             	shl    $0x2,%eax
f010242e:	01 c8                	add    %ecx,%eax
f0102430:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
f0102436:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f010243c:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010243f:	89 d0                	mov    %edx,%eax
f0102441:	01 c0                	add    %eax,%eax
f0102443:	01 d0                	add    %edx,%eax
f0102445:	c1 e0 02             	shl    $0x2,%eax
f0102448:	01 c8                	add    %ecx,%eax
f010244a:	8b 15 1c 88 1a f0    	mov    0xf01a881c,%edx
f0102450:	89 10                	mov    %edx,(%eax)
f0102452:	8b 00                	mov    (%eax),%eax
f0102454:	85 c0                	test   %eax,%eax
f0102456:	74 1d                	je     f0102475 <page_init+0x76>
f0102458:	8b 0d 1c 88 1a f0    	mov    0xf01a881c,%ecx
f010245e:	8b 1d cc 94 1a f0    	mov    0xf01a94cc,%ebx
f0102464:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0102467:	89 d0                	mov    %edx,%eax
f0102469:	01 c0                	add    %eax,%eax
f010246b:	01 d0                	add    %edx,%eax
f010246d:	c1 e0 02             	shl    $0x2,%eax
f0102470:	01 d8                	add    %ebx,%eax
f0102472:	89 41 04             	mov    %eax,0x4(%ecx)
f0102475:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f010247b:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010247e:	89 d0                	mov    %edx,%eax
f0102480:	01 c0                	add    %eax,%eax
f0102482:	01 d0                	add    %edx,%eax
f0102484:	c1 e0 02             	shl    $0x2,%eax
f0102487:	01 c8                	add    %ecx,%eax
f0102489:	a3 1c 88 1a f0       	mov    %eax,0xf01a881c
f010248e:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f0102494:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0102497:	89 d0                	mov    %edx,%eax
f0102499:	01 c0                	add    %eax,%eax
f010249b:	01 d0                	add    %edx,%eax
f010249d:	c1 e0 02             	shl    $0x2,%eax
f01024a0:	01 c8                	add    %ecx,%eax
f01024a2:	c7 40 04 1c 88 1a f0 	movl   $0xf01a881c,0x4(%eax)
	//     Which pages are used for page tables and other data structures?
	//
	// Change the code to reflect this.
	int i;
	LIST_INIT(&page_free_list);
	for (i = 0; i < npage; i++) { // all set
f01024a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f01024ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01024b0:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f01024b5:	39 c2                	cmp    %eax,%edx
f01024b7:	0f 82 5f ff ff ff    	jb     f010241c <page_init+0x1d>
		pages[i].pp_ref = 0;
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
	}
	pages[0].pp_ref = 1;
f01024bd:	a1 cc 94 1a f0       	mov    0xf01a94cc,%eax
f01024c2:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)
	LIST_REMOVE(&pages[0], pp_link); // begin to delete
f01024c8:	a1 cc 94 1a f0       	mov    0xf01a94cc,%eax
f01024cd:	8b 00                	mov    (%eax),%eax
f01024cf:	85 c0                	test   %eax,%eax
f01024d1:	74 13                	je     f01024e6 <page_init+0xe7>
f01024d3:	a1 cc 94 1a f0       	mov    0xf01a94cc,%eax
f01024d8:	8b 00                	mov    (%eax),%eax
f01024da:	8b 15 cc 94 1a f0    	mov    0xf01a94cc,%edx
f01024e0:	8b 52 04             	mov    0x4(%edx),%edx
f01024e3:	89 50 04             	mov    %edx,0x4(%eax)
f01024e6:	a1 cc 94 1a f0       	mov    0xf01a94cc,%eax
f01024eb:	8b 40 04             	mov    0x4(%eax),%eax
f01024ee:	8b 15 cc 94 1a f0    	mov    0xf01a94cc,%edx
f01024f4:	8b 12                	mov    (%edx),%edx
f01024f6:	89 10                	mov    %edx,(%eax)
	for (i = IOPHYSMEM; i < EXTPHYSMEM; i += PGSIZE) {
f01024f8:	c7 45 f4 00 00 0a 00 	movl   $0xa0000,-0xc(%ebp)
f01024ff:	e9 fa 00 00 00       	jmp    f01025fe <page_init+0x1ff>
		pages[i/PGSIZE].pp_ref = 1;
f0102504:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f010250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010250d:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0102513:	85 c0                	test   %eax,%eax
f0102515:	0f 48 c2             	cmovs  %edx,%eax
f0102518:	c1 f8 0c             	sar    $0xc,%eax
f010251b:	89 c2                	mov    %eax,%edx
f010251d:	89 d0                	mov    %edx,%eax
f010251f:	01 c0                	add    %eax,%eax
f0102521:	01 d0                	add    %edx,%eax
f0102523:	c1 e0 02             	shl    $0x2,%eax
f0102526:	01 c8                	add    %ecx,%eax
f0102528:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)
		LIST_REMOVE(&pages[i/PGSIZE], pp_link);
f010252e:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f0102534:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102537:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f010253d:	85 c0                	test   %eax,%eax
f010253f:	0f 48 c2             	cmovs  %edx,%eax
f0102542:	c1 f8 0c             	sar    $0xc,%eax
f0102545:	89 c2                	mov    %eax,%edx
f0102547:	89 d0                	mov    %edx,%eax
f0102549:	01 c0                	add    %eax,%eax
f010254b:	01 d0                	add    %edx,%eax
f010254d:	c1 e0 02             	shl    $0x2,%eax
f0102550:	01 c8                	add    %ecx,%eax
f0102552:	8b 00                	mov    (%eax),%eax
f0102554:	85 c0                	test   %eax,%eax
f0102556:	74 50                	je     f01025a8 <page_init+0x1a9>
f0102558:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f010255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102561:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0102567:	85 c0                	test   %eax,%eax
f0102569:	0f 48 c2             	cmovs  %edx,%eax
f010256c:	c1 f8 0c             	sar    $0xc,%eax
f010256f:	89 c2                	mov    %eax,%edx
f0102571:	89 d0                	mov    %edx,%eax
f0102573:	01 c0                	add    %eax,%eax
f0102575:	01 d0                	add    %edx,%eax
f0102577:	c1 e0 02             	shl    $0x2,%eax
f010257a:	01 c8                	add    %ecx,%eax
f010257c:	8b 08                	mov    (%eax),%ecx
f010257e:	8b 1d cc 94 1a f0    	mov    0xf01a94cc,%ebx
f0102584:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102587:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f010258d:	85 c0                	test   %eax,%eax
f010258f:	0f 48 c2             	cmovs  %edx,%eax
f0102592:	c1 f8 0c             	sar    $0xc,%eax
f0102595:	89 c2                	mov    %eax,%edx
f0102597:	89 d0                	mov    %edx,%eax
f0102599:	01 c0                	add    %eax,%eax
f010259b:	01 d0                	add    %edx,%eax
f010259d:	c1 e0 02             	shl    $0x2,%eax
f01025a0:	01 d8                	add    %ebx,%eax
f01025a2:	8b 40 04             	mov    0x4(%eax),%eax
f01025a5:	89 41 04             	mov    %eax,0x4(%ecx)
f01025a8:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f01025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01025b1:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01025b7:	85 c0                	test   %eax,%eax
f01025b9:	0f 48 c2             	cmovs  %edx,%eax
f01025bc:	c1 f8 0c             	sar    $0xc,%eax
f01025bf:	89 c2                	mov    %eax,%edx
f01025c1:	89 d0                	mov    %edx,%eax
f01025c3:	01 c0                	add    %eax,%eax
f01025c5:	01 d0                	add    %edx,%eax
f01025c7:	c1 e0 02             	shl    $0x2,%eax
f01025ca:	01 c8                	add    %ecx,%eax
f01025cc:	8b 48 04             	mov    0x4(%eax),%ecx
f01025cf:	8b 1d cc 94 1a f0    	mov    0xf01a94cc,%ebx
f01025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01025d8:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01025de:	85 c0                	test   %eax,%eax
f01025e0:	0f 48 c2             	cmovs  %edx,%eax
f01025e3:	c1 f8 0c             	sar    $0xc,%eax
f01025e6:	89 c2                	mov    %eax,%edx
f01025e8:	89 d0                	mov    %edx,%eax
f01025ea:	01 c0                	add    %eax,%eax
f01025ec:	01 d0                	add    %edx,%eax
f01025ee:	c1 e0 02             	shl    $0x2,%eax
f01025f1:	01 d8                	add    %ebx,%eax
f01025f3:	8b 00                	mov    (%eax),%eax
f01025f5:	89 01                	mov    %eax,(%ecx)
		pages[i].pp_ref = 0;
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
	}
	pages[0].pp_ref = 1;
	LIST_REMOVE(&pages[0], pp_link); // begin to delete
	for (i = IOPHYSMEM; i < EXTPHYSMEM; i += PGSIZE) {
f01025f7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f01025fe:	81 7d f4 ff ff 0f 00 	cmpl   $0xfffff,-0xc(%ebp)
f0102605:	0f 8e f9 fe ff ff    	jle    f0102504 <page_init+0x105>
		pages[i/PGSIZE].pp_ref = 1;
		LIST_REMOVE(&pages[i/PGSIZE], pp_link);
	}
	for (i = EXTPHYSMEM; i < PADDR((unsigned int)boot_freemem); i += PGSIZE) {
f010260b:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
f0102612:	e9 fa 00 00 00       	jmp    f0102711 <page_init+0x312>
		pages[i/PGSIZE].pp_ref = 1;
f0102617:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f010261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102620:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0102626:	85 c0                	test   %eax,%eax
f0102628:	0f 48 c2             	cmovs  %edx,%eax
f010262b:	c1 f8 0c             	sar    $0xc,%eax
f010262e:	89 c2                	mov    %eax,%edx
f0102630:	89 d0                	mov    %edx,%eax
f0102632:	01 c0                	add    %eax,%eax
f0102634:	01 d0                	add    %edx,%eax
f0102636:	c1 e0 02             	shl    $0x2,%eax
f0102639:	01 c8                	add    %ecx,%eax
f010263b:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)
		LIST_REMOVE(&pages[i/PGSIZE], pp_link);
f0102641:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f0102647:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010264a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0102650:	85 c0                	test   %eax,%eax
f0102652:	0f 48 c2             	cmovs  %edx,%eax
f0102655:	c1 f8 0c             	sar    $0xc,%eax
f0102658:	89 c2                	mov    %eax,%edx
f010265a:	89 d0                	mov    %edx,%eax
f010265c:	01 c0                	add    %eax,%eax
f010265e:	01 d0                	add    %edx,%eax
f0102660:	c1 e0 02             	shl    $0x2,%eax
f0102663:	01 c8                	add    %ecx,%eax
f0102665:	8b 00                	mov    (%eax),%eax
f0102667:	85 c0                	test   %eax,%eax
f0102669:	74 50                	je     f01026bb <page_init+0x2bc>
f010266b:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f0102671:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102674:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f010267a:	85 c0                	test   %eax,%eax
f010267c:	0f 48 c2             	cmovs  %edx,%eax
f010267f:	c1 f8 0c             	sar    $0xc,%eax
f0102682:	89 c2                	mov    %eax,%edx
f0102684:	89 d0                	mov    %edx,%eax
f0102686:	01 c0                	add    %eax,%eax
f0102688:	01 d0                	add    %edx,%eax
f010268a:	c1 e0 02             	shl    $0x2,%eax
f010268d:	01 c8                	add    %ecx,%eax
f010268f:	8b 08                	mov    (%eax),%ecx
f0102691:	8b 1d cc 94 1a f0    	mov    0xf01a94cc,%ebx
f0102697:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010269a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01026a0:	85 c0                	test   %eax,%eax
f01026a2:	0f 48 c2             	cmovs  %edx,%eax
f01026a5:	c1 f8 0c             	sar    $0xc,%eax
f01026a8:	89 c2                	mov    %eax,%edx
f01026aa:	89 d0                	mov    %edx,%eax
f01026ac:	01 c0                	add    %eax,%eax
f01026ae:	01 d0                	add    %edx,%eax
f01026b0:	c1 e0 02             	shl    $0x2,%eax
f01026b3:	01 d8                	add    %ebx,%eax
f01026b5:	8b 40 04             	mov    0x4(%eax),%eax
f01026b8:	89 41 04             	mov    %eax,0x4(%ecx)
f01026bb:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f01026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01026c4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01026ca:	85 c0                	test   %eax,%eax
f01026cc:	0f 48 c2             	cmovs  %edx,%eax
f01026cf:	c1 f8 0c             	sar    $0xc,%eax
f01026d2:	89 c2                	mov    %eax,%edx
f01026d4:	89 d0                	mov    %edx,%eax
f01026d6:	01 c0                	add    %eax,%eax
f01026d8:	01 d0                	add    %edx,%eax
f01026da:	c1 e0 02             	shl    $0x2,%eax
f01026dd:	01 c8                	add    %ecx,%eax
f01026df:	8b 48 04             	mov    0x4(%eax),%ecx
f01026e2:	8b 1d cc 94 1a f0    	mov    0xf01a94cc,%ebx
f01026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01026eb:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01026f1:	85 c0                	test   %eax,%eax
f01026f3:	0f 48 c2             	cmovs  %edx,%eax
f01026f6:	c1 f8 0c             	sar    $0xc,%eax
f01026f9:	89 c2                	mov    %eax,%edx
f01026fb:	89 d0                	mov    %edx,%eax
f01026fd:	01 c0                	add    %eax,%eax
f01026ff:	01 d0                	add    %edx,%eax
f0102701:	c1 e0 02             	shl    $0x2,%eax
f0102704:	01 d8                	add    %ebx,%eax
f0102706:	8b 00                	mov    (%eax),%eax
f0102708:	89 01                	mov    %eax,(%ecx)
	LIST_REMOVE(&pages[0], pp_link); // begin to delete
	for (i = IOPHYSMEM; i < EXTPHYSMEM; i += PGSIZE) {
		pages[i/PGSIZE].pp_ref = 1;
		LIST_REMOVE(&pages[i/PGSIZE], pp_link);
	}
	for (i = EXTPHYSMEM; i < PADDR((unsigned int)boot_freemem); i += PGSIZE) {
f010270a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f0102711:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0102714:	a1 18 88 1a f0       	mov    0xf01a8818,%eax
f0102719:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010271c:	81 7d f0 ff ff ff ef 	cmpl   $0xefffffff,-0x10(%ebp)
f0102723:	77 23                	ja     f0102748 <page_init+0x349>
f0102725:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102728:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010272c:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f0102733:	f0 
f0102734:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
f010273b:	00 
f010273c:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102743:	e8 56 da ff ff       	call   f010019e <_panic>
f0102748:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010274b:	05 00 00 00 10       	add    $0x10000000,%eax
f0102750:	39 c2                	cmp    %eax,%edx
f0102752:	0f 82 bf fe ff ff    	jb     f0102617 <page_init+0x218>
		pages[i/PGSIZE].pp_ref = 1;
		LIST_REMOVE(&pages[i/PGSIZE], pp_link);
	}
}
f0102758:	83 c4 24             	add    $0x24,%esp
f010275b:	5b                   	pop    %ebx
f010275c:	5d                   	pop    %ebp
f010275d:	c3                   	ret    

f010275e <page_initpp>:
// The result has null links and 0 refcount.
// Note that the corresponding physical page is NOT initialized!
//
static void
page_initpp(struct Page *pp)
{
f010275e:	55                   	push   %ebp
f010275f:	89 e5                	mov    %esp,%ebp
f0102761:	83 ec 18             	sub    $0x18,%esp
	memset(pp, 0, sizeof(*pp));
f0102764:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
f010276b:	00 
f010276c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102773:	00 
f0102774:	8b 45 08             	mov    0x8(%ebp),%eax
f0102777:	89 04 24             	mov    %eax,(%esp)
f010277a:	e8 74 4a 00 00       	call   f01071f3 <memset>
}
f010277f:	c9                   	leave  
f0102780:	c3                   	ret    

f0102781 <page_alloc>:
//
// Hint: use LIST_FIRST, LIST_REMOVE, and page_initpp
// Hint: pp_ref should not be incremented 
int
page_alloc(struct Page **pp_store)
{
f0102781:	55                   	push   %ebp
f0102782:	89 e5                	mov    %esp,%ebp
	// Fill this function in
	if(LIST_FIRST(&page_free_list) == NULL){
f0102784:	a1 1c 88 1a f0       	mov    0xf01a881c,%eax
f0102789:	85 c0                	test   %eax,%eax
f010278b:	75 07                	jne    f0102794 <page_alloc+0x13>
		return -E_NO_MEM;
f010278d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0102792:	eb 3e                	jmp    f01027d2 <page_alloc+0x51>
	}
	else{
		*pp_store = LIST_FIRST(&page_free_list);
f0102794:	8b 15 1c 88 1a f0    	mov    0xf01a881c,%edx
f010279a:	8b 45 08             	mov    0x8(%ebp),%eax
f010279d:	89 10                	mov    %edx,(%eax)
		//page_initpp(*pp_store);
		LIST_REMOVE(*pp_store, pp_link);
f010279f:	8b 45 08             	mov    0x8(%ebp),%eax
f01027a2:	8b 00                	mov    (%eax),%eax
f01027a4:	8b 00                	mov    (%eax),%eax
f01027a6:	85 c0                	test   %eax,%eax
f01027a8:	74 12                	je     f01027bc <page_alloc+0x3b>
f01027aa:	8b 45 08             	mov    0x8(%ebp),%eax
f01027ad:	8b 00                	mov    (%eax),%eax
f01027af:	8b 00                	mov    (%eax),%eax
f01027b1:	8b 55 08             	mov    0x8(%ebp),%edx
f01027b4:	8b 12                	mov    (%edx),%edx
f01027b6:	8b 52 04             	mov    0x4(%edx),%edx
f01027b9:	89 50 04             	mov    %edx,0x4(%eax)
f01027bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01027bf:	8b 00                	mov    (%eax),%eax
f01027c1:	8b 40 04             	mov    0x4(%eax),%eax
f01027c4:	8b 55 08             	mov    0x8(%ebp),%edx
f01027c7:	8b 12                	mov    (%edx),%edx
f01027c9:	8b 12                	mov    (%edx),%edx
f01027cb:	89 10                	mov    %edx,(%eax)
		return 0;
f01027cd:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
f01027d2:	5d                   	pop    %ebp
f01027d3:	c3                   	ret    

f01027d4 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct Page *pp)
{
f01027d4:	55                   	push   %ebp
f01027d5:	89 e5                	mov    %esp,%ebp
f01027d7:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	if(pp->pp_ref) return;
f01027da:	8b 45 08             	mov    0x8(%ebp),%eax
f01027dd:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f01027e1:	66 85 c0             	test   %ax,%ax
f01027e4:	75 3f                	jne    f0102825 <page_free+0x51>
	else{
		page_initpp(pp);
f01027e6:	8b 45 08             	mov    0x8(%ebp),%eax
f01027e9:	89 04 24             	mov    %eax,(%esp)
f01027ec:	e8 6d ff ff ff       	call   f010275e <page_initpp>
		LIST_INSERT_HEAD(&page_free_list, pp, pp_link);
f01027f1:	8b 15 1c 88 1a f0    	mov    0xf01a881c,%edx
f01027f7:	8b 45 08             	mov    0x8(%ebp),%eax
f01027fa:	89 10                	mov    %edx,(%eax)
f01027fc:	8b 45 08             	mov    0x8(%ebp),%eax
f01027ff:	8b 00                	mov    (%eax),%eax
f0102801:	85 c0                	test   %eax,%eax
f0102803:	74 0b                	je     f0102810 <page_free+0x3c>
f0102805:	a1 1c 88 1a f0       	mov    0xf01a881c,%eax
f010280a:	8b 55 08             	mov    0x8(%ebp),%edx
f010280d:	89 50 04             	mov    %edx,0x4(%eax)
f0102810:	8b 45 08             	mov    0x8(%ebp),%eax
f0102813:	a3 1c 88 1a f0       	mov    %eax,0xf01a881c
f0102818:	8b 45 08             	mov    0x8(%ebp),%eax
f010281b:	c7 40 04 1c 88 1a f0 	movl   $0xf01a881c,0x4(%eax)
		return;
f0102822:	90                   	nop
f0102823:	eb 01                	jmp    f0102826 <page_free+0x52>
//
void
page_free(struct Page *pp)
{
	// Fill this function in
	if(pp->pp_ref) return;
f0102825:	90                   	nop
	else{
		page_initpp(pp);
		LIST_INSERT_HEAD(&page_free_list, pp, pp_link);
		return;
	}
}
f0102826:	c9                   	leave  
f0102827:	c3                   	ret    

f0102828 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct Page* pp)
{
f0102828:	55                   	push   %ebp
f0102829:	89 e5                	mov    %esp,%ebp
f010282b:	83 ec 18             	sub    $0x18,%esp
	if (--pp->pp_ref == 0)
f010282e:	8b 45 08             	mov    0x8(%ebp),%eax
f0102831:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f0102835:	8d 50 ff             	lea    -0x1(%eax),%edx
f0102838:	8b 45 08             	mov    0x8(%ebp),%eax
f010283b:	66 89 50 08          	mov    %dx,0x8(%eax)
f010283f:	8b 45 08             	mov    0x8(%ebp),%eax
f0102842:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f0102846:	66 85 c0             	test   %ax,%ax
f0102849:	75 0b                	jne    f0102856 <page_decref+0x2e>
		page_free(pp);
f010284b:	8b 45 08             	mov    0x8(%ebp),%eax
f010284e:	89 04 24             	mov    %eax,(%esp)
f0102851:	e8 7e ff ff ff       	call   f01027d4 <page_free>
}
f0102856:	c9                   	leave  
f0102857:	c3                   	ret    

f0102858 <pgdir_walk>:
//
// Hint: you can turn a Page * into the physical address of the
// page it refers to with page2pa() from kern/pmap.h.
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f0102858:	55                   	push   %ebp
f0102859:	89 e5                	mov    %esp,%ebp
f010285b:	83 ec 38             	sub    $0x38,%esp
	// Fill this function in
    pde_t *pt = pgdir + PDX(va);
f010285e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102861:	c1 e8 16             	shr    $0x16,%eax
f0102864:	c1 e0 02             	shl    $0x2,%eax
f0102867:	03 45 08             	add    0x8(%ebp),%eax
f010286a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(*pt & PTE_P){//pt[PTE_P] == 1
f010286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102870:	8b 00                	mov    (%eax),%eax
f0102872:	83 e0 01             	and    $0x1,%eax
f0102875:	84 c0                	test   %al,%al
f0102877:	74 61                	je     f01028da <pgdir_walk+0x82>
        return (pte_t *)KADDR(PTE_ADDR(*pt)) + PTX(va);
f0102879:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010287c:	8b 00                	mov    (%eax),%eax
f010287e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102883:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0102886:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102889:	c1 e8 0c             	shr    $0xc,%eax
f010288c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010288f:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f0102894:	39 45 ec             	cmp    %eax,-0x14(%ebp)
f0102897:	72 23                	jb     f01028bc <pgdir_walk+0x64>
f0102899:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010289c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01028a0:	c7 44 24 08 0c 7f 10 	movl   $0xf0107f0c,0x8(%esp)
f01028a7:	f0 
f01028a8:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
f01028af:	00 
f01028b0:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01028b7:	e8 e2 d8 ff ff       	call   f010019e <_panic>
f01028bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01028bf:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01028c4:	8b 55 0c             	mov    0xc(%ebp),%edx
f01028c7:	c1 ea 0c             	shr    $0xc,%edx
f01028ca:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f01028d0:	c1 e2 02             	shl    $0x2,%edx
f01028d3:	01 d0                	add    %edx,%eax
f01028d5:	e9 f8 00 00 00       	jmp    f01029d2 <pgdir_walk+0x17a>
    }
    struct Page *pg;
    if(create == 1 && page_alloc(&pg) == 0){
f01028da:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
f01028de:	0f 85 e9 00 00 00    	jne    f01029cd <pgdir_walk+0x175>
f01028e4:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01028e7:	89 04 24             	mov    %eax,(%esp)
f01028ea:	e8 92 fe ff ff       	call   f0102781 <page_alloc>
f01028ef:	85 c0                	test   %eax,%eax
f01028f1:	0f 85 d6 00 00 00    	jne    f01029cd <pgdir_walk+0x175>
        pg->pp_ref = 1;
f01028f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01028fa:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)
        memset(page2kva(pg), 0, PGSIZE);//pg turn to the va to be init
f0102900:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0102903:	89 04 24             	mov    %eax,(%esp)
f0102906:	e8 d1 ec ff ff       	call   f01015dc <page2kva>
f010290b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102912:	00 
f0102913:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010291a:	00 
f010291b:	89 04 24             	mov    %eax,(%esp)
f010291e:	e8 d0 48 00 00       	call   f01071f3 <memset>

        *pt = PADDR(page2kva(pg))|PTE_U|PTE_W|PTE_P;//same with the begin
f0102923:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0102926:	89 04 24             	mov    %eax,(%esp)
f0102929:	e8 ae ec ff ff       	call   f01015dc <page2kva>
f010292e:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0102931:	81 7d e8 ff ff ff ef 	cmpl   $0xefffffff,-0x18(%ebp)
f0102938:	77 23                	ja     f010295d <pgdir_walk+0x105>
f010293a:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010293d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102941:	c7 44 24 08 70 7f 10 	movl   $0xf0107f70,0x8(%esp)
f0102948:	f0 
f0102949:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
f0102950:	00 
f0102951:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102958:	e8 41 d8 ff ff       	call   f010019e <_panic>
f010295d:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0102960:	05 00 00 00 10       	add    $0x10000000,%eax
f0102965:	89 c2                	mov    %eax,%edx
f0102967:	83 ca 07             	or     $0x7,%edx
f010296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010296d:	89 10                	mov    %edx,(%eax)
        return (pte_t *)KADDR(PTE_ADDR(*pt)) + PTX(va);
f010296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102972:	8b 00                	mov    (%eax),%eax
f0102974:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010297c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010297f:	c1 e8 0c             	shr    $0xc,%eax
f0102982:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0102985:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f010298a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f010298d:	72 23                	jb     f01029b2 <pgdir_walk+0x15a>
f010298f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102992:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102996:	c7 44 24 08 0c 7f 10 	movl   $0xf0107f0c,0x8(%esp)
f010299d:	f0 
f010299e:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
f01029a5:	00 
f01029a6:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01029ad:	e8 ec d7 ff ff       	call   f010019e <_panic>
f01029b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01029b5:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01029ba:	8b 55 0c             	mov    0xc(%ebp),%edx
f01029bd:	c1 ea 0c             	shr    $0xc,%edx
f01029c0:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f01029c6:	c1 e2 02             	shl    $0x2,%edx
f01029c9:	01 d0                	add    %edx,%eax
f01029cb:	eb 05                	jmp    f01029d2 <pgdir_walk+0x17a>
    }
	return NULL;
f01029cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01029d2:	c9                   	leave  
f01029d3:	c3                   	ret    

f01029d4 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct Page *pp, void *va, int perm) 
{
f01029d4:	55                   	push   %ebp
f01029d5:	89 e5                	mov    %esp,%ebp
f01029d7:	83 ec 28             	sub    $0x28,%esp
	// Fill this function in
	pte_t *pte;
	pte = pgdir_walk(pgdir, va, 1);
f01029da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01029e1:	00 
f01029e2:	8b 45 10             	mov    0x10(%ebp),%eax
f01029e5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01029e9:	8b 45 08             	mov    0x8(%ebp),%eax
f01029ec:	89 04 24             	mov    %eax,(%esp)
f01029ef:	e8 64 fe ff ff       	call   f0102858 <pgdir_walk>
f01029f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(pte == NULL){
f01029f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01029fb:	75 07                	jne    f0102a04 <page_insert+0x30>
		return -E_NO_MEM;
f01029fd:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0102a02:	eb 4e                	jmp    f0102a52 <page_insert+0x7e>
	}
	else{
		pp->pp_ref ++;
f0102a04:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102a07:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f0102a0b:	8d 50 01             	lea    0x1(%eax),%edx
f0102a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102a11:	66 89 50 08          	mov    %dx,0x8(%eax)
		if((*pte & PTE_P)){
f0102a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102a18:	8b 00                	mov    (%eax),%eax
f0102a1a:	83 e0 01             	and    $0x1,%eax
f0102a1d:	84 c0                	test   %al,%al
f0102a1f:	74 12                	je     f0102a33 <page_insert+0x5f>
            //if(PTE_ADDR(*pte) == page2pa(pp)) pp->pp_ref --;
            //else
			page_remove(pgdir, va);
f0102a21:	8b 45 10             	mov    0x10(%ebp),%eax
f0102a24:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102a28:	8b 45 08             	mov    0x8(%ebp),%eax
f0102a2b:	89 04 24             	mov    %eax,(%esp)
f0102a2e:	e8 31 01 00 00       	call   f0102b64 <page_remove>
		}
		*pte = page2pa(pp) | PTE_P | perm;
f0102a33:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102a36:	89 04 24             	mov    %eax,(%esp)
f0102a39:	e8 3a eb ff ff       	call   f0101578 <page2pa>
f0102a3e:	8b 55 14             	mov    0x14(%ebp),%edx
f0102a41:	09 d0                	or     %edx,%eax
f0102a43:	89 c2                	mov    %eax,%edx
f0102a45:	83 ca 01             	or     $0x1,%edx
f0102a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102a4b:	89 10                	mov    %edx,(%eax)
		return 0;
f0102a4d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	return 0;
}
f0102a52:	c9                   	leave  
f0102a53:	c3                   	ret    

f0102a54 <boot_map_segment>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm)
{
f0102a54:	55                   	push   %ebp
f0102a55:	89 e5                	mov    %esp,%ebp
f0102a57:	83 ec 28             	sub    $0x28,%esp
	// Fill this function in
	uint32_t i;
	pte_t *pte;
	size = ROUNDUP(size, PGSIZE);
f0102a5a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
f0102a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102a64:	8b 55 10             	mov    0x10(%ebp),%edx
f0102a67:	01 d0                	add    %edx,%eax
f0102a69:	83 e8 01             	sub    $0x1,%eax
f0102a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0102a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0102a72:	ba 00 00 00 00       	mov    $0x0,%edx
f0102a77:	f7 75 f0             	divl   -0x10(%ebp)
f0102a7a:	89 d0                	mov    %edx,%eax
f0102a7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0102a7f:	89 d1                	mov    %edx,%ecx
f0102a81:	29 c1                	sub    %eax,%ecx
f0102a83:	89 c8                	mov    %ecx,%eax
f0102a85:	89 45 10             	mov    %eax,0x10(%ebp)
	for(i=0;i<size; i += PGSIZE){
f0102a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102a8f:	eb 70                	jmp    f0102b01 <boot_map_segment+0xad>
		pte = pgdir_walk(pgdir,(void *)(la+i), 1);
f0102a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102a94:	8b 55 0c             	mov    0xc(%ebp),%edx
f0102a97:	01 d0                	add    %edx,%eax
f0102a99:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102aa0:	00 
f0102aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102aa5:	8b 45 08             	mov    0x8(%ebp),%eax
f0102aa8:	89 04 24             	mov    %eax,(%esp)
f0102aab:	e8 a8 fd ff ff       	call   f0102858 <pgdir_walk>
f0102ab0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(pte == NULL){
f0102ab3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0102ab7:	75 2a                	jne    f0102ae3 <boot_map_segment+0x8f>
			assert(pte!=NULL);
f0102ab9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0102abd:	75 24                	jne    f0102ae3 <boot_map_segment+0x8f>
f0102abf:	c7 44 24 0c 23 82 10 	movl   $0xf0108223,0xc(%esp)
f0102ac6:	f0 
f0102ac7:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102ace:	f0 
f0102acf:	c7 44 24 04 7d 02 00 	movl   $0x27d,0x4(%esp)
f0102ad6:	00 
f0102ad7:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102ade:	e8 bb d6 ff ff       	call   f010019e <_panic>
		}
		*pte = (pa+i)| perm | PTE_P;
f0102ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102ae6:	8b 55 14             	mov    0x14(%ebp),%edx
f0102ae9:	01 c2                	add    %eax,%edx
f0102aeb:	8b 45 18             	mov    0x18(%ebp),%eax
f0102aee:	09 d0                	or     %edx,%eax
f0102af0:	89 c2                	mov    %eax,%edx
f0102af2:	83 ca 01             	or     $0x1,%edx
f0102af5:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0102af8:	89 10                	mov    %edx,(%eax)
{
	// Fill this function in
	uint32_t i;
	pte_t *pte;
	size = ROUNDUP(size, PGSIZE);
	for(i=0;i<size; i += PGSIZE){
f0102afa:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f0102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102b04:	3b 45 10             	cmp    0x10(%ebp),%eax
f0102b07:	72 88                	jb     f0102a91 <boot_map_segment+0x3d>
		if(pte == NULL){
			assert(pte!=NULL);
		}
		*pte = (pa+i)| perm | PTE_P;
	}
}
f0102b09:	c9                   	leave  
f0102b0a:	c3                   	ret    

f0102b0b <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct Page *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f0102b0b:	55                   	push   %ebp
f0102b0c:	89 e5                	mov    %esp,%ebp
f0102b0e:	83 ec 28             	sub    $0x28,%esp
	// Fill this function in
	pte_t *pte;
	pte = pgdir_walk(pgdir, va, 0);
f0102b11:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102b18:	00 
f0102b19:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102b20:	8b 45 08             	mov    0x8(%ebp),%eax
f0102b23:	89 04 24             	mov    %eax,(%esp)
f0102b26:	e8 2d fd ff ff       	call   f0102858 <pgdir_walk>
f0102b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(pte == NULL||(*pte & PTE_P) == 0){
f0102b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0102b32:	74 0c                	je     f0102b40 <page_lookup+0x35>
f0102b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102b37:	8b 00                	mov    (%eax),%eax
f0102b39:	83 e0 01             	and    $0x1,%eax
f0102b3c:	85 c0                	test   %eax,%eax
f0102b3e:	75 07                	jne    f0102b47 <page_lookup+0x3c>
		return NULL;
f0102b40:	b8 00 00 00 00       	mov    $0x0,%eax
f0102b45:	eb 1b                	jmp    f0102b62 <page_lookup+0x57>
	}
	if(pte_store != NULL){
f0102b47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0102b4b:	74 08                	je     f0102b55 <page_lookup+0x4a>
		*pte_store = pte;
f0102b4d:	8b 45 10             	mov    0x10(%ebp),%eax
f0102b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0102b53:	89 10                	mov    %edx,(%eax)
	}
	return pa2page(*pte);
f0102b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102b58:	8b 00                	mov    (%eax),%eax
f0102b5a:	89 04 24             	mov    %eax,(%esp)
f0102b5d:	e8 2c ea ff ff       	call   f010158e <pa2page>
}
f0102b62:	c9                   	leave  
f0102b63:	c3                   	ret    

f0102b64 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0102b64:	55                   	push   %ebp
f0102b65:	89 e5                	mov    %esp,%ebp
f0102b67:	83 ec 28             	sub    $0x28,%esp
	// Fill this function in
	struct Page *pg;
	pte_t *pte;
	pg = page_lookup(pgdir, va, &pte);
f0102b6a:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0102b6d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102b71:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102b74:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102b78:	8b 45 08             	mov    0x8(%ebp),%eax
f0102b7b:	89 04 24             	mov    %eax,(%esp)
f0102b7e:	e8 88 ff ff ff       	call   f0102b0b <page_lookup>
f0102b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(pg ==NULL){
f0102b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0102b8a:	74 2f                	je     f0102bbb <page_remove+0x57>
		return;
	}
	else{
		page_decref(pg);
f0102b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102b8f:	89 04 24             	mov    %eax,(%esp)
f0102b92:	e8 91 fc ff ff       	call   f0102828 <page_decref>
	}
	if(pte != NULL){
f0102b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102b9a:	85 c0                	test   %eax,%eax
f0102b9c:	74 09                	je     f0102ba7 <page_remove+0x43>
		*pte = 0;
f0102b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102ba1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	tlb_invalidate(pgdir, va);
f0102ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102baa:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102bae:	8b 45 08             	mov    0x8(%ebp),%eax
f0102bb1:	89 04 24             	mov    %eax,(%esp)
f0102bb4:	e8 05 00 00 00       	call   f0102bbe <tlb_invalidate>
f0102bb9:	eb 01                	jmp    f0102bbc <page_remove+0x58>
	// Fill this function in
	struct Page *pg;
	pte_t *pte;
	pg = page_lookup(pgdir, va, &pte);
	if(pg ==NULL){
		return;
f0102bbb:	90                   	nop
	}
	if(pte != NULL){
		*pte = 0;
	}
	tlb_invalidate(pgdir, va);
}
f0102bbc:	c9                   	leave  
f0102bbd:	c3                   	ret    

f0102bbe <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0102bbe:	55                   	push   %ebp
f0102bbf:	89 e5                	mov    %esp,%ebp
f0102bc1:	83 ec 10             	sub    $0x10,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0102bc4:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0102bc9:	85 c0                	test   %eax,%eax
f0102bcb:	74 0d                	je     f0102bda <tlb_invalidate+0x1c>
f0102bcd:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0102bd2:	8b 40 5c             	mov    0x5c(%eax),%eax
f0102bd5:	3b 45 08             	cmp    0x8(%ebp),%eax
f0102bd8:	75 0c                	jne    f0102be6 <tlb_invalidate+0x28>
f0102bda:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102bdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
}

static __inline void 
invlpg(void *addr)
{ 
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0102be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0102be3:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f0102be6:	c9                   	leave  
f0102be7:	c3                   	ret    

f0102be8 <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f0102be8:	55                   	push   %ebp
f0102be9:	89 e5                	mov    %esp,%ebp
f0102beb:	83 ec 38             	sub    $0x38,%esp
	// LAB 3: Your code here. 
    uintptr_t lva = (uintptr_t) va;
f0102bee:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uintptr_t hva = (uintptr_t) va + len - 1;
f0102bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102bf7:	03 45 10             	add    0x10(%ebp),%eax
f0102bfa:	83 e8 01             	sub    $0x1,%eax
f0102bfd:	89 45 ec             	mov    %eax,-0x14(%ebp)

    perm = perm|PTE_U|PTE_P;
f0102c00:	83 4d 14 05          	orl    $0x5,0x14(%ebp)

    pte_t *pte;
    uintptr_t idx_va;
    for(idx_va=lva; idx_va<=hva; idx_va+=PGSIZE){
f0102c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0102c0a:	eb 76                	jmp    f0102c82 <user_mem_check+0x9a>
        if(idx_va>=ULIM){//beyond the limit
f0102c0c:	81 7d f4 ff ff 7f ef 	cmpl   $0xef7fffff,-0xc(%ebp)
f0102c13:	76 0f                	jbe    f0102c24 <user_mem_check+0x3c>
            user_mem_check_addr = idx_va;
f0102c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102c18:	a3 20 88 1a f0       	mov    %eax,0xf01a8820
            return -E_FAULT;
f0102c1d:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0102c22:	eb 6b                	jmp    f0102c8f <user_mem_check+0xa7>
        }

        pte = pgdir_walk(env->env_pgdir, (void *)idx_va, 0);
f0102c24:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0102c27:	8b 45 08             	mov    0x8(%ebp),%eax
f0102c2a:	8b 40 5c             	mov    0x5c(%eax),%eax
f0102c2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102c34:	00 
f0102c35:	89 54 24 04          	mov    %edx,0x4(%esp)
f0102c39:	89 04 24             	mov    %eax,(%esp)
f0102c3c:	e8 17 fc ff ff       	call   f0102858 <pgdir_walk>
f0102c41:	89 45 e8             	mov    %eax,-0x18(%ebp)

        if(pte==NULL||(*pte & perm)!=perm){//power
f0102c44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0102c48:	74 11                	je     f0102c5b <user_mem_check+0x73>
f0102c4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0102c4d:	8b 10                	mov    (%eax),%edx
f0102c4f:	8b 45 14             	mov    0x14(%ebp),%eax
f0102c52:	21 c2                	and    %eax,%edx
f0102c54:	8b 45 14             	mov    0x14(%ebp),%eax
f0102c57:	39 c2                	cmp    %eax,%edx
f0102c59:	74 0f                	je     f0102c6a <user_mem_check+0x82>
            user_mem_check_addr = idx_va;
f0102c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102c5e:	a3 20 88 1a f0       	mov    %eax,0xf01a8820
            return -E_FAULT;
f0102c63:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0102c68:	eb 25                	jmp    f0102c8f <user_mem_check+0xa7>
        }
        idx_va = ROUNDDOWN(idx_va, PGSIZE);
f0102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102c6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102c73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102c78:	89 45 f4             	mov    %eax,-0xc(%ebp)

    perm = perm|PTE_U|PTE_P;

    pte_t *pte;
    uintptr_t idx_va;
    for(idx_va=lva; idx_va<=hva; idx_va+=PGSIZE){
f0102c7b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f0102c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102c85:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f0102c88:	76 82                	jbe    f0102c0c <user_mem_check+0x24>
            return -E_FAULT;
        }
        idx_va = ROUNDDOWN(idx_va, PGSIZE);
    }

	return 0;
f0102c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0102c8f:	c9                   	leave  
f0102c90:	c3                   	ret    

f0102c91 <user_mem_assert>:
// If it can, then the function simply returns.
// If it cannot, 'env' is destroyed.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0102c91:	55                   	push   %ebp
f0102c92:	89 e5                	mov    %esp,%ebp
f0102c94:	83 ec 18             	sub    $0x18,%esp
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0102c97:	8b 45 14             	mov    0x14(%ebp),%eax
f0102c9a:	83 c8 04             	or     $0x4,%eax
f0102c9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102ca1:	8b 45 10             	mov    0x10(%ebp),%eax
f0102ca4:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102cab:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102caf:	8b 45 08             	mov    0x8(%ebp),%eax
f0102cb2:	89 04 24             	mov    %eax,(%esp)
f0102cb5:	e8 2e ff ff ff       	call   f0102be8 <user_mem_check>
f0102cba:	85 c0                	test   %eax,%eax
f0102cbc:	79 2d                	jns    f0102ceb <user_mem_assert+0x5a>
		cprintf("[%08x] user_mem_check assertion failure for "
f0102cbe:	8b 15 20 88 1a f0    	mov    0xf01a8820,%edx
			"va %08x\n", curenv->env_id, user_mem_check_addr);
f0102cc4:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
		cprintf("[%08x] user_mem_check assertion failure for "
f0102cc9:	8b 40 4c             	mov    0x4c(%eax),%eax
f0102ccc:	89 54 24 08          	mov    %edx,0x8(%esp)
f0102cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102cd4:	c7 04 24 30 82 10 f0 	movl   $0xf0108230,(%esp)
f0102cdb:	e8 ae 19 00 00       	call   f010468e <cprintf>
			"va %08x\n", curenv->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0102ce0:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ce3:	89 04 24             	mov    %eax,(%esp)
f0102ce6:	e8 d4 15 00 00       	call   f01042bf <env_destroy>
	}
}
f0102ceb:	c9                   	leave  
f0102cec:	c3                   	ret    

f0102ced <page_check>:

// check page_insert, page_remove, &c
static void
page_check(void)
{
f0102ced:	55                   	push   %ebp
f0102cee:	89 e5                	mov    %esp,%ebp
f0102cf0:	53                   	push   %ebx
f0102cf1:	83 ec 54             	sub    $0x54,%esp
	pte_t *ptep, *ptep1;
	void *va;
	int i;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0102cf4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
f0102cfb:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102cfe:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102d01:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102d04:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	assert(page_alloc(&pp0) == 0);
f0102d07:	8d 45 d4             	lea    -0x2c(%ebp),%eax
f0102d0a:	89 04 24             	mov    %eax,(%esp)
f0102d0d:	e8 6f fa ff ff       	call   f0102781 <page_alloc>
f0102d12:	85 c0                	test   %eax,%eax
f0102d14:	74 24                	je     f0102d3a <page_check+0x4d>
f0102d16:	c7 44 24 0c f5 7f 10 	movl   $0xf0107ff5,0xc(%esp)
f0102d1d:	f0 
f0102d1e:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102d25:	f0 
f0102d26:	c7 44 24 04 17 03 00 	movl   $0x317,0x4(%esp)
f0102d2d:	00 
f0102d2e:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102d35:	e8 64 d4 ff ff       	call   f010019e <_panic>
	assert(page_alloc(&pp1) == 0);
f0102d3a:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0102d3d:	89 04 24             	mov    %eax,(%esp)
f0102d40:	e8 3c fa ff ff       	call   f0102781 <page_alloc>
f0102d45:	85 c0                	test   %eax,%eax
f0102d47:	74 24                	je     f0102d6d <page_check+0x80>
f0102d49:	c7 44 24 0c 20 80 10 	movl   $0xf0108020,0xc(%esp)
f0102d50:	f0 
f0102d51:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102d58:	f0 
f0102d59:	c7 44 24 04 18 03 00 	movl   $0x318,0x4(%esp)
f0102d60:	00 
f0102d61:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102d68:	e8 31 d4 ff ff       	call   f010019e <_panic>
	assert(page_alloc(&pp2) == 0);
f0102d6d:	8d 45 cc             	lea    -0x34(%ebp),%eax
f0102d70:	89 04 24             	mov    %eax,(%esp)
f0102d73:	e8 09 fa ff ff       	call   f0102781 <page_alloc>
f0102d78:	85 c0                	test   %eax,%eax
f0102d7a:	74 24                	je     f0102da0 <page_check+0xb3>
f0102d7c:	c7 44 24 0c 36 80 10 	movl   $0xf0108036,0xc(%esp)
f0102d83:	f0 
f0102d84:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102d8b:	f0 
f0102d8c:	c7 44 24 04 19 03 00 	movl   $0x319,0x4(%esp)
f0102d93:	00 
f0102d94:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102d9b:	e8 fe d3 ff ff       	call   f010019e <_panic>

	assert(pp0);
f0102da0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102da3:	85 c0                	test   %eax,%eax
f0102da5:	75 24                	jne    f0102dcb <page_check+0xde>
f0102da7:	c7 44 24 0c 4c 80 10 	movl   $0xf010804c,0xc(%esp)
f0102dae:	f0 
f0102daf:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102db6:	f0 
f0102db7:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
f0102dbe:	00 
f0102dbf:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102dc6:	e8 d3 d3 ff ff       	call   f010019e <_panic>
	assert(pp1 && pp1 != pp0);
f0102dcb:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102dce:	85 c0                	test   %eax,%eax
f0102dd0:	74 0a                	je     f0102ddc <page_check+0xef>
f0102dd2:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0102dd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102dd8:	39 c2                	cmp    %eax,%edx
f0102dda:	75 24                	jne    f0102e00 <page_check+0x113>
f0102ddc:	c7 44 24 0c 50 80 10 	movl   $0xf0108050,0xc(%esp)
f0102de3:	f0 
f0102de4:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102deb:	f0 
f0102dec:	c7 44 24 04 1c 03 00 	movl   $0x31c,0x4(%esp)
f0102df3:	00 
f0102df4:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102dfb:	e8 9e d3 ff ff       	call   f010019e <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102e00:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102e03:	85 c0                	test   %eax,%eax
f0102e05:	74 14                	je     f0102e1b <page_check+0x12e>
f0102e07:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0102e0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102e0d:	39 c2                	cmp    %eax,%edx
f0102e0f:	74 0a                	je     f0102e1b <page_check+0x12e>
f0102e11:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0102e14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e17:	39 c2                	cmp    %eax,%edx
f0102e19:	75 24                	jne    f0102e3f <page_check+0x152>
f0102e1b:	c7 44 24 0c 64 80 10 	movl   $0xf0108064,0xc(%esp)
f0102e22:	f0 
f0102e23:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102e2a:	f0 
f0102e2b:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
f0102e32:	00 
f0102e33:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102e3a:	e8 5f d3 ff ff       	call   f010019e <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102e3f:	a1 1c 88 1a f0       	mov    0xf01a881c,%eax
f0102e44:	89 45 c8             	mov    %eax,-0x38(%ebp)
	LIST_INIT(&page_free_list);
f0102e47:	c7 05 1c 88 1a f0 00 	movl   $0x0,0xf01a881c
f0102e4e:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0102e51:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0102e54:	89 04 24             	mov    %eax,(%esp)
f0102e57:	e8 25 f9 ff ff       	call   f0102781 <page_alloc>
f0102e5c:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0102e5f:	74 24                	je     f0102e85 <page_check+0x198>
f0102e61:	c7 44 24 0c d8 80 10 	movl   $0xf01080d8,0xc(%esp)
f0102e68:	f0 
f0102e69:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102e70:	f0 
f0102e71:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
f0102e78:	00 
f0102e79:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102e80:	e8 19 d3 ff ff       	call   f010019e <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(boot_pgdir, (void *) 0x0, &ptep) == NULL);
f0102e85:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0102e8a:	8d 55 c4             	lea    -0x3c(%ebp),%edx
f0102e8d:	89 54 24 08          	mov    %edx,0x8(%esp)
f0102e91:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102e98:	00 
f0102e99:	89 04 24             	mov    %eax,(%esp)
f0102e9c:	e8 6a fc ff ff       	call   f0102b0b <page_lookup>
f0102ea1:	85 c0                	test   %eax,%eax
f0102ea3:	74 24                	je     f0102ec9 <page_check+0x1dc>
f0102ea5:	c7 44 24 0c 68 82 10 	movl   $0xf0108268,0xc(%esp)
f0102eac:	f0 
f0102ead:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102eb4:	f0 
f0102eb5:	c7 44 24 04 27 03 00 	movl   $0x327,0x4(%esp)
f0102ebc:	00 
f0102ebd:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102ec4:	e8 d5 d2 ff ff       	call   f010019e <_panic>

	// there is no free memory, so we can't allocate a page table 
	assert(page_insert(boot_pgdir, pp1, 0x0, 0) < 0);
f0102ec9:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0102ecc:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0102ed1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102ed8:	00 
f0102ed9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102ee0:	00 
f0102ee1:	89 54 24 04          	mov    %edx,0x4(%esp)
f0102ee5:	89 04 24             	mov    %eax,(%esp)
f0102ee8:	e8 e7 fa ff ff       	call   f01029d4 <page_insert>
f0102eed:	85 c0                	test   %eax,%eax
f0102eef:	78 24                	js     f0102f15 <page_check+0x228>
f0102ef1:	c7 44 24 0c a0 82 10 	movl   $0xf01082a0,0xc(%esp)
f0102ef8:	f0 
f0102ef9:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102f00:	f0 
f0102f01:	c7 44 24 04 2a 03 00 	movl   $0x32a,0x4(%esp)
f0102f08:	00 
f0102f09:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102f10:	e8 89 d2 ff ff       	call   f010019e <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0102f15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f18:	89 04 24             	mov    %eax,(%esp)
f0102f1b:	e8 b4 f8 ff ff       	call   f01027d4 <page_free>
	assert(page_insert(boot_pgdir, pp1, 0x0, 0) == 0);
f0102f20:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0102f23:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0102f28:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102f2f:	00 
f0102f30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102f37:	00 
f0102f38:	89 54 24 04          	mov    %edx,0x4(%esp)
f0102f3c:	89 04 24             	mov    %eax,(%esp)
f0102f3f:	e8 90 fa ff ff       	call   f01029d4 <page_insert>
f0102f44:	85 c0                	test   %eax,%eax
f0102f46:	74 24                	je     f0102f6c <page_check+0x27f>
f0102f48:	c7 44 24 0c cc 82 10 	movl   $0xf01082cc,0xc(%esp)
f0102f4f:	f0 
f0102f50:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102f57:	f0 
f0102f58:	c7 44 24 04 2e 03 00 	movl   $0x32e,0x4(%esp)
f0102f5f:	00 
f0102f60:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102f67:	e8 32 d2 ff ff       	call   f010019e <_panic>
	assert(PTE_ADDR(boot_pgdir[0]) == page2pa(pp0));
f0102f6c:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0102f71:	8b 00                	mov    (%eax),%eax
f0102f73:	89 c3                	mov    %eax,%ebx
f0102f75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0102f7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f7e:	89 04 24             	mov    %eax,(%esp)
f0102f81:	e8 f2 e5 ff ff       	call   f0101578 <page2pa>
f0102f86:	39 c3                	cmp    %eax,%ebx
f0102f88:	74 24                	je     f0102fae <page_check+0x2c1>
f0102f8a:	c7 44 24 0c f8 82 10 	movl   $0xf01082f8,0xc(%esp)
f0102f91:	f0 
f0102f92:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102f99:	f0 
f0102f9a:	c7 44 24 04 2f 03 00 	movl   $0x32f,0x4(%esp)
f0102fa1:	00 
f0102fa2:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102fa9:	e8 f0 d1 ff ff       	call   f010019e <_panic>
	assert(check_va2pa(boot_pgdir, 0x0) == page2pa(pp1));
f0102fae:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0102fb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102fba:	00 
f0102fbb:	89 04 24             	mov    %eax,(%esp)
f0102fbe:	e8 8b f3 ff ff       	call   f010234e <check_va2pa>
f0102fc3:	89 c3                	mov    %eax,%ebx
f0102fc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102fc8:	89 04 24             	mov    %eax,(%esp)
f0102fcb:	e8 a8 e5 ff ff       	call   f0101578 <page2pa>
f0102fd0:	39 c3                	cmp    %eax,%ebx
f0102fd2:	74 24                	je     f0102ff8 <page_check+0x30b>
f0102fd4:	c7 44 24 0c 20 83 10 	movl   $0xf0108320,0xc(%esp)
f0102fdb:	f0 
f0102fdc:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0102fe3:	f0 
f0102fe4:	c7 44 24 04 30 03 00 	movl   $0x330,0x4(%esp)
f0102feb:	00 
f0102fec:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0102ff3:	e8 a6 d1 ff ff       	call   f010019e <_panic>
	assert(pp1->pp_ref == 1);
f0102ff8:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102ffb:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f0102fff:	66 83 f8 01          	cmp    $0x1,%ax
f0103003:	74 24                	je     f0103029 <page_check+0x33c>
f0103005:	c7 44 24 0c 4d 83 10 	movl   $0xf010834d,0xc(%esp)
f010300c:	f0 
f010300d:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103014:	f0 
f0103015:	c7 44 24 04 31 03 00 	movl   $0x331,0x4(%esp)
f010301c:	00 
f010301d:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103024:	e8 75 d1 ff ff       	call   f010019e <_panic>
	assert(pp0->pp_ref == 1);
f0103029:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010302c:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f0103030:	66 83 f8 01          	cmp    $0x1,%ax
f0103034:	74 24                	je     f010305a <page_check+0x36d>
f0103036:	c7 44 24 0c 5e 83 10 	movl   $0xf010835e,0xc(%esp)
f010303d:	f0 
f010303e:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103045:	f0 
f0103046:	c7 44 24 04 32 03 00 	movl   $0x332,0x4(%esp)
f010304d:	00 
f010304e:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103055:	e8 44 d1 ff ff       	call   f010019e <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, 0) == 0);
f010305a:	8b 55 cc             	mov    -0x34(%ebp),%edx
f010305d:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0103062:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0103069:	00 
f010306a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103071:	00 
f0103072:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103076:	89 04 24             	mov    %eax,(%esp)
f0103079:	e8 56 f9 ff ff       	call   f01029d4 <page_insert>
f010307e:	85 c0                	test   %eax,%eax
f0103080:	74 24                	je     f01030a6 <page_check+0x3b9>
f0103082:	c7 44 24 0c 70 83 10 	movl   $0xf0108370,0xc(%esp)
f0103089:	f0 
f010308a:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103091:	f0 
f0103092:	c7 44 24 04 35 03 00 	movl   $0x335,0x4(%esp)
f0103099:	00 
f010309a:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01030a1:	e8 f8 d0 ff ff       	call   f010019e <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f01030a6:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01030ab:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01030b2:	00 
f01030b3:	89 04 24             	mov    %eax,(%esp)
f01030b6:	e8 93 f2 ff ff       	call   f010234e <check_va2pa>
f01030bb:	89 c3                	mov    %eax,%ebx
f01030bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01030c0:	89 04 24             	mov    %eax,(%esp)
f01030c3:	e8 b0 e4 ff ff       	call   f0101578 <page2pa>
f01030c8:	39 c3                	cmp    %eax,%ebx
f01030ca:	74 24                	je     f01030f0 <page_check+0x403>
f01030cc:	c7 44 24 0c a8 83 10 	movl   $0xf01083a8,0xc(%esp)
f01030d3:	f0 
f01030d4:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01030db:	f0 
f01030dc:	c7 44 24 04 36 03 00 	movl   $0x336,0x4(%esp)
f01030e3:	00 
f01030e4:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01030eb:	e8 ae d0 ff ff       	call   f010019e <_panic>
	assert(pp2->pp_ref == 1);
f01030f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01030f3:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f01030f7:	66 83 f8 01          	cmp    $0x1,%ax
f01030fb:	74 24                	je     f0103121 <page_check+0x434>
f01030fd:	c7 44 24 0c d8 83 10 	movl   $0xf01083d8,0xc(%esp)
f0103104:	f0 
f0103105:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010310c:	f0 
f010310d:	c7 44 24 04 37 03 00 	movl   $0x337,0x4(%esp)
f0103114:	00 
f0103115:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010311c:	e8 7d d0 ff ff       	call   f010019e <_panic>

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0103121:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0103124:	89 04 24             	mov    %eax,(%esp)
f0103127:	e8 55 f6 ff ff       	call   f0102781 <page_alloc>
f010312c:	83 f8 fc             	cmp    $0xfffffffc,%eax
f010312f:	74 24                	je     f0103155 <page_check+0x468>
f0103131:	c7 44 24 0c d8 80 10 	movl   $0xf01080d8,0xc(%esp)
f0103138:	f0 
f0103139:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103140:	f0 
f0103141:	c7 44 24 04 3a 03 00 	movl   $0x33a,0x4(%esp)
f0103148:	00 
f0103149:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103150:	e8 49 d0 ff ff       	call   f010019e <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, 0) == 0);
f0103155:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0103158:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f010315d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0103164:	00 
f0103165:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010316c:	00 
f010316d:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103171:	89 04 24             	mov    %eax,(%esp)
f0103174:	e8 5b f8 ff ff       	call   f01029d4 <page_insert>
f0103179:	85 c0                	test   %eax,%eax
f010317b:	74 24                	je     f01031a1 <page_check+0x4b4>
f010317d:	c7 44 24 0c 70 83 10 	movl   $0xf0108370,0xc(%esp)
f0103184:	f0 
f0103185:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010318c:	f0 
f010318d:	c7 44 24 04 3d 03 00 	movl   $0x33d,0x4(%esp)
f0103194:	00 
f0103195:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010319c:	e8 fd cf ff ff       	call   f010019e <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f01031a1:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01031a6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01031ad:	00 
f01031ae:	89 04 24             	mov    %eax,(%esp)
f01031b1:	e8 98 f1 ff ff       	call   f010234e <check_va2pa>
f01031b6:	89 c3                	mov    %eax,%ebx
f01031b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01031bb:	89 04 24             	mov    %eax,(%esp)
f01031be:	e8 b5 e3 ff ff       	call   f0101578 <page2pa>
f01031c3:	39 c3                	cmp    %eax,%ebx
f01031c5:	74 24                	je     f01031eb <page_check+0x4fe>
f01031c7:	c7 44 24 0c a8 83 10 	movl   $0xf01083a8,0xc(%esp)
f01031ce:	f0 
f01031cf:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01031d6:	f0 
f01031d7:	c7 44 24 04 3e 03 00 	movl   $0x33e,0x4(%esp)
f01031de:	00 
f01031df:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01031e6:	e8 b3 cf ff ff       	call   f010019e <_panic>
	assert(pp2->pp_ref == 1);
f01031eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01031ee:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f01031f2:	66 83 f8 01          	cmp    $0x1,%ax
f01031f6:	74 24                	je     f010321c <page_check+0x52f>
f01031f8:	c7 44 24 0c d8 83 10 	movl   $0xf01083d8,0xc(%esp)
f01031ff:	f0 
f0103200:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103207:	f0 
f0103208:	c7 44 24 04 3f 03 00 	movl   $0x33f,0x4(%esp)
f010320f:	00 
f0103210:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103217:	e8 82 cf ff ff       	call   f010019e <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(page_alloc(&pp) == -E_NO_MEM);
f010321c:	8d 45 d8             	lea    -0x28(%ebp),%eax
f010321f:	89 04 24             	mov    %eax,(%esp)
f0103222:	e8 5a f5 ff ff       	call   f0102781 <page_alloc>
f0103227:	83 f8 fc             	cmp    $0xfffffffc,%eax
f010322a:	74 24                	je     f0103250 <page_check+0x563>
f010322c:	c7 44 24 0c d8 80 10 	movl   $0xf01080d8,0xc(%esp)
f0103233:	f0 
f0103234:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010323b:	f0 
f010323c:	c7 44 24 04 43 03 00 	movl   $0x343,0x4(%esp)
f0103243:	00 
f0103244:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010324b:	e8 4e cf ff ff       	call   f010019e <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = KADDR(PTE_ADDR(boot_pgdir[PDX(PGSIZE)]));
f0103250:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0103255:	8b 00                	mov    (%eax),%eax
f0103257:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010325c:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010325f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103262:	c1 e8 0c             	shr    $0xc,%eax
f0103265:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0103268:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f010326d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
f0103270:	72 23                	jb     f0103295 <page_check+0x5a8>
f0103272:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103275:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103279:	c7 44 24 08 0c 7f 10 	movl   $0xf0107f0c,0x8(%esp)
f0103280:	f0 
f0103281:	c7 44 24 04 46 03 00 	movl   $0x346,0x4(%esp)
f0103288:	00 
f0103289:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103290:	e8 09 cf ff ff       	call   f010019e <_panic>
f0103295:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103298:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010329d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	assert(pgdir_walk(boot_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01032a0:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01032a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01032ac:	00 
f01032ad:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01032b4:	00 
f01032b5:	89 04 24             	mov    %eax,(%esp)
f01032b8:	e8 9b f5 ff ff       	call   f0102858 <pgdir_walk>
f01032bd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01032c0:	83 c2 04             	add    $0x4,%edx
f01032c3:	39 d0                	cmp    %edx,%eax
f01032c5:	74 24                	je     f01032eb <page_check+0x5fe>
f01032c7:	c7 44 24 0c ec 83 10 	movl   $0xf01083ec,0xc(%esp)
f01032ce:	f0 
f01032cf:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01032d6:	f0 
f01032d7:	c7 44 24 04 47 03 00 	movl   $0x347,0x4(%esp)
f01032de:	00 
f01032df:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01032e6:	e8 b3 ce ff ff       	call   f010019e <_panic>

	// should be able to change permissions too.
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, PTE_U) == 0);
f01032eb:	8b 55 cc             	mov    -0x34(%ebp),%edx
f01032ee:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01032f3:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f01032fa:	00 
f01032fb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103302:	00 
f0103303:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103307:	89 04 24             	mov    %eax,(%esp)
f010330a:	e8 c5 f6 ff ff       	call   f01029d4 <page_insert>
f010330f:	85 c0                	test   %eax,%eax
f0103311:	74 24                	je     f0103337 <page_check+0x64a>
f0103313:	c7 44 24 0c 2c 84 10 	movl   $0xf010842c,0xc(%esp)
f010331a:	f0 
f010331b:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103322:	f0 
f0103323:	c7 44 24 04 4a 03 00 	movl   $0x34a,0x4(%esp)
f010332a:	00 
f010332b:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103332:	e8 67 ce ff ff       	call   f010019e <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f0103337:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f010333c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0103343:	00 
f0103344:	89 04 24             	mov    %eax,(%esp)
f0103347:	e8 02 f0 ff ff       	call   f010234e <check_va2pa>
f010334c:	89 c3                	mov    %eax,%ebx
f010334e:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103351:	89 04 24             	mov    %eax,(%esp)
f0103354:	e8 1f e2 ff ff       	call   f0101578 <page2pa>
f0103359:	39 c3                	cmp    %eax,%ebx
f010335b:	74 24                	je     f0103381 <page_check+0x694>
f010335d:	c7 44 24 0c a8 83 10 	movl   $0xf01083a8,0xc(%esp)
f0103364:	f0 
f0103365:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010336c:	f0 
f010336d:	c7 44 24 04 4b 03 00 	movl   $0x34b,0x4(%esp)
f0103374:	00 
f0103375:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010337c:	e8 1d ce ff ff       	call   f010019e <_panic>
	assert(pp2->pp_ref == 1);
f0103381:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103384:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f0103388:	66 83 f8 01          	cmp    $0x1,%ax
f010338c:	74 24                	je     f01033b2 <page_check+0x6c5>
f010338e:	c7 44 24 0c d8 83 10 	movl   $0xf01083d8,0xc(%esp)
f0103395:	f0 
f0103396:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010339d:	f0 
f010339e:	c7 44 24 04 4c 03 00 	movl   $0x34c,0x4(%esp)
f01033a5:	00 
f01033a6:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01033ad:	e8 ec cd ff ff       	call   f010019e <_panic>
	assert(*pgdir_walk(boot_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01033b2:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01033b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01033be:	00 
f01033bf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01033c6:	00 
f01033c7:	89 04 24             	mov    %eax,(%esp)
f01033ca:	e8 89 f4 ff ff       	call   f0102858 <pgdir_walk>
f01033cf:	8b 00                	mov    (%eax),%eax
f01033d1:	83 e0 04             	and    $0x4,%eax
f01033d4:	85 c0                	test   %eax,%eax
f01033d6:	75 24                	jne    f01033fc <page_check+0x70f>
f01033d8:	c7 44 24 0c 68 84 10 	movl   $0xf0108468,0xc(%esp)
f01033df:	f0 
f01033e0:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01033e7:	f0 
f01033e8:	c7 44 24 04 4d 03 00 	movl   $0x34d,0x4(%esp)
f01033ef:	00 
f01033f0:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01033f7:	e8 a2 cd ff ff       	call   f010019e <_panic>
	
	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(boot_pgdir, pp0, (void*) PTSIZE, 0) < 0);
f01033fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01033ff:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0103404:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010340b:	00 
f010340c:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f0103413:	00 
f0103414:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103418:	89 04 24             	mov    %eax,(%esp)
f010341b:	e8 b4 f5 ff ff       	call   f01029d4 <page_insert>
f0103420:	85 c0                	test   %eax,%eax
f0103422:	78 24                	js     f0103448 <page_check+0x75b>
f0103424:	c7 44 24 0c 9c 84 10 	movl   $0xf010849c,0xc(%esp)
f010342b:	f0 
f010342c:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103433:	f0 
f0103434:	c7 44 24 04 50 03 00 	movl   $0x350,0x4(%esp)
f010343b:	00 
f010343c:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103443:	e8 56 cd ff ff       	call   f010019e <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(boot_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0103448:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010344b:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0103450:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0103457:	00 
f0103458:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010345f:	00 
f0103460:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103464:	89 04 24             	mov    %eax,(%esp)
f0103467:	e8 68 f5 ff ff       	call   f01029d4 <page_insert>
f010346c:	85 c0                	test   %eax,%eax
f010346e:	74 24                	je     f0103494 <page_check+0x7a7>
f0103470:	c7 44 24 0c d0 84 10 	movl   $0xf01084d0,0xc(%esp)
f0103477:	f0 
f0103478:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010347f:	f0 
f0103480:	c7 44 24 04 53 03 00 	movl   $0x353,0x4(%esp)
f0103487:	00 
f0103488:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010348f:	e8 0a cd ff ff       	call   f010019e <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(boot_pgdir, 0) == page2pa(pp1));
f0103494:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0103499:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01034a0:	00 
f01034a1:	89 04 24             	mov    %eax,(%esp)
f01034a4:	e8 a5 ee ff ff       	call   f010234e <check_va2pa>
f01034a9:	89 c3                	mov    %eax,%ebx
f01034ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01034ae:	89 04 24             	mov    %eax,(%esp)
f01034b1:	e8 c2 e0 ff ff       	call   f0101578 <page2pa>
f01034b6:	39 c3                	cmp    %eax,%ebx
f01034b8:	74 24                	je     f01034de <page_check+0x7f1>
f01034ba:	c7 44 24 0c 08 85 10 	movl   $0xf0108508,0xc(%esp)
f01034c1:	f0 
f01034c2:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01034c9:	f0 
f01034ca:	c7 44 24 04 56 03 00 	movl   $0x356,0x4(%esp)
f01034d1:	00 
f01034d2:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01034d9:	e8 c0 cc ff ff       	call   f010019e <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp1));
f01034de:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01034e3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01034ea:	00 
f01034eb:	89 04 24             	mov    %eax,(%esp)
f01034ee:	e8 5b ee ff ff       	call   f010234e <check_va2pa>
f01034f3:	89 c3                	mov    %eax,%ebx
f01034f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01034f8:	89 04 24             	mov    %eax,(%esp)
f01034fb:	e8 78 e0 ff ff       	call   f0101578 <page2pa>
f0103500:	39 c3                	cmp    %eax,%ebx
f0103502:	74 24                	je     f0103528 <page_check+0x83b>
f0103504:	c7 44 24 0c 34 85 10 	movl   $0xf0108534,0xc(%esp)
f010350b:	f0 
f010350c:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103513:	f0 
f0103514:	c7 44 24 04 57 03 00 	movl   $0x357,0x4(%esp)
f010351b:	00 
f010351c:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103523:	e8 76 cc ff ff       	call   f010019e <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0103528:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010352b:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f010352f:	66 83 f8 02          	cmp    $0x2,%ax
f0103533:	74 24                	je     f0103559 <page_check+0x86c>
f0103535:	c7 44 24 0c 64 85 10 	movl   $0xf0108564,0xc(%esp)
f010353c:	f0 
f010353d:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103544:	f0 
f0103545:	c7 44 24 04 59 03 00 	movl   $0x359,0x4(%esp)
f010354c:	00 
f010354d:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103554:	e8 45 cc ff ff       	call   f010019e <_panic>
	assert(pp2->pp_ref == 0);
f0103559:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010355c:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f0103560:	66 85 c0             	test   %ax,%ax
f0103563:	74 24                	je     f0103589 <page_check+0x89c>
f0103565:	c7 44 24 0c 75 85 10 	movl   $0xf0108575,0xc(%esp)
f010356c:	f0 
f010356d:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103574:	f0 
f0103575:	c7 44 24 04 5a 03 00 	movl   $0x35a,0x4(%esp)
f010357c:	00 
f010357d:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103584:	e8 15 cc ff ff       	call   f010019e <_panic>

	// pp2 should be returned by page_alloc
	assert(page_alloc(&pp) == 0 && pp == pp2);
f0103589:	8d 45 d8             	lea    -0x28(%ebp),%eax
f010358c:	89 04 24             	mov    %eax,(%esp)
f010358f:	e8 ed f1 ff ff       	call   f0102781 <page_alloc>
f0103594:	85 c0                	test   %eax,%eax
f0103596:	75 0a                	jne    f01035a2 <page_check+0x8b5>
f0103598:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010359b:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010359e:	39 c2                	cmp    %eax,%edx
f01035a0:	74 24                	je     f01035c6 <page_check+0x8d9>
f01035a2:	c7 44 24 0c 88 85 10 	movl   $0xf0108588,0xc(%esp)
f01035a9:	f0 
f01035aa:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01035b1:	f0 
f01035b2:	c7 44 24 04 5d 03 00 	movl   $0x35d,0x4(%esp)
f01035b9:	00 
f01035ba:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01035c1:	e8 d8 cb ff ff       	call   f010019e <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(boot_pgdir, 0x0);
f01035c6:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01035cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01035d2:	00 
f01035d3:	89 04 24             	mov    %eax,(%esp)
f01035d6:	e8 89 f5 ff ff       	call   f0102b64 <page_remove>
	assert(check_va2pa(boot_pgdir, 0x0) == ~0);
f01035db:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01035e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01035e7:	00 
f01035e8:	89 04 24             	mov    %eax,(%esp)
f01035eb:	e8 5e ed ff ff       	call   f010234e <check_va2pa>
f01035f0:	83 f8 ff             	cmp    $0xffffffff,%eax
f01035f3:	74 24                	je     f0103619 <page_check+0x92c>
f01035f5:	c7 44 24 0c ac 85 10 	movl   $0xf01085ac,0xc(%esp)
f01035fc:	f0 
f01035fd:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103604:	f0 
f0103605:	c7 44 24 04 61 03 00 	movl   $0x361,0x4(%esp)
f010360c:	00 
f010360d:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103614:	e8 85 cb ff ff       	call   f010019e <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp1));
f0103619:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f010361e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0103625:	00 
f0103626:	89 04 24             	mov    %eax,(%esp)
f0103629:	e8 20 ed ff ff       	call   f010234e <check_va2pa>
f010362e:	89 c3                	mov    %eax,%ebx
f0103630:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103633:	89 04 24             	mov    %eax,(%esp)
f0103636:	e8 3d df ff ff       	call   f0101578 <page2pa>
f010363b:	39 c3                	cmp    %eax,%ebx
f010363d:	74 24                	je     f0103663 <page_check+0x976>
f010363f:	c7 44 24 0c 34 85 10 	movl   $0xf0108534,0xc(%esp)
f0103646:	f0 
f0103647:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010364e:	f0 
f010364f:	c7 44 24 04 62 03 00 	movl   $0x362,0x4(%esp)
f0103656:	00 
f0103657:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010365e:	e8 3b cb ff ff       	call   f010019e <_panic>
	assert(pp1->pp_ref == 1);
f0103663:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103666:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f010366a:	66 83 f8 01          	cmp    $0x1,%ax
f010366e:	74 24                	je     f0103694 <page_check+0x9a7>
f0103670:	c7 44 24 0c 4d 83 10 	movl   $0xf010834d,0xc(%esp)
f0103677:	f0 
f0103678:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010367f:	f0 
f0103680:	c7 44 24 04 63 03 00 	movl   $0x363,0x4(%esp)
f0103687:	00 
f0103688:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010368f:	e8 0a cb ff ff       	call   f010019e <_panic>
	assert(pp2->pp_ref == 0);
f0103694:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103697:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f010369b:	66 85 c0             	test   %ax,%ax
f010369e:	74 24                	je     f01036c4 <page_check+0x9d7>
f01036a0:	c7 44 24 0c 75 85 10 	movl   $0xf0108575,0xc(%esp)
f01036a7:	f0 
f01036a8:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01036af:	f0 
f01036b0:	c7 44 24 04 64 03 00 	movl   $0x364,0x4(%esp)
f01036b7:	00 
f01036b8:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01036bf:	e8 da ca ff ff       	call   f010019e <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(boot_pgdir, (void*) PGSIZE);
f01036c4:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01036c9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01036d0:	00 
f01036d1:	89 04 24             	mov    %eax,(%esp)
f01036d4:	e8 8b f4 ff ff       	call   f0102b64 <page_remove>
	assert(check_va2pa(boot_pgdir, 0x0) == ~0);
f01036d9:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01036de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01036e5:	00 
f01036e6:	89 04 24             	mov    %eax,(%esp)
f01036e9:	e8 60 ec ff ff       	call   f010234e <check_va2pa>
f01036ee:	83 f8 ff             	cmp    $0xffffffff,%eax
f01036f1:	74 24                	je     f0103717 <page_check+0xa2a>
f01036f3:	c7 44 24 0c ac 85 10 	movl   $0xf01085ac,0xc(%esp)
f01036fa:	f0 
f01036fb:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103702:	f0 
f0103703:	c7 44 24 04 68 03 00 	movl   $0x368,0x4(%esp)
f010370a:	00 
f010370b:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103712:	e8 87 ca ff ff       	call   f010019e <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == ~0);
f0103717:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f010371c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0103723:	00 
f0103724:	89 04 24             	mov    %eax,(%esp)
f0103727:	e8 22 ec ff ff       	call   f010234e <check_va2pa>
f010372c:	83 f8 ff             	cmp    $0xffffffff,%eax
f010372f:	74 24                	je     f0103755 <page_check+0xa68>
f0103731:	c7 44 24 0c d0 85 10 	movl   $0xf01085d0,0xc(%esp)
f0103738:	f0 
f0103739:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103740:	f0 
f0103741:	c7 44 24 04 69 03 00 	movl   $0x369,0x4(%esp)
f0103748:	00 
f0103749:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103750:	e8 49 ca ff ff       	call   f010019e <_panic>
	assert(pp1->pp_ref == 0);
f0103755:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103758:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f010375c:	66 85 c0             	test   %ax,%ax
f010375f:	74 24                	je     f0103785 <page_check+0xa98>
f0103761:	c7 44 24 0c f6 85 10 	movl   $0xf01085f6,0xc(%esp)
f0103768:	f0 
f0103769:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103770:	f0 
f0103771:	c7 44 24 04 6a 03 00 	movl   $0x36a,0x4(%esp)
f0103778:	00 
f0103779:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103780:	e8 19 ca ff ff       	call   f010019e <_panic>
	assert(pp2->pp_ref == 0);
f0103785:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103788:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f010378c:	66 85 c0             	test   %ax,%ax
f010378f:	74 24                	je     f01037b5 <page_check+0xac8>
f0103791:	c7 44 24 0c 75 85 10 	movl   $0xf0108575,0xc(%esp)
f0103798:	f0 
f0103799:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01037a0:	f0 
f01037a1:	c7 44 24 04 6b 03 00 	movl   $0x36b,0x4(%esp)
f01037a8:	00 
f01037a9:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01037b0:	e8 e9 c9 ff ff       	call   f010019e <_panic>

	// so it should be returned by page_alloc
	assert(page_alloc(&pp) == 0 && pp == pp1);
f01037b5:	8d 45 d8             	lea    -0x28(%ebp),%eax
f01037b8:	89 04 24             	mov    %eax,(%esp)
f01037bb:	e8 c1 ef ff ff       	call   f0102781 <page_alloc>
f01037c0:	85 c0                	test   %eax,%eax
f01037c2:	75 0a                	jne    f01037ce <page_check+0xae1>
f01037c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01037c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01037ca:	39 c2                	cmp    %eax,%edx
f01037cc:	74 24                	je     f01037f2 <page_check+0xb05>
f01037ce:	c7 44 24 0c 08 86 10 	movl   $0xf0108608,0xc(%esp)
f01037d5:	f0 
f01037d6:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f01037dd:	f0 
f01037de:	c7 44 24 04 6e 03 00 	movl   $0x36e,0x4(%esp)
f01037e5:	00 
f01037e6:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f01037ed:	e8 ac c9 ff ff       	call   f010019e <_panic>

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f01037f2:	8d 45 d8             	lea    -0x28(%ebp),%eax
f01037f5:	89 04 24             	mov    %eax,(%esp)
f01037f8:	e8 84 ef ff ff       	call   f0102781 <page_alloc>
f01037fd:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0103800:	74 24                	je     f0103826 <page_check+0xb39>
f0103802:	c7 44 24 0c d8 80 10 	movl   $0xf01080d8,0xc(%esp)
f0103809:	f0 
f010380a:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103811:	f0 
f0103812:	c7 44 24 04 71 03 00 	movl   $0x371,0x4(%esp)
f0103819:	00 
f010381a:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103821:	e8 78 c9 ff ff       	call   f010019e <_panic>
	page_remove(boot_pgdir, 0x0);
	assert(pp2->pp_ref == 0);
#endif

	// forcibly take pp0 back
	assert(PTE_ADDR(boot_pgdir[0]) == page2pa(pp0));
f0103826:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f010382b:	8b 00                	mov    (%eax),%eax
f010382d:	89 c3                	mov    %eax,%ebx
f010382f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0103835:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103838:	89 04 24             	mov    %eax,(%esp)
f010383b:	e8 38 dd ff ff       	call   f0101578 <page2pa>
f0103840:	39 c3                	cmp    %eax,%ebx
f0103842:	74 24                	je     f0103868 <page_check+0xb7b>
f0103844:	c7 44 24 0c f8 82 10 	movl   $0xf01082f8,0xc(%esp)
f010384b:	f0 
f010384c:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103853:	f0 
f0103854:	c7 44 24 04 84 03 00 	movl   $0x384,0x4(%esp)
f010385b:	00 
f010385c:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103863:	e8 36 c9 ff ff       	call   f010019e <_panic>
	boot_pgdir[0] = 0;
f0103868:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f010386d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0103873:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103876:	0f b7 40 08          	movzwl 0x8(%eax),%eax
f010387a:	66 83 f8 01          	cmp    $0x1,%ax
f010387e:	74 24                	je     f01038a4 <page_check+0xbb7>
f0103880:	c7 44 24 0c 5e 83 10 	movl   $0xf010835e,0xc(%esp)
f0103887:	f0 
f0103888:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f010388f:	f0 
f0103890:	c7 44 24 04 86 03 00 	movl   $0x386,0x4(%esp)
f0103897:	00 
f0103898:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f010389f:	e8 fa c8 ff ff       	call   f010019e <_panic>
	pp0->pp_ref = 0;
f01038a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01038a7:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
	
	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01038ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01038b0:	89 04 24             	mov    %eax,(%esp)
f01038b3:	e8 1c ef ff ff       	call   f01027d4 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
f01038b8:	c7 45 e8 00 10 40 00 	movl   $0x401000,-0x18(%ebp)
	ptep = pgdir_walk(boot_pgdir, va, 1);
f01038bf:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01038c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01038cb:	00 
f01038cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01038cf:	89 54 24 04          	mov    %edx,0x4(%esp)
f01038d3:	89 04 24             	mov    %eax,(%esp)
f01038d6:	e8 7d ef ff ff       	call   f0102858 <pgdir_walk>
f01038db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	ptep1 = KADDR(PTE_ADDR(boot_pgdir[PDX(va)]));
f01038de:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01038e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01038e6:	c1 ea 16             	shr    $0x16,%edx
f01038e9:	c1 e2 02             	shl    $0x2,%edx
f01038ec:	01 d0                	add    %edx,%eax
f01038ee:	8b 00                	mov    (%eax),%eax
f01038f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01038f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01038f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01038fb:	c1 e8 0c             	shr    $0xc,%eax
f01038fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103901:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f0103906:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f0103909:	72 23                	jb     f010392e <page_check+0xc41>
f010390b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010390e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103912:	c7 44 24 08 0c 7f 10 	movl   $0xf0107f0c,0x8(%esp)
f0103919:	f0 
f010391a:	c7 44 24 04 8d 03 00 	movl   $0x38d,0x4(%esp)
f0103921:	00 
f0103922:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103929:	e8 70 c8 ff ff       	call   f010019e <_panic>
f010392e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103931:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103936:	89 45 dc             	mov    %eax,-0x24(%ebp)
	assert(ptep == ptep1 + PTX(va));
f0103939:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010393c:	c1 e8 0c             	shr    $0xc,%eax
f010393f:	25 ff 03 00 00       	and    $0x3ff,%eax
f0103944:	c1 e0 02             	shl    $0x2,%eax
f0103947:	89 c2                	mov    %eax,%edx
f0103949:	03 55 dc             	add    -0x24(%ebp),%edx
f010394c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f010394f:	39 c2                	cmp    %eax,%edx
f0103951:	74 24                	je     f0103977 <page_check+0xc8a>
f0103953:	c7 44 24 0c 2a 86 10 	movl   $0xf010862a,0xc(%esp)
f010395a:	f0 
f010395b:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103962:	f0 
f0103963:	c7 44 24 04 8e 03 00 	movl   $0x38e,0x4(%esp)
f010396a:	00 
f010396b:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103972:	e8 27 c8 ff ff       	call   f010019e <_panic>
	boot_pgdir[PDX(va)] = 0;
f0103977:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f010397c:	8b 55 e8             	mov    -0x18(%ebp),%edx
f010397f:	c1 ea 16             	shr    $0x16,%edx
f0103982:	c1 e2 02             	shl    $0x2,%edx
f0103985:	01 d0                	add    %edx,%eax
f0103987:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010398d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103990:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
	
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0103996:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103999:	89 04 24             	mov    %eax,(%esp)
f010399c:	e8 3b dc ff ff       	call   f01015dc <page2kva>
f01039a1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01039a8:	00 
f01039a9:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f01039b0:	00 
f01039b1:	89 04 24             	mov    %eax,(%esp)
f01039b4:	e8 3a 38 00 00       	call   f01071f3 <memset>
	page_free(pp0);
f01039b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01039bc:	89 04 24             	mov    %eax,(%esp)
f01039bf:	e8 10 ee ff ff       	call   f01027d4 <page_free>
	pgdir_walk(boot_pgdir, 0x0, 1);
f01039c4:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f01039c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01039d0:	00 
f01039d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01039d8:	00 
f01039d9:	89 04 24             	mov    %eax,(%esp)
f01039dc:	e8 77 ee ff ff       	call   f0102858 <pgdir_walk>
	ptep = page2kva(pp0);
f01039e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01039e4:	89 04 24             	mov    %eax,(%esp)
f01039e7:	e8 f0 db ff ff       	call   f01015dc <page2kva>
f01039ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i=0; i<NPTENTRIES; i++)
f01039ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01039f6:	eb 3c                	jmp    f0103a34 <page_check+0xd47>
		assert((ptep[i] & PTE_P) == 0);
f01039f8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f01039fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01039fe:	c1 e2 02             	shl    $0x2,%edx
f0103a01:	01 d0                	add    %edx,%eax
f0103a03:	8b 00                	mov    (%eax),%eax
f0103a05:	83 e0 01             	and    $0x1,%eax
f0103a08:	84 c0                	test   %al,%al
f0103a0a:	74 24                	je     f0103a30 <page_check+0xd43>
f0103a0c:	c7 44 24 0c 42 86 10 	movl   $0xf0108642,0xc(%esp)
f0103a13:	f0 
f0103a14:	c7 44 24 08 0b 80 10 	movl   $0xf010800b,0x8(%esp)
f0103a1b:	f0 
f0103a1c:	c7 44 24 04 98 03 00 	movl   $0x398,0x4(%esp)
f0103a23:	00 
f0103a24:	c7 04 24 94 7f 10 f0 	movl   $0xf0107f94,(%esp)
f0103a2b:	e8 6e c7 ff ff       	call   f010019e <_panic>
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(boot_pgdir, 0x0, 1);
	ptep = page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f0103a30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0103a34:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
f0103a3b:	7e bb                	jle    f01039f8 <page_check+0xd0b>
		assert((ptep[i] & PTE_P) == 0);
	boot_pgdir[0] = 0;
f0103a3d:	a1 c8 94 1a f0       	mov    0xf01a94c8,%eax
f0103a42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0103a48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103a4b:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)

	// give free list back
	page_free_list = fl;
f0103a51:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0103a54:	a3 1c 88 1a f0       	mov    %eax,0xf01a881c

	// free the pages we took
	page_free(pp0);
f0103a59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103a5c:	89 04 24             	mov    %eax,(%esp)
f0103a5f:	e8 70 ed ff ff       	call   f01027d4 <page_free>
	page_free(pp1);
f0103a64:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103a67:	89 04 24             	mov    %eax,(%esp)
f0103a6a:	e8 65 ed ff ff       	call   f01027d4 <page_free>
	page_free(pp2);
f0103a6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103a72:	89 04 24             	mov    %eax,(%esp)
f0103a75:	e8 5a ed ff ff       	call   f01027d4 <page_free>
	
	cprintf("page_check() succeeded!\n");
f0103a7a:	c7 04 24 59 86 10 f0 	movl   $0xf0108659,(%esp)
f0103a81:	e8 08 0c 00 00       	call   f010468e <cprintf>
}
f0103a86:	83 c4 54             	add    $0x54,%esp
f0103a89:	5b                   	pop    %ebx
f0103a8a:	5d                   	pop    %ebp
f0103a8b:	c3                   	ret    

f0103a8c <page2ppn>:
int	user_mem_check(struct Env *env, const void *va, size_t len, int perm);
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline ppn_t
page2ppn(struct Page *pp)
{
f0103a8c:	55                   	push   %ebp
f0103a8d:	89 e5                	mov    %esp,%ebp
	return pp - pages;
f0103a8f:	8b 55 08             	mov    0x8(%ebp),%edx
f0103a92:	a1 cc 94 1a f0       	mov    0xf01a94cc,%eax
f0103a97:	89 d1                	mov    %edx,%ecx
f0103a99:	29 c1                	sub    %eax,%ecx
f0103a9b:	89 c8                	mov    %ecx,%eax
f0103a9d:	c1 f8 02             	sar    $0x2,%eax
f0103aa0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
f0103aa6:	5d                   	pop    %ebp
f0103aa7:	c3                   	ret    

f0103aa8 <page2pa>:

static inline physaddr_t
page2pa(struct Page *pp)
{
f0103aa8:	55                   	push   %ebp
f0103aa9:	89 e5                	mov    %esp,%ebp
f0103aab:	83 ec 04             	sub    $0x4,%esp
	return page2ppn(pp) << PGSHIFT;
f0103aae:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ab1:	89 04 24             	mov    %eax,(%esp)
f0103ab4:	e8 d3 ff ff ff       	call   f0103a8c <page2ppn>
f0103ab9:	c1 e0 0c             	shl    $0xc,%eax
}
f0103abc:	c9                   	leave  
f0103abd:	c3                   	ret    

f0103abe <pa2page>:

static inline struct Page*
pa2page(physaddr_t pa)
{
f0103abe:	55                   	push   %ebp
f0103abf:	89 e5                	mov    %esp,%ebp
f0103ac1:	83 ec 18             	sub    $0x18,%esp
	if (PPN(pa) >= npage)
f0103ac4:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ac7:	89 c2                	mov    %eax,%edx
f0103ac9:	c1 ea 0c             	shr    $0xc,%edx
f0103acc:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f0103ad1:	39 c2                	cmp    %eax,%edx
f0103ad3:	72 1c                	jb     f0103af1 <pa2page+0x33>
		panic("pa2page called with invalid pa");
f0103ad5:	c7 44 24 08 74 86 10 	movl   $0xf0108674,0x8(%esp)
f0103adc:	f0 
f0103add:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0103ae4:	00 
f0103ae5:	c7 04 24 93 86 10 f0 	movl   $0xf0108693,(%esp)
f0103aec:	e8 ad c6 ff ff       	call   f010019e <_panic>
	return &pages[PPN(pa)];
f0103af1:	8b 0d cc 94 1a f0    	mov    0xf01a94cc,%ecx
f0103af7:	8b 45 08             	mov    0x8(%ebp),%eax
f0103afa:	89 c2                	mov    %eax,%edx
f0103afc:	c1 ea 0c             	shr    $0xc,%edx
f0103aff:	89 d0                	mov    %edx,%eax
f0103b01:	01 c0                	add    %eax,%eax
f0103b03:	01 d0                	add    %edx,%eax
f0103b05:	c1 e0 02             	shl    $0x2,%eax
f0103b08:	01 c8                	add    %ecx,%eax
}
f0103b0a:	c9                   	leave  
f0103b0b:	c3                   	ret    

f0103b0c <page2kva>:

static inline void*
page2kva(struct Page *pp)
{
f0103b0c:	55                   	push   %ebp
f0103b0d:	89 e5                	mov    %esp,%ebp
f0103b0f:	83 ec 28             	sub    $0x28,%esp
	return KADDR(page2pa(pp));
f0103b12:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b15:	89 04 24             	mov    %eax,(%esp)
f0103b18:	e8 8b ff ff ff       	call   f0103aa8 <page2pa>
f0103b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0103b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103b23:	c1 e8 0c             	shr    $0xc,%eax
f0103b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0103b29:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f0103b2e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
f0103b31:	72 23                	jb     f0103b56 <page2kva+0x4a>
f0103b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103b36:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103b3a:	c7 44 24 08 a4 86 10 	movl   $0xf01086a4,0x8(%esp)
f0103b41:	f0 
f0103b42:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0103b49:	00 
f0103b4a:	c7 04 24 93 86 10 f0 	movl   $0xf0108693,(%esp)
f0103b51:	e8 48 c6 ff ff       	call   f010019e <_panic>
f0103b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103b59:	2d 00 00 00 10       	sub    $0x10000000,%eax
}
f0103b5e:	c9                   	leave  
f0103b5f:	c3                   	ret    

f0103b60 <envid2env>:
//   On success, sets *penv to the environment.
//   On error, sets *penv to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103b60:	55                   	push   %ebp
f0103b61:	89 e5                	mov    %esp,%ebp
f0103b63:	83 ec 10             	sub    $0x10,%esp
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0103b6a:	75 12                	jne    f0103b7e <envid2env+0x1e>
		*env_store = curenv;
f0103b6c:	8b 15 28 88 1a f0    	mov    0xf01a8828,%edx
f0103b72:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103b75:	89 10                	mov    %edx,(%eax)
		return 0;
f0103b77:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b7c:	eb 7a                	jmp    f0103bf8 <envid2env+0x98>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0103b7e:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0103b83:	8b 55 08             	mov    0x8(%ebp),%edx
f0103b86:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0103b8c:	c1 e2 07             	shl    $0x7,%edx
f0103b8f:	01 d0                	add    %edx,%eax
f0103b91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103b94:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0103b97:	8b 40 54             	mov    0x54(%eax),%eax
f0103b9a:	85 c0                	test   %eax,%eax
f0103b9c:	74 0b                	je     f0103ba9 <envid2env+0x49>
f0103b9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0103ba1:	8b 40 4c             	mov    0x4c(%eax),%eax
f0103ba4:	3b 45 08             	cmp    0x8(%ebp),%eax
f0103ba7:	74 10                	je     f0103bb9 <envid2env+0x59>
		*env_store = 0;
f0103ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103bb2:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103bb7:	eb 3f                	jmp    f0103bf8 <envid2env+0x98>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103bb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0103bbd:	74 2c                	je     f0103beb <envid2env+0x8b>
f0103bbf:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0103bc4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
f0103bc7:	74 22                	je     f0103beb <envid2env+0x8b>
f0103bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0103bcc:	8b 50 50             	mov    0x50(%eax),%edx
f0103bcf:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0103bd4:	8b 40 4c             	mov    0x4c(%eax),%eax
f0103bd7:	39 c2                	cmp    %eax,%edx
f0103bd9:	74 10                	je     f0103beb <envid2env+0x8b>
		*env_store = 0;
f0103bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103be4:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103be9:	eb 0d                	jmp    f0103bf8 <envid2env+0x98>
	}

	*env_store = e;
f0103beb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103bee:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0103bf1:	89 10                	mov    %edx,(%eax)
	return 0;
f0103bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103bf8:	c9                   	leave  
f0103bf9:	c3                   	ret    

f0103bfa <env_init>:
// Insert in reverse order, so that the first call to env_alloc()
// returns envs[0].
//
void
env_init(void)
{
f0103bfa:	55                   	push   %ebp
f0103bfb:	89 e5                	mov    %esp,%ebp
f0103bfd:	83 ec 10             	sub    $0x10,%esp
	// LAB 3: Your code here.
    int i;
    LIST_INIT(&env_free_list);
f0103c00:	c7 05 2c 88 1a f0 00 	movl   $0x0,0xf01a882c
f0103c07:	00 00 00 
    for(i = NENV-1;i>=0;i--){
f0103c0a:	c7 45 fc ff 03 00 00 	movl   $0x3ff,-0x4(%ebp)
f0103c11:	e9 88 00 00 00       	jmp    f0103c9e <env_init+0xa4>
        envs[i].env_id = 0;// set id = 0
f0103c16:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0103c1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0103c1e:	c1 e2 07             	shl    $0x7,%edx
f0103c21:	01 d0                	add    %edx,%eax
f0103c23:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
        envs[i].env_status = ENV_FREE;// envs as free
f0103c2a:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0103c2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0103c32:	c1 e2 07             	shl    $0x7,%edx
f0103c35:	01 d0                	add    %edx,%eax
f0103c37:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
        LIST_INSERT_HEAD(&env_free_list, &envs[i], env_link);//set into the free_list
f0103c3e:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0103c43:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0103c46:	c1 e2 07             	shl    $0x7,%edx
f0103c49:	01 d0                	add    %edx,%eax
f0103c4b:	8b 15 2c 88 1a f0    	mov    0xf01a882c,%edx
f0103c51:	89 50 44             	mov    %edx,0x44(%eax)
f0103c54:	8b 40 44             	mov    0x44(%eax),%eax
f0103c57:	85 c0                	test   %eax,%eax
f0103c59:	74 19                	je     f0103c74 <env_init+0x7a>
f0103c5b:	a1 2c 88 1a f0       	mov    0xf01a882c,%eax
f0103c60:	8b 15 24 88 1a f0    	mov    0xf01a8824,%edx
f0103c66:	8b 4d fc             	mov    -0x4(%ebp),%ecx
f0103c69:	c1 e1 07             	shl    $0x7,%ecx
f0103c6c:	01 ca                	add    %ecx,%edx
f0103c6e:	83 c2 44             	add    $0x44,%edx
f0103c71:	89 50 48             	mov    %edx,0x48(%eax)
f0103c74:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0103c79:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0103c7c:	c1 e2 07             	shl    $0x7,%edx
f0103c7f:	01 d0                	add    %edx,%eax
f0103c81:	a3 2c 88 1a f0       	mov    %eax,0xf01a882c
f0103c86:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0103c8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0103c8e:	c1 e2 07             	shl    $0x7,%edx
f0103c91:	01 d0                	add    %edx,%eax
f0103c93:	c7 40 48 2c 88 1a f0 	movl   $0xf01a882c,0x48(%eax)
env_init(void)
{
	// LAB 3: Your code here.
    int i;
    LIST_INIT(&env_free_list);
    for(i = NENV-1;i>=0;i--){
f0103c9a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
f0103c9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
f0103ca2:	0f 89 6e ff ff ff    	jns    f0103c16 <env_init+0x1c>
        envs[i].env_id = 0;// set id = 0
        envs[i].env_status = ENV_FREE;// envs as free
        LIST_INSERT_HEAD(&env_free_list, &envs[i], env_link);//set into the free_list
    }
}
f0103ca8:	c9                   	leave  
f0103ca9:	c3                   	ret    

f0103caa <env_setup_vm>:
// Returns 0 on success, < 0 on error.  Errors include:
//	-E_NO_MEM if page directory or table could not be allocated.
//
static int
env_setup_vm(struct Env *e)
{
f0103caa:	55                   	push   %ebp
f0103cab:	89 e5                	mov    %esp,%ebp
f0103cad:	83 ec 28             	sub    $0x28,%esp
	int i, r;
	struct Page *p = NULL;
f0103cb0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	// Allocate a page for the page directory
	if ((r = page_alloc(&p)) < 0)
f0103cb7:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0103cba:	89 04 24             	mov    %eax,(%esp)
f0103cbd:	e8 bf ea ff ff       	call   f0102781 <page_alloc>
f0103cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0103cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0103cc9:	79 08                	jns    f0103cd3 <env_setup_vm+0x29>
		return r;
f0103ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103cce:	e9 a1 00 00 00       	jmp    f0103d74 <env_setup_vm+0xca>
	//    - Note: pp_ref is not maintained for most physical pages
	//	mapped above UTOP -- but you do need to increment
	//	env_pgdir's pp_ref!

	// LAB 3: Your code here.
    e->env_pgdir = page2kva(p);
f0103cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103cd6:	89 04 24             	mov    %eax,(%esp)
f0103cd9:	e8 2e fe ff ff       	call   f0103b0c <page2kva>
f0103cde:	8b 55 08             	mov    0x8(%ebp),%edx
f0103ce1:	89 42 5c             	mov    %eax,0x5c(%edx)
    e->env_cr3 = page2pa(p);// set the page to be 0
f0103ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103ce7:	89 04 24             	mov    %eax,(%esp)
f0103cea:	e8 b9 fd ff ff       	call   f0103aa8 <page2pa>
f0103cef:	8b 55 08             	mov    0x8(%ebp),%edx
f0103cf2:	89 42 60             	mov    %eax,0x60(%edx)
        e->env_pgdir[i] = boot_pgdir[i];//copy the boot_pgdir
    }
    //memmove(e->env_pgdir, boot_pgdir, PGSIZE);
    //memset(e->env_pgdir, 0, PDX(UTOP) * sizeof(pde_t));
    memset(e->env_pgdir, 0, PGSIZE);*/
    memmove(e->env_pgdir, boot_pgdir, PGSIZE);
f0103cf5:	8b 15 c8 94 1a f0    	mov    0xf01a94c8,%edx
f0103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
f0103cfe:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103d01:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103d08:	00 
f0103d09:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103d0d:	89 04 24             	mov    %eax,(%esp)
f0103d10:	e8 0f 35 00 00       	call   f0107224 <memmove>
    memset(e->env_pgdir, 0, PDX(UTOP)*sizeof(pde_t));
f0103d15:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d18:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103d1b:	c7 44 24 08 ec 0e 00 	movl   $0xeec,0x8(%esp)
f0103d22:	00 
f0103d23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103d2a:	00 
f0103d2b:	89 04 24             	mov    %eax,(%esp)
f0103d2e:	e8 c0 34 00 00       	call   f01071f3 <memset>
    p->pp_ref++;
f0103d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103d36:	0f b7 50 08          	movzwl 0x8(%eax),%edx
f0103d3a:	83 c2 01             	add    $0x1,%edx
f0103d3d:	66 89 50 08          	mov    %dx,0x8(%eax)
	// VPT and UVPT map the env's own page table, with
	// different permissions.
	e->env_pgdir[PDX(VPT)]  = e->env_cr3 | PTE_P | PTE_W;
f0103d41:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d44:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103d47:	8d 90 fc 0e 00 00    	lea    0xefc(%eax),%edx
f0103d4d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d50:	8b 40 60             	mov    0x60(%eax),%eax
f0103d53:	83 c8 03             	or     $0x3,%eax
f0103d56:	89 02                	mov    %eax,(%edx)
	e->env_pgdir[PDX(UVPT)] = e->env_cr3 | PTE_P | PTE_U;
f0103d58:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d5b:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103d5e:	8d 90 f4 0e 00 00    	lea    0xef4(%eax),%edx
f0103d64:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d67:	8b 40 60             	mov    0x60(%eax),%eax
f0103d6a:	83 c8 05             	or     $0x5,%eax
f0103d6d:	89 02                	mov    %eax,(%edx)

	return 0;
f0103d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103d74:	c9                   	leave  
f0103d75:	c3                   	ret    

f0103d76 <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103d76:	55                   	push   %ebp
f0103d77:	89 e5                	mov    %esp,%ebp
f0103d79:	83 ec 28             	sub    $0x28,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = LIST_FIRST(&env_free_list)))
f0103d7c:	a1 2c 88 1a f0       	mov    0xf01a882c,%eax
f0103d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0103d84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0103d88:	75 0a                	jne    f0103d94 <env_alloc+0x1e>
		return -E_NO_FREE_ENV;
f0103d8a:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103d8f:	e9 3f 01 00 00       	jmp    f0103ed3 <env_alloc+0x15d>

	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
f0103d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103d97:	89 04 24             	mov    %eax,(%esp)
f0103d9a:	e8 0b ff ff ff       	call   f0103caa <env_setup_vm>
f0103d9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0103da2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f0103da6:	79 08                	jns    f0103db0 <env_alloc+0x3a>
		return r;
f0103da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0103dab:	e9 23 01 00 00       	jmp    f0103ed3 <env_alloc+0x15d>

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103db3:	8b 40 4c             	mov    0x4c(%eax),%eax
f0103db6:	05 00 10 00 00       	add    $0x1000,%eax
f0103dbb:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0103dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (generation <= 0)	// Don't create a negative env_id.
f0103dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0103dc7:	7f 07                	jg     f0103dd0 <env_alloc+0x5a>
		generation = 1 << ENVGENSHIFT;
f0103dc9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
	e->env_id = generation | (e - envs);
f0103dd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0103dd3:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0103dd8:	89 d1                	mov    %edx,%ecx
f0103dda:	29 c1                	sub    %eax,%ecx
f0103ddc:	89 c8                	mov    %ecx,%eax
f0103dde:	c1 f8 07             	sar    $0x7,%eax
f0103de1:	89 c2                	mov    %eax,%edx
f0103de3:	0b 55 f4             	or     -0xc(%ebp),%edx
f0103de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103de9:	89 50 4c             	mov    %edx,0x4c(%eax)
	
	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103def:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103df2:	89 50 50             	mov    %edx,0x50(%eax)
	e->env_status = ENV_RUNNABLE;
f0103df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103df8:	c7 40 54 01 00 00 00 	movl   $0x1,0x54(%eax)
	e->env_runs = 0;
f0103dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e02:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e0c:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0103e13:	00 
f0103e14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103e1b:	00 
f0103e1c:	89 04 24             	mov    %eax,(%esp)
f0103e1f:	e8 cf 33 00 00       	call   f01071f3 <memset>
	// Set up appropriate initial values for the segment registers.
	// GD_UD is the user data segment selector in the GDT, and 
	// GD_UT is the user text segment selector (see inc/memlayout.h).
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.
	e->env_tf.tf_ds = GD_UD | 3;
f0103e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e27:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
	e->env_tf.tf_es = GD_UD | 3;
f0103e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e30:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
	e->env_tf.tf_ss = GD_UD | 3;
f0103e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e39:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
	e->env_tf.tf_esp = USTACKTOP;
f0103e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e42:	c7 40 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%eax)
	e->env_tf.tf_cs = GD_UT | 3;
f0103e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e4c:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
	// You will set e->env_tf.tf_eip later.
	
	//the env_priority
	e->env_priority = ENV_PRIOR_DEFAULT;
f0103e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e55:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
	//cprintf("%d\n",e->env_priority);
	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
    e->env_tf.tf_eflags |= FL_IF;
f0103e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e5f:	8b 40 38             	mov    0x38(%eax),%eax
f0103e62:	89 c2                	mov    %eax,%edx
f0103e64:	80 ce 02             	or     $0x2,%dh
f0103e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e6a:	89 50 38             	mov    %edx,0x38(%eax)
	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0103e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e70:	c7 40 64 00 00 00 00 	movl   $0x0,0x64(%eax)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0103e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e7a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

	// If this is the file server (e == &envs[1]) give it I/O privileges.
	// LAB 5: Your code here.
    if(e == &envs[1]){
f0103e81:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0103e86:	83 e8 80             	sub    $0xffffff80,%eax
f0103e89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
f0103e8c:	75 11                	jne    f0103e9f <env_alloc+0x129>
		e->env_tf.tf_eflags |= FL_IOPL_3;
f0103e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e91:	8b 40 38             	mov    0x38(%eax),%eax
f0103e94:	89 c2                	mov    %eax,%edx
f0103e96:	80 ce 30             	or     $0x30,%dh
f0103e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103e9c:	89 50 38             	mov    %edx,0x38(%eax)
	}
	// commit the allocation
	LIST_REMOVE(e, env_link);
f0103e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103ea2:	8b 40 44             	mov    0x44(%eax),%eax
f0103ea5:	85 c0                	test   %eax,%eax
f0103ea7:	74 0f                	je     f0103eb8 <env_alloc+0x142>
f0103ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103eac:	8b 40 44             	mov    0x44(%eax),%eax
f0103eaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0103eb2:	8b 52 48             	mov    0x48(%edx),%edx
f0103eb5:	89 50 48             	mov    %edx,0x48(%eax)
f0103eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103ebb:	8b 40 48             	mov    0x48(%eax),%eax
f0103ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0103ec1:	8b 52 44             	mov    0x44(%edx),%edx
f0103ec4:	89 10                	mov    %edx,(%eax)
	*newenv_store = e;
f0103ec6:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ec9:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0103ecc:	89 10                	mov    %edx,(%eax)

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
f0103ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103ed3:	c9                   	leave  
f0103ed4:	c3                   	ret    

f0103ed5 <segment_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
segment_alloc(struct Env *e, void *va, size_t len)
{
f0103ed5:	55                   	push   %ebp
f0103ed6:	89 e5                	mov    %esp,%ebp
f0103ed8:	83 ec 38             	sub    $0x38,%esp
	// (But only if you need it for load_icode.)
	//
	// Hint: It is easier to use segment_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round len up.
    va = ROUNDDOWN(va, PGSIZE);
f0103edb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0103ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103ee4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103ee9:	89 45 0c             	mov    %eax,0xc(%ebp)
    len = ROUNDUP(len, PGSIZE);
f0103eec:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
f0103ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103ef6:	8b 55 10             	mov    0x10(%ebp),%edx
f0103ef9:	01 d0                	add    %edx,%eax
f0103efb:	83 e8 01             	sub    $0x1,%eax
f0103efe:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0103f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0103f04:	ba 00 00 00 00       	mov    $0x0,%edx
f0103f09:	f7 75 f0             	divl   -0x10(%ebp)
f0103f0c:	89 d0                	mov    %edx,%eax
f0103f0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0103f11:	89 d1                	mov    %edx,%ecx
f0103f13:	29 c1                	sub    %eax,%ecx
f0103f15:	89 c8                	mov    %ecx,%eax
f0103f17:	89 45 10             	mov    %eax,0x10(%ebp)
    struct Page *pg;
    int r;
    for(;len>0;len-=PGSIZE, va+=PGSIZE){
f0103f1a:	e9 87 00 00 00       	jmp    f0103fa6 <segment_alloc+0xd1>
        r = page_alloc(&pg);//alloc a page
f0103f1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103f22:	89 04 24             	mov    %eax,(%esp)
f0103f25:	e8 57 e8 ff ff       	call   f0102781 <page_alloc>
f0103f2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(r!=0){
f0103f2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0103f31:	74 1c                	je     f0103f4f <segment_alloc+0x7a>
            panic("alloc failed with none physical page\n");
f0103f33:	c7 44 24 08 c8 86 10 	movl   $0xf01086c8,0x8(%esp)
f0103f3a:	f0 
f0103f3b:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
f0103f42:	00 
f0103f43:	c7 04 24 ee 86 10 f0 	movl   $0xf01086ee,(%esp)
f0103f4a:	e8 4f c2 ff ff       	call   f010019e <_panic>
        }
        r = page_insert(e->env_pgdir, pg, va, PTE_U|PTE_W);//insert the page into env_pgdir
f0103f4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103f52:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f55:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103f58:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0103f5f:	00 
f0103f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103f63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0103f67:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103f6b:	89 04 24             	mov    %eax,(%esp)
f0103f6e:	e8 61 ea ff ff       	call   f01029d4 <page_insert>
f0103f73:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(r!=0){
f0103f76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0103f7a:	74 1c                	je     f0103f98 <segment_alloc+0xc3>
            panic("alloc failed with mapping failed\n");
f0103f7c:	c7 44 24 08 fc 86 10 	movl   $0xf01086fc,0x8(%esp)
f0103f83:	f0 
f0103f84:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
f0103f8b:	00 
f0103f8c:	c7 04 24 ee 86 10 f0 	movl   $0xf01086ee,(%esp)
f0103f93:	e8 06 c2 ff ff       	call   f010019e <_panic>
	//   You should round va down, and round len up.
    va = ROUNDDOWN(va, PGSIZE);
    len = ROUNDUP(len, PGSIZE);
    struct Page *pg;
    int r;
    for(;len>0;len-=PGSIZE, va+=PGSIZE){
f0103f98:	81 6d 10 00 10 00 00 	subl   $0x1000,0x10(%ebp)
f0103f9f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
f0103fa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0103faa:	0f 85 6f ff ff ff    	jne    f0103f1f <segment_alloc+0x4a>
        r = page_insert(e->env_pgdir, pg, va, PTE_U|PTE_W);//insert the page into env_pgdir
        if(r!=0){
            panic("alloc failed with mapping failed\n");
        }
    }
}
f0103fb0:	c9                   	leave  
f0103fb1:	c3                   	ret    

f0103fb2 <load_icode>:
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
static void
load_icode(struct Env *e, uint8_t *binary, size_t size)
{
f0103fb2:	55                   	push   %ebp
f0103fb3:	89 e5                	mov    %esp,%ebp
f0103fb5:	83 ec 38             	sub    $0x38,%esp

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.
    struct Elf *env_elf = (struct Elf*)binary;//turn the binary to Elf
f0103fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Proghdr *ph, *eph;
    if(env_elf->e_magic != ELF_MAGIC){
f0103fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103fc1:	8b 00                	mov    (%eax),%eax
f0103fc3:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
f0103fc8:	74 1c                	je     f0103fe6 <load_icode+0x34>
        panic("load_icode: this is not a elf file\n");
f0103fca:	c7 44 24 08 20 87 10 	movl   $0xf0108720,0x8(%esp)
f0103fd1:	f0 
f0103fd2:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
f0103fd9:	00 
f0103fda:	c7 04 24 ee 86 10 f0 	movl   $0xf01086ee,(%esp)
f0103fe1:	e8 b8 c1 ff ff       	call   f010019e <_panic>
    }
    ph = (struct Proghdr*)((uint8_t *)env_elf + env_elf->e_phoff);//
f0103fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103fe9:	8b 40 1c             	mov    0x1c(%eax),%eax
f0103fec:	03 45 f0             	add    -0x10(%ebp),%eax
f0103fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    eph = ph + env_elf->e_phnum;
f0103ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103ff5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103ff9:	0f b7 c0             	movzwl %ax,%eax
f0103ffc:	c1 e0 05             	shl    $0x5,%eax
f0103fff:	03 45 f4             	add    -0xc(%ebp),%eax
f0104002:	89 45 ec             	mov    %eax,-0x14(%ebp)

    lcr3(e->env_cr3);
f0104005:	8b 45 08             	mov    0x8(%ebp),%eax
f0104008:	8b 40 60             	mov    0x60(%eax),%eax
f010400b:	89 45 e8             	mov    %eax,-0x18(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010400e:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0104011:	0f 22 d8             	mov    %eax,%cr3
    for(;ph<eph;ph++){
f0104014:	eb 74                	jmp    f010408a <load_icode+0xd8>
        if(ph->p_type == ELF_PROG_LOAD){// must elf_prog_load
f0104016:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104019:	8b 00                	mov    (%eax),%eax
f010401b:	83 f8 01             	cmp    $0x1,%eax
f010401e:	75 66                	jne    f0104086 <load_icode+0xd4>
            segment_alloc(e, (void *)ph->p_va, ph->p_memsz);//get the vm for e
f0104020:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104023:	8b 50 14             	mov    0x14(%eax),%edx
f0104026:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104029:	8b 40 08             	mov    0x8(%eax),%eax
f010402c:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104030:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104034:	8b 45 08             	mov    0x8(%ebp),%eax
f0104037:	89 04 24             	mov    %eax,(%esp)
f010403a:	e8 96 fe ff ff       	call   f0103ed5 <segment_alloc>
            memset((void *)ph->p_va, 0, ph->p_memsz);//reset it clearly
f010403f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104042:	8b 50 14             	mov    0x14(%eax),%edx
f0104045:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104048:	8b 40 08             	mov    0x8(%eax),%eax
f010404b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010404f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0104056:	00 
f0104057:	89 04 24             	mov    %eax,(%esp)
f010405a:	e8 94 31 00 00       	call   f01071f3 <memset>
            memmove((void *)ph->p_va, binary+ph->p_offset, ph->p_filesz);//copy to it
f010405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104062:	8b 48 10             	mov    0x10(%eax),%ecx
f0104065:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104068:	8b 40 04             	mov    0x4(%eax),%eax
f010406b:	89 c2                	mov    %eax,%edx
f010406d:	03 55 0c             	add    0xc(%ebp),%edx
f0104070:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104073:	8b 40 08             	mov    0x8(%eax),%eax
f0104076:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010407a:	89 54 24 04          	mov    %edx,0x4(%esp)
f010407e:	89 04 24             	mov    %eax,(%esp)
f0104081:	e8 9e 31 00 00       	call   f0107224 <memmove>
    }
    ph = (struct Proghdr*)((uint8_t *)env_elf + env_elf->e_phoff);//
    eph = ph + env_elf->e_phnum;

    lcr3(e->env_cr3);
    for(;ph<eph;ph++){
f0104086:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
f010408a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010408d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f0104090:	72 84                	jb     f0104016 <load_icode+0x64>
            memset((void *)ph->p_va, 0, ph->p_memsz);//reset it clearly
            memmove((void *)ph->p_va, binary+ph->p_offset, ph->p_filesz);//copy to it
        }
    }

    lcr3(boot_cr3);
f0104092:	a1 c4 94 1a f0       	mov    0xf01a94c4,%eax
f0104097:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010409a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010409d:	0f 22 d8             	mov    %eax,%cr3

    e->env_tf.tf_eip = env_elf->e_entry;
f01040a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01040a3:	8b 50 18             	mov    0x18(%eax),%edx
f01040a6:	8b 45 08             	mov    0x8(%ebp),%eax
f01040a9:	89 50 30             	mov    %edx,0x30(%eax)
        cprintf("page alloc failed\n");
        return ;
    }
    page_insert(e->env_pgdir, pg, (void *)(USTACKTOP - PGSIZE), PTE_U|PTE_W);
*/
    segment_alloc(e, (void *)(USTACKTOP - PGSIZE), PGSIZE);
f01040ac:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01040b3:	00 
f01040b4:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
f01040bb:	ee 
f01040bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01040bf:	89 04 24             	mov    %eax,(%esp)
f01040c2:	e8 0e fe ff ff       	call   f0103ed5 <segment_alloc>
    //lcr3(boot_cr3);
    //can we just use segment_alloc replace the paga_alloc?
}
f01040c7:	c9                   	leave  
f01040c8:	c3                   	ret    

f01040c9 <env_create>:
// By convention, envs[0] is the first environment allocated, so
// whoever calls env_create simply looks for the newly created
// environment there. 
void
env_create(uint8_t *binary, size_t size)
{
f01040c9:	55                   	push   %ebp
f01040ca:	89 e5                	mov    %esp,%ebp
f01040cc:	83 ec 28             	sub    $0x28,%esp
	// LAB 3: Your code here
    struct Env *e;
    int r = env_alloc(&e, 0);//0 to set it
f01040cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01040d6:	00 
f01040d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
f01040da:	89 04 24             	mov    %eax,(%esp)
f01040dd:	e8 94 fc ff ff       	call   f0103d76 <env_alloc>
f01040e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 //   cprintf("%d \n",r);
    if(r<0){//failed
f01040e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01040e9:	79 1c                	jns    f0104107 <env_create+0x3e>
        panic("env_create failed\n");
f01040eb:	c7 44 24 08 44 87 10 	movl   $0xf0108744,0x8(%esp)
f01040f2:	f0 
f01040f3:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
f01040fa:	00 
f01040fb:	c7 04 24 ee 86 10 f0 	movl   $0xf01086ee,(%esp)
f0104102:	e8 97 c0 ff ff       	call   f010019e <_panic>
    }
    load_icode(e, binary, size);//load program
f0104107:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010410a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010410d:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104111:	8b 55 08             	mov    0x8(%ebp),%edx
f0104114:	89 54 24 04          	mov    %edx,0x4(%esp)
f0104118:	89 04 24             	mov    %eax,(%esp)
f010411b:	e8 92 fe ff ff       	call   f0103fb2 <load_icode>
}
f0104120:	c9                   	leave  
f0104121:	c3                   	ret    

f0104122 <env_free>:
//
// Frees env e and all memory it uses.
// 
void
env_free(struct Env *e)
{
f0104122:	55                   	push   %ebp
f0104123:	89 e5                	mov    %esp,%ebp
f0104125:	83 ec 38             	sub    $0x38,%esp
	physaddr_t pa;
	
	// If freeing the current environment, switch to boot_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0104128:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010412d:	39 45 08             	cmp    %eax,0x8(%ebp)
f0104130:	75 0e                	jne    f0104140 <env_free+0x1e>
		lcr3(boot_cr3);
f0104132:	a1 c4 94 1a f0       	mov    0xf01a94c4,%eax
f0104137:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010413a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010413d:	0f 22 d8             	mov    %eax,%cr3
	// Note the environment's demise.
	// cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0104140:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0104147:	e9 f4 00 00 00       	jmp    f0104240 <env_free+0x11e>

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010414c:	8b 45 08             	mov    0x8(%ebp),%eax
f010414f:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104152:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104155:	c1 e2 02             	shl    $0x2,%edx
f0104158:	01 d0                	add    %edx,%eax
f010415a:	8b 00                	mov    (%eax),%eax
f010415c:	83 e0 01             	and    $0x1,%eax
f010415f:	85 c0                	test   %eax,%eax
f0104161:	0f 84 d4 00 00 00    	je     f010423b <env_free+0x119>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0104167:	8b 45 08             	mov    0x8(%ebp),%eax
f010416a:	8b 40 5c             	mov    0x5c(%eax),%eax
f010416d:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104170:	c1 e2 02             	shl    $0x2,%edx
f0104173:	01 d0                	add    %edx,%eax
f0104175:	8b 00                	mov    (%eax),%eax
f0104177:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010417c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		pt = (pte_t*) KADDR(pa);
f010417f:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104182:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0104185:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0104188:	c1 e8 0c             	shr    $0xc,%eax
f010418b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010418e:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f0104193:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0104196:	72 23                	jb     f01041bb <env_free+0x99>
f0104198:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010419b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010419f:	c7 44 24 08 a4 86 10 	movl   $0xf01086a4,0x8(%esp)
f01041a6:	f0 
f01041a7:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
f01041ae:	00 
f01041af:	c7 04 24 ee 86 10 f0 	movl   $0xf01086ee,(%esp)
f01041b6:	e8 e3 bf ff ff       	call   f010019e <_panic>
f01041bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01041be:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01041c3:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01041c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f01041cd:	eb 3a                	jmp    f0104209 <env_free+0xe7>
			if (pt[pteno] & PTE_P)
f01041cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01041d2:	c1 e0 02             	shl    $0x2,%eax
f01041d5:	03 45 e0             	add    -0x20(%ebp),%eax
f01041d8:	8b 00                	mov    (%eax),%eax
f01041da:	83 e0 01             	and    $0x1,%eax
f01041dd:	84 c0                	test   %al,%al
f01041df:	74 24                	je     f0104205 <env_free+0xe3>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01041e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01041e4:	89 c2                	mov    %eax,%edx
f01041e6:	c1 e2 16             	shl    $0x16,%edx
f01041e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01041ec:	c1 e0 0c             	shl    $0xc,%eax
f01041ef:	09 d0                	or     %edx,%eax
f01041f1:	89 c2                	mov    %eax,%edx
f01041f3:	8b 45 08             	mov    0x8(%ebp),%eax
f01041f6:	8b 40 5c             	mov    0x5c(%eax),%eax
f01041f9:	89 54 24 04          	mov    %edx,0x4(%esp)
f01041fd:	89 04 24             	mov    %eax,(%esp)
f0104200:	e8 5f e9 ff ff       	call   f0102b64 <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0104205:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f0104209:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
f0104210:	76 bd                	jbe    f01041cf <env_free+0xad>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0104212:	8b 45 08             	mov    0x8(%ebp),%eax
f0104215:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104218:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010421b:	c1 e2 02             	shl    $0x2,%edx
f010421e:	01 d0                	add    %edx,%eax
f0104220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		page_decref(pa2page(pa));
f0104226:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104229:	89 04 24             	mov    %eax,(%esp)
f010422c:	e8 8d f8 ff ff       	call   f0103abe <pa2page>
f0104231:	89 04 24             	mov    %eax,(%esp)
f0104234:	e8 ef e5 ff ff       	call   f0102828 <page_decref>
f0104239:	eb 01                	jmp    f010423c <env_free+0x11a>
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
			continue;
f010423b:	90                   	nop
	// Note the environment's demise.
	// cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f010423c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0104240:	81 7d f4 ba 03 00 00 	cmpl   $0x3ba,-0xc(%ebp)
f0104247:	0f 86 ff fe ff ff    	jbe    f010414c <env_free+0x2a>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = e->env_cr3;
f010424d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104250:	8b 40 60             	mov    0x60(%eax),%eax
f0104253:	89 45 ec             	mov    %eax,-0x14(%ebp)
	e->env_pgdir = 0;
f0104256:	8b 45 08             	mov    0x8(%ebp),%eax
f0104259:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)
	e->env_cr3 = 0;
f0104260:	8b 45 08             	mov    0x8(%ebp),%eax
f0104263:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)
	page_decref(pa2page(pa));
f010426a:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010426d:	89 04 24             	mov    %eax,(%esp)
f0104270:	e8 49 f8 ff ff       	call   f0103abe <pa2page>
f0104275:	89 04 24             	mov    %eax,(%esp)
f0104278:	e8 ab e5 ff ff       	call   f0102828 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f010427d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104280:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	LIST_INSERT_HEAD(&env_free_list, e, env_link);
f0104287:	8b 15 2c 88 1a f0    	mov    0xf01a882c,%edx
f010428d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104290:	89 50 44             	mov    %edx,0x44(%eax)
f0104293:	8b 45 08             	mov    0x8(%ebp),%eax
f0104296:	8b 40 44             	mov    0x44(%eax),%eax
f0104299:	85 c0                	test   %eax,%eax
f010429b:	74 0e                	je     f01042ab <env_free+0x189>
f010429d:	a1 2c 88 1a f0       	mov    0xf01a882c,%eax
f01042a2:	8b 55 08             	mov    0x8(%ebp),%edx
f01042a5:	83 c2 44             	add    $0x44,%edx
f01042a8:	89 50 48             	mov    %edx,0x48(%eax)
f01042ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01042ae:	a3 2c 88 1a f0       	mov    %eax,0xf01a882c
f01042b3:	8b 45 08             	mov    0x8(%ebp),%eax
f01042b6:	c7 40 48 2c 88 1a f0 	movl   $0xf01a882c,0x48(%eax)
}
f01042bd:	c9                   	leave  
f01042be:	c3                   	ret    

f01042bf <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e) 
{
f01042bf:	55                   	push   %ebp
f01042c0:	89 e5                	mov    %esp,%ebp
f01042c2:	83 ec 18             	sub    $0x18,%esp
	env_free(e);
f01042c5:	8b 45 08             	mov    0x8(%ebp),%eax
f01042c8:	89 04 24             	mov    %eax,(%esp)
f01042cb:	e8 52 fe ff ff       	call   f0104122 <env_free>

	if (curenv == e) {
f01042d0:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f01042d5:	3b 45 08             	cmp    0x8(%ebp),%eax
f01042d8:	75 0f                	jne    f01042e9 <env_destroy+0x2a>
		curenv = NULL;
f01042da:	c7 05 28 88 1a f0 00 	movl   $0x0,0xf01a8828
f01042e1:	00 00 00 
		sched_yield();
f01042e4:	e8 43 14 00 00       	call   f010572c <sched_yield>
	}
}
f01042e9:	c9                   	leave  
f01042ea:	c3                   	ret    

f01042eb <env_pop_tf>:
// This exits the kernel and starts executing some environment's code.
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f01042eb:	55                   	push   %ebp
f01042ec:	89 e5                	mov    %esp,%ebp
f01042ee:	83 ec 18             	sub    $0x18,%esp
	__asm __volatile("movl %0,%%esp\n"
f01042f1:	8b 65 08             	mov    0x8(%ebp),%esp
f01042f4:	61                   	popa   
f01042f5:	07                   	pop    %es
f01042f6:	1f                   	pop    %ds
f01042f7:	83 c4 08             	add    $0x8,%esp
f01042fa:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01042fb:	c7 44 24 08 57 87 10 	movl   $0xf0108757,0x8(%esp)
f0104302:	f0 
f0104303:	c7 44 24 04 c0 01 00 	movl   $0x1c0,0x4(%esp)
f010430a:	00 
f010430b:	c7 04 24 ee 86 10 f0 	movl   $0xf01086ee,(%esp)
f0104312:	e8 87 be ff ff       	call   f010019e <_panic>

f0104317 <env_run>:
// Note: if this is the first call to env_run, curenv is NULL.
//  (This function does not return.)
//
void
env_run(struct Env *e)
{
f0104317:	55                   	push   %ebp
f0104318:	89 e5                	mov    %esp,%ebp
f010431a:	83 ec 28             	sub    $0x28,%esp
	// LAB 3: Your code here.

    //panic("env_run not yet implemented");
    //cprintf("the PADDR of env is %x\n",e->env_cr3);
    //cprintf("env %d father %d : the KADDR of env is %x, the PADDR of env is %x\n", e->env_id, e->env_parent_id, e->env_pgdir, e->env_cr3);
    if(curenv != e){
f010431d:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0104322:	3b 45 08             	cmp    0x8(%ebp),%eax
f0104325:	74 27                	je     f010434e <env_run+0x37>
        curenv = e;
f0104327:	8b 45 08             	mov    0x8(%ebp),%eax
f010432a:	a3 28 88 1a f0       	mov    %eax,0xf01a8828
        curenv->env_runs++;//run again
f010432f:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0104334:	8b 50 58             	mov    0x58(%eax),%edx
f0104337:	83 c2 01             	add    $0x1,%edx
f010433a:	89 50 58             	mov    %edx,0x58(%eax)
        lcr3(curenv->env_cr3);
f010433d:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0104342:	8b 40 60             	mov    0x60(%eax),%eax
f0104345:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0104348:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010434b:	0f 22 d8             	mov    %eax,%cr3
    }
    env_pop_tf(&curenv->env_tf);
f010434e:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0104353:	89 04 24             	mov    %eax,(%esp)
f0104356:	e8 90 ff ff ff       	call   f01042eb <env_pop_tf>
	...

f010435c <mc146818_read>:
#include <kern/picirq.h>


unsigned
mc146818_read(unsigned reg)
{
f010435c:	55                   	push   %ebp
f010435d:	89 e5                	mov    %esp,%ebp
f010435f:	53                   	push   %ebx
f0104360:	83 ec 14             	sub    $0x14,%esp
	outb(IO_RTC, reg);
f0104363:	8b 45 08             	mov    0x8(%ebp),%eax
f0104366:	0f b6 c0             	movzbl %al,%eax
f0104369:	c7 45 f8 70 00 00 00 	movl   $0x70,-0x8(%ebp)
f0104370:	88 45 f7             	mov    %al,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104373:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
f0104377:	8b 55 f8             	mov    -0x8(%ebp),%edx
f010437a:	ee                   	out    %al,(%dx)
f010437b:	c7 45 f0 71 00 00 00 	movl   $0x71,-0x10(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0104382:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0104385:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0104388:	8b 55 e8             	mov    -0x18(%ebp),%edx
f010438b:	ec                   	in     (%dx),%al
f010438c:	89 c3                	mov    %eax,%ebx
f010438e:	88 5d ef             	mov    %bl,-0x11(%ebp)
	return data;
f0104391:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
	return inb(IO_RTC+1);
f0104395:	0f b6 c0             	movzbl %al,%eax
}
f0104398:	83 c4 14             	add    $0x14,%esp
f010439b:	5b                   	pop    %ebx
f010439c:	5d                   	pop    %ebp
f010439d:	c3                   	ret    

f010439e <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f010439e:	55                   	push   %ebp
f010439f:	89 e5                	mov    %esp,%ebp
f01043a1:	83 ec 10             	sub    $0x10,%esp
	outb(IO_RTC, reg);
f01043a4:	8b 45 08             	mov    0x8(%ebp),%eax
f01043a7:	0f b6 c0             	movzbl %al,%eax
f01043aa:	c7 45 fc 70 00 00 00 	movl   $0x70,-0x4(%ebp)
f01043b1:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01043b4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
f01043b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
f01043bb:	ee                   	out    %al,(%dx)
	outb(IO_RTC+1, datum);
f01043bc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01043bf:	0f b6 c0             	movzbl %al,%eax
f01043c2:	c7 45 f4 71 00 00 00 	movl   $0x71,-0xc(%ebp)
f01043c9:	88 45 f3             	mov    %al,-0xd(%ebp)
f01043cc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01043d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01043d3:	ee                   	out    %al,(%dx)
}
f01043d4:	c9                   	leave  
f01043d5:	c3                   	ret    

f01043d6 <kclock_init>:


void
kclock_init(void)
{
f01043d6:	55                   	push   %ebp
f01043d7:	89 e5                	mov    %esp,%ebp
f01043d9:	83 ec 38             	sub    $0x38,%esp
f01043dc:	c7 45 f4 43 00 00 00 	movl   $0x43,-0xc(%ebp)
f01043e3:	c6 45 f3 34          	movb   $0x34,-0xd(%ebp)
f01043e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01043eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01043ee:	ee                   	out    %al,(%dx)
f01043ef:	c7 45 ec 40 00 00 00 	movl   $0x40,-0x14(%ebp)
f01043f6:	c6 45 eb 9c          	movb   $0x9c,-0x15(%ebp)
f01043fa:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
f01043fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0104401:	ee                   	out    %al,(%dx)
f0104402:	c7 45 e4 40 00 00 00 	movl   $0x40,-0x1c(%ebp)
f0104409:	c6 45 e3 2e          	movb   $0x2e,-0x1d(%ebp)
f010440d:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f0104411:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104414:	ee                   	out    %al,(%dx)
	/* initialize 8253 clock to interrupt 100 times/sec */
	outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
	outb(IO_TIMER1, TIMER_DIV(100) % 256);
	outb(IO_TIMER1, TIMER_DIV(100) / 256);
	cprintf("	Setup timer interrupts via 8259A\n");
f0104415:	c7 04 24 64 87 10 f0 	movl   $0xf0108764,(%esp)
f010441c:	e8 6d 02 00 00       	call   f010468e <cprintf>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<0));
f0104421:	0f b7 05 38 f6 11 f0 	movzwl 0xf011f638,%eax
f0104428:	0f b7 c0             	movzwl %ax,%eax
f010442b:	25 fe ff 00 00       	and    $0xfffe,%eax
f0104430:	89 04 24             	mov    %eax,(%esp)
f0104433:	e8 4e 01 00 00       	call   f0104586 <irq_setmask_8259A>
	cprintf("	unmasked timer interrupt\n");
f0104438:	c7 04 24 87 87 10 f0 	movl   $0xf0108787,(%esp)
f010443f:	e8 4a 02 00 00       	call   f010468e <cprintf>
}
f0104444:	c9                   	leave  
f0104445:	c3                   	ret    
	...

f0104448 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0104448:	55                   	push   %ebp
f0104449:	89 e5                	mov    %esp,%ebp
f010444b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	didinit = 1;
f0104451:	c7 05 30 88 1a f0 01 	movl   $0x1,0xf01a8830
f0104458:	00 00 00 
f010445b:	c7 45 f4 21 00 00 00 	movl   $0x21,-0xc(%ebp)
f0104462:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
f0104466:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f010446a:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010446d:	ee                   	out    %al,(%dx)
f010446e:	c7 45 ec a1 00 00 00 	movl   $0xa1,-0x14(%ebp)
f0104475:	c6 45 eb ff          	movb   $0xff,-0x15(%ebp)
f0104479:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
f010447d:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0104480:	ee                   	out    %al,(%dx)
f0104481:	c7 45 e4 20 00 00 00 	movl   $0x20,-0x1c(%ebp)
f0104488:	c6 45 e3 11          	movb   $0x11,-0x1d(%ebp)
f010448c:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
f0104490:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104493:	ee                   	out    %al,(%dx)
f0104494:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
f010449b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
f010449f:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
f01044a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01044a6:	ee                   	out    %al,(%dx)
f01044a7:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
f01044ae:	c6 45 d3 04          	movb   $0x4,-0x2d(%ebp)
f01044b2:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
f01044b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01044b9:	ee                   	out    %al,(%dx)
f01044ba:	c7 45 cc 21 00 00 00 	movl   $0x21,-0x34(%ebp)
f01044c1:	c6 45 cb 03          	movb   $0x3,-0x35(%ebp)
f01044c5:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
f01044c9:	8b 55 cc             	mov    -0x34(%ebp),%edx
f01044cc:	ee                   	out    %al,(%dx)
f01044cd:	c7 45 c4 a0 00 00 00 	movl   $0xa0,-0x3c(%ebp)
f01044d4:	c6 45 c3 11          	movb   $0x11,-0x3d(%ebp)
f01044d8:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
f01044dc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01044df:	ee                   	out    %al,(%dx)
f01044e0:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
f01044e7:	c6 45 bb 28          	movb   $0x28,-0x45(%ebp)
f01044eb:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
f01044ef:	8b 55 bc             	mov    -0x44(%ebp),%edx
f01044f2:	ee                   	out    %al,(%dx)
f01044f3:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
f01044fa:	c6 45 b3 02          	movb   $0x2,-0x4d(%ebp)
f01044fe:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
f0104502:	8b 55 b4             	mov    -0x4c(%ebp),%edx
f0104505:	ee                   	out    %al,(%dx)
f0104506:	c7 45 ac a1 00 00 00 	movl   $0xa1,-0x54(%ebp)
f010450d:	c6 45 ab 01          	movb   $0x1,-0x55(%ebp)
f0104511:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
f0104515:	8b 55 ac             	mov    -0x54(%ebp),%edx
f0104518:	ee                   	out    %al,(%dx)
f0104519:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
f0104520:	c6 45 a3 68          	movb   $0x68,-0x5d(%ebp)
f0104524:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
f0104528:	8b 55 a4             	mov    -0x5c(%ebp),%edx
f010452b:	ee                   	out    %al,(%dx)
f010452c:	c7 45 9c 20 00 00 00 	movl   $0x20,-0x64(%ebp)
f0104533:	c6 45 9b 0a          	movb   $0xa,-0x65(%ebp)
f0104537:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
f010453b:	8b 55 9c             	mov    -0x64(%ebp),%edx
f010453e:	ee                   	out    %al,(%dx)
f010453f:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
f0104546:	c6 45 93 68          	movb   $0x68,-0x6d(%ebp)
f010454a:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
f010454e:	8b 55 94             	mov    -0x6c(%ebp),%edx
f0104551:	ee                   	out    %al,(%dx)
f0104552:	c7 45 8c a0 00 00 00 	movl   $0xa0,-0x74(%ebp)
f0104559:	c6 45 8b 0a          	movb   $0xa,-0x75(%ebp)
f010455d:	0f b6 45 8b          	movzbl -0x75(%ebp),%eax
f0104561:	8b 55 8c             	mov    -0x74(%ebp),%edx
f0104564:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0104565:	0f b7 05 38 f6 11 f0 	movzwl 0xf011f638,%eax
f010456c:	66 83 f8 ff          	cmp    $0xffff,%ax
f0104570:	74 12                	je     f0104584 <pic_init+0x13c>
		irq_setmask_8259A(irq_mask_8259A);
f0104572:	0f b7 05 38 f6 11 f0 	movzwl 0xf011f638,%eax
f0104579:	0f b7 c0             	movzwl %ax,%eax
f010457c:	89 04 24             	mov    %eax,(%esp)
f010457f:	e8 02 00 00 00       	call   f0104586 <irq_setmask_8259A>
}
f0104584:	c9                   	leave  
f0104585:	c3                   	ret    

f0104586 <irq_setmask_8259A>:

void
irq_setmask_8259A(uint16_t mask)
{
f0104586:	55                   	push   %ebp
f0104587:	89 e5                	mov    %esp,%ebp
f0104589:	53                   	push   %ebx
f010458a:	83 ec 44             	sub    $0x44,%esp
f010458d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104590:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
	int i;
	irq_mask_8259A = mask;
f0104594:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
f0104598:	66 a3 38 f6 11 f0    	mov    %ax,0xf011f638
	if (!didinit)
f010459e:	a1 30 88 1a f0       	mov    0xf01a8830,%eax
f01045a3:	85 c0                	test   %eax,%eax
f01045a5:	0f 84 90 00 00 00    	je     f010463b <irq_setmask_8259A+0xb5>
		return;
	outb(IO_PIC1+1, (char)mask);
f01045ab:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
f01045af:	0f b6 c0             	movzbl %al,%eax
f01045b2:	c7 45 f0 21 00 00 00 	movl   $0x21,-0x10(%ebp)
f01045b9:	88 45 ef             	mov    %al,-0x11(%ebp)
f01045bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
f01045c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01045c3:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01045c4:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
f01045c8:	66 c1 e8 08          	shr    $0x8,%ax
f01045cc:	0f b6 c0             	movzbl %al,%eax
f01045cf:	c7 45 e8 a1 00 00 00 	movl   $0xa1,-0x18(%ebp)
f01045d6:	88 45 e7             	mov    %al,-0x19(%ebp)
f01045d9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f01045dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01045e0:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01045e1:	c7 04 24 a2 87 10 f0 	movl   $0xf01087a2,(%esp)
f01045e8:	e8 a1 00 00 00       	call   f010468e <cprintf>
	for (i = 0; i < 16; i++)
f01045ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01045f4:	eb 31                	jmp    f0104627 <irq_setmask_8259A+0xa1>
		if (~mask & (1<<i))
f01045f6:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
f01045fa:	89 c2                	mov    %eax,%edx
f01045fc:	f7 d2                	not    %edx
f01045fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104601:	89 d3                	mov    %edx,%ebx
f0104603:	89 c1                	mov    %eax,%ecx
f0104605:	d3 fb                	sar    %cl,%ebx
f0104607:	89 d8                	mov    %ebx,%eax
f0104609:	83 e0 01             	and    $0x1,%eax
f010460c:	84 c0                	test   %al,%al
f010460e:	74 13                	je     f0104623 <irq_setmask_8259A+0x9d>
			cprintf(" %d", i);
f0104610:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104613:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104617:	c7 04 24 b6 87 10 f0 	movl   $0xf01087b6,(%esp)
f010461e:	e8 6b 00 00 00       	call   f010468e <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f0104623:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0104627:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
f010462b:	7e c9                	jle    f01045f6 <irq_setmask_8259A+0x70>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f010462d:	c7 04 24 ba 87 10 f0 	movl   $0xf01087ba,(%esp)
f0104634:	e8 55 00 00 00       	call   f010468e <cprintf>
f0104639:	eb 01                	jmp    f010463c <irq_setmask_8259A+0xb6>
irq_setmask_8259A(uint16_t mask)
{
	int i;
	irq_mask_8259A = mask;
	if (!didinit)
		return;
f010463b:	90                   	nop
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f010463c:	83 c4 44             	add    $0x44,%esp
f010463f:	5b                   	pop    %ebx
f0104640:	5d                   	pop    %ebp
f0104641:	c3                   	ret    
	...

f0104644 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0104644:	55                   	push   %ebp
f0104645:	89 e5                	mov    %esp,%ebp
f0104647:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f010464a:	8b 45 08             	mov    0x8(%ebp),%eax
f010464d:	89 04 24             	mov    %eax,(%esp)
f0104650:	e8 50 c4 ff ff       	call   f0100aa5 <cputchar>
	*cnt++;
f0104655:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
}
f0104659:	c9                   	leave  
f010465a:	c3                   	ret    

f010465b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010465b:	55                   	push   %ebp
f010465c:	89 e5                	mov    %esp,%ebp
f010465e:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0104661:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0104668:	8b 45 0c             	mov    0xc(%ebp),%eax
f010466b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010466f:	8b 45 08             	mov    0x8(%ebp),%eax
f0104672:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104676:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104679:	89 44 24 04          	mov    %eax,0x4(%esp)
f010467d:	c7 04 24 44 46 10 f0 	movl   $0xf0104644,(%esp)
f0104684:	e8 6f 21 00 00       	call   f01067f8 <vprintfmt>
	return cnt;
f0104689:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f010468c:	c9                   	leave  
f010468d:	c3                   	ret    

f010468e <cprintf>:

int
cprintf(const char *fmt, ...)
{
f010468e:	55                   	push   %ebp
f010468f:	89 e5                	mov    %esp,%ebp
f0104691:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0104694:	8d 45 0c             	lea    0xc(%ebp),%eax
f0104697:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
f010469a:	8b 45 08             	mov    0x8(%ebp),%eax
f010469d:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01046a0:	89 54 24 04          	mov    %edx,0x4(%esp)
f01046a4:	89 04 24             	mov    %eax,(%esp)
f01046a7:	e8 af ff ff ff       	call   f010465b <vcprintf>
f01046ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
f01046af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
f01046b2:	c9                   	leave  
f01046b3:	c3                   	ret    

f01046b4 <trapname>:
	sizeof(idt) - 1, (uint32_t) idt
};


static const char *trapname(int trapno)
{
f01046b4:	55                   	push   %ebp
f01046b5:	89 e5                	mov    %esp,%ebp
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f01046b7:	8b 45 08             	mov    0x8(%ebp),%eax
f01046ba:	83 f8 13             	cmp    $0x13,%eax
f01046bd:	77 0c                	ja     f01046cb <trapname+0x17>
		return excnames[trapno];
f01046bf:	8b 45 08             	mov    0x8(%ebp),%eax
f01046c2:	8b 04 85 e0 8a 10 f0 	mov    -0xfef7520(,%eax,4),%eax
f01046c9:	eb 25                	jmp    f01046f0 <trapname+0x3c>
	if (trapno == T_SYSCALL)
f01046cb:	83 7d 08 30          	cmpl   $0x30,0x8(%ebp)
f01046cf:	75 07                	jne    f01046d8 <trapname+0x24>
		return "System call";
f01046d1:	b8 c0 87 10 f0       	mov    $0xf01087c0,%eax
f01046d6:	eb 18                	jmp    f01046f0 <trapname+0x3c>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01046d8:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
f01046dc:	7e 0d                	jle    f01046eb <trapname+0x37>
f01046de:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
f01046e2:	7f 07                	jg     f01046eb <trapname+0x37>
		return "Hardware Interrupt";
f01046e4:	b8 cc 87 10 f0       	mov    $0xf01087cc,%eax
f01046e9:	eb 05                	jmp    f01046f0 <trapname+0x3c>
	return "(unknown trap)";
f01046eb:	b8 df 87 10 f0       	mov    $0xf01087df,%eax
}
f01046f0:	5d                   	pop    %ebp
f01046f1:	c3                   	ret    

f01046f2 <idt_init>:


void
idt_init(void)
{
f01046f2:	55                   	push   %ebp
f01046f3:	89 e5                	mov    %esp,%ebp
f01046f5:	83 ec 10             	sub    $0x10,%esp
	extern void routine_mchk ();
	extern void routine_simderr ();
	extern void system_call();
	extern void timer();
	
	SETGATE (idt[T_DIVIDE], 0, GD_KT, routine_divide, 0);
f01046f8:	b8 a8 56 10 f0       	mov    $0xf01056a8,%eax
f01046fd:	66 a3 40 88 1a f0    	mov    %ax,0xf01a8840
f0104703:	66 c7 05 42 88 1a f0 	movw   $0x8,0xf01a8842
f010470a:	08 00 
f010470c:	0f b6 05 44 88 1a f0 	movzbl 0xf01a8844,%eax
f0104713:	83 e0 e0             	and    $0xffffffe0,%eax
f0104716:	a2 44 88 1a f0       	mov    %al,0xf01a8844
f010471b:	0f b6 05 44 88 1a f0 	movzbl 0xf01a8844,%eax
f0104722:	83 e0 1f             	and    $0x1f,%eax
f0104725:	a2 44 88 1a f0       	mov    %al,0xf01a8844
f010472a:	0f b6 05 45 88 1a f0 	movzbl 0xf01a8845,%eax
f0104731:	83 e0 f0             	and    $0xfffffff0,%eax
f0104734:	83 c8 0e             	or     $0xe,%eax
f0104737:	a2 45 88 1a f0       	mov    %al,0xf01a8845
f010473c:	0f b6 05 45 88 1a f0 	movzbl 0xf01a8845,%eax
f0104743:	83 e0 ef             	and    $0xffffffef,%eax
f0104746:	a2 45 88 1a f0       	mov    %al,0xf01a8845
f010474b:	0f b6 05 45 88 1a f0 	movzbl 0xf01a8845,%eax
f0104752:	83 e0 9f             	and    $0xffffff9f,%eax
f0104755:	a2 45 88 1a f0       	mov    %al,0xf01a8845
f010475a:	0f b6 05 45 88 1a f0 	movzbl 0xf01a8845,%eax
f0104761:	83 c8 80             	or     $0xffffff80,%eax
f0104764:	a2 45 88 1a f0       	mov    %al,0xf01a8845
f0104769:	b8 a8 56 10 f0       	mov    $0xf01056a8,%eax
f010476e:	c1 e8 10             	shr    $0x10,%eax
f0104771:	66 a3 46 88 1a f0    	mov    %ax,0xf01a8846
	SETGATE (idt[T_DEBUG], 0, GD_KT, routine_debug, 0);
f0104777:	b8 ae 56 10 f0       	mov    $0xf01056ae,%eax
f010477c:	66 a3 48 88 1a f0    	mov    %ax,0xf01a8848
f0104782:	66 c7 05 4a 88 1a f0 	movw   $0x8,0xf01a884a
f0104789:	08 00 
f010478b:	0f b6 05 4c 88 1a f0 	movzbl 0xf01a884c,%eax
f0104792:	83 e0 e0             	and    $0xffffffe0,%eax
f0104795:	a2 4c 88 1a f0       	mov    %al,0xf01a884c
f010479a:	0f b6 05 4c 88 1a f0 	movzbl 0xf01a884c,%eax
f01047a1:	83 e0 1f             	and    $0x1f,%eax
f01047a4:	a2 4c 88 1a f0       	mov    %al,0xf01a884c
f01047a9:	0f b6 05 4d 88 1a f0 	movzbl 0xf01a884d,%eax
f01047b0:	83 e0 f0             	and    $0xfffffff0,%eax
f01047b3:	83 c8 0e             	or     $0xe,%eax
f01047b6:	a2 4d 88 1a f0       	mov    %al,0xf01a884d
f01047bb:	0f b6 05 4d 88 1a f0 	movzbl 0xf01a884d,%eax
f01047c2:	83 e0 ef             	and    $0xffffffef,%eax
f01047c5:	a2 4d 88 1a f0       	mov    %al,0xf01a884d
f01047ca:	0f b6 05 4d 88 1a f0 	movzbl 0xf01a884d,%eax
f01047d1:	83 e0 9f             	and    $0xffffff9f,%eax
f01047d4:	a2 4d 88 1a f0       	mov    %al,0xf01a884d
f01047d9:	0f b6 05 4d 88 1a f0 	movzbl 0xf01a884d,%eax
f01047e0:	83 c8 80             	or     $0xffffff80,%eax
f01047e3:	a2 4d 88 1a f0       	mov    %al,0xf01a884d
f01047e8:	b8 ae 56 10 f0       	mov    $0xf01056ae,%eax
f01047ed:	c1 e8 10             	shr    $0x10,%eax
f01047f0:	66 a3 4e 88 1a f0    	mov    %ax,0xf01a884e
	SETGATE (idt[T_NMI], 0, GD_KT, routine_nmi, 0);
f01047f6:	b8 b4 56 10 f0       	mov    $0xf01056b4,%eax
f01047fb:	66 a3 50 88 1a f0    	mov    %ax,0xf01a8850
f0104801:	66 c7 05 52 88 1a f0 	movw   $0x8,0xf01a8852
f0104808:	08 00 
f010480a:	0f b6 05 54 88 1a f0 	movzbl 0xf01a8854,%eax
f0104811:	83 e0 e0             	and    $0xffffffe0,%eax
f0104814:	a2 54 88 1a f0       	mov    %al,0xf01a8854
f0104819:	0f b6 05 54 88 1a f0 	movzbl 0xf01a8854,%eax
f0104820:	83 e0 1f             	and    $0x1f,%eax
f0104823:	a2 54 88 1a f0       	mov    %al,0xf01a8854
f0104828:	0f b6 05 55 88 1a f0 	movzbl 0xf01a8855,%eax
f010482f:	83 e0 f0             	and    $0xfffffff0,%eax
f0104832:	83 c8 0e             	or     $0xe,%eax
f0104835:	a2 55 88 1a f0       	mov    %al,0xf01a8855
f010483a:	0f b6 05 55 88 1a f0 	movzbl 0xf01a8855,%eax
f0104841:	83 e0 ef             	and    $0xffffffef,%eax
f0104844:	a2 55 88 1a f0       	mov    %al,0xf01a8855
f0104849:	0f b6 05 55 88 1a f0 	movzbl 0xf01a8855,%eax
f0104850:	83 e0 9f             	and    $0xffffff9f,%eax
f0104853:	a2 55 88 1a f0       	mov    %al,0xf01a8855
f0104858:	0f b6 05 55 88 1a f0 	movzbl 0xf01a8855,%eax
f010485f:	83 c8 80             	or     $0xffffff80,%eax
f0104862:	a2 55 88 1a f0       	mov    %al,0xf01a8855
f0104867:	b8 b4 56 10 f0       	mov    $0xf01056b4,%eax
f010486c:	c1 e8 10             	shr    $0x10,%eax
f010486f:	66 a3 56 88 1a f0    	mov    %ax,0xf01a8856
	// break point needs no kernel mode privilege
	SETGATE (idt[T_BRKPT], 0, GD_KT, routine_brkpt, 3);
f0104875:	b8 ba 56 10 f0       	mov    $0xf01056ba,%eax
f010487a:	66 a3 58 88 1a f0    	mov    %ax,0xf01a8858
f0104880:	66 c7 05 5a 88 1a f0 	movw   $0x8,0xf01a885a
f0104887:	08 00 
f0104889:	0f b6 05 5c 88 1a f0 	movzbl 0xf01a885c,%eax
f0104890:	83 e0 e0             	and    $0xffffffe0,%eax
f0104893:	a2 5c 88 1a f0       	mov    %al,0xf01a885c
f0104898:	0f b6 05 5c 88 1a f0 	movzbl 0xf01a885c,%eax
f010489f:	83 e0 1f             	and    $0x1f,%eax
f01048a2:	a2 5c 88 1a f0       	mov    %al,0xf01a885c
f01048a7:	0f b6 05 5d 88 1a f0 	movzbl 0xf01a885d,%eax
f01048ae:	83 e0 f0             	and    $0xfffffff0,%eax
f01048b1:	83 c8 0e             	or     $0xe,%eax
f01048b4:	a2 5d 88 1a f0       	mov    %al,0xf01a885d
f01048b9:	0f b6 05 5d 88 1a f0 	movzbl 0xf01a885d,%eax
f01048c0:	83 e0 ef             	and    $0xffffffef,%eax
f01048c3:	a2 5d 88 1a f0       	mov    %al,0xf01a885d
f01048c8:	0f b6 05 5d 88 1a f0 	movzbl 0xf01a885d,%eax
f01048cf:	83 c8 60             	or     $0x60,%eax
f01048d2:	a2 5d 88 1a f0       	mov    %al,0xf01a885d
f01048d7:	0f b6 05 5d 88 1a f0 	movzbl 0xf01a885d,%eax
f01048de:	83 c8 80             	or     $0xffffff80,%eax
f01048e1:	a2 5d 88 1a f0       	mov    %al,0xf01a885d
f01048e6:	b8 ba 56 10 f0       	mov    $0xf01056ba,%eax
f01048eb:	c1 e8 10             	shr    $0x10,%eax
f01048ee:	66 a3 5e 88 1a f0    	mov    %ax,0xf01a885e
	SETGATE (idt[T_OFLOW], 0, GD_KT, routine_oflow, 0);
f01048f4:	b8 c0 56 10 f0       	mov    $0xf01056c0,%eax
f01048f9:	66 a3 60 88 1a f0    	mov    %ax,0xf01a8860
f01048ff:	66 c7 05 62 88 1a f0 	movw   $0x8,0xf01a8862
f0104906:	08 00 
f0104908:	0f b6 05 64 88 1a f0 	movzbl 0xf01a8864,%eax
f010490f:	83 e0 e0             	and    $0xffffffe0,%eax
f0104912:	a2 64 88 1a f0       	mov    %al,0xf01a8864
f0104917:	0f b6 05 64 88 1a f0 	movzbl 0xf01a8864,%eax
f010491e:	83 e0 1f             	and    $0x1f,%eax
f0104921:	a2 64 88 1a f0       	mov    %al,0xf01a8864
f0104926:	0f b6 05 65 88 1a f0 	movzbl 0xf01a8865,%eax
f010492d:	83 e0 f0             	and    $0xfffffff0,%eax
f0104930:	83 c8 0e             	or     $0xe,%eax
f0104933:	a2 65 88 1a f0       	mov    %al,0xf01a8865
f0104938:	0f b6 05 65 88 1a f0 	movzbl 0xf01a8865,%eax
f010493f:	83 e0 ef             	and    $0xffffffef,%eax
f0104942:	a2 65 88 1a f0       	mov    %al,0xf01a8865
f0104947:	0f b6 05 65 88 1a f0 	movzbl 0xf01a8865,%eax
f010494e:	83 e0 9f             	and    $0xffffff9f,%eax
f0104951:	a2 65 88 1a f0       	mov    %al,0xf01a8865
f0104956:	0f b6 05 65 88 1a f0 	movzbl 0xf01a8865,%eax
f010495d:	83 c8 80             	or     $0xffffff80,%eax
f0104960:	a2 65 88 1a f0       	mov    %al,0xf01a8865
f0104965:	b8 c0 56 10 f0       	mov    $0xf01056c0,%eax
f010496a:	c1 e8 10             	shr    $0x10,%eax
f010496d:	66 a3 66 88 1a f0    	mov    %ax,0xf01a8866
	SETGATE (idt[T_BOUND], 0, GD_KT, routine_bound, 0);
f0104973:	b8 c6 56 10 f0       	mov    $0xf01056c6,%eax
f0104978:	66 a3 68 88 1a f0    	mov    %ax,0xf01a8868
f010497e:	66 c7 05 6a 88 1a f0 	movw   $0x8,0xf01a886a
f0104985:	08 00 
f0104987:	0f b6 05 6c 88 1a f0 	movzbl 0xf01a886c,%eax
f010498e:	83 e0 e0             	and    $0xffffffe0,%eax
f0104991:	a2 6c 88 1a f0       	mov    %al,0xf01a886c
f0104996:	0f b6 05 6c 88 1a f0 	movzbl 0xf01a886c,%eax
f010499d:	83 e0 1f             	and    $0x1f,%eax
f01049a0:	a2 6c 88 1a f0       	mov    %al,0xf01a886c
f01049a5:	0f b6 05 6d 88 1a f0 	movzbl 0xf01a886d,%eax
f01049ac:	83 e0 f0             	and    $0xfffffff0,%eax
f01049af:	83 c8 0e             	or     $0xe,%eax
f01049b2:	a2 6d 88 1a f0       	mov    %al,0xf01a886d
f01049b7:	0f b6 05 6d 88 1a f0 	movzbl 0xf01a886d,%eax
f01049be:	83 e0 ef             	and    $0xffffffef,%eax
f01049c1:	a2 6d 88 1a f0       	mov    %al,0xf01a886d
f01049c6:	0f b6 05 6d 88 1a f0 	movzbl 0xf01a886d,%eax
f01049cd:	83 e0 9f             	and    $0xffffff9f,%eax
f01049d0:	a2 6d 88 1a f0       	mov    %al,0xf01a886d
f01049d5:	0f b6 05 6d 88 1a f0 	movzbl 0xf01a886d,%eax
f01049dc:	83 c8 80             	or     $0xffffff80,%eax
f01049df:	a2 6d 88 1a f0       	mov    %al,0xf01a886d
f01049e4:	b8 c6 56 10 f0       	mov    $0xf01056c6,%eax
f01049e9:	c1 e8 10             	shr    $0x10,%eax
f01049ec:	66 a3 6e 88 1a f0    	mov    %ax,0xf01a886e
	SETGATE (idt[T_ILLOP], 0, GD_KT, routine_illop, 0);
f01049f2:	b8 cc 56 10 f0       	mov    $0xf01056cc,%eax
f01049f7:	66 a3 70 88 1a f0    	mov    %ax,0xf01a8870
f01049fd:	66 c7 05 72 88 1a f0 	movw   $0x8,0xf01a8872
f0104a04:	08 00 
f0104a06:	0f b6 05 74 88 1a f0 	movzbl 0xf01a8874,%eax
f0104a0d:	83 e0 e0             	and    $0xffffffe0,%eax
f0104a10:	a2 74 88 1a f0       	mov    %al,0xf01a8874
f0104a15:	0f b6 05 74 88 1a f0 	movzbl 0xf01a8874,%eax
f0104a1c:	83 e0 1f             	and    $0x1f,%eax
f0104a1f:	a2 74 88 1a f0       	mov    %al,0xf01a8874
f0104a24:	0f b6 05 75 88 1a f0 	movzbl 0xf01a8875,%eax
f0104a2b:	83 e0 f0             	and    $0xfffffff0,%eax
f0104a2e:	83 c8 0e             	or     $0xe,%eax
f0104a31:	a2 75 88 1a f0       	mov    %al,0xf01a8875
f0104a36:	0f b6 05 75 88 1a f0 	movzbl 0xf01a8875,%eax
f0104a3d:	83 e0 ef             	and    $0xffffffef,%eax
f0104a40:	a2 75 88 1a f0       	mov    %al,0xf01a8875
f0104a45:	0f b6 05 75 88 1a f0 	movzbl 0xf01a8875,%eax
f0104a4c:	83 e0 9f             	and    $0xffffff9f,%eax
f0104a4f:	a2 75 88 1a f0       	mov    %al,0xf01a8875
f0104a54:	0f b6 05 75 88 1a f0 	movzbl 0xf01a8875,%eax
f0104a5b:	83 c8 80             	or     $0xffffff80,%eax
f0104a5e:	a2 75 88 1a f0       	mov    %al,0xf01a8875
f0104a63:	b8 cc 56 10 f0       	mov    $0xf01056cc,%eax
f0104a68:	c1 e8 10             	shr    $0x10,%eax
f0104a6b:	66 a3 76 88 1a f0    	mov    %ax,0xf01a8876
	SETGATE (idt[T_DEVICE], 0, GD_KT, routine_device, 0);
f0104a71:	b8 d2 56 10 f0       	mov    $0xf01056d2,%eax
f0104a76:	66 a3 78 88 1a f0    	mov    %ax,0xf01a8878
f0104a7c:	66 c7 05 7a 88 1a f0 	movw   $0x8,0xf01a887a
f0104a83:	08 00 
f0104a85:	0f b6 05 7c 88 1a f0 	movzbl 0xf01a887c,%eax
f0104a8c:	83 e0 e0             	and    $0xffffffe0,%eax
f0104a8f:	a2 7c 88 1a f0       	mov    %al,0xf01a887c
f0104a94:	0f b6 05 7c 88 1a f0 	movzbl 0xf01a887c,%eax
f0104a9b:	83 e0 1f             	and    $0x1f,%eax
f0104a9e:	a2 7c 88 1a f0       	mov    %al,0xf01a887c
f0104aa3:	0f b6 05 7d 88 1a f0 	movzbl 0xf01a887d,%eax
f0104aaa:	83 e0 f0             	and    $0xfffffff0,%eax
f0104aad:	83 c8 0e             	or     $0xe,%eax
f0104ab0:	a2 7d 88 1a f0       	mov    %al,0xf01a887d
f0104ab5:	0f b6 05 7d 88 1a f0 	movzbl 0xf01a887d,%eax
f0104abc:	83 e0 ef             	and    $0xffffffef,%eax
f0104abf:	a2 7d 88 1a f0       	mov    %al,0xf01a887d
f0104ac4:	0f b6 05 7d 88 1a f0 	movzbl 0xf01a887d,%eax
f0104acb:	83 e0 9f             	and    $0xffffff9f,%eax
f0104ace:	a2 7d 88 1a f0       	mov    %al,0xf01a887d
f0104ad3:	0f b6 05 7d 88 1a f0 	movzbl 0xf01a887d,%eax
f0104ada:	83 c8 80             	or     $0xffffff80,%eax
f0104add:	a2 7d 88 1a f0       	mov    %al,0xf01a887d
f0104ae2:	b8 d2 56 10 f0       	mov    $0xf01056d2,%eax
f0104ae7:	c1 e8 10             	shr    $0x10,%eax
f0104aea:	66 a3 7e 88 1a f0    	mov    %ax,0xf01a887e
	SETGATE (idt[T_DBLFLT], 0, GD_KT, routine_dblflt, 0);
f0104af0:	b8 d8 56 10 f0       	mov    $0xf01056d8,%eax
f0104af5:	66 a3 80 88 1a f0    	mov    %ax,0xf01a8880
f0104afb:	66 c7 05 82 88 1a f0 	movw   $0x8,0xf01a8882
f0104b02:	08 00 
f0104b04:	0f b6 05 84 88 1a f0 	movzbl 0xf01a8884,%eax
f0104b0b:	83 e0 e0             	and    $0xffffffe0,%eax
f0104b0e:	a2 84 88 1a f0       	mov    %al,0xf01a8884
f0104b13:	0f b6 05 84 88 1a f0 	movzbl 0xf01a8884,%eax
f0104b1a:	83 e0 1f             	and    $0x1f,%eax
f0104b1d:	a2 84 88 1a f0       	mov    %al,0xf01a8884
f0104b22:	0f b6 05 85 88 1a f0 	movzbl 0xf01a8885,%eax
f0104b29:	83 e0 f0             	and    $0xfffffff0,%eax
f0104b2c:	83 c8 0e             	or     $0xe,%eax
f0104b2f:	a2 85 88 1a f0       	mov    %al,0xf01a8885
f0104b34:	0f b6 05 85 88 1a f0 	movzbl 0xf01a8885,%eax
f0104b3b:	83 e0 ef             	and    $0xffffffef,%eax
f0104b3e:	a2 85 88 1a f0       	mov    %al,0xf01a8885
f0104b43:	0f b6 05 85 88 1a f0 	movzbl 0xf01a8885,%eax
f0104b4a:	83 e0 9f             	and    $0xffffff9f,%eax
f0104b4d:	a2 85 88 1a f0       	mov    %al,0xf01a8885
f0104b52:	0f b6 05 85 88 1a f0 	movzbl 0xf01a8885,%eax
f0104b59:	83 c8 80             	or     $0xffffff80,%eax
f0104b5c:	a2 85 88 1a f0       	mov    %al,0xf01a8885
f0104b61:	b8 d8 56 10 f0       	mov    $0xf01056d8,%eax
f0104b66:	c1 e8 10             	shr    $0x10,%eax
f0104b69:	66 a3 86 88 1a f0    	mov    %ax,0xf01a8886
	SETGATE (idt[T_TSS], 0, GD_KT, routine_tss, 0);
f0104b6f:	b8 dc 56 10 f0       	mov    $0xf01056dc,%eax
f0104b74:	66 a3 90 88 1a f0    	mov    %ax,0xf01a8890
f0104b7a:	66 c7 05 92 88 1a f0 	movw   $0x8,0xf01a8892
f0104b81:	08 00 
f0104b83:	0f b6 05 94 88 1a f0 	movzbl 0xf01a8894,%eax
f0104b8a:	83 e0 e0             	and    $0xffffffe0,%eax
f0104b8d:	a2 94 88 1a f0       	mov    %al,0xf01a8894
f0104b92:	0f b6 05 94 88 1a f0 	movzbl 0xf01a8894,%eax
f0104b99:	83 e0 1f             	and    $0x1f,%eax
f0104b9c:	a2 94 88 1a f0       	mov    %al,0xf01a8894
f0104ba1:	0f b6 05 95 88 1a f0 	movzbl 0xf01a8895,%eax
f0104ba8:	83 e0 f0             	and    $0xfffffff0,%eax
f0104bab:	83 c8 0e             	or     $0xe,%eax
f0104bae:	a2 95 88 1a f0       	mov    %al,0xf01a8895
f0104bb3:	0f b6 05 95 88 1a f0 	movzbl 0xf01a8895,%eax
f0104bba:	83 e0 ef             	and    $0xffffffef,%eax
f0104bbd:	a2 95 88 1a f0       	mov    %al,0xf01a8895
f0104bc2:	0f b6 05 95 88 1a f0 	movzbl 0xf01a8895,%eax
f0104bc9:	83 e0 9f             	and    $0xffffff9f,%eax
f0104bcc:	a2 95 88 1a f0       	mov    %al,0xf01a8895
f0104bd1:	0f b6 05 95 88 1a f0 	movzbl 0xf01a8895,%eax
f0104bd8:	83 c8 80             	or     $0xffffff80,%eax
f0104bdb:	a2 95 88 1a f0       	mov    %al,0xf01a8895
f0104be0:	b8 dc 56 10 f0       	mov    $0xf01056dc,%eax
f0104be5:	c1 e8 10             	shr    $0x10,%eax
f0104be8:	66 a3 96 88 1a f0    	mov    %ax,0xf01a8896
	SETGATE (idt[T_SEGNP], 0, GD_KT, routine_segnp, 0);
f0104bee:	b8 e0 56 10 f0       	mov    $0xf01056e0,%eax
f0104bf3:	66 a3 98 88 1a f0    	mov    %ax,0xf01a8898
f0104bf9:	66 c7 05 9a 88 1a f0 	movw   $0x8,0xf01a889a
f0104c00:	08 00 
f0104c02:	0f b6 05 9c 88 1a f0 	movzbl 0xf01a889c,%eax
f0104c09:	83 e0 e0             	and    $0xffffffe0,%eax
f0104c0c:	a2 9c 88 1a f0       	mov    %al,0xf01a889c
f0104c11:	0f b6 05 9c 88 1a f0 	movzbl 0xf01a889c,%eax
f0104c18:	83 e0 1f             	and    $0x1f,%eax
f0104c1b:	a2 9c 88 1a f0       	mov    %al,0xf01a889c
f0104c20:	0f b6 05 9d 88 1a f0 	movzbl 0xf01a889d,%eax
f0104c27:	83 e0 f0             	and    $0xfffffff0,%eax
f0104c2a:	83 c8 0e             	or     $0xe,%eax
f0104c2d:	a2 9d 88 1a f0       	mov    %al,0xf01a889d
f0104c32:	0f b6 05 9d 88 1a f0 	movzbl 0xf01a889d,%eax
f0104c39:	83 e0 ef             	and    $0xffffffef,%eax
f0104c3c:	a2 9d 88 1a f0       	mov    %al,0xf01a889d
f0104c41:	0f b6 05 9d 88 1a f0 	movzbl 0xf01a889d,%eax
f0104c48:	83 e0 9f             	and    $0xffffff9f,%eax
f0104c4b:	a2 9d 88 1a f0       	mov    %al,0xf01a889d
f0104c50:	0f b6 05 9d 88 1a f0 	movzbl 0xf01a889d,%eax
f0104c57:	83 c8 80             	or     $0xffffff80,%eax
f0104c5a:	a2 9d 88 1a f0       	mov    %al,0xf01a889d
f0104c5f:	b8 e0 56 10 f0       	mov    $0xf01056e0,%eax
f0104c64:	c1 e8 10             	shr    $0x10,%eax
f0104c67:	66 a3 9e 88 1a f0    	mov    %ax,0xf01a889e
	SETGATE (idt[T_STACK], 0, GD_KT, routine_stack, 0);
f0104c6d:	b8 e4 56 10 f0       	mov    $0xf01056e4,%eax
f0104c72:	66 a3 a0 88 1a f0    	mov    %ax,0xf01a88a0
f0104c78:	66 c7 05 a2 88 1a f0 	movw   $0x8,0xf01a88a2
f0104c7f:	08 00 
f0104c81:	0f b6 05 a4 88 1a f0 	movzbl 0xf01a88a4,%eax
f0104c88:	83 e0 e0             	and    $0xffffffe0,%eax
f0104c8b:	a2 a4 88 1a f0       	mov    %al,0xf01a88a4
f0104c90:	0f b6 05 a4 88 1a f0 	movzbl 0xf01a88a4,%eax
f0104c97:	83 e0 1f             	and    $0x1f,%eax
f0104c9a:	a2 a4 88 1a f0       	mov    %al,0xf01a88a4
f0104c9f:	0f b6 05 a5 88 1a f0 	movzbl 0xf01a88a5,%eax
f0104ca6:	83 e0 f0             	and    $0xfffffff0,%eax
f0104ca9:	83 c8 0e             	or     $0xe,%eax
f0104cac:	a2 a5 88 1a f0       	mov    %al,0xf01a88a5
f0104cb1:	0f b6 05 a5 88 1a f0 	movzbl 0xf01a88a5,%eax
f0104cb8:	83 e0 ef             	and    $0xffffffef,%eax
f0104cbb:	a2 a5 88 1a f0       	mov    %al,0xf01a88a5
f0104cc0:	0f b6 05 a5 88 1a f0 	movzbl 0xf01a88a5,%eax
f0104cc7:	83 e0 9f             	and    $0xffffff9f,%eax
f0104cca:	a2 a5 88 1a f0       	mov    %al,0xf01a88a5
f0104ccf:	0f b6 05 a5 88 1a f0 	movzbl 0xf01a88a5,%eax
f0104cd6:	83 c8 80             	or     $0xffffff80,%eax
f0104cd9:	a2 a5 88 1a f0       	mov    %al,0xf01a88a5
f0104cde:	b8 e4 56 10 f0       	mov    $0xf01056e4,%eax
f0104ce3:	c1 e8 10             	shr    $0x10,%eax
f0104ce6:	66 a3 a6 88 1a f0    	mov    %ax,0xf01a88a6
	SETGATE (idt[T_GPFLT], 0, GD_KT, routine_gpflt, 0);
f0104cec:	b8 e8 56 10 f0       	mov    $0xf01056e8,%eax
f0104cf1:	66 a3 a8 88 1a f0    	mov    %ax,0xf01a88a8
f0104cf7:	66 c7 05 aa 88 1a f0 	movw   $0x8,0xf01a88aa
f0104cfe:	08 00 
f0104d00:	0f b6 05 ac 88 1a f0 	movzbl 0xf01a88ac,%eax
f0104d07:	83 e0 e0             	and    $0xffffffe0,%eax
f0104d0a:	a2 ac 88 1a f0       	mov    %al,0xf01a88ac
f0104d0f:	0f b6 05 ac 88 1a f0 	movzbl 0xf01a88ac,%eax
f0104d16:	83 e0 1f             	and    $0x1f,%eax
f0104d19:	a2 ac 88 1a f0       	mov    %al,0xf01a88ac
f0104d1e:	0f b6 05 ad 88 1a f0 	movzbl 0xf01a88ad,%eax
f0104d25:	83 e0 f0             	and    $0xfffffff0,%eax
f0104d28:	83 c8 0e             	or     $0xe,%eax
f0104d2b:	a2 ad 88 1a f0       	mov    %al,0xf01a88ad
f0104d30:	0f b6 05 ad 88 1a f0 	movzbl 0xf01a88ad,%eax
f0104d37:	83 e0 ef             	and    $0xffffffef,%eax
f0104d3a:	a2 ad 88 1a f0       	mov    %al,0xf01a88ad
f0104d3f:	0f b6 05 ad 88 1a f0 	movzbl 0xf01a88ad,%eax
f0104d46:	83 e0 9f             	and    $0xffffff9f,%eax
f0104d49:	a2 ad 88 1a f0       	mov    %al,0xf01a88ad
f0104d4e:	0f b6 05 ad 88 1a f0 	movzbl 0xf01a88ad,%eax
f0104d55:	83 c8 80             	or     $0xffffff80,%eax
f0104d58:	a2 ad 88 1a f0       	mov    %al,0xf01a88ad
f0104d5d:	b8 e8 56 10 f0       	mov    $0xf01056e8,%eax
f0104d62:	c1 e8 10             	shr    $0x10,%eax
f0104d65:	66 a3 ae 88 1a f0    	mov    %ax,0xf01a88ae
	SETGATE (idt[T_PGFLT], 0, GD_KT, routine_pgflt, 0);
f0104d6b:	b8 ec 56 10 f0       	mov    $0xf01056ec,%eax
f0104d70:	66 a3 b0 88 1a f0    	mov    %ax,0xf01a88b0
f0104d76:	66 c7 05 b2 88 1a f0 	movw   $0x8,0xf01a88b2
f0104d7d:	08 00 
f0104d7f:	0f b6 05 b4 88 1a f0 	movzbl 0xf01a88b4,%eax
f0104d86:	83 e0 e0             	and    $0xffffffe0,%eax
f0104d89:	a2 b4 88 1a f0       	mov    %al,0xf01a88b4
f0104d8e:	0f b6 05 b4 88 1a f0 	movzbl 0xf01a88b4,%eax
f0104d95:	83 e0 1f             	and    $0x1f,%eax
f0104d98:	a2 b4 88 1a f0       	mov    %al,0xf01a88b4
f0104d9d:	0f b6 05 b5 88 1a f0 	movzbl 0xf01a88b5,%eax
f0104da4:	83 e0 f0             	and    $0xfffffff0,%eax
f0104da7:	83 c8 0e             	or     $0xe,%eax
f0104daa:	a2 b5 88 1a f0       	mov    %al,0xf01a88b5
f0104daf:	0f b6 05 b5 88 1a f0 	movzbl 0xf01a88b5,%eax
f0104db6:	83 e0 ef             	and    $0xffffffef,%eax
f0104db9:	a2 b5 88 1a f0       	mov    %al,0xf01a88b5
f0104dbe:	0f b6 05 b5 88 1a f0 	movzbl 0xf01a88b5,%eax
f0104dc5:	83 e0 9f             	and    $0xffffff9f,%eax
f0104dc8:	a2 b5 88 1a f0       	mov    %al,0xf01a88b5
f0104dcd:	0f b6 05 b5 88 1a f0 	movzbl 0xf01a88b5,%eax
f0104dd4:	83 c8 80             	or     $0xffffff80,%eax
f0104dd7:	a2 b5 88 1a f0       	mov    %al,0xf01a88b5
f0104ddc:	b8 ec 56 10 f0       	mov    $0xf01056ec,%eax
f0104de1:	c1 e8 10             	shr    $0x10,%eax
f0104de4:	66 a3 b6 88 1a f0    	mov    %ax,0xf01a88b6
	SETGATE (idt[T_FPERR], 0, GD_KT, routine_fperr, 0);
f0104dea:	b8 f0 56 10 f0       	mov    $0xf01056f0,%eax
f0104def:	66 a3 c0 88 1a f0    	mov    %ax,0xf01a88c0
f0104df5:	66 c7 05 c2 88 1a f0 	movw   $0x8,0xf01a88c2
f0104dfc:	08 00 
f0104dfe:	0f b6 05 c4 88 1a f0 	movzbl 0xf01a88c4,%eax
f0104e05:	83 e0 e0             	and    $0xffffffe0,%eax
f0104e08:	a2 c4 88 1a f0       	mov    %al,0xf01a88c4
f0104e0d:	0f b6 05 c4 88 1a f0 	movzbl 0xf01a88c4,%eax
f0104e14:	83 e0 1f             	and    $0x1f,%eax
f0104e17:	a2 c4 88 1a f0       	mov    %al,0xf01a88c4
f0104e1c:	0f b6 05 c5 88 1a f0 	movzbl 0xf01a88c5,%eax
f0104e23:	83 e0 f0             	and    $0xfffffff0,%eax
f0104e26:	83 c8 0e             	or     $0xe,%eax
f0104e29:	a2 c5 88 1a f0       	mov    %al,0xf01a88c5
f0104e2e:	0f b6 05 c5 88 1a f0 	movzbl 0xf01a88c5,%eax
f0104e35:	83 e0 ef             	and    $0xffffffef,%eax
f0104e38:	a2 c5 88 1a f0       	mov    %al,0xf01a88c5
f0104e3d:	0f b6 05 c5 88 1a f0 	movzbl 0xf01a88c5,%eax
f0104e44:	83 e0 9f             	and    $0xffffff9f,%eax
f0104e47:	a2 c5 88 1a f0       	mov    %al,0xf01a88c5
f0104e4c:	0f b6 05 c5 88 1a f0 	movzbl 0xf01a88c5,%eax
f0104e53:	83 c8 80             	or     $0xffffff80,%eax
f0104e56:	a2 c5 88 1a f0       	mov    %al,0xf01a88c5
f0104e5b:	b8 f0 56 10 f0       	mov    $0xf01056f0,%eax
f0104e60:	c1 e8 10             	shr    $0x10,%eax
f0104e63:	66 a3 c6 88 1a f0    	mov    %ax,0xf01a88c6
	SETGATE (idt[T_ALIGN], 0, GD_KT, routine_align, 0);
f0104e69:	b8 f6 56 10 f0       	mov    $0xf01056f6,%eax
f0104e6e:	66 a3 c8 88 1a f0    	mov    %ax,0xf01a88c8
f0104e74:	66 c7 05 ca 88 1a f0 	movw   $0x8,0xf01a88ca
f0104e7b:	08 00 
f0104e7d:	0f b6 05 cc 88 1a f0 	movzbl 0xf01a88cc,%eax
f0104e84:	83 e0 e0             	and    $0xffffffe0,%eax
f0104e87:	a2 cc 88 1a f0       	mov    %al,0xf01a88cc
f0104e8c:	0f b6 05 cc 88 1a f0 	movzbl 0xf01a88cc,%eax
f0104e93:	83 e0 1f             	and    $0x1f,%eax
f0104e96:	a2 cc 88 1a f0       	mov    %al,0xf01a88cc
f0104e9b:	0f b6 05 cd 88 1a f0 	movzbl 0xf01a88cd,%eax
f0104ea2:	83 e0 f0             	and    $0xfffffff0,%eax
f0104ea5:	83 c8 0e             	or     $0xe,%eax
f0104ea8:	a2 cd 88 1a f0       	mov    %al,0xf01a88cd
f0104ead:	0f b6 05 cd 88 1a f0 	movzbl 0xf01a88cd,%eax
f0104eb4:	83 e0 ef             	and    $0xffffffef,%eax
f0104eb7:	a2 cd 88 1a f0       	mov    %al,0xf01a88cd
f0104ebc:	0f b6 05 cd 88 1a f0 	movzbl 0xf01a88cd,%eax
f0104ec3:	83 e0 9f             	and    $0xffffff9f,%eax
f0104ec6:	a2 cd 88 1a f0       	mov    %al,0xf01a88cd
f0104ecb:	0f b6 05 cd 88 1a f0 	movzbl 0xf01a88cd,%eax
f0104ed2:	83 c8 80             	or     $0xffffff80,%eax
f0104ed5:	a2 cd 88 1a f0       	mov    %al,0xf01a88cd
f0104eda:	b8 f6 56 10 f0       	mov    $0xf01056f6,%eax
f0104edf:	c1 e8 10             	shr    $0x10,%eax
f0104ee2:	66 a3 ce 88 1a f0    	mov    %ax,0xf01a88ce
	SETGATE (idt[T_MCHK], 0, GD_KT, routine_mchk, 0);
f0104ee8:	b8 fa 56 10 f0       	mov    $0xf01056fa,%eax
f0104eed:	66 a3 d0 88 1a f0    	mov    %ax,0xf01a88d0
f0104ef3:	66 c7 05 d2 88 1a f0 	movw   $0x8,0xf01a88d2
f0104efa:	08 00 
f0104efc:	0f b6 05 d4 88 1a f0 	movzbl 0xf01a88d4,%eax
f0104f03:	83 e0 e0             	and    $0xffffffe0,%eax
f0104f06:	a2 d4 88 1a f0       	mov    %al,0xf01a88d4
f0104f0b:	0f b6 05 d4 88 1a f0 	movzbl 0xf01a88d4,%eax
f0104f12:	83 e0 1f             	and    $0x1f,%eax
f0104f15:	a2 d4 88 1a f0       	mov    %al,0xf01a88d4
f0104f1a:	0f b6 05 d5 88 1a f0 	movzbl 0xf01a88d5,%eax
f0104f21:	83 e0 f0             	and    $0xfffffff0,%eax
f0104f24:	83 c8 0e             	or     $0xe,%eax
f0104f27:	a2 d5 88 1a f0       	mov    %al,0xf01a88d5
f0104f2c:	0f b6 05 d5 88 1a f0 	movzbl 0xf01a88d5,%eax
f0104f33:	83 e0 ef             	and    $0xffffffef,%eax
f0104f36:	a2 d5 88 1a f0       	mov    %al,0xf01a88d5
f0104f3b:	0f b6 05 d5 88 1a f0 	movzbl 0xf01a88d5,%eax
f0104f42:	83 e0 9f             	and    $0xffffff9f,%eax
f0104f45:	a2 d5 88 1a f0       	mov    %al,0xf01a88d5
f0104f4a:	0f b6 05 d5 88 1a f0 	movzbl 0xf01a88d5,%eax
f0104f51:	83 c8 80             	or     $0xffffff80,%eax
f0104f54:	a2 d5 88 1a f0       	mov    %al,0xf01a88d5
f0104f59:	b8 fa 56 10 f0       	mov    $0xf01056fa,%eax
f0104f5e:	c1 e8 10             	shr    $0x10,%eax
f0104f61:	66 a3 d6 88 1a f0    	mov    %ax,0xf01a88d6
	SETGATE (idt[T_SIMDERR], 0, GD_KT, routine_simderr, 0);
f0104f67:	b8 00 57 10 f0       	mov    $0xf0105700,%eax
f0104f6c:	66 a3 d8 88 1a f0    	mov    %ax,0xf01a88d8
f0104f72:	66 c7 05 da 88 1a f0 	movw   $0x8,0xf01a88da
f0104f79:	08 00 
f0104f7b:	0f b6 05 dc 88 1a f0 	movzbl 0xf01a88dc,%eax
f0104f82:	83 e0 e0             	and    $0xffffffe0,%eax
f0104f85:	a2 dc 88 1a f0       	mov    %al,0xf01a88dc
f0104f8a:	0f b6 05 dc 88 1a f0 	movzbl 0xf01a88dc,%eax
f0104f91:	83 e0 1f             	and    $0x1f,%eax
f0104f94:	a2 dc 88 1a f0       	mov    %al,0xf01a88dc
f0104f99:	0f b6 05 dd 88 1a f0 	movzbl 0xf01a88dd,%eax
f0104fa0:	83 e0 f0             	and    $0xfffffff0,%eax
f0104fa3:	83 c8 0e             	or     $0xe,%eax
f0104fa6:	a2 dd 88 1a f0       	mov    %al,0xf01a88dd
f0104fab:	0f b6 05 dd 88 1a f0 	movzbl 0xf01a88dd,%eax
f0104fb2:	83 e0 ef             	and    $0xffffffef,%eax
f0104fb5:	a2 dd 88 1a f0       	mov    %al,0xf01a88dd
f0104fba:	0f b6 05 dd 88 1a f0 	movzbl 0xf01a88dd,%eax
f0104fc1:	83 e0 9f             	and    $0xffffff9f,%eax
f0104fc4:	a2 dd 88 1a f0       	mov    %al,0xf01a88dd
f0104fc9:	0f b6 05 dd 88 1a f0 	movzbl 0xf01a88dd,%eax
f0104fd0:	83 c8 80             	or     $0xffffff80,%eax
f0104fd3:	a2 dd 88 1a f0       	mov    %al,0xf01a88dd
f0104fd8:	b8 00 57 10 f0       	mov    $0xf0105700,%eax
f0104fdd:	c1 e8 10             	shr    $0x10,%eax
f0104fe0:	66 a3 de 88 1a f0    	mov    %ax,0xf01a88de
	SETGATE (idt[T_SYSCALL], 0, GD_KT, system_call, 3);
f0104fe6:	b8 06 57 10 f0       	mov    $0xf0105706,%eax
f0104feb:	66 a3 c0 89 1a f0    	mov    %ax,0xf01a89c0
f0104ff1:	66 c7 05 c2 89 1a f0 	movw   $0x8,0xf01a89c2
f0104ff8:	08 00 
f0104ffa:	0f b6 05 c4 89 1a f0 	movzbl 0xf01a89c4,%eax
f0105001:	83 e0 e0             	and    $0xffffffe0,%eax
f0105004:	a2 c4 89 1a f0       	mov    %al,0xf01a89c4
f0105009:	0f b6 05 c4 89 1a f0 	movzbl 0xf01a89c4,%eax
f0105010:	83 e0 1f             	and    $0x1f,%eax
f0105013:	a2 c4 89 1a f0       	mov    %al,0xf01a89c4
f0105018:	0f b6 05 c5 89 1a f0 	movzbl 0xf01a89c5,%eax
f010501f:	83 e0 f0             	and    $0xfffffff0,%eax
f0105022:	83 c8 0e             	or     $0xe,%eax
f0105025:	a2 c5 89 1a f0       	mov    %al,0xf01a89c5
f010502a:	0f b6 05 c5 89 1a f0 	movzbl 0xf01a89c5,%eax
f0105031:	83 e0 ef             	and    $0xffffffef,%eax
f0105034:	a2 c5 89 1a f0       	mov    %al,0xf01a89c5
f0105039:	0f b6 05 c5 89 1a f0 	movzbl 0xf01a89c5,%eax
f0105040:	83 c8 60             	or     $0x60,%eax
f0105043:	a2 c5 89 1a f0       	mov    %al,0xf01a89c5
f0105048:	0f b6 05 c5 89 1a f0 	movzbl 0xf01a89c5,%eax
f010504f:	83 c8 80             	or     $0xffffff80,%eax
f0105052:	a2 c5 89 1a f0       	mov    %al,0xf01a89c5
f0105057:	b8 06 57 10 f0       	mov    $0xf0105706,%eax
f010505c:	c1 e8 10             	shr    $0x10,%eax
f010505f:	66 a3 c6 89 1a f0    	mov    %ax,0xf01a89c6
	SETGATE (idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, timer, 0);
f0105065:	b8 0c 57 10 f0       	mov    $0xf010570c,%eax
f010506a:	66 a3 40 89 1a f0    	mov    %ax,0xf01a8940
f0105070:	66 c7 05 42 89 1a f0 	movw   $0x8,0xf01a8942
f0105077:	08 00 
f0105079:	0f b6 05 44 89 1a f0 	movzbl 0xf01a8944,%eax
f0105080:	83 e0 e0             	and    $0xffffffe0,%eax
f0105083:	a2 44 89 1a f0       	mov    %al,0xf01a8944
f0105088:	0f b6 05 44 89 1a f0 	movzbl 0xf01a8944,%eax
f010508f:	83 e0 1f             	and    $0x1f,%eax
f0105092:	a2 44 89 1a f0       	mov    %al,0xf01a8944
f0105097:	0f b6 05 45 89 1a f0 	movzbl 0xf01a8945,%eax
f010509e:	83 e0 f0             	and    $0xfffffff0,%eax
f01050a1:	83 c8 0e             	or     $0xe,%eax
f01050a4:	a2 45 89 1a f0       	mov    %al,0xf01a8945
f01050a9:	0f b6 05 45 89 1a f0 	movzbl 0xf01a8945,%eax
f01050b0:	83 e0 ef             	and    $0xffffffef,%eax
f01050b3:	a2 45 89 1a f0       	mov    %al,0xf01a8945
f01050b8:	0f b6 05 45 89 1a f0 	movzbl 0xf01a8945,%eax
f01050bf:	83 e0 9f             	and    $0xffffff9f,%eax
f01050c2:	a2 45 89 1a f0       	mov    %al,0xf01a8945
f01050c7:	0f b6 05 45 89 1a f0 	movzbl 0xf01a8945,%eax
f01050ce:	83 c8 80             	or     $0xffffff80,%eax
f01050d1:	a2 45 89 1a f0       	mov    %al,0xf01a8945
f01050d6:	b8 0c 57 10 f0       	mov    $0xf010570c,%eax
f01050db:	c1 e8 10             	shr    $0x10,%eax
f01050de:	66 a3 46 89 1a f0    	mov    %ax,0xf01a8946
	
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f01050e4:	c7 05 44 90 1a f0 00 	movl   $0xefc00000,0xf01a9044
f01050eb:	00 c0 ef 
	ts.ts_ss0 = GD_KD;
f01050ee:	66 c7 05 48 90 1a f0 	movw   $0x10,0xf01a9048
f01050f5:	10 00 

	// Initialize the TSS field of the gdt.
	gdt[GD_TSS >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f01050f7:	66 c7 05 28 f6 11 f0 	movw   $0x68,0xf011f628
f01050fe:	68 00 
f0105100:	b8 40 90 1a f0       	mov    $0xf01a9040,%eax
f0105105:	66 a3 2a f6 11 f0    	mov    %ax,0xf011f62a
f010510b:	b8 40 90 1a f0       	mov    $0xf01a9040,%eax
f0105110:	c1 e8 10             	shr    $0x10,%eax
f0105113:	a2 2c f6 11 f0       	mov    %al,0xf011f62c
f0105118:	0f b6 05 2d f6 11 f0 	movzbl 0xf011f62d,%eax
f010511f:	83 e0 f0             	and    $0xfffffff0,%eax
f0105122:	83 c8 09             	or     $0x9,%eax
f0105125:	a2 2d f6 11 f0       	mov    %al,0xf011f62d
f010512a:	0f b6 05 2d f6 11 f0 	movzbl 0xf011f62d,%eax
f0105131:	83 c8 10             	or     $0x10,%eax
f0105134:	a2 2d f6 11 f0       	mov    %al,0xf011f62d
f0105139:	0f b6 05 2d f6 11 f0 	movzbl 0xf011f62d,%eax
f0105140:	83 e0 9f             	and    $0xffffff9f,%eax
f0105143:	a2 2d f6 11 f0       	mov    %al,0xf011f62d
f0105148:	0f b6 05 2d f6 11 f0 	movzbl 0xf011f62d,%eax
f010514f:	83 c8 80             	or     $0xffffff80,%eax
f0105152:	a2 2d f6 11 f0       	mov    %al,0xf011f62d
f0105157:	0f b6 05 2e f6 11 f0 	movzbl 0xf011f62e,%eax
f010515e:	83 e0 f0             	and    $0xfffffff0,%eax
f0105161:	a2 2e f6 11 f0       	mov    %al,0xf011f62e
f0105166:	0f b6 05 2e f6 11 f0 	movzbl 0xf011f62e,%eax
f010516d:	83 e0 ef             	and    $0xffffffef,%eax
f0105170:	a2 2e f6 11 f0       	mov    %al,0xf011f62e
f0105175:	0f b6 05 2e f6 11 f0 	movzbl 0xf011f62e,%eax
f010517c:	83 e0 df             	and    $0xffffffdf,%eax
f010517f:	a2 2e f6 11 f0       	mov    %al,0xf011f62e
f0105184:	0f b6 05 2e f6 11 f0 	movzbl 0xf011f62e,%eax
f010518b:	83 c8 40             	or     $0x40,%eax
f010518e:	a2 2e f6 11 f0       	mov    %al,0xf011f62e
f0105193:	0f b6 05 2e f6 11 f0 	movzbl 0xf011f62e,%eax
f010519a:	83 e0 7f             	and    $0x7f,%eax
f010519d:	a2 2e f6 11 f0       	mov    %al,0xf011f62e
f01051a2:	b8 40 90 1a f0       	mov    $0xf01a9040,%eax
f01051a7:	c1 e8 18             	shr    $0x18,%eax
f01051aa:	a2 2f f6 11 f0       	mov    %al,0xf011f62f
					sizeof(struct Taskstate), 0);
	gdt[GD_TSS >> 3].sd_s = 0;
f01051af:	0f b6 05 2d f6 11 f0 	movzbl 0xf011f62d,%eax
f01051b6:	83 e0 ef             	and    $0xffffffef,%eax
f01051b9:	a2 2d f6 11 f0       	mov    %al,0xf011f62d
f01051be:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01051c4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
f01051c8:	0f 00 d8             	ltr    %ax

	// Load the TSS
	ltr(GD_TSS);

	// Load the IDT
	asm volatile("lidt idt_pd");
f01051cb:	0f 01 1d 3e f6 11 f0 	lidtl  0xf011f63e
}
f01051d2:	c9                   	leave  
f01051d3:	c3                   	ret    

f01051d4 <print_trapframe>:

void
print_trapframe(struct Trapframe *tf)
{
f01051d4:	55                   	push   %ebp
f01051d5:	89 e5                	mov    %esp,%ebp
f01051d7:	83 ec 18             	sub    $0x18,%esp
	cprintf("TRAP frame at %p\n", tf);
f01051da:	8b 45 08             	mov    0x8(%ebp),%eax
f01051dd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051e1:	c7 04 24 ee 87 10 f0 	movl   $0xf01087ee,(%esp)
f01051e8:	e8 a1 f4 ff ff       	call   f010468e <cprintf>
	print_regs(&tf->tf_regs);
f01051ed:	8b 45 08             	mov    0x8(%ebp),%eax
f01051f0:	89 04 24             	mov    %eax,(%esp)
f01051f3:	e8 ea 00 00 00       	call   f01052e2 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01051f8:	8b 45 08             	mov    0x8(%ebp),%eax
f01051fb:	0f b7 40 20          	movzwl 0x20(%eax),%eax
f01051ff:	0f b7 c0             	movzwl %ax,%eax
f0105202:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105206:	c7 04 24 00 88 10 f0 	movl   $0xf0108800,(%esp)
f010520d:	e8 7c f4 ff ff       	call   f010468e <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0105212:	8b 45 08             	mov    0x8(%ebp),%eax
f0105215:	0f b7 40 24          	movzwl 0x24(%eax),%eax
f0105219:	0f b7 c0             	movzwl %ax,%eax
f010521c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105220:	c7 04 24 13 88 10 f0 	movl   $0xf0108813,(%esp)
f0105227:	e8 62 f4 ff ff       	call   f010468e <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010522c:	8b 45 08             	mov    0x8(%ebp),%eax
f010522f:	8b 40 28             	mov    0x28(%eax),%eax
f0105232:	89 04 24             	mov    %eax,(%esp)
f0105235:	e8 7a f4 ff ff       	call   f01046b4 <trapname>
f010523a:	8b 55 08             	mov    0x8(%ebp),%edx
f010523d:	8b 52 28             	mov    0x28(%edx),%edx
f0105240:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105244:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105248:	c7 04 24 26 88 10 f0 	movl   $0xf0108826,(%esp)
f010524f:	e8 3a f4 ff ff       	call   f010468e <cprintf>
	cprintf("  err  0x%08x\n", tf->tf_err);
f0105254:	8b 45 08             	mov    0x8(%ebp),%eax
f0105257:	8b 40 2c             	mov    0x2c(%eax),%eax
f010525a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010525e:	c7 04 24 38 88 10 f0 	movl   $0xf0108838,(%esp)
f0105265:	e8 24 f4 ff ff       	call   f010468e <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f010526a:	8b 45 08             	mov    0x8(%ebp),%eax
f010526d:	8b 40 30             	mov    0x30(%eax),%eax
f0105270:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105274:	c7 04 24 47 88 10 f0 	movl   $0xf0108847,(%esp)
f010527b:	e8 0e f4 ff ff       	call   f010468e <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0105280:	8b 45 08             	mov    0x8(%ebp),%eax
f0105283:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f0105287:	0f b7 c0             	movzwl %ax,%eax
f010528a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010528e:	c7 04 24 56 88 10 f0 	movl   $0xf0108856,(%esp)
f0105295:	e8 f4 f3 ff ff       	call   f010468e <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f010529a:	8b 45 08             	mov    0x8(%ebp),%eax
f010529d:	8b 40 38             	mov    0x38(%eax),%eax
f01052a0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052a4:	c7 04 24 69 88 10 f0 	movl   $0xf0108869,(%esp)
f01052ab:	e8 de f3 ff ff       	call   f010468e <cprintf>
	cprintf("  esp  0x%08x\n", tf->tf_esp);
f01052b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01052b3:	8b 40 3c             	mov    0x3c(%eax),%eax
f01052b6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052ba:	c7 04 24 78 88 10 f0 	movl   $0xf0108878,(%esp)
f01052c1:	e8 c8 f3 ff ff       	call   f010468e <cprintf>
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
f01052c6:	8b 45 08             	mov    0x8(%ebp),%eax
f01052c9:	0f b7 40 40          	movzwl 0x40(%eax),%eax
f01052cd:	0f b7 c0             	movzwl %ax,%eax
f01052d0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052d4:	c7 04 24 87 88 10 f0 	movl   $0xf0108887,(%esp)
f01052db:	e8 ae f3 ff ff       	call   f010468e <cprintf>
}
f01052e0:	c9                   	leave  
f01052e1:	c3                   	ret    

f01052e2 <print_regs>:

void
print_regs(struct PushRegs *regs)
{
f01052e2:	55                   	push   %ebp
f01052e3:	89 e5                	mov    %esp,%ebp
f01052e5:	83 ec 18             	sub    $0x18,%esp
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f01052e8:	8b 45 08             	mov    0x8(%ebp),%eax
f01052eb:	8b 00                	mov    (%eax),%eax
f01052ed:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052f1:	c7 04 24 9a 88 10 f0 	movl   $0xf010889a,(%esp)
f01052f8:	e8 91 f3 ff ff       	call   f010468e <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01052fd:	8b 45 08             	mov    0x8(%ebp),%eax
f0105300:	8b 40 04             	mov    0x4(%eax),%eax
f0105303:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105307:	c7 04 24 a9 88 10 f0 	movl   $0xf01088a9,(%esp)
f010530e:	e8 7b f3 ff ff       	call   f010468e <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0105313:	8b 45 08             	mov    0x8(%ebp),%eax
f0105316:	8b 40 08             	mov    0x8(%eax),%eax
f0105319:	89 44 24 04          	mov    %eax,0x4(%esp)
f010531d:	c7 04 24 b8 88 10 f0 	movl   $0xf01088b8,(%esp)
f0105324:	e8 65 f3 ff ff       	call   f010468e <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0105329:	8b 45 08             	mov    0x8(%ebp),%eax
f010532c:	8b 40 0c             	mov    0xc(%eax),%eax
f010532f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105333:	c7 04 24 c7 88 10 f0 	movl   $0xf01088c7,(%esp)
f010533a:	e8 4f f3 ff ff       	call   f010468e <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f010533f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105342:	8b 40 10             	mov    0x10(%eax),%eax
f0105345:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105349:	c7 04 24 d6 88 10 f0 	movl   $0xf01088d6,(%esp)
f0105350:	e8 39 f3 ff ff       	call   f010468e <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0105355:	8b 45 08             	mov    0x8(%ebp),%eax
f0105358:	8b 40 14             	mov    0x14(%eax),%eax
f010535b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010535f:	c7 04 24 e5 88 10 f0 	movl   $0xf01088e5,(%esp)
f0105366:	e8 23 f3 ff ff       	call   f010468e <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f010536b:	8b 45 08             	mov    0x8(%ebp),%eax
f010536e:	8b 40 18             	mov    0x18(%eax),%eax
f0105371:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105375:	c7 04 24 f4 88 10 f0 	movl   $0xf01088f4,(%esp)
f010537c:	e8 0d f3 ff ff       	call   f010468e <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0105381:	8b 45 08             	mov    0x8(%ebp),%eax
f0105384:	8b 40 1c             	mov    0x1c(%eax),%eax
f0105387:	89 44 24 04          	mov    %eax,0x4(%esp)
f010538b:	c7 04 24 03 89 10 f0 	movl   $0xf0108903,(%esp)
f0105392:	e8 f7 f2 ff ff       	call   f010468e <cprintf>
}
f0105397:	c9                   	leave  
f0105398:	c3                   	ret    

f0105399 <trap_dispatch>:

static void
trap_dispatch(struct Trapframe *tf)
{
f0105399:	55                   	push   %ebp
f010539a:	89 e5                	mov    %esp,%ebp
f010539c:	57                   	push   %edi
f010539d:	56                   	push   %esi
f010539e:	53                   	push   %ebx
f010539f:	83 ec 3c             	sub    $0x3c,%esp
	// Handle processor exceptions.
	// LAB 3: Your code here.
	//cprintf("the trapno is 0x%x\n", tf->tf_trapno);
	if(tf->tf_trapno == T_PGFLT){//page fault
f01053a2:	8b 45 08             	mov    0x8(%ebp),%eax
f01053a5:	8b 40 28             	mov    0x28(%eax),%eax
f01053a8:	83 f8 0e             	cmp    $0xe,%eax
f01053ab:	75 10                	jne    f01053bd <trap_dispatch+0x24>
	    //cprintf("%x \n", tf->tf_err);
	    page_fault_handler(tf);
f01053ad:	8b 45 08             	mov    0x8(%ebp),%eax
f01053b0:	89 04 24             	mov    %eax,(%esp)
f01053b3:	e8 6d 01 00 00       	call   f0105525 <page_fault_handler>
        return ;
f01053b8:	e9 c5 00 00 00       	jmp    f0105482 <trap_dispatch+0xe9>
    }

    if(tf->tf_trapno == T_BRKPT){//break point fault
f01053bd:	8b 45 08             	mov    0x8(%ebp),%eax
f01053c0:	8b 40 28             	mov    0x28(%eax),%eax
f01053c3:	83 f8 03             	cmp    $0x3,%eax
f01053c6:	75 10                	jne    f01053d8 <trap_dispatch+0x3f>
        monitor(tf);
f01053c8:	8b 45 08             	mov    0x8(%ebp),%eax
f01053cb:	89 04 24             	mov    %eax,(%esp)
f01053ce:	e8 11 c1 ff ff       	call   f01014e4 <monitor>
        return ;
f01053d3:	e9 aa 00 00 00       	jmp    f0105482 <trap_dispatch+0xe9>
    }
    
    if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER){
f01053d8:	8b 45 08             	mov    0x8(%ebp),%eax
f01053db:	8b 40 28             	mov    0x28(%eax),%eax
f01053de:	83 f8 20             	cmp    $0x20,%eax
f01053e1:	75 05                	jne    f01053e8 <trap_dispatch+0x4f>
		sched_yield();
f01053e3:	e8 44 03 00 00       	call   f010572c <sched_yield>
		return ;
	}
    
    if(tf->tf_trapno == T_SYSCALL){//syscall
f01053e8:	8b 45 08             	mov    0x8(%ebp),%eax
f01053eb:	8b 40 28             	mov    0x28(%eax),%eax
f01053ee:	83 f8 30             	cmp    $0x30,%eax
f01053f1:	75 4d                	jne    f0105440 <trap_dispatch+0xa7>
                tf->tf_regs.reg_eax,
                tf->tf_regs.reg_edx,
                tf->tf_regs.reg_ecx,
                tf->tf_regs.reg_ebx,
                tf->tf_regs.reg_edi,
                tf->tf_regs.reg_esi);
f01053f3:	8b 45 08             	mov    0x8(%ebp),%eax
		sched_yield();
		return ;
	}
    
    if(tf->tf_trapno == T_SYSCALL){//syscall
        int r = syscall(
f01053f6:	8b 78 04             	mov    0x4(%eax),%edi
                tf->tf_regs.reg_eax,
                tf->tf_regs.reg_edx,
                tf->tf_regs.reg_ecx,
                tf->tf_regs.reg_ebx,
                tf->tf_regs.reg_edi,
f01053f9:	8b 45 08             	mov    0x8(%ebp),%eax
		sched_yield();
		return ;
	}
    
    if(tf->tf_trapno == T_SYSCALL){//syscall
        int r = syscall(
f01053fc:	8b 30                	mov    (%eax),%esi
                tf->tf_regs.reg_eax,
                tf->tf_regs.reg_edx,
                tf->tf_regs.reg_ecx,
                tf->tf_regs.reg_ebx,
f01053fe:	8b 45 08             	mov    0x8(%ebp),%eax
		sched_yield();
		return ;
	}
    
    if(tf->tf_trapno == T_SYSCALL){//syscall
        int r = syscall(
f0105401:	8b 58 10             	mov    0x10(%eax),%ebx
                tf->tf_regs.reg_eax,
                tf->tf_regs.reg_edx,
                tf->tf_regs.reg_ecx,
f0105404:	8b 45 08             	mov    0x8(%ebp),%eax
		sched_yield();
		return ;
	}
    
    if(tf->tf_trapno == T_SYSCALL){//syscall
        int r = syscall(
f0105407:	8b 48 18             	mov    0x18(%eax),%ecx
                tf->tf_regs.reg_eax,
                tf->tf_regs.reg_edx,
f010540a:	8b 45 08             	mov    0x8(%ebp),%eax
		sched_yield();
		return ;
	}
    
    if(tf->tf_trapno == T_SYSCALL){//syscall
        int r = syscall(
f010540d:	8b 50 14             	mov    0x14(%eax),%edx
                tf->tf_regs.reg_eax,
f0105410:	8b 45 08             	mov    0x8(%ebp),%eax
		sched_yield();
		return ;
	}
    
    if(tf->tf_trapno == T_SYSCALL){//syscall
        int r = syscall(
f0105413:	8b 40 1c             	mov    0x1c(%eax),%eax
f0105416:	89 7c 24 14          	mov    %edi,0x14(%esp)
f010541a:	89 74 24 10          	mov    %esi,0x10(%esp)
f010541e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0105422:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105426:	89 54 24 04          	mov    %edx,0x4(%esp)
f010542a:	89 04 24             	mov    %eax,(%esp)
f010542d:	e8 28 0c 00 00       	call   f010605a <syscall>
f0105432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                /*
        if(r < 0){
			cprintf("%d\n", r);
			panic("trap dispatch: syscall failed\n");
		}*/
		tf->tf_regs.reg_eax = r;
f0105435:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105438:	8b 45 08             	mov    0x8(%ebp),%eax
f010543b:	89 50 1c             	mov    %edx,0x1c(%eax)
		return ;
f010543e:	eb 42                	jmp    f0105482 <trap_dispatch+0xe9>

	// Handle keyboard interrupts.
	// LAB 5: Your code here.

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f0105440:	8b 45 08             	mov    0x8(%ebp),%eax
f0105443:	89 04 24             	mov    %eax,(%esp)
f0105446:	e8 89 fd ff ff       	call   f01051d4 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f010544b:	8b 45 08             	mov    0x8(%ebp),%eax
f010544e:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f0105452:	66 83 f8 08          	cmp    $0x8,%ax
f0105456:	75 1c                	jne    f0105474 <trap_dispatch+0xdb>
		panic("unhandled trap in kernel");
f0105458:	c7 44 24 08 12 89 10 	movl   $0xf0108912,0x8(%esp)
f010545f:	f0 
f0105460:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
f0105467:	00 
f0105468:	c7 04 24 2b 89 10 f0 	movl   $0xf010892b,(%esp)
f010546f:	e8 2a ad ff ff       	call   f010019e <_panic>
	else {
		env_destroy(curenv);
f0105474:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0105479:	89 04 24             	mov    %eax,(%esp)
f010547c:	e8 3e ee ff ff       	call   f01042bf <env_destroy>
		return;
f0105481:	90                   	nop
	}
}
f0105482:	83 c4 3c             	add    $0x3c,%esp
f0105485:	5b                   	pop    %ebx
f0105486:	5e                   	pop    %esi
f0105487:	5f                   	pop    %edi
f0105488:	5d                   	pop    %ebp
f0105489:	c3                   	ret    

f010548a <trap>:

void
trap(struct Trapframe *tf)
{
f010548a:	55                   	push   %ebp
f010548b:	89 e5                	mov    %esp,%ebp
f010548d:	57                   	push   %edi
f010548e:	56                   	push   %esi
f010548f:	53                   	push   %ebx
f0105490:	83 ec 1c             	sub    $0x1c,%esp
	if ((tf->tf_cs & 3) == 3) {
f0105493:	8b 45 08             	mov    0x8(%ebp),%eax
f0105496:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f010549a:	0f b7 c0             	movzwl %ax,%eax
f010549d:	83 e0 03             	and    $0x3,%eax
f01054a0:	83 f8 03             	cmp    $0x3,%eax
f01054a3:	75 4d                	jne    f01054f2 <trap+0x68>
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
f01054a5:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f01054aa:	85 c0                	test   %eax,%eax
f01054ac:	75 24                	jne    f01054d2 <trap+0x48>
f01054ae:	c7 44 24 0c 37 89 10 	movl   $0xf0108937,0xc(%esp)
f01054b5:	f0 
f01054b6:	c7 44 24 08 3e 89 10 	movl   $0xf010893e,0x8(%esp)
f01054bd:	f0 
f01054be:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
f01054c5:	00 
f01054c6:	c7 04 24 2b 89 10 f0 	movl   $0xf010892b,(%esp)
f01054cd:	e8 cc ac ff ff       	call   f010019e <_panic>
		curenv->env_tf = *tf;
f01054d2:	8b 15 28 88 1a f0    	mov    0xf01a8828,%edx
f01054d8:	8b 45 08             	mov    0x8(%ebp),%eax
f01054db:	89 c3                	mov    %eax,%ebx
f01054dd:	b8 11 00 00 00       	mov    $0x11,%eax
f01054e2:	89 d7                	mov    %edx,%edi
f01054e4:	89 de                	mov    %ebx,%esi
f01054e6:	89 c1                	mov    %eax,%ecx
f01054e8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f01054ea:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f01054ef:	89 45 08             	mov    %eax,0x8(%ebp)
	}
	//cprintf("%x \n", tf->tf_err);
	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
f01054f2:	8b 45 08             	mov    0x8(%ebp),%eax
f01054f5:	89 04 24             	mov    %eax,(%esp)
f01054f8:	e8 9c fe ff ff       	call   f0105399 <trap_dispatch>

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
f01054fd:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0105502:	85 c0                	test   %eax,%eax
f0105504:	74 1a                	je     f0105520 <trap+0x96>
f0105506:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010550b:	8b 40 54             	mov    0x54(%eax),%eax
f010550e:	83 f8 01             	cmp    $0x1,%eax
f0105511:	75 0d                	jne    f0105520 <trap+0x96>
		env_run(curenv);
f0105513:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0105518:	89 04 24             	mov    %eax,(%esp)
f010551b:	e8 f7 ed ff ff       	call   f0104317 <env_run>
	else
		sched_yield();
f0105520:	e8 07 02 00 00       	call   f010572c <sched_yield>

f0105525 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0105525:	55                   	push   %ebp
f0105526:	89 e5                	mov    %esp,%ebp
f0105528:	53                   	push   %ebx
f0105529:	83 ec 24             	sub    $0x24,%esp

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f010552c:	0f 20 d3             	mov    %cr2,%ebx
f010552f:	89 5d ec             	mov    %ebx,-0x14(%ebp)
	return val;
f0105532:	8b 45 ec             	mov    -0x14(%ebp),%eax
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();
f0105535:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("%x\n",fault_va);
	// Handle kernel-mode page faults.
	
	// LAB 3: Your code here.
    if((tf->tf_cs & 3) == 0){
f0105538:	8b 45 08             	mov    0x8(%ebp),%eax
f010553b:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f010553f:	0f b7 c0             	movzwl %ax,%eax
f0105542:	83 e0 03             	and    $0x3,%eax
f0105545:	85 c0                	test   %eax,%eax
f0105547:	75 1c                	jne    f0105565 <page_fault_handler+0x40>
        panic("kernel mode page_faults\n");
f0105549:	c7 44 24 08 53 89 10 	movl   $0xf0108953,0x8(%esp)
f0105550:	f0 
f0105551:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
f0105558:	00 
f0105559:	c7 04 24 2b 89 10 f0 	movl   $0xf010892b,(%esp)
f0105560:	e8 39 ac ff ff       	call   f010019e <_panic>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').
	
	// LAB 4: Your code here.
	
	if(curenv->env_pgfault_upcall != NULL){//reg the pgfault
f0105565:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010556a:	8b 40 64             	mov    0x64(%eax),%eax
f010556d:	85 c0                	test   %eax,%eax
f010556f:	0f 84 e9 00 00 00    	je     f010565e <page_fault_handler+0x139>
	    struct UTrapframe *utf;
	    //check whether 1(user) or 2 (user err) 
	    if(UXSTACKTOP - PGSIZE <= tf->tf_esp && tf->tf_esp < UXSTACKTOP){
f0105575:	8b 45 08             	mov    0x8(%ebp),%eax
f0105578:	8b 40 3c             	mov    0x3c(%eax),%eax
f010557b:	3d ff ef bf ee       	cmp    $0xeebfefff,%eax
f0105580:	76 1b                	jbe    f010559d <page_fault_handler+0x78>
f0105582:	8b 45 08             	mov    0x8(%ebp),%eax
f0105585:	8b 40 3c             	mov    0x3c(%eax),%eax
f0105588:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
f010558d:	77 0e                	ja     f010559d <page_fault_handler+0x78>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(struct UTrapframe) - 4);
f010558f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105592:	8b 40 3c             	mov    0x3c(%eax),%eax
f0105595:	83 e8 38             	sub    $0x38,%eax
f0105598:	89 45 f4             	mov    %eax,-0xc(%ebp)
f010559b:	eb 07                	jmp    f01055a4 <page_fault_handler+0x7f>
		}
		else{
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
f010559d:	c7 45 f4 cc ff bf ee 	movl   $0xeebfffcc,-0xc(%ebp)
		}
		
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_U|PTE_W|PTE_P);//
f01055a4:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f01055a9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f01055b0:	00 
f01055b1:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
f01055b8:	00 
f01055b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01055bc:	89 54 24 04          	mov    %edx,0x4(%esp)
f01055c0:	89 04 24             	mov    %eax,(%esp)
f01055c3:	e8 c9 d6 ff ff       	call   f0102c91 <user_mem_assert>
		
		utf->utf_eflags = tf->tf_eflags;
f01055c8:	8b 45 08             	mov    0x8(%ebp),%eax
f01055cb:	8b 50 38             	mov    0x38(%eax),%edx
f01055ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01055d1:	89 50 2c             	mov    %edx,0x2c(%eax)
		utf->utf_eip = tf->tf_eip;
f01055d4:	8b 45 08             	mov    0x8(%ebp),%eax
f01055d7:	8b 50 30             	mov    0x30(%eax),%edx
f01055da:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01055dd:	89 50 28             	mov    %edx,0x28(%eax)
		utf->utf_err = tf->tf_err;
f01055e0:	8b 45 08             	mov    0x8(%ebp),%eax
f01055e3:	8b 50 2c             	mov    0x2c(%eax),%edx
f01055e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01055e9:	89 50 04             	mov    %edx,0x4(%eax)
		utf->utf_esp = tf->tf_esp;
f01055ec:	8b 45 08             	mov    0x8(%ebp),%eax
f01055ef:	8b 50 3c             	mov    0x3c(%eax),%edx
f01055f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01055f5:	89 50 30             	mov    %edx,0x30(%eax)
		utf->utf_fault_va = fault_va;
f01055f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01055fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01055fe:	89 10                	mov    %edx,(%eax)
		utf->utf_regs = tf->tf_regs;
f0105600:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105603:	8b 55 08             	mov    0x8(%ebp),%edx
f0105606:	8b 0a                	mov    (%edx),%ecx
f0105608:	89 48 08             	mov    %ecx,0x8(%eax)
f010560b:	8b 4a 04             	mov    0x4(%edx),%ecx
f010560e:	89 48 0c             	mov    %ecx,0xc(%eax)
f0105611:	8b 4a 08             	mov    0x8(%edx),%ecx
f0105614:	89 48 10             	mov    %ecx,0x10(%eax)
f0105617:	8b 4a 0c             	mov    0xc(%edx),%ecx
f010561a:	89 48 14             	mov    %ecx,0x14(%eax)
f010561d:	8b 4a 10             	mov    0x10(%edx),%ecx
f0105620:	89 48 18             	mov    %ecx,0x18(%eax)
f0105623:	8b 4a 14             	mov    0x14(%edx),%ecx
f0105626:	89 48 1c             	mov    %ecx,0x1c(%eax)
f0105629:	8b 4a 18             	mov    0x18(%edx),%ecx
f010562c:	89 48 20             	mov    %ecx,0x20(%eax)
f010562f:	8b 52 1c             	mov    0x1c(%edx),%edx
f0105632:	89 50 24             	mov    %edx,0x24(%eax)
		
		//cprintf("err : %x\n", tf->tf_err);
		
		curenv->env_tf.tf_eip = (uint32_t) curenv->env_pgfault_upcall;
f0105635:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010563a:	8b 15 28 88 1a f0    	mov    0xf01a8828,%edx
f0105640:	8b 52 64             	mov    0x64(%edx),%edx
f0105643:	89 50 30             	mov    %edx,0x30(%eax)
		curenv->env_tf.tf_esp = (uint32_t) utf;
f0105646:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010564b:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010564e:	89 50 3c             	mov    %edx,0x3c(%eax)
		
		env_run(curenv);
f0105651:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0105656:	89 04 24             	mov    %eax,(%esp)
f0105659:	e8 b9 ec ff ff       	call   f0104317 <env_run>
	}
	//else cprintf("curenv->env_pgfault_upcall is NULL\n");
	
	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
		curenv->env_id, fault_va, tf->tf_eip);
f010565e:	8b 45 08             	mov    0x8(%ebp),%eax
		env_run(curenv);
	}
	//else cprintf("curenv->env_pgfault_upcall is NULL\n");
	
	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0105661:	8b 50 30             	mov    0x30(%eax),%edx
		curenv->env_id, fault_va, tf->tf_eip);
f0105664:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
		env_run(curenv);
	}
	//else cprintf("curenv->env_pgfault_upcall is NULL\n");
	
	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0105669:	8b 40 4c             	mov    0x4c(%eax),%eax
f010566c:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105670:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105673:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105677:	89 44 24 04          	mov    %eax,0x4(%esp)
f010567b:	c7 04 24 6c 89 10 f0 	movl   $0xf010896c,(%esp)
f0105682:	e8 07 f0 ff ff       	call   f010468e <cprintf>
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
f0105687:	8b 45 08             	mov    0x8(%ebp),%eax
f010568a:	89 04 24             	mov    %eax,(%esp)
f010568d:	e8 42 fb ff ff       	call   f01051d4 <print_trapframe>
	env_destroy(curenv);
f0105692:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0105697:	89 04 24             	mov    %eax,(%esp)
f010569a:	e8 20 ec ff ff       	call   f01042bf <env_destroy>
}
f010569f:	83 c4 24             	add    $0x24,%esp
f01056a2:	5b                   	pop    %ebx
f01056a3:	5d                   	pop    %ebp
f01056a4:	c3                   	ret    
f01056a5:	00 00                	add    %al,(%eax)
	...

f01056a8 <routine_divide>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(routine_divide, T_DIVIDE)
f01056a8:	6a 00                	push   $0x0
f01056aa:	6a 00                	push   $0x0
f01056ac:	eb 64                	jmp    f0105712 <_alltraps>

f01056ae <routine_debug>:
TRAPHANDLER_NOEC(routine_debug, T_DEBUG)
f01056ae:	6a 00                	push   $0x0
f01056b0:	6a 01                	push   $0x1
f01056b2:	eb 5e                	jmp    f0105712 <_alltraps>

f01056b4 <routine_nmi>:
TRAPHANDLER_NOEC(routine_nmi, T_NMI)
f01056b4:	6a 00                	push   $0x0
f01056b6:	6a 02                	push   $0x2
f01056b8:	eb 58                	jmp    f0105712 <_alltraps>

f01056ba <routine_brkpt>:
TRAPHANDLER_NOEC(routine_brkpt, T_BRKPT)
f01056ba:	6a 00                	push   $0x0
f01056bc:	6a 03                	push   $0x3
f01056be:	eb 52                	jmp    f0105712 <_alltraps>

f01056c0 <routine_oflow>:
TRAPHANDLER_NOEC(routine_oflow, T_OFLOW)
f01056c0:	6a 00                	push   $0x0
f01056c2:	6a 04                	push   $0x4
f01056c4:	eb 4c                	jmp    f0105712 <_alltraps>

f01056c6 <routine_bound>:
TRAPHANDLER_NOEC(routine_bound, T_BOUND)
f01056c6:	6a 00                	push   $0x0
f01056c8:	6a 05                	push   $0x5
f01056ca:	eb 46                	jmp    f0105712 <_alltraps>

f01056cc <routine_illop>:
TRAPHANDLER_NOEC(routine_illop, T_ILLOP)
f01056cc:	6a 00                	push   $0x0
f01056ce:	6a 06                	push   $0x6
f01056d0:	eb 40                	jmp    f0105712 <_alltraps>

f01056d2 <routine_device>:
TRAPHANDLER_NOEC(routine_device, T_DEVICE)
f01056d2:	6a 00                	push   $0x0
f01056d4:	6a 07                	push   $0x7
f01056d6:	eb 3a                	jmp    f0105712 <_alltraps>

f01056d8 <routine_dblflt>:
TRAPHANDLER(routine_dblflt, T_DBLFLT)
f01056d8:	6a 08                	push   $0x8
f01056da:	eb 36                	jmp    f0105712 <_alltraps>

f01056dc <routine_tss>:
TRAPHANDLER(routine_tss, T_TSS)
f01056dc:	6a 0a                	push   $0xa
f01056de:	eb 32                	jmp    f0105712 <_alltraps>

f01056e0 <routine_segnp>:
TRAPHANDLER(routine_segnp, T_SEGNP)
f01056e0:	6a 0b                	push   $0xb
f01056e2:	eb 2e                	jmp    f0105712 <_alltraps>

f01056e4 <routine_stack>:
TRAPHANDLER(routine_stack, T_STACK)
f01056e4:	6a 0c                	push   $0xc
f01056e6:	eb 2a                	jmp    f0105712 <_alltraps>

f01056e8 <routine_gpflt>:
TRAPHANDLER(routine_gpflt, T_GPFLT)
f01056e8:	6a 0d                	push   $0xd
f01056ea:	eb 26                	jmp    f0105712 <_alltraps>

f01056ec <routine_pgflt>:
TRAPHANDLER(routine_pgflt, T_PGFLT)
f01056ec:	6a 0e                	push   $0xe
f01056ee:	eb 22                	jmp    f0105712 <_alltraps>

f01056f0 <routine_fperr>:
TRAPHANDLER_NOEC(routine_fperr, T_FPERR)
f01056f0:	6a 00                	push   $0x0
f01056f2:	6a 10                	push   $0x10
f01056f4:	eb 1c                	jmp    f0105712 <_alltraps>

f01056f6 <routine_align>:
TRAPHANDLER(routine_align, T_ALIGN)
f01056f6:	6a 11                	push   $0x11
f01056f8:	eb 18                	jmp    f0105712 <_alltraps>

f01056fa <routine_mchk>:
TRAPHANDLER_NOEC(routine_mchk, T_MCHK)
f01056fa:	6a 00                	push   $0x0
f01056fc:	6a 12                	push   $0x12
f01056fe:	eb 12                	jmp    f0105712 <_alltraps>

f0105700 <routine_simderr>:
TRAPHANDLER_NOEC(routine_simderr, T_SIMDERR)
f0105700:	6a 00                	push   $0x0
f0105702:	6a 13                	push   $0x13
f0105704:	eb 0c                	jmp    f0105712 <_alltraps>

f0105706 <system_call>:
TRAPHANDLER_NOEC(system_call, T_SYSCALL)
f0105706:	6a 00                	push   $0x0
f0105708:	6a 30                	push   $0x30
f010570a:	eb 06                	jmp    f0105712 <_alltraps>

f010570c <timer>:
TRAPHANDLER_NOEC(timer, IRQ_OFFSET + IRQ_TIMER)
f010570c:	6a 00                	push   $0x0
f010570e:	6a 20                	push   $0x20
f0105710:	eb 00                	jmp    f0105712 <_alltraps>

f0105712 <_alltraps>:
  popal
  popl %es
  popl %ds
  iret
*/
  pushw  $0x0
f0105712:	66 6a 00             	pushw  $0x0
  pushw  %ds
f0105715:	66 1e                	pushw  %ds
  pushw  $0x0
f0105717:	66 6a 00             	pushw  $0x0
  pushw  %es
f010571a:	66 06                	pushw  %es
  pushal
f010571c:	60                   	pusha  
  movl   $GD_KD, %eax
f010571d:	b8 10 00 00 00       	mov    $0x10,%eax
  movw   %ax, %ds
f0105722:	8e d8                	mov    %eax,%ds
  movw   %ax, %es
f0105724:	8e c0                	mov    %eax,%es
  pushl  %esp
f0105726:	54                   	push   %esp
  call trap
f0105727:	e8 5e fd ff ff       	call   f010548a <trap>

f010572c <sched_yield>:


// Choose a user environment to run and run it.
void
sched_yield(void)
{
f010572c:	55                   	push   %ebp
f010572d:	89 e5                	mov    %esp,%ebp
f010572f:	83 ec 28             	sub    $0x28,%esp
	// But never choose envs[0], the idle environment,
	// unless NOTHING else is runnable.

	// LAB 4: Your code here.
	struct Env *able;// = NULL;
    struct Env *run = curenv;
f0105732:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0105737:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(curenv == NULL){
f010573a:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010573f:	85 c0                	test   %eax,%eax
f0105741:	75 08                	jne    f010574b <sched_yield+0x1f>
        run = envs;
f0105743:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0105748:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    int round = 0;
f010574b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    int level = 21;//the highest
f0105752:	c7 45 e8 15 00 00 00 	movl   $0x15,-0x18(%ebp)
        if(run->env_status == ENV_RUNNABLE){
			env_run(run);
        }
    }
    */
    for(able = run+1; round<NENV; able++,round++){
f0105759:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010575c:	83 e8 80             	sub    $0xffffff80,%eax
f010575f:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0105762:	eb 47                	jmp    f01057ab <sched_yield+0x7f>
        if(able >= envs+NENV){
f0105764:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0105769:	05 00 00 02 00       	add    $0x20000,%eax
f010576e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
f0105771:	77 0b                	ja     f010577e <sched_yield+0x52>
            able = envs+1;
f0105773:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f0105778:	83 e8 80             	sub    $0xffffff80,%eax
f010577b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        if(able->env_status == ENV_RUNNABLE){
f010577e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105781:	8b 40 54             	mov    0x54(%eax),%eax
f0105784:	83 f8 01             	cmp    $0x1,%eax
f0105787:	75 1a                	jne    f01057a3 <sched_yield+0x77>
			if(level > able->env_priority){
f0105789:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010578c:	8b 40 7c             	mov    0x7c(%eax),%eax
f010578f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0105792:	7d 0f                	jge    f01057a3 <sched_yield+0x77>
				run = able;//decide to run
f0105794:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105797:	89 45 f0             	mov    %eax,-0x10(%ebp)
				level = able->env_priority;
f010579a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010579d:	8b 40 7c             	mov    0x7c(%eax),%eax
f01057a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(run->env_status == ENV_RUNNABLE){
			env_run(run);
        }
    }
    */
    for(able = run+1; round<NENV; able++,round++){
f01057a3:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
f01057a7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
f01057ab:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
f01057b2:	7e b0                	jle    f0105764 <sched_yield+0x38>
				run = able;//decide to run
				level = able->env_priority;
			}
        }
	}
	if(level<21){//there must be some one can be run
f01057b4:	83 7d e8 14          	cmpl   $0x14,-0x18(%ebp)
f01057b8:	7f 0b                	jg     f01057c5 <sched_yield+0x99>
	    env_run(run);
f01057ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01057bd:	89 04 24             	mov    %eax,(%esp)
f01057c0:	e8 52 eb ff ff       	call   f0104317 <env_run>
	}
	// Run the special idle environment when nothing else is runnable.
	if (envs[0].env_status == ENV_RUNNABLE)
f01057c5:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f01057ca:	8b 40 54             	mov    0x54(%eax),%eax
f01057cd:	83 f8 01             	cmp    $0x1,%eax
f01057d0:	75 0d                	jne    f01057df <sched_yield+0xb3>
		env_run(&envs[0]);
f01057d2:	a1 24 88 1a f0       	mov    0xf01a8824,%eax
f01057d7:	89 04 24             	mov    %eax,(%esp)
f01057da:	e8 38 eb ff ff       	call   f0104317 <env_run>
	else {
		cprintf("Destroyed all environments - nothing more to do!\n");
f01057df:	c7 04 24 30 8b 10 f0 	movl   $0xf0108b30,(%esp)
f01057e6:	e8 a3 ee ff ff       	call   f010468e <cprintf>
		while (1)
			monitor(NULL);
f01057eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01057f2:	e8 ed bc ff ff       	call   f01014e4 <monitor>
f01057f7:	eb f2                	jmp    f01057eb <sched_yield+0xbf>
f01057f9:	00 00                	add    %al,(%eax)
	...

f01057fc <page2ppn>:
int	user_mem_check(struct Env *env, const void *va, size_t len, int perm);
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline ppn_t
page2ppn(struct Page *pp)
{
f01057fc:	55                   	push   %ebp
f01057fd:	89 e5                	mov    %esp,%ebp
	return pp - pages;
f01057ff:	8b 55 08             	mov    0x8(%ebp),%edx
f0105802:	a1 cc 94 1a f0       	mov    0xf01a94cc,%eax
f0105807:	89 d1                	mov    %edx,%ecx
f0105809:	29 c1                	sub    %eax,%ecx
f010580b:	89 c8                	mov    %ecx,%eax
f010580d:	c1 f8 02             	sar    $0x2,%eax
f0105810:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
}
f0105816:	5d                   	pop    %ebp
f0105817:	c3                   	ret    

f0105818 <page2pa>:

static inline physaddr_t
page2pa(struct Page *pp)
{
f0105818:	55                   	push   %ebp
f0105819:	89 e5                	mov    %esp,%ebp
f010581b:	83 ec 04             	sub    $0x4,%esp
	return page2ppn(pp) << PGSHIFT;
f010581e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105821:	89 04 24             	mov    %eax,(%esp)
f0105824:	e8 d3 ff ff ff       	call   f01057fc <page2ppn>
f0105829:	c1 e0 0c             	shl    $0xc,%eax
}
f010582c:	c9                   	leave  
f010582d:	c3                   	ret    

f010582e <page2kva>:
	return &pages[PPN(pa)];
}

static inline void*
page2kva(struct Page *pp)
{
f010582e:	55                   	push   %ebp
f010582f:	89 e5                	mov    %esp,%ebp
f0105831:	83 ec 28             	sub    $0x28,%esp
	return KADDR(page2pa(pp));
f0105834:	8b 45 08             	mov    0x8(%ebp),%eax
f0105837:	89 04 24             	mov    %eax,(%esp)
f010583a:	e8 d9 ff ff ff       	call   f0105818 <page2pa>
f010583f:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0105842:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105845:	c1 e8 0c             	shr    $0xc,%eax
f0105848:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010584b:	a1 c0 94 1a f0       	mov    0xf01a94c0,%eax
f0105850:	39 45 f0             	cmp    %eax,-0x10(%ebp)
f0105853:	72 23                	jb     f0105878 <page2kva+0x4a>
f0105855:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105858:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010585c:	c7 44 24 08 64 8b 10 	movl   $0xf0108b64,0x8(%esp)
f0105863:	f0 
f0105864:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f010586b:	00 
f010586c:	c7 04 24 87 8b 10 f0 	movl   $0xf0108b87,(%esp)
f0105873:	e8 26 a9 ff ff       	call   f010019e <_panic>
f0105878:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010587b:	2d 00 00 00 10       	sub    $0x10000000,%eax
}
f0105880:	c9                   	leave  
f0105881:	c3                   	ret    

f0105882 <sys_cputs>:
// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
f0105882:	55                   	push   %ebp
f0105883:	89 e5                	mov    %esp,%ebp
f0105885:	83 ec 18             	sub    $0x18,%esp
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
	
	// LAB 3: Your code here.
    user_mem_assert(curenv, s, len, PTE_U);//env s.begin s.len power
f0105888:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010588d:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105894:	00 
f0105895:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105898:	89 54 24 08          	mov    %edx,0x8(%esp)
f010589c:	8b 55 08             	mov    0x8(%ebp),%edx
f010589f:	89 54 24 04          	mov    %edx,0x4(%esp)
f01058a3:	89 04 24             	mov    %eax,(%esp)
f01058a6:	e8 e6 d3 ff ff       	call   f0102c91 <user_mem_assert>
	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f01058ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01058ae:	89 44 24 08          	mov    %eax,0x8(%esp)
f01058b2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01058b5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01058b9:	c7 04 24 95 8b 10 f0 	movl   $0xf0108b95,(%esp)
f01058c0:	e8 c9 ed ff ff       	call   f010468e <cprintf>
}
f01058c5:	c9                   	leave  
f01058c6:	c3                   	ret    

f01058c7 <sys_cgetc>:

// Read a character from the system console.
// Returns the character.
static int
sys_cgetc(void)
{
f01058c7:	55                   	push   %ebp
f01058c8:	89 e5                	mov    %esp,%ebp
f01058ca:	83 ec 18             	sub    $0x18,%esp
	int c;

	// The cons_getc() primitive doesn't wait for a character,
	// but the sys_cgetc() system call does.
	while ((c = cons_getc()) == 0)
f01058cd:	e8 2e b1 ff ff       	call   f0100a00 <cons_getc>
f01058d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01058d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01058d9:	74 f2                	je     f01058cd <sys_cgetc+0x6>
		/* do nothing */;

	return c;
f01058db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f01058de:	c9                   	leave  
f01058df:	c3                   	ret    

f01058e0 <sys_getenvid>:

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
f01058e0:	55                   	push   %ebp
f01058e1:	89 e5                	mov    %esp,%ebp
	return curenv->env_id;
f01058e3:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f01058e8:	8b 40 4c             	mov    0x4c(%eax),%eax
}
f01058eb:	5d                   	pop    %ebp
f01058ec:	c3                   	ret    

f01058ed <sys_env_destroy>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
f01058ed:	55                   	push   %ebp
f01058ee:	89 e5                	mov    %esp,%ebp
f01058f0:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f01058f3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01058fa:	00 
f01058fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
f01058fe:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105902:	8b 45 08             	mov    0x8(%ebp),%eax
f0105905:	89 04 24             	mov    %eax,(%esp)
f0105908:	e8 53 e2 ff ff       	call   f0103b60 <envid2env>
f010590d:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0105910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0105914:	79 05                	jns    f010591b <sys_env_destroy+0x2e>
		return r;
f0105916:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105919:	eb 10                	jmp    f010592b <sys_env_destroy+0x3e>
	env_destroy(e);
f010591b:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010591e:	89 04 24             	mov    %eax,(%esp)
f0105921:	e8 99 e9 ff ff       	call   f01042bf <env_destroy>
	return 0;
f0105926:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010592b:	c9                   	leave  
f010592c:	c3                   	ret    

f010592d <sys_yield>:

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
f010592d:	55                   	push   %ebp
f010592e:	89 e5                	mov    %esp,%ebp
f0105930:	83 ec 08             	sub    $0x8,%esp
	sched_yield();
f0105933:	e8 f4 fd ff ff       	call   f010572c <sched_yield>

f0105938 <sys_exofork>:
// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
static envid_t
sys_exofork(void)
{
f0105938:	55                   	push   %ebp
f0105939:	89 e5                	mov    %esp,%ebp
f010593b:	57                   	push   %edi
f010593c:	56                   	push   %esi
f010593d:	53                   	push   %ebx
f010593e:	83 ec 2c             	sub    $0x2c,%esp
	// will appear to return 0.
	
	// LAB 4: Your code here.
	struct Env *newenv;
	int r;
	if((r = env_alloc(&newenv, sys_getenvid())) < 0) return r;
f0105941:	e8 9a ff ff ff       	call   f01058e0 <sys_getenvid>
f0105946:	89 44 24 04          	mov    %eax,0x4(%esp)
f010594a:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010594d:	89 04 24             	mov    %eax,(%esp)
f0105950:	e8 21 e4 ff ff       	call   f0103d76 <env_alloc>
f0105955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010595c:	79 05                	jns    f0105963 <sys_exofork+0x2b>
f010595e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105961:	eb 31                	jmp    f0105994 <sys_exofork+0x5c>
	
	//set not runnable
	newenv->env_status = ENV_NOT_RUNNABLE;
f0105963:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105966:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	//copy tf
	newenv->env_tf = curenv->env_tf;
f010596d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105970:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0105975:	89 c3                	mov    %eax,%ebx
f0105977:	b8 11 00 00 00       	mov    $0x11,%eax
f010597c:	89 d7                	mov    %edx,%edi
f010597e:	89 de                	mov    %ebx,%esi
f0105980:	89 c1                	mov    %eax,%ecx
f0105982:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	//copy the page fault hander
	//newenv->env_pgfault_upcall = curenv->env_pgfault_upcall;
	//make the child env's return to 0
	newenv->env_tf.tf_regs.reg_eax = 0;	
f0105984:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105987:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return newenv->env_id;
f010598e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105991:	8b 40 4c             	mov    0x4c(%eax),%eax
	//panic("sys_exofork not implemented");
}
f0105994:	83 c4 2c             	add    $0x2c,%esp
f0105997:	5b                   	pop    %ebx
f0105998:	5e                   	pop    %esi
f0105999:	5f                   	pop    %edi
f010599a:	5d                   	pop    %ebp
f010599b:	c3                   	ret    

f010599c <sys_env_set_priority>:

//set the SYS_env_set_priority
static int
sys_env_set_priority(envid_t envid, int priority)
{
f010599c:	55                   	push   %ebp
f010599d:	89 e5                	mov    %esp,%ebp
f010599f:	83 ec 28             	sub    $0x28,%esp
		return -E_INVAL;
	}*/
	struct Env *env_pri;
	int r;
	//look for envs by id
	if((r = envid2env(envid, &env_pri, 1)) < 0) return r;
f01059a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01059a9:	00 
f01059aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
f01059ad:	89 44 24 04          	mov    %eax,0x4(%esp)
f01059b1:	8b 45 08             	mov    0x8(%ebp),%eax
f01059b4:	89 04 24             	mov    %eax,(%esp)
f01059b7:	e8 a4 e1 ff ff       	call   f0103b60 <envid2env>
f01059bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01059bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01059c3:	79 05                	jns    f01059ca <sys_env_set_priority+0x2e>
f01059c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01059c8:	eb 0e                	jmp    f01059d8 <sys_env_set_priority+0x3c>
	
	env_pri->env_priority = priority;
f01059ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01059cd:	8b 55 0c             	mov    0xc(%ebp),%edx
f01059d0:	89 50 7c             	mov    %edx,0x7c(%eax)
	
	return 0;
f01059d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01059d8:	c9                   	leave  
f01059d9:	c3                   	ret    

f01059da <sys_env_set_status>:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
f01059da:	55                   	push   %ebp
f01059db:	89 e5                	mov    %esp,%ebp
f01059dd:	83 ec 28             	sub    $0x28,%esp
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.
	
	// LAB 4: Your code here.
	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE){
f01059e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f01059e4:	74 0d                	je     f01059f3 <sys_env_set_status+0x19>
f01059e6:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
f01059ea:	74 07                	je     f01059f3 <sys_env_set_status+0x19>
		return -E_INVAL;
f01059ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01059f1:	eb 36                	jmp    f0105a29 <sys_env_set_status+0x4f>
	}
	struct Env *env_sta;
	int r;
	//look for envs by id
	if((r = envid2env(envid, &env_sta, 1)) < 0) return r;
f01059f3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01059fa:	00 
f01059fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
f01059fe:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105a02:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a05:	89 04 24             	mov    %eax,(%esp)
f0105a08:	e8 53 e1 ff ff       	call   f0103b60 <envid2env>
f0105a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0105a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0105a14:	79 05                	jns    f0105a1b <sys_env_set_status+0x41>
f0105a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105a19:	eb 0e                	jmp    f0105a29 <sys_env_set_status+0x4f>
	
	env_sta->env_status = status;
f0105a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105a21:	89 50 54             	mov    %edx,0x54(%eax)
	
	return 0;
f0105a24:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("sys_env_set_status not implemented");
}
f0105a29:	c9                   	leave  
f0105a2a:	c3                   	ret    

f0105a2b <sys_env_set_trapframe>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
f0105a2b:	55                   	push   %ebp
f0105a2c:	89 e5                	mov    %esp,%ebp
f0105a2e:	57                   	push   %edi
f0105a2f:	56                   	push   %esi
f0105a30:	53                   	push   %ebx
f0105a31:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	struct Env *env_tf;
	int r;
	if((r = envid2env(envid, &env_tf, 1)) < 0) return -E_BAD_ENV;
f0105a34:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105a3b:	00 
f0105a3c:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105a3f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105a43:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a46:	89 04 24             	mov    %eax,(%esp)
f0105a49:	e8 12 e1 ff ff       	call   f0103b60 <envid2env>
f0105a4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105a51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105a55:	79 07                	jns    f0105a5e <sys_env_set_trapframe+0x33>
f0105a57:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105a5c:	eb 54                	jmp    f0105ab2 <sys_env_set_trapframe+0x87>
	user_mem_assert (env_tf, tf, sizeof (struct Trapframe), PTE_U);
f0105a5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a61:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105a68:	00 
f0105a69:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0105a70:	00 
f0105a71:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105a74:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105a78:	89 04 24             	mov    %eax,(%esp)
f0105a7b:	e8 11 d2 ff ff       	call   f0102c91 <user_mem_assert>
	env_tf->env_tf.tf_cs = GD_UT | 3;
f0105a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a83:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
    env_tf->env_tf.tf_eflags |= FL_IF;
f0105a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105a8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105a8f:	8b 52 38             	mov    0x38(%edx),%edx
f0105a92:	80 ce 02             	or     $0x2,%dh
f0105a95:	89 50 38             	mov    %edx,0x38(%eax)
	env_tf->env_tf = *tf;
f0105a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105a9e:	89 c3                	mov    %eax,%ebx
f0105aa0:	b8 11 00 00 00       	mov    $0x11,%eax
f0105aa5:	89 d7                	mov    %edx,%edi
f0105aa7:	89 de                	mov    %ebx,%esi
f0105aa9:	89 c1                	mov    %eax,%ecx
f0105aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	return 0;
f0105aad:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("sys_set_trapframe not implemented");
}
f0105ab2:	83 c4 2c             	add    $0x2c,%esp
f0105ab5:	5b                   	pop    %ebx
f0105ab6:	5e                   	pop    %esi
f0105ab7:	5f                   	pop    %edi
f0105ab8:	5d                   	pop    %ebp
f0105ab9:	c3                   	ret    

f0105aba <sys_env_set_pgfault_upcall>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
f0105aba:	55                   	push   %ebp
f0105abb:	89 e5                	mov    %esp,%ebp
f0105abd:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	struct Env *env;
	if(envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
f0105ac0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105ac7:	00 
f0105ac8:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0105acb:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105acf:	8b 45 08             	mov    0x8(%ebp),%eax
f0105ad2:	89 04 24             	mov    %eax,(%esp)
f0105ad5:	e8 86 e0 ff ff       	call   f0103b60 <envid2env>
f0105ada:	85 c0                	test   %eax,%eax
f0105adc:	79 07                	jns    f0105ae5 <sys_env_set_pgfault_upcall+0x2b>
f0105ade:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105ae3:	eb 0e                	jmp    f0105af3 <sys_env_set_pgfault_upcall+0x39>
	
	env->env_pgfault_upcall = func;
f0105ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105aeb:	89 50 64             	mov    %edx,0x64(%eax)
	return 0;
f0105aee:	b8 00 00 00 00       	mov    $0x0,%eax
	
	//panic("sys_env_set_pgfault_upcall not implemented");
}
f0105af3:	c9                   	leave  
f0105af4:	c3                   	ret    

f0105af5 <sys_page_alloc>:
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
f0105af5:	55                   	push   %ebp
f0105af6:	89 e5                	mov    %esp,%ebp
f0105af8:	83 ec 28             	sub    $0x28,%esp
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
	if(va >= (void *)UTOP) return -E_INVAL;//beyond
f0105afb:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105b02:	76 0a                	jbe    f0105b0e <sys_page_alloc+0x19>
f0105b04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105b09:	e9 08 01 00 00       	jmp    f0105c16 <sys_page_alloc+0x121>
	if(ROUNDUP(va, PGSIZE) != va) return -E_INVAL;//page-aligned
f0105b0e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
f0105b15:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105b18:	03 45 f4             	add    -0xc(%ebp),%eax
f0105b1b:	83 e8 01             	sub    $0x1,%eax
f0105b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105b24:	ba 00 00 00 00       	mov    $0x0,%edx
f0105b29:	f7 75 f4             	divl   -0xc(%ebp)
f0105b2c:	89 d0                	mov    %edx,%eax
f0105b2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105b31:	89 d1                	mov    %edx,%ecx
f0105b33:	29 c1                	sub    %eax,%ecx
f0105b35:	89 c8                	mov    %ecx,%eax
f0105b37:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0105b3a:	74 0a                	je     f0105b46 <sys_page_alloc+0x51>
f0105b3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105b41:	e9 d0 00 00 00       	jmp    f0105c16 <sys_page_alloc+0x121>
	if((perm & PTE_U)==0||(perm & PTE_P)==0) return -E_INVAL;//power
f0105b46:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b49:	83 e0 04             	and    $0x4,%eax
f0105b4c:	85 c0                	test   %eax,%eax
f0105b4e:	74 0a                	je     f0105b5a <sys_page_alloc+0x65>
f0105b50:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b53:	83 e0 01             	and    $0x1,%eax
f0105b56:	85 c0                	test   %eax,%eax
f0105b58:	75 0a                	jne    f0105b64 <sys_page_alloc+0x6f>
f0105b5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105b5f:	e9 b2 00 00 00       	jmp    f0105c16 <sys_page_alloc+0x121>
	if((perm & ~PTE_USER) > 0) return -E_INVAL;//?
f0105b64:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b67:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f0105b6c:	85 c0                	test   %eax,%eax
f0105b6e:	7e 0a                	jle    f0105b7a <sys_page_alloc+0x85>
f0105b70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105b75:	e9 9c 00 00 00       	jmp    f0105c16 <sys_page_alloc+0x121>
	
	struct Env *e;
	if(envid2env(envid, &e, 1) < 0) return -E_BAD_ENV;//environment envid doesn't currently
f0105b7a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105b81:	00 
f0105b82:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105b85:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105b89:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b8c:	89 04 24             	mov    %eax,(%esp)
f0105b8f:	e8 cc df ff ff       	call   f0103b60 <envid2env>
f0105b94:	85 c0                	test   %eax,%eax
f0105b96:	79 07                	jns    f0105b9f <sys_page_alloc+0xaa>
f0105b98:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105b9d:	eb 77                	jmp    f0105c16 <sys_page_alloc+0x121>
	
	struct Page *pg;
	if(page_alloc(&pg) < 0) return -E_NO_MEM;
f0105b9f:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0105ba2:	89 04 24             	mov    %eax,(%esp)
f0105ba5:	e8 d7 cb ff ff       	call   f0102781 <page_alloc>
f0105baa:	85 c0                	test   %eax,%eax
f0105bac:	79 07                	jns    f0105bb5 <sys_page_alloc+0xc0>
f0105bae:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105bb3:	eb 61                	jmp    f0105c16 <sys_page_alloc+0x121>
	if(page_insert(e->env_pgdir, pg, va, perm) < 0){
f0105bb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105bbb:	8b 40 5c             	mov    0x5c(%eax),%eax
f0105bbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105bc1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0105bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105bc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105bcc:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105bd0:	89 04 24             	mov    %eax,(%esp)
f0105bd3:	e8 fc cd ff ff       	call   f01029d4 <page_insert>
f0105bd8:	85 c0                	test   %eax,%eax
f0105bda:	79 12                	jns    f0105bee <sys_page_alloc+0xf9>
		page_free(pg);//free it
f0105bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105bdf:	89 04 24             	mov    %eax,(%esp)
f0105be2:	e8 ed cb ff ff       	call   f01027d4 <page_free>
		return -E_NO_MEM;
f0105be7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105bec:	eb 28                	jmp    f0105c16 <sys_page_alloc+0x121>
	}
	memset(page2kva(pg), 0, PGSIZE);
f0105bee:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105bf1:	89 04 24             	mov    %eax,(%esp)
f0105bf4:	e8 35 fc ff ff       	call   f010582e <page2kva>
f0105bf9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0105c00:	00 
f0105c01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0105c08:	00 
f0105c09:	89 04 24             	mov    %eax,(%esp)
f0105c0c:	e8 e2 15 00 00       	call   f01071f3 <memset>
	return 0;
f0105c11:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("sys_page_alloc not implemented");
}
f0105c16:	c9                   	leave  
f0105c17:	c3                   	ret    

f0105c18 <sys_page_map>:
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
f0105c18:	55                   	push   %ebp
f0105c19:	89 e5                	mov    %esp,%ebp
f0105c1b:	83 ec 38             	sub    $0x38,%esp
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
	if(srcva >= (void *)UTOP) return -E_INVAL;
f0105c1e:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105c25:	76 0a                	jbe    f0105c31 <sys_page_map+0x19>
f0105c27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105c2c:	e9 79 01 00 00       	jmp    f0105daa <sys_page_map+0x192>
	if(ROUNDUP(srcva, PGSIZE) != srcva) return -E_INVAL;
f0105c31:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
f0105c38:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105c3b:	03 45 f4             	add    -0xc(%ebp),%eax
f0105c3e:	83 e8 01             	sub    $0x1,%eax
f0105c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105c47:	ba 00 00 00 00       	mov    $0x0,%edx
f0105c4c:	f7 75 f4             	divl   -0xc(%ebp)
f0105c4f:	89 d0                	mov    %edx,%eax
f0105c51:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105c54:	89 d1                	mov    %edx,%ecx
f0105c56:	29 c1                	sub    %eax,%ecx
f0105c58:	89 c8                	mov    %ecx,%eax
f0105c5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0105c5d:	74 0a                	je     f0105c69 <sys_page_map+0x51>
f0105c5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105c64:	e9 41 01 00 00       	jmp    f0105daa <sys_page_map+0x192>
	if(dstva >= (void *)UTOP) return -E_INVAL;
f0105c69:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0105c70:	76 0a                	jbe    f0105c7c <sys_page_map+0x64>
f0105c72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105c77:	e9 2e 01 00 00       	jmp    f0105daa <sys_page_map+0x192>
	if(ROUNDUP(dstva, PGSIZE) != dstva) return -E_INVAL;
f0105c7c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
f0105c83:	8b 45 14             	mov    0x14(%ebp),%eax
f0105c86:	03 45 ec             	add    -0x14(%ebp),%eax
f0105c89:	83 e8 01             	sub    $0x1,%eax
f0105c8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0105c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105c92:	ba 00 00 00 00       	mov    $0x0,%edx
f0105c97:	f7 75 ec             	divl   -0x14(%ebp)
f0105c9a:	89 d0                	mov    %edx,%eax
f0105c9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105c9f:	89 d1                	mov    %edx,%ecx
f0105ca1:	29 c1                	sub    %eax,%ecx
f0105ca3:	89 c8                	mov    %ecx,%eax
f0105ca5:	3b 45 14             	cmp    0x14(%ebp),%eax
f0105ca8:	74 0a                	je     f0105cb4 <sys_page_map+0x9c>
f0105caa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105caf:	e9 f6 00 00 00       	jmp    f0105daa <sys_page_map+0x192>
	if((perm & PTE_U)==0&&(perm & PTE_P)==0) return -E_INVAL;
f0105cb4:	8b 45 18             	mov    0x18(%ebp),%eax
f0105cb7:	83 e0 04             	and    $0x4,%eax
f0105cba:	85 c0                	test   %eax,%eax
f0105cbc:	75 14                	jne    f0105cd2 <sys_page_map+0xba>
f0105cbe:	8b 45 18             	mov    0x18(%ebp),%eax
f0105cc1:	83 e0 01             	and    $0x1,%eax
f0105cc4:	85 c0                	test   %eax,%eax
f0105cc6:	75 0a                	jne    f0105cd2 <sys_page_map+0xba>
f0105cc8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105ccd:	e9 d8 00 00 00       	jmp    f0105daa <sys_page_map+0x192>
	if((perm & ~PTE_USER) > 0) return -E_INVAL;
f0105cd2:	8b 45 18             	mov    0x18(%ebp),%eax
f0105cd5:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f0105cda:	85 c0                	test   %eax,%eax
f0105cdc:	7e 0a                	jle    f0105ce8 <sys_page_map+0xd0>
f0105cde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105ce3:	e9 c2 00 00 00       	jmp    f0105daa <sys_page_map+0x192>
	
	struct Env *srcenv;
	if(envid2env(srcenvid, &srcenv, 1) < 0) return -E_BAD_ENV;
f0105ce8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105cef:	00 
f0105cf0:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105cf7:	8b 45 08             	mov    0x8(%ebp),%eax
f0105cfa:	89 04 24             	mov    %eax,(%esp)
f0105cfd:	e8 5e de ff ff       	call   f0103b60 <envid2env>
f0105d02:	85 c0                	test   %eax,%eax
f0105d04:	79 0a                	jns    f0105d10 <sys_page_map+0xf8>
f0105d06:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105d0b:	e9 9a 00 00 00       	jmp    f0105daa <sys_page_map+0x192>
	struct Env *dstenv;
	if(envid2env(dstenvid, &dstenv, 1) < 0) return -E_BAD_ENV;
f0105d10:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105d17:	00 
f0105d18:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105d1f:	8b 45 10             	mov    0x10(%ebp),%eax
f0105d22:	89 04 24             	mov    %eax,(%esp)
f0105d25:	e8 36 de ff ff       	call   f0103b60 <envid2env>
f0105d2a:	85 c0                	test   %eax,%eax
f0105d2c:	79 07                	jns    f0105d35 <sys_page_map+0x11d>
f0105d2e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105d33:	eb 75                	jmp    f0105daa <sys_page_map+0x192>
	
	pte_t *pte;
	struct Page *pg;
	pg = page_lookup(srcenv->env_pgdir, srcva, &pte);
f0105d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d38:	8b 40 5c             	mov    0x5c(%eax),%eax
f0105d3b:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105d3e:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105d42:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105d45:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105d49:	89 04 24             	mov    %eax,(%esp)
f0105d4c:	e8 ba cd ff ff       	call   f0102b0b <page_lookup>
f0105d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(pg == NULL||((perm & PTE_W)&&((*pte & PTE_W)==0))) return -E_INVAL;
f0105d54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105d58:	74 16                	je     f0105d70 <sys_page_map+0x158>
f0105d5a:	8b 45 18             	mov    0x18(%ebp),%eax
f0105d5d:	83 e0 02             	and    $0x2,%eax
f0105d60:	85 c0                	test   %eax,%eax
f0105d62:	74 13                	je     f0105d77 <sys_page_map+0x15f>
f0105d64:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105d67:	8b 00                	mov    (%eax),%eax
f0105d69:	83 e0 02             	and    $0x2,%eax
f0105d6c:	85 c0                	test   %eax,%eax
f0105d6e:	75 07                	jne    f0105d77 <sys_page_map+0x15f>
f0105d70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105d75:	eb 33                	jmp    f0105daa <sys_page_map+0x192>
	
	if(page_insert(dstenv->env_pgdir, pg, dstva, perm) < 0)
f0105d77:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105d7a:	8b 40 5c             	mov    0x5c(%eax),%eax
f0105d7d:	8b 55 18             	mov    0x18(%ebp),%edx
f0105d80:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105d84:	8b 55 14             	mov    0x14(%ebp),%edx
f0105d87:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105d8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105d8e:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105d92:	89 04 24             	mov    %eax,(%esp)
f0105d95:	e8 3a cc ff ff       	call   f01029d4 <page_insert>
f0105d9a:	85 c0                	test   %eax,%eax
f0105d9c:	79 07                	jns    f0105da5 <sys_page_map+0x18d>
	   return -E_NO_MEM;
f0105d9e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105da3:	eb 05                	jmp    f0105daa <sys_page_map+0x192>
	
	return 0;
f0105da5:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("sys_page_map not implemented");
}
f0105daa:	c9                   	leave  
f0105dab:	c3                   	ret    

f0105dac <sys_page_unmap>:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
f0105dac:	55                   	push   %ebp
f0105dad:	89 e5                	mov    %esp,%ebp
f0105daf:	83 ec 28             	sub    $0x28,%esp
	// Hint: This function is a wrapper around page_remove().
	// LAB 4: Your code here.
	if(va >= (void *)UTOP) return -E_INVAL;
f0105db2:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105db9:	76 07                	jbe    f0105dc2 <sys_page_unmap+0x16>
f0105dbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105dc0:	eb 74                	jmp    f0105e36 <sys_page_unmap+0x8a>
	if(ROUNDUP(va, PGSIZE) != va) return -E_INVAL;
f0105dc2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
f0105dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105dcc:	03 45 f4             	add    -0xc(%ebp),%eax
f0105dcf:	83 e8 01             	sub    $0x1,%eax
f0105dd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105dd8:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ddd:	f7 75 f4             	divl   -0xc(%ebp)
f0105de0:	89 d0                	mov    %edx,%eax
f0105de2:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105de5:	89 d1                	mov    %edx,%ecx
f0105de7:	29 c1                	sub    %eax,%ecx
f0105de9:	89 c8                	mov    %ecx,%eax
f0105deb:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0105dee:	74 07                	je     f0105df7 <sys_page_unmap+0x4b>
f0105df0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105df5:	eb 3f                	jmp    f0105e36 <sys_page_unmap+0x8a>
	
	struct Env *env;
	if(envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
f0105df7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105dfe:	00 
f0105dff:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105e02:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105e06:	8b 45 08             	mov    0x8(%ebp),%eax
f0105e09:	89 04 24             	mov    %eax,(%esp)
f0105e0c:	e8 4f dd ff ff       	call   f0103b60 <envid2env>
f0105e11:	85 c0                	test   %eax,%eax
f0105e13:	79 07                	jns    f0105e1c <sys_page_unmap+0x70>
f0105e15:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105e1a:	eb 1a                	jmp    f0105e36 <sys_page_unmap+0x8a>
	
	page_remove(env->env_pgdir, va);
f0105e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105e1f:	8b 40 5c             	mov    0x5c(%eax),%eax
f0105e22:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105e25:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105e29:	89 04 24             	mov    %eax,(%esp)
f0105e2c:	e8 33 cd ff ff       	call   f0102b64 <page_remove>
	
	return 0;
f0105e31:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("sys_page_unmap not implemented");
}
f0105e36:	c9                   	leave  
f0105e37:	c3                   	ret    

f0105e38 <sys_ipc_try_send>:
//		address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
f0105e38:	55                   	push   %ebp
f0105e39:	89 e5                	mov    %esp,%ebp
f0105e3b:	83 ec 38             	sub    $0x38,%esp
	// LAB 4: Your code here.
	struct Env *dstenv;
	int r;
	if((r = envid2env(envid, &dstenv, 0)) < 0) return -E_BAD_ENV;
f0105e3e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105e45:	00 
f0105e46:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0105e49:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105e4d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105e50:	89 04 24             	mov    %eax,(%esp)
f0105e53:	e8 08 dd ff ff       	call   f0103b60 <envid2env>
f0105e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105e5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0105e5f:	79 0a                	jns    f0105e6b <sys_ipc_try_send+0x33>
f0105e61:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105e66:	e9 6f 01 00 00       	jmp    f0105fda <sys_ipc_try_send+0x1a2>
	if(!dstenv->env_ipc_recving || dstenv->env_ipc_from != 0) return -E_IPC_NOT_RECV;
f0105e6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105e6e:	8b 40 68             	mov    0x68(%eax),%eax
f0105e71:	85 c0                	test   %eax,%eax
f0105e73:	74 0a                	je     f0105e7f <sys_ipc_try_send+0x47>
f0105e75:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105e78:	8b 40 74             	mov    0x74(%eax),%eax
f0105e7b:	85 c0                	test   %eax,%eax
f0105e7d:	74 0a                	je     f0105e89 <sys_ipc_try_send+0x51>
f0105e7f:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
f0105e84:	e9 51 01 00 00       	jmp    f0105fda <sys_ipc_try_send+0x1a2>
	if((srcva < (void *)UTOP) && ROUNDDOWN(srcva, PGSIZE) != srcva){//receive a page of data
f0105e89:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105e90:	77 1d                	ja     f0105eaf <sys_ipc_try_send+0x77>
f0105e92:	8b 45 10             	mov    0x10(%ebp),%eax
f0105e95:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105e9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0105ea0:	3b 45 10             	cmp    0x10(%ebp),%eax
f0105ea3:	74 0a                	je     f0105eaf <sys_ipc_try_send+0x77>
	    //cprintf("this page is not page-aligned\n");
	    return -E_INVAL;
f0105ea5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105eaa:	e9 2b 01 00 00       	jmp    f0105fda <sys_ipc_try_send+0x1a2>
	     //panic("this page is not page-aligned\n");
	}
	//cprintf("this page is page-aligned\n");
	if(srcva < (void *)UTOP){
f0105eaf:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105eb6:	77 34                	ja     f0105eec <sys_ipc_try_send+0xb4>
		if((perm & PTE_U) == 0 && (perm & PTE_P) == 0) return -E_INVAL;
f0105eb8:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ebb:	83 e0 04             	and    $0x4,%eax
f0105ebe:	85 c0                	test   %eax,%eax
f0105ec0:	75 14                	jne    f0105ed6 <sys_ipc_try_send+0x9e>
f0105ec2:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ec5:	83 e0 01             	and    $0x1,%eax
f0105ec8:	85 c0                	test   %eax,%eax
f0105eca:	75 0a                	jne    f0105ed6 <sys_ipc_try_send+0x9e>
f0105ecc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105ed1:	e9 04 01 00 00       	jmp    f0105fda <sys_ipc_try_send+0x1a2>
		if((perm & ~PTE_USER) > 0) return -E_INVAL;
f0105ed6:	8b 45 14             	mov    0x14(%ebp),%eax
f0105ed9:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f0105ede:	85 c0                	test   %eax,%eax
f0105ee0:	74 0a                	je     f0105eec <sys_ipc_try_send+0xb4>
f0105ee2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105ee7:	e9 ee 00 00 00       	jmp    f0105fda <sys_ipc_try_send+0x1a2>
	}
	//cprintf("perm normol\n");
	pte_t *pte;
	struct Page *pg;
	//not mapped in current env
	if(srcva < (void *)UTOP){
f0105eec:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105ef3:	77 51                	ja     f0105f46 <sys_ipc_try_send+0x10e>
		if((pg = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL) return -E_INVAL;
f0105ef5:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0105efa:	8b 40 5c             	mov    0x5c(%eax),%eax
f0105efd:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105f00:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105f04:	8b 55 10             	mov    0x10(%ebp),%edx
f0105f07:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105f0b:	89 04 24             	mov    %eax,(%esp)
f0105f0e:	e8 f8 cb ff ff       	call   f0102b0b <page_lookup>
f0105f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0105f16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0105f1a:	75 0a                	jne    f0105f26 <sys_ipc_try_send+0xee>
f0105f1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105f21:	e9 b4 00 00 00       	jmp    f0105fda <sys_ipc_try_send+0x1a2>
		if((*pte & PTE_W) == 0 && (perm & PTE_W) > 0) return -E_INVAL;
f0105f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f29:	8b 00                	mov    (%eax),%eax
f0105f2b:	83 e0 02             	and    $0x2,%eax
f0105f2e:	85 c0                	test   %eax,%eax
f0105f30:	75 14                	jne    f0105f46 <sys_ipc_try_send+0x10e>
f0105f32:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f35:	83 e0 02             	and    $0x2,%eax
f0105f38:	85 c0                	test   %eax,%eax
f0105f3a:	74 0a                	je     f0105f46 <sys_ipc_try_send+0x10e>
f0105f3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105f41:	e9 94 00 00 00       	jmp    f0105fda <sys_ipc_try_send+0x1a2>
	}
	//if env_ipc_dstva != 0 , send a page
	if(srcva >= (void *)UTOP) dstenv->env_ipc_perm = 0;
f0105f46:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105f4d:	76 0a                	jbe    f0105f59 <sys_ipc_try_send+0x121>
f0105f4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105f52:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	if(srcva < (void *)UTOP && dstenv->env_ipc_dstva <(void *)UTOP){//!= 0
f0105f59:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105f60:	77 47                	ja     f0105fa9 <sys_ipc_try_send+0x171>
f0105f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105f65:	8b 40 6c             	mov    0x6c(%eax),%eax
f0105f68:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
f0105f6d:	77 3a                	ja     f0105fa9 <sys_ipc_try_send+0x171>
		if(page_insert(dstenv->env_pgdir, pg, dstenv->env_ipc_dstva, perm) < 0) return -E_NO_MEM;
f0105f6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0105f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105f75:	8b 50 6c             	mov    0x6c(%eax),%edx
f0105f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105f7b:	8b 40 5c             	mov    0x5c(%eax),%eax
f0105f7e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0105f82:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105f86:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0105f89:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105f8d:	89 04 24             	mov    %eax,(%esp)
f0105f90:	e8 3f ca ff ff       	call   f01029d4 <page_insert>
f0105f95:	85 c0                	test   %eax,%eax
f0105f97:	79 07                	jns    f0105fa0 <sys_ipc_try_send+0x168>
f0105f99:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105f9e:	eb 3a                	jmp    f0105fda <sys_ipc_try_send+0x1a2>
		dstenv->env_ipc_perm = perm;
f0105fa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105fa3:	8b 55 14             	mov    0x14(%ebp),%edx
f0105fa6:	89 50 78             	mov    %edx,0x78(%eax)
	}
	dstenv->env_ipc_recving = 0;
f0105fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105fac:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
	dstenv->env_ipc_from = curenv->env_id;
f0105fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105fb6:	8b 15 28 88 1a f0    	mov    0xf01a8828,%edx
f0105fbc:	8b 52 4c             	mov    0x4c(%edx),%edx
f0105fbf:	89 50 74             	mov    %edx,0x74(%eax)
	dstenv->env_ipc_value = value;
f0105fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105fc8:	89 50 70             	mov    %edx,0x70(%eax)
	dstenv->env_status = ENV_RUNNABLE;
f0105fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105fce:	c7 40 54 01 00 00 00 	movl   $0x1,0x54(%eax)
	//dstenv->env_tf.tf_regs.reg_eax = 0;
	return 0;
f0105fd5:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("sys_ipc_try_send not implemented");
}
f0105fda:	c9                   	leave  
f0105fdb:	c3                   	ret    

f0105fdc <sys_ipc_recv>:
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
f0105fdc:	55                   	push   %ebp
f0105fdd:	89 e5                	mov    %esp,%ebp
f0105fdf:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	if((dstva < (void *)UTOP) && ROUNDDOWN(dstva, PGSIZE) != dstva){//receive a page of data
f0105fe2:	81 7d 08 ff ff bf ee 	cmpl   $0xeebfffff,0x8(%ebp)
f0105fe9:	77 2f                	ja     f010601a <sys_ipc_recv+0x3e>
f0105feb:	8b 45 08             	mov    0x8(%ebp),%eax
f0105fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0105ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105ff4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0105ff9:	3b 45 08             	cmp    0x8(%ebp),%eax
f0105ffc:	74 1c                	je     f010601a <sys_ipc_recv+0x3e>
	     panic("this page is not page-aligned\n");
f0105ffe:	c7 44 24 08 9c 8b 10 	movl   $0xf0108b9c,0x8(%esp)
f0106005:	f0 
f0106006:	c7 44 24 04 9d 01 00 	movl   $0x19d,0x4(%esp)
f010600d:	00 
f010600e:	c7 04 24 bb 8b 10 f0 	movl   $0xf0108bbb,(%esp)
f0106015:	e8 84 a1 ff ff       	call   f010019e <_panic>
	     return -E_INVAL;
	     //panic("this page is not page-aligned\n");
	}
	curenv->env_ipc_dstva = dstva;
f010601a:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010601f:	8b 55 08             	mov    0x8(%ebp),%edx
f0106022:	89 50 6c             	mov    %edx,0x6c(%eax)
	curenv->env_ipc_recving = 1;//wait for recv
f0106025:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010602a:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%eax)
	curenv->env_ipc_from = 0;
f0106031:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0106036:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f010603d:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f0106042:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	curenv->env_tf.tf_regs.reg_eax = 0;
f0106049:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010604e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	//why from is 0;
	sched_yield();
f0106055:	e8 d2 f6 ff ff       	call   f010572c <sched_yield>

f010605a <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f010605a:	55                   	push   %ebp
f010605b:	89 e5                	mov    %esp,%ebp
f010605d:	56                   	push   %esi
f010605e:	53                   	push   %ebx
f010605f:	83 ec 30             	sub    $0x30,%esp
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
    int32_t r = 0;
f0106062:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    switch(syscallno){//choose different no
f0106069:	83 7d 08 0e          	cmpl   $0xe,0x8(%ebp)
f010606d:	0f 87 6d 01 00 00    	ja     f01061e0 <syscall+0x186>
f0106073:	8b 45 08             	mov    0x8(%ebp),%eax
f0106076:	c1 e0 02             	shl    $0x2,%eax
f0106079:	05 cc 8b 10 f0       	add    $0xf0108bcc,%eax
f010607e:	8b 00                	mov    (%eax),%eax
f0106080:	ff e0                	jmp    *%eax
        //output 1
        case SYS_cputs:
            sys_cputs((const char*)a1, (size_t)a2); break;
f0106082:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106085:	8b 55 10             	mov    0x10(%ebp),%edx
f0106088:	89 54 24 04          	mov    %edx,0x4(%esp)
f010608c:	89 04 24             	mov    %eax,(%esp)
f010608f:	e8 ee f7 ff ff       	call   f0105882 <sys_cputs>
f0106094:	e9 4e 01 00 00       	jmp    f01061e7 <syscall+0x18d>
        //input 2
        case SYS_cgetc:
            r = sys_cgetc(); break;
f0106099:	e8 29 f8 ff ff       	call   f01058c7 <sys_cgetc>
f010609e:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01060a1:	e9 41 01 00 00       	jmp    f01061e7 <syscall+0x18d>
        //get pid 3
        case SYS_getenvid:
            r = sys_getenvid(); break;
f01060a6:	e8 35 f8 ff ff       	call   f01058e0 <sys_getenvid>
f01060ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01060ae:	e9 34 01 00 00       	jmp    f01061e7 <syscall+0x18d>
        //distroy a env 4
        case SYS_env_destroy:
            r = sys_env_destroy((envid_t)a1); break;
f01060b3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01060b6:	89 04 24             	mov    %eax,(%esp)
f01060b9:	e8 2f f8 ff ff       	call   f01058ed <sys_env_destroy>
f01060be:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01060c1:	e9 21 01 00 00       	jmp    f01061e7 <syscall+0x18d>
        //make another one 5
        case SYS_yield: sys_yield(); return 0;
f01060c6:	e8 62 f8 ff ff       	call   f010592d <sys_yield>
f01060cb:	b8 00 00 00 00       	mov    $0x0,%eax
f01060d0:	e9 15 01 00 00       	jmp    f01061ea <syscall+0x190>
        //fork a env 6
        case SYS_exofork:
            r = sys_exofork(); break;
f01060d5:	e8 5e f8 ff ff       	call   f0105938 <sys_exofork>
f01060da:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01060dd:	e9 05 01 00 00       	jmp    f01061e7 <syscall+0x18d>
        //set status 7
        case SYS_env_set_status: 
            r = sys_env_set_status((envid_t)a1, (int)a2); 
f01060e2:	8b 55 10             	mov    0x10(%ebp),%edx
f01060e5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01060e8:	89 54 24 04          	mov    %edx,0x4(%esp)
f01060ec:	89 04 24             	mov    %eax,(%esp)
f01060ef:	e8 e6 f8 ff ff       	call   f01059da <sys_env_set_status>
f01060f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f01060f7:	e9 eb 00 00 00       	jmp    f01061e7 <syscall+0x18d>
        //set trapframe 8
        case SYS_env_set_trapframe: 
            r = sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2); 
f01060fc:	8b 55 10             	mov    0x10(%ebp),%edx
f01060ff:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106102:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106106:	89 04 24             	mov    %eax,(%esp)
f0106109:	e8 1d f9 ff ff       	call   f0105a2b <sys_env_set_trapframe>
f010610e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f0106111:	e9 d1 00 00 00       	jmp    f01061e7 <syscall+0x18d>
        //set pgfault call 9
        case SYS_env_set_pgfault_upcall:
            r = sys_env_set_pgfault_upcall((envid_t)a1, (void *)a2);
f0106116:	8b 55 10             	mov    0x10(%ebp),%edx
f0106119:	8b 45 0c             	mov    0xc(%ebp),%eax
f010611c:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106120:	89 04 24             	mov    %eax,(%esp)
f0106123:	e8 92 f9 ff ff       	call   f0105aba <sys_env_set_pgfault_upcall>
f0106128:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f010612b:	e9 b7 00 00 00       	jmp    f01061e7 <syscall+0x18d>
        //page alloc 10
        case SYS_page_alloc: 
            r = sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
f0106130:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0106133:	8b 55 10             	mov    0x10(%ebp),%edx
f0106136:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106139:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010613d:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106141:	89 04 24             	mov    %eax,(%esp)
f0106144:	e8 ac f9 ff ff       	call   f0105af5 <sys_page_alloc>
f0106149:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f010614c:	e9 96 00 00 00       	jmp    f01061e7 <syscall+0x18d>
        //page map 11
        case SYS_page_map: 
            r = sys_page_map((envid_t)a1, (void *)a2, (envid_t)a3, (void *)a4, (int)a5);
f0106151:	8b 75 1c             	mov    0x1c(%ebp),%esi
f0106154:	8b 5d 18             	mov    0x18(%ebp),%ebx
f0106157:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010615a:	8b 55 10             	mov    0x10(%ebp),%edx
f010615d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106160:	89 74 24 10          	mov    %esi,0x10(%esp)
f0106164:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0106168:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010616c:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106170:	89 04 24             	mov    %eax,(%esp)
f0106173:	e8 a0 fa ff ff       	call   f0105c18 <sys_page_map>
f0106178:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f010617b:	eb 6a                	jmp    f01061e7 <syscall+0x18d>
        //page unmap 12
        case SYS_page_unmap: 
            r = sys_page_unmap((envid_t)a1, (void *)a2);
f010617d:	8b 55 10             	mov    0x10(%ebp),%edx
f0106180:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106183:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106187:	89 04 24             	mov    %eax,(%esp)
f010618a:	e8 1d fc ff ff       	call   f0105dac <sys_page_unmap>
f010618f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f0106192:	eb 53                	jmp    f01061e7 <syscall+0x18d>
        // 13
        case SYS_ipc_try_send: 
            r = sys_ipc_try_send((envid_t)a1, (uint32_t)a2, (void *)a3, (unsigned)a4);
f0106194:	8b 55 14             	mov    0x14(%ebp),%edx
f0106197:	8b 45 0c             	mov    0xc(%ebp),%eax
f010619a:	8b 4d 18             	mov    0x18(%ebp),%ecx
f010619d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f01061a1:	89 54 24 08          	mov    %edx,0x8(%esp)
f01061a5:	8b 55 10             	mov    0x10(%ebp),%edx
f01061a8:	89 54 24 04          	mov    %edx,0x4(%esp)
f01061ac:	89 04 24             	mov    %eax,(%esp)
f01061af:	e8 84 fc ff ff       	call   f0105e38 <sys_ipc_try_send>
f01061b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f01061b7:	eb 2e                	jmp    f01061e7 <syscall+0x18d>
        // 14
        case SYS_ipc_recv:
            r = sys_ipc_recv((void *)a1);
f01061b9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01061bc:	89 04 24             	mov    %eax,(%esp)
f01061bf:	e8 18 fe ff ff       	call   f0105fdc <sys_ipc_recv>
f01061c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f01061c7:	eb 1e                	jmp    f01061e7 <syscall+0x18d>
        // 15
        case SYS_env_set_priority:
            r = sys_env_set_priority((envid_t)a1, (int)a2);
f01061c9:	8b 55 10             	mov    0x10(%ebp),%edx
f01061cc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01061cf:	89 54 24 04          	mov    %edx,0x4(%esp)
f01061d3:	89 04 24             	mov    %eax,(%esp)
f01061d6:	e8 c1 f7 ff ff       	call   f010599c <sys_env_set_priority>
f01061db:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
f01061de:	eb 07                	jmp    f01061e7 <syscall+0x18d>
        default: r = -E_INVAL;
f01061e0:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    }
    return r;
f01061e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
	//panic("syscall not implemented");
}
f01061ea:	83 c4 30             	add    $0x30,%esp
f01061ed:	5b                   	pop    %ebx
f01061ee:	5e                   	pop    %esi
f01061ef:	5d                   	pop    %ebp
f01061f0:	c3                   	ret    
f01061f1:	00 00                	add    %al,(%eax)
	...

f01061f4 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f01061f4:	55                   	push   %ebp
f01061f5:	89 e5                	mov    %esp,%ebp
f01061f7:	83 ec 20             	sub    $0x20,%esp
	int l = *region_left, r = *region_right, any_matches = 0;
f01061fa:	8b 45 0c             	mov    0xc(%ebp),%eax
f01061fd:	8b 00                	mov    (%eax),%eax
f01061ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
f0106202:	8b 45 10             	mov    0x10(%ebp),%eax
f0106205:	8b 00                	mov    (%eax),%eax
f0106207:	89 45 f8             	mov    %eax,-0x8(%ebp)
f010620a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	
	while (l <= r) {
f0106211:	e9 c6 00 00 00       	jmp    f01062dc <stab_binsearch+0xe8>
		int true_m = (l + r) / 2, m = true_m;
f0106216:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0106219:	8b 55 fc             	mov    -0x4(%ebp),%edx
f010621c:	01 d0                	add    %edx,%eax
f010621e:	89 c2                	mov    %eax,%edx
f0106220:	c1 ea 1f             	shr    $0x1f,%edx
f0106223:	01 d0                	add    %edx,%eax
f0106225:	d1 f8                	sar    %eax
f0106227:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010622a:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010622d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0106230:	eb 04                	jmp    f0106236 <stab_binsearch+0x42>
			m--;
f0106232:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0106236:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106239:	3b 45 fc             	cmp    -0x4(%ebp),%eax
f010623c:	7c 1b                	jl     f0106259 <stab_binsearch+0x65>
f010623e:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0106241:	89 d0                	mov    %edx,%eax
f0106243:	01 c0                	add    %eax,%eax
f0106245:	01 d0                	add    %edx,%eax
f0106247:	c1 e0 02             	shl    $0x2,%eax
f010624a:	03 45 08             	add    0x8(%ebp),%eax
f010624d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f0106251:	0f b6 c0             	movzbl %al,%eax
f0106254:	3b 45 14             	cmp    0x14(%ebp),%eax
f0106257:	75 d9                	jne    f0106232 <stab_binsearch+0x3e>
			m--;
		if (m < l) {	// no match in [l, m]
f0106259:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010625c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
f010625f:	7d 0b                	jge    f010626c <stab_binsearch+0x78>
			l = true_m + 1;
f0106261:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106264:	83 c0 01             	add    $0x1,%eax
f0106267:	89 45 fc             	mov    %eax,-0x4(%ebp)
			continue;
f010626a:	eb 70                	jmp    f01062dc <stab_binsearch+0xe8>
		}

		// actual binary search
		any_matches = 1;
f010626c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		if (stabs[m].n_value < addr) {
f0106273:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0106276:	89 d0                	mov    %edx,%eax
f0106278:	01 c0                	add    %eax,%eax
f010627a:	01 d0                	add    %edx,%eax
f010627c:	c1 e0 02             	shl    $0x2,%eax
f010627f:	03 45 08             	add    0x8(%ebp),%eax
f0106282:	8b 40 08             	mov    0x8(%eax),%eax
f0106285:	3b 45 18             	cmp    0x18(%ebp),%eax
f0106288:	73 13                	jae    f010629d <stab_binsearch+0xa9>
			*region_left = m;
f010628a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010628d:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0106290:	89 10                	mov    %edx,(%eax)
			l = true_m + 1;
f0106292:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106295:	83 c0 01             	add    $0x1,%eax
f0106298:	89 45 fc             	mov    %eax,-0x4(%ebp)
f010629b:	eb 3f                	jmp    f01062dc <stab_binsearch+0xe8>
		} else if (stabs[m].n_value > addr) {
f010629d:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01062a0:	89 d0                	mov    %edx,%eax
f01062a2:	01 c0                	add    %eax,%eax
f01062a4:	01 d0                	add    %edx,%eax
f01062a6:	c1 e0 02             	shl    $0x2,%eax
f01062a9:	03 45 08             	add    0x8(%ebp),%eax
f01062ac:	8b 40 08             	mov    0x8(%eax),%eax
f01062af:	3b 45 18             	cmp    0x18(%ebp),%eax
f01062b2:	76 16                	jbe    f01062ca <stab_binsearch+0xd6>
			*region_right = m - 1;
f01062b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01062b7:	8d 50 ff             	lea    -0x1(%eax),%edx
f01062ba:	8b 45 10             	mov    0x10(%ebp),%eax
f01062bd:	89 10                	mov    %edx,(%eax)
			r = m - 1;
f01062bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01062c2:	83 e8 01             	sub    $0x1,%eax
f01062c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
f01062c8:	eb 12                	jmp    f01062dc <stab_binsearch+0xe8>
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01062ca:	8b 45 0c             	mov    0xc(%ebp),%eax
f01062cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01062d0:	89 10                	mov    %edx,(%eax)
			l = m;
f01062d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01062d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
			addr++;
f01062d8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
	
	while (l <= r) {
f01062dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
f01062df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
f01062e2:	0f 8e 2e ff ff ff    	jle    f0106216 <stab_binsearch+0x22>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f01062e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01062ec:	75 0f                	jne    f01062fd <stab_binsearch+0x109>
		*region_right = *region_left - 1;
f01062ee:	8b 45 0c             	mov    0xc(%ebp),%eax
f01062f1:	8b 00                	mov    (%eax),%eax
f01062f3:	8d 50 ff             	lea    -0x1(%eax),%edx
f01062f6:	8b 45 10             	mov    0x10(%ebp),%eax
f01062f9:	89 10                	mov    %edx,(%eax)
f01062fb:	eb 3b                	jmp    f0106338 <stab_binsearch+0x144>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01062fd:	8b 45 10             	mov    0x10(%ebp),%eax
f0106300:	8b 00                	mov    (%eax),%eax
f0106302:	89 45 fc             	mov    %eax,-0x4(%ebp)
f0106305:	eb 04                	jmp    f010630b <stab_binsearch+0x117>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
f0106307:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
		     l > *region_left && stabs[l].n_type != type;
f010630b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010630e:	8b 00                	mov    (%eax),%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0106310:	3b 45 fc             	cmp    -0x4(%ebp),%eax
f0106313:	7d 1b                	jge    f0106330 <stab_binsearch+0x13c>
		     l > *region_left && stabs[l].n_type != type;
f0106315:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0106318:	89 d0                	mov    %edx,%eax
f010631a:	01 c0                	add    %eax,%eax
f010631c:	01 d0                	add    %edx,%eax
f010631e:	c1 e0 02             	shl    $0x2,%eax
f0106321:	03 45 08             	add    0x8(%ebp),%eax
f0106324:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f0106328:	0f b6 c0             	movzbl %al,%eax
f010632b:	3b 45 14             	cmp    0x14(%ebp),%eax
f010632e:	75 d7                	jne    f0106307 <stab_binsearch+0x113>
		     l--)
			/* do nothing */;
		*region_left = l;
f0106330:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106333:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0106336:	89 10                	mov    %edx,(%eax)
	}
}
f0106338:	c9                   	leave  
f0106339:	c3                   	ret    

f010633a <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010633a:	55                   	push   %ebp
f010633b:	89 e5                	mov    %esp,%ebp
f010633d:	53                   	push   %ebx
f010633e:	83 ec 54             	sub    $0x54,%esp
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0106341:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106344:	c7 00 08 8c 10 f0    	movl   $0xf0108c08,(%eax)
	info->eip_line = 0;
f010634a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010634d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	info->eip_fn_name = "<unknown>";
f0106354:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106357:	c7 40 08 08 8c 10 f0 	movl   $0xf0108c08,0x8(%eax)
	info->eip_fn_namelen = 9;
f010635e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106361:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
	info->eip_fn_addr = addr;
f0106368:	8b 45 0c             	mov    0xc(%ebp),%eax
f010636b:	8b 55 08             	mov    0x8(%ebp),%edx
f010636e:	89 50 10             	mov    %edx,0x10(%eax)
	info->eip_fn_narg = 0;
f0106371:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106374:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f010637b:	81 7d 08 ff ff 7f ef 	cmpl   $0xef7fffff,0x8(%ebp)
f0106382:	76 21                	jbe    f01063a5 <debuginfo_eip+0x6b>
		stabs = __STAB_BEGIN__;
f0106384:	c7 45 f4 30 8f 10 f0 	movl   $0xf0108f30,-0xc(%ebp)
		stab_end = __STAB_END__;
f010638b:	c7 45 f0 bc 35 11 f0 	movl   $0xf01135bc,-0x10(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0106392:	c7 45 ec bd 35 11 f0 	movl   $0xf01135bd,-0x14(%ebp)
		stabstr_end = __STABSTR_END__;
f0106399:	c7 45 e8 a2 67 11 f0 	movl   $0xf01167a2,-0x18(%ebp)
f01063a0:	e9 a1 00 00 00       	jmp    f0106446 <debuginfo_eip+0x10c>
		// The user-application linker script, user/user.ld,
		// puts information about the application's stabs (equivalent
		// to __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__, and
		// __STABSTR_END__) in a structure located at virtual address
		// USTABDATA.
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;
f01063a5:	c7 45 e0 00 00 20 00 	movl   $0x200000,-0x20(%ebp)

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		
		stabs = usd->stabs;
f01063ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063af:	8b 00                	mov    (%eax),%eax
f01063b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		stab_end = usd->stab_end;
f01063b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063b7:	8b 40 04             	mov    0x4(%eax),%eax
f01063ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		stabstr = usd->stabstr;
f01063bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063c0:	8b 40 08             	mov    0x8(%eax),%eax
f01063c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		stabstr_end = usd->stabstr_end;
f01063c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063c9:	8b 40 0c             	mov    0xc(%eax),%eax
f01063cc:	89 45 e8             	mov    %eax,-0x18(%ebp)

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, stabs, stab_end - stabs, PTE_U) < 0 
f01063cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01063d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01063d5:	89 d1                	mov    %edx,%ecx
f01063d7:	29 c1                	sub    %eax,%ecx
f01063d9:	89 c8                	mov    %ecx,%eax
f01063db:	c1 f8 02             	sar    $0x2,%eax
f01063de:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f01063e4:	89 c2                	mov    %eax,%edx
f01063e6:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f01063eb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f01063f2:	00 
f01063f3:	89 54 24 08          	mov    %edx,0x8(%esp)
f01063f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01063fa:	89 54 24 04          	mov    %edx,0x4(%esp)
f01063fe:	89 04 24             	mov    %eax,(%esp)
f0106401:	e8 e2 c7 ff ff       	call   f0102be8 <user_mem_check>
f0106406:	85 c0                	test   %eax,%eax
f0106408:	78 32                	js     f010643c <debuginfo_eip+0x102>
		|| user_mem_check (curenv, stabstr, stabstr_end - stabstr, PTE_U) < 0){
f010640a:	8b 55 e8             	mov    -0x18(%ebp),%edx
f010640d:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106410:	89 d3                	mov    %edx,%ebx
f0106412:	29 c3                	sub    %eax,%ebx
f0106414:	89 d8                	mov    %ebx,%eax
f0106416:	89 c2                	mov    %eax,%edx
f0106418:	a1 28 88 1a f0       	mov    0xf01a8828,%eax
f010641d:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0106424:	00 
f0106425:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106429:	8b 55 ec             	mov    -0x14(%ebp),%edx
f010642c:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106430:	89 04 24             	mov    %eax,(%esp)
f0106433:	e8 b0 c7 ff ff       	call   f0102be8 <user_mem_check>
f0106438:	85 c0                	test   %eax,%eax
f010643a:	79 0a                	jns    f0106446 <debuginfo_eip+0x10c>
			return -1;
f010643c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0106441:	e9 00 02 00 00       	jmp    f0106646 <debuginfo_eip+0x30c>
		}
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0106446:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0106449:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f010644c:	76 0d                	jbe    f010645b <debuginfo_eip+0x121>
f010644e:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0106451:	83 e8 01             	sub    $0x1,%eax
f0106454:	0f b6 00             	movzbl (%eax),%eax
f0106457:	84 c0                	test   %al,%al
f0106459:	74 0a                	je     f0106465 <debuginfo_eip+0x12b>
		return -1;
f010645b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0106460:	e9 e1 01 00 00       	jmp    f0106646 <debuginfo_eip+0x30c>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0106465:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	rfile = (stab_end - stabs) - 1;
f010646c:	8b 55 f0             	mov    -0x10(%ebp),%edx
f010646f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106472:	89 d1                	mov    %edx,%ecx
f0106474:	29 c1                	sub    %eax,%ecx
f0106476:	89 c8                	mov    %ecx,%eax
f0106478:	c1 f8 02             	sar    $0x2,%eax
f010647b:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0106481:	83 e8 01             	sub    $0x1,%eax
f0106484:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0106487:	8b 45 08             	mov    0x8(%ebp),%eax
f010648a:	89 44 24 10          	mov    %eax,0x10(%esp)
f010648e:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
f0106495:	00 
f0106496:	8d 45 d4             	lea    -0x2c(%ebp),%eax
f0106499:	89 44 24 08          	mov    %eax,0x8(%esp)
f010649d:	8d 45 d8             	lea    -0x28(%ebp),%eax
f01064a0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01064a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01064a7:	89 04 24             	mov    %eax,(%esp)
f01064aa:	e8 45 fd ff ff       	call   f01061f4 <stab_binsearch>
	if (lfile == 0)
f01064af:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01064b2:	85 c0                	test   %eax,%eax
f01064b4:	75 0a                	jne    f01064c0 <debuginfo_eip+0x186>
		return -1;
f01064b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01064bb:	e9 86 01 00 00       	jmp    f0106646 <debuginfo_eip+0x30c>

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f01064c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01064c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	rfun = rfile;
f01064c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01064c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f01064cc:	8b 45 08             	mov    0x8(%ebp),%eax
f01064cf:	89 44 24 10          	mov    %eax,0x10(%esp)
f01064d3:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
f01064da:	00 
f01064db:	8d 45 cc             	lea    -0x34(%ebp),%eax
f01064de:	89 44 24 08          	mov    %eax,0x8(%esp)
f01064e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
f01064e5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01064e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01064ec:	89 04 24             	mov    %eax,(%esp)
f01064ef:	e8 00 fd ff ff       	call   f01061f4 <stab_binsearch>

	if (lfun <= rfun) {
f01064f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01064f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01064fa:	39 c2                	cmp    %eax,%edx
f01064fc:	7f 72                	jg     f0106570 <debuginfo_eip+0x236>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f01064fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106501:	89 c2                	mov    %eax,%edx
f0106503:	89 d0                	mov    %edx,%eax
f0106505:	01 c0                	add    %eax,%eax
f0106507:	01 d0                	add    %edx,%eax
f0106509:	c1 e0 02             	shl    $0x2,%eax
f010650c:	03 45 f4             	add    -0xc(%ebp),%eax
f010650f:	8b 10                	mov    (%eax),%edx
f0106511:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0106514:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106517:	89 cb                	mov    %ecx,%ebx
f0106519:	29 c3                	sub    %eax,%ebx
f010651b:	89 d8                	mov    %ebx,%eax
f010651d:	39 c2                	cmp    %eax,%edx
f010651f:	73 1e                	jae    f010653f <debuginfo_eip+0x205>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0106521:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106524:	89 c2                	mov    %eax,%edx
f0106526:	89 d0                	mov    %edx,%eax
f0106528:	01 c0                	add    %eax,%eax
f010652a:	01 d0                	add    %edx,%eax
f010652c:	c1 e0 02             	shl    $0x2,%eax
f010652f:	03 45 f4             	add    -0xc(%ebp),%eax
f0106532:	8b 00                	mov    (%eax),%eax
f0106534:	89 c2                	mov    %eax,%edx
f0106536:	03 55 ec             	add    -0x14(%ebp),%edx
f0106539:	8b 45 0c             	mov    0xc(%ebp),%eax
f010653c:	89 50 08             	mov    %edx,0x8(%eax)
		info->eip_fn_addr = stabs[lfun].n_value;
f010653f:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106542:	89 c2                	mov    %eax,%edx
f0106544:	89 d0                	mov    %edx,%eax
f0106546:	01 c0                	add    %eax,%eax
f0106548:	01 d0                	add    %edx,%eax
f010654a:	c1 e0 02             	shl    $0x2,%eax
f010654d:	03 45 f4             	add    -0xc(%ebp),%eax
f0106550:	8b 50 08             	mov    0x8(%eax),%edx
f0106553:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106556:	89 50 10             	mov    %edx,0x10(%eax)
		addr -= info->eip_fn_addr;
f0106559:	8b 45 0c             	mov    0xc(%ebp),%eax
f010655c:	8b 40 10             	mov    0x10(%eax),%eax
f010655f:	29 45 08             	sub    %eax,0x8(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f0106562:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		rline = rfun;
f0106568:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010656b:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010656e:	eb 15                	jmp    f0106585 <debuginfo_eip+0x24b>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0106570:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106573:	8b 55 08             	mov    0x8(%ebp),%edx
f0106576:	89 50 10             	mov    %edx,0x10(%eax)
		lline = lfile;
f0106579:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010657c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		rline = rfile;
f010657f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0106582:	89 45 dc             	mov    %eax,-0x24(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0106585:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106588:	8b 40 08             	mov    0x8(%eax),%eax
f010658b:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0106592:	00 
f0106593:	89 04 24             	mov    %eax,(%esp)
f0106596:	e8 29 0c 00 00       	call   f01071c4 <strfind>
f010659b:	89 c2                	mov    %eax,%edx
f010659d:	8b 45 0c             	mov    0xc(%ebp),%eax
f01065a0:	8b 40 08             	mov    0x8(%eax),%eax
f01065a3:	29 c2                	sub    %eax,%edx
f01065a5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01065a8:	89 50 0c             	mov    %edx,0xc(%eax)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01065ab:	eb 04                	jmp    f01065b1 <debuginfo_eip+0x277>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f01065ad:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01065b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01065b4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f01065b7:	7c 44                	jl     f01065fd <debuginfo_eip+0x2c3>
	       && stabs[lline].n_type != N_SOL
f01065b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01065bc:	89 d0                	mov    %edx,%eax
f01065be:	01 c0                	add    %eax,%eax
f01065c0:	01 d0                	add    %edx,%eax
f01065c2:	c1 e0 02             	shl    $0x2,%eax
f01065c5:	03 45 f4             	add    -0xc(%ebp),%eax
f01065c8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f01065cc:	3c 84                	cmp    $0x84,%al
f01065ce:	74 2d                	je     f01065fd <debuginfo_eip+0x2c3>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01065d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01065d3:	89 d0                	mov    %edx,%eax
f01065d5:	01 c0                	add    %eax,%eax
f01065d7:	01 d0                	add    %edx,%eax
f01065d9:	c1 e0 02             	shl    $0x2,%eax
f01065dc:	03 45 f4             	add    -0xc(%ebp),%eax
f01065df:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f01065e3:	3c 64                	cmp    $0x64,%al
f01065e5:	75 c6                	jne    f01065ad <debuginfo_eip+0x273>
f01065e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01065ea:	89 d0                	mov    %edx,%eax
f01065ec:	01 c0                	add    %eax,%eax
f01065ee:	01 d0                	add    %edx,%eax
f01065f0:	c1 e0 02             	shl    $0x2,%eax
f01065f3:	03 45 f4             	add    -0xc(%ebp),%eax
f01065f6:	8b 40 08             	mov    0x8(%eax),%eax
f01065f9:	85 c0                	test   %eax,%eax
f01065fb:	74 b0                	je     f01065ad <debuginfo_eip+0x273>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01065fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106600:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0106603:	7c 3c                	jl     f0106641 <debuginfo_eip+0x307>
f0106605:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0106608:	89 d0                	mov    %edx,%eax
f010660a:	01 c0                	add    %eax,%eax
f010660c:	01 d0                	add    %edx,%eax
f010660e:	c1 e0 02             	shl    $0x2,%eax
f0106611:	03 45 f4             	add    -0xc(%ebp),%eax
f0106614:	8b 10                	mov    (%eax),%edx
f0106616:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0106619:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010661c:	89 cb                	mov    %ecx,%ebx
f010661e:	29 c3                	sub    %eax,%ebx
f0106620:	89 d8                	mov    %ebx,%eax
f0106622:	39 c2                	cmp    %eax,%edx
f0106624:	73 1b                	jae    f0106641 <debuginfo_eip+0x307>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0106626:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0106629:	89 d0                	mov    %edx,%eax
f010662b:	01 c0                	add    %eax,%eax
f010662d:	01 d0                	add    %edx,%eax
f010662f:	c1 e0 02             	shl    $0x2,%eax
f0106632:	03 45 f4             	add    -0xc(%ebp),%eax
f0106635:	8b 00                	mov    (%eax),%eax
f0106637:	89 c2                	mov    %eax,%edx
f0106639:	03 55 ec             	add    -0x14(%ebp),%edx
f010663c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010663f:	89 10                	mov    %edx,(%eax)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	// Your code here.

	
	return 0;
f0106641:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106646:	83 c4 54             	add    $0x54,%esp
f0106649:	5b                   	pop    %ebx
f010664a:	5d                   	pop    %ebp
f010664b:	c3                   	ret    

f010664c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010664c:	55                   	push   %ebp
f010664d:	89 e5                	mov    %esp,%ebp
f010664f:	53                   	push   %ebx
f0106650:	83 ec 34             	sub    $0x34,%esp
f0106653:	8b 45 10             	mov    0x10(%ebp),%eax
f0106656:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106659:	8b 45 14             	mov    0x14(%ebp),%eax
f010665c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f010665f:	8b 45 18             	mov    0x18(%ebp),%eax
f0106662:	ba 00 00 00 00       	mov    $0x0,%edx
f0106667:	3b 55 f4             	cmp    -0xc(%ebp),%edx
f010666a:	77 72                	ja     f01066de <printnum+0x92>
f010666c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
f010666f:	72 05                	jb     f0106676 <printnum+0x2a>
f0106671:	3b 45 f0             	cmp    -0x10(%ebp),%eax
f0106674:	77 68                	ja     f01066de <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0106676:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0106679:	8d 58 ff             	lea    -0x1(%eax),%ebx
f010667c:	8b 45 18             	mov    0x18(%ebp),%eax
f010667f:	ba 00 00 00 00       	mov    $0x0,%edx
f0106684:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106688:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010668c:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010668f:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0106692:	89 04 24             	mov    %eax,(%esp)
f0106695:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106699:	e8 22 0e 00 00       	call   f01074c0 <__udivdi3>
f010669e:	8b 4d 20             	mov    0x20(%ebp),%ecx
f01066a1:	89 4c 24 18          	mov    %ecx,0x18(%esp)
f01066a5:	89 5c 24 14          	mov    %ebx,0x14(%esp)
f01066a9:	8b 4d 18             	mov    0x18(%ebp),%ecx
f01066ac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f01066b0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01066b4:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01066b8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01066bb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01066bf:	8b 45 08             	mov    0x8(%ebp),%eax
f01066c2:	89 04 24             	mov    %eax,(%esp)
f01066c5:	e8 82 ff ff ff       	call   f010664c <printnum>
f01066ca:	eb 1c                	jmp    f01066e8 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01066cc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01066cf:	89 44 24 04          	mov    %eax,0x4(%esp)
f01066d3:	8b 45 20             	mov    0x20(%ebp),%eax
f01066d6:	89 04 24             	mov    %eax,(%esp)
f01066d9:	8b 45 08             	mov    0x8(%ebp),%eax
f01066dc:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f01066de:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
f01066e2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
f01066e6:	7f e4                	jg     f01066cc <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01066e8:	8b 4d 18             	mov    0x18(%ebp),%ecx
f01066eb:	bb 00 00 00 00       	mov    $0x0,%ebx
f01066f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01066f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01066f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01066fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01066fe:	89 04 24             	mov    %eax,(%esp)
f0106701:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106705:	e8 e6 0e 00 00       	call   f01075f0 <__umoddi3>
f010670a:	05 7c 8d 10 f0       	add    $0xf0108d7c,%eax
f010670f:	0f b6 00             	movzbl (%eax),%eax
f0106712:	0f be c0             	movsbl %al,%eax
f0106715:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106718:	89 54 24 04          	mov    %edx,0x4(%esp)
f010671c:	89 04 24             	mov    %eax,(%esp)
f010671f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106722:	ff d0                	call   *%eax
}
f0106724:	83 c4 34             	add    $0x34,%esp
f0106727:	5b                   	pop    %ebx
f0106728:	5d                   	pop    %ebp
f0106729:	c3                   	ret    

f010672a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f010672a:	55                   	push   %ebp
f010672b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f010672d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f0106731:	7e 1c                	jle    f010674f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
f0106733:	8b 45 08             	mov    0x8(%ebp),%eax
f0106736:	8b 00                	mov    (%eax),%eax
f0106738:	8d 50 08             	lea    0x8(%eax),%edx
f010673b:	8b 45 08             	mov    0x8(%ebp),%eax
f010673e:	89 10                	mov    %edx,(%eax)
f0106740:	8b 45 08             	mov    0x8(%ebp),%eax
f0106743:	8b 00                	mov    (%eax),%eax
f0106745:	83 e8 08             	sub    $0x8,%eax
f0106748:	8b 50 04             	mov    0x4(%eax),%edx
f010674b:	8b 00                	mov    (%eax),%eax
f010674d:	eb 40                	jmp    f010678f <getuint+0x65>
	else if (lflag)
f010674f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106753:	74 1e                	je     f0106773 <getuint+0x49>
		return va_arg(*ap, unsigned long);
f0106755:	8b 45 08             	mov    0x8(%ebp),%eax
f0106758:	8b 00                	mov    (%eax),%eax
f010675a:	8d 50 04             	lea    0x4(%eax),%edx
f010675d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106760:	89 10                	mov    %edx,(%eax)
f0106762:	8b 45 08             	mov    0x8(%ebp),%eax
f0106765:	8b 00                	mov    (%eax),%eax
f0106767:	83 e8 04             	sub    $0x4,%eax
f010676a:	8b 00                	mov    (%eax),%eax
f010676c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106771:	eb 1c                	jmp    f010678f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
f0106773:	8b 45 08             	mov    0x8(%ebp),%eax
f0106776:	8b 00                	mov    (%eax),%eax
f0106778:	8d 50 04             	lea    0x4(%eax),%edx
f010677b:	8b 45 08             	mov    0x8(%ebp),%eax
f010677e:	89 10                	mov    %edx,(%eax)
f0106780:	8b 45 08             	mov    0x8(%ebp),%eax
f0106783:	8b 00                	mov    (%eax),%eax
f0106785:	83 e8 04             	sub    $0x4,%eax
f0106788:	8b 00                	mov    (%eax),%eax
f010678a:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010678f:	5d                   	pop    %ebp
f0106790:	c3                   	ret    

f0106791 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f0106791:	55                   	push   %ebp
f0106792:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0106794:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f0106798:	7e 1c                	jle    f01067b6 <getint+0x25>
		return va_arg(*ap, long long);
f010679a:	8b 45 08             	mov    0x8(%ebp),%eax
f010679d:	8b 00                	mov    (%eax),%eax
f010679f:	8d 50 08             	lea    0x8(%eax),%edx
f01067a2:	8b 45 08             	mov    0x8(%ebp),%eax
f01067a5:	89 10                	mov    %edx,(%eax)
f01067a7:	8b 45 08             	mov    0x8(%ebp),%eax
f01067aa:	8b 00                	mov    (%eax),%eax
f01067ac:	83 e8 08             	sub    $0x8,%eax
f01067af:	8b 50 04             	mov    0x4(%eax),%edx
f01067b2:	8b 00                	mov    (%eax),%eax
f01067b4:	eb 40                	jmp    f01067f6 <getint+0x65>
	else if (lflag)
f01067b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01067ba:	74 1e                	je     f01067da <getint+0x49>
		return va_arg(*ap, long);
f01067bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01067bf:	8b 00                	mov    (%eax),%eax
f01067c1:	8d 50 04             	lea    0x4(%eax),%edx
f01067c4:	8b 45 08             	mov    0x8(%ebp),%eax
f01067c7:	89 10                	mov    %edx,(%eax)
f01067c9:	8b 45 08             	mov    0x8(%ebp),%eax
f01067cc:	8b 00                	mov    (%eax),%eax
f01067ce:	83 e8 04             	sub    $0x4,%eax
f01067d1:	8b 00                	mov    (%eax),%eax
f01067d3:	89 c2                	mov    %eax,%edx
f01067d5:	c1 fa 1f             	sar    $0x1f,%edx
f01067d8:	eb 1c                	jmp    f01067f6 <getint+0x65>
	else
		return va_arg(*ap, int);
f01067da:	8b 45 08             	mov    0x8(%ebp),%eax
f01067dd:	8b 00                	mov    (%eax),%eax
f01067df:	8d 50 04             	lea    0x4(%eax),%edx
f01067e2:	8b 45 08             	mov    0x8(%ebp),%eax
f01067e5:	89 10                	mov    %edx,(%eax)
f01067e7:	8b 45 08             	mov    0x8(%ebp),%eax
f01067ea:	8b 00                	mov    (%eax),%eax
f01067ec:	83 e8 04             	sub    $0x4,%eax
f01067ef:	8b 00                	mov    (%eax),%eax
f01067f1:	89 c2                	mov    %eax,%edx
f01067f3:	c1 fa 1f             	sar    $0x1f,%edx
}
f01067f6:	5d                   	pop    %ebp
f01067f7:	c3                   	ret    

f01067f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f01067f8:	55                   	push   %ebp
f01067f9:	89 e5                	mov    %esp,%ebp
f01067fb:	56                   	push   %esi
f01067fc:	53                   	push   %ebx
f01067fd:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106800:	eb 17                	jmp    f0106819 <vprintfmt+0x21>
			if (ch == '\0')
f0106802:	85 db                	test   %ebx,%ebx
f0106804:	0f 84 d1 05 00 00    	je     f0106ddb <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
f010680a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010680d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106811:	89 1c 24             	mov    %ebx,(%esp)
f0106814:	8b 45 08             	mov    0x8(%ebp),%eax
f0106817:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106819:	8b 45 10             	mov    0x10(%ebp),%eax
f010681c:	0f b6 00             	movzbl (%eax),%eax
f010681f:	0f b6 d8             	movzbl %al,%ebx
f0106822:	83 fb 25             	cmp    $0x25,%ebx
f0106825:	0f 95 c0             	setne  %al
f0106828:	83 45 10 01          	addl   $0x1,0x10(%ebp)
f010682c:	84 c0                	test   %al,%al
f010682e:	75 d2                	jne    f0106802 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
f0106830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
f0106834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
f010683b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0106842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
f0106849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0106850:	eb 04                	jmp    f0106856 <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
f0106852:	90                   	nop
f0106853:	eb 01                	jmp    f0106856 <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
f0106855:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106856:	8b 45 10             	mov    0x10(%ebp),%eax
f0106859:	0f b6 00             	movzbl (%eax),%eax
f010685c:	0f b6 d8             	movzbl %al,%ebx
f010685f:	89 d8                	mov    %ebx,%eax
f0106861:	83 45 10 01          	addl   $0x1,0x10(%ebp)
f0106865:	83 e8 23             	sub    $0x23,%eax
f0106868:	83 f8 55             	cmp    $0x55,%eax
f010686b:	0f 87 39 05 00 00    	ja     f0106daa <vprintfmt+0x5b2>
f0106871:	8b 04 85 c4 8d 10 f0 	mov    -0xfef723c(,%eax,4),%eax
f0106878:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
f010687a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
f010687e:	eb d6                	jmp    f0106856 <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f0106880:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
f0106884:	eb d0                	jmp    f0106856 <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0106886:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
f010688d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0106890:	89 d0                	mov    %edx,%eax
f0106892:	c1 e0 02             	shl    $0x2,%eax
f0106895:	01 d0                	add    %edx,%eax
f0106897:	01 c0                	add    %eax,%eax
f0106899:	01 d8                	add    %ebx,%eax
f010689b:	83 e8 30             	sub    $0x30,%eax
f010689e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
f01068a1:	8b 45 10             	mov    0x10(%ebp),%eax
f01068a4:	0f b6 00             	movzbl (%eax),%eax
f01068a7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
f01068aa:	83 fb 2f             	cmp    $0x2f,%ebx
f01068ad:	7e 43                	jle    f01068f2 <vprintfmt+0xfa>
f01068af:	83 fb 39             	cmp    $0x39,%ebx
f01068b2:	7f 3e                	jg     f01068f2 <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f01068b4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
f01068b8:	eb d3                	jmp    f010688d <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f01068ba:	8b 45 14             	mov    0x14(%ebp),%eax
f01068bd:	83 c0 04             	add    $0x4,%eax
f01068c0:	89 45 14             	mov    %eax,0x14(%ebp)
f01068c3:	8b 45 14             	mov    0x14(%ebp),%eax
f01068c6:	83 e8 04             	sub    $0x4,%eax
f01068c9:	8b 00                	mov    (%eax),%eax
f01068cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
f01068ce:	eb 23                	jmp    f01068f3 <vprintfmt+0xfb>

		case '.':
			if (width < 0)
f01068d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01068d4:	0f 89 78 ff ff ff    	jns    f0106852 <vprintfmt+0x5a>
				width = 0;
f01068da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
f01068e1:	e9 6c ff ff ff       	jmp    f0106852 <vprintfmt+0x5a>

		case '#':
			altflag = 1;
f01068e6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
f01068ed:	e9 64 ff ff ff       	jmp    f0106856 <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
f01068f2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f01068f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01068f7:	0f 89 58 ff ff ff    	jns    f0106855 <vprintfmt+0x5d>
				width = precision, precision = -1;
f01068fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106900:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106903:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
f010690a:	e9 46 ff ff ff       	jmp    f0106855 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f010690f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
f0106913:	e9 3e ff ff ff       	jmp    f0106856 <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0106918:	8b 45 14             	mov    0x14(%ebp),%eax
f010691b:	83 c0 04             	add    $0x4,%eax
f010691e:	89 45 14             	mov    %eax,0x14(%ebp)
f0106921:	8b 45 14             	mov    0x14(%ebp),%eax
f0106924:	83 e8 04             	sub    $0x4,%eax
f0106927:	8b 00                	mov    (%eax),%eax
f0106929:	8b 55 0c             	mov    0xc(%ebp),%edx
f010692c:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106930:	89 04 24             	mov    %eax,(%esp)
f0106933:	8b 45 08             	mov    0x8(%ebp),%eax
f0106936:	ff d0                	call   *%eax
			break;
f0106938:	e9 98 04 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
f010693d:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
f0106944:	00 
f0106945:	8b 45 10             	mov    0x10(%ebp),%eax
f0106948:	89 44 24 04          	mov    %eax,0x4(%esp)
f010694c:	8d 45 d7             	lea    -0x29(%ebp),%eax
f010694f:	89 04 24             	mov    %eax,(%esp)
f0106952:	e8 cd 08 00 00       	call   f0107224 <memmove>
            sel_c[3] = '\0';
f0106957:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
f010695b:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
f010695f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
f0106963:	3c 2f                	cmp    $0x2f,%al
f0106965:	7e 4c                	jle    f01069b3 <vprintfmt+0x1bb>
f0106967:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
f010696b:	3c 39                	cmp    $0x39,%al
f010696d:	7f 44                	jg     f01069b3 <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
f010696f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
f0106973:	0f be d0             	movsbl %al,%edx
f0106976:	89 d0                	mov    %edx,%eax
f0106978:	c1 e0 02             	shl    $0x2,%eax
f010697b:	01 d0                	add    %edx,%eax
f010697d:	01 c0                	add    %eax,%eax
f010697f:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
f0106985:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
f0106989:	0f be c0             	movsbl %al,%eax
f010698c:	01 c2                	add    %eax,%edx
f010698e:	89 d0                	mov    %edx,%eax
f0106990:	c1 e0 02             	shl    $0x2,%eax
f0106993:	01 d0                	add    %edx,%eax
f0106995:	01 c0                	add    %eax,%eax
f0106997:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
f010699d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
f01069a1:	0f be c0             	movsbl %al,%eax
f01069a4:	01 d0                	add    %edx,%eax
f01069a6:	83 e8 30             	sub    $0x30,%eax
f01069a9:	a3 48 f6 11 f0       	mov    %eax,0xf011f648
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f01069ae:	e9 22 04 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
f01069b3:	c7 44 24 04 8d 8d 10 	movl   $0xf0108d8d,0x4(%esp)
f01069ba:	f0 
f01069bb:	8d 45 d7             	lea    -0x29(%ebp),%eax
f01069be:	89 04 24             	mov    %eax,(%esp)
f01069c1:	e8 32 07 00 00       	call   f01070f8 <strcmp>
f01069c6:	85 c0                	test   %eax,%eax
f01069c8:	75 0f                	jne    f01069d9 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
f01069ca:	c7 05 48 f6 11 f0 07 	movl   $0x7,0xf011f648
f01069d1:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f01069d4:	e9 fc 03 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
f01069d9:	c7 44 24 04 91 8d 10 	movl   $0xf0108d91,0x4(%esp)
f01069e0:	f0 
f01069e1:	8d 45 d7             	lea    -0x29(%ebp),%eax
f01069e4:	89 04 24             	mov    %eax,(%esp)
f01069e7:	e8 0c 07 00 00       	call   f01070f8 <strcmp>
f01069ec:	85 c0                	test   %eax,%eax
f01069ee:	75 0f                	jne    f01069ff <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
f01069f0:	c7 05 48 f6 11 f0 01 	movl   $0x1,0xf011f648
f01069f7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f01069fa:	e9 d6 03 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
f01069ff:	c7 44 24 04 95 8d 10 	movl   $0xf0108d95,0x4(%esp)
f0106a06:	f0 
f0106a07:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0106a0a:	89 04 24             	mov    %eax,(%esp)
f0106a0d:	e8 e6 06 00 00       	call   f01070f8 <strcmp>
f0106a12:	85 c0                	test   %eax,%eax
f0106a14:	75 0f                	jne    f0106a25 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
f0106a16:	c7 05 48 f6 11 f0 02 	movl   $0x2,0xf011f648
f0106a1d:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f0106a20:	e9 b0 03 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
f0106a25:	c7 44 24 04 99 8d 10 	movl   $0xf0108d99,0x4(%esp)
f0106a2c:	f0 
f0106a2d:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0106a30:	89 04 24             	mov    %eax,(%esp)
f0106a33:	e8 c0 06 00 00       	call   f01070f8 <strcmp>
f0106a38:	85 c0                	test   %eax,%eax
f0106a3a:	75 0f                	jne    f0106a4b <vprintfmt+0x253>
                    ch_color = COLOR_RED;
f0106a3c:	c7 05 48 f6 11 f0 04 	movl   $0x4,0xf011f648
f0106a43:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f0106a46:	e9 8a 03 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
f0106a4b:	c7 44 24 04 9d 8d 10 	movl   $0xf0108d9d,0x4(%esp)
f0106a52:	f0 
f0106a53:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0106a56:	89 04 24             	mov    %eax,(%esp)
f0106a59:	e8 9a 06 00 00       	call   f01070f8 <strcmp>
f0106a5e:	85 c0                	test   %eax,%eax
f0106a60:	75 0f                	jne    f0106a71 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
f0106a62:	c7 05 48 f6 11 f0 08 	movl   $0x8,0xf011f648
f0106a69:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f0106a6c:	e9 64 03 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
f0106a71:	c7 44 24 04 a1 8d 10 	movl   $0xf0108da1,0x4(%esp)
f0106a78:	f0 
f0106a79:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0106a7c:	89 04 24             	mov    %eax,(%esp)
f0106a7f:	e8 74 06 00 00       	call   f01070f8 <strcmp>
f0106a84:	85 c0                	test   %eax,%eax
f0106a86:	75 0f                	jne    f0106a97 <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
f0106a88:	c7 05 48 f6 11 f0 0f 	movl   $0xf,0xf011f648
f0106a8f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f0106a92:	e9 3e 03 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
f0106a97:	c7 44 24 04 a5 8d 10 	movl   $0xf0108da5,0x4(%esp)
f0106a9e:	f0 
f0106a9f:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0106aa2:	89 04 24             	mov    %eax,(%esp)
f0106aa5:	e8 4e 06 00 00       	call   f01070f8 <strcmp>
f0106aaa:	85 c0                	test   %eax,%eax
f0106aac:	75 0f                	jne    f0106abd <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
f0106aae:	c7 05 48 f6 11 f0 0c 	movl   $0xc,0xf011f648
f0106ab5:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f0106ab8:	e9 18 03 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
f0106abd:	c7 44 24 04 a9 8d 10 	movl   $0xf0108da9,0x4(%esp)
f0106ac4:	f0 
f0106ac5:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0106ac8:	89 04 24             	mov    %eax,(%esp)
f0106acb:	e8 28 06 00 00       	call   f01070f8 <strcmp>
f0106ad0:	85 c0                	test   %eax,%eax
f0106ad2:	75 0f                	jne    f0106ae3 <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
f0106ad4:	c7 05 48 f6 11 f0 06 	movl   $0x6,0xf011f648
f0106adb:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f0106ade:	e9 f2 02 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
f0106ae3:	c7 44 24 04 ad 8d 10 	movl   $0xf0108dad,0x4(%esp)
f0106aea:	f0 
f0106aeb:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0106aee:	89 04 24             	mov    %eax,(%esp)
f0106af1:	e8 02 06 00 00       	call   f01070f8 <strcmp>
f0106af6:	85 c0                	test   %eax,%eax
f0106af8:	75 0f                	jne    f0106b09 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
f0106afa:	c7 05 48 f6 11 f0 0b 	movl   $0xb,0xf011f648
f0106b01:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f0106b04:	e9 cc 02 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
f0106b09:	c7 05 48 f6 11 f0 07 	movl   $0x7,0xf011f648
f0106b10:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
f0106b13:	e9 bd 02 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
f0106b18:	8b 45 14             	mov    0x14(%ebp),%eax
f0106b1b:	83 c0 04             	add    $0x4,%eax
f0106b1e:	89 45 14             	mov    %eax,0x14(%ebp)
f0106b21:	8b 45 14             	mov    0x14(%ebp),%eax
f0106b24:	83 e8 04             	sub    $0x4,%eax
f0106b27:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
f0106b29:	85 db                	test   %ebx,%ebx
f0106b2b:	79 02                	jns    f0106b2f <vprintfmt+0x337>
				err = -err;
f0106b2d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
f0106b2f:	83 fb 0e             	cmp    $0xe,%ebx
f0106b32:	7f 0b                	jg     f0106b3f <vprintfmt+0x347>
f0106b34:	8b 34 9d 40 8d 10 f0 	mov    -0xfef72c0(,%ebx,4),%esi
f0106b3b:	85 f6                	test   %esi,%esi
f0106b3d:	75 23                	jne    f0106b62 <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
f0106b3f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0106b43:	c7 44 24 08 b1 8d 10 	movl   $0xf0108db1,0x8(%esp)
f0106b4a:	f0 
f0106b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b52:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b55:	89 04 24             	mov    %eax,(%esp)
f0106b58:	e8 86 02 00 00       	call   f0106de3 <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
f0106b5d:	e9 73 02 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f0106b62:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106b66:	c7 44 24 08 ba 8d 10 	movl   $0xf0108dba,0x8(%esp)
f0106b6d:	f0 
f0106b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106b71:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b75:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b78:	89 04 24             	mov    %eax,(%esp)
f0106b7b:	e8 63 02 00 00       	call   f0106de3 <printfmt>
			break;
f0106b80:	e9 50 02 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0106b85:	8b 45 14             	mov    0x14(%ebp),%eax
f0106b88:	83 c0 04             	add    $0x4,%eax
f0106b8b:	89 45 14             	mov    %eax,0x14(%ebp)
f0106b8e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106b91:	83 e8 04             	sub    $0x4,%eax
f0106b94:	8b 30                	mov    (%eax),%esi
f0106b96:	85 f6                	test   %esi,%esi
f0106b98:	75 05                	jne    f0106b9f <vprintfmt+0x3a7>
				p = "(null)";
f0106b9a:	be bd 8d 10 f0       	mov    $0xf0108dbd,%esi
			if (width > 0 && padc != '-')
f0106b9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0106ba3:	7e 73                	jle    f0106c18 <vprintfmt+0x420>
f0106ba5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
f0106ba9:	74 6d                	je     f0106c18 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
f0106bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106bae:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106bb2:	89 34 24             	mov    %esi,(%esp)
f0106bb5:	e8 48 04 00 00       	call   f0107002 <strnlen>
f0106bba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
f0106bbd:	eb 17                	jmp    f0106bd6 <vprintfmt+0x3de>
					putch(padc, putdat);
f0106bbf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
f0106bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106bc6:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106bca:	89 04 24             	mov    %eax,(%esp)
f0106bcd:	8b 45 08             	mov    0x8(%ebp),%eax
f0106bd0:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0106bd2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0106bd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0106bda:	7f e3                	jg     f0106bbf <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0106bdc:	eb 3a                	jmp    f0106c18 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
f0106bde:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0106be2:	74 1f                	je     f0106c03 <vprintfmt+0x40b>
f0106be4:	83 fb 1f             	cmp    $0x1f,%ebx
f0106be7:	7e 05                	jle    f0106bee <vprintfmt+0x3f6>
f0106be9:	83 fb 7e             	cmp    $0x7e,%ebx
f0106bec:	7e 15                	jle    f0106c03 <vprintfmt+0x40b>
					putch('?', putdat);
f0106bee:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106bf5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f0106bfc:	8b 45 08             	mov    0x8(%ebp),%eax
f0106bff:	ff d0                	call   *%eax
f0106c01:	eb 0f                	jmp    f0106c12 <vprintfmt+0x41a>
				else
					putch(ch, putdat);
f0106c03:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106c06:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106c0a:	89 1c 24             	mov    %ebx,(%esp)
f0106c0d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c10:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0106c12:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0106c16:	eb 01                	jmp    f0106c19 <vprintfmt+0x421>
f0106c18:	90                   	nop
f0106c19:	0f b6 06             	movzbl (%esi),%eax
f0106c1c:	0f be d8             	movsbl %al,%ebx
f0106c1f:	85 db                	test   %ebx,%ebx
f0106c21:	0f 95 c0             	setne  %al
f0106c24:	83 c6 01             	add    $0x1,%esi
f0106c27:	84 c0                	test   %al,%al
f0106c29:	74 29                	je     f0106c54 <vprintfmt+0x45c>
f0106c2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0106c2f:	78 ad                	js     f0106bde <vprintfmt+0x3e6>
f0106c31:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
f0106c35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0106c39:	79 a3                	jns    f0106bde <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0106c3b:	eb 17                	jmp    f0106c54 <vprintfmt+0x45c>
				putch(' ', putdat);
f0106c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106c40:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106c44:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0106c4b:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c4e:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0106c50:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0106c54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0106c58:	7f e3                	jg     f0106c3d <vprintfmt+0x445>
				putch(' ', putdat);
			break;
f0106c5a:	e9 76 01 00 00       	jmp    f0106dd5 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f0106c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0106c62:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106c66:	8d 45 14             	lea    0x14(%ebp),%eax
f0106c69:	89 04 24             	mov    %eax,(%esp)
f0106c6c:	e8 20 fb ff ff       	call   f0106791 <getint>
f0106c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106c74:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
f0106c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0106c7d:	85 d2                	test   %edx,%edx
f0106c7f:	79 26                	jns    f0106ca7 <vprintfmt+0x4af>
				putch('-', putdat);
f0106c81:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106c84:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106c88:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f0106c8f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c92:	ff d0                	call   *%eax
				num = -(long long) num;
f0106c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106c97:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0106c9a:	f7 d8                	neg    %eax
f0106c9c:	83 d2 00             	adc    $0x0,%edx
f0106c9f:	f7 da                	neg    %edx
f0106ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106ca4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
f0106ca7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
f0106cae:	e9 ae 00 00 00       	jmp    f0106d61 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0106cb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0106cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106cba:	8d 45 14             	lea    0x14(%ebp),%eax
f0106cbd:	89 04 24             	mov    %eax,(%esp)
f0106cc0:	e8 65 fa ff ff       	call   f010672a <getuint>
f0106cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106cc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
f0106ccb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
f0106cd2:	e9 8a 00 00 00       	jmp    f0106d61 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
f0106cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0106cda:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106cde:	8d 45 14             	lea    0x14(%ebp),%eax
f0106ce1:	89 04 24             	mov    %eax,(%esp)
f0106ce4:	e8 41 fa ff ff       	call   f010672a <getuint>
f0106ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106cec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
f0106cef:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
f0106cf6:	eb 69                	jmp    f0106d61 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
f0106cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106cff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0106d06:	8b 45 08             	mov    0x8(%ebp),%eax
f0106d09:	ff d0                	call   *%eax
			putch('x', putdat);
f0106d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d12:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0106d19:	8b 45 08             	mov    0x8(%ebp),%eax
f0106d1c:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0106d1e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106d21:	83 c0 04             	add    $0x4,%eax
f0106d24:	89 45 14             	mov    %eax,0x14(%ebp)
f0106d27:	8b 45 14             	mov    0x14(%ebp),%eax
f0106d2a:	83 e8 04             	sub    $0x4,%eax
f0106d2d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0106d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106d32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0106d39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
f0106d40:	eb 1f                	jmp    f0106d61 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0106d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0106d45:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d49:	8d 45 14             	lea    0x14(%ebp),%eax
f0106d4c:	89 04 24             	mov    %eax,(%esp)
f0106d4f:	e8 d6 f9 ff ff       	call   f010672a <getuint>
f0106d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106d57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
f0106d5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
f0106d61:	0f be 55 db          	movsbl -0x25(%ebp),%edx
f0106d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106d68:	89 54 24 18          	mov    %edx,0x18(%esp)
f0106d6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0106d6f:	89 54 24 14          	mov    %edx,0x14(%esp)
f0106d73:	89 44 24 10          	mov    %eax,0x10(%esp)
f0106d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0106d7d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106d81:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106d85:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106d88:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d8c:	8b 45 08             	mov    0x8(%ebp),%eax
f0106d8f:	89 04 24             	mov    %eax,(%esp)
f0106d92:	e8 b5 f8 ff ff       	call   f010664c <printnum>
			break;
f0106d97:	eb 3c                	jmp    f0106dd5 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0106d99:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106da0:	89 1c 24             	mov    %ebx,(%esp)
f0106da3:	8b 45 08             	mov    0x8(%ebp),%eax
f0106da6:	ff d0                	call   *%eax
			break;
f0106da8:	eb 2b                	jmp    f0106dd5 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0106daa:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106dad:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106db1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0106db8:	8b 45 08             	mov    0x8(%ebp),%eax
f0106dbb:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
f0106dbd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0106dc1:	eb 04                	jmp    f0106dc7 <vprintfmt+0x5cf>
f0106dc3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0106dc7:	8b 45 10             	mov    0x10(%ebp),%eax
f0106dca:	83 e8 01             	sub    $0x1,%eax
f0106dcd:	0f b6 00             	movzbl (%eax),%eax
f0106dd0:	3c 25                	cmp    $0x25,%al
f0106dd2:	75 ef                	jne    f0106dc3 <vprintfmt+0x5cb>
				/* do nothing */;
			break;
f0106dd4:	90                   	nop
		}
	}
f0106dd5:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106dd6:	e9 3e fa ff ff       	jmp    f0106819 <vprintfmt+0x21>
			if (ch == '\0')
				return;
f0106ddb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
f0106ddc:	83 c4 50             	add    $0x50,%esp
f0106ddf:	5b                   	pop    %ebx
f0106de0:	5e                   	pop    %esi
f0106de1:	5d                   	pop    %ebp
f0106de2:	c3                   	ret    

f0106de3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0106de3:	55                   	push   %ebp
f0106de4:	89 e5                	mov    %esp,%ebp
f0106de6:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
f0106de9:	8d 45 10             	lea    0x10(%ebp),%eax
f0106dec:	83 c0 04             	add    $0x4,%eax
f0106def:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
f0106df2:	8b 45 10             	mov    0x10(%ebp),%eax
f0106df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0106df8:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106dfc:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106e00:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e03:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106e07:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e0a:	89 04 24             	mov    %eax,(%esp)
f0106e0d:	e8 e6 f9 ff ff       	call   f01067f8 <vprintfmt>
	va_end(ap);
}
f0106e12:	c9                   	leave  
f0106e13:	c3                   	ret    

f0106e14 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0106e14:	55                   	push   %ebp
f0106e15:	89 e5                	mov    %esp,%ebp
	b->cnt++;
f0106e17:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e1a:	8b 40 08             	mov    0x8(%eax),%eax
f0106e1d:	8d 50 01             	lea    0x1(%eax),%edx
f0106e20:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e23:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
f0106e26:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e29:	8b 10                	mov    (%eax),%edx
f0106e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e2e:	8b 40 04             	mov    0x4(%eax),%eax
f0106e31:	39 c2                	cmp    %eax,%edx
f0106e33:	73 12                	jae    f0106e47 <sprintputch+0x33>
		*b->buf++ = ch;
f0106e35:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e38:	8b 00                	mov    (%eax),%eax
f0106e3a:	8b 55 08             	mov    0x8(%ebp),%edx
f0106e3d:	88 10                	mov    %dl,(%eax)
f0106e3f:	8d 50 01             	lea    0x1(%eax),%edx
f0106e42:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e45:	89 10                	mov    %edx,(%eax)
}
f0106e47:	5d                   	pop    %ebp
f0106e48:	c3                   	ret    

f0106e49 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0106e49:	55                   	push   %ebp
f0106e4a:	89 e5                	mov    %esp,%ebp
f0106e4c:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
f0106e4f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e52:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0106e55:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e58:	83 e8 01             	sub    $0x1,%eax
f0106e5b:	03 45 08             	add    0x8(%ebp),%eax
f0106e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106e61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0106e68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0106e6c:	74 06                	je     f0106e74 <vsnprintf+0x2b>
f0106e6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106e72:	7f 07                	jg     f0106e7b <vsnprintf+0x32>
		return -E_INVAL;
f0106e74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0106e79:	eb 2a                	jmp    f0106ea5 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106e7b:	8b 45 14             	mov    0x14(%ebp),%eax
f0106e7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106e82:	8b 45 10             	mov    0x10(%ebp),%eax
f0106e85:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106e89:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0106e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106e90:	c7 04 24 14 6e 10 f0 	movl   $0xf0106e14,(%esp)
f0106e97:	e8 5c f9 ff ff       	call   f01067f8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106e9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0106ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0106ea5:	c9                   	leave  
f0106ea6:	c3                   	ret    

f0106ea7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0106ea7:	55                   	push   %ebp
f0106ea8:	89 e5                	mov    %esp,%ebp
f0106eaa:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106ead:	8d 45 10             	lea    0x10(%ebp),%eax
f0106eb0:	83 c0 04             	add    $0x4,%eax
f0106eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
f0106eb6:	8b 45 10             	mov    0x10(%ebp),%eax
f0106eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0106ebc:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106ec0:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106ecb:	8b 45 08             	mov    0x8(%ebp),%eax
f0106ece:	89 04 24             	mov    %eax,(%esp)
f0106ed1:	e8 73 ff ff ff       	call   f0106e49 <vsnprintf>
f0106ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
f0106ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
f0106edc:	c9                   	leave  
f0106edd:	c3                   	ret    
	...

f0106ee0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106ee0:	55                   	push   %ebp
f0106ee1:	89 e5                	mov    %esp,%ebp
f0106ee3:	83 ec 28             	sub    $0x28,%esp
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106ee6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0106eea:	74 13                	je     f0106eff <readline+0x1f>
		cprintf("%s", prompt);
f0106eec:	8b 45 08             	mov    0x8(%ebp),%eax
f0106eef:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106ef3:	c7 04 24 1c 8f 10 f0 	movl   $0xf0108f1c,(%esp)
f0106efa:	e8 8f d7 ff ff       	call   f010468e <cprintf>
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f0106eff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
f0106f06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0106f0d:	e8 bf 9b ff ff       	call   f0100ad1 <iscons>
f0106f12:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106f15:	eb 01                	jmp    f0106f18 <readline+0x38>
			if (echoing)
				cputchar(c);
			buf[i] = 0;
			return buf;
		}
	}
f0106f17:	90                   	nop
#endif

	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
f0106f18:	e8 9b 9b ff ff       	call   f0100ab8 <getchar>
f0106f1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
f0106f20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f0106f24:	79 23                	jns    f0106f49 <readline+0x69>
			if (c != -E_EOF)
f0106f26:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%ebp)
f0106f2a:	74 13                	je     f0106f3f <readline+0x5f>
				cprintf("read error: %e\n", c);
f0106f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106f33:	c7 04 24 1f 8f 10 f0 	movl   $0xf0108f1f,(%esp)
f0106f3a:	e8 4f d7 ff ff       	call   f010468e <cprintf>
			return NULL;
f0106f3f:	b8 00 00 00 00       	mov    $0x0,%eax
f0106f44:	e9 8f 00 00 00       	jmp    f0106fd8 <readline+0xf8>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106f49:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
f0106f4d:	7e 2e                	jle    f0106f7d <readline+0x9d>
f0106f4f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
f0106f56:	7f 25                	jg     f0106f7d <readline+0x9d>
			if (echoing)
f0106f58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0106f5c:	74 0b                	je     f0106f69 <readline+0x89>
				cputchar(c);
f0106f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106f61:	89 04 24             	mov    %eax,(%esp)
f0106f64:	e8 3c 9b ff ff       	call   f0100aa5 <cputchar>
			buf[i++] = c;
f0106f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106f6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0106f6f:	81 c2 c0 90 1a f0    	add    $0xf01a90c0,%edx
f0106f75:	88 02                	mov    %al,(%edx)
f0106f77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0106f7b:	eb 56                	jmp    f0106fd3 <readline+0xf3>
		} else if (c == '\b' && i > 0) {
f0106f7d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
f0106f81:	75 1d                	jne    f0106fa0 <readline+0xc0>
f0106f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0106f87:	7e 17                	jle    f0106fa0 <readline+0xc0>
			if (echoing)
f0106f89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0106f8d:	74 0b                	je     f0106f9a <readline+0xba>
				cputchar(c);
f0106f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106f92:	89 04 24             	mov    %eax,(%esp)
f0106f95:	e8 0b 9b ff ff       	call   f0100aa5 <cputchar>
			i--;
f0106f9a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
f0106f9e:	eb 33                	jmp    f0106fd3 <readline+0xf3>
		} else if (c == '\n' || c == '\r') {
f0106fa0:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
f0106fa4:	74 0a                	je     f0106fb0 <readline+0xd0>
f0106fa6:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
f0106faa:	0f 85 67 ff ff ff    	jne    f0106f17 <readline+0x37>
			if (echoing)
f0106fb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0106fb4:	74 0b                	je     f0106fc1 <readline+0xe1>
				cputchar(c);
f0106fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106fb9:	89 04 24             	mov    %eax,(%esp)
f0106fbc:	e8 e4 9a ff ff       	call   f0100aa5 <cputchar>
			buf[i] = 0;
f0106fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106fc4:	05 c0 90 1a f0       	add    $0xf01a90c0,%eax
f0106fc9:	c6 00 00             	movb   $0x0,(%eax)
			return buf;
f0106fcc:	b8 c0 90 1a f0       	mov    $0xf01a90c0,%eax
f0106fd1:	eb 05                	jmp    f0106fd8 <readline+0xf8>
		}
	}
f0106fd3:	e9 3f ff ff ff       	jmp    f0106f17 <readline+0x37>
}
f0106fd8:	c9                   	leave  
f0106fd9:	c3                   	ret    
	...

f0106fdc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
f0106fdc:	55                   	push   %ebp
f0106fdd:	89 e5                	mov    %esp,%ebp
f0106fdf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
f0106fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
f0106fe9:	eb 08                	jmp    f0106ff3 <strlen+0x17>
		n++;
f0106feb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0106fef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106ff3:	8b 45 08             	mov    0x8(%ebp),%eax
f0106ff6:	0f b6 00             	movzbl (%eax),%eax
f0106ff9:	84 c0                	test   %al,%al
f0106ffb:	75 ee                	jne    f0106feb <strlen+0xf>
		n++;
	return n;
f0106ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f0107000:	c9                   	leave  
f0107001:	c3                   	ret    

f0107002 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0107002:	55                   	push   %ebp
f0107003:	89 e5                	mov    %esp,%ebp
f0107005:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0107008:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
f010700f:	eb 0c                	jmp    f010701d <strnlen+0x1b>
		n++;
f0107011:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0107015:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0107019:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
f010701d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0107021:	74 0a                	je     f010702d <strnlen+0x2b>
f0107023:	8b 45 08             	mov    0x8(%ebp),%eax
f0107026:	0f b6 00             	movzbl (%eax),%eax
f0107029:	84 c0                	test   %al,%al
f010702b:	75 e4                	jne    f0107011 <strnlen+0xf>
		n++;
	return n;
f010702d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f0107030:	c9                   	leave  
f0107031:	c3                   	ret    

f0107032 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0107032:	55                   	push   %ebp
f0107033:	89 e5                	mov    %esp,%ebp
f0107035:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
f0107038:	8b 45 08             	mov    0x8(%ebp),%eax
f010703b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
f010703e:	90                   	nop
f010703f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0107042:	0f b6 10             	movzbl (%eax),%edx
f0107045:	8b 45 08             	mov    0x8(%ebp),%eax
f0107048:	88 10                	mov    %dl,(%eax)
f010704a:	8b 45 08             	mov    0x8(%ebp),%eax
f010704d:	0f b6 00             	movzbl (%eax),%eax
f0107050:	84 c0                	test   %al,%al
f0107052:	0f 95 c0             	setne  %al
f0107055:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0107059:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f010705d:	84 c0                	test   %al,%al
f010705f:	75 de                	jne    f010703f <strcpy+0xd>
		/* do nothing */;
	return ret;
f0107061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f0107064:	c9                   	leave  
f0107065:	c3                   	ret    

f0107066 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0107066:	55                   	push   %ebp
f0107067:	89 e5                	mov    %esp,%ebp
f0107069:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
f010706c:	8b 45 08             	mov    0x8(%ebp),%eax
f010706f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
f0107072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
f0107079:	eb 21                	jmp    f010709c <strncpy+0x36>
		*dst++ = *src;
f010707b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010707e:	0f b6 10             	movzbl (%eax),%edx
f0107081:	8b 45 08             	mov    0x8(%ebp),%eax
f0107084:	88 10                	mov    %dl,(%eax)
f0107086:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
f010708a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010708d:	0f b6 00             	movzbl (%eax),%eax
f0107090:	84 c0                	test   %al,%al
f0107092:	74 04                	je     f0107098 <strncpy+0x32>
			src++;
f0107094:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0107098:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
f010709c:	8b 45 fc             	mov    -0x4(%ebp),%eax
f010709f:	3b 45 10             	cmp    0x10(%ebp),%eax
f01070a2:	72 d7                	jb     f010707b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
f01070a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
f01070a7:	c9                   	leave  
f01070a8:	c3                   	ret    

f01070a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01070a9:	55                   	push   %ebp
f01070aa:	89 e5                	mov    %esp,%ebp
f01070ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
f01070af:	8b 45 08             	mov    0x8(%ebp),%eax
f01070b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
f01070b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01070b9:	74 2f                	je     f01070ea <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
f01070bb:	eb 13                	jmp    f01070d0 <strlcpy+0x27>
			*dst++ = *src++;
f01070bd:	8b 45 0c             	mov    0xc(%ebp),%eax
f01070c0:	0f b6 10             	movzbl (%eax),%edx
f01070c3:	8b 45 08             	mov    0x8(%ebp),%eax
f01070c6:	88 10                	mov    %dl,(%eax)
f01070c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f01070cc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01070d0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f01070d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01070d8:	74 0a                	je     f01070e4 <strlcpy+0x3b>
f01070da:	8b 45 0c             	mov    0xc(%ebp),%eax
f01070dd:	0f b6 00             	movzbl (%eax),%eax
f01070e0:	84 c0                	test   %al,%al
f01070e2:	75 d9                	jne    f01070bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
f01070e4:	8b 45 08             	mov    0x8(%ebp),%eax
f01070e7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01070ea:	8b 55 08             	mov    0x8(%ebp),%edx
f01070ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
f01070f0:	89 d1                	mov    %edx,%ecx
f01070f2:	29 c1                	sub    %eax,%ecx
f01070f4:	89 c8                	mov    %ecx,%eax
}
f01070f6:	c9                   	leave  
f01070f7:	c3                   	ret    

f01070f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01070f8:	55                   	push   %ebp
f01070f9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
f01070fb:	eb 08                	jmp    f0107105 <strcmp+0xd>
		p++, q++;
f01070fd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0107101:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0107105:	8b 45 08             	mov    0x8(%ebp),%eax
f0107108:	0f b6 00             	movzbl (%eax),%eax
f010710b:	84 c0                	test   %al,%al
f010710d:	74 10                	je     f010711f <strcmp+0x27>
f010710f:	8b 45 08             	mov    0x8(%ebp),%eax
f0107112:	0f b6 10             	movzbl (%eax),%edx
f0107115:	8b 45 0c             	mov    0xc(%ebp),%eax
f0107118:	0f b6 00             	movzbl (%eax),%eax
f010711b:	38 c2                	cmp    %al,%dl
f010711d:	74 de                	je     f01070fd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010711f:	8b 45 08             	mov    0x8(%ebp),%eax
f0107122:	0f b6 00             	movzbl (%eax),%eax
f0107125:	0f b6 d0             	movzbl %al,%edx
f0107128:	8b 45 0c             	mov    0xc(%ebp),%eax
f010712b:	0f b6 00             	movzbl (%eax),%eax
f010712e:	0f b6 c0             	movzbl %al,%eax
f0107131:	89 d1                	mov    %edx,%ecx
f0107133:	29 c1                	sub    %eax,%ecx
f0107135:	89 c8                	mov    %ecx,%eax
}
f0107137:	5d                   	pop    %ebp
f0107138:	c3                   	ret    

f0107139 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0107139:	55                   	push   %ebp
f010713a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
f010713c:	eb 0c                	jmp    f010714a <strncmp+0x11>
		n--, p++, q++;
f010713e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0107142:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0107146:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f010714a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010714e:	74 1a                	je     f010716a <strncmp+0x31>
f0107150:	8b 45 08             	mov    0x8(%ebp),%eax
f0107153:	0f b6 00             	movzbl (%eax),%eax
f0107156:	84 c0                	test   %al,%al
f0107158:	74 10                	je     f010716a <strncmp+0x31>
f010715a:	8b 45 08             	mov    0x8(%ebp),%eax
f010715d:	0f b6 10             	movzbl (%eax),%edx
f0107160:	8b 45 0c             	mov    0xc(%ebp),%eax
f0107163:	0f b6 00             	movzbl (%eax),%eax
f0107166:	38 c2                	cmp    %al,%dl
f0107168:	74 d4                	je     f010713e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
f010716a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010716e:	75 07                	jne    f0107177 <strncmp+0x3e>
		return 0;
f0107170:	b8 00 00 00 00       	mov    $0x0,%eax
f0107175:	eb 18                	jmp    f010718f <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0107177:	8b 45 08             	mov    0x8(%ebp),%eax
f010717a:	0f b6 00             	movzbl (%eax),%eax
f010717d:	0f b6 d0             	movzbl %al,%edx
f0107180:	8b 45 0c             	mov    0xc(%ebp),%eax
f0107183:	0f b6 00             	movzbl (%eax),%eax
f0107186:	0f b6 c0             	movzbl %al,%eax
f0107189:	89 d1                	mov    %edx,%ecx
f010718b:	29 c1                	sub    %eax,%ecx
f010718d:	89 c8                	mov    %ecx,%eax
}
f010718f:	5d                   	pop    %ebp
f0107190:	c3                   	ret    

f0107191 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0107191:	55                   	push   %ebp
f0107192:	89 e5                	mov    %esp,%ebp
f0107194:	83 ec 04             	sub    $0x4,%esp
f0107197:	8b 45 0c             	mov    0xc(%ebp),%eax
f010719a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
f010719d:	eb 14                	jmp    f01071b3 <strchr+0x22>
		if (*s == c)
f010719f:	8b 45 08             	mov    0x8(%ebp),%eax
f01071a2:	0f b6 00             	movzbl (%eax),%eax
f01071a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
f01071a8:	75 05                	jne    f01071af <strchr+0x1e>
			return (char *) s;
f01071aa:	8b 45 08             	mov    0x8(%ebp),%eax
f01071ad:	eb 13                	jmp    f01071c2 <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f01071af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f01071b3:	8b 45 08             	mov    0x8(%ebp),%eax
f01071b6:	0f b6 00             	movzbl (%eax),%eax
f01071b9:	84 c0                	test   %al,%al
f01071bb:	75 e2                	jne    f010719f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
f01071bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01071c2:	c9                   	leave  
f01071c3:	c3                   	ret    

f01071c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01071c4:	55                   	push   %ebp
f01071c5:	89 e5                	mov    %esp,%ebp
f01071c7:	83 ec 04             	sub    $0x4,%esp
f01071ca:	8b 45 0c             	mov    0xc(%ebp),%eax
f01071cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
f01071d0:	eb 0f                	jmp    f01071e1 <strfind+0x1d>
		if (*s == c)
f01071d2:	8b 45 08             	mov    0x8(%ebp),%eax
f01071d5:	0f b6 00             	movzbl (%eax),%eax
f01071d8:	3a 45 fc             	cmp    -0x4(%ebp),%al
f01071db:	74 10                	je     f01071ed <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01071dd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f01071e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01071e4:	0f b6 00             	movzbl (%eax),%eax
f01071e7:	84 c0                	test   %al,%al
f01071e9:	75 e7                	jne    f01071d2 <strfind+0xe>
f01071eb:	eb 01                	jmp    f01071ee <strfind+0x2a>
		if (*s == c)
			break;
f01071ed:	90                   	nop
	return (char *) s;
f01071ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
f01071f1:	c9                   	leave  
f01071f2:	c3                   	ret    

f01071f3 <memset>:


void *
memset(void *v, int c, size_t n)
{
f01071f3:	55                   	push   %ebp
f01071f4:	89 e5                	mov    %esp,%ebp
f01071f6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
f01071f9:	8b 45 08             	mov    0x8(%ebp),%eax
f01071fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
f01071ff:	8b 45 10             	mov    0x10(%ebp),%eax
f0107202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
f0107205:	eb 0e                	jmp    f0107215 <memset+0x22>
		*p++ = c;
f0107207:	8b 45 0c             	mov    0xc(%ebp),%eax
f010720a:	89 c2                	mov    %eax,%edx
f010720c:	8b 45 fc             	mov    -0x4(%ebp),%eax
f010720f:	88 10                	mov    %dl,(%eax)
f0107211:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
f0107215:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
f0107219:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
f010721d:	79 e8                	jns    f0107207 <memset+0x14>
		*p++ = c;

	return v;
f010721f:	8b 45 08             	mov    0x8(%ebp),%eax
}
f0107222:	c9                   	leave  
f0107223:	c3                   	ret    

f0107224 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
f0107224:	55                   	push   %ebp
f0107225:	89 e5                	mov    %esp,%ebp
f0107227:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
f010722a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010722d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
f0107230:	8b 45 08             	mov    0x8(%ebp),%eax
f0107233:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
f0107236:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0107239:	3b 45 f8             	cmp    -0x8(%ebp),%eax
f010723c:	73 54                	jae    f0107292 <memmove+0x6e>
f010723e:	8b 45 10             	mov    0x10(%ebp),%eax
f0107241:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0107244:	01 d0                	add    %edx,%eax
f0107246:	3b 45 f8             	cmp    -0x8(%ebp),%eax
f0107249:	76 47                	jbe    f0107292 <memmove+0x6e>
		s += n;
f010724b:	8b 45 10             	mov    0x10(%ebp),%eax
f010724e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
f0107251:	8b 45 10             	mov    0x10(%ebp),%eax
f0107254:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
f0107257:	eb 13                	jmp    f010726c <memmove+0x48>
			*--d = *--s;
f0107259:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
f010725d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
f0107261:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0107264:	0f b6 10             	movzbl (%eax),%edx
f0107267:	8b 45 f8             	mov    -0x8(%ebp),%eax
f010726a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
f010726c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0107270:	0f 95 c0             	setne  %al
f0107273:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0107277:	84 c0                	test   %al,%al
f0107279:	75 de                	jne    f0107259 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010727b:	eb 25                	jmp    f01072a2 <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
f010727d:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0107280:	0f b6 10             	movzbl (%eax),%edx
f0107283:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0107286:	88 10                	mov    %dl,(%eax)
f0107288:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
f010728c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
f0107290:	eb 01                	jmp    f0107293 <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
f0107292:	90                   	nop
f0107293:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0107297:	0f 95 c0             	setne  %al
f010729a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f010729e:	84 c0                	test   %al,%al
f01072a0:	75 db                	jne    f010727d <memmove+0x59>
			*d++ = *s++;

	return dst;
f01072a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
f01072a5:	c9                   	leave  
f01072a6:	c3                   	ret    

f01072a7 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f01072a7:	55                   	push   %ebp
f01072a8:	89 e5                	mov    %esp,%ebp
f01072aa:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f01072ad:	8b 45 10             	mov    0x10(%ebp),%eax
f01072b0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01072b4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01072b7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01072bb:	8b 45 08             	mov    0x8(%ebp),%eax
f01072be:	89 04 24             	mov    %eax,(%esp)
f01072c1:	e8 5e ff ff ff       	call   f0107224 <memmove>
}
f01072c6:	c9                   	leave  
f01072c7:	c3                   	ret    

f01072c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01072c8:	55                   	push   %ebp
f01072c9:	89 e5                	mov    %esp,%ebp
f01072cb:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
f01072ce:	8b 45 08             	mov    0x8(%ebp),%eax
f01072d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
f01072d4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01072d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
f01072da:	eb 32                	jmp    f010730e <memcmp+0x46>
		if (*s1 != *s2)
f01072dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
f01072df:	0f b6 10             	movzbl (%eax),%edx
f01072e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
f01072e5:	0f b6 00             	movzbl (%eax),%eax
f01072e8:	38 c2                	cmp    %al,%dl
f01072ea:	74 1a                	je     f0107306 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
f01072ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
f01072ef:	0f b6 00             	movzbl (%eax),%eax
f01072f2:	0f b6 d0             	movzbl %al,%edx
f01072f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
f01072f8:	0f b6 00             	movzbl (%eax),%eax
f01072fb:	0f b6 c0             	movzbl %al,%eax
f01072fe:	89 d1                	mov    %edx,%ecx
f0107300:	29 c1                	sub    %eax,%ecx
f0107302:	89 c8                	mov    %ecx,%eax
f0107304:	eb 1c                	jmp    f0107322 <memcmp+0x5a>
		s1++, s2++;
f0107306:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
f010730a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010730e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0107312:	0f 95 c0             	setne  %al
f0107315:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0107319:	84 c0                	test   %al,%al
f010731b:	75 bf                	jne    f01072dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f010731d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0107322:	c9                   	leave  
f0107323:	c3                   	ret    

f0107324 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0107324:	55                   	push   %ebp
f0107325:	89 e5                	mov    %esp,%ebp
f0107327:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
f010732a:	8b 45 10             	mov    0x10(%ebp),%eax
f010732d:	8b 55 08             	mov    0x8(%ebp),%edx
f0107330:	01 d0                	add    %edx,%eax
f0107332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
f0107335:	eb 11                	jmp    f0107348 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f0107337:	8b 45 08             	mov    0x8(%ebp),%eax
f010733a:	0f b6 10             	movzbl (%eax),%edx
f010733d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0107340:	38 c2                	cmp    %al,%dl
f0107342:	74 0e                	je     f0107352 <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0107344:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0107348:	8b 45 08             	mov    0x8(%ebp),%eax
f010734b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
f010734e:	72 e7                	jb     f0107337 <memfind+0x13>
f0107350:	eb 01                	jmp    f0107353 <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
f0107352:	90                   	nop
	return (void *) s;
f0107353:	8b 45 08             	mov    0x8(%ebp),%eax
}
f0107356:	c9                   	leave  
f0107357:	c3                   	ret    

f0107358 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0107358:	55                   	push   %ebp
f0107359:	89 e5                	mov    %esp,%ebp
f010735b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
f010735e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
f0107365:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010736c:	eb 04                	jmp    f0107372 <strtol+0x1a>
		s++;
f010736e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0107372:	8b 45 08             	mov    0x8(%ebp),%eax
f0107375:	0f b6 00             	movzbl (%eax),%eax
f0107378:	3c 20                	cmp    $0x20,%al
f010737a:	74 f2                	je     f010736e <strtol+0x16>
f010737c:	8b 45 08             	mov    0x8(%ebp),%eax
f010737f:	0f b6 00             	movzbl (%eax),%eax
f0107382:	3c 09                	cmp    $0x9,%al
f0107384:	74 e8                	je     f010736e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
f0107386:	8b 45 08             	mov    0x8(%ebp),%eax
f0107389:	0f b6 00             	movzbl (%eax),%eax
f010738c:	3c 2b                	cmp    $0x2b,%al
f010738e:	75 06                	jne    f0107396 <strtol+0x3e>
		s++;
f0107390:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0107394:	eb 15                	jmp    f01073ab <strtol+0x53>
	else if (*s == '-')
f0107396:	8b 45 08             	mov    0x8(%ebp),%eax
f0107399:	0f b6 00             	movzbl (%eax),%eax
f010739c:	3c 2d                	cmp    $0x2d,%al
f010739e:	75 0b                	jne    f01073ab <strtol+0x53>
		s++, neg = 1;
f01073a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f01073a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01073ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01073af:	74 06                	je     f01073b7 <strtol+0x5f>
f01073b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
f01073b5:	75 24                	jne    f01073db <strtol+0x83>
f01073b7:	8b 45 08             	mov    0x8(%ebp),%eax
f01073ba:	0f b6 00             	movzbl (%eax),%eax
f01073bd:	3c 30                	cmp    $0x30,%al
f01073bf:	75 1a                	jne    f01073db <strtol+0x83>
f01073c1:	8b 45 08             	mov    0x8(%ebp),%eax
f01073c4:	83 c0 01             	add    $0x1,%eax
f01073c7:	0f b6 00             	movzbl (%eax),%eax
f01073ca:	3c 78                	cmp    $0x78,%al
f01073cc:	75 0d                	jne    f01073db <strtol+0x83>
		s += 2, base = 16;
f01073ce:	83 45 08 02          	addl   $0x2,0x8(%ebp)
f01073d2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
f01073d9:	eb 2a                	jmp    f0107405 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
f01073db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01073df:	75 17                	jne    f01073f8 <strtol+0xa0>
f01073e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01073e4:	0f b6 00             	movzbl (%eax),%eax
f01073e7:	3c 30                	cmp    $0x30,%al
f01073e9:	75 0d                	jne    f01073f8 <strtol+0xa0>
		s++, base = 8;
f01073eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f01073ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
f01073f6:	eb 0d                	jmp    f0107405 <strtol+0xad>
	else if (base == 0)
f01073f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01073fc:	75 07                	jne    f0107405 <strtol+0xad>
		base = 10;
f01073fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0107405:	8b 45 08             	mov    0x8(%ebp),%eax
f0107408:	0f b6 00             	movzbl (%eax),%eax
f010740b:	3c 2f                	cmp    $0x2f,%al
f010740d:	7e 1b                	jle    f010742a <strtol+0xd2>
f010740f:	8b 45 08             	mov    0x8(%ebp),%eax
f0107412:	0f b6 00             	movzbl (%eax),%eax
f0107415:	3c 39                	cmp    $0x39,%al
f0107417:	7f 11                	jg     f010742a <strtol+0xd2>
			dig = *s - '0';
f0107419:	8b 45 08             	mov    0x8(%ebp),%eax
f010741c:	0f b6 00             	movzbl (%eax),%eax
f010741f:	0f be c0             	movsbl %al,%eax
f0107422:	83 e8 30             	sub    $0x30,%eax
f0107425:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0107428:	eb 48                	jmp    f0107472 <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
f010742a:	8b 45 08             	mov    0x8(%ebp),%eax
f010742d:	0f b6 00             	movzbl (%eax),%eax
f0107430:	3c 60                	cmp    $0x60,%al
f0107432:	7e 1b                	jle    f010744f <strtol+0xf7>
f0107434:	8b 45 08             	mov    0x8(%ebp),%eax
f0107437:	0f b6 00             	movzbl (%eax),%eax
f010743a:	3c 7a                	cmp    $0x7a,%al
f010743c:	7f 11                	jg     f010744f <strtol+0xf7>
			dig = *s - 'a' + 10;
f010743e:	8b 45 08             	mov    0x8(%ebp),%eax
f0107441:	0f b6 00             	movzbl (%eax),%eax
f0107444:	0f be c0             	movsbl %al,%eax
f0107447:	83 e8 57             	sub    $0x57,%eax
f010744a:	89 45 f4             	mov    %eax,-0xc(%ebp)
f010744d:	eb 23                	jmp    f0107472 <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
f010744f:	8b 45 08             	mov    0x8(%ebp),%eax
f0107452:	0f b6 00             	movzbl (%eax),%eax
f0107455:	3c 40                	cmp    $0x40,%al
f0107457:	7e 38                	jle    f0107491 <strtol+0x139>
f0107459:	8b 45 08             	mov    0x8(%ebp),%eax
f010745c:	0f b6 00             	movzbl (%eax),%eax
f010745f:	3c 5a                	cmp    $0x5a,%al
f0107461:	7f 2e                	jg     f0107491 <strtol+0x139>
			dig = *s - 'A' + 10;
f0107463:	8b 45 08             	mov    0x8(%ebp),%eax
f0107466:	0f b6 00             	movzbl (%eax),%eax
f0107469:	0f be c0             	movsbl %al,%eax
f010746c:	83 e8 37             	sub    $0x37,%eax
f010746f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
f0107472:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0107475:	3b 45 10             	cmp    0x10(%ebp),%eax
f0107478:	7d 16                	jge    f0107490 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
f010747a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f010747e:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0107481:	0f af 45 10          	imul   0x10(%ebp),%eax
f0107485:	03 45 f4             	add    -0xc(%ebp),%eax
f0107488:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
f010748b:	e9 75 ff ff ff       	jmp    f0107405 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
f0107490:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
f0107491:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0107495:	74 08                	je     f010749f <strtol+0x147>
		*endptr = (char *) s;
f0107497:	8b 45 0c             	mov    0xc(%ebp),%eax
f010749a:	8b 55 08             	mov    0x8(%ebp),%edx
f010749d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
f010749f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
f01074a3:	74 07                	je     f01074ac <strtol+0x154>
f01074a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
f01074a8:	f7 d8                	neg    %eax
f01074aa:	eb 03                	jmp    f01074af <strtol+0x157>
f01074ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
f01074af:	c9                   	leave  
f01074b0:	c3                   	ret    
	...

f01074c0 <__udivdi3>:
f01074c0:	83 ec 1c             	sub    $0x1c,%esp
f01074c3:	89 7c 24 14          	mov    %edi,0x14(%esp)
f01074c7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
f01074cb:	8b 44 24 20          	mov    0x20(%esp),%eax
f01074cf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
f01074d3:	89 74 24 10          	mov    %esi,0x10(%esp)
f01074d7:	8b 74 24 24          	mov    0x24(%esp),%esi
f01074db:	85 ff                	test   %edi,%edi
f01074dd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
f01074e1:	89 44 24 08          	mov    %eax,0x8(%esp)
f01074e5:	89 cd                	mov    %ecx,%ebp
f01074e7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01074eb:	75 33                	jne    f0107520 <__udivdi3+0x60>
f01074ed:	39 f1                	cmp    %esi,%ecx
f01074ef:	77 57                	ja     f0107548 <__udivdi3+0x88>
f01074f1:	85 c9                	test   %ecx,%ecx
f01074f3:	75 0b                	jne    f0107500 <__udivdi3+0x40>
f01074f5:	b8 01 00 00 00       	mov    $0x1,%eax
f01074fa:	31 d2                	xor    %edx,%edx
f01074fc:	f7 f1                	div    %ecx
f01074fe:	89 c1                	mov    %eax,%ecx
f0107500:	89 f0                	mov    %esi,%eax
f0107502:	31 d2                	xor    %edx,%edx
f0107504:	f7 f1                	div    %ecx
f0107506:	89 c6                	mov    %eax,%esi
f0107508:	8b 44 24 04          	mov    0x4(%esp),%eax
f010750c:	f7 f1                	div    %ecx
f010750e:	89 f2                	mov    %esi,%edx
f0107510:	8b 74 24 10          	mov    0x10(%esp),%esi
f0107514:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0107518:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f010751c:	83 c4 1c             	add    $0x1c,%esp
f010751f:	c3                   	ret    
f0107520:	31 d2                	xor    %edx,%edx
f0107522:	31 c0                	xor    %eax,%eax
f0107524:	39 f7                	cmp    %esi,%edi
f0107526:	77 e8                	ja     f0107510 <__udivdi3+0x50>
f0107528:	0f bd cf             	bsr    %edi,%ecx
f010752b:	83 f1 1f             	xor    $0x1f,%ecx
f010752e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0107532:	75 2c                	jne    f0107560 <__udivdi3+0xa0>
f0107534:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
f0107538:	76 04                	jbe    f010753e <__udivdi3+0x7e>
f010753a:	39 f7                	cmp    %esi,%edi
f010753c:	73 d2                	jae    f0107510 <__udivdi3+0x50>
f010753e:	31 d2                	xor    %edx,%edx
f0107540:	b8 01 00 00 00       	mov    $0x1,%eax
f0107545:	eb c9                	jmp    f0107510 <__udivdi3+0x50>
f0107547:	90                   	nop
f0107548:	89 f2                	mov    %esi,%edx
f010754a:	f7 f1                	div    %ecx
f010754c:	31 d2                	xor    %edx,%edx
f010754e:	8b 74 24 10          	mov    0x10(%esp),%esi
f0107552:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0107556:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f010755a:	83 c4 1c             	add    $0x1c,%esp
f010755d:	c3                   	ret    
f010755e:	66 90                	xchg   %ax,%ax
f0107560:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0107565:	b8 20 00 00 00       	mov    $0x20,%eax
f010756a:	89 ea                	mov    %ebp,%edx
f010756c:	2b 44 24 04          	sub    0x4(%esp),%eax
f0107570:	d3 e7                	shl    %cl,%edi
f0107572:	89 c1                	mov    %eax,%ecx
f0107574:	d3 ea                	shr    %cl,%edx
f0107576:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010757b:	09 fa                	or     %edi,%edx
f010757d:	89 f7                	mov    %esi,%edi
f010757f:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0107583:	89 f2                	mov    %esi,%edx
f0107585:	8b 74 24 08          	mov    0x8(%esp),%esi
f0107589:	d3 e5                	shl    %cl,%ebp
f010758b:	89 c1                	mov    %eax,%ecx
f010758d:	d3 ef                	shr    %cl,%edi
f010758f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0107594:	d3 e2                	shl    %cl,%edx
f0107596:	89 c1                	mov    %eax,%ecx
f0107598:	d3 ee                	shr    %cl,%esi
f010759a:	09 d6                	or     %edx,%esi
f010759c:	89 fa                	mov    %edi,%edx
f010759e:	89 f0                	mov    %esi,%eax
f01075a0:	f7 74 24 0c          	divl   0xc(%esp)
f01075a4:	89 d7                	mov    %edx,%edi
f01075a6:	89 c6                	mov    %eax,%esi
f01075a8:	f7 e5                	mul    %ebp
f01075aa:	39 d7                	cmp    %edx,%edi
f01075ac:	72 22                	jb     f01075d0 <__udivdi3+0x110>
f01075ae:	8b 6c 24 08          	mov    0x8(%esp),%ebp
f01075b2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01075b7:	d3 e5                	shl    %cl,%ebp
f01075b9:	39 c5                	cmp    %eax,%ebp
f01075bb:	73 04                	jae    f01075c1 <__udivdi3+0x101>
f01075bd:	39 d7                	cmp    %edx,%edi
f01075bf:	74 0f                	je     f01075d0 <__udivdi3+0x110>
f01075c1:	89 f0                	mov    %esi,%eax
f01075c3:	31 d2                	xor    %edx,%edx
f01075c5:	e9 46 ff ff ff       	jmp    f0107510 <__udivdi3+0x50>
f01075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01075d0:	8d 46 ff             	lea    -0x1(%esi),%eax
f01075d3:	31 d2                	xor    %edx,%edx
f01075d5:	8b 74 24 10          	mov    0x10(%esp),%esi
f01075d9:	8b 7c 24 14          	mov    0x14(%esp),%edi
f01075dd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f01075e1:	83 c4 1c             	add    $0x1c,%esp
f01075e4:	c3                   	ret    
	...

f01075f0 <__umoddi3>:
f01075f0:	83 ec 1c             	sub    $0x1c,%esp
f01075f3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
f01075f7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
f01075fb:	8b 44 24 20          	mov    0x20(%esp),%eax
f01075ff:	89 74 24 10          	mov    %esi,0x10(%esp)
f0107603:	8b 4c 24 28          	mov    0x28(%esp),%ecx
f0107607:	8b 74 24 24          	mov    0x24(%esp),%esi
f010760b:	85 ed                	test   %ebp,%ebp
f010760d:	89 7c 24 14          	mov    %edi,0x14(%esp)
f0107611:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107615:	89 cf                	mov    %ecx,%edi
f0107617:	89 04 24             	mov    %eax,(%esp)
f010761a:	89 f2                	mov    %esi,%edx
f010761c:	75 1a                	jne    f0107638 <__umoddi3+0x48>
f010761e:	39 f1                	cmp    %esi,%ecx
f0107620:	76 4e                	jbe    f0107670 <__umoddi3+0x80>
f0107622:	f7 f1                	div    %ecx
f0107624:	89 d0                	mov    %edx,%eax
f0107626:	31 d2                	xor    %edx,%edx
f0107628:	8b 74 24 10          	mov    0x10(%esp),%esi
f010762c:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0107630:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0107634:	83 c4 1c             	add    $0x1c,%esp
f0107637:	c3                   	ret    
f0107638:	39 f5                	cmp    %esi,%ebp
f010763a:	77 54                	ja     f0107690 <__umoddi3+0xa0>
f010763c:	0f bd c5             	bsr    %ebp,%eax
f010763f:	83 f0 1f             	xor    $0x1f,%eax
f0107642:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107646:	75 60                	jne    f01076a8 <__umoddi3+0xb8>
f0107648:	3b 0c 24             	cmp    (%esp),%ecx
f010764b:	0f 87 07 01 00 00    	ja     f0107758 <__umoddi3+0x168>
f0107651:	89 f2                	mov    %esi,%edx
f0107653:	8b 34 24             	mov    (%esp),%esi
f0107656:	29 ce                	sub    %ecx,%esi
f0107658:	19 ea                	sbb    %ebp,%edx
f010765a:	89 34 24             	mov    %esi,(%esp)
f010765d:	8b 04 24             	mov    (%esp),%eax
f0107660:	8b 74 24 10          	mov    0x10(%esp),%esi
f0107664:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0107668:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f010766c:	83 c4 1c             	add    $0x1c,%esp
f010766f:	c3                   	ret    
f0107670:	85 c9                	test   %ecx,%ecx
f0107672:	75 0b                	jne    f010767f <__umoddi3+0x8f>
f0107674:	b8 01 00 00 00       	mov    $0x1,%eax
f0107679:	31 d2                	xor    %edx,%edx
f010767b:	f7 f1                	div    %ecx
f010767d:	89 c1                	mov    %eax,%ecx
f010767f:	89 f0                	mov    %esi,%eax
f0107681:	31 d2                	xor    %edx,%edx
f0107683:	f7 f1                	div    %ecx
f0107685:	8b 04 24             	mov    (%esp),%eax
f0107688:	f7 f1                	div    %ecx
f010768a:	eb 98                	jmp    f0107624 <__umoddi3+0x34>
f010768c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107690:	89 f2                	mov    %esi,%edx
f0107692:	8b 74 24 10          	mov    0x10(%esp),%esi
f0107696:	8b 7c 24 14          	mov    0x14(%esp),%edi
f010769a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f010769e:	83 c4 1c             	add    $0x1c,%esp
f01076a1:	c3                   	ret    
f01076a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01076a8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01076ad:	89 e8                	mov    %ebp,%eax
f01076af:	bd 20 00 00 00       	mov    $0x20,%ebp
f01076b4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
f01076b8:	89 fa                	mov    %edi,%edx
f01076ba:	d3 e0                	shl    %cl,%eax
f01076bc:	89 e9                	mov    %ebp,%ecx
f01076be:	d3 ea                	shr    %cl,%edx
f01076c0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01076c5:	09 c2                	or     %eax,%edx
f01076c7:	8b 44 24 08          	mov    0x8(%esp),%eax
f01076cb:	89 14 24             	mov    %edx,(%esp)
f01076ce:	89 f2                	mov    %esi,%edx
f01076d0:	d3 e7                	shl    %cl,%edi
f01076d2:	89 e9                	mov    %ebp,%ecx
f01076d4:	d3 ea                	shr    %cl,%edx
f01076d6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01076db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01076df:	d3 e6                	shl    %cl,%esi
f01076e1:	89 e9                	mov    %ebp,%ecx
f01076e3:	d3 e8                	shr    %cl,%eax
f01076e5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01076ea:	09 f0                	or     %esi,%eax
f01076ec:	8b 74 24 08          	mov    0x8(%esp),%esi
f01076f0:	f7 34 24             	divl   (%esp)
f01076f3:	d3 e6                	shl    %cl,%esi
f01076f5:	89 74 24 08          	mov    %esi,0x8(%esp)
f01076f9:	89 d6                	mov    %edx,%esi
f01076fb:	f7 e7                	mul    %edi
f01076fd:	39 d6                	cmp    %edx,%esi
f01076ff:	89 c1                	mov    %eax,%ecx
f0107701:	89 d7                	mov    %edx,%edi
f0107703:	72 3f                	jb     f0107744 <__umoddi3+0x154>
f0107705:	39 44 24 08          	cmp    %eax,0x8(%esp)
f0107709:	72 35                	jb     f0107740 <__umoddi3+0x150>
f010770b:	8b 44 24 08          	mov    0x8(%esp),%eax
f010770f:	29 c8                	sub    %ecx,%eax
f0107711:	19 fe                	sbb    %edi,%esi
f0107713:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0107718:	89 f2                	mov    %esi,%edx
f010771a:	d3 e8                	shr    %cl,%eax
f010771c:	89 e9                	mov    %ebp,%ecx
f010771e:	d3 e2                	shl    %cl,%edx
f0107720:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0107725:	09 d0                	or     %edx,%eax
f0107727:	89 f2                	mov    %esi,%edx
f0107729:	d3 ea                	shr    %cl,%edx
f010772b:	8b 74 24 10          	mov    0x10(%esp),%esi
f010772f:	8b 7c 24 14          	mov    0x14(%esp),%edi
f0107733:	8b 6c 24 18          	mov    0x18(%esp),%ebp
f0107737:	83 c4 1c             	add    $0x1c,%esp
f010773a:	c3                   	ret    
f010773b:	90                   	nop
f010773c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107740:	39 d6                	cmp    %edx,%esi
f0107742:	75 c7                	jne    f010770b <__umoddi3+0x11b>
f0107744:	89 d7                	mov    %edx,%edi
f0107746:	89 c1                	mov    %eax,%ecx
f0107748:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
f010774c:	1b 3c 24             	sbb    (%esp),%edi
f010774f:	eb ba                	jmp    f010770b <__umoddi3+0x11b>
f0107751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107758:	39 f5                	cmp    %esi,%ebp
f010775a:	0f 82 f1 fe ff ff    	jb     f0107651 <__umoddi3+0x61>
f0107760:	e9 f8 fe ff ff       	jmp    f010765d <__umoddi3+0x6d>
