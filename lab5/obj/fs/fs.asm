
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 ef 25 00 00       	call   802620 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  80003b:	c7 45 f4 f7 01 00 00 	movl   $0x1f7,-0xc(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800045:	89 55 e8             	mov    %edx,-0x18(%ebp)
  800048:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80004b:	ec                   	in     (%dx),%al
  80004c:	89 c3                	mov    %eax,%ebx
  80004e:	88 5d f3             	mov    %bl,-0xd(%ebp)
	return data;
  800051:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  800055:	0f b6 c0             	movzbl %al,%eax
  800058:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80005b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80005e:	25 c0 00 00 00       	and    $0xc0,%eax
  800063:	83 f8 40             	cmp    $0x40,%eax
  800066:	75 d3                	jne    80003b <ide_wait_ready+0x7>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80006c:	74 11                	je     80007f <ide_wait_ready+0x4b>
  80006e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800071:	83 e0 21             	and    $0x21,%eax
  800074:	85 c0                	test   %eax,%eax
  800076:	74 07                	je     80007f <ide_wait_ready+0x4b>
		return -1;
  800078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80007d:	eb 05                	jmp    800084 <ide_wait_ready+0x50>
	return 0;
  80007f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800084:	83 c4 14             	add    $0x14,%esp
  800087:	5b                   	pop    %ebx
  800088:	5d                   	pop    %ebp
  800089:	c3                   	ret    

0080008a <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80008a:	55                   	push   %ebp
  80008b:	89 e5                	mov    %esp,%ebp
  80008d:	53                   	push   %ebx
  80008e:	83 ec 44             	sub    $0x44,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800098:	e8 97 ff ff ff       	call   800034 <ide_wait_ready>
  80009d:	c7 45 ec f6 01 00 00 	movl   $0x1f6,-0x14(%ebp)
  8000a4:	c6 45 eb f0          	movb   $0xf0,-0x15(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000a8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  8000ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8000af:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0; x < 1000 && (r = inb(0x1F7)) == 0; x++)
  8000b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000b7:	eb 04                	jmp    8000bd <ide_probe_disk1+0x33>
  8000b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8000bd:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  8000c4:	7f 26                	jg     8000ec <ide_probe_disk1+0x62>
  8000c6:	c7 45 e4 f7 01 00 00 	movl   $0x1f7,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8000d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d6:	ec                   	in     (%dx),%al
  8000d7:	89 c3                	mov    %eax,%ebx
  8000d9:	88 5d e3             	mov    %bl,-0x1d(%ebp)
	return data;
  8000dc:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  8000e0:	0f b6 c0             	movzbl %al,%eax
  8000e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8000e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8000ea:	74 cd                	je     8000b9 <ide_probe_disk1+0x2f>
  8000ec:	c7 45 dc f6 01 00 00 	movl   $0x1f6,-0x24(%ebp)
  8000f3:	c6 45 db e0          	movb   $0xe0,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000f7:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  8000fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8000fe:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000ff:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  800106:	0f 9e c0             	setle  %al
  800109:	0f b6 c0             	movzbl %al,%eax
  80010c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800110:	c7 04 24 60 4c 80 00 	movl   $0x804c60,(%esp)
  800117:	e8 9c 26 00 00       	call   8027b8 <cprintf>
	return (x < 1000);
  80011c:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  800123:	0f 9e c0             	setle  %al
  800126:	0f b6 c0             	movzbl %al,%eax
}
  800129:	83 c4 44             	add    $0x44,%esp
  80012c:	5b                   	pop    %ebx
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <ide_set_disk>:

void
ide_set_disk(int d)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 18             	sub    $0x18,%esp
	if (d != 0 && d != 1)
  800135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800139:	74 22                	je     80015d <ide_set_disk+0x2e>
  80013b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80013f:	74 1c                	je     80015d <ide_set_disk+0x2e>
		panic("bad disk number");
  800141:	c7 44 24 08 77 4c 80 	movl   $0x804c77,0x8(%esp)
  800148:	00 
  800149:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 87 4c 80 00 	movl   $0x804c87,(%esp)
  800158:	e8 27 25 00 00       	call   802684 <_panic>
	diskno = d;
  80015d:	8b 45 08             	mov    0x8(%ebp),%eax
  800160:	a3 00 80 80 00       	mov    %eax,0x808000
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
  80016d:	83 ec 5c             	sub    $0x5c,%esp
	int r;

	assert(nsecs <= 256);
  800170:	81 7d 10 00 01 00 00 	cmpl   $0x100,0x10(%ebp)
  800177:	76 24                	jbe    80019d <ide_read+0x36>
  800179:	c7 44 24 0c 90 4c 80 	movl   $0x804c90,0xc(%esp)
  800180:	00 
  800181:	c7 44 24 08 9d 4c 80 	movl   $0x804c9d,0x8(%esp)
  800188:	00 
  800189:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  800190:	00 
  800191:	c7 04 24 87 4c 80 00 	movl   $0x804c87,(%esp)
  800198:	e8 e7 24 00 00       	call   802684 <_panic>

	ide_wait_ready(0);
  80019d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a4:	e8 8b fe ff ff       	call   800034 <ide_wait_ready>

	outb(0x1F2, nsecs);
  8001a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ac:	0f b6 c0             	movzbl %al,%eax
  8001af:	c7 45 e0 f2 01 00 00 	movl   $0x1f2,-0x20(%ebp)
  8001b6:	88 45 df             	mov    %al,-0x21(%ebp)
  8001b9:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  8001bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001c0:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  8001c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c4:	0f b6 c0             	movzbl %al,%eax
  8001c7:	c7 45 d8 f3 01 00 00 	movl   $0x1f3,-0x28(%ebp)
  8001ce:	88 45 d7             	mov    %al,-0x29(%ebp)
  8001d1:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8001d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001d8:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	c1 e8 08             	shr    $0x8,%eax
  8001df:	0f b6 c0             	movzbl %al,%eax
  8001e2:	c7 45 d0 f4 01 00 00 	movl   $0x1f4,-0x30(%ebp)
  8001e9:	88 45 cf             	mov    %al,-0x31(%ebp)
  8001ec:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
  8001f0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001f3:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	0f b6 c0             	movzbl %al,%eax
  8001fd:	c7 45 c8 f5 01 00 00 	movl   $0x1f5,-0x38(%ebp)
  800204:	88 45 c7             	mov    %al,-0x39(%ebp)
  800207:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
  80020b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80020e:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80020f:	a1 00 80 80 00       	mov    0x808000,%eax
  800214:	83 e0 01             	and    $0x1,%eax
  800217:	89 c2                	mov    %eax,%edx
  800219:	c1 e2 04             	shl    $0x4,%edx
  80021c:	8b 45 08             	mov    0x8(%ebp),%eax
  80021f:	c1 e8 18             	shr    $0x18,%eax
  800222:	83 e0 0f             	and    $0xf,%eax
  800225:	09 d0                	or     %edx,%eax
  800227:	83 c8 e0             	or     $0xffffffe0,%eax
  80022a:	0f b6 c0             	movzbl %al,%eax
  80022d:	c7 45 c0 f6 01 00 00 	movl   $0x1f6,-0x40(%ebp)
  800234:	88 45 bf             	mov    %al,-0x41(%ebp)
  800237:	0f b6 45 bf          	movzbl -0x41(%ebp),%eax
  80023b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80023e:	ee                   	out    %al,(%dx)
  80023f:	c7 45 b8 f7 01 00 00 	movl   $0x1f7,-0x48(%ebp)
  800246:	c6 45 b7 20          	movb   $0x20,-0x49(%ebp)
  80024a:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
  80024e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  800251:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800252:	eb 59                	jmp    8002ad <ide_read+0x146>
		if ((r = ide_wait_ready(1)) < 0)
  800254:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80025b:	e8 d4 fd ff ff       	call   800034 <ide_wait_ready>
  800260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800263:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800267:	79 05                	jns    80026e <ide_read+0x107>
			return r;
  800269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026c:	eb 4a                	jmp    8002b8 <ide_read+0x151>
  80026e:	c7 45 b0 f0 01 00 00 	movl   $0x1f0,-0x50(%ebp)
  800275:	8b 45 0c             	mov    0xc(%ebp),%eax
  800278:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80027b:	c7 45 a8 80 00 00 00 	movl   $0x80,-0x58(%ebp)
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  800282:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800285:	8b 4d ac             	mov    -0x54(%ebp),%ecx
  800288:	8b 55 a8             	mov    -0x58(%ebp),%edx
  80028b:	89 ce                	mov    %ecx,%esi
  80028d:	89 d3                	mov    %edx,%ebx
  80028f:	89 f7                	mov    %esi,%edi
  800291:	89 d9                	mov    %ebx,%ecx
  800293:	89 c2                	mov    %eax,%edx
  800295:	fc                   	cld    
  800296:	f2 6d                	repnz insl (%dx),%es:(%edi)
  800298:	89 cb                	mov    %ecx,%ebx
  80029a:	89 fe                	mov    %edi,%esi
  80029c:	89 75 ac             	mov    %esi,-0x54(%ebp)
  80029f:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002a2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8002a6:	81 45 0c 00 02 00 00 	addl   $0x200,0xc(%ebp)
  8002ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002b1:	75 a1                	jne    800254 <ide_read+0xed>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}
	
	return 0;
  8002b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002b8:	83 c4 5c             	add    $0x5c,%esp
  8002bb:	5b                   	pop    %ebx
  8002bc:	5e                   	pop    %esi
  8002bd:	5f                   	pop    %edi
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	56                   	push   %esi
  8002c4:	53                   	push   %ebx
  8002c5:	83 ec 50             	sub    $0x50,%esp
	int r;
	
	assert(nsecs <= 256);
  8002c8:	81 7d 10 00 01 00 00 	cmpl   $0x100,0x10(%ebp)
  8002cf:	76 24                	jbe    8002f5 <ide_write+0x35>
  8002d1:	c7 44 24 0c 90 4c 80 	movl   $0x804c90,0xc(%esp)
  8002d8:	00 
  8002d9:	c7 44 24 08 9d 4c 80 	movl   $0x804c9d,0x8(%esp)
  8002e0:	00 
  8002e1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8002e8:	00 
  8002e9:	c7 04 24 87 4c 80 00 	movl   $0x804c87,(%esp)
  8002f0:	e8 8f 23 00 00       	call   802684 <_panic>

	ide_wait_ready(0);
  8002f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002fc:	e8 33 fd ff ff       	call   800034 <ide_wait_ready>

	outb(0x1F2, nsecs);
  800301:	8b 45 10             	mov    0x10(%ebp),%eax
  800304:	0f b6 c0             	movzbl %al,%eax
  800307:	c7 45 f0 f2 01 00 00 	movl   $0x1f2,-0x10(%ebp)
  80030e:	88 45 ef             	mov    %al,-0x11(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800311:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  800315:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800318:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	0f b6 c0             	movzbl %al,%eax
  80031f:	c7 45 e8 f3 01 00 00 	movl   $0x1f3,-0x18(%ebp)
  800326:	88 45 e7             	mov    %al,-0x19(%ebp)
  800329:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  80032d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800330:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	c1 e8 08             	shr    $0x8,%eax
  800337:	0f b6 c0             	movzbl %al,%eax
  80033a:	c7 45 e0 f4 01 00 00 	movl   $0x1f4,-0x20(%ebp)
  800341:	88 45 df             	mov    %al,-0x21(%ebp)
  800344:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800348:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034b:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	c1 e8 10             	shr    $0x10,%eax
  800352:	0f b6 c0             	movzbl %al,%eax
  800355:	c7 45 d8 f5 01 00 00 	movl   $0x1f5,-0x28(%ebp)
  80035c:	88 45 d7             	mov    %al,-0x29(%ebp)
  80035f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800363:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800366:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800367:	a1 00 80 80 00       	mov    0x808000,%eax
  80036c:	83 e0 01             	and    $0x1,%eax
  80036f:	89 c2                	mov    %eax,%edx
  800371:	c1 e2 04             	shl    $0x4,%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	c1 e8 18             	shr    $0x18,%eax
  80037a:	83 e0 0f             	and    $0xf,%eax
  80037d:	09 d0                	or     %edx,%eax
  80037f:	83 c8 e0             	or     $0xffffffe0,%eax
  800382:	0f b6 c0             	movzbl %al,%eax
  800385:	c7 45 d0 f6 01 00 00 	movl   $0x1f6,-0x30(%ebp)
  80038c:	88 45 cf             	mov    %al,-0x31(%ebp)
  80038f:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
  800393:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800396:	ee                   	out    %al,(%dx)
  800397:	c7 45 c8 f7 01 00 00 	movl   $0x1f7,-0x38(%ebp)
  80039e:	c6 45 c7 30          	movb   $0x30,-0x39(%ebp)
  8003a2:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
  8003a6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8003a9:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8003aa:	eb 55                	jmp    800401 <ide_write+0x141>
		if ((r = ide_wait_ready(1)) < 0)
  8003ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003b3:	e8 7c fc ff ff       	call   800034 <ide_wait_ready>
  8003b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8003bf:	79 05                	jns    8003c6 <ide_write+0x106>
			return r;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	eb 46                	jmp    80040c <ide_write+0x14c>
  8003c6:	c7 45 c0 f0 01 00 00 	movl   $0x1f0,-0x40(%ebp)
  8003cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8003d3:	c7 45 b8 80 00 00 00 	movl   $0x80,-0x48(%ebp)
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  8003da:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003dd:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8003e0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8003e3:	89 ce                	mov    %ecx,%esi
  8003e5:	89 d3                	mov    %edx,%ebx
  8003e7:	89 d9                	mov    %ebx,%ecx
  8003e9:	89 c2                	mov    %eax,%edx
  8003eb:	fc                   	cld    
  8003ec:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  8003ee:	89 cb                	mov    %ecx,%ebx
  8003f0:	89 75 bc             	mov    %esi,-0x44(%ebp)
  8003f3:	89 5d b8             	mov    %ebx,-0x48(%ebp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8003f6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8003fa:	81 45 0c 00 02 00 00 	addl   $0x200,0xc(%ebp)
  800401:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800405:	75 a5                	jne    8003ac <ide_write+0xec>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80040c:	83 c4 50             	add    $0x50,%esp
  80040f:	5b                   	pop    %ebx
  800410:	5e                   	pop    %esi
  800411:	5d                   	pop    %ebp
  800412:	c3                   	ret    
	...

00800414 <diskaddr>:
bool block_is_free(uint32_t blockno);

// Return the virtual address of this disk block.
char*
diskaddr(uint32_t blockno)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	83 ec 18             	sub    $0x18,%esp
	if (super && blockno >= super->s_nblocks)
  80041a:	a1 64 c0 80 00       	mov    0x80c064,%eax
  80041f:	85 c0                	test   %eax,%eax
  800421:	74 30                	je     800453 <diskaddr+0x3f>
  800423:	a1 64 c0 80 00       	mov    0x80c064,%eax
  800428:	8b 40 04             	mov    0x4(%eax),%eax
  80042b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80042e:	77 23                	ja     800453 <diskaddr+0x3f>
		panic("bad block number %08x in diskaddr", blockno);
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800437:	c7 44 24 08 b4 4c 80 	movl   $0x804cb4,0x8(%esp)
  80043e:	00 
  80043f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  800446:	00 
  800447:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  80044e:	e8 31 22 00 00       	call   802684 <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	05 00 00 01 00       	add    $0x10000,%eax
  80045b:	c1 e0 0c             	shl    $0xc,%eax
}
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
	return (vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P);
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	c1 e8 16             	shr    $0x16,%eax
  800469:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800470:	83 e0 01             	and    $0x1,%eax
  800473:	84 c0                	test   %al,%al
  800475:	74 1b                	je     800492 <va_is_mapped+0x32>
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	c1 e8 0c             	shr    $0xc,%eax
  80047d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800484:	83 e0 01             	and    $0x1,%eax
  800487:	84 c0                	test   %al,%al
  800489:	74 07                	je     800492 <va_is_mapped+0x32>
  80048b:	b8 01 00 00 00       	mov    $0x1,%eax
  800490:	eb 05                	jmp    800497 <va_is_mapped+0x37>
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800497:	5d                   	pop    %ebp
  800498:	c3                   	ret    

00800499 <block_is_mapped>:

// Is this disk block mapped?
bool
block_is_mapped(uint32_t blockno)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 28             	sub    $0x28,%esp
	char *va = diskaddr(blockno);
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	89 04 24             	mov    %eax,(%esp)
  8004a5:	e8 6a ff ff ff       	call   800414 <diskaddr>
  8004aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return va_is_mapped(va) && va != 0;
  8004ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b0:	89 04 24             	mov    %eax,(%esp)
  8004b3:	e8 a8 ff ff ff       	call   800460 <va_is_mapped>
  8004b8:	85 c0                	test   %eax,%eax
  8004ba:	74 0d                	je     8004c9 <block_is_mapped+0x30>
  8004bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8004c0:	74 07                	je     8004c9 <block_is_mapped+0x30>
  8004c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8004c7:	eb 05                	jmp    8004ce <block_is_mapped+0x35>
  8004c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
	return (vpt[VPN(va)] & PTE_D) != 0;
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	c1 e8 0c             	shr    $0xc,%eax
  8004d9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004e0:	83 e0 40             	and    $0x40,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	0f 95 c0             	setne  %al
  8004e8:	0f b6 c0             	movzbl %al,%eax
}
  8004eb:	5d                   	pop    %ebp
  8004ec:	c3                   	ret    

008004ed <block_is_dirty>:

// Is this block dirty?
bool
block_is_dirty(uint32_t blockno)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 28             	sub    $0x28,%esp
	char *va = diskaddr(blockno);
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	89 04 24             	mov    %eax,(%esp)
  8004f9:	e8 16 ff ff ff       	call   800414 <diskaddr>
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return va_is_mapped(va) && va_is_dirty(va);
  800501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800504:	89 04 24             	mov    %eax,(%esp)
  800507:	e8 54 ff ff ff       	call   800460 <va_is_mapped>
  80050c:	85 c0                	test   %eax,%eax
  80050e:	74 16                	je     800526 <block_is_dirty+0x39>
  800510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800513:	89 04 24             	mov    %eax,(%esp)
  800516:	e8 b5 ff ff ff       	call   8004d0 <va_is_dirty>
  80051b:	85 c0                	test   %eax,%eax
  80051d:	74 07                	je     800526 <block_is_dirty+0x39>
  80051f:	b8 01 00 00 00       	mov    $0x1,%eax
  800524:	eb 05                	jmp    80052b <block_is_dirty+0x3e>
  800526:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <map_block>:

// Allocate a page to hold the disk block
int
map_block(uint32_t blockno)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	if (block_is_mapped(blockno))
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	89 04 24             	mov    %eax,(%esp)
  800539:	e8 5b ff ff ff       	call   800499 <block_is_mapped>
  80053e:	85 c0                	test   %eax,%eax
  800540:	74 07                	je     800549 <map_block+0x1c>
		return 0;
  800542:	b8 00 00 00 00       	mov    $0x0,%eax
  800547:	eb 23                	jmp    80056c <map_block+0x3f>
	return sys_page_alloc(0, diskaddr(blockno), PTE_U|PTE_P|PTE_W);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	89 04 24             	mov    %eax,(%esp)
  80054f:	e8 c0 fe ff ff       	call   800414 <diskaddr>
  800554:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80055b:	00 
  80055c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800567:	e8 9a 31 00 00       	call   803706 <sys_page_alloc>
}
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <read_block>:
// If blk != 0, set *blk to the address of the block in memory.
//
// Hint: Use diskaddr, map_block, and ide_read.
static int
read_block(uint32_t blockno, char **blk)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *addr;

	if (super && blockno >= super->s_nblocks)
  800574:	a1 64 c0 80 00       	mov    0x80c064,%eax
  800579:	85 c0                	test   %eax,%eax
  80057b:	74 30                	je     8005ad <read_block+0x3f>
  80057d:	a1 64 c0 80 00       	mov    0x80c064,%eax
  800582:	8b 40 04             	mov    0x4(%eax),%eax
  800585:	3b 45 08             	cmp    0x8(%ebp),%eax
  800588:	77 23                	ja     8005ad <read_block+0x3f>
		panic("reading non-existent block %08x\n", blockno);
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800591:	c7 44 24 08 e0 4c 80 	movl   $0x804ce0,0x8(%esp)
  800598:	00 
  800599:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8005a0:	00 
  8005a1:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  8005a8:	e8 d7 20 00 00       	call   802684 <_panic>

	if (bitmap && block_is_free(blockno))
  8005ad:	a1 60 c0 80 00       	mov    0x80c060,%eax
  8005b2:	85 c0                	test   %eax,%eax
  8005b4:	74 32                	je     8005e8 <read_block+0x7a>
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	89 04 24             	mov    %eax,(%esp)
  8005bc:	e8 71 02 00 00       	call   800832 <block_is_free>
  8005c1:	85 c0                	test   %eax,%eax
  8005c3:	74 23                	je     8005e8 <read_block+0x7a>
		panic("reading free block %08x\n", blockno);
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cc:	c7 44 24 08 01 4d 80 	movl   $0x804d01,0x8(%esp)
  8005d3:	00 
  8005d4:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8005db:	00 
  8005dc:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  8005e3:	e8 9c 20 00 00       	call   802684 <_panic>

	// LAB 5: Your code here.
	addr = diskaddr(blockno);
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	89 04 24             	mov    %eax,(%esp)
  8005ee:	e8 21 fe ff ff       	call   800414 <diskaddr>
  8005f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(blk == NULL){ *blk = addr;}//set blk to the address
  8005f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fa:	75 08                	jne    800604 <read_block+0x96>
  8005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800602:	89 10                	mov    %edx,(%eax)
	if(va_is_mapped(addr)) return 0;//has been mapped
  800604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800607:	89 04 24             	mov    %eax,(%esp)
  80060a:	e8 51 fe ff ff       	call   800460 <va_is_mapped>
  80060f:	85 c0                	test   %eax,%eax
  800611:	74 07                	je     80061a <read_block+0xac>
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	eb 4d                	jmp    800667 <read_block+0xf9>
	if((r = map_block(blockno)) < 0) return r;//map_block failed
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	89 04 24             	mov    %eax,(%esp)
  800620:	e8 08 ff ff ff       	call   80052d <map_block>
  800625:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800628:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80062c:	79 05                	jns    800633 <read_block+0xc5>
  80062e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800631:	eb 34                	jmp    800667 <read_block+0xf9>
	if((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS))) return r;//ide_read fail
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80063d:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800644:	00 
  800645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064c:	89 14 24             	mov    %edx,(%esp)
  80064f:	e8 13 fb ff ff       	call   800167 <ide_read>
  800654:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800657:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80065b:	74 05                	je     800662 <read_block+0xf4>
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	eb 05                	jmp    800667 <read_block+0xf9>
	//panic("read_block not implemented");
	return 0;
  800662:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <write_block>:
// Then clear the PTE_D bit using sys_page_map.
// Hint: Use ide_write.
// Hint: Use the PTE_USER constant when calling sys_page_map.
void
write_block(uint32_t blockno)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 38             	sub    $0x38,%esp
	char *addr;
	int r;
	if (!block_is_mapped(blockno))
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	89 04 24             	mov    %eax,(%esp)
  800675:	e8 1f fe ff ff       	call   800499 <block_is_mapped>
  80067a:	85 c0                	test   %eax,%eax
  80067c:	75 23                	jne    8006a1 <write_block+0x38>
		panic("write unmapped block %08x", blockno);
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800685:	c7 44 24 08 1a 4d 80 	movl   $0x804d1a,0x8(%esp)
  80068c:	00 
  80068d:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  800694:	00 
  800695:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  80069c:	e8 e3 1f 00 00       	call   802684 <_panic>
	
	// Write the disk block and clear PTE_D.
	// LAB 5: Your code here.
	addr = diskaddr(blockno);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	89 04 24             	mov    %eax,(%esp)
  8006a7:	e8 68 fd ff ff       	call   800414 <diskaddr>
  8006ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(!va_is_dirty(addr)) return;//not dirty
  8006af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b2:	89 04 24             	mov    %eax,(%esp)
  8006b5:	e8 16 fe ff ff       	call   8004d0 <va_is_dirty>
  8006ba:	85 c0                	test   %eax,%eax
  8006bc:	0f 84 95 00 00 00    	je     800757 <write_block+0xee>
	if((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0){
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8006cc:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  8006d3:	00 
  8006d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006db:	89 14 24             	mov    %edx,(%esp)
  8006de:	e8 dd fb ff ff       	call   8002c0 <ide_write>
  8006e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006ea:	79 1c                	jns    800708 <write_block+0x9f>
		panic("ide_write failed\n");
  8006ec:	c7 44 24 08 34 4d 80 	movl   $0x804d34,0x8(%esp)
  8006f3:	00 
  8006f4:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
  8006fb:	00 
  8006fc:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800703:	e8 7c 1f 00 00       	call   802684 <_panic>
		}
	//remove the PTE_D
	if((r = sys_page_map(0, addr, 0, addr, PTE_USER)) < 0){
  800708:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  80070f:	00 
  800710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800713:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800717:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80071e:	00 
  80071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800722:	89 44 24 04          	mov    %eax,0x4(%esp)
  800726:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80072d:	e8 15 30 00 00       	call   803747 <sys_page_map>
  800732:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800739:	79 1d                	jns    800758 <write_block+0xef>
		panic("sys_page_map failed\n");
  80073b:	c7 44 24 08 46 4d 80 	movl   $0x804d46,0x8(%esp)
  800742:	00 
  800743:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  80074a:	00 
  80074b:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800752:	e8 2d 1f 00 00       	call   802684 <_panic>
		panic("write unmapped block %08x", blockno);
	
	// Write the disk block and clear PTE_D.
	// LAB 5: Your code here.
	addr = diskaddr(blockno);
	if(!va_is_dirty(addr)) return;//not dirty
  800757:	90                   	nop
	//remove the PTE_D
	if((r = sys_page_map(0, addr, 0, addr, PTE_USER)) < 0){
		panic("sys_page_map failed\n");
		}
	//panic("write_block not implemented");
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <unmap_block>:

// Make sure this block is unmapped.
void
unmap_block(uint32_t blockno)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (!block_is_mapped(blockno))
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	89 04 24             	mov    %eax,(%esp)
  800766:	e8 2e fd ff ff       	call   800499 <block_is_mapped>
  80076b:	85 c0                	test   %eax,%eax
  80076d:	0f 84 bc 00 00 00    	je     80082f <unmap_block+0xd5>
		return;

	assert(block_is_free(blockno) || !block_is_dirty(blockno));
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	89 04 24             	mov    %eax,(%esp)
  800779:	e8 b4 00 00 00       	call   800832 <block_is_free>
  80077e:	85 c0                	test   %eax,%eax
  800780:	75 33                	jne    8007b5 <unmap_block+0x5b>
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	e8 60 fd ff ff       	call   8004ed <block_is_dirty>
  80078d:	85 c0                	test   %eax,%eax
  80078f:	74 24                	je     8007b5 <unmap_block+0x5b>
  800791:	c7 44 24 0c 5c 4d 80 	movl   $0x804d5c,0xc(%esp)
  800798:	00 
  800799:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  8007a0:	00 
  8007a1:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8007a8:	00 
  8007a9:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  8007b0:	e8 cf 1e 00 00       	call   802684 <_panic>

	if ((r = sys_page_unmap(0, diskaddr(blockno))) < 0)
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	89 04 24             	mov    %eax,(%esp)
  8007bb:	e8 54 fc ff ff       	call   800414 <diskaddr>
  8007c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007cb:	e8 bd 2f 00 00       	call   80378d <sys_page_unmap>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8007d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007d7:	79 23                	jns    8007fc <unmap_block+0xa2>
		panic("unmap_block: sys_mem_unmap: %e", r);
  8007d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007e0:	c7 44 24 08 a4 4d 80 	movl   $0x804da4,0x8(%esp)
  8007e7:	00 
  8007e8:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8007ef:	00 
  8007f0:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  8007f7:	e8 88 1e 00 00       	call   802684 <_panic>
	assert(!block_is_mapped(blockno));
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	89 04 24             	mov    %eax,(%esp)
  800802:	e8 92 fc ff ff       	call   800499 <block_is_mapped>
  800807:	85 c0                	test   %eax,%eax
  800809:	74 25                	je     800830 <unmap_block+0xd6>
  80080b:	c7 44 24 0c c3 4d 80 	movl   $0x804dc3,0xc(%esp)
  800812:	00 
  800813:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  80081a:	00 
  80081b:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
  800822:	00 
  800823:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  80082a:	e8 55 1e 00 00       	call   802684 <_panic>
unmap_block(uint32_t blockno)
{
	int r;

	if (!block_is_mapped(blockno))
		return;
  80082f:	90                   	nop
	assert(block_is_free(blockno) || !block_is_dirty(blockno));

	if ((r = sys_page_unmap(0, diskaddr(blockno))) < 0)
		panic("unmap_block: sys_mem_unmap: %e", r);
	assert(!block_is_mapped(blockno));
}
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	56                   	push   %esi
  800836:	53                   	push   %ebx
	if (super == 0 || blockno >= super->s_nblocks)
  800837:	a1 64 c0 80 00       	mov    0x80c064,%eax
  80083c:	85 c0                	test   %eax,%eax
  80083e:	74 0d                	je     80084d <block_is_free+0x1b>
  800840:	a1 64 c0 80 00       	mov    0x80c064,%eax
  800845:	8b 40 04             	mov    0x4(%eax),%eax
  800848:	3b 45 08             	cmp    0x8(%ebp),%eax
  80084b:	77 07                	ja     800854 <block_is_free+0x22>
		return 0;
  80084d:	b8 00 00 00 00       	mov    $0x0,%eax
  800852:	eb 37                	jmp    80088b <block_is_free+0x59>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800854:	a1 60 c0 80 00       	mov    0x80c060,%eax
  800859:	8b 55 08             	mov    0x8(%ebp),%edx
  80085c:	c1 ea 05             	shr    $0x5,%edx
  80085f:	c1 e2 02             	shl    $0x2,%edx
  800862:	01 d0                	add    %edx,%eax
  800864:	8b 10                	mov    (%eax),%edx
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	83 e0 1f             	and    $0x1f,%eax
  80086c:	bb 01 00 00 00       	mov    $0x1,%ebx
  800871:	89 de                	mov    %ebx,%esi
  800873:	89 c1                	mov    %eax,%ecx
  800875:	d3 e6                	shl    %cl,%esi
  800877:	89 f0                	mov    %esi,%eax
  800879:	21 d0                	and    %edx,%eax
  80087b:	85 c0                	test   %eax,%eax
  80087d:	74 07                	je     800886 <block_is_free+0x54>
		return 1;
  80087f:	b8 01 00 00 00       	mov    $0x1,%eax
  800884:	eb 05                	jmp    80088b <block_is_free+0x59>
	return 0;
  800886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80088b:	5b                   	pop    %ebx
  80088c:	5e                   	pop    %esi
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	57                   	push   %edi
  800893:	56                   	push   %esi
  800894:	53                   	push   %ebx
  800895:	83 ec 1c             	sub    $0x1c,%esp
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800898:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80089c:	75 1c                	jne    8008ba <free_block+0x2b>
		panic("attempt to free zero block");
  80089e:	c7 44 24 08 dd 4d 80 	movl   $0x804ddd,0x8(%esp)
  8008a5:	00 
  8008a6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  8008ad:	00 
  8008ae:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  8008b5:	e8 ca 1d 00 00       	call   802684 <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  8008ba:	8b 0d 60 c0 80 00    	mov    0x80c060,%ecx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	c1 e8 05             	shr    $0x5,%eax
  8008c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008cd:	01 ca                	add    %ecx,%edx
  8008cf:	8b 0d 60 c0 80 00    	mov    0x80c060,%ecx
  8008d5:	c1 e0 02             	shl    $0x2,%eax
  8008d8:	01 c8                	add    %ecx,%eax
  8008da:	8b 18                	mov    (%eax),%ebx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	83 e0 1f             	and    $0x1f,%eax
  8008e2:	be 01 00 00 00       	mov    $0x1,%esi
  8008e7:	89 f7                	mov    %esi,%edi
  8008e9:	89 c1                	mov    %eax,%ecx
  8008eb:	d3 e7                	shl    %cl,%edi
  8008ed:	89 f8                	mov    %edi,%eax
  8008ef:	09 d8                	or     %ebx,%eax
  8008f1:	89 02                	mov    %eax,(%edx)
}
  8008f3:	83 c4 1c             	add    $0x1c,%esp
  8008f6:	5b                   	pop    %ebx
  8008f7:	5e                   	pop    %esi
  8008f8:	5f                   	pop    %edi
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <alloc_block_num>:
// 
// Return block number allocated on success,
// -E_NO_DISK if we are out of blocks.
int
alloc_block_num(void)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	57                   	push   %edi
  8008ff:	56                   	push   %esi
  800900:	53                   	push   %ebx
  800901:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 5: Your code here.
	//panic("alloc_block_num not implemented");
	int i;
	//if((r = alloc_block()) < 0) 
	for(i=3; i<super->s_nblocks; i++){
  800904:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  80090b:	e9 b9 00 00 00       	jmp    8009c9 <alloc_block_num+0xce>
		if((bitmap[i/32] && (1<<(i%32)))){//find the place
  800910:	8b 15 60 c0 80 00    	mov    0x80c060,%edx
  800916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800919:	8d 48 1f             	lea    0x1f(%eax),%ecx
  80091c:	85 c0                	test   %eax,%eax
  80091e:	0f 48 c1             	cmovs  %ecx,%eax
  800921:	c1 f8 05             	sar    $0x5,%eax
  800924:	c1 e0 02             	shl    $0x2,%eax
  800927:	01 d0                	add    %edx,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	85 c0                	test   %eax,%eax
  80092d:	0f 84 92 00 00 00    	je     8009c5 <alloc_block_num+0xca>
  800933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800936:	89 c2                	mov    %eax,%edx
  800938:	c1 fa 1f             	sar    $0x1f,%edx
  80093b:	c1 ea 1b             	shr    $0x1b,%edx
  80093e:	01 d0                	add    %edx,%eax
  800940:	83 e0 1f             	and    $0x1f,%eax
  800943:	29 d0                	sub    %edx,%eax
  800945:	ba 01 00 00 00       	mov    $0x1,%edx
  80094a:	89 d3                	mov    %edx,%ebx
  80094c:	89 c1                	mov    %eax,%ecx
  80094e:	d3 e3                	shl    %cl,%ebx
  800950:	89 d8                	mov    %ebx,%eax
  800952:	85 c0                	test   %eax,%eax
  800954:	74 6f                	je     8009c5 <alloc_block_num+0xca>
		    bitmap[i/32] &= ~(1<<(i%32));
  800956:	8b 15 60 c0 80 00    	mov    0x80c060,%edx
  80095c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095f:	8d 48 1f             	lea    0x1f(%eax),%ecx
  800962:	85 c0                	test   %eax,%eax
  800964:	0f 48 c1             	cmovs  %ecx,%eax
  800967:	c1 f8 05             	sar    $0x5,%eax
  80096a:	89 c1                	mov    %eax,%ecx
  80096c:	c1 e1 02             	shl    $0x2,%ecx
  80096f:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
  800972:	8b 15 60 c0 80 00    	mov    0x80c060,%edx
  800978:	c1 e0 02             	shl    $0x2,%eax
  80097b:	01 d0                	add    %edx,%eax
  80097d:	8b 30                	mov    (%eax),%esi
  80097f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800982:	89 c2                	mov    %eax,%edx
  800984:	c1 fa 1f             	sar    $0x1f,%edx
  800987:	c1 ea 1b             	shr    $0x1b,%edx
  80098a:	01 d0                	add    %edx,%eax
  80098c:	83 e0 1f             	and    $0x1f,%eax
  80098f:	29 d0                	sub    %edx,%eax
  800991:	ba 01 00 00 00       	mov    $0x1,%edx
  800996:	89 d7                	mov    %edx,%edi
  800998:	89 c1                	mov    %eax,%ecx
  80099a:	d3 e7                	shl    %cl,%edi
  80099c:	89 f8                	mov    %edi,%eax
  80099e:	f7 d0                	not    %eax
  8009a0:	21 f0                	and    %esi,%eax
  8009a2:	89 03                	mov    %eax,(%ebx)
		    write_block(2 + i/BLKBITSIZE);
  8009a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009a7:	8d 90 ff 7f 00 00    	lea    0x7fff(%eax),%edx
  8009ad:	85 c0                	test   %eax,%eax
  8009af:	0f 48 c2             	cmovs  %edx,%eax
  8009b2:	c1 f8 0f             	sar    $0xf,%eax
  8009b5:	83 c0 02             	add    $0x2,%eax
  8009b8:	89 04 24             	mov    %eax,(%esp)
  8009bb:	e8 a9 fc ff ff       	call   800669 <write_block>
		    return i;
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	eb 1c                	jmp    8009e1 <alloc_block_num+0xe6>
{
	// LAB 5: Your code here.
	//panic("alloc_block_num not implemented");
	int i;
	//if((r = alloc_block()) < 0) 
	for(i=3; i<super->s_nblocks; i++){
  8009c5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  8009c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009cc:	a1 64 c0 80 00       	mov    0x80c064,%eax
  8009d1:	8b 40 04             	mov    0x4(%eax),%eax
  8009d4:	39 c2                	cmp    %eax,%edx
  8009d6:	0f 82 34 ff ff ff    	jb     800910 <alloc_block_num+0x15>
		    bitmap[i/32] &= ~(1<<(i%32));
		    write_block(2 + i/BLKBITSIZE);
		    return i;
		}
	}
	return -E_NO_DISK;
  8009dc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  8009e1:	83 c4 2c             	add    $0x2c,%esp
  8009e4:	5b                   	pop    %ebx
  8009e5:	5e                   	pop    %esi
  8009e6:	5f                   	pop    %edi
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <alloc_block>:

// Allocate a block -- first find a free block in the bitmap,
// then map it into memory.
int
alloc_block(void)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	83 ec 28             	sub    $0x28,%esp
	int r, bno;

	if ((r = alloc_block_num()) < 0)
  8009ef:	e8 07 ff ff ff       	call   8008fb <alloc_block_num>
  8009f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8009fb:	79 05                	jns    800a02 <alloc_block+0x19>
		return r;
  8009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a00:	eb 2d                	jmp    800a2f <alloc_block+0x46>
	bno = r;
  800a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a05:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if ((r = map_block(bno)) < 0) {
  800a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0b:	89 04 24             	mov    %eax,(%esp)
  800a0e:	e8 1a fb ff ff       	call   80052d <map_block>
  800a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a1a:	79 10                	jns    800a2c <alloc_block+0x43>
		free_block(bno);
  800a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1f:	89 04 24             	mov    %eax,(%esp)
  800a22:	e8 68 fe ff ff       	call   80088f <free_block>
		return r;
  800a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a2a:	eb 03                	jmp    800a2f <alloc_block+0x46>
	}
	return bno;
  800a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2f:	c9                   	leave  
  800a30:	c3                   	ret    

00800a31 <read_super>:

// Read and validate the file system super-block.
void
read_super(void)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *blk;

	if ((r = read_block(1, &blk)) < 0)
  800a37:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a45:	e8 24 fb ff ff       	call   80056e <read_block>
  800a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a51:	79 23                	jns    800a76 <read_super+0x45>
		panic("cannot read superblock: %e", r);
  800a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a56:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a5a:	c7 44 24 08 f8 4d 80 	movl   $0x804df8,0x8(%esp)
  800a61:	00 
  800a62:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  800a69:	00 
  800a6a:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800a71:	e8 0e 1c 00 00       	call   802684 <_panic>

	super = (struct Super*) blk;
  800a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a79:	a3 64 c0 80 00       	mov    %eax,0x80c064
	if (super->s_magic != FS_MAGIC)
  800a7e:	a1 64 c0 80 00       	mov    0x80c064,%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800a8a:	74 1c                	je     800aa8 <read_super+0x77>
		panic("bad file system magic number");
  800a8c:	c7 44 24 08 13 4e 80 	movl   $0x804e13,0x8(%esp)
  800a93:	00 
  800a94:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  800a9b:	00 
  800a9c:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800aa3:	e8 dc 1b 00 00       	call   802684 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800aa8:	a1 64 c0 80 00       	mov    0x80c064,%eax
  800aad:	8b 40 04             	mov    0x4(%eax),%eax
  800ab0:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800ab5:	76 1c                	jbe    800ad3 <read_super+0xa2>
		panic("file system is too large");
  800ab7:	c7 44 24 08 30 4e 80 	movl   $0x804e30,0x8(%esp)
  800abe:	00 
  800abf:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  800ac6:	00 
  800ac7:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800ace:	e8 b1 1b 00 00       	call   802684 <_panic>

	cprintf("superblock is good\n");
  800ad3:	c7 04 24 49 4e 80 00 	movl   $0x804e49,(%esp)
  800ada:	e8 d9 1c 00 00       	call   8027b8 <cprintf>
}
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <read_bitmap>:
//
// Hint: Assume that the superblock has already been loaded into
// memory (in variable 'super').  Check out super->s_nblocks.
void
read_bitmap(void)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 28             	sub    $0x28,%esp
	/*
	if ((r = read_block(2, &blk)) < 0)
		panic("cannot read bitmap block: %e", r);

	bitmap = (struct bitmap*) blk;*/
	bitmap_blkno = super->s_nblocks / BLKBITSIZE;
  800ae7:	a1 64 c0 80 00       	mov    0x80c064,%eax
  800aec:	8b 40 04             	mov    0x4(%eax),%eax
  800aef:	c1 e8 0f             	shr    $0xf,%eax
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(super->s_nblocks % BLKBITSIZE) bitmap_blkno++;
  800af5:	a1 64 c0 80 00       	mov    0x80c064,%eax
  800afa:	8b 40 04             	mov    0x4(%eax),%eax
  800afd:	25 ff 7f 00 00       	and    $0x7fff,%eax
  800b02:	85 c0                	test   %eax,%eax
  800b04:	74 04                	je     800b0a <read_bitmap+0x29>
  800b06:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
	for(i=0;i<bitmap_blkno;i++){
  800b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800b11:	eb 45                	jmp    800b58 <read_bitmap+0x77>
		if((r = read_block(2+i, &blk)) < 0){
  800b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b16:	8d 50 02             	lea    0x2(%eax),%edx
  800b19:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b20:	89 14 24             	mov    %edx,(%esp)
  800b23:	e8 46 fa ff ff       	call   80056e <read_block>
  800b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b2f:	79 23                	jns    800b54 <read_bitmap+0x73>
			panic("cannot read bitmap block: %e", r);}
  800b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b34:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b38:	c7 44 24 08 5d 4e 80 	movl   $0x804e5d,0x8(%esp)
  800b3f:	00 
  800b40:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  800b47:	00 
  800b48:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800b4f:	e8 30 1b 00 00       	call   802684 <_panic>
		panic("cannot read bitmap block: %e", r);

	bitmap = (struct bitmap*) blk;*/
	bitmap_blkno = super->s_nblocks / BLKBITSIZE;
	if(super->s_nblocks % BLKBITSIZE) bitmap_blkno++;
	for(i=0;i<bitmap_blkno;i++){
  800b54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b5b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b5e:	72 b3                	jb     800b13 <read_bitmap+0x32>
		if((r = read_block(2+i, &blk)) < 0){
			panic("cannot read bitmap block: %e", r);}
	}
	bitmap = (uint32_t *)diskaddr(2);
  800b60:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800b67:	e8 a8 f8 ff ff       	call   800414 <diskaddr>
  800b6c:	a3 60 c0 80 00       	mov    %eax,0x80c060
	//panic("read_bitmap not implemented");

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800b71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b78:	e8 b5 fc ff ff       	call   800832 <block_is_free>
  800b7d:	85 c0                	test   %eax,%eax
  800b7f:	74 24                	je     800ba5 <read_bitmap+0xc4>
  800b81:	c7 44 24 0c 7a 4e 80 	movl   $0x804e7a,0xc(%esp)
  800b88:	00 
  800b89:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800b90:	00 
  800b91:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  800b98:	00 
  800b99:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800ba0:	e8 df 1a 00 00       	call   802684 <_panic>
	assert(!block_is_free(1));
  800ba5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800bac:	e8 81 fc ff ff       	call   800832 <block_is_free>
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	74 24                	je     800bd9 <read_bitmap+0xf8>
  800bb5:	c7 44 24 0c 8c 4e 80 	movl   $0x804e8c,0xc(%esp)
  800bbc:	00 
  800bbd:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800bc4:	00 
  800bc5:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  800bcc:	00 
  800bcd:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800bd4:	e8 ab 1a 00 00       	call   802684 <_panic>
	assert(bitmap);
  800bd9:	a1 60 c0 80 00       	mov    0x80c060,%eax
  800bde:	85 c0                	test   %eax,%eax
  800be0:	75 24                	jne    800c06 <read_bitmap+0x125>
  800be2:	c7 44 24 0c 9e 4e 80 	movl   $0x804e9e,0xc(%esp)
  800be9:	00 
  800bea:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800bf1:	00 
  800bf2:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  800bf9:	00 
  800bfa:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800c01:	e8 7e 1a 00 00       	call   802684 <_panic>

	// Make sure that the bitmap blocks are marked in-use.
	// LAB 5: Your code here.
    for(i=0;i<bitmap_blkno;i++){
  800c06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800c0d:	eb 3a                	jmp    800c49 <read_bitmap+0x168>
		assert(!block_is_free(2+i));
  800c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c12:	83 c0 02             	add    $0x2,%eax
  800c15:	89 04 24             	mov    %eax,(%esp)
  800c18:	e8 15 fc ff ff       	call   800832 <block_is_free>
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	74 24                	je     800c45 <read_bitmap+0x164>
  800c21:	c7 44 24 0c a5 4e 80 	movl   $0x804ea5,0xc(%esp)
  800c28:	00 
  800c29:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800c30:	00 
  800c31:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  800c38:	00 
  800c39:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800c40:	e8 3f 1a 00 00       	call   802684 <_panic>
	assert(!block_is_free(1));
	assert(bitmap);

	// Make sure that the bitmap blocks are marked in-use.
	// LAB 5: Your code here.
    for(i=0;i<bitmap_blkno;i++){
  800c45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c4c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c4f:	72 be                	jb     800c0f <read_bitmap+0x12e>
		assert(!block_is_free(2+i));
	}
	cprintf("read_bitmap is good\n");
  800c51:	c7 04 24 b9 4e 80 00 	movl   $0x804eb9,(%esp)
  800c58:	e8 5b 1b 00 00       	call   8027b8 <cprintf>
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <check_write_block>:

// Test that write_block works, by smashing the superblock and reading it back.
void
check_write_block(void)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	53                   	push   %ebx
  800c63:	83 ec 14             	sub    $0x14,%esp
	super = 0;
  800c66:	c7 05 64 c0 80 00 00 	movl   $0x0,0x80c064
  800c6d:	00 00 00 

	// back up super block
	read_block(0, 0);
  800c70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c77:	00 
  800c78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c7f:	e8 ea f8 ff ff       	call   80056e <read_block>
	memmove(diskaddr(0), diskaddr(1), PGSIZE);
  800c84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800c8b:	e8 84 f7 ff ff       	call   800414 <diskaddr>
  800c90:	89 c3                	mov    %eax,%ebx
  800c92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c99:	e8 76 f7 ff ff       	call   800414 <diskaddr>
  800c9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800ca5:	00 
  800ca6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800caa:	89 04 24             	mov    %eax,(%esp)
  800cad:	e8 0a 26 00 00       	call   8032bc <memmove>

	// smash it 
	strcpy(diskaddr(1), "OOPS!\n");
  800cb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800cb9:	e8 56 f7 ff ff       	call   800414 <diskaddr>
  800cbe:	c7 44 24 04 ce 4e 80 	movl   $0x804ece,0x4(%esp)
  800cc5:	00 
  800cc6:	89 04 24             	mov    %eax,(%esp)
  800cc9:	e8 fc 23 00 00       	call   8030ca <strcpy>
	write_block(1);
  800cce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800cd5:	e8 8f f9 ff ff       	call   800669 <write_block>
	assert(block_is_mapped(1));
  800cda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800ce1:	e8 b3 f7 ff ff       	call   800499 <block_is_mapped>
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	75 24                	jne    800d0e <check_write_block+0xaf>
  800cea:	c7 44 24 0c d5 4e 80 	movl   $0x804ed5,0xc(%esp)
  800cf1:	00 
  800cf2:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800cf9:	00 
  800cfa:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  800d01:	00 
  800d02:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800d09:	e8 76 19 00 00       	call   802684 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800d0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800d15:	e8 fa f6 ff ff       	call   800414 <diskaddr>
  800d1a:	89 04 24             	mov    %eax,(%esp)
  800d1d:	e8 ae f7 ff ff       	call   8004d0 <va_is_dirty>
  800d22:	85 c0                	test   %eax,%eax
  800d24:	74 24                	je     800d4a <check_write_block+0xeb>
  800d26:	c7 44 24 0c e8 4e 80 	movl   $0x804ee8,0xc(%esp)
  800d2d:	00 
  800d2e:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800d35:	00 
  800d36:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  800d3d:	00 
  800d3e:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800d45:	e8 3a 19 00 00       	call   802684 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800d4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800d51:	e8 be f6 ff ff       	call   800414 <diskaddr>
  800d56:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d61:	e8 27 2a 00 00       	call   80378d <sys_page_unmap>
	assert(!block_is_mapped(1));
  800d66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800d6d:	e8 27 f7 ff ff       	call   800499 <block_is_mapped>
  800d72:	85 c0                	test   %eax,%eax
  800d74:	74 24                	je     800d9a <check_write_block+0x13b>
  800d76:	c7 44 24 0c 02 4f 80 	movl   $0x804f02,0xc(%esp)
  800d7d:	00 
  800d7e:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800d85:	00 
  800d86:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  800d8d:	00 
  800d8e:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800d95:	e8 ea 18 00 00       	call   802684 <_panic>

	// read it back in
	read_block(1, 0);
  800d9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800da1:	00 
  800da2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800da9:	e8 c0 f7 ff ff       	call   80056e <read_block>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800dae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800db5:	e8 5a f6 ff ff       	call   800414 <diskaddr>
  800dba:	c7 44 24 04 ce 4e 80 	movl   $0x804ece,0x4(%esp)
  800dc1:	00 
  800dc2:	89 04 24             	mov    %eax,(%esp)
  800dc5:	e8 c6 23 00 00       	call   803190 <strcmp>
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	74 24                	je     800df2 <check_write_block+0x193>
  800dce:	c7 44 24 0c 18 4f 80 	movl   $0x804f18,0xc(%esp)
  800dd5:	00 
  800dd6:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800ddd:	00 
  800dde:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  800de5:	00 
  800de6:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800ded:	e8 92 18 00 00       	call   802684 <_panic>

	// fix it
	memmove(diskaddr(1), diskaddr(0), PGSIZE);
  800df2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800df9:	e8 16 f6 ff ff       	call   800414 <diskaddr>
  800dfe:	89 c3                	mov    %eax,%ebx
  800e00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800e07:	e8 08 f6 ff ff       	call   800414 <diskaddr>
  800e0c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800e13:	00 
  800e14:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e18:	89 04 24             	mov    %eax,(%esp)
  800e1b:	e8 9c 24 00 00       	call   8032bc <memmove>
	write_block(1);
  800e20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800e27:	e8 3d f8 ff ff       	call   800669 <write_block>
	super = (struct Super*)diskaddr(1);
  800e2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800e33:	e8 dc f5 ff ff       	call   800414 <diskaddr>
  800e38:	a3 64 c0 80 00       	mov    %eax,0x80c064

	cprintf("write_block is good\n");
  800e3d:	c7 04 24 3c 4f 80 00 	movl   $0x804f3c,(%esp)
  800e44:	e8 6f 19 00 00       	call   8027b8 <cprintf>
}
  800e49:	83 c4 14             	add    $0x14,%esp
  800e4c:	5b                   	pop    %ebx
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <fs_init>:

// Initialize the file system
void
fs_init(void)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  800e55:	e8 30 f2 ff ff       	call   80008a <ide_probe_disk1>
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	74 0e                	je     800e6c <fs_init+0x1d>
		ide_set_disk(1);
  800e5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800e65:	e8 c5 f2 ff ff       	call   80012f <ide_set_disk>
  800e6a:	eb 0c                	jmp    800e78 <fs_init+0x29>
	else
		ide_set_disk(0);
  800e6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e73:	e8 b7 f2 ff ff       	call   80012f <ide_set_disk>
	
	read_super();
  800e78:	e8 b4 fb ff ff       	call   800a31 <read_super>
	check_write_block();
  800e7d:	e8 dd fd ff ff       	call   800c5f <check_write_block>
	read_bitmap();
  800e82:	e8 5a fc ff ff       	call   800ae1 <read_bitmap>
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <file_block_walk>:
//	-E_INVAL if filebno is out of range (it's >= NINDIRECT).
//
// Analogy: This is like pgdir_walk for files.  
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 28             	sub    $0x28,%esp
	int r;
	uint32_t *ptr;
	char *blk;

	if (filebno < NDIRECT)
  800e8f:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
  800e93:	77 19                	ja     800eae <file_block_walk+0x25>
		ptr = &f->f_direct[filebno];
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8d 90 88 00 00 00    	lea    0x88(%eax),%edx
  800e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea1:	c1 e0 02             	shl    $0x2,%eax
  800ea4:	01 d0                	add    %edx,%eax
  800ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ea9:	e9 de 00 00 00       	jmp    800f8c <file_block_walk+0x103>
	else if (filebno < NINDIRECT) {
  800eae:	81 7d 0c ff 03 00 00 	cmpl   $0x3ff,0xc(%ebp)
  800eb5:	0f 87 ca 00 00 00    	ja     800f85 <file_block_walk+0xfc>
		if (f->f_indirect == 0) {
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 34                	jne    800efc <file_block_walk+0x73>
			if (alloc == 0)
  800ec8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  800ecc:	75 0a                	jne    800ed8 <file_block_walk+0x4f>
				return -E_NOT_FOUND;
  800ece:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800ed3:	e9 c1 00 00 00       	jmp    800f99 <file_block_walk+0x110>
			if ((r = alloc_block()) < 0)
  800ed8:	e8 0c fb ff ff       	call   8009e9 <alloc_block>
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ee4:	79 08                	jns    800eee <file_block_walk+0x65>
				return r;
  800ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee9:	e9 ab 00 00 00       	jmp    800f99 <file_block_walk+0x110>
			f->f_indirect = r;
  800eee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  800efa:	eb 07                	jmp    800f03 <file_block_walk+0x7a>
		} else
			alloc = 0;	// we did not allocate a block
  800efc:	c7 45 14 00 00 00 00 	movl   $0x0,0x14(%ebp)
		if ((r = read_block(f->f_indirect, &blk)) < 0)
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  800f0c:	8d 55 ec             	lea    -0x14(%ebp),%edx
  800f0f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f13:	89 04 24             	mov    %eax,(%esp)
  800f16:	e8 53 f6 ff ff       	call   80056e <read_block>
  800f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f22:	79 05                	jns    800f29 <file_block_walk+0xa0>
			return r;
  800f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f27:	eb 70                	jmp    800f99 <file_block_walk+0x110>
		assert(blk != 0);
  800f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	75 24                	jne    800f54 <file_block_walk+0xcb>
  800f30:	c7 44 24 0c 51 4f 80 	movl   $0x804f51,0xc(%esp)
  800f37:	00 
  800f38:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  800f3f:	00 
  800f40:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
  800f47:	00 
  800f48:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  800f4f:	e8 30 17 00 00       	call   802684 <_panic>
		if (alloc)		// must clear any block we allocated
  800f54:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  800f58:	74 1b                	je     800f75 <file_block_walk+0xec>
			memset(blk, 0, BLKSIZE);
  800f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f5d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800f64:	00 
  800f65:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800f6c:	00 
  800f6d:	89 04 24             	mov    %eax,(%esp)
  800f70:	e8 16 23 00 00       	call   80328b <memset>
		ptr = (uint32_t*)blk + filebno;
  800f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f7b:	c1 e2 02             	shl    $0x2,%edx
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f83:	eb 07                	jmp    800f8c <file_block_walk+0x103>
	} else
		return -E_INVAL;
  800f85:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f8a:	eb 0d                	jmp    800f99 <file_block_walk+0x110>

	*ppdiskbno = ptr;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f92:	89 10                	mov    %edx,(%eax)
	return 0;
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <file_map_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_NO_MEM if we're out of memory.
//	-E_INVAL if filebno is out of range.
int
file_map_block(struct File *f, uint32_t filebno, uint32_t *diskbno, bool alloc)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 28             	sub    $0x28,%esp
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, alloc)) < 0)
  800fa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fa8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fab:	89 44 24 08          	mov    %eax,0x8(%esp)
  800faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	89 04 24             	mov    %eax,(%esp)
  800fbc:	e8 c8 fe ff ff       	call   800e89 <file_block_walk>
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fc8:	79 05                	jns    800fcf <file_map_block+0x34>
		return r;
  800fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fcd:	eb 40                	jmp    80100f <file_map_block+0x74>
	if (*ptr == 0) {
  800fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	75 28                	jne    801000 <file_map_block+0x65>
		if (alloc == 0)
  800fd8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  800fdc:	75 07                	jne    800fe5 <file_map_block+0x4a>
			return -E_NOT_FOUND;
  800fde:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800fe3:	eb 2a                	jmp    80100f <file_map_block+0x74>
		if ((r = alloc_block()) < 0)
  800fe5:	e8 ff f9 ff ff       	call   8009e9 <alloc_block>
  800fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ff1:	79 05                	jns    800ff8 <file_map_block+0x5d>
			return r;
  800ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff6:	eb 17                	jmp    80100f <file_map_block+0x74>
		*ptr = r;
  800ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffe:	89 10                	mov    %edx,(%eax)
	}
	*diskbno = *ptr;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801003:	8b 10                	mov    (%eax),%edx
  801005:	8b 45 10             	mov    0x10(%ebp),%eax
  801008:	89 10                	mov    %edx,(%eax)
	return 0;
  80100a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <file_clear_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
int
file_clear_block(struct File *f, uint32_t filebno)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 28             	sub    $0x28,%esp
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801017:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80101e:	00 
  80101f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801022:	89 44 24 08          	mov    %eax,0x8(%esp)
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	89 44 24 04          	mov    %eax,0x4(%esp)
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	89 04 24             	mov    %eax,(%esp)
  801033:	e8 51 fe ff ff       	call   800e89 <file_block_walk>
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80103f:	79 05                	jns    801046 <file_clear_block+0x35>
		return r;
  801041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801044:	eb 24                	jmp    80106a <file_clear_block+0x59>
	if (*ptr) {
  801046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801049:	8b 00                	mov    (%eax),%eax
  80104b:	85 c0                	test   %eax,%eax
  80104d:	74 16                	je     801065 <file_clear_block+0x54>
		free_block(*ptr);
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801052:	8b 00                	mov    (%eax),%eax
  801054:	89 04 24             	mov    %eax,(%esp)
  801057:	e8 33 f8 ff ff       	call   80088f <free_block>
		*ptr = 0;
  80105c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <file_get_block>:
// Set *blk to point at the filebno'th block in file 'f'.
// Allocate the block if it doesn't yet exist.
// Returns 0 on success, < 0 on error.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 28             	sub    $0x28,%esp

	// Read in the block, leaving the pointer in *blk.
	// Hint: Use file_map_block and read_block.
	// LAB 5: Your code here.
	//can alloc
	if((r = file_map_block(f, filebno, &diskbno, 1)) < 0) return r;
  801072:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801079:	00 
  80107a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80107d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	89 44 24 04          	mov    %eax,0x4(%esp)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 04 24             	mov    %eax,(%esp)
  80108e:	e8 08 ff ff ff       	call   800f9b <file_map_block>
  801093:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80109a:	79 05                	jns    8010a1 <file_get_block+0x35>
  80109c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109f:	eb 25                	jmp    8010c6 <file_get_block+0x5a>
	//if()  it has been alloced in the map_block when the alloc = 1;
	if((r = read_block(diskbno, blk)) < 0) return r;
  8010a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a4:	8b 55 10             	mov    0x10(%ebp),%edx
  8010a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010ab:	89 04 24             	mov    %eax,(%esp)
  8010ae:	e8 bb f4 ff ff       	call   80056e <read_block>
  8010b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8010ba:	79 05                	jns    8010c1 <file_get_block+0x55>
  8010bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bf:	eb 05                	jmp    8010c6 <file_get_block+0x5a>
	//panic("file_get_block not implemented");
	return 0;
  8010c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <file_dirty>:

// Mark the offset/BLKSIZE'th block dirty in file f
// by writing its first word to itself.  
int
file_dirty(struct File *f, off_t offset)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *blk;

	if ((r = file_get_block(f, offset/BLKSIZE, &blk)) < 0)
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	0f 48 c2             	cmovs  %edx,%eax
  8010dc:	c1 f8 0c             	sar    $0xc,%eax
  8010df:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8010e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 04 24             	mov    %eax,(%esp)
  8010f0:	e8 77 ff ff ff       	call   80106c <file_get_block>
  8010f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8010fc:	79 05                	jns    801103 <file_dirty+0x3b>
		return r;
  8010fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801101:	eb 10                	jmp    801113 <file_dirty+0x4b>
	*(volatile char*)blk = *(volatile char*)blk;
  801103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	0f b6 12             	movzbl (%edx),%edx
  80110c:	88 10                	mov    %dl,(%eax)
	return 0;
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <dir_lookup>:

// Try to find a file named "name" in dir.  If so, set *file to it.
int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 38             	sub    $0x38,%esp
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  801124:	25 ff 0f 00 00       	and    $0xfff,%eax
  801129:	85 c0                	test   %eax,%eax
  80112b:	74 24                	je     801151 <dir_lookup+0x3c>
  80112d:	c7 44 24 0c 5a 4f 80 	movl   $0x804f5a,0xc(%esp)
  801134:	00 
  801135:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  80113c:	00 
  80113d:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  801144:	00 
  801145:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  80114c:	e8 33 15 00 00       	call   802684 <_panic>
	nblock = dir->f_size / BLKSIZE;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  80115a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  801160:	85 c0                	test   %eax,%eax
  801162:	0f 48 c2             	cmovs  %edx,%eax
  801165:	c1 f8 0c             	sar    $0xc,%eax
  801168:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (i = 0; i < nblock; i++) {
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801172:	e9 89 00 00 00       	jmp    801200 <dir_lookup+0xeb>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801177:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80117a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80117e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801181:	89 44 24 04          	mov    %eax,0x4(%esp)
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	89 04 24             	mov    %eax,(%esp)
  80118b:	e8 dc fe ff ff       	call   80106c <file_get_block>
  801190:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801193:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801197:	79 05                	jns    80119e <dir_lookup+0x89>
			return r;
  801199:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80119c:	eb 73                	jmp    801211 <dir_lookup+0xfc>
		f = (struct File*) blk;
  80119e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (j = 0; j < BLKFILES; j++)
  8011a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011ab:	eb 49                	jmp    8011f6 <dir_lookup+0xe1>
			if (strcmp(f[j].f_name, name) == 0) {
  8011ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b0:	c1 e0 08             	shl    $0x8,%eax
  8011b3:	03 45 e4             	add    -0x1c(%ebp),%eax
  8011b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011bd:	89 04 24             	mov    %eax,(%esp)
  8011c0:	e8 cb 1f 00 00       	call   803190 <strcmp>
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	75 29                	jne    8011f2 <dir_lookup+0xdd>
				*file = &f[j];
  8011c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cc:	c1 e0 08             	shl    $0x8,%eax
  8011cf:	89 c2                	mov    %eax,%edx
  8011d1:	03 55 e4             	add    -0x1c(%ebp),%edx
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	89 10                	mov    %edx,(%eax)
				f[j].f_dir = dir;
  8011d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011dc:	c1 e0 08             	shl    $0x8,%eax
  8011df:	03 45 e4             	add    -0x1c(%ebp),%eax
  8011e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e5:	89 90 b4 00 00 00    	mov    %edx,0xb4(%eax)
				return 0;
  8011eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f0:	eb 1f                	jmp    801211 <dir_lookup+0xfc>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8011f2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8011f6:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
  8011fa:	76 b1                	jbe    8011ad <dir_lookup+0x98>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8011fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801203:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801206:	0f 82 6b ff ff ff    	jb     801177 <dir_lookup+0x62>
				*file = &f[j];
				f[j].f_dir = dir;
				return 0;
			}
	}
	return -E_NOT_FOUND;
  80120c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <dir_alloc_file>:

// Set *file to point at a free File structure in dir.
int
dir_alloc_file(struct File *dir, struct File **file)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 38             	sub    $0x38,%esp
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  801222:	25 ff 0f 00 00       	and    $0xfff,%eax
  801227:	85 c0                	test   %eax,%eax
  801229:	74 24                	je     80124f <dir_alloc_file+0x3c>
  80122b:	c7 44 24 0c 5a 4f 80 	movl   $0x804f5a,0xc(%esp)
  801232:	00 
  801233:	c7 44 24 08 8f 4d 80 	movl   $0x804d8f,0x8(%esp)
  80123a:	00 
  80123b:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
  801242:	00 
  801243:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  80124a:	e8 35 14 00 00       	call   802684 <_panic>
	nblock = dir->f_size / BLKSIZE;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  801258:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80125e:	85 c0                	test   %eax,%eax
  801260:	0f 48 c2             	cmovs  %edx,%eax
  801263:	c1 f8 0c             	sar    $0xc,%eax
  801266:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (i = 0; i < nblock; i++) {
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801270:	e9 80 00 00 00       	jmp    8012f5 <dir_alloc_file+0xe2>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801275:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801278:	89 44 24 08          	mov    %eax,0x8(%esp)
  80127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 04 24             	mov    %eax,(%esp)
  801289:	e8 de fd ff ff       	call   80106c <file_get_block>
  80128e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801291:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801295:	79 08                	jns    80129f <dir_alloc_file+0x8c>
			return r;
  801297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80129a:	e9 c0 00 00 00       	jmp    80135f <dir_alloc_file+0x14c>
		f = (struct File*) blk;
  80129f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (j = 0; j < BLKFILES; j++)
  8012a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012ac:	eb 3d                	jmp    8012eb <dir_alloc_file+0xd8>
			if (f[j].f_name[0] == '\0') {
  8012ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b1:	c1 e0 08             	shl    $0x8,%eax
  8012b4:	03 45 e4             	add    -0x1c(%ebp),%eax
  8012b7:	0f b6 00             	movzbl (%eax),%eax
  8012ba:	84 c0                	test   %al,%al
  8012bc:	75 29                	jne    8012e7 <dir_alloc_file+0xd4>
				*file = &f[j];
  8012be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c1:	c1 e0 08             	shl    $0x8,%eax
  8012c4:	89 c2                	mov    %eax,%edx
  8012c6:	03 55 e4             	add    -0x1c(%ebp),%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	89 10                	mov    %edx,(%eax)
				f[j].f_dir = dir;
  8012ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d1:	c1 e0 08             	shl    $0x8,%eax
  8012d4:	03 45 e4             	add    -0x1c(%ebp),%eax
  8012d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012da:	89 90 b4 00 00 00    	mov    %edx,0xb4(%eax)
				return 0;
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e5:	eb 78                	jmp    80135f <dir_alloc_file+0x14c>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8012e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8012eb:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
  8012ef:	76 bd                	jbe    8012ae <dir_alloc_file+0x9b>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8012f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8012f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8012fb:	0f 82 74 ff ff ff    	jb     801275 <dir_alloc_file+0x62>
				*file = &f[j];
				f[j].f_dir = dir;
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  80130a:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801319:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80131c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801323:	89 44 24 04          	mov    %eax,0x4(%esp)
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	89 04 24             	mov    %eax,(%esp)
  80132d:	e8 3a fd ff ff       	call   80106c <file_get_block>
  801332:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801335:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801339:	79 05                	jns    801340 <dir_alloc_file+0x12d>
		return r;
  80133b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80133e:	eb 1f                	jmp    80135f <dir_alloc_file+0x14c>
	f = (struct File*) blk;
  801340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*file = &f[0];
  801346:	8b 45 0c             	mov    0xc(%ebp),%eax
  801349:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80134c:	89 10                	mov    %edx,(%eax)
	f[0].f_dir = dir;
  80134e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801351:	8b 55 08             	mov    0x8(%ebp),%edx
  801354:	89 90 b4 00 00 00    	mov    %edx,0xb4(%eax)
	return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <skip_slash>:

// Skip over slashes.
static inline const char*
skip_slash(const char *p)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	while (*p == '/')
  801364:	eb 04                	jmp    80136a <skip_slash+0x9>
		p++;
  801366:	83 45 08 01          	addl   $0x1,0x8(%ebp)

// Skip over slashes.
static inline const char*
skip_slash(const char *p)
{
	while (*p == '/')
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	0f b6 00             	movzbl (%eax),%eax
  801370:	3c 2f                	cmp    $0x2f,%al
  801372:	74 f2                	je     801366 <skip_slash+0x5>
		p++;
	return p;
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801377:	5d                   	pop    %ebp
  801378:	c3                   	ret    

00801379 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	81 ec a8 00 00 00    	sub    $0xa8,%esp
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	89 04 24             	mov    %eax,(%esp)
  801388:	e8 d4 ff ff ff       	call   801361 <skip_slash>
  80138d:	89 45 08             	mov    %eax,0x8(%ebp)
	f = &super->s_root;
  801390:	a1 64 c0 80 00       	mov    0x80c064,%eax
  801395:	83 c0 08             	add    $0x8,%eax
  801398:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	dir = 0;
  80139e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	name[0] = 0;
  8013a5:	c6 85 6c ff ff ff 00 	movb   $0x0,-0x94(%ebp)

	if (pdir)
  8013ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013b0:	74 09                	je     8013bb <walk_path+0x42>
		*pdir = 0;
  8013b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pf = 0;
  8013bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (*path != '\0') {
  8013c4:	e9 12 01 00 00       	jmp    8014db <walk_path+0x162>
		dir = f;
  8013c9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8013cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = path;
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (*path != '/' && *path != '\0')
  8013d8:	eb 04                	jmp    8013de <walk_path+0x65>
			path++;
  8013da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	0f b6 00             	movzbl (%eax),%eax
  8013e4:	3c 2f                	cmp    $0x2f,%al
  8013e6:	74 0a                	je     8013f2 <walk_path+0x79>
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	0f b6 00             	movzbl (%eax),%eax
  8013ee:	84 c0                	test   %al,%al
  8013f0:	75 e8                	jne    8013da <walk_path+0x61>
			path++;
		if (path - p >= MAXNAMELEN)
  8013f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f8:	89 d1                	mov    %edx,%ecx
  8013fa:	29 c1                	sub    %eax,%ecx
  8013fc:	89 c8                	mov    %ecx,%eax
  8013fe:	83 f8 7f             	cmp    $0x7f,%eax
  801401:	7e 0a                	jle    80140d <walk_path+0x94>
			return -E_BAD_PATH;
  801403:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801408:	e9 fa 00 00 00       	jmp    801507 <walk_path+0x18e>
		memmove(name, p, path - p);
  80140d:	8b 55 08             	mov    0x8(%ebp),%edx
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	89 d1                	mov    %edx,%ecx
  801415:	29 c1                	sub    %eax,%ecx
  801417:	89 c8                	mov    %ecx,%eax
  801419:	89 44 24 08          	mov    %eax,0x8(%esp)
  80141d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801420:	89 44 24 04          	mov    %eax,0x4(%esp)
  801424:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  80142a:	89 04 24             	mov    %eax,(%esp)
  80142d:	e8 8a 1e 00 00       	call   8032bc <memmove>
		name[path - p] = '\0';
  801432:	8b 55 08             	mov    0x8(%ebp),%edx
  801435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801438:	89 d1                	mov    %edx,%ecx
  80143a:	29 c1                	sub    %eax,%ecx
  80143c:	89 c8                	mov    %ecx,%eax
  80143e:	c6 84 05 6c ff ff ff 	movb   $0x0,-0x94(%ebp,%eax,1)
  801445:	00 
		path = skip_slash(path);
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	89 04 24             	mov    %eax,(%esp)
  80144c:	e8 10 ff ff ff       	call   801361 <skip_slash>
  801451:	89 45 08             	mov    %eax,0x8(%ebp)

		if (dir->f_type != FTYPE_DIR)
  801454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801457:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80145d:	83 f8 01             	cmp    $0x1,%eax
  801460:	74 0a                	je     80146c <walk_path+0xf3>
			return -E_NOT_FOUND;
  801462:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  801467:	e9 9b 00 00 00       	jmp    801507 <walk_path+0x18e>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  80146c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801472:	89 44 24 08          	mov    %eax,0x8(%esp)
  801476:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  80147c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	89 04 24             	mov    %eax,(%esp)
  801486:	e8 8a fc ff ff       	call   801115 <dir_lookup>
  80148b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80148e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801492:	79 47                	jns    8014db <walk_path+0x162>
			if (r == -E_NOT_FOUND && *path == '\0') {
  801494:	83 7d ec f5          	cmpl   $0xfffffff5,-0x14(%ebp)
  801498:	75 3c                	jne    8014d6 <walk_path+0x15d>
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	0f b6 00             	movzbl (%eax),%eax
  8014a0:	84 c0                	test   %al,%al
  8014a2:	75 32                	jne    8014d6 <walk_path+0x15d>
				if (pdir)
  8014a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a8:	74 08                	je     8014b2 <walk_path+0x139>
					*pdir = dir;
  8014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b0:	89 10                	mov    %edx,(%eax)
				if (lastelem)
  8014b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8014b6:	74 15                	je     8014cd <walk_path+0x154>
					strcpy(lastelem, name);
  8014b8:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8014be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c5:	89 04 24             	mov    %eax,(%esp)
  8014c8:	e8 fd 1b 00 00       	call   8030ca <strcpy>
				*pf = 0;
  8014cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  8014d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d9:	eb 2c                	jmp    801507 <walk_path+0x18e>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	0f b6 00             	movzbl (%eax),%eax
  8014e1:	84 c0                	test   %al,%al
  8014e3:	0f 85 e0 fe ff ff    	jne    8013c9 <walk_path+0x50>
			}
			return r;
		}
	}

	if (pdir)
  8014e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014ed:	74 08                	je     8014f7 <walk_path+0x17e>
		*pdir = dir;
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	89 10                	mov    %edx,(%eax)
	*pf = f;
  8014f7:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
  8014fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801500:	89 10                	mov    %edx,(%eax)
	return 0;
  801502:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	81 ec a8 00 00 00    	sub    $0xa8,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801512:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
  801518:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80151c:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  801522:	89 44 24 08          	mov    %eax,0x8(%esp)
  801526:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  80152c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	89 04 24             	mov    %eax,(%esp)
  801536:	e8 3e fe ff ff       	call   801379 <walk_path>
  80153b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80153e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801542:	75 07                	jne    80154b <file_create+0x42>
		return -E_FILE_EXISTS;
  801544:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801549:	eb 5e                	jmp    8015a9 <file_create+0xa0>
	if (r != -E_NOT_FOUND || dir == 0)
  80154b:	83 7d f4 f5          	cmpl   $0xfffffff5,-0xc(%ebp)
  80154f:	75 0a                	jne    80155b <file_create+0x52>
  801551:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801557:	85 c0                	test   %eax,%eax
  801559:	75 05                	jne    801560 <file_create+0x57>
		return r;
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	eb 49                	jmp    8015a9 <file_create+0xa0>
	if (dir_alloc_file(dir, &f) < 0)
  801560:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801566:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  80156c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801570:	89 04 24             	mov    %eax,(%esp)
  801573:	e8 9b fc ff ff       	call   801213 <dir_alloc_file>
  801578:	85 c0                	test   %eax,%eax
  80157a:	79 05                	jns    801581 <file_create+0x78>
		return r;
  80157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157f:	eb 28                	jmp    8015a9 <file_create+0xa0>
	strcpy(f->f_name, name);
  801581:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801587:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
  80158d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801591:	89 04 24             	mov    %eax,(%esp)
  801594:	e8 31 1b 00 00       	call   8030ca <strcpy>
	*pf = f;
  801599:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  80159f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a2:	89 10                	mov    %edx,(%eax)
	return 0;
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	81 ec a8 00 00 00    	sub    $0xa8,%esp
	// Hint: Use walk_path.
	// LAB 5: Your code here.
	int r;
	struct File *dir;
	char lastelem[MAXNAMELEN];
	if((r = walk_path(path, &dir, pf, lastelem)) < 0) return r;
  8015b4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8015ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	89 04 24             	mov    %eax,(%esp)
  8015d2:	e8 a2 fd ff ff       	call   801379 <walk_path>
  8015d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015de:	79 05                	jns    8015e5 <file_open+0x3a>
  8015e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e3:	eb 05                	jmp    8015ea <file_open+0x3f>
	//panic("file_open not implemented");
	return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 38             	sub    $0x38,%esp
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	// Hint: Use file_clear_block and/or free_block.
	// LAB 5: Your code here.
	old_nblocks = ROUNDUP(f->f_size, BLKSIZE) / BLKSIZE;
  8015f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  801602:	03 45 f0             	add    -0x10(%ebp),%eax
  801605:	83 e8 01             	sub    $0x1,%eax
  801608:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80160b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160e:	ba 00 00 00 00       	mov    $0x0,%edx
  801613:	f7 75 f0             	divl   -0x10(%ebp)
  801616:	89 d0                	mov    %edx,%eax
  801618:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80161b:	89 d1                	mov    %edx,%ecx
  80161d:	29 c1                	sub    %eax,%ecx
  80161f:	89 c8                	mov    %ecx,%eax
  801621:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  801627:	85 c0                	test   %eax,%eax
  801629:	0f 48 c2             	cmovs  %edx,%eax
  80162c:	c1 f8 0c             	sar    $0xc,%eax
  80162f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	new_nblocks = ROUNDUP(newsize, BLKSIZE) / BLKSIZE;
  801632:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	03 45 e4             	add    -0x1c(%ebp),%eax
  80163f:	83 e8 01             	sub    $0x1,%eax
  801642:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801648:	ba 00 00 00 00       	mov    $0x0,%edx
  80164d:	f7 75 e4             	divl   -0x1c(%ebp)
  801650:	89 d0                	mov    %edx,%eax
  801652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801655:	89 d1                	mov    %edx,%ecx
  801657:	29 c1                	sub    %eax,%ecx
  801659:	89 c8                	mov    %ecx,%eax
  80165b:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  801661:	85 c0                	test   %eax,%eax
  801663:	0f 48 c2             	cmovs  %edx,%eax
  801666:	c1 f8 0c             	sar    $0xc,%eax
  801669:	89 45 dc             	mov    %eax,-0x24(%ebp)
	for(bno = new_nblocks; bno < old_nblocks; bno++) 
  80166c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80166f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801672:	eb 16                	jmp    80168a <file_truncate_blocks+0x9e>
	    file_clear_block(f, bno);
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	89 04 24             	mov    %eax,(%esp)
  801681:	e8 8b f9 ff ff       	call   801011 <file_clear_block>

	// Hint: Use file_clear_block and/or free_block.
	// LAB 5: Your code here.
	old_nblocks = ROUNDUP(f->f_size, BLKSIZE) / BLKSIZE;
	new_nblocks = ROUNDUP(newsize, BLKSIZE) / BLKSIZE;
	for(bno = new_nblocks; bno < old_nblocks; bno++) 
  801686:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  80168a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801690:	72 e2                	jb     801674 <file_truncate_blocks+0x88>
	    file_clear_block(f, bno);
	if(f->f_indirect!=0 && new_nblocks <= NDIRECT){
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  80169b:	85 c0                	test   %eax,%eax
  80169d:	74 24                	je     8016c3 <file_truncate_blocks+0xd7>
  80169f:	83 7d dc 0a          	cmpl   $0xa,-0x24(%ebp)
  8016a3:	77 1e                	ja     8016c3 <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  8016ae:	89 04 24             	mov    %eax,(%esp)
  8016b1:	e8 d9 f1 ff ff       	call   80088f <free_block>
		f->f_indirect = 0;
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  8016c0:	00 00 00 
	}
	// panic("file_truncate_blocks not implemented");
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <file_set_size>:

int
file_set_size(struct File *f, off_t newsize)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 18             	sub    $0x18,%esp
	if (f->f_size > newsize)
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  8016d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8016d7:	7e 12                	jle    8016eb <file_set_size+0x26>
		file_truncate_blocks(f, newsize);
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	89 04 24             	mov    %eax,(%esp)
  8016e6:	e8 01 ff ff ff       	call   8015ec <file_truncate_blocks>
	f->f_size = newsize;
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	if (f->f_dir)
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
  801700:	85 c0                	test   %eax,%eax
  801702:	74 11                	je     801715 <file_set_size+0x50>
		file_flush(f->f_dir);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
  80170d:	89 04 24             	mov    %eax,(%esp)
  801710:	e8 07 00 00 00       	call   80171c <file_flush>
	return 0;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <file_flush>:
// and then check whether that disk block is dirty.  If so, write it out.
//
// Hint: use file_map_block, block_is_dirty, and write_block.
void
file_flush(struct File *f)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 38             	sub    $0x38,%esp
	// LAB 5: Your code here.
	int blkno = ROUNDUP(f->f_size, BLKSIZE) / BLKSIZE;
  801722:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  801732:	03 45 f0             	add    -0x10(%ebp),%eax
  801735:	83 e8 01             	sub    $0x1,%eax
  801738:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80173b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
  801743:	f7 75 f0             	divl   -0x10(%ebp)
  801746:	89 d0                	mov    %edx,%eax
  801748:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80174b:	89 d1                	mov    %edx,%ecx
  80174d:	29 c1                	sub    %eax,%ecx
  80174f:	89 c8                	mov    %ecx,%eax
  801751:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  801757:	85 c0                	test   %eax,%eax
  801759:	0f 48 c2             	cmovs  %edx,%eax
  80175c:	c1 f8 0c             	sar    $0xc,%eax
  80175f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int i,disk_blk_no;
	for(i=0;i<blkno;i++){
  801762:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801769:	eb 5f                	jmp    8017ca <file_flush+0xae>
		if(file_map_block(f, i, (unsigned int *)(&disk_blk_no), 0) < 0){
  80176b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801775:	00 
  801776:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801779:	89 54 24 08          	mov    %edx,0x8(%esp)
  80177d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	89 04 24             	mov    %eax,(%esp)
  801787:	e8 0f f8 ff ff       	call   800f9b <file_map_block>
  80178c:	85 c0                	test   %eax,%eax
  80178e:	79 1c                	jns    8017ac <file_flush+0x90>
			panic("map block failed\n");}
  801790:	c7 44 24 08 77 4f 80 	movl   $0x804f77,0x8(%esp)
  801797:	00 
  801798:	c7 44 24 04 8b 02 00 	movl   $0x28b,0x4(%esp)
  80179f:	00 
  8017a0:	c7 04 24 d6 4c 80 00 	movl   $0x804cd6,(%esp)
  8017a7:	e8 d8 0e 00 00       	call   802684 <_panic>
		if(block_is_dirty(disk_blk_no) != 0){
  8017ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017af:	89 04 24             	mov    %eax,(%esp)
  8017b2:	e8 36 ed ff ff       	call   8004ed <block_is_dirty>
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	74 0b                	je     8017c6 <file_flush+0xaa>
			write_block(disk_blk_no);}
  8017bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017be:	89 04 24             	mov    %eax,(%esp)
  8017c1:	e8 a3 ee ff ff       	call   800669 <write_block>
file_flush(struct File *f)
{
	// LAB 5: Your code here.
	int blkno = ROUNDUP(f->f_size, BLKSIZE) / BLKSIZE;
	int i,disk_blk_no;
	for(i=0;i<blkno;i++){
  8017c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017d0:	7c 99                	jl     80176b <file_flush+0x4f>
			panic("map block failed\n");}
		if(block_is_dirty(disk_blk_no) != 0){
			write_block(disk_blk_no);}
	}
	//panic("file_flush not implemented");
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < super->s_nblocks; i++)
  8017da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017e1:	eb 1e                	jmp    801801 <fs_sync+0x2d>
		if (block_is_dirty(i))
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	89 04 24             	mov    %eax,(%esp)
  8017e9:	e8 ff ec ff ff       	call   8004ed <block_is_dirty>
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	74 0b                	je     8017fd <fs_sync+0x29>
			write_block(i);
  8017f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f5:	89 04 24             	mov    %eax,(%esp)
  8017f8:	e8 6c ee ff ff       	call   800669 <write_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 0; i < super->s_nblocks; i++)
  8017fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801804:	a1 64 c0 80 00       	mov    0x80c064,%eax
  801809:	8b 40 04             	mov    0x4(%eax),%eax
  80180c:	39 c2                	cmp    %eax,%edx
  80180e:	72 d3                	jb     8017e3 <fs_sync+0xf>
		if (block_is_dirty(i))
			write_block(i);
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <file_close>:

// Close a file.
void
file_close(struct File *f)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 18             	sub    $0x18,%esp
	file_flush(f);
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	89 04 24             	mov    %eax,(%esp)
  80181e:	e8 f9 fe ff ff       	call   80171c <file_flush>
	if (f->f_dir)
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
  80182c:	85 c0                	test   %eax,%eax
  80182e:	74 11                	je     801841 <file_close+0x2f>
		file_flush(f->f_dir);
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
  801839:	89 04 24             	mov    %eax,(%esp)
  80183c:	e8 db fe ff ff       	call   80171c <file_flush>
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801849:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801850:	00 
  801851:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801854:	89 44 24 08          	mov    %eax,0x8(%esp)
  801858:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80185f:	00 
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	89 04 24             	mov    %eax,(%esp)
  801866:	e8 0e fb ff ff       	call   801379 <walk_path>
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80186e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801872:	79 05                	jns    801879 <file_remove+0x36>
		return r;
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	eb 49                	jmp    8018c2 <file_remove+0x7f>

	file_truncate_blocks(f, 0);
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801883:	00 
  801884:	89 04 24             	mov    %eax,(%esp)
  801887:	e8 60 fd ff ff       	call   8015ec <file_truncate_blocks>
	f->f_name[0] = '\0';
  80188c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188f:	c6 00 00             	movb   $0x0,(%eax)
	f->f_size = 0;
  801892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801895:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  80189c:	00 00 00 
	if (f->f_dir)
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	74 11                	je     8018bd <file_remove+0x7a>
		file_flush(f->f_dir);
  8018ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018af:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
  8018b5:	89 04 24             	mov    %eax,(%esp)
  8018b8:	e8 5f fe ff ff       	call   80171c <file_flush>

	return 0;
  8018bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
#define REQVA		0x0ffff000

void
serve_init(void)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 10             	sub    $0x10,%esp
	int i;
	uintptr_t va = FILEVA;
  8018ca:	c7 45 f8 00 00 00 d0 	movl   $0xd0000000,-0x8(%ebp)
	for (i = 0; i < MAXOPEN; i++) {
  8018d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018d8:	eb 2e                	jmp    801908 <serve_init+0x44>
		opentab[i].o_fileid = i;
  8018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e0:	c1 e2 04             	shl    $0x4,%edx
  8018e3:	81 c2 20 80 80 00    	add    $0x808020,%edx
  8018e9:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f1:	c1 e2 04             	shl    $0x4,%edx
  8018f4:	81 c2 20 80 80 00    	add    $0x808020,%edx
  8018fa:	89 42 0c             	mov    %eax,0xc(%edx)
		va += PGSIZE;
  8018fd:	81 45 f8 00 10 00 00 	addl   $0x1000,-0x8(%ebp)
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  801904:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801908:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
  80190f:	7e c9                	jle    8018da <serve_init+0x16>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 28             	sub    $0x28,%esp
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801919:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801920:	e9 bc 00 00 00       	jmp    8019e1 <openfile_alloc+0xce>
		switch (pageref(opentab[i].o_fd)) {
  801925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801928:	c1 e0 04             	shl    $0x4,%eax
  80192b:	05 20 80 80 00       	add    $0x808020,%eax
  801930:	8b 40 0c             	mov    0xc(%eax),%eax
  801933:	89 04 24             	mov    %eax,(%esp)
  801936:	e8 0d 30 00 00       	call   804948 <pageref>
  80193b:	85 c0                	test   %eax,%eax
  80193d:	74 0a                	je     801949 <openfile_alloc+0x36>
  80193f:	83 f8 01             	cmp    $0x1,%eax
  801942:	74 39                	je     80197d <openfile_alloc+0x6a>
  801944:	e9 94 00 00 00       	jmp    8019dd <openfile_alloc+0xca>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194c:	c1 e0 04             	shl    $0x4,%eax
  80194f:	05 20 80 80 00       	add    $0x808020,%eax
  801954:	8b 40 0c             	mov    0xc(%eax),%eax
  801957:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80195e:	00 
  80195f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801963:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80196a:	e8 97 1d 00 00       	call   803706 <sys_page_alloc>
  80196f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801972:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801976:	79 05                	jns    80197d <openfile_alloc+0x6a>
				return r;
  801978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197b:	eb 76                	jmp    8019f3 <openfile_alloc+0xe0>
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	c1 e0 04             	shl    $0x4,%eax
  801983:	05 20 80 80 00       	add    $0x808020,%eax
  801988:	8b 00                	mov    (%eax),%eax
  80198a:	8d 90 00 04 00 00    	lea    0x400(%eax),%edx
  801990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801993:	c1 e0 04             	shl    $0x4,%eax
  801996:	05 20 80 80 00       	add    $0x808020,%eax
  80199b:	89 10                	mov    %edx,(%eax)
			*o = &opentab[i];
  80199d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a0:	c1 e0 04             	shl    $0x4,%eax
  8019a3:	8d 90 20 80 80 00    	lea    0x808020(%eax),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	89 10                	mov    %edx,(%eax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8019ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b1:	c1 e0 04             	shl    $0x4,%eax
  8019b4:	05 20 80 80 00       	add    $0x808020,%eax
  8019b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019bc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8019c3:	00 
  8019c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019cb:	00 
  8019cc:	89 04 24             	mov    %eax,(%esp)
  8019cf:	e8 b7 18 00 00       	call   80328b <memset>
			return (*o)->o_fileid;
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8b 00                	mov    (%eax),%eax
  8019d9:	8b 00                	mov    (%eax),%eax
  8019db:	eb 16                	jmp    8019f3 <openfile_alloc+0xe0>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8019dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8019e1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  8019e8:	0f 8e 37 ff ff ff    	jle    801925 <openfile_alloc+0x12>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  8019ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8019fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fe:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a03:	c1 e0 04             	shl    $0x4,%eax
  801a06:	05 20 80 80 00       	add    $0x808020,%eax
  801a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  801a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a11:	8b 40 0c             	mov    0xc(%eax),%eax
  801a14:	89 04 24             	mov    %eax,(%esp)
  801a17:	e8 2c 2f 00 00       	call   804948 <pageref>
  801a1c:	83 f8 01             	cmp    $0x1,%eax
  801a1f:	74 0a                	je     801a2b <openfile_lookup+0x36>
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	8b 00                	mov    (%eax),%eax
  801a26:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a29:	74 07                	je     801a32 <openfile_lookup+0x3d>
		return -E_INVAL;
  801a2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a30:	eb 0d                	jmp    801a3f <openfile_lookup+0x4a>
	*po = o;
  801a32:	8b 45 10             	mov    0x10(%ebp),%eax
  801a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a38:	89 10                	mov    %edx,(%eax)
	return 0;
  801a3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <serve_open>:
// Serve requests, sending responses back to envid.
// To send a result back, ipc_send(envid, r, 0, 0).
// To include a page, ipc_send(envid, r, srcva, perm).
void
serve_open(envid_t envid, struct Fsreq_open *rq)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	57                   	push   %edi
  801a45:	56                   	push   %esi
  801a46:	53                   	push   %ebx
  801a47:	81 ec 2c 04 00 00    	sub    $0x42c,%esp

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, rq->req_path, rq->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, rq->req_path, MAXPATHLEN);
  801a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a50:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  801a57:	00 
  801a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5c:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
  801a62:	89 04 24             	mov    %eax,(%esp)
  801a65:	e8 52 18 00 00       	call   8032bc <memmove>
	path[MAXPATHLEN-1] = 0;
  801a6a:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  801a6e:	8d 85 d8 fb ff ff    	lea    -0x428(%ebp),%eax
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	e8 97 fe ff ff       	call   801913 <openfile_alloc>
  801a7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a83:	0f 88 d1 00 00 00    	js     801b5a <serve_open+0x119>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		goto out;
	}
	fileid = r;
  801a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a8c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// Open the file
	if ((r = file_open(path, &f)) < 0) {
  801a8f:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
  801a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a99:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
  801a9f:	89 04 24             	mov    %eax,(%esp)
  801aa2:	e8 04 fb ff ff       	call   8015ab <file_open>
  801aa7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aaa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aae:	0f 88 a9 00 00 00    	js     801b5d <serve_open+0x11c>
			cprintf("file_open failed: %e", r);
		goto out;
	}

	// Save the file pointer
	o->o_file = f;
  801ab4:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
  801aba:	8b 95 dc fb ff ff    	mov    -0x424(%ebp),%edx
  801ac0:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.file = *f;
  801ac3:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
  801ac9:	8b 50 0c             	mov    0xc(%eax),%edx
  801acc:	8b 85 dc fb ff ff    	mov    -0x424(%ebp),%eax
  801ad2:	8d 5a 10             	lea    0x10(%edx),%ebx
  801ad5:	89 c2                	mov    %eax,%edx
  801ad7:	b8 40 00 00 00       	mov    $0x40,%eax
  801adc:	89 df                	mov    %ebx,%edi
  801ade:	89 d6                	mov    %edx,%esi
  801ae0:	89 c1                	mov    %eax,%ecx
  801ae2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	o->o_fd->fd_file.id = o->o_fileid;
  801ae4:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
  801aea:	8b 40 0c             	mov    0xc(%eax),%eax
  801aed:	8b 95 d8 fb ff ff    	mov    -0x428(%ebp),%edx
  801af3:	8b 12                	mov    (%edx),%edx
  801af5:	89 50 0c             	mov    %edx,0xc(%eax)
	o->o_fd->fd_omode = rq->req_omode;
  801af8:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
  801afe:	8b 40 0c             	mov    0xc(%eax),%eax
  801b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b04:	8b 92 00 04 00 00    	mov    0x400(%edx),%edx
  801b0a:	89 50 08             	mov    %edx,0x8(%eax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801b0d:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
  801b13:	8b 40 0c             	mov    0xc(%eax),%eax
  801b16:	8b 15 40 c0 80 00    	mov    0x80c040,%edx
  801b1c:	89 10                	mov    %edx,(%eax)
	o->o_mode = rq->req_omode;
  801b1e:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 92 00 04 00 00    	mov    0x400(%edx),%edx
  801b2d:	89 50 08             	mov    %edx,0x8(%eax)

	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);
	ipc_send(envid, 0, o->o_fd, PTE_P|PTE_U|PTE_W|PTE_SHARE);
  801b30:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
  801b36:	8b 40 0c             	mov    0xc(%eax),%eax
  801b39:	c7 44 24 0c 07 04 00 	movl   $0x407,0xc(%esp)
  801b40:	00 
  801b41:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b4c:	00 
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	89 04 24             	mov    %eax,(%esp)
  801b53:	e8 90 1e 00 00       	call   8039e8 <ipc_send>
	return;
  801b58:	eb 26                	jmp    801b80 <serve_open+0x13f>

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		goto out;
  801b5a:	90                   	nop
  801b5b:	eb 01                	jmp    801b5e <serve_open+0x11d>

	// Open the file
	if ((r = file_open(path, &f)) < 0) {
		if (debug)
			cprintf("file_open failed: %e", r);
		goto out;
  801b5d:	90                   	nop
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);
	ipc_send(envid, 0, o->o_fd, PTE_P|PTE_U|PTE_W|PTE_SHARE);
	return;
out:
	ipc_send(envid, r, 0, 0);
  801b5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b61:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b68:	00 
  801b69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b70:	00 
  801b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	89 04 24             	mov    %eax,(%esp)
  801b7b:	e8 68 1e 00 00       	call   8039e8 <ipc_send>
}
  801b80:	81 c4 2c 04 00 00    	add    $0x42c,%esp
  801b86:	5b                   	pop    %ebx
  801b87:	5e                   	pop    %esi
  801b88:	5f                   	pop    %edi
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    

00801b8b <serve_set_size>:

void
serve_set_size(envid_t envid, struct Fsreq_set_size *rq)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	83 ec 28             	sub    $0x28,%esp
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0)
  801b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b94:	8b 00                	mov    (%eax),%eax
  801b96:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b99:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	89 04 24             	mov    %eax,(%esp)
  801ba7:	e8 49 fe ff ff       	call   8019f5 <openfile_lookup>
  801bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb3:	78 35                	js     801bea <serve_set_size+0x5f>
		goto out;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	if ((r = file_set_size(o->o_file, rq->req_size)) < 0)
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	8b 50 04             	mov    0x4(%eax),%edx
  801bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbe:	8b 40 04             	mov    0x4(%eax),%eax
  801bc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bc5:	89 04 24             	mov    %eax,(%esp)
  801bc8:	e8 f8 fa ff ff       	call   8016c5 <file_set_size>
  801bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bd4:	78 17                	js     801bed <serve_set_size+0x62>
		goto out;

	// Third, update the 'struct Fd' copy of the 'struct File'
	// as appropriate.
	o->o_fd->fd_file.file.f_size = rq->req_size;
  801bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdf:	8b 52 04             	mov    0x4(%edx),%edx
  801be2:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  801be8:	eb 04                	jmp    801bee <serve_set_size+0x63>
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0)
		goto out;
  801bea:	90                   	nop
  801beb:	eb 01                	jmp    801bee <serve_set_size+0x63>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	if ((r = file_set_size(o->o_file, rq->req_size)) < 0)
		goto out;
  801bed:	90                   	nop
	o->o_fd->fd_file.file.f_size = rq->req_size;

	// Finally, return to the client!
	// (We just return r since we know it's 0 at this point.)
out:
	ipc_send(envid, r, 0, 0);
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801bf8:	00 
  801bf9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c00:	00 
  801c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	89 04 24             	mov    %eax,(%esp)
  801c0b:	e8 d8 1d 00 00       	call   8039e8 <ipc_send>
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <serve_map>:

void
serve_map(envid_t envid, struct Fsreq_map *rq)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 38             	sub    $0x38,%esp
	// by using ipc_send.
	// Map read-only unless the file's open mode (o->o_mode) allows writes
	// (see the O_ flags in inc/lib.h).
	
	// LAB 5: Your code here.
	if((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0){
  801c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1b:	8b 00                	mov    (%eax),%eax
  801c1d:	8d 55 e0             	lea    -0x20(%ebp),%edx
  801c20:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	89 04 24             	mov    %eax,(%esp)
  801c2e:	e8 c2 fd ff ff       	call   8019f5 <openfile_lookup>
  801c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c3a:	79 27                	jns    801c63 <serve_map+0x51>
		ipc_send(envid, r, 0, 0); return;}
  801c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c46:	00 
  801c47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c4e:	00 
  801c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	89 04 24             	mov    %eax,(%esp)
  801c59:	e8 8a 1d 00 00       	call   8039e8 <ipc_send>
  801c5e:	e9 c1 00 00 00       	jmp    801d24 <serve_map+0x112>
	if((r = file_get_block(o->o_file, ROUNDUP(rq->req_offset, BLKSIZE)/BLKSIZE, &blk)) < 0){
  801c63:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6d:	8b 40 04             	mov    0x4(%eax),%eax
  801c70:	03 45 ec             	add    -0x14(%ebp),%eax
  801c73:	83 e8 01             	sub    $0x1,%eax
  801c76:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c81:	f7 75 ec             	divl   -0x14(%ebp)
  801c84:	89 d0                	mov    %edx,%eax
  801c86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c89:	89 d1                	mov    %edx,%ecx
  801c8b:	29 c1                	sub    %eax,%ecx
  801c8d:	89 c8                	mov    %ecx,%eax
  801c8f:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  801c95:	85 c0                	test   %eax,%eax
  801c97:	0f 48 c2             	cmovs  %edx,%eax
  801c9a:	c1 f8 0c             	sar    $0xc,%eax
  801c9d:	89 c2                	mov    %eax,%edx
  801c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca2:	8b 40 04             	mov    0x4(%eax),%eax
  801ca5:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  801ca8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cac:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cb0:	89 04 24             	mov    %eax,(%esp)
  801cb3:	e8 b4 f3 ff ff       	call   80106c <file_get_block>
  801cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cbf:	79 24                	jns    801ce5 <serve_map+0xd3>
		ipc_send(envid, r, 0, 0); return;}
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ccb:	00 
  801ccc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cd3:	00 
  801cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	89 04 24             	mov    %eax,(%esp)
  801cde:	e8 05 1d 00 00       	call   8039e8 <ipc_send>
  801ce3:	eb 3f                	jmp    801d24 <serve_map+0x112>
	if((o->o_mode & O_ACCMODE) == O_RDONLY) perm = PTE_P|PTE_U;//read
  801ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce8:	8b 40 08             	mov    0x8(%eax),%eax
  801ceb:	83 e0 03             	and    $0x3,%eax
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	75 09                	jne    801cfb <serve_map+0xe9>
  801cf2:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
  801cf9:	eb 07                	jmp    801d02 <serve_map+0xf0>
	else perm = PTE_P|PTE_U|PTE_W;
  801cfb:	c7 45 f4 07 00 00 00 	movl   $0x7,-0xc(%ebp)
	//check for the perm and send it
	ipc_send(envid, 0, blk, perm);
  801d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d08:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d17:	00 
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	89 04 24             	mov    %eax,(%esp)
  801d1e:	e8 c5 1c 00 00       	call   8039e8 <ipc_send>
	return ;
  801d23:	90                   	nop
	//panic("serve_map not implemented");
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <serve_close>:

void
serve_close(envid_t envid, struct Fsreq_close *rq)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 28             	sub    $0x28,%esp
		cprintf("serve_close %08x %08x\n", envid, rq->req_fileid);

	// Close the file.
	
	// LAB 5: Your code here.
	if((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0){
  801d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2f:	8b 00                	mov    (%eax),%eax
  801d31:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801d34:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	89 04 24             	mov    %eax,(%esp)
  801d42:	e8 ae fc ff ff       	call   8019f5 <openfile_lookup>
  801d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4e:	79 24                	jns    801d74 <serve_close+0x4e>
		ipc_send(envid, r, 0, 0); return;}
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d5a:	00 
  801d5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d62:	00 
  801d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	89 04 24             	mov    %eax,(%esp)
  801d6d:	e8 76 1c 00 00       	call   8039e8 <ipc_send>
  801d72:	eb 32                	jmp    801da6 <serve_close+0x80>
	file_close(o->o_file);
  801d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d77:	8b 40 04             	mov    0x4(%eax),%eax
  801d7a:	89 04 24             	mov    %eax,(%esp)
  801d7d:	e8 90 fa ff ff       	call   801812 <file_close>
	ipc_send(envid, 0, 0, 0);
  801d82:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d89:	00 
  801d8a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d91:	00 
  801d92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d99:	00 
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	89 04 24             	mov    %eax,(%esp)
  801da0:	e8 43 1c 00 00       	call   8039e8 <ipc_send>
	return ;
  801da5:	90                   	nop
	//panic("serve_close not implemented");
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <serve_remove>:

void
serve_remove(envid_t envid, struct Fsreq_remove *rq)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	81 ec 28 04 00 00    	sub    $0x428,%esp
	// Delete the named file.
	// Note: This request doesn't refer to an open file.
	// Hint: Make sure the path is null-terminated!

	// LAB 5: Your code here.
	memmove(path, rq->req_path, MAXPATHLEN);
  801db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db4:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  801dbb:	00 
  801dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc0:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801dc6:	89 04 24             	mov    %eax,(%esp)
  801dc9:	e8 ee 14 00 00       	call   8032bc <memmove>
	path[MAXPATHLEN-1] = 0;//set '\0'
  801dce:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	r = file_remove(path);
  801dd2:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801dd8:	89 04 24             	mov    %eax,(%esp)
  801ddb:	e8 63 fa ff ff       	call   801843 <file_remove>
  801de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ipc_send(envid, r, 0, 0);
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ded:	00 
  801dee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801df5:	00 
  801df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	89 04 24             	mov    %eax,(%esp)
  801e00:	e8 e3 1b 00 00       	call   8039e8 <ipc_send>
	return ;
	//panic("serve_remove not implemented");
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <serve_dirty>:

void
serve_dirty(envid_t envid, struct Fsreq_dirty *rq)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 28             	sub    $0x28,%esp

	// Mark the page containing the requested file offset as dirty.
	// Returns 0 on success, < 0 on error.
	
	// LAB 5: Your code here.
	if((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0){
  801e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e10:	8b 00                	mov    (%eax),%eax
  801e12:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801e15:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	89 04 24             	mov    %eax,(%esp)
  801e23:	e8 cd fb ff ff       	call   8019f5 <openfile_lookup>
  801e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e2f:	79 24                	jns    801e55 <serve_dirty+0x4e>
		ipc_send(envid, r, 0, 0); return;}
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e3b:	00 
  801e3c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e43:	00 
  801e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	89 04 24             	mov    %eax,(%esp)
  801e4e:	e8 95 1b 00 00       	call   8039e8 <ipc_send>
  801e53:	eb 46                	jmp    801e9b <serve_dirty+0x94>
	if((r = file_dirty(o->o_file, rq->req_offset)) < 0){
  801e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e58:	8b 50 04             	mov    0x4(%eax),%edx
  801e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5e:	8b 40 04             	mov    0x4(%eax),%eax
  801e61:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e65:	89 04 24             	mov    %eax,(%esp)
  801e68:	e8 5b f2 ff ff       	call   8010c8 <file_dirty>
  801e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e74:	79 24                	jns    801e9a <serve_dirty+0x93>
		ipc_send(envid, r, 0, 0); return;}
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e80:	00 
  801e81:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e88:	00 
  801e89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	89 04 24             	mov    %eax,(%esp)
  801e93:	e8 50 1b 00 00       	call   8039e8 <ipc_send>
  801e98:	eb 01                	jmp    801e9b <serve_dirty+0x94>
	return ;//look up a file , and mark it dirty
  801e9a:	90                   	nop
	//panic("serve_dirty not implemented");
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <serve_sync>:

void
serve_sync(envid_t envid)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 18             	sub    $0x18,%esp
	fs_sync();
  801ea3:	e8 2c f9 ff ff       	call   8017d4 <fs_sync>
	ipc_send(envid, 0, 0, 0);
  801ea8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eaf:	00 
  801eb0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801eb7:	00 
  801eb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ebf:	00 
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	89 04 24             	mov    %eax,(%esp)
  801ec6:	e8 1d 1b 00 00       	call   8039e8 <ipc_send>
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <serve>:
//add serve
void
serve(void)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 28             	sub    $0x28,%esp
	uint32_t req, whom;
	int perm;
	
	while (1) {
		perm = 0;
  801ed3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		req = ipc_recv((int32_t *) &whom, (void *) REQVA, &perm);
  801eda:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801edd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee1:	c7 44 24 04 00 f0 ff 	movl   $0xffff000,0x4(%esp)
  801ee8:	0f 
  801ee9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eec:	89 04 24             	mov    %eax,(%esp)
  801eef:	e8 68 1a 00 00       	call   80395c <ipc_recv>
  801ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, vpt[VPN(REQVA)], REQVA);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  801ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efa:	83 e0 01             	and    $0x1,%eax
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 16                	jne    801f17 <serve+0x4a>
			cprintf("Invalid request from %08x: no argument page\n",
  801f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f08:	c7 04 24 8c 4f 80 00 	movl   $0x804f8c,(%esp)
  801f0f:	e8 a4 08 00 00       	call   8027b8 <cprintf>
				whom);
			continue; // just leave it hanging...
  801f14:	90                   	nop
		default:
			cprintf("Invalid request code %d from %08x\n", whom, req);
			break;
		}
		sys_page_unmap(0, (void*) REQVA);
	}
  801f15:	eb bc                	jmp    801ed3 <serve+0x6>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		switch (req) {
  801f17:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
  801f1b:	0f 87 9d 00 00 00    	ja     801fbe <serve+0xf1>
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	c1 e0 02             	shl    $0x2,%eax
  801f27:	05 e0 4f 80 00       	add    $0x804fe0,%eax
  801f2c:	8b 00                	mov    (%eax),%eax
  801f2e:	ff e0                	jmp    *%eax
		case FSREQ_OPEN:
			serve_open(whom, (struct Fsreq_open*)REQVA);
  801f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f33:	c7 44 24 04 00 f0 ff 	movl   $0xffff000,0x4(%esp)
  801f3a:	0f 
  801f3b:	89 04 24             	mov    %eax,(%esp)
  801f3e:	e8 fe fa ff ff       	call   801a41 <serve_open>
			break;
  801f43:	e9 91 00 00 00       	jmp    801fd9 <serve+0x10c>
		case FSREQ_MAP:
			serve_map(whom, (struct Fsreq_map*)REQVA);
  801f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4b:	c7 44 24 04 00 f0 ff 	movl   $0xffff000,0x4(%esp)
  801f52:	0f 
  801f53:	89 04 24             	mov    %eax,(%esp)
  801f56:	e8 b7 fc ff ff       	call   801c12 <serve_map>
			break;
  801f5b:	eb 7c                	jmp    801fd9 <serve+0x10c>
		case FSREQ_SET_SIZE:
			serve_set_size(whom, (struct Fsreq_set_size*)REQVA);
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	c7 44 24 04 00 f0 ff 	movl   $0xffff000,0x4(%esp)
  801f67:	0f 
  801f68:	89 04 24             	mov    %eax,(%esp)
  801f6b:	e8 1b fc ff ff       	call   801b8b <serve_set_size>
			break;
  801f70:	eb 67                	jmp    801fd9 <serve+0x10c>
		case FSREQ_CLOSE:
			serve_close(whom, (struct Fsreq_close*)REQVA);
  801f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f75:	c7 44 24 04 00 f0 ff 	movl   $0xffff000,0x4(%esp)
  801f7c:	0f 
  801f7d:	89 04 24             	mov    %eax,(%esp)
  801f80:	e8 a1 fd ff ff       	call   801d26 <serve_close>
			break;
  801f85:	eb 52                	jmp    801fd9 <serve+0x10c>
		case FSREQ_DIRTY:
			serve_dirty(whom, (struct Fsreq_dirty*)REQVA);
  801f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8a:	c7 44 24 04 00 f0 ff 	movl   $0xffff000,0x4(%esp)
  801f91:	0f 
  801f92:	89 04 24             	mov    %eax,(%esp)
  801f95:	e8 6d fe ff ff       	call   801e07 <serve_dirty>
			break;
  801f9a:	eb 3d                	jmp    801fd9 <serve+0x10c>
		case FSREQ_REMOVE:
			serve_remove(whom, (struct Fsreq_remove*)REQVA);
  801f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9f:	c7 44 24 04 00 f0 ff 	movl   $0xffff000,0x4(%esp)
  801fa6:	0f 
  801fa7:	89 04 24             	mov    %eax,(%esp)
  801faa:	e8 f9 fd ff ff       	call   801da8 <serve_remove>
			break;
  801faf:	eb 28                	jmp    801fd9 <serve+0x10c>
		case FSREQ_SYNC:
			serve_sync(whom);
  801fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb4:	89 04 24             	mov    %eax,(%esp)
  801fb7:	e8 e1 fe ff ff       	call   801e9d <serve_sync>
			break;
  801fbc:	eb 1b                	jmp    801fd9 <serve+0x10c>
		default:
			cprintf("Invalid request code %d from %08x\n", whom, req);
  801fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc4:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcc:	c7 04 24 bc 4f 80 00 	movl   $0x804fbc,(%esp)
  801fd3:	e8 e0 07 00 00       	call   8027b8 <cprintf>
			break;
  801fd8:	90                   	nop
		}
		sys_page_unmap(0, (void*) REQVA);
  801fd9:	c7 44 24 04 00 f0 ff 	movl   $0xffff000,0x4(%esp)
  801fe0:	0f 
  801fe1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe8:	e8 a0 17 00 00       	call   80378d <sys_page_unmap>
	}
  801fed:	e9 e1 fe ff ff       	jmp    801ed3 <serve+0x6>

00801ff2 <umain>:
}

void
umain(void)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 28             	sub    $0x28,%esp
	static_assert(sizeof(struct File) == 256);
        binaryname = "fs";
  801ff8:	c7 05 24 c0 80 00 00 	movl   $0x805000,0x80c024
  801fff:	50 80 00 
	cprintf("FS is running\n");
  802002:	c7 04 24 03 50 80 00 	movl   $0x805003,(%esp)
  802009:	e8 aa 07 00 00       	call   8027b8 <cprintf>
  80200e:	c7 45 f4 00 8a 00 00 	movl   $0x8a00,-0xc(%ebp)
  802015:	66 c7 45 f2 00 8a    	movw   $0x8a00,-0xe(%ebp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80201b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  80201f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802022:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802024:	c7 04 24 12 50 80 00 	movl   $0x805012,(%esp)
  80202b:	e8 88 07 00 00       	call   8027b8 <cprintf>

	serve_init();
  802030:	e8 8f f8 ff ff       	call   8018c4 <serve_init>
	fs_init();
  802035:	e8 15 ee ff ff       	call   800e4f <fs_init>
	fs_test();
  80203a:	e8 43 00 00 00       	call   802082 <fs_test>

	serve();
  80203f:	e8 89 fe ff ff       	call   801ecd <serve>
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    
	...

00802048 <strecmp>:
#include "fs.h"


int
strecmp(char *a, char *b)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	while (*b)
  80204b:	eb 24                	jmp    802071 <strecmp+0x29>
		if (*a++ != *b++)
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	0f b6 10             	movzbl (%eax),%edx
  802053:	8b 45 0c             	mov    0xc(%ebp),%eax
  802056:	0f b6 00             	movzbl (%eax),%eax
  802059:	38 c2                	cmp    %al,%dl
  80205b:	0f 95 c0             	setne  %al
  80205e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  802062:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  802066:	84 c0                	test   %al,%al
  802068:	74 07                	je     802071 <strecmp+0x29>
			return 1;
  80206a:	b8 01 00 00 00       	mov    $0x1,%eax
  80206f:	eb 0f                	jmp    802080 <strecmp+0x38>


int
strecmp(char *a, char *b)
{
	while (*b)
  802071:	8b 45 0c             	mov    0xc(%ebp),%eax
  802074:	0f b6 00             	movzbl (%eax),%eax
  802077:	84 c0                	test   %al,%al
  802079:	75 d2                	jne    80204d <strecmp+0x5>
		if (*a++ != *b++)
			return 1;
	return 0;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802080:	5d                   	pop    %ebp
  802081:	c3                   	ret    

00802082 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	56                   	push   %esi
  802086:	53                   	push   %ebx
  802087:	83 ec 20             	sub    $0x20,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80208a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802091:	00 
  802092:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  802099:	00 
  80209a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a1:	e8 60 16 00 00       	call   803706 <sys_page_alloc>
  8020a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ad:	79 23                	jns    8020d2 <fs_test+0x50>
		panic("sys_page_alloc: %e", r);
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020b6:	c7 44 24 08 4a 50 80 	movl   $0x80504a,0x8(%esp)
  8020bd:	00 
  8020be:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8020c5:	00 
  8020c6:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  8020cd:	e8 b2 05 00 00       	call   802684 <_panic>
	bits = (uint32_t*) PGSIZE;
  8020d2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
	memmove(bits, bitmap, PGSIZE);
  8020d9:	a1 60 c0 80 00       	mov    0x80c060,%eax
  8020de:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8020e5:	00 
  8020e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ed:	89 04 24             	mov    %eax,(%esp)
  8020f0:	e8 c7 11 00 00       	call   8032bc <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8020f5:	e8 ef e8 ff ff       	call   8009e9 <alloc_block>
  8020fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802101:	79 23                	jns    802126 <fs_test+0xa4>
		panic("alloc_block: %e", r);
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80210a:	c7 44 24 08 67 50 80 	movl   $0x805067,0x8(%esp)
  802111:	00 
  802112:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802119:	00 
  80211a:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802121:	e8 5e 05 00 00       	call   802684 <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  802126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802129:	8d 50 1f             	lea    0x1f(%eax),%edx
  80212c:	85 c0                	test   %eax,%eax
  80212e:	0f 48 c2             	cmovs  %edx,%eax
  802131:	c1 f8 05             	sar    $0x5,%eax
  802134:	c1 e0 02             	shl    $0x2,%eax
  802137:	03 45 f0             	add    -0x10(%ebp),%eax
  80213a:	8b 18                	mov    (%eax),%ebx
  80213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213f:	89 c2                	mov    %eax,%edx
  802141:	c1 fa 1f             	sar    $0x1f,%edx
  802144:	c1 ea 1b             	shr    $0x1b,%edx
  802147:	01 d0                	add    %edx,%eax
  802149:	83 e0 1f             	and    $0x1f,%eax
  80214c:	29 d0                	sub    %edx,%eax
  80214e:	ba 01 00 00 00       	mov    $0x1,%edx
  802153:	89 d6                	mov    %edx,%esi
  802155:	89 c1                	mov    %eax,%ecx
  802157:	d3 e6                	shl    %cl,%esi
  802159:	89 f0                	mov    %esi,%eax
  80215b:	21 d8                	and    %ebx,%eax
  80215d:	85 c0                	test   %eax,%eax
  80215f:	75 24                	jne    802185 <fs_test+0x103>
  802161:	c7 44 24 0c 77 50 80 	movl   $0x805077,0xc(%esp)
  802168:	00 
  802169:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  802170:	00 
  802171:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802178:	00 
  802179:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802180:	e8 ff 04 00 00       	call   802684 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802185:	8b 15 60 c0 80 00    	mov    0x80c060,%edx
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	8d 48 1f             	lea    0x1f(%eax),%ecx
  802191:	85 c0                	test   %eax,%eax
  802193:	0f 48 c1             	cmovs  %ecx,%eax
  802196:	c1 f8 05             	sar    $0x5,%eax
  802199:	c1 e0 02             	shl    $0x2,%eax
  80219c:	01 d0                	add    %edx,%eax
  80219e:	8b 18                	mov    (%eax),%ebx
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	89 c2                	mov    %eax,%edx
  8021a5:	c1 fa 1f             	sar    $0x1f,%edx
  8021a8:	c1 ea 1b             	shr    $0x1b,%edx
  8021ab:	01 d0                	add    %edx,%eax
  8021ad:	83 e0 1f             	and    $0x1f,%eax
  8021b0:	29 d0                	sub    %edx,%eax
  8021b2:	ba 01 00 00 00       	mov    $0x1,%edx
  8021b7:	89 d6                	mov    %edx,%esi
  8021b9:	89 c1                	mov    %eax,%ecx
  8021bb:	d3 e6                	shl    %cl,%esi
  8021bd:	89 f0                	mov    %esi,%eax
  8021bf:	21 d8                	and    %ebx,%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	74 24                	je     8021e9 <fs_test+0x167>
  8021c5:	c7 44 24 0c a8 50 80 	movl   $0x8050a8,0xc(%esp)
  8021cc:	00 
  8021cd:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  8021d4:	00 
  8021d5:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8021dc:	00 
  8021dd:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  8021e4:	e8 9b 04 00 00       	call   802684 <_panic>
	cprintf("alloc_block is good\n");
  8021e9:	c7 04 24 c8 50 80 00 	movl   $0x8050c8,(%esp)
  8021f0:	e8 c3 05 00 00       	call   8027b8 <cprintf>
	
	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8021f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fc:	c7 04 24 dd 50 80 00 	movl   $0x8050dd,(%esp)
  802203:	e8 a3 f3 ff ff       	call   8015ab <file_open>
  802208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220f:	79 29                	jns    80223a <fs_test+0x1b8>
  802211:	83 7d f4 f5          	cmpl   $0xfffffff5,-0xc(%ebp)
  802215:	74 23                	je     80223a <fs_test+0x1b8>
		panic("file_open /not-found: %e", r);
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80221e:	c7 44 24 08 e8 50 80 	movl   $0x8050e8,0x8(%esp)
  802225:	00 
  802226:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  80222d:	00 
  80222e:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802235:	e8 4a 04 00 00       	call   802684 <_panic>
	else if (r == 0)
  80223a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223e:	75 1c                	jne    80225c <fs_test+0x1da>
		panic("file_open /not-found succeeded!");
  802240:	c7 44 24 08 04 51 80 	movl   $0x805104,0x8(%esp)
  802247:	00 
  802248:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  80224f:	00 
  802250:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802257:	e8 28 04 00 00       	call   802684 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  80225c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80225f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802263:	c7 04 24 24 51 80 00 	movl   $0x805124,(%esp)
  80226a:	e8 3c f3 ff ff       	call   8015ab <file_open>
  80226f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802272:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802276:	79 23                	jns    80229b <fs_test+0x219>
		panic("file_open /newmotd: %e", r);
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80227f:	c7 44 24 08 2d 51 80 	movl   $0x80512d,0x8(%esp)
  802286:	00 
  802287:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  80228e:	00 
  80228f:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802296:	e8 e9 03 00 00       	call   802684 <_panic>
	cprintf("file_open is good\n");
  80229b:	c7 04 24 44 51 80 00 	movl   $0x805144,(%esp)
  8022a2:	e8 11 05 00 00       	call   8027b8 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8022a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022aa:	8d 55 e8             	lea    -0x18(%ebp),%edx
  8022ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022b8:	00 
  8022b9:	89 04 24             	mov    %eax,(%esp)
  8022bc:	e8 ab ed ff ff       	call   80106c <file_get_block>
  8022c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c8:	79 23                	jns    8022ed <fs_test+0x26b>
		panic("file_get_block: %e", r);
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022d1:	c7 44 24 08 57 51 80 	movl   $0x805157,0x8(%esp)
  8022d8:	00 
  8022d9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8022e0:	00 
  8022e1:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  8022e8:	e8 97 03 00 00       	call   802684 <_panic>
	if (strecmp(blk, msg) != 0)
  8022ed:	8b 15 20 c0 80 00    	mov    0x80c020,%edx
  8022f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022fa:	89 04 24             	mov    %eax,(%esp)
  8022fd:	e8 46 fd ff ff       	call   802048 <strecmp>
  802302:	85 c0                	test   %eax,%eax
  802304:	74 1c                	je     802322 <fs_test+0x2a0>
		panic("file_get_block returned wrong data");
  802306:	c7 44 24 08 6c 51 80 	movl   $0x80516c,0x8(%esp)
  80230d:	00 
  80230e:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  802315:	00 
  802316:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  80231d:	e8 62 03 00 00       	call   802684 <_panic>
	cprintf("file_get_block is good\n");
  802322:	c7 04 24 8f 51 80 00 	movl   $0x80518f,(%esp)
  802329:	e8 8a 04 00 00       	call   8027b8 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  80232e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802331:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802334:	0f b6 12             	movzbl (%edx),%edx
  802337:	88 10                	mov    %dl,(%eax)
	assert((vpt[VPN(blk)] & PTE_D));
  802339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80233c:	c1 e8 0c             	shr    $0xc,%eax
  80233f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802346:	83 e0 40             	and    $0x40,%eax
  802349:	85 c0                	test   %eax,%eax
  80234b:	75 24                	jne    802371 <fs_test+0x2ef>
  80234d:	c7 44 24 0c a7 51 80 	movl   $0x8051a7,0xc(%esp)
  802354:	00 
  802355:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  80235c:	00 
  80235d:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  802364:	00 
  802365:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  80236c:	e8 13 03 00 00       	call   802684 <_panic>
	file_flush(f);
  802371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802374:	89 04 24             	mov    %eax,(%esp)
  802377:	e8 a0 f3 ff ff       	call   80171c <file_flush>
	assert(!(vpt[VPN(blk)] & PTE_D));
  80237c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80237f:	c1 e8 0c             	shr    $0xc,%eax
  802382:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802389:	83 e0 40             	and    $0x40,%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	74 24                	je     8023b4 <fs_test+0x332>
  802390:	c7 44 24 0c bf 51 80 	movl   $0x8051bf,0xc(%esp)
  802397:	00 
  802398:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  80239f:	00 
  8023a0:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8023a7:	00 
  8023a8:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  8023af:	e8 d0 02 00 00       	call   802684 <_panic>
	cprintf("file_flush is good\n");
  8023b4:	c7 04 24 d8 51 80 00 	movl   $0x8051d8,(%esp)
  8023bb:	e8 f8 03 00 00       	call   8027b8 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8023c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023ca:	00 
  8023cb:	89 04 24             	mov    %eax,(%esp)
  8023ce:	e8 f2 f2 ff ff       	call   8016c5 <file_set_size>
  8023d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023da:	79 23                	jns    8023ff <fs_test+0x37d>
		panic("file_set_size: %e", r);
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023e3:	c7 44 24 08 ec 51 80 	movl   $0x8051ec,0x8(%esp)
  8023ea:	00 
  8023eb:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  8023f2:	00 
  8023f3:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  8023fa:	e8 85 02 00 00       	call   802684 <_panic>
	assert(f->f_direct[0] == 0);
  8023ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802402:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
  802408:	85 c0                	test   %eax,%eax
  80240a:	74 24                	je     802430 <fs_test+0x3ae>
  80240c:	c7 44 24 0c fe 51 80 	movl   $0x8051fe,0xc(%esp)
  802413:	00 
  802414:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  80241b:	00 
  80241c:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  802423:	00 
  802424:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  80242b:	e8 54 02 00 00       	call   802684 <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  802430:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802433:	c1 e8 0c             	shr    $0xc,%eax
  802436:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80243d:	83 e0 40             	and    $0x40,%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 24                	je     802468 <fs_test+0x3e6>
  802444:	c7 44 24 0c 12 52 80 	movl   $0x805212,0xc(%esp)
  80244b:	00 
  80244c:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  802453:	00 
  802454:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  80245b:	00 
  80245c:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802463:	e8 1c 02 00 00       	call   802684 <_panic>
	cprintf("file_truncate is good\n");
  802468:	c7 04 24 29 52 80 00 	movl   $0x805229,(%esp)
  80246f:	e8 44 03 00 00       	call   8027b8 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802474:	a1 20 c0 80 00       	mov    0x80c020,%eax
  802479:	89 04 24             	mov    %eax,(%esp)
  80247c:	e8 f3 0b 00 00       	call   803074 <strlen>
  802481:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802484:	89 44 24 04          	mov    %eax,0x4(%esp)
  802488:	89 14 24             	mov    %edx,(%esp)
  80248b:	e8 35 f2 ff ff       	call   8016c5 <file_set_size>
  802490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802497:	79 23                	jns    8024bc <fs_test+0x43a>
		panic("file_set_size 2: %e", r);
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024a0:	c7 44 24 08 40 52 80 	movl   $0x805240,0x8(%esp)
  8024a7:	00 
  8024a8:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8024af:	00 
  8024b0:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  8024b7:	e8 c8 01 00 00       	call   802684 <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  8024bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bf:	c1 e8 0c             	shr    $0xc,%eax
  8024c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8024c9:	83 e0 40             	and    $0x40,%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	74 24                	je     8024f4 <fs_test+0x472>
  8024d0:	c7 44 24 0c 12 52 80 	movl   $0x805212,0xc(%esp)
  8024d7:	00 
  8024d8:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  8024df:	00 
  8024e0:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  8024e7:	00 
  8024e8:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  8024ef:	e8 90 01 00 00       	call   802684 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8024f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f7:	8d 55 e8             	lea    -0x18(%ebp),%edx
  8024fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802505:	00 
  802506:	89 04 24             	mov    %eax,(%esp)
  802509:	e8 5e eb ff ff       	call   80106c <file_get_block>
  80250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802511:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802515:	79 23                	jns    80253a <fs_test+0x4b8>
		panic("file_get_block 2: %e", r);
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80251e:	c7 44 24 08 54 52 80 	movl   $0x805254,0x8(%esp)
  802525:	00 
  802526:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  80252d:	00 
  80252e:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802535:	e8 4a 01 00 00       	call   802684 <_panic>
	strcpy(blk, msg);	
  80253a:	8b 15 20 c0 80 00    	mov    0x80c020,%edx
  802540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802543:	89 54 24 04          	mov    %edx,0x4(%esp)
  802547:	89 04 24             	mov    %eax,(%esp)
  80254a:	e8 7b 0b 00 00       	call   8030ca <strcpy>
	assert((vpt[VPN(blk)] & PTE_D));
  80254f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802552:	c1 e8 0c             	shr    $0xc,%eax
  802555:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80255c:	83 e0 40             	and    $0x40,%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	75 24                	jne    802587 <fs_test+0x505>
  802563:	c7 44 24 0c a7 51 80 	movl   $0x8051a7,0xc(%esp)
  80256a:	00 
  80256b:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  802572:	00 
  802573:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  80257a:	00 
  80257b:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802582:	e8 fd 00 00 00       	call   802684 <_panic>
	file_flush(f);
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	89 04 24             	mov    %eax,(%esp)
  80258d:	e8 8a f1 ff ff       	call   80171c <file_flush>
	assert(!(vpt[VPN(blk)] & PTE_D));
  802592:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802595:	c1 e8 0c             	shr    $0xc,%eax
  802598:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80259f:	83 e0 40             	and    $0x40,%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 24                	je     8025ca <fs_test+0x548>
  8025a6:	c7 44 24 0c bf 51 80 	movl   $0x8051bf,0xc(%esp)
  8025ad:	00 
  8025ae:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  8025b5:	00 
  8025b6:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8025bd:	00 
  8025be:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  8025c5:	e8 ba 00 00 00       	call   802684 <_panic>
	file_close(f);
  8025ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cd:	89 04 24             	mov    %eax,(%esp)
  8025d0:	e8 3d f2 ff ff       	call   801812 <file_close>
	assert(!(vpt[VPN(f)] & PTE_D));	
  8025d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d8:	c1 e8 0c             	shr    $0xc,%eax
  8025db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8025e2:	83 e0 40             	and    $0x40,%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 24                	je     80260d <fs_test+0x58b>
  8025e9:	c7 44 24 0c 12 52 80 	movl   $0x805212,0xc(%esp)
  8025f0:	00 
  8025f1:	c7 44 24 08 92 50 80 	movl   $0x805092,0x8(%esp)
  8025f8:	00 
  8025f9:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  802600:	00 
  802601:	c7 04 24 5d 50 80 00 	movl   $0x80505d,(%esp)
  802608:	e8 77 00 00 00       	call   802684 <_panic>
	cprintf("file rewrite is good\n");
  80260d:	c7 04 24 69 52 80 00 	movl   $0x805269,(%esp)
  802614:	e8 9f 01 00 00       	call   8027b8 <cprintf>
}
  802619:	83 c4 20             	add    $0x20,%esp
  80261c:	5b                   	pop    %ebx
  80261d:	5e                   	pop    %esi
  80261e:	5d                   	pop    %ebp
  80261f:	c3                   	ret    

00802620 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  802626:	e8 53 10 00 00       	call   80367e <sys_getenvid>
  80262b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802630:	c1 e0 07             	shl    $0x7,%eax
  802633:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802638:	a3 68 c0 80 00       	mov    %eax,0x80c068
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80263d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802641:	7e 0a                	jle    80264d <libmain+0x2d>
		binaryname = argv[0];
  802643:	8b 45 0c             	mov    0xc(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	a3 24 c0 80 00       	mov    %eax,0x80c024

	// call user main routine
	umain(argc, argv);
  80264d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802650:	89 44 24 04          	mov    %eax,0x4(%esp)
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	89 04 24             	mov    %eax,(%esp)
  80265a:	e8 93 f9 ff ff       	call   801ff2 <umain>

	// exit gracefully
	exit();
  80265f:	e8 04 00 00 00       	call   802668 <exit>
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    
	...

00802668 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80266e:	e8 03 16 00 00       	call   803c76 <close_all>
	sys_env_destroy(0);
  802673:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80267a:	e8 bc 0f 00 00       	call   80363b <sys_env_destroy>
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    
  802681:	00 00                	add    %al,(%eax)
	...

00802684 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  80268a:	8d 45 10             	lea    0x10(%ebp),%eax
  80268d:	83 c0 04             	add    $0x4,%eax
  802690:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  802693:	a1 6c c0 80 00       	mov    0x80c06c,%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	74 15                	je     8026b1 <_panic+0x2d>
		cprintf("%s: ", argv0);
  80269c:	a1 6c c0 80 00       	mov    0x80c06c,%eax
  8026a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a5:	c7 04 24 96 52 80 00 	movl   $0x805296,(%esp)
  8026ac:	e8 07 01 00 00       	call   8027b8 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8026b1:	a1 24 c0 80 00       	mov    0x80c024,%eax
  8026b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c8:	c7 04 24 9b 52 80 00 	movl   $0x80529b,(%esp)
  8026cf:	e8 e4 00 00 00       	call   8027b8 <cprintf>
	vcprintf(fmt, ap);
  8026d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026da:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026de:	89 04 24             	mov    %eax,(%esp)
  8026e1:	e8 6e 00 00 00       	call   802754 <vcprintf>
	cprintf("\n");
  8026e6:	c7 04 24 b7 52 80 00 	movl   $0x8052b7,(%esp)
  8026ed:	e8 c6 00 00 00       	call   8027b8 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026f2:	cc                   	int3   
  8026f3:	eb fd                	jmp    8026f2 <_panic+0x6e>
  8026f5:	00 00                	add    %al,(%eax)
	...

008026f8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
  8026fb:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  8026fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	8b 55 08             	mov    0x8(%ebp),%edx
  802706:	89 d1                	mov    %edx,%ecx
  802708:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  80270f:	8d 50 01             	lea    0x1(%eax),%edx
  802712:	8b 45 0c             	mov    0xc(%ebp),%eax
  802715:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  802717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	3d ff 00 00 00       	cmp    $0xff,%eax
  802721:	75 20                	jne    802743 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  802723:	8b 45 0c             	mov    0xc(%ebp),%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272b:	83 c2 08             	add    $0x8,%edx
  80272e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802732:	89 14 24             	mov    %edx,(%esp)
  802735:	e8 7b 0e 00 00       	call   8035b5 <sys_cputs>
		b->idx = 0;
  80273a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  802743:	8b 45 0c             	mov    0xc(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	8d 50 01             	lea    0x1(%eax),%edx
  80274c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274f:	89 50 04             	mov    %edx,0x4(%eax)
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80275d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802764:	00 00 00 
	b.cnt = 0;
  802767:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80276e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  802771:	8b 45 0c             	mov    0xc(%ebp),%eax
  802774:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80277f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  802785:	89 44 24 04          	mov    %eax,0x4(%esp)
  802789:	c7 04 24 f8 26 80 00 	movl   $0x8026f8,(%esp)
  802790:	e8 f7 01 00 00       	call   80298c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  802795:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80279b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8027a5:	83 c0 08             	add    $0x8,%eax
  8027a8:	89 04 24             	mov    %eax,(%esp)
  8027ab:	e8 05 0e 00 00       	call   8035b5 <sys_cputs>

	return b.cnt;
  8027b0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8027be:	8d 45 0c             	lea    0xc(%ebp),%eax
  8027c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027ce:	89 04 24             	mov    %eax,(%esp)
  8027d1:	e8 7e ff ff ff       	call   802754 <vcprintf>
  8027d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    
	...

008027e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	53                   	push   %ebx
  8027e4:	83 ec 34             	sub    $0x34,%esp
  8027e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8027f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8027f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8027f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8027fe:	77 72                	ja     802872 <printnum+0x92>
  802800:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  802803:	72 05                	jb     80280a <printnum+0x2a>
  802805:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802808:	77 68                	ja     802872 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80280a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80280d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  802810:	8b 45 18             	mov    0x18(%ebp),%eax
  802813:	ba 00 00 00 00       	mov    $0x0,%edx
  802818:	89 44 24 08          	mov    %eax,0x8(%esp)
  80281c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802826:	89 04 24             	mov    %eax,(%esp)
  802829:	89 54 24 04          	mov    %edx,0x4(%esp)
  80282d:	e8 7e 21 00 00       	call   8049b0 <__udivdi3>
  802832:	8b 4d 20             	mov    0x20(%ebp),%ecx
  802835:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  802839:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  80283d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  802840:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802844:	89 44 24 08          	mov    %eax,0x8(%esp)
  802848:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80284c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802853:	8b 45 08             	mov    0x8(%ebp),%eax
  802856:	89 04 24             	mov    %eax,(%esp)
  802859:	e8 82 ff ff ff       	call   8027e0 <printnum>
  80285e:	eb 1c                	jmp    80287c <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802860:	8b 45 0c             	mov    0xc(%ebp),%eax
  802863:	89 44 24 04          	mov    %eax,0x4(%esp)
  802867:	8b 45 20             	mov    0x20(%ebp),%eax
  80286a:	89 04 24             	mov    %eax,(%esp)
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802872:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  802876:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80287a:	7f e4                	jg     802860 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80287c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80287f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80288e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802892:	89 04 24             	mov    %eax,(%esp)
  802895:	89 54 24 04          	mov    %edx,0x4(%esp)
  802899:	e8 42 22 00 00       	call   804ae0 <__umoddi3>
  80289e:	05 1c 54 80 00       	add    $0x80541c,%eax
  8028a3:	0f b6 00             	movzbl (%eax),%eax
  8028a6:	0f be c0             	movsbl %al,%eax
  8028a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028b0:	89 04 24             	mov    %eax,(%esp)
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	ff d0                	call   *%eax
}
  8028b8:	83 c4 34             	add    $0x34,%esp
  8028bb:	5b                   	pop    %ebx
  8028bc:	5d                   	pop    %ebp
  8028bd:	c3                   	ret    

008028be <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8028be:	55                   	push   %ebp
  8028bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8028c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8028c5:	7e 1c                	jle    8028e3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	8d 50 08             	lea    0x8(%eax),%edx
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	89 10                	mov    %edx,(%eax)
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	83 e8 08             	sub    $0x8,%eax
  8028dc:	8b 50 04             	mov    0x4(%eax),%edx
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	eb 40                	jmp    802923 <getuint+0x65>
	else if (lflag)
  8028e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028e7:	74 1e                	je     802907 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	8d 50 04             	lea    0x4(%eax),%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	89 10                	mov    %edx,(%eax)
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	83 e8 04             	sub    $0x4,%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	ba 00 00 00 00       	mov    $0x0,%edx
  802905:	eb 1c                	jmp    802923 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	8b 00                	mov    (%eax),%eax
  80290c:	8d 50 04             	lea    0x4(%eax),%edx
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	89 10                	mov    %edx,(%eax)
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	83 e8 04             	sub    $0x4,%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  802923:	5d                   	pop    %ebp
  802924:	c3                   	ret    

00802925 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  802928:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80292c:	7e 1c                	jle    80294a <getint+0x25>
		return va_arg(*ap, long long);
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	8d 50 08             	lea    0x8(%eax),%edx
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	89 10                	mov    %edx,(%eax)
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	83 e8 08             	sub    $0x8,%eax
  802943:	8b 50 04             	mov    0x4(%eax),%edx
  802946:	8b 00                	mov    (%eax),%eax
  802948:	eb 40                	jmp    80298a <getint+0x65>
	else if (lflag)
  80294a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80294e:	74 1e                	je     80296e <getint+0x49>
		return va_arg(*ap, long);
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	8d 50 04             	lea    0x4(%eax),%edx
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	83 e8 04             	sub    $0x4,%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	89 c2                	mov    %eax,%edx
  802969:	c1 fa 1f             	sar    $0x1f,%edx
  80296c:	eb 1c                	jmp    80298a <getint+0x65>
	else
		return va_arg(*ap, int);
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	8d 50 04             	lea    0x4(%eax),%edx
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	89 10                	mov    %edx,(%eax)
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	83 e8 04             	sub    $0x4,%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	89 c2                	mov    %eax,%edx
  802987:	c1 fa 1f             	sar    $0x1f,%edx
}
  80298a:	5d                   	pop    %ebp
  80298b:	c3                   	ret    

0080298c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	56                   	push   %esi
  802990:	53                   	push   %ebx
  802991:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802994:	eb 17                	jmp    8029ad <vprintfmt+0x21>
			if (ch == '\0')
  802996:	85 db                	test   %ebx,%ebx
  802998:	0f 84 d1 05 00 00    	je     802f6f <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  80299e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a5:	89 1c 24             	mov    %ebx,(%esp)
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8029ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8029b0:	0f b6 00             	movzbl (%eax),%eax
  8029b3:	0f b6 d8             	movzbl %al,%ebx
  8029b6:	83 fb 25             	cmp    $0x25,%ebx
  8029b9:	0f 95 c0             	setne  %al
  8029bc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8029c0:	84 c0                	test   %al,%al
  8029c2:	75 d2                	jne    802996 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8029c4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8029c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8029cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8029d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8029dd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8029e4:	eb 04                	jmp    8029ea <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8029e6:	90                   	nop
  8029e7:	eb 01                	jmp    8029ea <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8029e9:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8029ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ed:	0f b6 00             	movzbl (%eax),%eax
  8029f0:	0f b6 d8             	movzbl %al,%ebx
  8029f3:	89 d8                	mov    %ebx,%eax
  8029f5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8029f9:	83 e8 23             	sub    $0x23,%eax
  8029fc:	83 f8 55             	cmp    $0x55,%eax
  8029ff:	0f 87 39 05 00 00    	ja     802f3e <vprintfmt+0x5b2>
  802a05:	8b 04 85 64 54 80 00 	mov    0x805464(,%eax,4),%eax
  802a0c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  802a0e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  802a12:	eb d6                	jmp    8029ea <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802a14:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  802a18:	eb d0                	jmp    8029ea <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802a1a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  802a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a24:	89 d0                	mov    %edx,%eax
  802a26:	c1 e0 02             	shl    $0x2,%eax
  802a29:	01 d0                	add    %edx,%eax
  802a2b:	01 c0                	add    %eax,%eax
  802a2d:	01 d8                	add    %ebx,%eax
  802a2f:	83 e8 30             	sub    $0x30,%eax
  802a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  802a35:	8b 45 10             	mov    0x10(%ebp),%eax
  802a38:	0f b6 00             	movzbl (%eax),%eax
  802a3b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802a3e:	83 fb 2f             	cmp    $0x2f,%ebx
  802a41:	7e 43                	jle    802a86 <vprintfmt+0xfa>
  802a43:	83 fb 39             	cmp    $0x39,%ebx
  802a46:	7f 3e                	jg     802a86 <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802a48:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802a4c:	eb d3                	jmp    802a21 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  802a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  802a51:	83 c0 04             	add    $0x4,%eax
  802a54:	89 45 14             	mov    %eax,0x14(%ebp)
  802a57:	8b 45 14             	mov    0x14(%ebp),%eax
  802a5a:	83 e8 04             	sub    $0x4,%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  802a62:	eb 23                	jmp    802a87 <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  802a64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a68:	0f 89 78 ff ff ff    	jns    8029e6 <vprintfmt+0x5a>
				width = 0;
  802a6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  802a75:	e9 6c ff ff ff       	jmp    8029e6 <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  802a7a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  802a81:	e9 64 ff ff ff       	jmp    8029ea <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  802a86:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  802a87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a8b:	0f 89 58 ff ff ff    	jns    8029e9 <vprintfmt+0x5d>
				width = precision, precision = -1;
  802a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a97:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  802a9e:	e9 46 ff ff ff       	jmp    8029e9 <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802aa3:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  802aa7:	e9 3e ff ff ff       	jmp    8029ea <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802aac:	8b 45 14             	mov    0x14(%ebp),%eax
  802aaf:	83 c0 04             	add    $0x4,%eax
  802ab2:	89 45 14             	mov    %eax,0x14(%ebp)
  802ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  802ab8:	83 e8 04             	sub    $0x4,%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac0:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ac4:	89 04 24             	mov    %eax,(%esp)
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	ff d0                	call   *%eax
			break;
  802acc:	e9 98 04 00 00       	jmp    802f69 <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  802ad1:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  802ad8:	00 
  802ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  802adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae0:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802ae3:	89 04 24             	mov    %eax,(%esp)
  802ae6:	e8 d1 07 00 00       	call   8032bc <memmove>
            sel_c[3] = '\0';
  802aeb:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  802aef:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  802af3:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  802af7:	3c 2f                	cmp    $0x2f,%al
  802af9:	7e 4c                	jle    802b47 <vprintfmt+0x1bb>
  802afb:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  802aff:	3c 39                	cmp    $0x39,%al
  802b01:	7f 44                	jg     802b47 <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  802b03:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  802b07:	0f be d0             	movsbl %al,%edx
  802b0a:	89 d0                	mov    %edx,%eax
  802b0c:	c1 e0 02             	shl    $0x2,%eax
  802b0f:	01 d0                	add    %edx,%eax
  802b11:	01 c0                	add    %eax,%eax
  802b13:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  802b19:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  802b1d:	0f be c0             	movsbl %al,%eax
  802b20:	01 c2                	add    %eax,%edx
  802b22:	89 d0                	mov    %edx,%eax
  802b24:	c1 e0 02             	shl    $0x2,%eax
  802b27:	01 d0                	add    %edx,%eax
  802b29:	01 c0                	add    %eax,%eax
  802b2b:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  802b31:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  802b35:	0f be c0             	movsbl %al,%eax
  802b38:	01 d0                	add    %edx,%eax
  802b3a:	83 e8 30             	sub    $0x30,%eax
  802b3d:	a3 28 c0 80 00       	mov    %eax,0x80c028
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802b42:	e9 22 04 00 00       	jmp    802f69 <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  802b47:	c7 44 24 04 2d 54 80 	movl   $0x80542d,0x4(%esp)
  802b4e:	00 
  802b4f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802b52:	89 04 24             	mov    %eax,(%esp)
  802b55:	e8 36 06 00 00       	call   803190 <strcmp>
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	75 0f                	jne    802b6d <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  802b5e:	c7 05 28 c0 80 00 07 	movl   $0x7,0x80c028
  802b65:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802b68:	e9 fc 03 00 00       	jmp    802f69 <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  802b6d:	c7 44 24 04 31 54 80 	movl   $0x805431,0x4(%esp)
  802b74:	00 
  802b75:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802b78:	89 04 24             	mov    %eax,(%esp)
  802b7b:	e8 10 06 00 00       	call   803190 <strcmp>
  802b80:	85 c0                	test   %eax,%eax
  802b82:	75 0f                	jne    802b93 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  802b84:	c7 05 28 c0 80 00 01 	movl   $0x1,0x80c028
  802b8b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802b8e:	e9 d6 03 00 00       	jmp    802f69 <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  802b93:	c7 44 24 04 35 54 80 	movl   $0x805435,0x4(%esp)
  802b9a:	00 
  802b9b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802b9e:	89 04 24             	mov    %eax,(%esp)
  802ba1:	e8 ea 05 00 00       	call   803190 <strcmp>
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	75 0f                	jne    802bb9 <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  802baa:	c7 05 28 c0 80 00 02 	movl   $0x2,0x80c028
  802bb1:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802bb4:	e9 b0 03 00 00       	jmp    802f69 <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  802bb9:	c7 44 24 04 39 54 80 	movl   $0x805439,0x4(%esp)
  802bc0:	00 
  802bc1:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802bc4:	89 04 24             	mov    %eax,(%esp)
  802bc7:	e8 c4 05 00 00       	call   803190 <strcmp>
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	75 0f                	jne    802bdf <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  802bd0:	c7 05 28 c0 80 00 04 	movl   $0x4,0x80c028
  802bd7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802bda:	e9 8a 03 00 00       	jmp    802f69 <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  802bdf:	c7 44 24 04 3d 54 80 	movl   $0x80543d,0x4(%esp)
  802be6:	00 
  802be7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802bea:	89 04 24             	mov    %eax,(%esp)
  802bed:	e8 9e 05 00 00       	call   803190 <strcmp>
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	75 0f                	jne    802c05 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  802bf6:	c7 05 28 c0 80 00 08 	movl   $0x8,0x80c028
  802bfd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802c00:	e9 64 03 00 00       	jmp    802f69 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  802c05:	c7 44 24 04 41 54 80 	movl   $0x805441,0x4(%esp)
  802c0c:	00 
  802c0d:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802c10:	89 04 24             	mov    %eax,(%esp)
  802c13:	e8 78 05 00 00       	call   803190 <strcmp>
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	75 0f                	jne    802c2b <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  802c1c:	c7 05 28 c0 80 00 0f 	movl   $0xf,0x80c028
  802c23:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802c26:	e9 3e 03 00 00       	jmp    802f69 <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  802c2b:	c7 44 24 04 45 54 80 	movl   $0x805445,0x4(%esp)
  802c32:	00 
  802c33:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802c36:	89 04 24             	mov    %eax,(%esp)
  802c39:	e8 52 05 00 00       	call   803190 <strcmp>
  802c3e:	85 c0                	test   %eax,%eax
  802c40:	75 0f                	jne    802c51 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  802c42:	c7 05 28 c0 80 00 0c 	movl   $0xc,0x80c028
  802c49:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802c4c:	e9 18 03 00 00       	jmp    802f69 <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  802c51:	c7 44 24 04 49 54 80 	movl   $0x805449,0x4(%esp)
  802c58:	00 
  802c59:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802c5c:	89 04 24             	mov    %eax,(%esp)
  802c5f:	e8 2c 05 00 00       	call   803190 <strcmp>
  802c64:	85 c0                	test   %eax,%eax
  802c66:	75 0f                	jne    802c77 <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  802c68:	c7 05 28 c0 80 00 06 	movl   $0x6,0x80c028
  802c6f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802c72:	e9 f2 02 00 00       	jmp    802f69 <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  802c77:	c7 44 24 04 4d 54 80 	movl   $0x80544d,0x4(%esp)
  802c7e:	00 
  802c7f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  802c82:	89 04 24             	mov    %eax,(%esp)
  802c85:	e8 06 05 00 00       	call   803190 <strcmp>
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	75 0f                	jne    802c9d <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  802c8e:	c7 05 28 c0 80 00 0b 	movl   $0xb,0x80c028
  802c95:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802c98:	e9 cc 02 00 00       	jmp    802f69 <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  802c9d:	c7 05 28 c0 80 00 07 	movl   $0x7,0x80c028
  802ca4:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  802ca7:	e9 bd 02 00 00       	jmp    802f69 <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  802cac:	8b 45 14             	mov    0x14(%ebp),%eax
  802caf:	83 c0 04             	add    $0x4,%eax
  802cb2:	89 45 14             	mov    %eax,0x14(%ebp)
  802cb5:	8b 45 14             	mov    0x14(%ebp),%eax
  802cb8:	83 e8 04             	sub    $0x4,%eax
  802cbb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  802cbd:	85 db                	test   %ebx,%ebx
  802cbf:	79 02                	jns    802cc3 <vprintfmt+0x337>
				err = -err;
  802cc1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  802cc3:	83 fb 0e             	cmp    $0xe,%ebx
  802cc6:	7f 0b                	jg     802cd3 <vprintfmt+0x347>
  802cc8:	8b 34 9d e0 53 80 00 	mov    0x8053e0(,%ebx,4),%esi
  802ccf:	85 f6                	test   %esi,%esi
  802cd1:	75 23                	jne    802cf6 <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  802cd3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802cd7:	c7 44 24 08 51 54 80 	movl   $0x805451,0x8(%esp)
  802cde:	00 
  802cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	89 04 24             	mov    %eax,(%esp)
  802cec:	e8 86 02 00 00       	call   802f77 <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802cf1:	e9 73 02 00 00       	jmp    802f69 <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802cf6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802cfa:	c7 44 24 08 5a 54 80 	movl   $0x80545a,0x8(%esp)
  802d01:	00 
  802d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d05:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	89 04 24             	mov    %eax,(%esp)
  802d0f:	e8 63 02 00 00       	call   802f77 <printfmt>
			break;
  802d14:	e9 50 02 00 00       	jmp    802f69 <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  802d19:	8b 45 14             	mov    0x14(%ebp),%eax
  802d1c:	83 c0 04             	add    $0x4,%eax
  802d1f:	89 45 14             	mov    %eax,0x14(%ebp)
  802d22:	8b 45 14             	mov    0x14(%ebp),%eax
  802d25:	83 e8 04             	sub    $0x4,%eax
  802d28:	8b 30                	mov    (%eax),%esi
  802d2a:	85 f6                	test   %esi,%esi
  802d2c:	75 05                	jne    802d33 <vprintfmt+0x3a7>
				p = "(null)";
  802d2e:	be 5d 54 80 00       	mov    $0x80545d,%esi
			if (width > 0 && padc != '-')
  802d33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d37:	7e 73                	jle    802dac <vprintfmt+0x420>
  802d39:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  802d3d:	74 6d                	je     802dac <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  802d3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d42:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d46:	89 34 24             	mov    %esi,(%esp)
  802d49:	e8 4c 03 00 00       	call   80309a <strnlen>
  802d4e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  802d51:	eb 17                	jmp    802d6a <vprintfmt+0x3de>
					putch(padc, putdat);
  802d53:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  802d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5a:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d5e:	89 04 24             	mov    %eax,(%esp)
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802d66:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802d6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d6e:	7f e3                	jg     802d53 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802d70:	eb 3a                	jmp    802dac <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  802d72:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d76:	74 1f                	je     802d97 <vprintfmt+0x40b>
  802d78:	83 fb 1f             	cmp    $0x1f,%ebx
  802d7b:	7e 05                	jle    802d82 <vprintfmt+0x3f6>
  802d7d:	83 fb 7e             	cmp    $0x7e,%ebx
  802d80:	7e 15                	jle    802d97 <vprintfmt+0x40b>
					putch('?', putdat);
  802d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d89:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	ff d0                	call   *%eax
  802d95:	eb 0f                	jmp    802da6 <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  802d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d9e:	89 1c 24             	mov    %ebx,(%esp)
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802da6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802daa:	eb 01                	jmp    802dad <vprintfmt+0x421>
  802dac:	90                   	nop
  802dad:	0f b6 06             	movzbl (%esi),%eax
  802db0:	0f be d8             	movsbl %al,%ebx
  802db3:	85 db                	test   %ebx,%ebx
  802db5:	0f 95 c0             	setne  %al
  802db8:	83 c6 01             	add    $0x1,%esi
  802dbb:	84 c0                	test   %al,%al
  802dbd:	74 29                	je     802de8 <vprintfmt+0x45c>
  802dbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dc3:	78 ad                	js     802d72 <vprintfmt+0x3e6>
  802dc5:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  802dc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dcd:	79 a3                	jns    802d72 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802dcf:	eb 17                	jmp    802de8 <vprintfmt+0x45c>
				putch(' ', putdat);
  802dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dd8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802de4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802de8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dec:	7f e3                	jg     802dd1 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  802dee:	e9 76 01 00 00       	jmp    802f69 <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  802df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dfa:	8d 45 14             	lea    0x14(%ebp),%eax
  802dfd:	89 04 24             	mov    %eax,(%esp)
  802e00:	e8 20 fb ff ff       	call   802925 <getint>
  802e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e11:	85 d2                	test   %edx,%edx
  802e13:	79 26                	jns    802e3b <vprintfmt+0x4af>
				putch('-', putdat);
  802e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e1c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	ff d0                	call   *%eax
				num = -(long long) num;
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2e:	f7 d8                	neg    %eax
  802e30:	83 d2 00             	adc    $0x0,%edx
  802e33:	f7 da                	neg    %edx
  802e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e38:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802e3b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802e42:	e9 ae 00 00 00       	jmp    802ef5 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802e47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e4e:	8d 45 14             	lea    0x14(%ebp),%eax
  802e51:	89 04 24             	mov    %eax,(%esp)
  802e54:	e8 65 fa ff ff       	call   8028be <getuint>
  802e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802e5f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802e66:	e9 8a 00 00 00       	jmp    802ef5 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  802e6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e72:	8d 45 14             	lea    0x14(%ebp),%eax
  802e75:	89 04 24             	mov    %eax,(%esp)
  802e78:	e8 41 fa ff ff       	call   8028be <getuint>
  802e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  802e83:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  802e8a:	eb 69                	jmp    802ef5 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  802e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e93:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	ff d0                	call   *%eax
			putch('x', putdat);
  802e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea2:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ea6:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  802eb2:	8b 45 14             	mov    0x14(%ebp),%eax
  802eb5:	83 c0 04             	add    $0x4,%eax
  802eb8:	89 45 14             	mov    %eax,0x14(%ebp)
  802ebb:	8b 45 14             	mov    0x14(%ebp),%eax
  802ebe:	83 e8 04             	sub    $0x4,%eax
  802ec1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ec6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  802ecd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  802ed4:	eb 1f                	jmp    802ef5 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802ed6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802edd:	8d 45 14             	lea    0x14(%ebp),%eax
  802ee0:	89 04 24             	mov    %eax,(%esp)
  802ee3:	e8 d6 f9 ff ff       	call   8028be <getuint>
  802ee8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802eeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802eee:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802ef5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	89 54 24 18          	mov    %edx,0x18(%esp)
  802f00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f03:	89 54 24 14          	mov    %edx,0x14(%esp)
  802f07:	89 44 24 10          	mov    %eax,0x10(%esp)
  802f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f11:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f15:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	89 04 24             	mov    %eax,(%esp)
  802f26:	e8 b5 f8 ff ff       	call   8027e0 <printnum>
			break;
  802f2b:	eb 3c                	jmp    802f69 <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f30:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f34:	89 1c 24             	mov    %ebx,(%esp)
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	ff d0                	call   *%eax
			break;
  802f3c:	eb 2b                	jmp    802f69 <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f41:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f45:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802f51:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  802f55:	eb 04                	jmp    802f5b <vprintfmt+0x5cf>
  802f57:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  802f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  802f5e:	83 e8 01             	sub    $0x1,%eax
  802f61:	0f b6 00             	movzbl (%eax),%eax
  802f64:	3c 25                	cmp    $0x25,%al
  802f66:	75 ef                	jne    802f57 <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  802f68:	90                   	nop
		}
	}
  802f69:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802f6a:	e9 3e fa ff ff       	jmp    8029ad <vprintfmt+0x21>
			if (ch == '\0')
				return;
  802f6f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802f70:	83 c4 50             	add    $0x50,%esp
  802f73:	5b                   	pop    %ebx
  802f74:	5e                   	pop    %esi
  802f75:	5d                   	pop    %ebp
  802f76:	c3                   	ret    

00802f77 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802f77:	55                   	push   %ebp
  802f78:	89 e5                	mov    %esp,%ebp
  802f7a:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  802f7d:	8d 45 10             	lea    0x10(%ebp),%eax
  802f80:	83 c0 04             	add    $0x4,%eax
  802f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802f86:	8b 45 10             	mov    0x10(%ebp),%eax
  802f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f8c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802f90:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f97:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	89 04 24             	mov    %eax,(%esp)
  802fa1:	e8 e6 f9 ff ff       	call   80298c <vprintfmt>
	va_end(ap);
}
  802fa6:	c9                   	leave  
  802fa7:	c3                   	ret    

00802fa8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802fa8:	55                   	push   %ebp
  802fa9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fae:	8b 40 08             	mov    0x8(%eax),%eax
  802fb1:	8d 50 01             	lea    0x1(%eax),%edx
  802fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  802fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbd:	8b 10                	mov    (%eax),%edx
  802fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc2:	8b 40 04             	mov    0x4(%eax),%eax
  802fc5:	39 c2                	cmp    %eax,%edx
  802fc7:	73 12                	jae    802fdb <sprintputch+0x33>
		*b->buf++ = ch;
  802fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd1:	88 10                	mov    %dl,(%eax)
  802fd3:	8d 50 01             	lea    0x1(%eax),%edx
  802fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd9:	89 10                	mov    %edx,(%eax)
}
  802fdb:	5d                   	pop    %ebp
  802fdc:	c3                   	ret    

00802fdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802fdd:	55                   	push   %ebp
  802fde:	89 e5                	mov    %esp,%ebp
  802fe0:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fec:	83 e8 01             	sub    $0x1,%eax
  802fef:	03 45 08             	add    0x8(%ebp),%eax
  802ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ff5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802ffc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803000:	74 06                	je     803008 <vsnprintf+0x2b>
  803002:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803006:	7f 07                	jg     80300f <vsnprintf+0x32>
		return -E_INVAL;
  803008:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80300d:	eb 2a                	jmp    803039 <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80300f:	8b 45 14             	mov    0x14(%ebp),%eax
  803012:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803016:	8b 45 10             	mov    0x10(%ebp),%eax
  803019:	89 44 24 08          	mov    %eax,0x8(%esp)
  80301d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  803020:	89 44 24 04          	mov    %eax,0x4(%esp)
  803024:	c7 04 24 a8 2f 80 00 	movl   $0x802fa8,(%esp)
  80302b:	e8 5c f9 ff ff       	call   80298c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  803030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803033:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803039:	c9                   	leave  
  80303a:	c3                   	ret    

0080303b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80303b:	55                   	push   %ebp
  80303c:	89 e5                	mov    %esp,%ebp
  80303e:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  803041:	8d 45 10             	lea    0x10(%ebp),%eax
  803044:	83 c0 04             	add    $0x4,%eax
  803047:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80304a:	8b 45 10             	mov    0x10(%ebp),%eax
  80304d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803050:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803054:	89 44 24 08          	mov    %eax,0x8(%esp)
  803058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	89 04 24             	mov    %eax,(%esp)
  803065:	e8 73 ff ff ff       	call   802fdd <vsnprintf>
  80306a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803070:	c9                   	leave  
  803071:	c3                   	ret    
	...

00803074 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  803074:	55                   	push   %ebp
  803075:	89 e5                	mov    %esp,%ebp
  803077:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80307a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803081:	eb 08                	jmp    80308b <strlen+0x17>
		n++;
  803083:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803087:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	0f b6 00             	movzbl (%eax),%eax
  803091:	84 c0                	test   %al,%al
  803093:	75 ee                	jne    803083 <strlen+0xf>
		n++;
	return n;
  803095:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803098:	c9                   	leave  
  803099:	c3                   	ret    

0080309a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
  80309d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8030a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030a7:	eb 0c                	jmp    8030b5 <strnlen+0x1b>
		n++;
  8030a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8030ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8030b1:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  8030b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030b9:	74 0a                	je     8030c5 <strnlen+0x2b>
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	0f b6 00             	movzbl (%eax),%eax
  8030c1:	84 c0                	test   %al,%al
  8030c3:	75 e4                	jne    8030a9 <strnlen+0xf>
		n++;
	return n;
  8030c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030c8:	c9                   	leave  
  8030c9:	c3                   	ret    

008030ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8030ca:	55                   	push   %ebp
  8030cb:	89 e5                	mov    %esp,%ebp
  8030cd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8030d6:	90                   	nop
  8030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030da:	0f b6 10             	movzbl (%eax),%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	88 10                	mov    %dl,(%eax)
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	0f b6 00             	movzbl (%eax),%eax
  8030e8:	84 c0                	test   %al,%al
  8030ea:	0f 95 c0             	setne  %al
  8030ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8030f1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  8030f5:	84 c0                	test   %al,%al
  8030f7:	75 de                	jne    8030d7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8030f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030fc:	c9                   	leave  
  8030fd:	c3                   	ret    

008030fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8030fe:	55                   	push   %ebp
  8030ff:	89 e5                	mov    %esp,%ebp
  803101:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80310a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803111:	eb 21                	jmp    803134 <strncpy+0x36>
		*dst++ = *src;
  803113:	8b 45 0c             	mov    0xc(%ebp),%eax
  803116:	0f b6 10             	movzbl (%eax),%edx
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	88 10                	mov    %dl,(%eax)
  80311e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803122:	8b 45 0c             	mov    0xc(%ebp),%eax
  803125:	0f b6 00             	movzbl (%eax),%eax
  803128:	84 c0                	test   %al,%al
  80312a:	74 04                	je     803130 <strncpy+0x32>
			src++;
  80312c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  803130:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  803134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803137:	3b 45 10             	cmp    0x10(%ebp),%eax
  80313a:	72 d7                	jb     803113 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80313c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80313f:	c9                   	leave  
  803140:	c3                   	ret    

00803141 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  803141:	55                   	push   %ebp
  803142:	89 e5                	mov    %esp,%ebp
  803144:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80314d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803151:	74 2f                	je     803182 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  803153:	eb 13                	jmp    803168 <strlcpy+0x27>
			*dst++ = *src++;
  803155:	8b 45 0c             	mov    0xc(%ebp),%eax
  803158:	0f b6 10             	movzbl (%eax),%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	88 10                	mov    %dl,(%eax)
  803160:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  803164:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  803168:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80316c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803170:	74 0a                	je     80317c <strlcpy+0x3b>
  803172:	8b 45 0c             	mov    0xc(%ebp),%eax
  803175:	0f b6 00             	movzbl (%eax),%eax
  803178:	84 c0                	test   %al,%al
  80317a:	75 d9                	jne    803155 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  803182:	8b 55 08             	mov    0x8(%ebp),%edx
  803185:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803188:	89 d1                	mov    %edx,%ecx
  80318a:	29 c1                	sub    %eax,%ecx
  80318c:	89 c8                	mov    %ecx,%eax
}
  80318e:	c9                   	leave  
  80318f:	c3                   	ret    

00803190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803190:	55                   	push   %ebp
  803191:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  803193:	eb 08                	jmp    80319d <strcmp+0xd>
		p++, q++;
  803195:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  803199:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	0f b6 00             	movzbl (%eax),%eax
  8031a3:	84 c0                	test   %al,%al
  8031a5:	74 10                	je     8031b7 <strcmp+0x27>
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	0f b6 10             	movzbl (%eax),%edx
  8031ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b0:	0f b6 00             	movzbl (%eax),%eax
  8031b3:	38 c2                	cmp    %al,%dl
  8031b5:	74 de                	je     803195 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	0f b6 00             	movzbl (%eax),%eax
  8031bd:	0f b6 d0             	movzbl %al,%edx
  8031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c3:	0f b6 00             	movzbl (%eax),%eax
  8031c6:	0f b6 c0             	movzbl %al,%eax
  8031c9:	89 d1                	mov    %edx,%ecx
  8031cb:	29 c1                	sub    %eax,%ecx
  8031cd:	89 c8                	mov    %ecx,%eax
}
  8031cf:	5d                   	pop    %ebp
  8031d0:	c3                   	ret    

008031d1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8031d1:	55                   	push   %ebp
  8031d2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8031d4:	eb 0c                	jmp    8031e2 <strncmp+0x11>
		n--, p++, q++;
  8031d6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8031da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8031de:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8031e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8031e6:	74 1a                	je     803202 <strncmp+0x31>
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	0f b6 00             	movzbl (%eax),%eax
  8031ee:	84 c0                	test   %al,%al
  8031f0:	74 10                	je     803202 <strncmp+0x31>
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	0f b6 10             	movzbl (%eax),%edx
  8031f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031fb:	0f b6 00             	movzbl (%eax),%eax
  8031fe:	38 c2                	cmp    %al,%dl
  803200:	74 d4                	je     8031d6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  803202:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803206:	75 07                	jne    80320f <strncmp+0x3e>
		return 0;
  803208:	b8 00 00 00 00       	mov    $0x0,%eax
  80320d:	eb 18                	jmp    803227 <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	0f b6 00             	movzbl (%eax),%eax
  803215:	0f b6 d0             	movzbl %al,%edx
  803218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80321b:	0f b6 00             	movzbl (%eax),%eax
  80321e:	0f b6 c0             	movzbl %al,%eax
  803221:	89 d1                	mov    %edx,%ecx
  803223:	29 c1                	sub    %eax,%ecx
  803225:	89 c8                	mov    %ecx,%eax
}
  803227:	5d                   	pop    %ebp
  803228:	c3                   	ret    

00803229 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  803229:	55                   	push   %ebp
  80322a:	89 e5                	mov    %esp,%ebp
  80322c:	83 ec 04             	sub    $0x4,%esp
  80322f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803232:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  803235:	eb 14                	jmp    80324b <strchr+0x22>
		if (*s == c)
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	0f b6 00             	movzbl (%eax),%eax
  80323d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  803240:	75 05                	jne    803247 <strchr+0x1e>
			return (char *) s;
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	eb 13                	jmp    80325a <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  803247:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	0f b6 00             	movzbl (%eax),%eax
  803251:	84 c0                	test   %al,%al
  803253:	75 e2                	jne    803237 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  803255:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80325a:	c9                   	leave  
  80325b:	c3                   	ret    

0080325c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80325c:	55                   	push   %ebp
  80325d:	89 e5                	mov    %esp,%ebp
  80325f:	83 ec 04             	sub    $0x4,%esp
  803262:	8b 45 0c             	mov    0xc(%ebp),%eax
  803265:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  803268:	eb 0f                	jmp    803279 <strfind+0x1d>
		if (*s == c)
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	0f b6 00             	movzbl (%eax),%eax
  803270:	3a 45 fc             	cmp    -0x4(%ebp),%al
  803273:	74 10                	je     803285 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  803275:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	0f b6 00             	movzbl (%eax),%eax
  80327f:	84 c0                	test   %al,%al
  803281:	75 e7                	jne    80326a <strfind+0xe>
  803283:	eb 01                	jmp    803286 <strfind+0x2a>
		if (*s == c)
			break;
  803285:	90                   	nop
	return (char *) s;
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803289:	c9                   	leave  
  80328a:	c3                   	ret    

0080328b <memset>:


void *
memset(void *v, int c, size_t n)
{
  80328b:	55                   	push   %ebp
  80328c:	89 e5                	mov    %esp,%ebp
  80328e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  803297:	8b 45 10             	mov    0x10(%ebp),%eax
  80329a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80329d:	eb 0e                	jmp    8032ad <memset+0x22>
		*p++ = c;
  80329f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a2:	89 c2                	mov    %eax,%edx
  8032a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032a7:	88 10                	mov    %dl,(%eax)
  8032a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8032ad:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  8032b1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8032b5:	79 e8                	jns    80329f <memset+0x14>
		*p++ = c;

	return v;
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8032ba:	c9                   	leave  
  8032bb:	c3                   	ret    

008032bc <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  8032bc:	55                   	push   %ebp
  8032bd:	89 e5                	mov    %esp,%ebp
  8032bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8032c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8032ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032d4:	73 54                	jae    80332a <memmove+0x6e>
  8032d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8032d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032dc:	01 d0                	add    %edx,%eax
  8032de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032e1:	76 47                	jbe    80332a <memmove+0x6e>
		s += n;
  8032e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8032e6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8032e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8032ec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8032ef:	eb 13                	jmp    803304 <memmove+0x48>
			*--d = *--s;
  8032f1:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  8032f5:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  8032f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032fc:	0f b6 10             	movzbl (%eax),%edx
  8032ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803302:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  803304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803308:	0f 95 c0             	setne  %al
  80330b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80330f:	84 c0                	test   %al,%al
  803311:	75 de                	jne    8032f1 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  803313:	eb 25                	jmp    80333a <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  803315:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803318:	0f b6 10             	movzbl (%eax),%edx
  80331b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80331e:	88 10                	mov    %dl,(%eax)
  803320:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  803324:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  803328:	eb 01                	jmp    80332b <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80332a:	90                   	nop
  80332b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80332f:	0f 95 c0             	setne  %al
  803332:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  803336:	84 c0                	test   %al,%al
  803338:	75 db                	jne    803315 <memmove+0x59>
			*d++ = *s++;

	return dst;
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80333d:	c9                   	leave  
  80333e:	c3                   	ret    

0080333f <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  80333f:	55                   	push   %ebp
  803340:	89 e5                	mov    %esp,%ebp
  803342:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  803345:	8b 45 10             	mov    0x10(%ebp),%eax
  803348:	89 44 24 08          	mov    %eax,0x8(%esp)
  80334c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	89 04 24             	mov    %eax,(%esp)
  803359:	e8 5e ff ff ff       	call   8032bc <memmove>
}
  80335e:	c9                   	leave  
  80335f:	c3                   	ret    

00803360 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803360:	55                   	push   %ebp
  803361:	89 e5                	mov    %esp,%ebp
  803363:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80336c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  803372:	eb 32                	jmp    8033a6 <memcmp+0x46>
		if (*s1 != *s2)
  803374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803377:	0f b6 10             	movzbl (%eax),%edx
  80337a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80337d:	0f b6 00             	movzbl (%eax),%eax
  803380:	38 c2                	cmp    %al,%dl
  803382:	74 1a                	je     80339e <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  803384:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803387:	0f b6 00             	movzbl (%eax),%eax
  80338a:	0f b6 d0             	movzbl %al,%edx
  80338d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803390:	0f b6 00             	movzbl (%eax),%eax
  803393:	0f b6 c0             	movzbl %al,%eax
  803396:	89 d1                	mov    %edx,%ecx
  803398:	29 c1                	sub    %eax,%ecx
  80339a:	89 c8                	mov    %ecx,%eax
  80339c:	eb 1c                	jmp    8033ba <memcmp+0x5a>
		s1++, s2++;
  80339e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8033a2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8033a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8033aa:	0f 95 c0             	setne  %al
  8033ad:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8033b1:	84 c0                	test   %al,%al
  8033b3:	75 bf                	jne    803374 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8033b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033ba:	c9                   	leave  
  8033bb:	c3                   	ret    

008033bc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8033bc:	55                   	push   %ebp
  8033bd:	89 e5                	mov    %esp,%ebp
  8033bf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8033c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8033c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c8:	01 d0                	add    %edx,%eax
  8033ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8033cd:	eb 11                	jmp    8033e0 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	0f b6 10             	movzbl (%eax),%edx
  8033d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d8:	38 c2                	cmp    %al,%dl
  8033da:	74 0e                	je     8033ea <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8033dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8033e6:	72 e7                	jb     8033cf <memfind+0x13>
  8033e8:	eb 01                	jmp    8033eb <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8033ea:	90                   	nop
	return (void *) s;
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8033ee:	c9                   	leave  
  8033ef:	c3                   	ret    

008033f0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8033f0:	55                   	push   %ebp
  8033f1:	89 e5                	mov    %esp,%ebp
  8033f3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8033f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8033fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803404:	eb 04                	jmp    80340a <strtol+0x1a>
		s++;
  803406:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	0f b6 00             	movzbl (%eax),%eax
  803410:	3c 20                	cmp    $0x20,%al
  803412:	74 f2                	je     803406 <strtol+0x16>
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	0f b6 00             	movzbl (%eax),%eax
  80341a:	3c 09                	cmp    $0x9,%al
  80341c:	74 e8                	je     803406 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	0f b6 00             	movzbl (%eax),%eax
  803424:	3c 2b                	cmp    $0x2b,%al
  803426:	75 06                	jne    80342e <strtol+0x3e>
		s++;
  803428:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80342c:	eb 15                	jmp    803443 <strtol+0x53>
	else if (*s == '-')
  80342e:	8b 45 08             	mov    0x8(%ebp),%eax
  803431:	0f b6 00             	movzbl (%eax),%eax
  803434:	3c 2d                	cmp    $0x2d,%al
  803436:	75 0b                	jne    803443 <strtol+0x53>
		s++, neg = 1;
  803438:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80343c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803443:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803447:	74 06                	je     80344f <strtol+0x5f>
  803449:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80344d:	75 24                	jne    803473 <strtol+0x83>
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	0f b6 00             	movzbl (%eax),%eax
  803455:	3c 30                	cmp    $0x30,%al
  803457:	75 1a                	jne    803473 <strtol+0x83>
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	83 c0 01             	add    $0x1,%eax
  80345f:	0f b6 00             	movzbl (%eax),%eax
  803462:	3c 78                	cmp    $0x78,%al
  803464:	75 0d                	jne    803473 <strtol+0x83>
		s += 2, base = 16;
  803466:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80346a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  803471:	eb 2a                	jmp    80349d <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  803473:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803477:	75 17                	jne    803490 <strtol+0xa0>
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	0f b6 00             	movzbl (%eax),%eax
  80347f:	3c 30                	cmp    $0x30,%al
  803481:	75 0d                	jne    803490 <strtol+0xa0>
		s++, base = 8;
  803483:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  803487:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80348e:	eb 0d                	jmp    80349d <strtol+0xad>
	else if (base == 0)
  803490:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803494:	75 07                	jne    80349d <strtol+0xad>
		base = 10;
  803496:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	0f b6 00             	movzbl (%eax),%eax
  8034a3:	3c 2f                	cmp    $0x2f,%al
  8034a5:	7e 1b                	jle    8034c2 <strtol+0xd2>
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	0f b6 00             	movzbl (%eax),%eax
  8034ad:	3c 39                	cmp    $0x39,%al
  8034af:	7f 11                	jg     8034c2 <strtol+0xd2>
			dig = *s - '0';
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	0f b6 00             	movzbl (%eax),%eax
  8034b7:	0f be c0             	movsbl %al,%eax
  8034ba:	83 e8 30             	sub    $0x30,%eax
  8034bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c0:	eb 48                	jmp    80350a <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	0f b6 00             	movzbl (%eax),%eax
  8034c8:	3c 60                	cmp    $0x60,%al
  8034ca:	7e 1b                	jle    8034e7 <strtol+0xf7>
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	0f b6 00             	movzbl (%eax),%eax
  8034d2:	3c 7a                	cmp    $0x7a,%al
  8034d4:	7f 11                	jg     8034e7 <strtol+0xf7>
			dig = *s - 'a' + 10;
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	0f b6 00             	movzbl (%eax),%eax
  8034dc:	0f be c0             	movsbl %al,%eax
  8034df:	83 e8 57             	sub    $0x57,%eax
  8034e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e5:	eb 23                	jmp    80350a <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	0f b6 00             	movzbl (%eax),%eax
  8034ed:	3c 40                	cmp    $0x40,%al
  8034ef:	7e 38                	jle    803529 <strtol+0x139>
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	0f b6 00             	movzbl (%eax),%eax
  8034f7:	3c 5a                	cmp    $0x5a,%al
  8034f9:	7f 2e                	jg     803529 <strtol+0x139>
			dig = *s - 'A' + 10;
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	0f b6 00             	movzbl (%eax),%eax
  803501:	0f be c0             	movsbl %al,%eax
  803504:	83 e8 37             	sub    $0x37,%eax
  803507:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350d:	3b 45 10             	cmp    0x10(%ebp),%eax
  803510:	7d 16                	jge    803528 <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  803512:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  803516:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803519:	0f af 45 10          	imul   0x10(%ebp),%eax
  80351d:	03 45 f4             	add    -0xc(%ebp),%eax
  803520:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  803523:	e9 75 ff ff ff       	jmp    80349d <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  803528:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  803529:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80352d:	74 08                	je     803537 <strtol+0x147>
		*endptr = (char *) s;
  80352f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803532:	8b 55 08             	mov    0x8(%ebp),%edx
  803535:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  803537:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80353b:	74 07                	je     803544 <strtol+0x154>
  80353d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803540:	f7 d8                	neg    %eax
  803542:	eb 03                	jmp    803547 <strtol+0x157>
  803544:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  803547:	c9                   	leave  
  803548:	c3                   	ret    
  803549:	00 00                	add    %al,(%eax)
	...

0080354c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80354c:	55                   	push   %ebp
  80354d:	89 e5                	mov    %esp,%ebp
  80354f:	57                   	push   %edi
  803550:	56                   	push   %esi
  803551:	53                   	push   %ebx
  803552:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80355b:	8b 55 10             	mov    0x10(%ebp),%edx
  80355e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803561:	8b 5d 18             	mov    0x18(%ebp),%ebx
  803564:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  803567:	8b 75 20             	mov    0x20(%ebp),%esi
  80356a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356d:	cd 30                	int    $0x30
  80356f:	89 c3                	mov    %eax,%ebx
  803571:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  803574:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803578:	74 30                	je     8035aa <syscall+0x5e>
  80357a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80357e:	7e 2a                	jle    8035aa <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  803580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803583:	89 44 24 10          	mov    %eax,0x10(%esp)
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80358e:	c7 44 24 08 bc 55 80 	movl   $0x8055bc,0x8(%esp)
  803595:	00 
  803596:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80359d:	00 
  80359e:	c7 04 24 d9 55 80 00 	movl   $0x8055d9,(%esp)
  8035a5:	e8 da f0 ff ff       	call   802684 <_panic>

	return ret;
  8035aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8035ad:	83 c4 4c             	add    $0x4c,%esp
  8035b0:	5b                   	pop    %ebx
  8035b1:	5e                   	pop    %esi
  8035b2:	5f                   	pop    %edi
  8035b3:	5d                   	pop    %ebp
  8035b4:	c3                   	ret    

008035b5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8035b5:	55                   	push   %ebp
  8035b6:	89 e5                	mov    %esp,%ebp
  8035b8:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8035c5:	00 
  8035c6:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8035cd:	00 
  8035ce:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8035d5:	00 
  8035d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8035dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8035e8:	00 
  8035e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035f0:	e8 57 ff ff ff       	call   80354c <syscall>
}
  8035f5:	c9                   	leave  
  8035f6:	c3                   	ret    

008035f7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8035f7:	55                   	push   %ebp
  8035f8:	89 e5                	mov    %esp,%ebp
  8035fa:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8035fd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  803604:	00 
  803605:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80360c:	00 
  80360d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  803614:	00 
  803615:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80361c:	00 
  80361d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803624:	00 
  803625:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80362c:	00 
  80362d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  803634:	e8 13 ff ff ff       	call   80354c <syscall>
}
  803639:	c9                   	leave  
  80363a:	c3                   	ret    

0080363b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80363b:	55                   	push   %ebp
  80363c:	89 e5                	mov    %esp,%ebp
  80363e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80364b:	00 
  80364c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  803653:	00 
  803654:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80365b:	00 
  80365c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803663:	00 
  803664:	89 44 24 08          	mov    %eax,0x8(%esp)
  803668:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80366f:	00 
  803670:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  803677:	e8 d0 fe ff ff       	call   80354c <syscall>
}
  80367c:	c9                   	leave  
  80367d:	c3                   	ret    

0080367e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80367e:	55                   	push   %ebp
  80367f:	89 e5                	mov    %esp,%ebp
  803681:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  803684:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80368b:	00 
  80368c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  803693:	00 
  803694:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80369b:	00 
  80369c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8036a3:	00 
  8036a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8036ab:	00 
  8036ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8036b3:	00 
  8036b4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8036bb:	e8 8c fe ff ff       	call   80354c <syscall>
}
  8036c0:	c9                   	leave  
  8036c1:	c3                   	ret    

008036c2 <sys_yield>:

void
sys_yield(void)
{
  8036c2:	55                   	push   %ebp
  8036c3:	89 e5                	mov    %esp,%ebp
  8036c5:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8036c8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8036cf:	00 
  8036d0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8036d7:	00 
  8036d8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8036df:	00 
  8036e0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8036e7:	00 
  8036e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8036ef:	00 
  8036f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8036f7:	00 
  8036f8:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8036ff:	e8 48 fe ff ff       	call   80354c <syscall>
}
  803704:	c9                   	leave  
  803705:	c3                   	ret    

00803706 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  803706:	55                   	push   %ebp
  803707:	89 e5                	mov    %esp,%ebp
  803709:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  80370c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80370f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80371c:	00 
  80371d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  803724:	00 
  803725:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803729:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80372d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803731:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803738:	00 
  803739:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  803740:	e8 07 fe ff ff       	call   80354c <syscall>
}
  803745:	c9                   	leave  
  803746:	c3                   	ret    

00803747 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  803747:	55                   	push   %ebp
  803748:	89 e5                	mov    %esp,%ebp
  80374a:	56                   	push   %esi
  80374b:	53                   	push   %ebx
  80374c:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80374f:	8b 75 18             	mov    0x18(%ebp),%esi
  803752:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803755:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	89 74 24 18          	mov    %esi,0x18(%esp)
  803762:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803766:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80376a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80376e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803772:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803779:	00 
  80377a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  803781:	e8 c6 fd ff ff       	call   80354c <syscall>
}
  803786:	83 c4 20             	add    $0x20,%esp
  803789:	5b                   	pop    %ebx
  80378a:	5e                   	pop    %esi
  80378b:	5d                   	pop    %ebp
  80378c:	c3                   	ret    

0080378d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80378d:	55                   	push   %ebp
  80378e:	89 e5                	mov    %esp,%ebp
  803790:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  803793:	8b 55 0c             	mov    0xc(%ebp),%edx
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8037a0:	00 
  8037a1:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8037a8:	00 
  8037a9:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8037b0:	00 
  8037b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8037b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8037c0:	00 
  8037c1:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  8037c8:	e8 7f fd ff ff       	call   80354c <syscall>
}
  8037cd:	c9                   	leave  
  8037ce:	c3                   	ret    

008037cf <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  8037cf:	55                   	push   %ebp
  8037d0:	89 e5                	mov    %esp,%ebp
  8037d2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  8037d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037db:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8037e2:	00 
  8037e3:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8037ea:	00 
  8037eb:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8037f2:	00 
  8037f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8037f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803802:	00 
  803803:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  80380a:	e8 3d fd ff ff       	call   80354c <syscall>
}
  80380f:	c9                   	leave  
  803810:	c3                   	ret    

00803811 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  803811:	55                   	push   %ebp
  803812:	89 e5                	mov    %esp,%ebp
  803814:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  803817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80381a:	8b 45 08             	mov    0x8(%ebp),%eax
  80381d:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  803824:	00 
  803825:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80382c:	00 
  80382d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  803834:	00 
  803835:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803839:	89 44 24 08          	mov    %eax,0x8(%esp)
  80383d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803844:	00 
  803845:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  80384c:	e8 fb fc ff ff       	call   80354c <syscall>
}
  803851:	c9                   	leave  
  803852:	c3                   	ret    

00803853 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  803853:	55                   	push   %ebp
  803854:	89 e5                	mov    %esp,%ebp
  803856:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  803859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80385c:	8b 45 08             	mov    0x8(%ebp),%eax
  80385f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  803866:	00 
  803867:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80386e:	00 
  80386f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  803876:	00 
  803877:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80387b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80387f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803886:	00 
  803887:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  80388e:	e8 b9 fc ff ff       	call   80354c <syscall>
}
  803893:	c9                   	leave  
  803894:	c3                   	ret    

00803895 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  803895:	55                   	push   %ebp
  803896:	89 e5                	mov    %esp,%ebp
  803898:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80389b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8038a8:	00 
  8038a9:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8038b0:	00 
  8038b1:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8038b8:	00 
  8038b9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8038bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8038c8:	00 
  8038c9:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  8038d0:	e8 77 fc ff ff       	call   80354c <syscall>
}
  8038d5:	c9                   	leave  
  8038d6:	c3                   	ret    

008038d7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
  8038da:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8038dd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8038e0:	8b 55 10             	mov    0x10(%ebp),%edx
  8038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e6:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8038ed:	00 
  8038ee:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8038f2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8038f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038f9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8038fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  803901:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803908:	00 
  803909:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  803910:	e8 37 fc ff ff       	call   80354c <syscall>
}
  803915:	c9                   	leave  
  803916:	c3                   	ret    

00803917 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  803917:	55                   	push   %ebp
  803918:	89 e5                	mov    %esp,%ebp
  80391a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  80391d:	8b 45 08             	mov    0x8(%ebp),%eax
  803920:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  803927:	00 
  803928:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80392f:	00 
  803930:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  803937:	00 
  803938:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80393f:	00 
  803940:	89 44 24 08          	mov    %eax,0x8(%esp)
  803944:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80394b:	00 
  80394c:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  803953:	e8 f4 fb ff ff       	call   80354c <syscall>
}
  803958:	c9                   	leave  
  803959:	c3                   	ret    
	...

0080395c <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80395c:	55                   	push   %ebp
  80395d:	89 e5                	mov    %esp,%ebp
  80395f:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  803962:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803966:	75 11                	jne    803979 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  803968:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  80396f:	e8 a3 ff ff ff       	call   803917 <sys_ipc_recv>
  803974:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803977:	eb 0e                	jmp    803987 <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  803979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80397c:	89 04 24             	mov    %eax,(%esp)
  80397f:	e8 93 ff ff ff       	call   803917 <sys_ipc_recv>
  803984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  803987:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80398b:	79 1c                	jns    8039a9 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  80398d:	c7 44 24 08 e7 55 80 	movl   $0x8055e7,0x8(%esp)
  803994:	00 
  803995:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  80399c:	00 
  80399d:	c7 04 24 fd 55 80 00 	movl   $0x8055fd,(%esp)
  8039a4:	e8 db ec ff ff       	call   802684 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  8039a9:	e8 d0 fc ff ff       	call   80367e <sys_getenvid>
  8039ae:	25 ff 03 00 00       	and    $0x3ff,%eax
  8039b3:	c1 e0 07             	shl    $0x7,%eax
  8039b6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8039bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  8039be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039c2:	74 0b                	je     8039cf <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  8039c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c7:	8b 50 74             	mov    0x74(%eax),%edx
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  8039cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8039d3:	74 0b                	je     8039e0 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  8039d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d8:	8b 50 78             	mov    0x78(%eax),%edx
  8039db:	8b 45 10             	mov    0x10(%ebp),%eax
  8039de:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  8039e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e3:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  8039e6:	c9                   	leave  
  8039e7:	c3                   	ret    

008039e8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8039e8:	55                   	push   %ebp
  8039e9:	89 e5                	mov    %esp,%ebp
  8039eb:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  8039ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8039f2:	75 26                	jne    803a1a <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  8039f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8039f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039fb:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  803a02:	ee 
  803a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0d:	89 04 24             	mov    %eax,(%esp)
  803a10:	e8 c2 fe ff ff       	call   8038d7 <sys_ipc_try_send>
  803a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a18:	eb 23                	jmp    803a3d <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  803a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  803a1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a21:	8b 45 10             	mov    0x10(%ebp),%eax
  803a24:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a32:	89 04 24             	mov    %eax,(%esp)
  803a35:	e8 9d fe ff ff       	call   8038d7 <sys_ipc_try_send>
  803a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  803a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a41:	79 29                	jns    803a6c <ipc_send+0x84>
  803a43:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  803a47:	74 23                	je     803a6c <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  803a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a50:	c7 44 24 08 07 56 80 	movl   $0x805607,0x8(%esp)
  803a57:	00 
  803a58:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  803a5f:	00 
  803a60:	c7 04 24 fd 55 80 00 	movl   $0x8055fd,(%esp)
  803a67:	e8 18 ec ff ff       	call   802684 <_panic>
	    sys_yield();
  803a6c:	e8 51 fc ff ff       	call   8036c2 <sys_yield>
	}while(r < 0);
  803a71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a75:	0f 88 73 ff ff ff    	js     8039ee <ipc_send+0x6>
}
  803a7b:	c9                   	leave  
  803a7c:	c3                   	ret    
  803a7d:	00 00                	add    %al,(%eax)
	...

00803a80 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  803a80:	55                   	push   %ebp
  803a81:	89 e5                	mov    %esp,%ebp
  803a83:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  803a86:	8b 45 08             	mov    0x8(%ebp),%eax
  803a89:	89 04 24             	mov    %eax,(%esp)
  803a8c:	e8 0a 00 00 00       	call   803a9b <fd2num>
  803a91:	05 40 03 00 00       	add    $0x340,%eax
  803a96:	c1 e0 16             	shl    $0x16,%eax
}
  803a99:	c9                   	leave  
  803a9a:	c3                   	ret    

00803a9b <fd2num>:

int
fd2num(struct Fd *fd)
{
  803a9b:	55                   	push   %ebp
  803a9c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  803a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa1:	05 00 00 40 30       	add    $0x30400000,%eax
  803aa6:	c1 e8 0c             	shr    $0xc,%eax
}
  803aa9:	5d                   	pop    %ebp
  803aaa:	c3                   	ret    

00803aab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  803aab:	55                   	push   %ebp
  803aac:	89 e5                	mov    %esp,%ebp
  803aae:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  803ab1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803ab8:	eb 49                	jmp    803b03 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  803aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803abd:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  803ac2:	c1 e0 0c             	shl    $0xc,%eax
  803ac5:	89 c2                	mov    %eax,%edx
  803ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aca:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  803acc:	8b 45 08             	mov    0x8(%ebp),%eax
  803acf:	8b 00                	mov    (%eax),%eax
  803ad1:	c1 e8 16             	shr    $0x16,%eax
  803ad4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803adb:	83 e0 01             	and    $0x1,%eax
  803ade:	85 c0                	test   %eax,%eax
  803ae0:	74 16                	je     803af8 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  803ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae5:	8b 00                	mov    (%eax),%eax
  803ae7:	c1 e8 0c             	shr    $0xc,%eax
  803aea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803af1:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  803af4:	85 c0                	test   %eax,%eax
  803af6:	75 07                	jne    803aff <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  803af8:	b8 00 00 00 00       	mov    $0x0,%eax
  803afd:	eb 18                	jmp    803b17 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  803aff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  803b03:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  803b07:	7e b1                	jle    803aba <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  803b09:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  803b12:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  803b17:	c9                   	leave  
  803b18:	c3                   	ret    

00803b19 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803b19:	55                   	push   %ebp
  803b1a:	89 e5                	mov    %esp,%ebp
  803b1c:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  803b1f:	c7 44 24 08 1c 56 80 	movl   $0x80561c,0x8(%esp)
  803b26:	00 
  803b27:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  803b2e:	00 
  803b2f:	c7 04 24 36 56 80 00 	movl   $0x805636,(%esp)
  803b36:	e8 49 eb ff ff       	call   802684 <_panic>

00803b3b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  803b3b:	55                   	push   %ebp
  803b3c:	89 e5                	mov    %esp,%ebp
  803b3e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  803b41:	8b 45 08             	mov    0x8(%ebp),%eax
  803b44:	89 04 24             	mov    %eax,(%esp)
  803b47:	e8 4f ff ff ff       	call   803a9b <fd2num>
  803b4c:	8d 55 f0             	lea    -0x10(%ebp),%edx
  803b4f:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b53:	89 04 24             	mov    %eax,(%esp)
  803b56:	e8 be ff ff ff       	call   803b19 <fd_lookup>
  803b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b62:	78 08                	js     803b6c <fd_close+0x31>
	    || fd != fd2)
  803b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b67:	39 45 08             	cmp    %eax,0x8(%ebp)
  803b6a:	74 12                	je     803b7e <fd_close+0x43>
		return (must_exist ? r : 0);
  803b6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b70:	74 05                	je     803b77 <fd_close+0x3c>
  803b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b75:	eb 05                	jmp    803b7c <fd_close+0x41>
  803b77:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7c:	eb 44                	jmp    803bc2 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  803b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803b86:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b8a:	89 04 24             	mov    %eax,(%esp)
  803b8d:	e8 32 00 00 00       	call   803bc4 <dev_lookup>
  803b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b99:	78 11                	js     803bac <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  803b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b9e:	8b 50 10             	mov    0x10(%eax),%edx
  803ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba4:	89 04 24             	mov    %eax,(%esp)
  803ba7:	ff d2                	call   *%edx
  803ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803bac:	8b 45 08             	mov    0x8(%ebp),%eax
  803baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bb3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803bba:	e8 ce fb ff ff       	call   80378d <sys_page_unmap>
	return r;
  803bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803bc2:	c9                   	leave  
  803bc3:	c3                   	ret    

00803bc4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803bc4:	55                   	push   %ebp
  803bc5:	89 e5                	mov    %esp,%ebp
  803bc7:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  803bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803bd1:	eb 2b                	jmp    803bfe <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  803bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd6:	8b 04 85 2c c0 80 00 	mov    0x80c02c(,%eax,4),%eax
  803bdd:	8b 00                	mov    (%eax),%eax
  803bdf:	3b 45 08             	cmp    0x8(%ebp),%eax
  803be2:	75 16                	jne    803bfa <dev_lookup+0x36>
			*dev = devtab[i];
  803be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be7:	8b 14 85 2c c0 80 00 	mov    0x80c02c(,%eax,4),%edx
  803bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf1:	89 10                	mov    %edx,(%eax)
			return 0;
  803bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf8:	eb 3f                	jmp    803c39 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803bfa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  803bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c01:	8b 04 85 2c c0 80 00 	mov    0x80c02c(,%eax,4),%eax
  803c08:	85 c0                	test   %eax,%eax
  803c0a:	75 c7                	jne    803bd3 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  803c0c:	a1 68 c0 80 00       	mov    0x80c068,%eax
  803c11:	8b 40 4c             	mov    0x4c(%eax),%eax
  803c14:	8b 55 08             	mov    0x8(%ebp),%edx
  803c17:	89 54 24 08          	mov    %edx,0x8(%esp)
  803c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c1f:	c7 04 24 40 56 80 00 	movl   $0x805640,(%esp)
  803c26:	e8 8d eb ff ff       	call   8027b8 <cprintf>
	*dev = 0;
  803c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  803c34:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803c39:	c9                   	leave  
  803c3a:	c3                   	ret    

00803c3b <close>:

int
close(int fdnum)
{
  803c3b:	55                   	push   %ebp
  803c3c:	89 e5                	mov    %esp,%ebp
  803c3e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c41:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c48:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4b:	89 04 24             	mov    %eax,(%esp)
  803c4e:	e8 c6 fe ff ff       	call   803b19 <fd_lookup>
  803c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c5a:	79 05                	jns    803c61 <close+0x26>
		return r;
  803c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5f:	eb 13                	jmp    803c74 <close+0x39>
	else
		return fd_close(fd, 1);
  803c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c64:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803c6b:	00 
  803c6c:	89 04 24             	mov    %eax,(%esp)
  803c6f:	e8 c7 fe ff ff       	call   803b3b <fd_close>
}
  803c74:	c9                   	leave  
  803c75:	c3                   	ret    

00803c76 <close_all>:

void
close_all(void)
{
  803c76:	55                   	push   %ebp
  803c77:	89 e5                	mov    %esp,%ebp
  803c79:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  803c7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803c83:	eb 0f                	jmp    803c94 <close_all+0x1e>
		close(i);
  803c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c88:	89 04 24             	mov    %eax,(%esp)
  803c8b:	e8 ab ff ff ff       	call   803c3b <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803c90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  803c94:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  803c98:	7e eb                	jle    803c85 <close_all+0xf>
		close(i);
}
  803c9a:	c9                   	leave  
  803c9b:	c3                   	ret    

00803c9c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803c9c:	55                   	push   %ebp
  803c9d:	89 e5                	mov    %esp,%ebp
  803c9f:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803ca2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  803ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cac:	89 04 24             	mov    %eax,(%esp)
  803caf:	e8 65 fe ff ff       	call   803b19 <fd_lookup>
  803cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803cb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cbb:	79 08                	jns    803cc5 <dup+0x29>
		return r;
  803cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc0:	e9 54 01 00 00       	jmp    803e19 <dup+0x17d>
	close(newfdnum);
  803cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc8:	89 04 24             	mov    %eax,(%esp)
  803ccb:	e8 6b ff ff ff       	call   803c3b <close>

	newfd = INDEX2FD(newfdnum);
  803cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd3:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  803cd8:	c1 e0 0c             	shl    $0xc,%eax
  803cdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  803cde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ce1:	89 04 24             	mov    %eax,(%esp)
  803ce4:	e8 97 fd ff ff       	call   803a80 <fd2data>
  803ce9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  803cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cef:	89 04 24             	mov    %eax,(%esp)
  803cf2:	e8 89 fd ff ff       	call   803a80 <fd2data>
  803cf7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  803cfa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cfd:	c1 e8 0c             	shr    $0xc,%eax
  803d00:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803d07:	89 c2                	mov    %eax,%edx
  803d09:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  803d0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d12:	89 54 24 10          	mov    %edx,0x10(%esp)
  803d16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d19:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803d1d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803d24:	00 
  803d25:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d30:	e8 12 fa ff ff       	call   803747 <sys_page_map>
  803d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d3c:	0f 88 8e 00 00 00    	js     803dd0 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  803d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d45:	c1 e8 16             	shr    $0x16,%eax
  803d48:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  803d4f:	85 c0                	test   %eax,%eax
  803d51:	74 78                	je     803dcb <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  803d53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803d5a:	eb 66                	jmp    803dc2 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  803d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5f:	03 45 e8             	add    -0x18(%ebp),%eax
  803d62:	c1 e8 0c             	shr    $0xc,%eax
  803d65:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803d6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  803d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d72:	83 e0 01             	and    $0x1,%eax
  803d75:	84 c0                	test   %al,%al
  803d77:	74 42                	je     803dbb <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  803d79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d7c:	89 c1                	mov    %eax,%ecx
  803d7e:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  803d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d87:	89 c2                	mov    %eax,%edx
  803d89:	03 55 e4             	add    -0x1c(%ebp),%edx
  803d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8f:	03 45 e8             	add    -0x18(%ebp),%eax
  803d92:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803d96:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803d9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803da1:	00 
  803da2:	89 44 24 04          	mov    %eax,0x4(%esp)
  803da6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803dad:	e8 95 f9 ff ff       	call   803747 <sys_page_map>
  803db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803db5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803db9:	78 18                	js     803dd3 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  803dbb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  803dc2:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  803dc9:	7e 91                	jle    803d5c <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  803dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dce:	eb 49                	jmp    803e19 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  803dd0:	90                   	nop
  803dd1:	eb 01                	jmp    803dd4 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  803dd3:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ddb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803de2:	e8 a6 f9 ff ff       	call   80378d <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  803de7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803dee:	eb 1d                	jmp    803e0d <dup+0x171>
		sys_page_unmap(0, nva + i);
  803df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df3:	03 45 e4             	add    -0x1c(%ebp),%eax
  803df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e01:	e8 87 f9 ff ff       	call   80378d <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  803e06:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  803e0d:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  803e14:	7e da                	jle    803df0 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  803e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803e19:	c9                   	leave  
  803e1a:	c3                   	ret    

00803e1b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803e1b:	55                   	push   %ebp
  803e1c:	89 e5                	mov    %esp,%ebp
  803e1e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803e21:	8d 45 ec             	lea    -0x14(%ebp),%eax
  803e24:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e28:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2b:	89 04 24             	mov    %eax,(%esp)
  803e2e:	e8 e6 fc ff ff       	call   803b19 <fd_lookup>
  803e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e3a:	78 1d                	js     803e59 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e3f:	8b 00                	mov    (%eax),%eax
  803e41:	8d 55 f0             	lea    -0x10(%ebp),%edx
  803e44:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e48:	89 04 24             	mov    %eax,(%esp)
  803e4b:	e8 74 fd ff ff       	call   803bc4 <dev_lookup>
  803e50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e57:	79 05                	jns    803e5e <read+0x43>
		return r;
  803e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5c:	eb 75                	jmp    803ed3 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e61:	8b 40 08             	mov    0x8(%eax),%eax
  803e64:	83 e0 03             	and    $0x3,%eax
  803e67:	83 f8 01             	cmp    $0x1,%eax
  803e6a:	75 26                	jne    803e92 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  803e6c:	a1 68 c0 80 00       	mov    0x80c068,%eax
  803e71:	8b 40 4c             	mov    0x4c(%eax),%eax
  803e74:	8b 55 08             	mov    0x8(%ebp),%edx
  803e77:	89 54 24 08          	mov    %edx,0x8(%esp)
  803e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e7f:	c7 04 24 5f 56 80 00 	movl   $0x80565f,(%esp)
  803e86:	e8 2d e9 ff ff       	call   8027b8 <cprintf>
		return -E_INVAL;
  803e8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e90:	eb 41                	jmp    803ed3 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  803e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e95:	8b 48 08             	mov    0x8(%eax),%ecx
  803e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e9b:	8b 50 04             	mov    0x4(%eax),%edx
  803e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ea1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803ea5:	8b 55 10             	mov    0x10(%ebp),%edx
  803ea8:	89 54 24 08          	mov    %edx,0x8(%esp)
  803eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  803eaf:	89 54 24 04          	mov    %edx,0x4(%esp)
  803eb3:	89 04 24             	mov    %eax,(%esp)
  803eb6:	ff d1                	call   *%ecx
  803eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  803ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ebf:	78 0f                	js     803ed0 <read+0xb5>
		fd->fd_offset += r;
  803ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ec4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ec7:	8b 52 04             	mov    0x4(%edx),%edx
  803eca:	03 55 f4             	add    -0xc(%ebp),%edx
  803ecd:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  803ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803ed3:	c9                   	leave  
  803ed4:	c3                   	ret    

00803ed5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803ed5:	55                   	push   %ebp
  803ed6:	89 e5                	mov    %esp,%ebp
  803ed8:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803ee2:	eb 3b                	jmp    803f1f <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee7:	8b 55 10             	mov    0x10(%ebp),%edx
  803eea:	29 c2                	sub    %eax,%edx
  803eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eef:	03 45 0c             	add    0xc(%ebp),%eax
  803ef2:	89 54 24 08          	mov    %edx,0x8(%esp)
  803ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
  803efa:	8b 45 08             	mov    0x8(%ebp),%eax
  803efd:	89 04 24             	mov    %eax,(%esp)
  803f00:	e8 16 ff ff ff       	call   803e1b <read>
  803f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  803f08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f0c:	79 05                	jns    803f13 <readn+0x3e>
			return m;
  803f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f11:	eb 1a                	jmp    803f2d <readn+0x58>
		if (m == 0)
  803f13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f17:	74 10                	je     803f29 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f1c:	01 45 f4             	add    %eax,-0xc(%ebp)
  803f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f22:	3b 45 10             	cmp    0x10(%ebp),%eax
  803f25:	72 bd                	jb     803ee4 <readn+0xf>
  803f27:	eb 01                	jmp    803f2a <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803f29:	90                   	nop
	}
	return tot;
  803f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803f2d:	c9                   	leave  
  803f2e:	c3                   	ret    

00803f2f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803f2f:	55                   	push   %ebp
  803f30:	89 e5                	mov    %esp,%ebp
  803f32:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803f35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  803f38:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3f:	89 04 24             	mov    %eax,(%esp)
  803f42:	e8 d2 fb ff ff       	call   803b19 <fd_lookup>
  803f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f4e:	78 1d                	js     803f6d <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f53:	8b 00                	mov    (%eax),%eax
  803f55:	8d 55 f0             	lea    -0x10(%ebp),%edx
  803f58:	89 54 24 04          	mov    %edx,0x4(%esp)
  803f5c:	89 04 24             	mov    %eax,(%esp)
  803f5f:	e8 60 fc ff ff       	call   803bc4 <dev_lookup>
  803f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f6b:	79 05                	jns    803f72 <write+0x43>
		return r;
  803f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f70:	eb 74                	jmp    803fe6 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f75:	8b 40 08             	mov    0x8(%eax),%eax
  803f78:	83 e0 03             	and    $0x3,%eax
  803f7b:	85 c0                	test   %eax,%eax
  803f7d:	75 26                	jne    803fa5 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  803f7f:	a1 68 c0 80 00       	mov    0x80c068,%eax
  803f84:	8b 40 4c             	mov    0x4c(%eax),%eax
  803f87:	8b 55 08             	mov    0x8(%ebp),%edx
  803f8a:	89 54 24 08          	mov    %edx,0x8(%esp)
  803f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f92:	c7 04 24 7b 56 80 00 	movl   $0x80567b,(%esp)
  803f99:	e8 1a e8 ff ff       	call   8027b8 <cprintf>
		return -E_INVAL;
  803f9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803fa3:	eb 41                	jmp    803fe6 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  803fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa8:	8b 48 0c             	mov    0xc(%eax),%ecx
  803fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fae:	8b 50 04             	mov    0x4(%eax),%edx
  803fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fb4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803fb8:	8b 55 10             	mov    0x10(%ebp),%edx
  803fbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  803fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  803fc2:	89 54 24 04          	mov    %edx,0x4(%esp)
  803fc6:	89 04 24             	mov    %eax,(%esp)
  803fc9:	ff d1                	call   *%ecx
  803fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  803fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fd2:	7e 0f                	jle    803fe3 <write+0xb4>
		fd->fd_offset += r;
  803fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fda:	8b 52 04             	mov    0x4(%edx),%edx
  803fdd:	03 55 f4             	add    -0xc(%ebp),%edx
  803fe0:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  803fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803fe6:	c9                   	leave  
  803fe7:	c3                   	ret    

00803fe8 <seek>:

int
seek(int fdnum, off_t offset)
{
  803fe8:	55                   	push   %ebp
  803fe9:	89 e5                	mov    %esp,%ebp
  803feb:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff8:	89 04 24             	mov    %eax,(%esp)
  803ffb:	e8 19 fb ff ff       	call   803b19 <fd_lookup>
  804000:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804007:	79 05                	jns    80400e <seek+0x26>
		return r;
  804009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400c:	eb 0e                	jmp    80401c <seek+0x34>
	fd->fd_offset = offset;
  80400e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804011:	8b 55 0c             	mov    0xc(%ebp),%edx
  804014:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  804017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80401c:	c9                   	leave  
  80401d:	c3                   	ret    

0080401e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80401e:	55                   	push   %ebp
  80401f:	89 e5                	mov    %esp,%ebp
  804021:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  804024:	8d 45 ec             	lea    -0x14(%ebp),%eax
  804027:	89 44 24 04          	mov    %eax,0x4(%esp)
  80402b:	8b 45 08             	mov    0x8(%ebp),%eax
  80402e:	89 04 24             	mov    %eax,(%esp)
  804031:	e8 e3 fa ff ff       	call   803b19 <fd_lookup>
  804036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80403d:	78 1d                	js     80405c <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80403f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804042:	8b 00                	mov    (%eax),%eax
  804044:	8d 55 f0             	lea    -0x10(%ebp),%edx
  804047:	89 54 24 04          	mov    %edx,0x4(%esp)
  80404b:	89 04 24             	mov    %eax,(%esp)
  80404e:	e8 71 fb ff ff       	call   803bc4 <dev_lookup>
  804053:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804056:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80405a:	79 05                	jns    804061 <ftruncate+0x43>
		return r;
  80405c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80405f:	eb 48                	jmp    8040a9 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  804061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804064:	8b 40 08             	mov    0x8(%eax),%eax
  804067:	83 e0 03             	and    $0x3,%eax
  80406a:	85 c0                	test   %eax,%eax
  80406c:	75 26                	jne    804094 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  80406e:	a1 68 c0 80 00       	mov    0x80c068,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  804073:	8b 40 4c             	mov    0x4c(%eax),%eax
  804076:	8b 55 08             	mov    0x8(%ebp),%edx
  804079:	89 54 24 08          	mov    %edx,0x8(%esp)
  80407d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804081:	c7 04 24 98 56 80 00 	movl   $0x805698,(%esp)
  804088:	e8 2b e7 ff ff       	call   8027b8 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  80408d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804092:	eb 15                	jmp    8040a9 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  804094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804097:	8b 48 1c             	mov    0x1c(%eax),%ecx
  80409a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80409d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8040a4:	89 04 24             	mov    %eax,(%esp)
  8040a7:	ff d1                	call   *%ecx
}
  8040a9:	c9                   	leave  
  8040aa:	c3                   	ret    

008040ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8040ab:	55                   	push   %ebp
  8040ac:	89 e5                	mov    %esp,%ebp
  8040ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8040b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8040b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bb:	89 04 24             	mov    %eax,(%esp)
  8040be:	e8 56 fa ff ff       	call   803b19 <fd_lookup>
  8040c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040ca:	78 1d                	js     8040e9 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8040cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040cf:	8b 00                	mov    (%eax),%eax
  8040d1:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8040d4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8040d8:	89 04 24             	mov    %eax,(%esp)
  8040db:	e8 e4 fa ff ff       	call   803bc4 <dev_lookup>
  8040e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040e7:	79 05                	jns    8040ee <fstat+0x43>
		return r;
  8040e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ec:	eb 41                	jmp    80412f <fstat+0x84>
	stat->st_name[0] = 0;
  8040ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040f1:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  8040f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040f7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  8040fe:	00 00 00 
	stat->st_isdir = 0;
  804101:	8b 45 0c             	mov    0xc(%ebp),%eax
  804104:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  80410b:	00 00 00 
	stat->st_dev = dev;
  80410e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804111:	8b 45 0c             	mov    0xc(%ebp),%eax
  804114:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  80411a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80411d:	8b 48 14             	mov    0x14(%eax),%ecx
  804120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804123:	8b 55 0c             	mov    0xc(%ebp),%edx
  804126:	89 54 24 04          	mov    %edx,0x4(%esp)
  80412a:	89 04 24             	mov    %eax,(%esp)
  80412d:	ff d1                	call   *%ecx
}
  80412f:	c9                   	leave  
  804130:	c3                   	ret    

00804131 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  804131:	55                   	push   %ebp
  804132:	89 e5                	mov    %esp,%ebp
  804134:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  804137:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80413e:	00 
  80413f:	8b 45 08             	mov    0x8(%ebp),%eax
  804142:	89 04 24             	mov    %eax,(%esp)
  804145:	e8 36 00 00 00       	call   804180 <open>
  80414a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80414d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804151:	79 05                	jns    804158 <stat+0x27>
		return fd;
  804153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804156:	eb 23                	jmp    80417b <stat+0x4a>
	r = fstat(fd, stat);
  804158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80415b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80415f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804162:	89 04 24             	mov    %eax,(%esp)
  804165:	e8 41 ff ff ff       	call   8040ab <fstat>
  80416a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  80416d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804170:	89 04 24             	mov    %eax,(%esp)
  804173:	e8 c3 fa ff ff       	call   803c3b <close>
	return r;
  804178:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80417b:	c9                   	leave  
  80417c:	c3                   	ret    
  80417d:	00 00                	add    %al,(%eax)
	...

00804180 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  804180:	55                   	push   %ebp
  804181:	89 e5                	mov    %esp,%ebp
  804183:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  804186:	8d 45 f0             	lea    -0x10(%ebp),%eax
  804189:	89 04 24             	mov    %eax,(%esp)
  80418c:	e8 1a f9 ff ff       	call   803aab <fd_alloc>
  804191:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804194:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804198:	79 05                	jns    80419f <open+0x1f>
  80419a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80419d:	eb 73                	jmp    804212 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  80419f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8041a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b0:	89 04 24             	mov    %eax,(%esp)
  8041b3:	e8 54 05 00 00       	call   80470c <fsipc_open>
  8041b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041bf:	79 05                	jns    8041c6 <open+0x46>
  8041c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041c4:	eb 4c                	jmp    804212 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  8041c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041c9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8041cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041d2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8041d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8041dd:	00 
  8041de:	89 04 24             	mov    %eax,(%esp)
  8041e1:	e8 25 03 00 00       	call   80450b <fmap>
  8041e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041ed:	79 18                	jns    804207 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  8041ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8041f9:	00 
  8041fa:	89 04 24             	mov    %eax,(%esp)
  8041fd:	e8 39 f9 ff ff       	call   803b3b <fd_close>
  804202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804205:	eb 0b                	jmp    804212 <open+0x92>
	return fd2num(fd);
  804207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80420a:	89 04 24             	mov    %eax,(%esp)
  80420d:	e8 89 f8 ff ff       	call   803a9b <fd2num>
	//panic("open() unimplemented!");
}
  804212:	c9                   	leave  
  804213:	c3                   	ret    

00804214 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  804214:	55                   	push   %ebp
  804215:	89 e5                	mov    %esp,%ebp
  804217:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  80421a:	8b 45 08             	mov    0x8(%ebp),%eax
  80421d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  804223:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  80422a:	00 
  80422b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804232:	00 
  804233:	89 44 24 04          	mov    %eax,0x4(%esp)
  804237:	8b 45 08             	mov    0x8(%ebp),%eax
  80423a:	89 04 24             	mov    %eax,(%esp)
  80423d:	e8 72 03 00 00       	call   8045b4 <funmap>
  804242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804249:	79 05                	jns    804250 <file_close+0x3c>
  80424b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80424e:	eb 21                	jmp    804271 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  804250:	8b 45 08             	mov    0x8(%ebp),%eax
  804253:	8b 40 0c             	mov    0xc(%eax),%eax
  804256:	89 04 24             	mov    %eax,(%esp)
  804259:	e8 e3 05 00 00       	call   804841 <fsipc_close>
  80425e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804265:	79 05                	jns    80426c <file_close+0x58>
  804267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80426a:	eb 05                	jmp    804271 <file_close+0x5d>
	return 0;
  80426c:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  804271:	c9                   	leave  
  804272:	c3                   	ret    

00804273 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  804273:	55                   	push   %ebp
  804274:	89 e5                	mov    %esp,%ebp
  804276:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  804279:	8b 45 08             	mov    0x8(%ebp),%eax
  80427c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  804282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  804285:	8b 45 14             	mov    0x14(%ebp),%eax
  804288:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80428b:	76 07                	jbe    804294 <file_read+0x21>
		return 0;
  80428d:	b8 00 00 00 00       	mov    $0x0,%eax
  804292:	eb 43                	jmp    8042d7 <file_read+0x64>
	if (offset + n > size)
  804294:	8b 45 14             	mov    0x14(%ebp),%eax
  804297:	03 45 10             	add    0x10(%ebp),%eax
  80429a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80429d:	76 0f                	jbe    8042ae <file_read+0x3b>
		n = size - offset;
  80429f:	8b 45 14             	mov    0x14(%ebp),%eax
  8042a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042a5:	89 d1                	mov    %edx,%ecx
  8042a7:	29 c1                	sub    %eax,%ecx
  8042a9:	89 c8                	mov    %ecx,%eax
  8042ab:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  8042ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b1:	89 04 24             	mov    %eax,(%esp)
  8042b4:	e8 c7 f7 ff ff       	call   803a80 <fd2data>
  8042b9:	8b 55 14             	mov    0x14(%ebp),%edx
  8042bc:	01 c2                	add    %eax,%edx
  8042be:	8b 45 10             	mov    0x10(%ebp),%eax
  8042c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8042c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8042c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042cc:	89 04 24             	mov    %eax,(%esp)
  8042cf:	e8 e8 ef ff ff       	call   8032bc <memmove>
	return n;
  8042d4:	8b 45 10             	mov    0x10(%ebp),%eax
}
  8042d7:	c9                   	leave  
  8042d8:	c3                   	ret    

008042d9 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8042d9:	55                   	push   %ebp
  8042da:	89 e5                	mov    %esp,%ebp
  8042dc:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042df:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8042e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e9:	89 04 24             	mov    %eax,(%esp)
  8042ec:	e8 28 f8 ff ff       	call   803b19 <fd_lookup>
  8042f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042f8:	79 05                	jns    8042ff <read_map+0x26>
		return r;
  8042fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042fd:	eb 74                	jmp    804373 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  8042ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804302:	8b 10                	mov    (%eax),%edx
  804304:	a1 40 c0 80 00       	mov    0x80c040,%eax
  804309:	39 c2                	cmp    %eax,%edx
  80430b:	74 07                	je     804314 <read_map+0x3b>
		return -E_INVAL;
  80430d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804312:	eb 5f                	jmp    804373 <read_map+0x9a>
	va = fd2data(fd) + offset;
  804314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804317:	89 04 24             	mov    %eax,(%esp)
  80431a:	e8 61 f7 ff ff       	call   803a80 <fd2data>
  80431f:	8b 55 0c             	mov    0xc(%ebp),%edx
  804322:	01 d0                	add    %edx,%eax
  804324:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  804327:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  80432e:	7e 07                	jle    804337 <read_map+0x5e>
		return -E_NO_DISK;
  804330:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804335:	eb 3c                	jmp    804373 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  804337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80433a:	c1 e8 16             	shr    $0x16,%eax
  80433d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  804344:	83 e0 01             	and    $0x1,%eax
  804347:	85 c0                	test   %eax,%eax
  804349:	74 14                	je     80435f <read_map+0x86>
  80434b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80434e:	c1 e8 0c             	shr    $0xc,%eax
  804351:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  804358:	83 e0 01             	and    $0x1,%eax
  80435b:	85 c0                	test   %eax,%eax
  80435d:	75 07                	jne    804366 <read_map+0x8d>
		return -E_NO_DISK;
  80435f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804364:	eb 0d                	jmp    804373 <read_map+0x9a>
	*blk = (void*) va;
  804366:	8b 45 10             	mov    0x10(%ebp),%eax
  804369:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80436c:	89 10                	mov    %edx,(%eax)
	return 0;
  80436e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804373:	c9                   	leave  
  804374:	c3                   	ret    

00804375 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  804375:	55                   	push   %ebp
  804376:	89 e5                	mov    %esp,%ebp
  804378:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  80437b:	8b 45 14             	mov    0x14(%ebp),%eax
  80437e:	03 45 10             	add    0x10(%ebp),%eax
  804381:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  804384:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  80438b:	76 07                	jbe    804394 <file_write+0x1f>
		return -E_NO_DISK;
  80438d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804392:	eb 57                	jmp    8043eb <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  804394:	8b 45 08             	mov    0x8(%ebp),%eax
  804397:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80439d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8043a0:	73 20                	jae    8043c2 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  8043a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8043ac:	89 04 24             	mov    %eax,(%esp)
  8043af:	e8 88 00 00 00       	call   80443c <file_trunc>
  8043b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8043b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8043bb:	79 05                	jns    8043c2 <file_write+0x4d>
			return r;
  8043bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043c0:	eb 29                	jmp    8043eb <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  8043c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8043c5:	89 04 24             	mov    %eax,(%esp)
  8043c8:	e8 b3 f6 ff ff       	call   803a80 <fd2data>
  8043cd:	8b 55 14             	mov    0x14(%ebp),%edx
  8043d0:	01 c2                	add    %eax,%edx
  8043d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8043d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8043d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043e0:	89 14 24             	mov    %edx,(%esp)
  8043e3:	e8 d4 ee ff ff       	call   8032bc <memmove>
	return n;
  8043e8:	8b 45 10             	mov    0x10(%ebp),%eax
}
  8043eb:	c9                   	leave  
  8043ec:	c3                   	ret    

008043ed <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  8043ed:	55                   	push   %ebp
  8043ee:	89 e5                	mov    %esp,%ebp
  8043f0:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  8043f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043f6:	8d 50 10             	lea    0x10(%eax),%edx
  8043f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  804400:	89 04 24             	mov    %eax,(%esp)
  804403:	e8 c2 ec ff ff       	call   8030ca <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  804408:	8b 45 08             	mov    0x8(%ebp),%eax
  80440b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  804411:	8b 45 0c             	mov    0xc(%ebp),%eax
  804414:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  80441a:	8b 45 08             	mov    0x8(%ebp),%eax
  80441d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  804423:	83 f8 01             	cmp    $0x1,%eax
  804426:	0f 94 c0             	sete   %al
  804429:	0f b6 d0             	movzbl %al,%edx
  80442c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80442f:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  804435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80443a:	c9                   	leave  
  80443b:	c3                   	ret    

0080443c <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  80443c:	55                   	push   %ebp
  80443d:	89 e5                	mov    %esp,%ebp
  80443f:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  804442:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  804449:	7e 0a                	jle    804455 <file_trunc+0x19>
		return -E_NO_DISK;
  80444b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804450:	e9 b4 00 00 00       	jmp    804509 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  804455:	8b 45 08             	mov    0x8(%ebp),%eax
  804458:	8b 40 0c             	mov    0xc(%eax),%eax
  80445b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  80445e:	8b 45 08             	mov    0x8(%ebp),%eax
  804461:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  804467:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  80446a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80446d:	8b 55 0c             	mov    0xc(%ebp),%edx
  804470:	89 54 24 04          	mov    %edx,0x4(%esp)
  804474:	89 04 24             	mov    %eax,(%esp)
  804477:	e8 82 03 00 00       	call   8047fe <fsipc_set_size>
  80447c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80447f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804483:	79 05                	jns    80448a <file_trunc+0x4e>
		return r;
  804485:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804488:	eb 7f                	jmp    804509 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  80448a:	8b 45 08             	mov    0x8(%ebp),%eax
  80448d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  804493:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804496:	74 24                	je     8044bc <file_trunc+0x80>
  804498:	c7 44 24 0c c4 56 80 	movl   $0x8056c4,0xc(%esp)
  80449f:	00 
  8044a0:	c7 44 24 08 e7 56 80 	movl   $0x8056e7,0x8(%esp)
  8044a7:	00 
  8044a8:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8044af:	00 
  8044b0:	c7 04 24 fc 56 80 00 	movl   $0x8056fc,(%esp)
  8044b7:	e8 c8 e1 ff ff       	call   802684 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  8044bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8044c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8044cd:	89 04 24             	mov    %eax,(%esp)
  8044d0:	e8 36 00 00 00       	call   80450b <fmap>
  8044d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8044d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8044dc:	79 05                	jns    8044e3 <file_trunc+0xa7>
		return r;
  8044de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044e1:	eb 26                	jmp    804509 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  8044e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8044ea:	00 
  8044eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8044f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8044fc:	89 04 24             	mov    %eax,(%esp)
  8044ff:	e8 b0 00 00 00       	call   8045b4 <funmap>

	return 0;
  804504:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804509:	c9                   	leave  
  80450a:	c3                   	ret    

0080450b <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  80450b:	55                   	push   %ebp
  80450c:	89 e5                	mov    %esp,%ebp
  80450e:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  804511:	8b 45 08             	mov    0x8(%ebp),%eax
  804514:	89 04 24             	mov    %eax,(%esp)
  804517:	e8 64 f5 ff ff       	call   803a80 <fd2data>
  80451c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80451f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  804526:	8b 45 0c             	mov    0xc(%ebp),%eax
  804529:	03 45 ec             	add    -0x14(%ebp),%eax
  80452c:	83 e8 01             	sub    $0x1,%eax
  80452f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804535:	ba 00 00 00 00       	mov    $0x0,%edx
  80453a:	f7 75 ec             	divl   -0x14(%ebp)
  80453d:	89 d0                	mov    %edx,%eax
  80453f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804542:	89 d1                	mov    %edx,%ecx
  804544:	29 c1                	sub    %eax,%ecx
  804546:	89 c8                	mov    %ecx,%eax
  804548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80454b:	eb 58                	jmp    8045a5 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  80454d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804553:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  804556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804559:	8b 45 08             	mov    0x8(%ebp),%eax
  80455c:	8b 40 0c             	mov    0xc(%eax),%eax
  80455f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804563:	89 54 24 04          	mov    %edx,0x4(%esp)
  804567:	89 04 24             	mov    %eax,(%esp)
  80456a:	e8 04 02 00 00       	call   804773 <fsipc_map>
  80456f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804572:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804576:	79 26                	jns    80459e <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  804578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80457b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  804582:	00 
  804583:	8b 55 0c             	mov    0xc(%ebp),%edx
  804586:	89 54 24 08          	mov    %edx,0x8(%esp)
  80458a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80458e:	8b 45 08             	mov    0x8(%ebp),%eax
  804591:	89 04 24             	mov    %eax,(%esp)
  804594:	e8 1b 00 00 00       	call   8045b4 <funmap>
			return r;
  804599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80459c:	eb 14                	jmp    8045b2 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80459e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8045a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8045a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8045ab:	77 a0                	ja     80454d <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  8045ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045b2:	c9                   	leave  
  8045b3:	c3                   	ret    

008045b4 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  8045b4:	55                   	push   %ebp
  8045b5:	89 e5                	mov    %esp,%ebp
  8045b7:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  8045ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8045bd:	89 04 24             	mov    %eax,(%esp)
  8045c0:	e8 bb f4 ff ff       	call   803a80 <fd2data>
  8045c5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  8045c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045cb:	c1 e8 16             	shr    $0x16,%eax
  8045ce:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8045d5:	83 e0 01             	and    $0x1,%eax
  8045d8:	85 c0                	test   %eax,%eax
  8045da:	75 0a                	jne    8045e6 <funmap+0x32>
		return 0;
  8045dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8045e1:	e9 bf 00 00 00       	jmp    8046a5 <funmap+0xf1>

	ret = 0;
  8045e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8045ed:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8045f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8045f7:	03 45 e8             	add    -0x18(%ebp),%eax
  8045fa:	83 e8 01             	sub    $0x1,%eax
  8045fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804603:	ba 00 00 00 00       	mov    $0x0,%edx
  804608:	f7 75 e8             	divl   -0x18(%ebp)
  80460b:	89 d0                	mov    %edx,%eax
  80460d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804610:	89 d1                	mov    %edx,%ecx
  804612:	29 c1                	sub    %eax,%ecx
  804614:	89 c8                	mov    %ecx,%eax
  804616:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804619:	eb 7b                	jmp    804696 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  80461b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80461e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804621:	01 d0                	add    %edx,%eax
  804623:	c1 e8 0c             	shr    $0xc,%eax
  804626:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80462d:	83 e0 01             	and    $0x1,%eax
  804630:	84 c0                	test   %al,%al
  804632:	74 5b                	je     80468f <funmap+0xdb>
			if (dirty
  804634:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  804638:	74 3d                	je     804677 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  80463a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80463d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804640:	01 d0                	add    %edx,%eax
  804642:	c1 e8 0c             	shr    $0xc,%eax
  804645:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80464c:	83 e0 40             	and    $0x40,%eax
  80464f:	85 c0                	test   %eax,%eax
  804651:	74 24                	je     804677 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  804653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804656:	8b 45 08             	mov    0x8(%ebp),%eax
  804659:	8b 40 0c             	mov    0xc(%eax),%eax
  80465c:	89 54 24 04          	mov    %edx,0x4(%esp)
  804660:	89 04 24             	mov    %eax,(%esp)
  804663:	e8 13 02 00 00       	call   80487b <fsipc_dirty>
  804668:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80466b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80466f:	79 06                	jns    804677 <funmap+0xc3>
				ret = r;
  804671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804674:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  804677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80467a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80467d:	01 d0                	add    %edx,%eax
  80467f:	89 44 24 04          	mov    %eax,0x4(%esp)
  804683:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80468a:	e8 fe f0 ff ff       	call   80378d <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  80468f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  804696:	8b 45 0c             	mov    0xc(%ebp),%eax
  804699:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80469c:	0f 87 79 ff ff ff    	ja     80461b <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  8046a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8046a5:	c9                   	leave  
  8046a6:	c3                   	ret    

008046a7 <remove>:

// Delete a file
int
remove(const char *path)
{
  8046a7:	55                   	push   %ebp
  8046a8:	89 e5                	mov    %esp,%ebp
  8046aa:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  8046ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8046b0:	89 04 24             	mov    %eax,(%esp)
  8046b3:	e8 06 02 00 00       	call   8048be <fsipc_remove>
}
  8046b8:	c9                   	leave  
  8046b9:	c3                   	ret    

008046ba <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8046ba:	55                   	push   %ebp
  8046bb:	89 e5                	mov    %esp,%ebp
  8046bd:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  8046c0:	e8 56 02 00 00       	call   80491b <fsipc_sync>
}
  8046c5:	c9                   	leave  
  8046c6:	c3                   	ret    
	...

008046c8 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  8046c8:	55                   	push   %ebp
  8046c9:	89 e5                	mov    %esp,%ebp
  8046cb:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  8046ce:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  8046d3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8046da:	00 
  8046db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8046de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8046e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8046e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8046e9:	89 04 24             	mov    %eax,(%esp)
  8046ec:	e8 f7 f2 ff ff       	call   8039e8 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  8046f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8046f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8046f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8046fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8046ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804702:	89 04 24             	mov    %eax,(%esp)
  804705:	e8 52 f2 ff ff       	call   80395c <ipc_recv>
}
  80470a:	c9                   	leave  
  80470b:	c3                   	ret    

0080470c <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  80470c:	55                   	push   %ebp
  80470d:	89 e5                	mov    %esp,%ebp
  80470f:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  804712:	c7 45 f4 00 60 80 00 	movl   $0x806000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  804719:	8b 45 08             	mov    0x8(%ebp),%eax
  80471c:	89 04 24             	mov    %eax,(%esp)
  80471f:	e8 50 e9 ff ff       	call   803074 <strlen>
  804724:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  804729:	7e 07                	jle    804732 <fsipc_open+0x26>
		return -E_BAD_PATH;
  80472b:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  804730:	eb 3f                	jmp    804771 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  804732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804735:	8b 55 08             	mov    0x8(%ebp),%edx
  804738:	89 54 24 04          	mov    %edx,0x4(%esp)
  80473c:	89 04 24             	mov    %eax,(%esp)
  80473f:	e8 86 e9 ff ff       	call   8030ca <strcpy>
	req->req_omode = omode;
  804744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80474a:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  804750:	8d 45 f0             	lea    -0x10(%ebp),%eax
  804753:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804757:	8b 45 10             	mov    0x10(%ebp),%eax
  80475a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804761:	89 44 24 04          	mov    %eax,0x4(%esp)
  804765:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80476c:	e8 57 ff ff ff       	call   8046c8 <fsipc>
}
  804771:	c9                   	leave  
  804772:	c3                   	ret    

00804773 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  804773:	55                   	push   %ebp
  804774:	89 e5                	mov    %esp,%ebp
  804776:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  804779:	c7 45 f4 00 60 80 00 	movl   $0x806000,-0xc(%ebp)
	req->req_fileid = fileid;
  804780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804783:	8b 55 08             	mov    0x8(%ebp),%edx
  804786:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  804788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80478b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80478e:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  804791:	8d 45 ec             	lea    -0x14(%ebp),%eax
  804794:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804798:	8b 45 10             	mov    0x10(%ebp),%eax
  80479b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8047a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047a6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8047ad:	e8 16 ff ff ff       	call   8046c8 <fsipc>
  8047b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8047b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8047b9:	79 05                	jns    8047c0 <fsipc_map+0x4d>
		return r;
  8047bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8047be:	eb 3c                	jmp    8047fc <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  8047c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047c3:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  8047c8:	83 f8 05             	cmp    $0x5,%eax
  8047cb:	74 2a                	je     8047f7 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  8047cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047d0:	8b 55 10             	mov    0x10(%ebp),%edx
  8047d3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8047d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8047db:	c7 44 24 08 08 57 80 	movl   $0x805708,0x8(%esp)
  8047e2:	00 
  8047e3:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  8047ea:	00 
  8047eb:	c7 04 24 3e 57 80 00 	movl   $0x80573e,(%esp)
  8047f2:	e8 8d de ff ff       	call   802684 <_panic>
	return 0;
  8047f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047fc:	c9                   	leave  
  8047fd:	c3                   	ret    

008047fe <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  8047fe:	55                   	push   %ebp
  8047ff:	89 e5                	mov    %esp,%ebp
  804801:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  804804:	c7 45 f4 00 60 80 00 	movl   $0x806000,-0xc(%ebp)
	req->req_fileid = fileid;
  80480b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80480e:	8b 55 08             	mov    0x8(%ebp),%edx
  804811:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  804813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804816:	8b 55 0c             	mov    0xc(%ebp),%edx
  804819:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  80481c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  804823:	00 
  804824:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80482b:	00 
  80482c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80482f:	89 44 24 04          	mov    %eax,0x4(%esp)
  804833:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80483a:	e8 89 fe ff ff       	call   8046c8 <fsipc>
}
  80483f:	c9                   	leave  
  804840:	c3                   	ret    

00804841 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  804841:	55                   	push   %ebp
  804842:	89 e5                	mov    %esp,%ebp
  804844:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  804847:	c7 45 f4 00 60 80 00 	movl   $0x806000,-0xc(%ebp)
	req->req_fileid = fileid;
  80484e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804851:	8b 55 08             	mov    0x8(%ebp),%edx
  804854:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  804856:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80485d:	00 
  80485e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804865:	00 
  804866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804869:	89 44 24 04          	mov    %eax,0x4(%esp)
  80486d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  804874:	e8 4f fe ff ff       	call   8046c8 <fsipc>
}
  804879:	c9                   	leave  
  80487a:	c3                   	ret    

0080487b <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  80487b:	55                   	push   %ebp
  80487c:	89 e5                	mov    %esp,%ebp
  80487e:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  804881:	c7 45 f4 00 60 80 00 	movl   $0x806000,-0xc(%ebp)
	req->req_fileid = fileid;
  804888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80488b:	8b 55 08             	mov    0x8(%ebp),%edx
  80488e:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  804890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804893:	8b 55 0c             	mov    0xc(%ebp),%edx
  804896:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  804899:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8048a0:	00 
  8048a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8048a8:	00 
  8048a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048b0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8048b7:	e8 0c fe ff ff       	call   8046c8 <fsipc>
}
  8048bc:	c9                   	leave  
  8048bd:	c3                   	ret    

008048be <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  8048be:	55                   	push   %ebp
  8048bf:	89 e5                	mov    %esp,%ebp
  8048c1:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  8048c4:	c7 45 f4 00 60 80 00 	movl   $0x806000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  8048cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8048ce:	89 04 24             	mov    %eax,(%esp)
  8048d1:	e8 9e e7 ff ff       	call   803074 <strlen>
  8048d6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8048db:	7e 07                	jle    8048e4 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  8048dd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8048e2:	eb 35                	jmp    804919 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  8048e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8048ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  8048ee:	89 04 24             	mov    %eax,(%esp)
  8048f1:	e8 d4 e7 ff ff       	call   8030ca <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8048f6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8048fd:	00 
  8048fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804905:	00 
  804906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80490d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  804914:	e8 af fd ff ff       	call   8046c8 <fsipc>
}
  804919:	c9                   	leave  
  80491a:	c3                   	ret    

0080491b <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  80491b:	55                   	push   %ebp
  80491c:	89 e5                	mov    %esp,%ebp
  80491e:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  804921:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  804928:	00 
  804929:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804930:	00 
  804931:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  804938:	00 
  804939:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  804940:	e8 83 fd ff ff       	call   8046c8 <fsipc>
}
  804945:	c9                   	leave  
  804946:	c3                   	ret    
	...

00804948 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804948:	55                   	push   %ebp
  804949:	89 e5                	mov    %esp,%ebp
  80494b:	83 ec 10             	sub    $0x10,%esp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80494e:	8b 45 08             	mov    0x8(%ebp),%eax
  804951:	c1 e8 16             	shr    $0x16,%eax
  804954:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80495b:	83 e0 01             	and    $0x1,%eax
  80495e:	85 c0                	test   %eax,%eax
  804960:	75 07                	jne    804969 <pageref+0x21>
		return 0;
  804962:	b8 00 00 00 00       	mov    $0x0,%eax
  804967:	eb 3e                	jmp    8049a7 <pageref+0x5f>
	pte = vpt[VPN(v)];
  804969:	8b 45 08             	mov    0x8(%ebp),%eax
  80496c:	c1 e8 0c             	shr    $0xc,%eax
  80496f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  804976:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (!(pte & PTE_P))
  804979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80497c:	83 e0 01             	and    $0x1,%eax
  80497f:	85 c0                	test   %eax,%eax
  804981:	75 07                	jne    80498a <pageref+0x42>
		return 0;
  804983:	b8 00 00 00 00       	mov    $0x0,%eax
  804988:	eb 1d                	jmp    8049a7 <pageref+0x5f>
	return pages[PPN(pte)].pp_ref;
  80498a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80498d:	89 c2                	mov    %eax,%edx
  80498f:	c1 ea 0c             	shr    $0xc,%edx
  804992:	89 d0                	mov    %edx,%eax
  804994:	01 c0                	add    %eax,%eax
  804996:	01 d0                	add    %edx,%eax
  804998:	c1 e0 02             	shl    $0x2,%eax
  80499b:	05 00 00 00 ef       	add    $0xef000000,%eax
  8049a0:	0f b7 40 08          	movzwl 0x8(%eax),%eax
  8049a4:	0f b7 c0             	movzwl %ax,%eax
}
  8049a7:	c9                   	leave  
  8049a8:	c3                   	ret    
  8049a9:	00 00                	add    %al,(%eax)
  8049ab:	00 00                	add    %al,(%eax)
  8049ad:	00 00                	add    %al,(%eax)
	...

008049b0 <__udivdi3>:
  8049b0:	83 ec 1c             	sub    $0x1c,%esp
  8049b3:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8049b7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  8049bb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8049bf:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8049c3:	89 74 24 10          	mov    %esi,0x10(%esp)
  8049c7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8049cb:	85 ff                	test   %edi,%edi
  8049cd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8049d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8049d5:	89 cd                	mov    %ecx,%ebp
  8049d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8049db:	75 33                	jne    804a10 <__udivdi3+0x60>
  8049dd:	39 f1                	cmp    %esi,%ecx
  8049df:	77 57                	ja     804a38 <__udivdi3+0x88>
  8049e1:	85 c9                	test   %ecx,%ecx
  8049e3:	75 0b                	jne    8049f0 <__udivdi3+0x40>
  8049e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8049ea:	31 d2                	xor    %edx,%edx
  8049ec:	f7 f1                	div    %ecx
  8049ee:	89 c1                	mov    %eax,%ecx
  8049f0:	89 f0                	mov    %esi,%eax
  8049f2:	31 d2                	xor    %edx,%edx
  8049f4:	f7 f1                	div    %ecx
  8049f6:	89 c6                	mov    %eax,%esi
  8049f8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8049fc:	f7 f1                	div    %ecx
  8049fe:	89 f2                	mov    %esi,%edx
  804a00:	8b 74 24 10          	mov    0x10(%esp),%esi
  804a04:	8b 7c 24 14          	mov    0x14(%esp),%edi
  804a08:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  804a0c:	83 c4 1c             	add    $0x1c,%esp
  804a0f:	c3                   	ret    
  804a10:	31 d2                	xor    %edx,%edx
  804a12:	31 c0                	xor    %eax,%eax
  804a14:	39 f7                	cmp    %esi,%edi
  804a16:	77 e8                	ja     804a00 <__udivdi3+0x50>
  804a18:	0f bd cf             	bsr    %edi,%ecx
  804a1b:	83 f1 1f             	xor    $0x1f,%ecx
  804a1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a22:	75 2c                	jne    804a50 <__udivdi3+0xa0>
  804a24:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  804a28:	76 04                	jbe    804a2e <__udivdi3+0x7e>
  804a2a:	39 f7                	cmp    %esi,%edi
  804a2c:	73 d2                	jae    804a00 <__udivdi3+0x50>
  804a2e:	31 d2                	xor    %edx,%edx
  804a30:	b8 01 00 00 00       	mov    $0x1,%eax
  804a35:	eb c9                	jmp    804a00 <__udivdi3+0x50>
  804a37:	90                   	nop
  804a38:	89 f2                	mov    %esi,%edx
  804a3a:	f7 f1                	div    %ecx
  804a3c:	31 d2                	xor    %edx,%edx
  804a3e:	8b 74 24 10          	mov    0x10(%esp),%esi
  804a42:	8b 7c 24 14          	mov    0x14(%esp),%edi
  804a46:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  804a4a:	83 c4 1c             	add    $0x1c,%esp
  804a4d:	c3                   	ret    
  804a4e:	66 90                	xchg   %ax,%ax
  804a50:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804a55:	b8 20 00 00 00       	mov    $0x20,%eax
  804a5a:	89 ea                	mov    %ebp,%edx
  804a5c:	2b 44 24 04          	sub    0x4(%esp),%eax
  804a60:	d3 e7                	shl    %cl,%edi
  804a62:	89 c1                	mov    %eax,%ecx
  804a64:	d3 ea                	shr    %cl,%edx
  804a66:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804a6b:	09 fa                	or     %edi,%edx
  804a6d:	89 f7                	mov    %esi,%edi
  804a6f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  804a73:	89 f2                	mov    %esi,%edx
  804a75:	8b 74 24 08          	mov    0x8(%esp),%esi
  804a79:	d3 e5                	shl    %cl,%ebp
  804a7b:	89 c1                	mov    %eax,%ecx
  804a7d:	d3 ef                	shr    %cl,%edi
  804a7f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804a84:	d3 e2                	shl    %cl,%edx
  804a86:	89 c1                	mov    %eax,%ecx
  804a88:	d3 ee                	shr    %cl,%esi
  804a8a:	09 d6                	or     %edx,%esi
  804a8c:	89 fa                	mov    %edi,%edx
  804a8e:	89 f0                	mov    %esi,%eax
  804a90:	f7 74 24 0c          	divl   0xc(%esp)
  804a94:	89 d7                	mov    %edx,%edi
  804a96:	89 c6                	mov    %eax,%esi
  804a98:	f7 e5                	mul    %ebp
  804a9a:	39 d7                	cmp    %edx,%edi
  804a9c:	72 22                	jb     804ac0 <__udivdi3+0x110>
  804a9e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  804aa2:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804aa7:	d3 e5                	shl    %cl,%ebp
  804aa9:	39 c5                	cmp    %eax,%ebp
  804aab:	73 04                	jae    804ab1 <__udivdi3+0x101>
  804aad:	39 d7                	cmp    %edx,%edi
  804aaf:	74 0f                	je     804ac0 <__udivdi3+0x110>
  804ab1:	89 f0                	mov    %esi,%eax
  804ab3:	31 d2                	xor    %edx,%edx
  804ab5:	e9 46 ff ff ff       	jmp    804a00 <__udivdi3+0x50>
  804aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804ac0:	8d 46 ff             	lea    -0x1(%esi),%eax
  804ac3:	31 d2                	xor    %edx,%edx
  804ac5:	8b 74 24 10          	mov    0x10(%esp),%esi
  804ac9:	8b 7c 24 14          	mov    0x14(%esp),%edi
  804acd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  804ad1:	83 c4 1c             	add    $0x1c,%esp
  804ad4:	c3                   	ret    
	...

00804ae0 <__umoddi3>:
  804ae0:	83 ec 1c             	sub    $0x1c,%esp
  804ae3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  804ae7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  804aeb:	8b 44 24 20          	mov    0x20(%esp),%eax
  804aef:	89 74 24 10          	mov    %esi,0x10(%esp)
  804af3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  804af7:	8b 74 24 24          	mov    0x24(%esp),%esi
  804afb:	85 ed                	test   %ebp,%ebp
  804afd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  804b01:	89 44 24 08          	mov    %eax,0x8(%esp)
  804b05:	89 cf                	mov    %ecx,%edi
  804b07:	89 04 24             	mov    %eax,(%esp)
  804b0a:	89 f2                	mov    %esi,%edx
  804b0c:	75 1a                	jne    804b28 <__umoddi3+0x48>
  804b0e:	39 f1                	cmp    %esi,%ecx
  804b10:	76 4e                	jbe    804b60 <__umoddi3+0x80>
  804b12:	f7 f1                	div    %ecx
  804b14:	89 d0                	mov    %edx,%eax
  804b16:	31 d2                	xor    %edx,%edx
  804b18:	8b 74 24 10          	mov    0x10(%esp),%esi
  804b1c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  804b20:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  804b24:	83 c4 1c             	add    $0x1c,%esp
  804b27:	c3                   	ret    
  804b28:	39 f5                	cmp    %esi,%ebp
  804b2a:	77 54                	ja     804b80 <__umoddi3+0xa0>
  804b2c:	0f bd c5             	bsr    %ebp,%eax
  804b2f:	83 f0 1f             	xor    $0x1f,%eax
  804b32:	89 44 24 04          	mov    %eax,0x4(%esp)
  804b36:	75 60                	jne    804b98 <__umoddi3+0xb8>
  804b38:	3b 0c 24             	cmp    (%esp),%ecx
  804b3b:	0f 87 07 01 00 00    	ja     804c48 <__umoddi3+0x168>
  804b41:	89 f2                	mov    %esi,%edx
  804b43:	8b 34 24             	mov    (%esp),%esi
  804b46:	29 ce                	sub    %ecx,%esi
  804b48:	19 ea                	sbb    %ebp,%edx
  804b4a:	89 34 24             	mov    %esi,(%esp)
  804b4d:	8b 04 24             	mov    (%esp),%eax
  804b50:	8b 74 24 10          	mov    0x10(%esp),%esi
  804b54:	8b 7c 24 14          	mov    0x14(%esp),%edi
  804b58:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  804b5c:	83 c4 1c             	add    $0x1c,%esp
  804b5f:	c3                   	ret    
  804b60:	85 c9                	test   %ecx,%ecx
  804b62:	75 0b                	jne    804b6f <__umoddi3+0x8f>
  804b64:	b8 01 00 00 00       	mov    $0x1,%eax
  804b69:	31 d2                	xor    %edx,%edx
  804b6b:	f7 f1                	div    %ecx
  804b6d:	89 c1                	mov    %eax,%ecx
  804b6f:	89 f0                	mov    %esi,%eax
  804b71:	31 d2                	xor    %edx,%edx
  804b73:	f7 f1                	div    %ecx
  804b75:	8b 04 24             	mov    (%esp),%eax
  804b78:	f7 f1                	div    %ecx
  804b7a:	eb 98                	jmp    804b14 <__umoddi3+0x34>
  804b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804b80:	89 f2                	mov    %esi,%edx
  804b82:	8b 74 24 10          	mov    0x10(%esp),%esi
  804b86:	8b 7c 24 14          	mov    0x14(%esp),%edi
  804b8a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  804b8e:	83 c4 1c             	add    $0x1c,%esp
  804b91:	c3                   	ret    
  804b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804b98:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804b9d:	89 e8                	mov    %ebp,%eax
  804b9f:	bd 20 00 00 00       	mov    $0x20,%ebp
  804ba4:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  804ba8:	89 fa                	mov    %edi,%edx
  804baa:	d3 e0                	shl    %cl,%eax
  804bac:	89 e9                	mov    %ebp,%ecx
  804bae:	d3 ea                	shr    %cl,%edx
  804bb0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804bb5:	09 c2                	or     %eax,%edx
  804bb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  804bbb:	89 14 24             	mov    %edx,(%esp)
  804bbe:	89 f2                	mov    %esi,%edx
  804bc0:	d3 e7                	shl    %cl,%edi
  804bc2:	89 e9                	mov    %ebp,%ecx
  804bc4:	d3 ea                	shr    %cl,%edx
  804bc6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804bcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804bcf:	d3 e6                	shl    %cl,%esi
  804bd1:	89 e9                	mov    %ebp,%ecx
  804bd3:	d3 e8                	shr    %cl,%eax
  804bd5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804bda:	09 f0                	or     %esi,%eax
  804bdc:	8b 74 24 08          	mov    0x8(%esp),%esi
  804be0:	f7 34 24             	divl   (%esp)
  804be3:	d3 e6                	shl    %cl,%esi
  804be5:	89 74 24 08          	mov    %esi,0x8(%esp)
  804be9:	89 d6                	mov    %edx,%esi
  804beb:	f7 e7                	mul    %edi
  804bed:	39 d6                	cmp    %edx,%esi
  804bef:	89 c1                	mov    %eax,%ecx
  804bf1:	89 d7                	mov    %edx,%edi
  804bf3:	72 3f                	jb     804c34 <__umoddi3+0x154>
  804bf5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  804bf9:	72 35                	jb     804c30 <__umoddi3+0x150>
  804bfb:	8b 44 24 08          	mov    0x8(%esp),%eax
  804bff:	29 c8                	sub    %ecx,%eax
  804c01:	19 fe                	sbb    %edi,%esi
  804c03:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804c08:	89 f2                	mov    %esi,%edx
  804c0a:	d3 e8                	shr    %cl,%eax
  804c0c:	89 e9                	mov    %ebp,%ecx
  804c0e:	d3 e2                	shl    %cl,%edx
  804c10:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  804c15:	09 d0                	or     %edx,%eax
  804c17:	89 f2                	mov    %esi,%edx
  804c19:	d3 ea                	shr    %cl,%edx
  804c1b:	8b 74 24 10          	mov    0x10(%esp),%esi
  804c1f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  804c23:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  804c27:	83 c4 1c             	add    $0x1c,%esp
  804c2a:	c3                   	ret    
  804c2b:	90                   	nop
  804c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804c30:	39 d6                	cmp    %edx,%esi
  804c32:	75 c7                	jne    804bfb <__umoddi3+0x11b>
  804c34:	89 d7                	mov    %edx,%edi
  804c36:	89 c1                	mov    %eax,%ecx
  804c38:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  804c3c:	1b 3c 24             	sbb    (%esp),%edi
  804c3f:	eb ba                	jmp    804bfb <__umoddi3+0x11b>
  804c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804c48:	39 f5                	cmp    %esi,%ebp
  804c4a:	0f 82 f1 fe ff ff    	jb     804b41 <__umoddi3+0x61>
  804c50:	e9 f8 fe ff ff       	jmp    804b4d <__umoddi3+0x6d>
