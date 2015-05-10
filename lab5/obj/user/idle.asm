
obj/user/idle:     file format elf32-i386


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
  80002c:	e8 1b 00 00 00       	call   80004c <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  80003a:	c7 05 00 50 80 00 40 	movl   $0x802640,0x805000
  800041:	26 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800044:	e8 dd 01 00 00       	call   800226 <sys_yield>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800049:	cc                   	int3   
		// However, in JOS it is easier for testing and grading
		// if we invoke the kernel monitor after each iteration,
		// because the first invocation of the idle environment
		// usually means everything else has run to completion.
		breakpoint();
	}
  80004a:	eb f8                	jmp    800044 <umain+0x10>

0080004c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  800052:	e8 8b 01 00 00       	call   8001e2 <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	c1 e0 07             	shl    $0x7,%eax
  80005f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800064:	a3 44 50 80 00       	mov    %eax,0x805044
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80006d:	7e 0a                	jle    800079 <libmain+0x2d>
		binaryname = argv[0];
  80006f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800072:	8b 00                	mov    (%eax),%eax
  800074:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	umain(argc, argv);
  800079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80007c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800080:	8b 45 08             	mov    0x8(%ebp),%eax
  800083:	89 04 24             	mov    %eax,(%esp)
  800086:	e8 a9 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80008b:	e8 04 00 00 00       	call   800094 <exit>
}
  800090:	c9                   	leave  
  800091:	c3                   	ret    
	...

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80009a:	e8 17 06 00 00       	call   8006b6 <close_all>
	sys_env_destroy(0);
  80009f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a6:	e8 f4 00 00 00       	call   80019f <sys_env_destroy>
}
  8000ab:	c9                   	leave  
  8000ac:	c3                   	ret    
  8000ad:	00 00                	add    %al,(%eax)
	...

008000b0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	57                   	push   %edi
  8000b4:	56                   	push   %esi
  8000b5:	53                   	push   %ebx
  8000b6:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8000bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000bf:	8b 55 10             	mov    0x10(%ebp),%edx
  8000c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8000c5:	8b 5d 18             	mov    0x18(%ebp),%ebx
  8000c8:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  8000cb:	8b 75 20             	mov    0x20(%ebp),%esi
  8000ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000d1:	cd 30                	int    $0x30
  8000d3:	89 c3                	mov    %eax,%ebx
  8000d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8000d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8000dc:	74 30                	je     80010e <syscall+0x5e>
  8000de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000e2:	7e 2a                	jle    80010e <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  8000e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f2:	c7 44 24 08 5c 26 80 	movl   $0x80265c,0x8(%esp)
  8000f9:	00 
  8000fa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800101:	00 
  800102:	c7 04 24 79 26 80 00 	movl   $0x802679,(%esp)
  800109:	e8 7a 12 00 00       	call   801388 <_panic>

	return ret;
  80010e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800111:	83 c4 4c             	add    $0x4c,%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80011f:	8b 45 08             	mov    0x8(%ebp),%eax
  800122:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800129:	00 
  80012a:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800131:	00 
  800132:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800139:	00 
  80013a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80013d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800141:	89 44 24 08          	mov    %eax,0x8(%esp)
  800145:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80014c:	00 
  80014d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800154:	e8 57 ff ff ff       	call   8000b0 <syscall>
}
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <sys_cgetc>:

int
sys_cgetc(void)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800161:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800168:	00 
  800169:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800170:	00 
  800171:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800178:	00 
  800179:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800180:	00 
  800181:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800188:	00 
  800189:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800190:	00 
  800191:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800198:	e8 13 ff ff ff       	call   8000b0 <syscall>
}
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8001af:	00 
  8001b0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8001b7:	00 
  8001b8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8001bf:	00 
  8001c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001c7:	00 
  8001c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001d3:	00 
  8001d4:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8001db:	e8 d0 fe ff ff       	call   8000b0 <syscall>
}
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    

008001e2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8001e8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8001ef:	00 
  8001f0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8001f7:	00 
  8001f8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8001ff:	00 
  800200:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800207:	00 
  800208:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80020f:	00 
  800210:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800217:	00 
  800218:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80021f:	e8 8c fe ff ff       	call   8000b0 <syscall>
}
  800224:	c9                   	leave  
  800225:	c3                   	ret    

00800226 <sys_yield>:

void
sys_yield(void)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80022c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800233:	00 
  800234:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80023b:	00 
  80023c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800243:	00 
  800244:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80024b:	00 
  80024c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800253:	00 
  800254:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80025b:	00 
  80025c:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  800263:	e8 48 fe ff ff       	call   8000b0 <syscall>
}
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800270:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800273:	8b 55 0c             	mov    0xc(%ebp),%edx
  800276:	8b 45 08             	mov    0x8(%ebp),%eax
  800279:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800280:	00 
  800281:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800288:	00 
  800289:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80028d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800291:	89 44 24 08          	mov    %eax,0x8(%esp)
  800295:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80029c:	00 
  80029d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8002a4:	e8 07 fe ff ff       	call   8000b0 <syscall>
}
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

008002ab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8002b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8002b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	89 74 24 18          	mov    %esi,0x18(%esp)
  8002c6:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8002ca:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8002dd:	00 
  8002de:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8002e5:	e8 c6 fd ff ff       	call   8000b0 <syscall>
}
  8002ea:	83 c4 20             	add    $0x20,%esp
  8002ed:	5b                   	pop    %ebx
  8002ee:	5e                   	pop    %esi
  8002ef:	5d                   	pop    %ebp
  8002f0:	c3                   	ret    

008002f1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8002f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800304:	00 
  800305:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80030c:	00 
  80030d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800314:	00 
  800315:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800319:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800324:	00 
  800325:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  80032c:	e8 7f fd ff ff       	call   8000b0 <syscall>
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  800339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80033c:	8b 45 08             	mov    0x8(%ebp),%eax
  80033f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800346:	00 
  800347:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80034e:	00 
  80034f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800356:	00 
  800357:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80035b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80035f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800366:	00 
  800367:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  80036e:	e8 3d fd ff ff       	call   8000b0 <syscall>
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80037b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037e:	8b 45 08             	mov    0x8(%ebp),%eax
  800381:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800388:	00 
  800389:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800390:	00 
  800391:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800398:	00 
  800399:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80039d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8003a8:	00 
  8003a9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8003b0:	e8 fb fc ff ff       	call   8000b0 <syscall>
}
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8003bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8003ca:	00 
  8003cb:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8003d2:	00 
  8003d3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8003da:	00 
  8003db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8003ea:	00 
  8003eb:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  8003f2:	e8 b9 fc ff ff       	call   8000b0 <syscall>
}
  8003f7:	c9                   	leave  
  8003f8:	c3                   	ret    

008003f9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8003ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80040c:	00 
  80040d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800414:	00 
  800415:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80041c:	00 
  80041d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800421:	89 44 24 08          	mov    %eax,0x8(%esp)
  800425:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80042c:	00 
  80042d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800434:	e8 77 fc ff ff       	call   8000b0 <syscall>
}
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800441:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800444:	8b 55 10             	mov    0x10(%ebp),%edx
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800451:	00 
  800452:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  800456:	89 54 24 10          	mov    %edx,0x10(%esp)
  80045a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800461:	89 44 24 08          	mov    %eax,0x8(%esp)
  800465:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80046c:	00 
  80046d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  800474:	e8 37 fc ff ff       	call   8000b0 <syscall>
}
  800479:	c9                   	leave  
  80047a:	c3                   	ret    

0080047b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
  80047e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80048b:	00 
  80048c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800493:	00 
  800494:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80049b:	00 
  80049c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004a3:	00 
  8004a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8004af:	00 
  8004b0:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  8004b7:	e8 f4 fb ff ff       	call   8000b0 <syscall>
}
  8004bc:	c9                   	leave  
  8004bd:	c3                   	ret    
	...

008004c0 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	89 04 24             	mov    %eax,(%esp)
  8004cc:	e8 0a 00 00 00       	call   8004db <fd2num>
  8004d1:	05 40 03 00 00       	add    $0x340,%eax
  8004d6:	c1 e0 16             	shl    $0x16,%eax
}
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <fd2num>:

int
fd2num(struct Fd *fd)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e1:	05 00 00 40 30       	add    $0x30400000,%eax
  8004e6:	c1 e8 0c             	shr    $0xc,%eax
}
  8004e9:	5d                   	pop    %ebp
  8004ea:	c3                   	ret    

008004eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  8004f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f8:	eb 49                	jmp    800543 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  8004fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004fd:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  800502:	c1 e0 0c             	shl    $0xc,%eax
  800505:	89 c2                	mov    %eax,%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	c1 e8 16             	shr    $0x16,%eax
  800514:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80051b:	83 e0 01             	and    $0x1,%eax
  80051e:	85 c0                	test   %eax,%eax
  800520:	74 16                	je     800538 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	c1 e8 0c             	shr    $0xc,%eax
  80052a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800531:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  800534:	85 c0                	test   %eax,%eax
  800536:	75 07                	jne    80053f <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	eb 18                	jmp    800557 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  80053f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800543:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  800547:	7e b1                	jle    8004fa <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  800552:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800557:	c9                   	leave  
  800558:	c3                   	ret    

00800559 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  80055f:	c7 44 24 08 88 26 80 	movl   $0x802688,0x8(%esp)
  800566:	00 
  800567:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80056e:	00 
  80056f:	c7 04 24 a2 26 80 00 	movl   $0x8026a2,(%esp)
  800576:	e8 0d 0e 00 00       	call   801388 <_panic>

0080057b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80057b:	55                   	push   %ebp
  80057c:	89 e5                	mov    %esp,%ebp
  80057e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	89 04 24             	mov    %eax,(%esp)
  800587:	e8 4f ff ff ff       	call   8004db <fd2num>
  80058c:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80058f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800593:	89 04 24             	mov    %eax,(%esp)
  800596:	e8 be ff ff ff       	call   800559 <fd_lookup>
  80059b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80059e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005a2:	78 08                	js     8005ac <fd_close+0x31>
	    || fd != fd2)
  8005a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a7:	39 45 08             	cmp    %eax,0x8(%ebp)
  8005aa:	74 12                	je     8005be <fd_close+0x43>
		return (must_exist ? r : 0);
  8005ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b0:	74 05                	je     8005b7 <fd_close+0x3c>
  8005b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b5:	eb 05                	jmp    8005bc <fd_close+0x41>
  8005b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bc:	eb 44                	jmp    800602 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8005c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ca:	89 04 24             	mov    %eax,(%esp)
  8005cd:	e8 32 00 00 00       	call   800604 <dev_lookup>
  8005d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8005d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d9:	78 11                	js     8005ec <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  8005db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005de:	8b 50 10             	mov    0x10(%eax),%edx
  8005e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e4:	89 04 24             	mov    %eax,(%esp)
  8005e7:	ff d2                	call   *%edx
  8005e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005fa:	e8 f2 fc ff ff       	call   8002f1 <sys_page_unmap>
	return r;
  8005ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800602:	c9                   	leave  
  800603:	c3                   	ret    

00800604 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  80060a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800611:	eb 2b                	jmp    80063e <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  800613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800616:	8b 04 85 04 50 80 00 	mov    0x805004(,%eax,4),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	3b 45 08             	cmp    0x8(%ebp),%eax
  800622:	75 16                	jne    80063a <dev_lookup+0x36>
			*dev = devtab[i];
  800624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800627:	8b 14 85 04 50 80 00 	mov    0x805004(,%eax,4),%edx
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	89 10                	mov    %edx,(%eax)
			return 0;
  800633:	b8 00 00 00 00       	mov    $0x0,%eax
  800638:	eb 3f                	jmp    800679 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80063a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  80063e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800641:	8b 04 85 04 50 80 00 	mov    0x805004(,%eax,4),%eax
  800648:	85 c0                	test   %eax,%eax
  80064a:	75 c7                	jne    800613 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80064c:	a1 44 50 80 00       	mov    0x805044,%eax
  800651:	8b 40 4c             	mov    0x4c(%eax),%eax
  800654:	8b 55 08             	mov    0x8(%ebp),%edx
  800657:	89 54 24 08          	mov    %edx,0x8(%esp)
  80065b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065f:	c7 04 24 ac 26 80 00 	movl   $0x8026ac,(%esp)
  800666:	e8 51 0e 00 00       	call   8014bc <cprintf>
	*dev = 0;
  80066b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800674:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <close>:

int
close(int fdnum)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800681:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800684:	89 44 24 04          	mov    %eax,0x4(%esp)
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	89 04 24             	mov    %eax,(%esp)
  80068e:	e8 c6 fe ff ff       	call   800559 <fd_lookup>
  800693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800696:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80069a:	79 05                	jns    8006a1 <close+0x26>
		return r;
  80069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069f:	eb 13                	jmp    8006b4 <close+0x39>
	else
		return fd_close(fd, 1);
  8006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006ab:	00 
  8006ac:	89 04 24             	mov    %eax,(%esp)
  8006af:	e8 c7 fe ff ff       	call   80057b <fd_close>
}
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <close_all>:

void
close_all(void)
{
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8006c3:	eb 0f                	jmp    8006d4 <close_all+0x1e>
		close(i);
  8006c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c8:	89 04 24             	mov    %eax,(%esp)
  8006cb:	e8 ab ff ff ff       	call   80067b <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8006d4:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  8006d8:	7e eb                	jle    8006c5 <close_all+0xf>
		close(i);
}
  8006da:	c9                   	leave  
  8006db:	c3                   	ret    

008006dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006e2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8006e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	89 04 24             	mov    %eax,(%esp)
  8006ef:	e8 65 fe ff ff       	call   800559 <fd_lookup>
  8006f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006fb:	79 08                	jns    800705 <dup+0x29>
		return r;
  8006fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800700:	e9 54 01 00 00       	jmp    800859 <dup+0x17d>
	close(newfdnum);
  800705:	8b 45 0c             	mov    0xc(%ebp),%eax
  800708:	89 04 24             	mov    %eax,(%esp)
  80070b:	e8 6b ff ff ff       	call   80067b <close>

	newfd = INDEX2FD(newfdnum);
  800710:	8b 45 0c             	mov    0xc(%ebp),%eax
  800713:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  800718:	c1 e0 0c             	shl    $0xc,%eax
  80071b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  80071e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800721:	89 04 24             	mov    %eax,(%esp)
  800724:	e8 97 fd ff ff       	call   8004c0 <fd2data>
  800729:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  80072c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	e8 89 fd ff ff       	call   8004c0 <fd2data>
  800737:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80073a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80073d:	c1 e8 0c             	shr    $0xc,%eax
  800740:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800747:	89 c2                	mov    %eax,%edx
  800749:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80074f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800752:	89 54 24 10          	mov    %edx,0x10(%esp)
  800756:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800759:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80075d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800764:	00 
  800765:	89 44 24 04          	mov    %eax,0x4(%esp)
  800769:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800770:	e8 36 fb ff ff       	call   8002ab <sys_page_map>
  800775:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800778:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80077c:	0f 88 8e 00 00 00    	js     800810 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  800782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800785:	c1 e8 16             	shr    $0x16,%eax
  800788:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80078f:	85 c0                	test   %eax,%eax
  800791:	74 78                	je     80080b <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  800793:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80079a:	eb 66                	jmp    800802 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  80079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079f:	03 45 e8             	add    -0x18(%ebp),%eax
  8007a2:	c1 e8 0c             	shr    $0xc,%eax
  8007a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8007ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  8007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b2:	83 e0 01             	and    $0x1,%eax
  8007b5:	84 c0                	test   %al,%al
  8007b7:	74 42                	je     8007fb <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  8007b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007bc:	89 c1                	mov    %eax,%ecx
  8007be:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	03 55 e4             	add    -0x1c(%ebp),%edx
  8007cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007cf:	03 45 e8             	add    -0x18(%ebp),%eax
  8007d2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8007d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007e1:	00 
  8007e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007ed:	e8 b9 fa ff ff       	call   8002ab <sys_page_map>
  8007f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8007f9:	78 18                	js     800813 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8007fb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800802:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  800809:	7e 91                	jle    80079c <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  80080b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080e:	eb 49                	jmp    800859 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  800810:	90                   	nop
  800811:	eb 01                	jmp    800814 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  800813:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800814:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800822:	e8 ca fa ff ff       	call   8002f1 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  800827:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80082e:	eb 1d                	jmp    80084d <dup+0x171>
		sys_page_unmap(0, nva + i);
  800830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800833:	03 45 e4             	add    -0x1c(%ebp),%eax
  800836:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800841:	e8 ab fa ff ff       	call   8002f1 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  800846:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80084d:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  800854:	7e da                	jle    800830 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800861:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800864:	89 44 24 04          	mov    %eax,0x4(%esp)
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	89 04 24             	mov    %eax,(%esp)
  80086e:	e8 e6 fc ff ff       	call   800559 <fd_lookup>
  800873:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800876:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80087a:	78 1d                	js     800899 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80087c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800884:	89 54 24 04          	mov    %edx,0x4(%esp)
  800888:	89 04 24             	mov    %eax,(%esp)
  80088b:	e8 74 fd ff ff       	call   800604 <dev_lookup>
  800890:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800897:	79 05                	jns    80089e <read+0x43>
		return r;
  800899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089c:	eb 75                	jmp    800913 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80089e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a1:	8b 40 08             	mov    0x8(%eax),%eax
  8008a4:	83 e0 03             	and    $0x3,%eax
  8008a7:	83 f8 01             	cmp    $0x1,%eax
  8008aa:	75 26                	jne    8008d2 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8008ac:	a1 44 50 80 00       	mov    0x805044,%eax
  8008b1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8008b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8008bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bf:	c7 04 24 cb 26 80 00 	movl   $0x8026cb,(%esp)
  8008c6:	e8 f1 0b 00 00       	call   8014bc <cprintf>
		return -E_INVAL;
  8008cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d0:	eb 41                	jmp    800913 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8008d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d5:	8b 48 08             	mov    0x8(%eax),%ecx
  8008d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008db:	8b 50 04             	mov    0x4(%eax),%edx
  8008de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008e5:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ef:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008f3:	89 04 24             	mov    %eax,(%esp)
  8008f6:	ff d1                	call   *%ecx
  8008f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  8008fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8008ff:	78 0f                	js     800910 <read+0xb5>
		fd->fd_offset += r;
  800901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800907:	8b 52 04             	mov    0x4(%edx),%edx
  80090a:	03 55 f4             	add    -0xc(%ebp),%edx
  80090d:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  800910:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800922:	eb 3b                	jmp    80095f <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800927:	8b 55 10             	mov    0x10(%ebp),%edx
  80092a:	29 c2                	sub    %eax,%edx
  80092c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092f:	03 45 0c             	add    0xc(%ebp),%eax
  800932:	89 54 24 08          	mov    %edx,0x8(%esp)
  800936:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	89 04 24             	mov    %eax,(%esp)
  800940:	e8 16 ff ff ff       	call   80085b <read>
  800945:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  800948:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80094c:	79 05                	jns    800953 <readn+0x3e>
			return m;
  80094e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800951:	eb 1a                	jmp    80096d <readn+0x58>
		if (m == 0)
  800953:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800957:	74 10                	je     800969 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095c:	01 45 f4             	add    %eax,-0xc(%ebp)
  80095f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800962:	3b 45 10             	cmp    0x10(%ebp),%eax
  800965:	72 bd                	jb     800924 <readn+0xf>
  800967:	eb 01                	jmp    80096a <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  800969:	90                   	nop
	}
	return tot;
  80096a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800975:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	89 04 24             	mov    %eax,(%esp)
  800982:	e8 d2 fb ff ff       	call   800559 <fd_lookup>
  800987:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80098a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80098e:	78 1d                	js     8009ad <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800998:	89 54 24 04          	mov    %edx,0x4(%esp)
  80099c:	89 04 24             	mov    %eax,(%esp)
  80099f:	e8 60 fc ff ff       	call   800604 <dev_lookup>
  8009a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8009ab:	79 05                	jns    8009b2 <write+0x43>
		return r;
  8009ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b0:	eb 74                	jmp    800a26 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b5:	8b 40 08             	mov    0x8(%eax),%eax
  8009b8:	83 e0 03             	and    $0x3,%eax
  8009bb:	85 c0                	test   %eax,%eax
  8009bd:	75 26                	jne    8009e5 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8009bf:	a1 44 50 80 00       	mov    0x805044,%eax
  8009c4:	8b 40 4c             	mov    0x4c(%eax),%eax
  8009c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8009ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d2:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  8009d9:	e8 de 0a 00 00       	call   8014bc <cprintf>
		return -E_INVAL;
  8009de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e3:	eb 41                	jmp    800a26 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 48 0c             	mov    0xc(%eax),%ecx
  8009eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ee:	8b 50 04             	mov    0x4(%eax),%edx
  8009f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009f8:	8b 55 10             	mov    0x10(%ebp),%edx
  8009fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a02:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a06:	89 04 24             	mov    %eax,(%esp)
  800a09:	ff d1                	call   *%ecx
  800a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  800a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a12:	7e 0f                	jle    800a23 <write+0xb4>
		fd->fd_offset += r;
  800a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a1a:	8b 52 04             	mov    0x4(%edx),%edx
  800a1d:	03 55 f4             	add    -0xc(%ebp),%edx
  800a20:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  800a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <seek>:

int
seek(int fdnum, off_t offset)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	89 04 24             	mov    %eax,(%esp)
  800a3b:	e8 19 fb ff ff       	call   800559 <fd_lookup>
  800a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a47:	79 05                	jns    800a4e <seek+0x26>
		return r;
  800a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a4c:	eb 0e                	jmp    800a5c <seek+0x34>
	fd->fd_offset = offset;
  800a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a54:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5c:	c9                   	leave  
  800a5d:	c3                   	ret    

00800a5e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a64:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	89 04 24             	mov    %eax,(%esp)
  800a71:	e8 e3 fa ff ff       	call   800559 <fd_lookup>
  800a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a7d:	78 1d                	js     800a9c <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a82:	8b 00                	mov    (%eax),%eax
  800a84:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800a87:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a8b:	89 04 24             	mov    %eax,(%esp)
  800a8e:	e8 71 fb ff ff       	call   800604 <dev_lookup>
  800a93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a9a:	79 05                	jns    800aa1 <ftruncate+0x43>
		return r;
  800a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9f:	eb 48                	jmp    800ae9 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa4:	8b 40 08             	mov    0x8(%eax),%eax
  800aa7:	83 e0 03             	and    $0x3,%eax
  800aaa:	85 c0                	test   %eax,%eax
  800aac:	75 26                	jne    800ad4 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  800aae:	a1 44 50 80 00       	mov    0x805044,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800ab3:	8b 40 4c             	mov    0x4c(%eax),%eax
  800ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab9:	89 54 24 08          	mov    %edx,0x8(%esp)
  800abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac1:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  800ac8:	e8 ef 09 00 00       	call   8014bc <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  800acd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ad2:	eb 15                	jmp    800ae9 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  800ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad7:	8b 48 1c             	mov    0x1c(%eax),%ecx
  800ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800add:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ae4:	89 04 24             	mov    %eax,(%esp)
  800ae7:	ff d1                	call   *%ecx
}
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    

00800aeb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800af1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	89 04 24             	mov    %eax,(%esp)
  800afe:	e8 56 fa ff ff       	call   800559 <fd_lookup>
  800b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b0a:	78 1d                	js     800b29 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800b14:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b18:	89 04 24             	mov    %eax,(%esp)
  800b1b:	e8 e4 fa ff ff       	call   800604 <dev_lookup>
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b27:	79 05                	jns    800b2e <fstat+0x43>
		return r;
  800b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b2c:	eb 41                	jmp    800b6f <fstat+0x84>
	stat->st_name[0] = 0;
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  800b3e:	00 00 00 
	stat->st_isdir = 0;
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  800b4b:	00 00 00 
	stat->st_dev = dev;
  800b4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  800b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5d:	8b 48 14             	mov    0x14(%eax),%ecx
  800b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b66:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b6a:	89 04 24             	mov    %eax,(%esp)
  800b6d:	ff d1                	call   *%ecx
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800b77:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800b7e:	00 
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	89 04 24             	mov    %eax,(%esp)
  800b85:	e8 36 00 00 00       	call   800bc0 <open>
  800b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800b8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b91:	79 05                	jns    800b98 <stat+0x27>
		return fd;
  800b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b96:	eb 23                	jmp    800bbb <stat+0x4a>
	r = fstat(fd, stat);
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ba2:	89 04 24             	mov    %eax,(%esp)
  800ba5:	e8 41 ff ff ff       	call   800aeb <fstat>
  800baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  800bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bb0:	89 04 24             	mov    %eax,(%esp)
  800bb3:	e8 c3 fa ff ff       	call   80067b <close>
	return r;
  800bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    
  800bbd:	00 00                	add    %al,(%eax)
	...

00800bc0 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  800bc6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bc9:	89 04 24             	mov    %eax,(%esp)
  800bcc:	e8 1a f9 ff ff       	call   8004eb <fd_alloc>
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800bd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bd8:	79 05                	jns    800bdf <open+0x1f>
  800bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bdd:	eb 73                	jmp    800c52 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  800bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	89 04 24             	mov    %eax,(%esp)
  800bf3:	e8 54 05 00 00       	call   80114c <fsipc_open>
  800bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800bfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bff:	79 05                	jns    800c06 <open+0x46>
  800c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c04:	eb 4c                	jmp    800c52 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  800c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c09:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c12:	89 54 24 08          	mov    %edx,0x8(%esp)
  800c16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c1d:	00 
  800c1e:	89 04 24             	mov    %eax,(%esp)
  800c21:	e8 25 03 00 00       	call   800f4b <fmap>
  800c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c2d:	79 18                	jns    800c47 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  800c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c32:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800c39:	00 
  800c3a:	89 04 24             	mov    %eax,(%esp)
  800c3d:	e8 39 f9 ff ff       	call   80057b <fd_close>
  800c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c45:	eb 0b                	jmp    800c52 <open+0x92>
	return fd2num(fd);
  800c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4a:	89 04 24             	mov    %eax,(%esp)
  800c4d:	e8 89 f8 ff ff       	call   8004db <fd2num>
	//panic("open() unimplemented!");
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800c63:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  800c6a:	00 
  800c6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800c72:	00 
  800c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	89 04 24             	mov    %eax,(%esp)
  800c7d:	e8 72 03 00 00       	call   800ff4 <funmap>
  800c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c89:	79 05                	jns    800c90 <file_close+0x3c>
  800c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c8e:	eb 21                	jmp    800cb1 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 40 0c             	mov    0xc(%eax),%eax
  800c96:	89 04 24             	mov    %eax,(%esp)
  800c99:	e8 e3 05 00 00       	call   801281 <fsipc_close>
  800c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ca1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ca5:	79 05                	jns    800cac <file_close+0x58>
  800ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800caa:	eb 05                	jmp    800cb1 <file_close+0x5d>
	return 0;
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  800cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ccb:	76 07                	jbe    800cd4 <file_read+0x21>
		return 0;
  800ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd2:	eb 43                	jmp    800d17 <file_read+0x64>
	if (offset + n > size)
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	03 45 10             	add    0x10(%ebp),%eax
  800cda:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800cdd:	76 0f                	jbe    800cee <file_read+0x3b>
		n = size - offset;
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce5:	89 d1                	mov    %edx,%ecx
  800ce7:	29 c1                	sub    %eax,%ecx
  800ce9:	89 c8                	mov    %ecx,%eax
  800ceb:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 04 24             	mov    %eax,(%esp)
  800cf4:	e8 c7 f7 ff ff       	call   8004c0 <fd2data>
  800cf9:	8b 55 14             	mov    0x14(%ebp),%edx
  800cfc:	01 c2                	add    %eax,%edx
  800cfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800d01:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d05:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	89 04 24             	mov    %eax,(%esp)
  800d0f:	e8 ac 12 00 00       	call   801fc0 <memmove>
	return n;
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d1f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	89 04 24             	mov    %eax,(%esp)
  800d2c:	e8 28 f8 ff ff       	call   800559 <fd_lookup>
  800d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800d38:	79 05                	jns    800d3f <read_map+0x26>
		return r;
  800d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d3d:	eb 74                	jmp    800db3 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  800d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d42:	8b 10                	mov    (%eax),%edx
  800d44:	a1 20 50 80 00       	mov    0x805020,%eax
  800d49:	39 c2                	cmp    %eax,%edx
  800d4b:	74 07                	je     800d54 <read_map+0x3b>
		return -E_INVAL;
  800d4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d52:	eb 5f                	jmp    800db3 <read_map+0x9a>
	va = fd2data(fd) + offset;
  800d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d57:	89 04 24             	mov    %eax,(%esp)
  800d5a:	e8 61 f7 ff ff       	call   8004c0 <fd2data>
  800d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d62:	01 d0                	add    %edx,%eax
  800d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  800d67:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  800d6e:	7e 07                	jle    800d77 <read_map+0x5e>
		return -E_NO_DISK;
  800d70:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800d75:	eb 3c                	jmp    800db3 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  800d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7a:	c1 e8 16             	shr    $0x16,%eax
  800d7d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800d84:	83 e0 01             	and    $0x1,%eax
  800d87:	85 c0                	test   %eax,%eax
  800d89:	74 14                	je     800d9f <read_map+0x86>
  800d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d8e:	c1 e8 0c             	shr    $0xc,%eax
  800d91:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800d98:	83 e0 01             	and    $0x1,%eax
  800d9b:	85 c0                	test   %eax,%eax
  800d9d:	75 07                	jne    800da6 <read_map+0x8d>
		return -E_NO_DISK;
  800d9f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800da4:	eb 0d                	jmp    800db3 <read_map+0x9a>
	*blk = (void*) va;
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dac:	89 10                	mov    %edx,(%eax)
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  800dbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbe:	03 45 10             	add    0x10(%ebp),%eax
  800dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  800dc4:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  800dcb:	76 07                	jbe    800dd4 <file_write+0x1f>
		return -E_NO_DISK;
  800dcd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800dd2:	eb 57                	jmp    800e2b <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800ddd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800de0:	73 20                	jae    800e02 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  800de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	89 04 24             	mov    %eax,(%esp)
  800def:	e8 88 00 00 00       	call   800e7c <file_trunc>
  800df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dfb:	79 05                	jns    800e02 <file_write+0x4d>
			return r;
  800dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e00:	eb 29                	jmp    800e2b <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 04 24             	mov    %eax,(%esp)
  800e08:	e8 b3 f6 ff ff       	call   8004c0 <fd2data>
  800e0d:	8b 55 14             	mov    0x14(%ebp),%edx
  800e10:	01 c2                	add    %eax,%edx
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e20:	89 14 24             	mov    %edx,(%esp)
  800e23:	e8 98 11 00 00       	call   801fc0 <memmove>
	return n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8d 50 10             	lea    0x10(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e40:	89 04 24             	mov    %eax,(%esp)
  800e43:	e8 86 0f 00 00       	call   801dce <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  800e63:	83 f8 01             	cmp    $0x1,%eax
  800e66:	0f 94 c0             	sete   %al
  800e69:	0f b6 d0             	movzbl %al,%edx
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  800e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  800e82:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  800e89:	7e 0a                	jle    800e95 <file_trunc+0x19>
		return -E_NO_DISK;
  800e8b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800e90:	e9 b4 00 00 00       	jmp    800f49 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8b 40 0c             	mov    0xc(%eax),%eax
  800e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  800eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800eb4:	89 04 24             	mov    %eax,(%esp)
  800eb7:	e8 82 03 00 00       	call   80123e <fsipc_set_size>
  800ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ebf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ec3:	79 05                	jns    800eca <file_trunc+0x4e>
		return r;
  800ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec8:	eb 7f                	jmp    800f49 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800ed3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ed6:	74 24                	je     800efc <file_trunc+0x80>
  800ed8:	c7 44 24 0c 30 27 80 	movl   $0x802730,0xc(%esp)
  800edf:	00 
  800ee0:	c7 44 24 08 53 27 80 	movl   $0x802753,0x8(%esp)
  800ee7:	00 
  800ee8:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  800eef:	00 
  800ef0:	c7 04 24 68 27 80 00 	movl   $0x802768,(%esp)
  800ef7:	e8 8c 04 00 00       	call   801388 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  800efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f06:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 04 24             	mov    %eax,(%esp)
  800f10:	e8 36 00 00 00       	call   800f4b <fmap>
  800f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f1c:	79 05                	jns    800f23 <file_trunc+0xa7>
		return r;
  800f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f21:	eb 26                	jmp    800f49 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  800f23:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800f2a:	00 
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f35:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 04 24             	mov    %eax,(%esp)
  800f3f:	e8 b0 00 00 00       	call   800ff4 <funmap>

	return 0;
  800f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	89 04 24             	mov    %eax,(%esp)
  800f57:	e8 64 f5 ff ff       	call   8004c0 <fd2data>
  800f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  800f5f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	03 45 ec             	add    -0x14(%ebp),%eax
  800f6c:	83 e8 01             	sub    $0x1,%eax
  800f6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f75:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7a:	f7 75 ec             	divl   -0x14(%ebp)
  800f7d:	89 d0                	mov    %edx,%eax
  800f7f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f82:	89 d1                	mov    %edx,%ecx
  800f84:	29 c1                	sub    %eax,%ecx
  800f86:	89 c8                	mov    %ecx,%eax
  800f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f8b:	eb 58                	jmp    800fe5 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  800f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  800f9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fa3:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fa7:	89 04 24             	mov    %eax,(%esp)
  800faa:	e8 04 02 00 00       	call   8011b3 <fsipc_map>
  800faf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb6:	79 26                	jns    800fde <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fbb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800fc2:	00 
  800fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc6:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fca:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	89 04 24             	mov    %eax,(%esp)
  800fd4:	e8 1b 00 00 00       	call   800ff4 <funmap>
			return r;
  800fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fdc:	eb 14                	jmp    800ff2 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  800fde:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	77 a0                	ja     800f8d <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  800fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	89 04 24             	mov    %eax,(%esp)
  801000:	e8 bb f4 ff ff       	call   8004c0 <fd2data>
  801005:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  801008:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80100b:	c1 e8 16             	shr    $0x16,%eax
  80100e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801015:	83 e0 01             	and    $0x1,%eax
  801018:	85 c0                	test   %eax,%eax
  80101a:	75 0a                	jne    801026 <funmap+0x32>
		return 0;
  80101c:	b8 00 00 00 00       	mov    $0x0,%eax
  801021:	e9 bf 00 00 00       	jmp    8010e5 <funmap+0xf1>

	ret = 0;
  801026:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  80102d:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
  801037:	03 45 e8             	add    -0x18(%ebp),%eax
  80103a:	83 e8 01             	sub    $0x1,%eax
  80103d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801040:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801043:	ba 00 00 00 00       	mov    $0x0,%edx
  801048:	f7 75 e8             	divl   -0x18(%ebp)
  80104b:	89 d0                	mov    %edx,%eax
  80104d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801050:	89 d1                	mov    %edx,%ecx
  801052:	29 c1                	sub    %eax,%ecx
  801054:	89 c8                	mov    %ecx,%eax
  801056:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801059:	eb 7b                	jmp    8010d6 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  80105b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801061:	01 d0                	add    %edx,%eax
  801063:	c1 e8 0c             	shr    $0xc,%eax
  801066:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80106d:	83 e0 01             	and    $0x1,%eax
  801070:	84 c0                	test   %al,%al
  801072:	74 5b                	je     8010cf <funmap+0xdb>
			if (dirty
  801074:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801078:	74 3d                	je     8010b7 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  80107a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801080:	01 d0                	add    %edx,%eax
  801082:	c1 e8 0c             	shr    $0xc,%eax
  801085:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80108c:	83 e0 40             	and    $0x40,%eax
  80108f:	85 c0                	test   %eax,%eax
  801091:	74 24                	je     8010b7 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  801093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8b 40 0c             	mov    0xc(%eax),%eax
  80109c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010a0:	89 04 24             	mov    %eax,(%esp)
  8010a3:	e8 13 02 00 00       	call   8012bb <fsipc_dirty>
  8010a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8010ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010af:	79 06                	jns    8010b7 <funmap+0xc3>
				ret = r;
  8010b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  8010b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010bd:	01 d0                	add    %edx,%eax
  8010bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010ca:	e8 22 f2 ff ff       	call   8002f1 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8010cf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010dc:	0f 87 79 ff ff ff    	ja     80105b <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  8010e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <remove>:

// Delete a file
int
remove(const char *path)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	89 04 24             	mov    %eax,(%esp)
  8010f3:	e8 06 02 00 00       	call   8012fe <fsipc_remove>
}
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801100:	e8 56 02 00 00       	call   80135b <fsipc_sync>
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    
	...

00801108 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80110e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801113:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80111a:	00 
  80111b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
  801125:	89 54 24 04          	mov    %edx,0x4(%esp)
  801129:	89 04 24             	mov    %eax,(%esp)
  80112c:	e8 ab 11 00 00       	call   8022dc <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801131:	8b 45 14             	mov    0x14(%ebp),%eax
  801134:	89 44 24 08          	mov    %eax,0x8(%esp)
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80113f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801142:	89 04 24             	mov    %eax,(%esp)
  801145:	e8 06 11 00 00       	call   802250 <ipc_recv>
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801152:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	89 04 24             	mov    %eax,(%esp)
  80115f:	e8 14 0c 00 00       	call   801d78 <strlen>
  801164:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801169:	7e 07                	jle    801172 <fsipc_open+0x26>
		return -E_BAD_PATH;
  80116b:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801170:	eb 3f                	jmp    8011b1 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  801172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	89 54 24 04          	mov    %edx,0x4(%esp)
  80117c:	89 04 24             	mov    %eax,(%esp)
  80117f:	e8 4a 0c 00 00       	call   801dce <strcpy>
	req->req_omode = omode;
  801184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118a:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801190:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801193:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80119e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8011ac:	e8 57 ff ff ff       	call   801108 <fsipc>
}
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  8011b9:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8011c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8011c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ce:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  8011d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8011ed:	e8 16 ff ff ff       	call   801108 <fsipc>
  8011f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011f9:	79 05                	jns    801200 <fsipc_map+0x4d>
		return r;
  8011fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fe:	eb 3c                	jmp    80123c <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  801200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801203:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  801208:	83 f8 05             	cmp    $0x5,%eax
  80120b:	74 2a                	je     801237 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  80120d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801210:	8b 55 10             	mov    0x10(%ebp),%edx
  801213:	89 54 24 10          	mov    %edx,0x10(%esp)
  801217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80121b:	c7 44 24 08 74 27 80 	movl   $0x802774,0x8(%esp)
  801222:	00 
  801223:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  80122a:	00 
  80122b:	c7 04 24 aa 27 80 00 	movl   $0x8027aa,(%esp)
  801232:	e8 51 01 00 00       	call   801388 <_panic>
	return 0;
  801237:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  801244:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80124b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  801253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801256:	8b 55 0c             	mov    0xc(%ebp),%edx
  801259:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  80125c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801263:	00 
  801264:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80126b:	00 
  80126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801273:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80127a:	e8 89 fe ff ff       	call   801108 <fsipc>
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  801287:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80128e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801291:	8b 55 08             	mov    0x8(%ebp),%edx
  801294:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801296:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80129d:	00 
  80129e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012a5:	00 
  8012a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ad:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  8012b4:	e8 4f fe ff ff       	call   801108 <fsipc>
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  8012c1:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8012c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ce:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  8012d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d6:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8012d9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8012e0:	00 
  8012e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012e8:	00 
  8012e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8012f7:	e8 0c fe ff ff       	call   801108 <fsipc>
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801304:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	89 04 24             	mov    %eax,(%esp)
  801311:	e8 62 0a 00 00       	call   801d78 <strlen>
  801316:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80131b:	7e 07                	jle    801324 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  80131d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801322:	eb 35                	jmp    801359 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  801324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801327:	8b 55 08             	mov    0x8(%ebp),%edx
  80132a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80132e:	89 04 24             	mov    %eax,(%esp)
  801331:	e8 98 0a 00 00       	call   801dce <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801336:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80133d:	00 
  80133e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801345:	00 
  801346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801349:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  801354:	e8 af fd ff ff       	call   801108 <fsipc>
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801361:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801368:	00 
  801369:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801370:	00 
  801371:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801378:	00 
  801379:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801380:	e8 83 fd ff ff       	call   801108 <fsipc>
}
  801385:	c9                   	leave  
  801386:	c3                   	ret    
	...

00801388 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  80138e:	8d 45 10             	lea    0x10(%ebp),%eax
  801391:	83 c0 04             	add    $0x4,%eax
  801394:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  801397:	a1 48 50 80 00       	mov    0x805048,%eax
  80139c:	85 c0                	test   %eax,%eax
  80139e:	74 15                	je     8013b5 <_panic+0x2d>
		cprintf("%s: ", argv0);
  8013a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8013a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a9:	c7 04 24 b6 27 80 00 	movl   $0x8027b6,(%esp)
  8013b0:	e8 07 01 00 00       	call   8014bc <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8013b5:	a1 00 50 80 00       	mov    0x805000,%eax
  8013ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cc:	c7 04 24 bb 27 80 00 	movl   $0x8027bb,(%esp)
  8013d3:	e8 e4 00 00 00       	call   8014bc <cprintf>
	vcprintf(fmt, ap);
  8013d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013de:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013e2:	89 04 24             	mov    %eax,(%esp)
  8013e5:	e8 6e 00 00 00       	call   801458 <vcprintf>
	cprintf("\n");
  8013ea:	c7 04 24 d7 27 80 00 	movl   $0x8027d7,(%esp)
  8013f1:	e8 c6 00 00 00       	call   8014bc <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8013f6:	cc                   	int3   
  8013f7:	eb fd                	jmp    8013f6 <_panic+0x6e>
  8013f9:	00 00                	add    %al,(%eax)
	...

008013fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	8b 00                	mov    (%eax),%eax
  801407:	8b 55 08             	mov    0x8(%ebp),%edx
  80140a:	89 d1                	mov    %edx,%ecx
  80140c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  801413:	8d 50 01             	lea    0x1(%eax),%edx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  80141b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141e:	8b 00                	mov    (%eax),%eax
  801420:	3d ff 00 00 00       	cmp    $0xff,%eax
  801425:	75 20                	jne    801447 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	8b 00                	mov    (%eax),%eax
  80142c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142f:	83 c2 08             	add    $0x8,%edx
  801432:	89 44 24 04          	mov    %eax,0x4(%esp)
  801436:	89 14 24             	mov    %edx,(%esp)
  801439:	e8 db ec ff ff       	call   800119 <sys_cputs>
		b->idx = 0;
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144a:	8b 40 04             	mov    0x4(%eax),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	8b 45 0c             	mov    0xc(%ebp),%eax
  801453:	89 50 04             	mov    %edx,0x4(%eax)
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801461:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801468:	00 00 00 
	b.cnt = 0;
  80146b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801472:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801483:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148d:	c7 04 24 fc 13 80 00 	movl   $0x8013fc,(%esp)
  801494:	e8 f7 01 00 00       	call   801690 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801499:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80149f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014a9:	83 c0 08             	add    $0x8,%eax
  8014ac:	89 04 24             	mov    %eax,(%esp)
  8014af:	e8 65 ec ff ff       	call   800119 <sys_cputs>

	return b.cnt;
  8014b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8014c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8014c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014d2:	89 04 24             	mov    %eax,(%esp)
  8014d5:	e8 7e ff ff ff       	call   801458 <vcprintf>
  8014da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8014dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    
	...

008014e4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	53                   	push   %ebx
  8014e8:	83 ec 34             	sub    $0x34,%esp
  8014eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8014f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8014fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801502:	77 72                	ja     801576 <printnum+0x92>
  801504:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801507:	72 05                	jb     80150e <printnum+0x2a>
  801509:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80150c:	77 68                	ja     801576 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80150e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801511:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801514:	8b 45 18             	mov    0x18(%ebp),%eax
  801517:	ba 00 00 00 00       	mov    $0x0,%edx
  80151c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801520:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801527:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152a:	89 04 24             	mov    %eax,(%esp)
  80152d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801531:	e8 4a 0e 00 00       	call   802380 <__udivdi3>
  801536:	8b 4d 20             	mov    0x20(%ebp),%ecx
  801539:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  80153d:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  801541:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801544:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801548:	89 44 24 08          	mov    %eax,0x8(%esp)
  80154c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801550:	8b 45 0c             	mov    0xc(%ebp),%eax
  801553:	89 44 24 04          	mov    %eax,0x4(%esp)
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	89 04 24             	mov    %eax,(%esp)
  80155d:	e8 82 ff ff ff       	call   8014e4 <printnum>
  801562:	eb 1c                	jmp    801580 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801564:	8b 45 0c             	mov    0xc(%ebp),%eax
  801567:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156b:	8b 45 20             	mov    0x20(%ebp),%eax
  80156e:	89 04 24             	mov    %eax,(%esp)
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801576:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  80157a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80157e:	7f e4                	jg     801564 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801580:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801583:	bb 00 00 00 00       	mov    $0x0,%ebx
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801592:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801596:	89 04 24             	mov    %eax,(%esp)
  801599:	89 54 24 04          	mov    %edx,0x4(%esp)
  80159d:	e8 0e 0f 00 00       	call   8024b0 <__umoddi3>
  8015a2:	05 3c 29 80 00       	add    $0x80293c,%eax
  8015a7:	0f b6 00             	movzbl (%eax),%eax
  8015aa:	0f be c0             	movsbl %al,%eax
  8015ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	ff d0                	call   *%eax
}
  8015bc:	83 c4 34             	add    $0x34,%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5d                   	pop    %ebp
  8015c1:	c3                   	ret    

008015c2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015c5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015c9:	7e 1c                	jle    8015e7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8b 00                	mov    (%eax),%eax
  8015d0:	8d 50 08             	lea    0x8(%eax),%edx
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	89 10                	mov    %edx,(%eax)
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	8b 00                	mov    (%eax),%eax
  8015dd:	83 e8 08             	sub    $0x8,%eax
  8015e0:	8b 50 04             	mov    0x4(%eax),%edx
  8015e3:	8b 00                	mov    (%eax),%eax
  8015e5:	eb 40                	jmp    801627 <getuint+0x65>
	else if (lflag)
  8015e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015eb:	74 1e                	je     80160b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8b 00                	mov    (%eax),%eax
  8015f2:	8d 50 04             	lea    0x4(%eax),%edx
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	89 10                	mov    %edx,(%eax)
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8b 00                	mov    (%eax),%eax
  8015ff:	83 e8 04             	sub    $0x4,%eax
  801602:	8b 00                	mov    (%eax),%eax
  801604:	ba 00 00 00 00       	mov    $0x0,%edx
  801609:	eb 1c                	jmp    801627 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	8d 50 04             	lea    0x4(%eax),%edx
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	89 10                	mov    %edx,(%eax)
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	8b 00                	mov    (%eax),%eax
  80161d:	83 e8 04             	sub    $0x4,%eax
  801620:	8b 00                	mov    (%eax),%eax
  801622:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    

00801629 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80162c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801630:	7e 1c                	jle    80164e <getint+0x25>
		return va_arg(*ap, long long);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8b 00                	mov    (%eax),%eax
  801637:	8d 50 08             	lea    0x8(%eax),%edx
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	89 10                	mov    %edx,(%eax)
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8b 00                	mov    (%eax),%eax
  801644:	83 e8 08             	sub    $0x8,%eax
  801647:	8b 50 04             	mov    0x4(%eax),%edx
  80164a:	8b 00                	mov    (%eax),%eax
  80164c:	eb 40                	jmp    80168e <getint+0x65>
	else if (lflag)
  80164e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801652:	74 1e                	je     801672 <getint+0x49>
		return va_arg(*ap, long);
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8b 00                	mov    (%eax),%eax
  801659:	8d 50 04             	lea    0x4(%eax),%edx
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	89 10                	mov    %edx,(%eax)
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	8b 00                	mov    (%eax),%eax
  801666:	83 e8 04             	sub    $0x4,%eax
  801669:	8b 00                	mov    (%eax),%eax
  80166b:	89 c2                	mov    %eax,%edx
  80166d:	c1 fa 1f             	sar    $0x1f,%edx
  801670:	eb 1c                	jmp    80168e <getint+0x65>
	else
		return va_arg(*ap, int);
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8b 00                	mov    (%eax),%eax
  801677:	8d 50 04             	lea    0x4(%eax),%edx
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	89 10                	mov    %edx,(%eax)
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	83 e8 04             	sub    $0x4,%eax
  801687:	8b 00                	mov    (%eax),%eax
  801689:	89 c2                	mov    %eax,%edx
  80168b:	c1 fa 1f             	sar    $0x1f,%edx
}
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	56                   	push   %esi
  801694:	53                   	push   %ebx
  801695:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801698:	eb 17                	jmp    8016b1 <vprintfmt+0x21>
			if (ch == '\0')
  80169a:	85 db                	test   %ebx,%ebx
  80169c:	0f 84 d1 05 00 00    	je     801c73 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  8016a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a9:	89 1c 24             	mov    %ebx,(%esp)
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b4:	0f b6 00             	movzbl (%eax),%eax
  8016b7:	0f b6 d8             	movzbl %al,%ebx
  8016ba:	83 fb 25             	cmp    $0x25,%ebx
  8016bd:	0f 95 c0             	setne  %al
  8016c0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8016c4:	84 c0                	test   %al,%al
  8016c6:	75 d2                	jne    80169a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8016c8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8016cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8016d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8016e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8016e8:	eb 04                	jmp    8016ee <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8016ea:	90                   	nop
  8016eb:	eb 01                	jmp    8016ee <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8016ed:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f1:	0f b6 00             	movzbl (%eax),%eax
  8016f4:	0f b6 d8             	movzbl %al,%ebx
  8016f7:	89 d8                	mov    %ebx,%eax
  8016f9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8016fd:	83 e8 23             	sub    $0x23,%eax
  801700:	83 f8 55             	cmp    $0x55,%eax
  801703:	0f 87 39 05 00 00    	ja     801c42 <vprintfmt+0x5b2>
  801709:	8b 04 85 84 29 80 00 	mov    0x802984(,%eax,4),%eax
  801710:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801712:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801716:	eb d6                	jmp    8016ee <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801718:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80171c:	eb d0                	jmp    8016ee <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80171e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801725:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801728:	89 d0                	mov    %edx,%eax
  80172a:	c1 e0 02             	shl    $0x2,%eax
  80172d:	01 d0                	add    %edx,%eax
  80172f:	01 c0                	add    %eax,%eax
  801731:	01 d8                	add    %ebx,%eax
  801733:	83 e8 30             	sub    $0x30,%eax
  801736:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801739:	8b 45 10             	mov    0x10(%ebp),%eax
  80173c:	0f b6 00             	movzbl (%eax),%eax
  80173f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801742:	83 fb 2f             	cmp    $0x2f,%ebx
  801745:	7e 43                	jle    80178a <vprintfmt+0xfa>
  801747:	83 fb 39             	cmp    $0x39,%ebx
  80174a:	7f 3e                	jg     80178a <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80174c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801750:	eb d3                	jmp    801725 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801752:	8b 45 14             	mov    0x14(%ebp),%eax
  801755:	83 c0 04             	add    $0x4,%eax
  801758:	89 45 14             	mov    %eax,0x14(%ebp)
  80175b:	8b 45 14             	mov    0x14(%ebp),%eax
  80175e:	83 e8 04             	sub    $0x4,%eax
  801761:	8b 00                	mov    (%eax),%eax
  801763:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801766:	eb 23                	jmp    80178b <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  801768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80176c:	0f 89 78 ff ff ff    	jns    8016ea <vprintfmt+0x5a>
				width = 0;
  801772:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801779:	e9 6c ff ff ff       	jmp    8016ea <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  80177e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801785:	e9 64 ff ff ff       	jmp    8016ee <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80178a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80178b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80178f:	0f 89 58 ff ff ff    	jns    8016ed <vprintfmt+0x5d>
				width = precision, precision = -1;
  801795:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801798:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80179b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8017a2:	e9 46 ff ff ff       	jmp    8016ed <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8017a7:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  8017ab:	e9 3e ff ff ff       	jmp    8016ee <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8017b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b3:	83 c0 04             	add    $0x4,%eax
  8017b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8017b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bc:	83 e8 04             	sub    $0x4,%eax
  8017bf:	8b 00                	mov    (%eax),%eax
  8017c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017c8:	89 04 24             	mov    %eax,(%esp)
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	ff d0                	call   *%eax
			break;
  8017d0:	e9 98 04 00 00       	jmp    801c6d <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  8017d5:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  8017dc:	00 
  8017dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e4:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8017e7:	89 04 24             	mov    %eax,(%esp)
  8017ea:	e8 d1 07 00 00       	call   801fc0 <memmove>
            sel_c[3] = '\0';
  8017ef:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  8017f3:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  8017f7:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  8017fb:	3c 2f                	cmp    $0x2f,%al
  8017fd:	7e 4c                	jle    80184b <vprintfmt+0x1bb>
  8017ff:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  801803:	3c 39                	cmp    $0x39,%al
  801805:	7f 44                	jg     80184b <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  801807:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80180b:	0f be d0             	movsbl %al,%edx
  80180e:	89 d0                	mov    %edx,%eax
  801810:	c1 e0 02             	shl    $0x2,%eax
  801813:	01 d0                	add    %edx,%eax
  801815:	01 c0                	add    %eax,%eax
  801817:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  80181d:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  801821:	0f be c0             	movsbl %al,%eax
  801824:	01 c2                	add    %eax,%edx
  801826:	89 d0                	mov    %edx,%eax
  801828:	c1 e0 02             	shl    $0x2,%eax
  80182b:	01 d0                	add    %edx,%eax
  80182d:	01 c0                	add    %eax,%eax
  80182f:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  801835:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  801839:	0f be c0             	movsbl %al,%eax
  80183c:	01 d0                	add    %edx,%eax
  80183e:	83 e8 30             	sub    $0x30,%eax
  801841:	a3 40 50 80 00       	mov    %eax,0x805040
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801846:	e9 22 04 00 00       	jmp    801c6d <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  80184b:	c7 44 24 04 4d 29 80 	movl   $0x80294d,0x4(%esp)
  801852:	00 
  801853:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801856:	89 04 24             	mov    %eax,(%esp)
  801859:	e8 36 06 00 00       	call   801e94 <strcmp>
  80185e:	85 c0                	test   %eax,%eax
  801860:	75 0f                	jne    801871 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  801862:	c7 05 40 50 80 00 07 	movl   $0x7,0x805040
  801869:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80186c:	e9 fc 03 00 00       	jmp    801c6d <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  801871:	c7 44 24 04 51 29 80 	movl   $0x802951,0x4(%esp)
  801878:	00 
  801879:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80187c:	89 04 24             	mov    %eax,(%esp)
  80187f:	e8 10 06 00 00       	call   801e94 <strcmp>
  801884:	85 c0                	test   %eax,%eax
  801886:	75 0f                	jne    801897 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  801888:	c7 05 40 50 80 00 01 	movl   $0x1,0x805040
  80188f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801892:	e9 d6 03 00 00       	jmp    801c6d <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  801897:	c7 44 24 04 55 29 80 	movl   $0x802955,0x4(%esp)
  80189e:	00 
  80189f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8018a2:	89 04 24             	mov    %eax,(%esp)
  8018a5:	e8 ea 05 00 00       	call   801e94 <strcmp>
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	75 0f                	jne    8018bd <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  8018ae:	c7 05 40 50 80 00 02 	movl   $0x2,0x805040
  8018b5:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8018b8:	e9 b0 03 00 00       	jmp    801c6d <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  8018bd:	c7 44 24 04 59 29 80 	movl   $0x802959,0x4(%esp)
  8018c4:	00 
  8018c5:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8018c8:	89 04 24             	mov    %eax,(%esp)
  8018cb:	e8 c4 05 00 00       	call   801e94 <strcmp>
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	75 0f                	jne    8018e3 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  8018d4:	c7 05 40 50 80 00 04 	movl   $0x4,0x805040
  8018db:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8018de:	e9 8a 03 00 00       	jmp    801c6d <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  8018e3:	c7 44 24 04 5d 29 80 	movl   $0x80295d,0x4(%esp)
  8018ea:	00 
  8018eb:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8018ee:	89 04 24             	mov    %eax,(%esp)
  8018f1:	e8 9e 05 00 00       	call   801e94 <strcmp>
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	75 0f                	jne    801909 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  8018fa:	c7 05 40 50 80 00 08 	movl   $0x8,0x805040
  801901:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801904:	e9 64 03 00 00       	jmp    801c6d <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  801909:	c7 44 24 04 61 29 80 	movl   $0x802961,0x4(%esp)
  801910:	00 
  801911:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801914:	89 04 24             	mov    %eax,(%esp)
  801917:	e8 78 05 00 00       	call   801e94 <strcmp>
  80191c:	85 c0                	test   %eax,%eax
  80191e:	75 0f                	jne    80192f <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  801920:	c7 05 40 50 80 00 0f 	movl   $0xf,0x805040
  801927:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80192a:	e9 3e 03 00 00       	jmp    801c6d <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  80192f:	c7 44 24 04 65 29 80 	movl   $0x802965,0x4(%esp)
  801936:	00 
  801937:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80193a:	89 04 24             	mov    %eax,(%esp)
  80193d:	e8 52 05 00 00       	call   801e94 <strcmp>
  801942:	85 c0                	test   %eax,%eax
  801944:	75 0f                	jne    801955 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  801946:	c7 05 40 50 80 00 0c 	movl   $0xc,0x805040
  80194d:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801950:	e9 18 03 00 00       	jmp    801c6d <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  801955:	c7 44 24 04 69 29 80 	movl   $0x802969,0x4(%esp)
  80195c:	00 
  80195d:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801960:	89 04 24             	mov    %eax,(%esp)
  801963:	e8 2c 05 00 00       	call   801e94 <strcmp>
  801968:	85 c0                	test   %eax,%eax
  80196a:	75 0f                	jne    80197b <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  80196c:	c7 05 40 50 80 00 06 	movl   $0x6,0x805040
  801973:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801976:	e9 f2 02 00 00       	jmp    801c6d <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  80197b:	c7 44 24 04 6d 29 80 	movl   $0x80296d,0x4(%esp)
  801982:	00 
  801983:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801986:	89 04 24             	mov    %eax,(%esp)
  801989:	e8 06 05 00 00       	call   801e94 <strcmp>
  80198e:	85 c0                	test   %eax,%eax
  801990:	75 0f                	jne    8019a1 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  801992:	c7 05 40 50 80 00 0b 	movl   $0xb,0x805040
  801999:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80199c:	e9 cc 02 00 00       	jmp    801c6d <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  8019a1:	c7 05 40 50 80 00 07 	movl   $0x7,0x805040
  8019a8:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8019ab:	e9 bd 02 00 00       	jmp    801c6d <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b3:	83 c0 04             	add    $0x4,%eax
  8019b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8019b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bc:	83 e8 04             	sub    $0x4,%eax
  8019bf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019c1:	85 db                	test   %ebx,%ebx
  8019c3:	79 02                	jns    8019c7 <vprintfmt+0x337>
				err = -err;
  8019c5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8019c7:	83 fb 0e             	cmp    $0xe,%ebx
  8019ca:	7f 0b                	jg     8019d7 <vprintfmt+0x347>
  8019cc:	8b 34 9d 00 29 80 00 	mov    0x802900(,%ebx,4),%esi
  8019d3:	85 f6                	test   %esi,%esi
  8019d5:	75 23                	jne    8019fa <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  8019d7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8019db:	c7 44 24 08 71 29 80 	movl   $0x802971,0x8(%esp)
  8019e2:	00 
  8019e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	89 04 24             	mov    %eax,(%esp)
  8019f0:	e8 86 02 00 00       	call   801c7b <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8019f5:	e9 73 02 00 00       	jmp    801c6d <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8019fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019fe:	c7 44 24 08 7a 29 80 	movl   $0x80297a,0x8(%esp)
  801a05:	00 
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	89 04 24             	mov    %eax,(%esp)
  801a13:	e8 63 02 00 00       	call   801c7b <printfmt>
			break;
  801a18:	e9 50 02 00 00       	jmp    801c6d <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a20:	83 c0 04             	add    $0x4,%eax
  801a23:	89 45 14             	mov    %eax,0x14(%ebp)
  801a26:	8b 45 14             	mov    0x14(%ebp),%eax
  801a29:	83 e8 04             	sub    $0x4,%eax
  801a2c:	8b 30                	mov    (%eax),%esi
  801a2e:	85 f6                	test   %esi,%esi
  801a30:	75 05                	jne    801a37 <vprintfmt+0x3a7>
				p = "(null)";
  801a32:	be 7d 29 80 00       	mov    $0x80297d,%esi
			if (width > 0 && padc != '-')
  801a37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a3b:	7e 73                	jle    801ab0 <vprintfmt+0x420>
  801a3d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a41:	74 6d                	je     801ab0 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4a:	89 34 24             	mov    %esi,(%esp)
  801a4d:	e8 4c 03 00 00       	call   801d9e <strnlen>
  801a52:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a55:	eb 17                	jmp    801a6e <vprintfmt+0x3de>
					putch(padc, putdat);
  801a57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a62:	89 04 24             	mov    %eax,(%esp)
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a6a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801a6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a72:	7f e3                	jg     801a57 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a74:	eb 3a                	jmp    801ab0 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  801a76:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a7a:	74 1f                	je     801a9b <vprintfmt+0x40b>
  801a7c:	83 fb 1f             	cmp    $0x1f,%ebx
  801a7f:	7e 05                	jle    801a86 <vprintfmt+0x3f6>
  801a81:	83 fb 7e             	cmp    $0x7e,%ebx
  801a84:	7e 15                	jle    801a9b <vprintfmt+0x40b>
					putch('?', putdat);
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	ff d0                	call   *%eax
  801a99:	eb 0f                	jmp    801aaa <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  801a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa2:	89 1c 24             	mov    %ebx,(%esp)
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801aaa:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801aae:	eb 01                	jmp    801ab1 <vprintfmt+0x421>
  801ab0:	90                   	nop
  801ab1:	0f b6 06             	movzbl (%esi),%eax
  801ab4:	0f be d8             	movsbl %al,%ebx
  801ab7:	85 db                	test   %ebx,%ebx
  801ab9:	0f 95 c0             	setne  %al
  801abc:	83 c6 01             	add    $0x1,%esi
  801abf:	84 c0                	test   %al,%al
  801ac1:	74 29                	je     801aec <vprintfmt+0x45c>
  801ac3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ac7:	78 ad                	js     801a76 <vprintfmt+0x3e6>
  801ac9:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  801acd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ad1:	79 a3                	jns    801a76 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ad3:	eb 17                	jmp    801aec <vprintfmt+0x45c>
				putch(' ', putdat);
  801ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ae8:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801af0:	7f e3                	jg     801ad5 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  801af2:	e9 76 01 00 00       	jmp    801c6d <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afe:	8d 45 14             	lea    0x14(%ebp),%eax
  801b01:	89 04 24             	mov    %eax,(%esp)
  801b04:	e8 20 fb ff ff       	call   801629 <getint>
  801b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b15:	85 d2                	test   %edx,%edx
  801b17:	79 26                	jns    801b3f <vprintfmt+0x4af>
				putch('-', putdat);
  801b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b20:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	ff d0                	call   *%eax
				num = -(long long) num;
  801b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b32:	f7 d8                	neg    %eax
  801b34:	83 d2 00             	adc    $0x0,%edx
  801b37:	f7 da                	neg    %edx
  801b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b46:	e9 ae 00 00 00       	jmp    801bf9 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b52:	8d 45 14             	lea    0x14(%ebp),%eax
  801b55:	89 04 24             	mov    %eax,(%esp)
  801b58:	e8 65 fa ff ff       	call   8015c2 <getuint>
  801b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b63:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b6a:	e9 8a 00 00 00       	jmp    801bf9 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  801b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b76:	8d 45 14             	lea    0x14(%ebp),%eax
  801b79:	89 04 24             	mov    %eax,(%esp)
  801b7c:	e8 41 fa ff ff       	call   8015c2 <getuint>
  801b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  801b87:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  801b8e:	eb 69                	jmp    801bf9 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  801b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b97:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	ff d0                	call   *%eax
			putch('x', putdat);
  801ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801baa:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb9:	83 c0 04             	add    $0x4,%eax
  801bbc:	89 45 14             	mov    %eax,0x14(%ebp)
  801bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc2:	83 e8 04             	sub    $0x4,%eax
  801bc5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801bd1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bd8:	eb 1f                	jmp    801bf9 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be1:	8d 45 14             	lea    0x14(%ebp),%eax
  801be4:	89 04 24             	mov    %eax,(%esp)
  801be7:	e8 d6 f9 ff ff       	call   8015c2 <getuint>
  801bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801bf9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c00:	89 54 24 18          	mov    %edx,0x18(%esp)
  801c04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c07:	89 54 24 14          	mov    %edx,0x14(%esp)
  801c0b:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c15:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c19:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	89 04 24             	mov    %eax,(%esp)
  801c2a:	e8 b5 f8 ff ff       	call   8014e4 <printnum>
			break;
  801c2f:	eb 3c                	jmp    801c6d <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c38:	89 1c 24             	mov    %ebx,(%esp)
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	ff d0                	call   *%eax
			break;
  801c40:	eb 2b                	jmp    801c6d <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c49:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  801c59:	eb 04                	jmp    801c5f <vprintfmt+0x5cf>
  801c5b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  801c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c62:	83 e8 01             	sub    $0x1,%eax
  801c65:	0f b6 00             	movzbl (%eax),%eax
  801c68:	3c 25                	cmp    $0x25,%al
  801c6a:	75 ef                	jne    801c5b <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  801c6c:	90                   	nop
		}
	}
  801c6d:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c6e:	e9 3e fa ff ff       	jmp    8016b1 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  801c73:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c74:	83 c4 50             	add    $0x50,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    

00801c7b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  801c81:	8d 45 10             	lea    0x10(%ebp),%eax
  801c84:	83 c0 04             	add    $0x4,%eax
  801c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c90:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c94:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	89 04 24             	mov    %eax,(%esp)
  801ca5:	e8 e6 f9 ff ff       	call   801690 <vprintfmt>
	va_end(ap);
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb2:	8b 40 08             	mov    0x8(%eax),%eax
  801cb5:	8d 50 01             	lea    0x1(%eax),%edx
  801cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	8b 10                	mov    (%eax),%edx
  801cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc6:	8b 40 04             	mov    0x4(%eax),%eax
  801cc9:	39 c2                	cmp    %eax,%edx
  801ccb:	73 12                	jae    801cdf <sprintputch+0x33>
		*b->buf++ = ch;
  801ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd0:	8b 00                	mov    (%eax),%eax
  801cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd5:	88 10                	mov    %dl,(%eax)
  801cd7:	8d 50 01             	lea    0x1(%eax),%edx
  801cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdd:	89 10                	mov    %edx,(%eax)
}
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    

00801ce1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf0:	83 e8 01             	sub    $0x1,%eax
  801cf3:	03 45 08             	add    0x8(%ebp),%eax
  801cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801d00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d04:	74 06                	je     801d0c <vsnprintf+0x2b>
  801d06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d0a:	7f 07                	jg     801d13 <vsnprintf+0x32>
		return -E_INVAL;
  801d0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d11:	eb 2a                	jmp    801d3d <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d13:	8b 45 14             	mov    0x14(%ebp),%eax
  801d16:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d21:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	c7 04 24 ac 1c 80 00 	movl   $0x801cac,(%esp)
  801d2f:	e8 5c f9 ff ff       	call   801690 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d45:	8d 45 10             	lea    0x10(%ebp),%eax
  801d48:	83 c0 04             	add    $0x4,%eax
  801d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d54:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d58:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	89 04 24             	mov    %eax,(%esp)
  801d69:	e8 73 ff ff ff       	call   801ce1 <vsnprintf>
  801d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    
	...

00801d78 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d85:	eb 08                	jmp    801d8f <strlen+0x17>
		n++;
  801d87:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d8b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	0f b6 00             	movzbl (%eax),%eax
  801d95:	84 c0                	test   %al,%al
  801d97:	75 ee                	jne    801d87 <strlen+0xf>
		n++;
	return n;
  801d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801da4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dab:	eb 0c                	jmp    801db9 <strnlen+0x1b>
		n++;
  801dad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801db1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801db5:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  801db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dbd:	74 0a                	je     801dc9 <strnlen+0x2b>
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	0f b6 00             	movzbl (%eax),%eax
  801dc5:	84 c0                	test   %al,%al
  801dc7:	75 e4                	jne    801dad <strnlen+0xf>
		n++;
	return n;
  801dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dda:	90                   	nop
  801ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dde:	0f b6 10             	movzbl (%eax),%edx
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	88 10                	mov    %dl,(%eax)
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	0f b6 00             	movzbl (%eax),%eax
  801dec:	84 c0                	test   %al,%al
  801dee:	0f 95 c0             	setne  %al
  801df1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801df5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  801df9:	84 c0                	test   %al,%al
  801dfb:	75 de                	jne    801ddb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e15:	eb 21                	jmp    801e38 <strncpy+0x36>
		*dst++ = *src;
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	0f b6 10             	movzbl (%eax),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	88 10                	mov    %dl,(%eax)
  801e22:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e29:	0f b6 00             	movzbl (%eax),%eax
  801e2c:	84 c0                	test   %al,%al
  801e2e:	74 04                	je     801e34 <strncpy+0x32>
			src++;
  801e30:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e34:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e3b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e3e:	72 d7                	jb     801e17 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e40:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e55:	74 2f                	je     801e86 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  801e57:	eb 13                	jmp    801e6c <strlcpy+0x27>
			*dst++ = *src++;
  801e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5c:	0f b6 10             	movzbl (%eax),%edx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	88 10                	mov    %dl,(%eax)
  801e64:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801e68:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e6c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  801e70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e74:	74 0a                	je     801e80 <strlcpy+0x3b>
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	0f b6 00             	movzbl (%eax),%eax
  801e7c:	84 c0                	test   %al,%al
  801e7e:	75 d9                	jne    801e59 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e86:	8b 55 08             	mov    0x8(%ebp),%edx
  801e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e8c:	89 d1                	mov    %edx,%ecx
  801e8e:	29 c1                	sub    %eax,%ecx
  801e90:	89 c8                	mov    %ecx,%eax
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e97:	eb 08                	jmp    801ea1 <strcmp+0xd>
		p++, q++;
  801e99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801e9d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	0f b6 00             	movzbl (%eax),%eax
  801ea7:	84 c0                	test   %al,%al
  801ea9:	74 10                	je     801ebb <strcmp+0x27>
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	0f b6 10             	movzbl (%eax),%edx
  801eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb4:	0f b6 00             	movzbl (%eax),%eax
  801eb7:	38 c2                	cmp    %al,%dl
  801eb9:	74 de                	je     801e99 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	0f b6 00             	movzbl (%eax),%eax
  801ec1:	0f b6 d0             	movzbl %al,%edx
  801ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec7:	0f b6 00             	movzbl (%eax),%eax
  801eca:	0f b6 c0             	movzbl %al,%eax
  801ecd:	89 d1                	mov    %edx,%ecx
  801ecf:	29 c1                	sub    %eax,%ecx
  801ed1:	89 c8                	mov    %ecx,%eax
}
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    

00801ed5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ed8:	eb 0c                	jmp    801ee6 <strncmp+0x11>
		n--, p++, q++;
  801eda:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  801ede:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801ee2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ee6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eea:	74 1a                	je     801f06 <strncmp+0x31>
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	0f b6 00             	movzbl (%eax),%eax
  801ef2:	84 c0                	test   %al,%al
  801ef4:	74 10                	je     801f06 <strncmp+0x31>
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	0f b6 10             	movzbl (%eax),%edx
  801efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eff:	0f b6 00             	movzbl (%eax),%eax
  801f02:	38 c2                	cmp    %al,%dl
  801f04:	74 d4                	je     801eda <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801f06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f0a:	75 07                	jne    801f13 <strncmp+0x3e>
		return 0;
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f11:	eb 18                	jmp    801f2b <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	0f b6 00             	movzbl (%eax),%eax
  801f19:	0f b6 d0             	movzbl %al,%edx
  801f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1f:	0f b6 00             	movzbl (%eax),%eax
  801f22:	0f b6 c0             	movzbl %al,%eax
  801f25:	89 d1                	mov    %edx,%ecx
  801f27:	29 c1                	sub    %eax,%ecx
  801f29:	89 c8                	mov    %ecx,%eax
}
  801f2b:	5d                   	pop    %ebp
  801f2c:	c3                   	ret    

00801f2d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f39:	eb 14                	jmp    801f4f <strchr+0x22>
		if (*s == c)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	0f b6 00             	movzbl (%eax),%eax
  801f41:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f44:	75 05                	jne    801f4b <strchr+0x1e>
			return (char *) s;
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	eb 13                	jmp    801f5e <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f4b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	0f b6 00             	movzbl (%eax),%eax
  801f55:	84 c0                	test   %al,%al
  801f57:	75 e2                	jne    801f3b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 04             	sub    $0x4,%esp
  801f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f6c:	eb 0f                	jmp    801f7d <strfind+0x1d>
		if (*s == c)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	0f b6 00             	movzbl (%eax),%eax
  801f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f77:	74 10                	je     801f89 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	0f b6 00             	movzbl (%eax),%eax
  801f83:	84 c0                	test   %al,%al
  801f85:	75 e7                	jne    801f6e <strfind+0xe>
  801f87:	eb 01                	jmp    801f8a <strfind+0x2a>
		if (*s == c)
			break;
  801f89:	90                   	nop
	return (char *) s;
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <memset>:


void *
memset(void *v, int c, size_t n)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801fa1:	eb 0e                	jmp    801fb1 <memset+0x22>
		*p++ = c;
  801fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa6:	89 c2                	mov    %eax,%edx
  801fa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fab:	88 10                	mov    %dl,(%eax)
  801fad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801fb1:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  801fb5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801fb9:	79 e8                	jns    801fa3 <memset+0x14>
		*p++ = c;

	return v;
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  801fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd8:	73 54                	jae    80202e <memmove+0x6e>
  801fda:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fe0:	01 d0                	add    %edx,%eax
  801fe2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fe5:	76 47                	jbe    80202e <memmove+0x6e>
		s += n;
  801fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fea:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fed:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801ff3:	eb 13                	jmp    802008 <memmove+0x48>
			*--d = *--s;
  801ff5:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  801ff9:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  801ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802000:	0f b6 10             	movzbl (%eax),%edx
  802003:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802006:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80200c:	0f 95 c0             	setne  %al
  80200f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  802013:	84 c0                	test   %al,%al
  802015:	75 de                	jne    801ff5 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802017:	eb 25                	jmp    80203e <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802019:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201c:	0f b6 10             	movzbl (%eax),%edx
  80201f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802022:	88 10                	mov    %dl,(%eax)
  802024:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  802028:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  80202c:	eb 01                	jmp    80202f <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80202e:	90                   	nop
  80202f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802033:	0f 95 c0             	setne  %al
  802036:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80203a:	84 c0                	test   %al,%al
  80203c:	75 db                	jne    802019 <memmove+0x59>
			*d++ = *s++;

	return dst;
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802049:	8b 45 10             	mov    0x10(%ebp),%eax
  80204c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802050:	8b 45 0c             	mov    0xc(%ebp),%eax
  802053:	89 44 24 04          	mov    %eax,0x4(%esp)
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	89 04 24             	mov    %eax,(%esp)
  80205d:	e8 5e ff ff ff       	call   801fc0 <memmove>
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802070:	8b 45 0c             	mov    0xc(%ebp),%eax
  802073:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802076:	eb 32                	jmp    8020aa <memcmp+0x46>
		if (*s1 != *s2)
  802078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207b:	0f b6 10             	movzbl (%eax),%edx
  80207e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802081:	0f b6 00             	movzbl (%eax),%eax
  802084:	38 c2                	cmp    %al,%dl
  802086:	74 1a                	je     8020a2 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  802088:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208b:	0f b6 00             	movzbl (%eax),%eax
  80208e:	0f b6 d0             	movzbl %al,%edx
  802091:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802094:	0f b6 00             	movzbl (%eax),%eax
  802097:	0f b6 c0             	movzbl %al,%eax
  80209a:	89 d1                	mov    %edx,%ecx
  80209c:	29 c1                	sub    %eax,%ecx
  80209e:	89 c8                	mov    %ecx,%eax
  8020a0:	eb 1c                	jmp    8020be <memcmp+0x5a>
		s1++, s2++;
  8020a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8020a6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8020aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020ae:	0f 95 c0             	setne  %al
  8020b1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8020b5:	84 c0                	test   %al,%al
  8020b7:	75 bf                	jne    802078 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8020b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8020c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cc:	01 d0                	add    %edx,%eax
  8020ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8020d1:	eb 11                	jmp    8020e4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	0f b6 10             	movzbl (%eax),%edx
  8020d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020dc:	38 c2                	cmp    %al,%dl
  8020de:	74 0e                	je     8020ee <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020ea:	72 e7                	jb     8020d3 <memfind+0x13>
  8020ec:	eb 01                	jmp    8020ef <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020ee:	90                   	nop
	return (void *) s;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802101:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802108:	eb 04                	jmp    80210e <strtol+0x1a>
		s++;
  80210a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	0f b6 00             	movzbl (%eax),%eax
  802114:	3c 20                	cmp    $0x20,%al
  802116:	74 f2                	je     80210a <strtol+0x16>
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	0f b6 00             	movzbl (%eax),%eax
  80211e:	3c 09                	cmp    $0x9,%al
  802120:	74 e8                	je     80210a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	0f b6 00             	movzbl (%eax),%eax
  802128:	3c 2b                	cmp    $0x2b,%al
  80212a:	75 06                	jne    802132 <strtol+0x3e>
		s++;
  80212c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  802130:	eb 15                	jmp    802147 <strtol+0x53>
	else if (*s == '-')
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	0f b6 00             	movzbl (%eax),%eax
  802138:	3c 2d                	cmp    $0x2d,%al
  80213a:	75 0b                	jne    802147 <strtol+0x53>
		s++, neg = 1;
  80213c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  802140:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802147:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80214b:	74 06                	je     802153 <strtol+0x5f>
  80214d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802151:	75 24                	jne    802177 <strtol+0x83>
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	0f b6 00             	movzbl (%eax),%eax
  802159:	3c 30                	cmp    $0x30,%al
  80215b:	75 1a                	jne    802177 <strtol+0x83>
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	83 c0 01             	add    $0x1,%eax
  802163:	0f b6 00             	movzbl (%eax),%eax
  802166:	3c 78                	cmp    $0x78,%al
  802168:	75 0d                	jne    802177 <strtol+0x83>
		s += 2, base = 16;
  80216a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80216e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802175:	eb 2a                	jmp    8021a1 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  802177:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80217b:	75 17                	jne    802194 <strtol+0xa0>
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	0f b6 00             	movzbl (%eax),%eax
  802183:	3c 30                	cmp    $0x30,%al
  802185:	75 0d                	jne    802194 <strtol+0xa0>
		s++, base = 8;
  802187:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80218b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802192:	eb 0d                	jmp    8021a1 <strtol+0xad>
	else if (base == 0)
  802194:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802198:	75 07                	jne    8021a1 <strtol+0xad>
		base = 10;
  80219a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	0f b6 00             	movzbl (%eax),%eax
  8021a7:	3c 2f                	cmp    $0x2f,%al
  8021a9:	7e 1b                	jle    8021c6 <strtol+0xd2>
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	0f b6 00             	movzbl (%eax),%eax
  8021b1:	3c 39                	cmp    $0x39,%al
  8021b3:	7f 11                	jg     8021c6 <strtol+0xd2>
			dig = *s - '0';
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	0f b6 00             	movzbl (%eax),%eax
  8021bb:	0f be c0             	movsbl %al,%eax
  8021be:	83 e8 30             	sub    $0x30,%eax
  8021c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c4:	eb 48                	jmp    80220e <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	0f b6 00             	movzbl (%eax),%eax
  8021cc:	3c 60                	cmp    $0x60,%al
  8021ce:	7e 1b                	jle    8021eb <strtol+0xf7>
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	0f b6 00             	movzbl (%eax),%eax
  8021d6:	3c 7a                	cmp    $0x7a,%al
  8021d8:	7f 11                	jg     8021eb <strtol+0xf7>
			dig = *s - 'a' + 10;
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	0f b6 00             	movzbl (%eax),%eax
  8021e0:	0f be c0             	movsbl %al,%eax
  8021e3:	83 e8 57             	sub    $0x57,%eax
  8021e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e9:	eb 23                	jmp    80220e <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	0f b6 00             	movzbl (%eax),%eax
  8021f1:	3c 40                	cmp    $0x40,%al
  8021f3:	7e 38                	jle    80222d <strtol+0x139>
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	0f b6 00             	movzbl (%eax),%eax
  8021fb:	3c 5a                	cmp    $0x5a,%al
  8021fd:	7f 2e                	jg     80222d <strtol+0x139>
			dig = *s - 'A' + 10;
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	0f b6 00             	movzbl (%eax),%eax
  802205:	0f be c0             	movsbl %al,%eax
  802208:	83 e8 37             	sub    $0x37,%eax
  80220b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	3b 45 10             	cmp    0x10(%ebp),%eax
  802214:	7d 16                	jge    80222c <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  802216:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80221a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80221d:	0f af 45 10          	imul   0x10(%ebp),%eax
  802221:	03 45 f4             	add    -0xc(%ebp),%eax
  802224:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802227:	e9 75 ff ff ff       	jmp    8021a1 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80222c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80222d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802231:	74 08                	je     80223b <strtol+0x147>
		*endptr = (char *) s;
  802233:	8b 45 0c             	mov    0xc(%ebp),%eax
  802236:	8b 55 08             	mov    0x8(%ebp),%edx
  802239:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80223b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80223f:	74 07                	je     802248 <strtol+0x154>
  802241:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802244:	f7 d8                	neg    %eax
  802246:	eb 03                	jmp    80224b <strtol+0x157>
  802248:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    
  80224d:	00 00                	add    %al,(%eax)
	...

00802250 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  802256:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80225a:	75 11                	jne    80226d <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  80225c:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  802263:	e8 13 e2 ff ff       	call   80047b <sys_ipc_recv>
  802268:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226b:	eb 0e                	jmp    80227b <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  80226d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802270:	89 04 24             	mov    %eax,(%esp)
  802273:	e8 03 e2 ff ff       	call   80047b <sys_ipc_recv>
  802278:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  80227b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227f:	79 1c                	jns    80229d <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  802281:	c7 44 24 08 dc 2a 80 	movl   $0x802adc,0x8(%esp)
  802288:	00 
  802289:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  802290:	00 
  802291:	c7 04 24 f2 2a 80 00 	movl   $0x802af2,(%esp)
  802298:	e8 eb f0 ff ff       	call   801388 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  80229d:	e8 40 df ff ff       	call   8001e2 <sys_getenvid>
  8022a2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022a7:	c1 e0 07             	shl    $0x7,%eax
  8022aa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  8022b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b6:	74 0b                	je     8022c3 <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	8b 50 74             	mov    0x74(%eax),%edx
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  8022c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022c7:	74 0b                	je     8022d4 <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  8022c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cc:	8b 50 78             	mov    0x78(%eax),%edx
  8022cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d2:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  8022d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d7:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  8022e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022e6:	75 26                	jne    80230e <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  8022e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8022eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022ef:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  8022f6:	ee 
  8022f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	89 04 24             	mov    %eax,(%esp)
  802304:	e8 32 e1 ff ff       	call   80043b <sys_ipc_try_send>
  802309:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230c:	eb 23                	jmp    802331 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  80230e:	8b 45 14             	mov    0x14(%ebp),%eax
  802311:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802315:	8b 45 10             	mov    0x10(%ebp),%eax
  802318:	89 44 24 08          	mov    %eax,0x8(%esp)
  80231c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	89 04 24             	mov    %eax,(%esp)
  802329:	e8 0d e1 ff ff       	call   80043b <sys_ipc_try_send>
  80232e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  802331:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802335:	79 29                	jns    802360 <ipc_send+0x84>
  802337:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  80233b:	74 23                	je     802360 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802344:	c7 44 24 08 fc 2a 80 	movl   $0x802afc,0x8(%esp)
  80234b:	00 
  80234c:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  802353:	00 
  802354:	c7 04 24 f2 2a 80 00 	movl   $0x802af2,(%esp)
  80235b:	e8 28 f0 ff ff       	call   801388 <_panic>
	    sys_yield();
  802360:	e8 c1 de ff ff       	call   800226 <sys_yield>
	}while(r < 0);
  802365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802369:	0f 88 73 ff ff ff    	js     8022e2 <ipc_send+0x6>
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    
	...

00802380 <__udivdi3>:
  802380:	83 ec 1c             	sub    $0x1c,%esp
  802383:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802387:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80238b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80238f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802393:	89 74 24 10          	mov    %esi,0x10(%esp)
  802397:	8b 74 24 24          	mov    0x24(%esp),%esi
  80239b:	85 ff                	test   %edi,%edi
  80239d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8023a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023a5:	89 cd                	mov    %ecx,%ebp
  8023a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ab:	75 33                	jne    8023e0 <__udivdi3+0x60>
  8023ad:	39 f1                	cmp    %esi,%ecx
  8023af:	77 57                	ja     802408 <__udivdi3+0x88>
  8023b1:	85 c9                	test   %ecx,%ecx
  8023b3:	75 0b                	jne    8023c0 <__udivdi3+0x40>
  8023b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ba:	31 d2                	xor    %edx,%edx
  8023bc:	f7 f1                	div    %ecx
  8023be:	89 c1                	mov    %eax,%ecx
  8023c0:	89 f0                	mov    %esi,%eax
  8023c2:	31 d2                	xor    %edx,%edx
  8023c4:	f7 f1                	div    %ecx
  8023c6:	89 c6                	mov    %eax,%esi
  8023c8:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023cc:	f7 f1                	div    %ecx
  8023ce:	89 f2                	mov    %esi,%edx
  8023d0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8023d4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8023d8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8023dc:	83 c4 1c             	add    $0x1c,%esp
  8023df:	c3                   	ret    
  8023e0:	31 d2                	xor    %edx,%edx
  8023e2:	31 c0                	xor    %eax,%eax
  8023e4:	39 f7                	cmp    %esi,%edi
  8023e6:	77 e8                	ja     8023d0 <__udivdi3+0x50>
  8023e8:	0f bd cf             	bsr    %edi,%ecx
  8023eb:	83 f1 1f             	xor    $0x1f,%ecx
  8023ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023f2:	75 2c                	jne    802420 <__udivdi3+0xa0>
  8023f4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8023f8:	76 04                	jbe    8023fe <__udivdi3+0x7e>
  8023fa:	39 f7                	cmp    %esi,%edi
  8023fc:	73 d2                	jae    8023d0 <__udivdi3+0x50>
  8023fe:	31 d2                	xor    %edx,%edx
  802400:	b8 01 00 00 00       	mov    $0x1,%eax
  802405:	eb c9                	jmp    8023d0 <__udivdi3+0x50>
  802407:	90                   	nop
  802408:	89 f2                	mov    %esi,%edx
  80240a:	f7 f1                	div    %ecx
  80240c:	31 d2                	xor    %edx,%edx
  80240e:	8b 74 24 10          	mov    0x10(%esp),%esi
  802412:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802416:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80241a:	83 c4 1c             	add    $0x1c,%esp
  80241d:	c3                   	ret    
  80241e:	66 90                	xchg   %ax,%ax
  802420:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802425:	b8 20 00 00 00       	mov    $0x20,%eax
  80242a:	89 ea                	mov    %ebp,%edx
  80242c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802430:	d3 e7                	shl    %cl,%edi
  802432:	89 c1                	mov    %eax,%ecx
  802434:	d3 ea                	shr    %cl,%edx
  802436:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80243b:	09 fa                	or     %edi,%edx
  80243d:	89 f7                	mov    %esi,%edi
  80243f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802443:	89 f2                	mov    %esi,%edx
  802445:	8b 74 24 08          	mov    0x8(%esp),%esi
  802449:	d3 e5                	shl    %cl,%ebp
  80244b:	89 c1                	mov    %eax,%ecx
  80244d:	d3 ef                	shr    %cl,%edi
  80244f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802454:	d3 e2                	shl    %cl,%edx
  802456:	89 c1                	mov    %eax,%ecx
  802458:	d3 ee                	shr    %cl,%esi
  80245a:	09 d6                	or     %edx,%esi
  80245c:	89 fa                	mov    %edi,%edx
  80245e:	89 f0                	mov    %esi,%eax
  802460:	f7 74 24 0c          	divl   0xc(%esp)
  802464:	89 d7                	mov    %edx,%edi
  802466:	89 c6                	mov    %eax,%esi
  802468:	f7 e5                	mul    %ebp
  80246a:	39 d7                	cmp    %edx,%edi
  80246c:	72 22                	jb     802490 <__udivdi3+0x110>
  80246e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802472:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802477:	d3 e5                	shl    %cl,%ebp
  802479:	39 c5                	cmp    %eax,%ebp
  80247b:	73 04                	jae    802481 <__udivdi3+0x101>
  80247d:	39 d7                	cmp    %edx,%edi
  80247f:	74 0f                	je     802490 <__udivdi3+0x110>
  802481:	89 f0                	mov    %esi,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	e9 46 ff ff ff       	jmp    8023d0 <__udivdi3+0x50>
  80248a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802490:	8d 46 ff             	lea    -0x1(%esi),%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	8b 74 24 10          	mov    0x10(%esp),%esi
  802499:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80249d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024a1:	83 c4 1c             	add    $0x1c,%esp
  8024a4:	c3                   	ret    
	...

008024b0 <__umoddi3>:
  8024b0:	83 ec 1c             	sub    $0x1c,%esp
  8024b3:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  8024b7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  8024bb:	8b 44 24 20          	mov    0x20(%esp),%eax
  8024bf:	89 74 24 10          	mov    %esi,0x10(%esp)
  8024c3:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  8024c7:	8b 74 24 24          	mov    0x24(%esp),%esi
  8024cb:	85 ed                	test   %ebp,%ebp
  8024cd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8024d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d5:	89 cf                	mov    %ecx,%edi
  8024d7:	89 04 24             	mov    %eax,(%esp)
  8024da:	89 f2                	mov    %esi,%edx
  8024dc:	75 1a                	jne    8024f8 <__umoddi3+0x48>
  8024de:	39 f1                	cmp    %esi,%ecx
  8024e0:	76 4e                	jbe    802530 <__umoddi3+0x80>
  8024e2:	f7 f1                	div    %ecx
  8024e4:	89 d0                	mov    %edx,%eax
  8024e6:	31 d2                	xor    %edx,%edx
  8024e8:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024ec:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024f0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024f4:	83 c4 1c             	add    $0x1c,%esp
  8024f7:	c3                   	ret    
  8024f8:	39 f5                	cmp    %esi,%ebp
  8024fa:	77 54                	ja     802550 <__umoddi3+0xa0>
  8024fc:	0f bd c5             	bsr    %ebp,%eax
  8024ff:	83 f0 1f             	xor    $0x1f,%eax
  802502:	89 44 24 04          	mov    %eax,0x4(%esp)
  802506:	75 60                	jne    802568 <__umoddi3+0xb8>
  802508:	3b 0c 24             	cmp    (%esp),%ecx
  80250b:	0f 87 07 01 00 00    	ja     802618 <__umoddi3+0x168>
  802511:	89 f2                	mov    %esi,%edx
  802513:	8b 34 24             	mov    (%esp),%esi
  802516:	29 ce                	sub    %ecx,%esi
  802518:	19 ea                	sbb    %ebp,%edx
  80251a:	89 34 24             	mov    %esi,(%esp)
  80251d:	8b 04 24             	mov    (%esp),%eax
  802520:	8b 74 24 10          	mov    0x10(%esp),%esi
  802524:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802528:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80252c:	83 c4 1c             	add    $0x1c,%esp
  80252f:	c3                   	ret    
  802530:	85 c9                	test   %ecx,%ecx
  802532:	75 0b                	jne    80253f <__umoddi3+0x8f>
  802534:	b8 01 00 00 00       	mov    $0x1,%eax
  802539:	31 d2                	xor    %edx,%edx
  80253b:	f7 f1                	div    %ecx
  80253d:	89 c1                	mov    %eax,%ecx
  80253f:	89 f0                	mov    %esi,%eax
  802541:	31 d2                	xor    %edx,%edx
  802543:	f7 f1                	div    %ecx
  802545:	8b 04 24             	mov    (%esp),%eax
  802548:	f7 f1                	div    %ecx
  80254a:	eb 98                	jmp    8024e4 <__umoddi3+0x34>
  80254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802550:	89 f2                	mov    %esi,%edx
  802552:	8b 74 24 10          	mov    0x10(%esp),%esi
  802556:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80255a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80255e:	83 c4 1c             	add    $0x1c,%esp
  802561:	c3                   	ret    
  802562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802568:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80256d:	89 e8                	mov    %ebp,%eax
  80256f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802574:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802578:	89 fa                	mov    %edi,%edx
  80257a:	d3 e0                	shl    %cl,%eax
  80257c:	89 e9                	mov    %ebp,%ecx
  80257e:	d3 ea                	shr    %cl,%edx
  802580:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802585:	09 c2                	or     %eax,%edx
  802587:	8b 44 24 08          	mov    0x8(%esp),%eax
  80258b:	89 14 24             	mov    %edx,(%esp)
  80258e:	89 f2                	mov    %esi,%edx
  802590:	d3 e7                	shl    %cl,%edi
  802592:	89 e9                	mov    %ebp,%ecx
  802594:	d3 ea                	shr    %cl,%edx
  802596:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80259b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80259f:	d3 e6                	shl    %cl,%esi
  8025a1:	89 e9                	mov    %ebp,%ecx
  8025a3:	d3 e8                	shr    %cl,%eax
  8025a5:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025aa:	09 f0                	or     %esi,%eax
  8025ac:	8b 74 24 08          	mov    0x8(%esp),%esi
  8025b0:	f7 34 24             	divl   (%esp)
  8025b3:	d3 e6                	shl    %cl,%esi
  8025b5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8025b9:	89 d6                	mov    %edx,%esi
  8025bb:	f7 e7                	mul    %edi
  8025bd:	39 d6                	cmp    %edx,%esi
  8025bf:	89 c1                	mov    %eax,%ecx
  8025c1:	89 d7                	mov    %edx,%edi
  8025c3:	72 3f                	jb     802604 <__umoddi3+0x154>
  8025c5:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8025c9:	72 35                	jb     802600 <__umoddi3+0x150>
  8025cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025cf:	29 c8                	sub    %ecx,%eax
  8025d1:	19 fe                	sbb    %edi,%esi
  8025d3:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025d8:	89 f2                	mov    %esi,%edx
  8025da:	d3 e8                	shr    %cl,%eax
  8025dc:	89 e9                	mov    %ebp,%ecx
  8025de:	d3 e2                	shl    %cl,%edx
  8025e0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025e5:	09 d0                	or     %edx,%eax
  8025e7:	89 f2                	mov    %esi,%edx
  8025e9:	d3 ea                	shr    %cl,%edx
  8025eb:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025ef:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025f3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025f7:	83 c4 1c             	add    $0x1c,%esp
  8025fa:	c3                   	ret    
  8025fb:	90                   	nop
  8025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802600:	39 d6                	cmp    %edx,%esi
  802602:	75 c7                	jne    8025cb <__umoddi3+0x11b>
  802604:	89 d7                	mov    %edx,%edi
  802606:	89 c1                	mov    %eax,%ecx
  802608:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  80260c:	1b 3c 24             	sbb    (%esp),%edi
  80260f:	eb ba                	jmp    8025cb <__umoddi3+0x11b>
  802611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802618:	39 f5                	cmp    %esi,%ebp
  80261a:	0f 82 f1 fe ff ff    	jb     802511 <__umoddi3+0x61>
  802620:	e9 f8 fe ff ff       	jmp    80251d <__umoddi3+0x6d>
