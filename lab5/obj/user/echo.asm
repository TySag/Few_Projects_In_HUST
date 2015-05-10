
obj/user/echo:     file format elf32-i386


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
  80002c:	e8 d3 00 00 00       	call   800104 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 28             	sub    $0x28,%esp
	int i, nflag;

	nflag = 0;
  80003a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800041:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800045:	7e 2b                	jle    800072 <umain+0x3e>
  800047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80004a:	83 c0 04             	add    $0x4,%eax
  80004d:	8b 00                	mov    (%eax),%eax
  80004f:	c7 44 24 04 e0 26 80 	movl   $0x8026e0,0x4(%esp)
  800056:	00 
  800057:	89 04 24             	mov    %eax,(%esp)
  80005a:	e8 25 02 00 00       	call   800284 <strcmp>
  80005f:	85 c0                	test   %eax,%eax
  800061:	75 0f                	jne    800072 <umain+0x3e>
		nflag = 1;
  800063:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		argc--;
  80006a:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
		argv++;
  80006e:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
	}
	for (i = 1; i < argc; i++) {
  800072:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  800079:	eb 5a                	jmp    8000d5 <umain+0xa1>
		if (i > 1)
  80007b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80007f:	7e 1c                	jle    80009d <umain+0x69>
			write(1, " ", 1);
  800081:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800088:	00 
  800089:	c7 44 24 04 e3 26 80 	movl   $0x8026e3,0x4(%esp)
  800090:	00 
  800091:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800098:	e8 62 0e 00 00       	call   800eff <write>
		write(1, argv[i], strlen(argv[i]));
  80009d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a0:	c1 e0 02             	shl    $0x2,%eax
  8000a3:	03 45 0c             	add    0xc(%ebp),%eax
  8000a6:	8b 00                	mov    (%eax),%eax
  8000a8:	89 04 24             	mov    %eax,(%esp)
  8000ab:	e8 b8 00 00 00       	call   800168 <strlen>
  8000b0:	89 c2                	mov    %eax,%edx
  8000b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b5:	c1 e0 02             	shl    $0x2,%eax
  8000b8:	03 45 0c             	add    0xc(%ebp),%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000cc:	e8 2e 0e 00 00       	call   800eff <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8000d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8000db:	7c 9e                	jl     80007b <umain+0x47>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8000e1:	75 1c                	jne    8000ff <umain+0xcb>
		write(1, "\n", 1);
  8000e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000ea:	00 
  8000eb:	c7 44 24 04 e5 26 80 	movl   $0x8026e5,0x4(%esp)
  8000f2:	00 
  8000f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fa:	e8 00 0e 00 00       	call   800eff <write>
}
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    
  800101:	00 00                	add    %al,(%eax)
	...

00800104 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  80010a:	e8 63 06 00 00       	call   800772 <sys_getenvid>
  80010f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800114:	c1 e0 07             	shl    $0x7,%eax
  800117:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011c:	a3 44 50 80 00       	mov    %eax,0x805044
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800121:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800125:	7e 0a                	jle    800131 <libmain+0x2d>
		binaryname = argv[0];
  800127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012a:	8b 00                	mov    (%eax),%eax
  80012c:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	umain(argc, argv);
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	89 44 24 04          	mov    %eax,0x4(%esp)
  800138:	8b 45 08             	mov    0x8(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 f1 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800143:	e8 04 00 00 00       	call   80014c <exit>
}
  800148:	c9                   	leave  
  800149:	c3                   	ret    
	...

0080014c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800152:	e8 ef 0a 00 00       	call   800c46 <close_all>
	sys_env_destroy(0);
  800157:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015e:	e8 cc 05 00 00       	call   80072f <sys_env_destroy>
}
  800163:	c9                   	leave  
  800164:	c3                   	ret    
  800165:	00 00                	add    %al,(%eax)
	...

00800168 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80016e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800175:	eb 08                	jmp    80017f <strlen+0x17>
		n++;
  800177:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80017b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80017f:	8b 45 08             	mov    0x8(%ebp),%eax
  800182:	0f b6 00             	movzbl (%eax),%eax
  800185:	84 c0                	test   %al,%al
  800187:	75 ee                	jne    800177 <strlen+0xf>
		n++;
	return n;
  800189:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    

0080018e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800194:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80019b:	eb 0c                	jmp    8001a9 <strnlen+0x1b>
		n++;
  80019d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8001a5:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  8001a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8001ad:	74 0a                	je     8001b9 <strnlen+0x2b>
  8001af:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b2:	0f b6 00             	movzbl (%eax),%eax
  8001b5:	84 c0                	test   %al,%al
  8001b7:	75 e4                	jne    80019d <strnlen+0xf>
		n++;
	return n;
  8001b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8001c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8001ca:	90                   	nop
  8001cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ce:	0f b6 10             	movzbl (%eax),%edx
  8001d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d4:	88 10                	mov    %dl,(%eax)
  8001d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d9:	0f b6 00             	movzbl (%eax),%eax
  8001dc:	84 c0                	test   %al,%al
  8001de:	0f 95 c0             	setne  %al
  8001e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8001e5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  8001e9:	84 c0                	test   %al,%al
  8001eb:	75 de                	jne    8001cb <strcpy+0xd>
		/* do nothing */;
	return ret;
  8001ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  8001f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8001fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800205:	eb 21                	jmp    800228 <strncpy+0x36>
		*dst++ = *src;
  800207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020a:	0f b6 10             	movzbl (%eax),%edx
  80020d:	8b 45 08             	mov    0x8(%ebp),%eax
  800210:	88 10                	mov    %dl,(%eax)
  800212:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800216:	8b 45 0c             	mov    0xc(%ebp),%eax
  800219:	0f b6 00             	movzbl (%eax),%eax
  80021c:	84 c0                	test   %al,%al
  80021e:	74 04                	je     800224 <strncpy+0x32>
			src++;
  800220:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800224:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800228:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80022b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80022e:	72 d7                	jb     800207 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800230:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800233:	c9                   	leave  
  800234:	c3                   	ret    

00800235 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80023b:	8b 45 08             	mov    0x8(%ebp),%eax
  80023e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800241:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800245:	74 2f                	je     800276 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800247:	eb 13                	jmp    80025c <strlcpy+0x27>
			*dst++ = *src++;
  800249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024c:	0f b6 10             	movzbl (%eax),%edx
  80024f:	8b 45 08             	mov    0x8(%ebp),%eax
  800252:	88 10                	mov    %dl,(%eax)
  800254:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800258:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80025c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800260:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800264:	74 0a                	je     800270 <strlcpy+0x3b>
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
  800269:	0f b6 00             	movzbl (%eax),%eax
  80026c:	84 c0                	test   %al,%al
  80026e:	75 d9                	jne    800249 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800270:	8b 45 08             	mov    0x8(%ebp),%eax
  800273:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800276:	8b 55 08             	mov    0x8(%ebp),%edx
  800279:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80027c:	89 d1                	mov    %edx,%ecx
  80027e:	29 c1                	sub    %eax,%ecx
  800280:	89 c8                	mov    %ecx,%eax
}
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800287:	eb 08                	jmp    800291 <strcmp+0xd>
		p++, q++;
  800289:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80028d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800291:	8b 45 08             	mov    0x8(%ebp),%eax
  800294:	0f b6 00             	movzbl (%eax),%eax
  800297:	84 c0                	test   %al,%al
  800299:	74 10                	je     8002ab <strcmp+0x27>
  80029b:	8b 45 08             	mov    0x8(%ebp),%eax
  80029e:	0f b6 10             	movzbl (%eax),%edx
  8002a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a4:	0f b6 00             	movzbl (%eax),%eax
  8002a7:	38 c2                	cmp    %al,%dl
  8002a9:	74 de                	je     800289 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ae:	0f b6 00             	movzbl (%eax),%eax
  8002b1:	0f b6 d0             	movzbl %al,%edx
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b7:	0f b6 00             	movzbl (%eax),%eax
  8002ba:	0f b6 c0             	movzbl %al,%eax
  8002bd:	89 d1                	mov    %edx,%ecx
  8002bf:	29 c1                	sub    %eax,%ecx
  8002c1:	89 c8                	mov    %ecx,%eax
}
  8002c3:	5d                   	pop    %ebp
  8002c4:	c3                   	ret    

008002c5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8002c8:	eb 0c                	jmp    8002d6 <strncmp+0x11>
		n--, p++, q++;
  8002ca:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8002ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8002d2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8002d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002da:	74 1a                	je     8002f6 <strncmp+0x31>
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	0f b6 00             	movzbl (%eax),%eax
  8002e2:	84 c0                	test   %al,%al
  8002e4:	74 10                	je     8002f6 <strncmp+0x31>
  8002e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e9:	0f b6 10             	movzbl (%eax),%edx
  8002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ef:	0f b6 00             	movzbl (%eax),%eax
  8002f2:	38 c2                	cmp    %al,%dl
  8002f4:	74 d4                	je     8002ca <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8002f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002fa:	75 07                	jne    800303 <strncmp+0x3e>
		return 0;
  8002fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800301:	eb 18                	jmp    80031b <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800303:	8b 45 08             	mov    0x8(%ebp),%eax
  800306:	0f b6 00             	movzbl (%eax),%eax
  800309:	0f b6 d0             	movzbl %al,%edx
  80030c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030f:	0f b6 00             	movzbl (%eax),%eax
  800312:	0f b6 c0             	movzbl %al,%eax
  800315:	89 d1                	mov    %edx,%ecx
  800317:	29 c1                	sub    %eax,%ecx
  800319:	89 c8                	mov    %ecx,%eax
}
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    

0080031d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	8b 45 0c             	mov    0xc(%ebp),%eax
  800326:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800329:	eb 14                	jmp    80033f <strchr+0x22>
		if (*s == c)
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	0f b6 00             	movzbl (%eax),%eax
  800331:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800334:	75 05                	jne    80033b <strchr+0x1e>
			return (char *) s;
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	eb 13                	jmp    80034e <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80033b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	0f b6 00             	movzbl (%eax),%eax
  800345:	84 c0                	test   %al,%al
  800347:	75 e2                	jne    80032b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800349:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 04             	sub    $0x4,%esp
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80035c:	eb 0f                	jmp    80036d <strfind+0x1d>
		if (*s == c)
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	0f b6 00             	movzbl (%eax),%eax
  800364:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800367:	74 10                	je     800379 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800369:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	0f b6 00             	movzbl (%eax),%eax
  800373:	84 c0                	test   %al,%al
  800375:	75 e7                	jne    80035e <strfind+0xe>
  800377:	eb 01                	jmp    80037a <strfind+0x2a>
		if (*s == c)
			break;
  800379:	90                   	nop
	return (char *) s;
  80037a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <memset>:


void *
memset(void *v, int c, size_t n)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800385:	8b 45 08             	mov    0x8(%ebp),%eax
  800388:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80038b:	8b 45 10             	mov    0x10(%ebp),%eax
  80038e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800391:	eb 0e                	jmp    8003a1 <memset+0x22>
		*p++ = c;
  800393:	8b 45 0c             	mov    0xc(%ebp),%eax
  800396:	89 c2                	mov    %eax,%edx
  800398:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039b:	88 10                	mov    %dl,(%eax)
  80039d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8003a1:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  8003a5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003a9:	79 e8                	jns    800393 <memset+0x14>
		*p++ = c;

	return v;
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8003c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003c8:	73 54                	jae    80041e <memmove+0x6e>
  8003ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003d5:	76 47                	jbe    80041e <memmove+0x6e>
		s += n;
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8003dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8003e3:	eb 13                	jmp    8003f8 <memmove+0x48>
			*--d = *--s;
  8003e5:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  8003e9:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  8003ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003f0:	0f b6 10             	movzbl (%eax),%edx
  8003f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003f6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8003f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003fc:	0f 95 c0             	setne  %al
  8003ff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800403:	84 c0                	test   %al,%al
  800405:	75 de                	jne    8003e5 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800407:	eb 25                	jmp    80042e <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040c:	0f b6 10             	movzbl (%eax),%edx
  80040f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800412:	88 10                	mov    %dl,(%eax)
  800414:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  800418:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  80041c:	eb 01                	jmp    80041f <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80041e:	90                   	nop
  80041f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800423:	0f 95 c0             	setne  %al
  800426:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80042a:	84 c0                	test   %al,%al
  80042c:	75 db                	jne    800409 <memmove+0x59>
			*d++ = *s++;

	return dst;
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800439:	8b 45 10             	mov    0x10(%ebp),%eax
  80043c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800440:	8b 45 0c             	mov    0xc(%ebp),%eax
  800443:	89 44 24 04          	mov    %eax,0x4(%esp)
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	89 04 24             	mov    %eax,(%esp)
  80044d:	e8 5e ff ff ff       	call   8003b0 <memmove>
}
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800460:	8b 45 0c             	mov    0xc(%ebp),%eax
  800463:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800466:	eb 32                	jmp    80049a <memcmp+0x46>
		if (*s1 != *s2)
  800468:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046b:	0f b6 10             	movzbl (%eax),%edx
  80046e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800471:	0f b6 00             	movzbl (%eax),%eax
  800474:	38 c2                	cmp    %al,%dl
  800476:	74 1a                	je     800492 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  800478:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047b:	0f b6 00             	movzbl (%eax),%eax
  80047e:	0f b6 d0             	movzbl %al,%edx
  800481:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800484:	0f b6 00             	movzbl (%eax),%eax
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	89 d1                	mov    %edx,%ecx
  80048c:	29 c1                	sub    %eax,%ecx
  80048e:	89 c8                	mov    %ecx,%eax
  800490:	eb 1c                	jmp    8004ae <memcmp+0x5a>
		s1++, s2++;
  800492:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800496:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80049a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80049e:	0f 95 c0             	setne  %al
  8004a1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8004a5:	84 c0                	test   %al,%al
  8004a7:	75 bf                	jne    800468 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8004a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004bc:	01 d0                	add    %edx,%eax
  8004be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8004c1:	eb 11                	jmp    8004d4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	0f b6 10             	movzbl (%eax),%edx
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	38 c2                	cmp    %al,%dl
  8004ce:	74 0e                	je     8004de <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8004d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8004da:	72 e7                	jb     8004c3 <memfind+0x13>
  8004dc:	eb 01                	jmp    8004df <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8004de:	90                   	nop
	return (void *) s;
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8004ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8004f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004f8:	eb 04                	jmp    8004fe <strtol+0x1a>
		s++;
  8004fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	0f b6 00             	movzbl (%eax),%eax
  800504:	3c 20                	cmp    $0x20,%al
  800506:	74 f2                	je     8004fa <strtol+0x16>
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	0f b6 00             	movzbl (%eax),%eax
  80050e:	3c 09                	cmp    $0x9,%al
  800510:	74 e8                	je     8004fa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800512:	8b 45 08             	mov    0x8(%ebp),%eax
  800515:	0f b6 00             	movzbl (%eax),%eax
  800518:	3c 2b                	cmp    $0x2b,%al
  80051a:	75 06                	jne    800522 <strtol+0x3e>
		s++;
  80051c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800520:	eb 15                	jmp    800537 <strtol+0x53>
	else if (*s == '-')
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	0f b6 00             	movzbl (%eax),%eax
  800528:	3c 2d                	cmp    $0x2d,%al
  80052a:	75 0b                	jne    800537 <strtol+0x53>
		s++, neg = 1;
  80052c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800530:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800537:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80053b:	74 06                	je     800543 <strtol+0x5f>
  80053d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800541:	75 24                	jne    800567 <strtol+0x83>
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	0f b6 00             	movzbl (%eax),%eax
  800549:	3c 30                	cmp    $0x30,%al
  80054b:	75 1a                	jne    800567 <strtol+0x83>
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 c0 01             	add    $0x1,%eax
  800553:	0f b6 00             	movzbl (%eax),%eax
  800556:	3c 78                	cmp    $0x78,%al
  800558:	75 0d                	jne    800567 <strtol+0x83>
		s += 2, base = 16;
  80055a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80055e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800565:	eb 2a                	jmp    800591 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  800567:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80056b:	75 17                	jne    800584 <strtol+0xa0>
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	0f b6 00             	movzbl (%eax),%eax
  800573:	3c 30                	cmp    $0x30,%al
  800575:	75 0d                	jne    800584 <strtol+0xa0>
		s++, base = 8;
  800577:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80057b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800582:	eb 0d                	jmp    800591 <strtol+0xad>
	else if (base == 0)
  800584:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800588:	75 07                	jne    800591 <strtol+0xad>
		base = 10;
  80058a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	0f b6 00             	movzbl (%eax),%eax
  800597:	3c 2f                	cmp    $0x2f,%al
  800599:	7e 1b                	jle    8005b6 <strtol+0xd2>
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	0f b6 00             	movzbl (%eax),%eax
  8005a1:	3c 39                	cmp    $0x39,%al
  8005a3:	7f 11                	jg     8005b6 <strtol+0xd2>
			dig = *s - '0';
  8005a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a8:	0f b6 00             	movzbl (%eax),%eax
  8005ab:	0f be c0             	movsbl %al,%eax
  8005ae:	83 e8 30             	sub    $0x30,%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8005b4:	eb 48                	jmp    8005fe <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	0f b6 00             	movzbl (%eax),%eax
  8005bc:	3c 60                	cmp    $0x60,%al
  8005be:	7e 1b                	jle    8005db <strtol+0xf7>
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	0f b6 00             	movzbl (%eax),%eax
  8005c6:	3c 7a                	cmp    $0x7a,%al
  8005c8:	7f 11                	jg     8005db <strtol+0xf7>
			dig = *s - 'a' + 10;
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	0f b6 00             	movzbl (%eax),%eax
  8005d0:	0f be c0             	movsbl %al,%eax
  8005d3:	83 e8 57             	sub    $0x57,%eax
  8005d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8005d9:	eb 23                	jmp    8005fe <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	0f b6 00             	movzbl (%eax),%eax
  8005e1:	3c 40                	cmp    $0x40,%al
  8005e3:	7e 38                	jle    80061d <strtol+0x139>
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	0f b6 00             	movzbl (%eax),%eax
  8005eb:	3c 5a                	cmp    $0x5a,%al
  8005ed:	7f 2e                	jg     80061d <strtol+0x139>
			dig = *s - 'A' + 10;
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	0f b6 00             	movzbl (%eax),%eax
  8005f5:	0f be c0             	movsbl %al,%eax
  8005f8:	83 e8 37             	sub    $0x37,%eax
  8005fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8005fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800601:	3b 45 10             	cmp    0x10(%ebp),%eax
  800604:	7d 16                	jge    80061c <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  800606:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80060a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80060d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800611:	03 45 f4             	add    -0xc(%ebp),%eax
  800614:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800617:	e9 75 ff ff ff       	jmp    800591 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80061c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80061d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800621:	74 08                	je     80062b <strtol+0x147>
		*endptr = (char *) s;
  800623:	8b 45 0c             	mov    0xc(%ebp),%eax
  800626:	8b 55 08             	mov    0x8(%ebp),%edx
  800629:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80062b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80062f:	74 07                	je     800638 <strtol+0x154>
  800631:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800634:	f7 d8                	neg    %eax
  800636:	eb 03                	jmp    80063b <strtol+0x157>
  800638:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    
  80063d:	00 00                	add    %al,(%eax)
	...

00800640 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800640:	55                   	push   %ebp
  800641:	89 e5                	mov    %esp,%ebp
  800643:	57                   	push   %edi
  800644:	56                   	push   %esi
  800645:	53                   	push   %ebx
  800646:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80064f:	8b 55 10             	mov    0x10(%ebp),%edx
  800652:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800655:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800658:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  80065b:	8b 75 20             	mov    0x20(%ebp),%esi
  80065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800661:	cd 30                	int    $0x30
  800663:	89 c3                	mov    %eax,%ebx
  800665:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800668:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066c:	74 30                	je     80069e <syscall+0x5e>
  80066e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800672:	7e 2a                	jle    80069e <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  800674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800677:	89 44 24 10          	mov    %eax,0x10(%esp)
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800682:	c7 44 24 08 fe 26 80 	movl   $0x8026fe,0x8(%esp)
  800689:	00 
  80068a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800691:	00 
  800692:	c7 04 24 1b 27 80 00 	movl   $0x80271b,(%esp)
  800699:	e8 7a 12 00 00       	call   801918 <_panic>

	return ret;
  80069e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8006a1:	83 c4 4c             	add    $0x4c,%esp
  8006a4:	5b                   	pop    %ebx
  8006a5:	5e                   	pop    %esi
  8006a6:	5f                   	pop    %edi
  8006a7:	5d                   	pop    %ebp
  8006a8:	c3                   	ret    

008006a9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8006a9:	55                   	push   %ebp
  8006aa:	89 e5                	mov    %esp,%ebp
  8006ac:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8006b9:	00 
  8006ba:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8006c1:	00 
  8006c2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8006c9:	00 
  8006ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8006dc:	00 
  8006dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006e4:	e8 57 ff ff ff       	call   800640 <syscall>
}
  8006e9:	c9                   	leave  
  8006ea:	c3                   	ret    

008006eb <sys_cgetc>:

int
sys_cgetc(void)
{
  8006eb:	55                   	push   %ebp
  8006ec:	89 e5                	mov    %esp,%ebp
  8006ee:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8006f1:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8006f8:	00 
  8006f9:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800700:	00 
  800701:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800708:	00 
  800709:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800710:	00 
  800711:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800718:	00 
  800719:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800720:	00 
  800721:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800728:	e8 13 ff ff ff       	call   800640 <syscall>
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80073f:	00 
  800740:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800747:	00 
  800748:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80074f:	00 
  800750:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800757:	00 
  800758:	89 44 24 08          	mov    %eax,0x8(%esp)
  80075c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800763:	00 
  800764:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80076b:	e8 d0 fe ff ff       	call   800640 <syscall>
}
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800778:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80077f:	00 
  800780:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800787:	00 
  800788:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80078f:	00 
  800790:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800797:	00 
  800798:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80079f:	00 
  8007a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8007a7:	00 
  8007a8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8007af:	e8 8c fe ff ff       	call   800640 <syscall>
}
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <sys_yield>:

void
sys_yield(void)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8007bc:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8007c3:	00 
  8007c4:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8007cb:	00 
  8007cc:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8007d3:	00 
  8007d4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007db:	00 
  8007dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007e3:	00 
  8007e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8007eb:	00 
  8007ec:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8007f3:	e8 48 fe ff ff       	call   800640 <syscall>
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800800:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800803:	8b 55 0c             	mov    0xc(%ebp),%edx
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800810:	00 
  800811:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800818:	00 
  800819:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80081d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800821:	89 44 24 08          	mov    %eax,0x8(%esp)
  800825:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80082c:	00 
  80082d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  800834:	e8 07 fe ff ff       	call   800640 <syscall>
}
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	56                   	push   %esi
  80083f:	53                   	push   %ebx
  800840:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800843:	8b 75 18             	mov    0x18(%ebp),%esi
  800846:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800849:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80084c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	89 74 24 18          	mov    %esi,0x18(%esp)
  800856:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  80085a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80085e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800862:	89 44 24 08          	mov    %eax,0x8(%esp)
  800866:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80086d:	00 
  80086e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  800875:	e8 c6 fd ff ff       	call   800640 <syscall>
}
  80087a:	83 c4 20             	add    $0x20,%esp
  80087d:	5b                   	pop    %ebx
  80087e:	5e                   	pop    %esi
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    

00800881 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800894:	00 
  800895:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80089c:	00 
  80089d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8008a4:	00 
  8008a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8008b4:	00 
  8008b5:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  8008bc:	e8 7f fd ff ff       	call   800640 <syscall>
}
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8008d6:	00 
  8008d7:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8008de:	00 
  8008df:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8008e6:	00 
  8008e7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8008f6:	00 
  8008f7:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  8008fe:	e8 3d fd ff ff       	call   800640 <syscall>
}
  800903:	c9                   	leave  
  800904:	c3                   	ret    

00800905 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80090b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800918:	00 
  800919:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800920:	00 
  800921:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800928:	00 
  800929:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80092d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800931:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800938:	00 
  800939:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800940:	e8 fb fc ff ff       	call   800640 <syscall>
}
  800945:	c9                   	leave  
  800946:	c3                   	ret    

00800947 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80094d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80095a:	00 
  80095b:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800962:	00 
  800963:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80096a:	00 
  80096b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80096f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800973:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80097a:	00 
  80097b:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  800982:	e8 b9 fc ff ff       	call   800640 <syscall>
}
  800987:	c9                   	leave  
  800988:	c3                   	ret    

00800989 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80099c:	00 
  80099d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8009a4:	00 
  8009a5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8009ac:	00 
  8009ad:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8009bc:	00 
  8009bd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  8009c4:	e8 77 fc ff ff       	call   800640 <syscall>
}
  8009c9:	c9                   	leave  
  8009ca:	c3                   	ret    

008009cb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8009d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8009d4:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8009e1:	00 
  8009e2:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8009e6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8009fc:	00 
  8009fd:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  800a04:	e8 37 fc ff ff       	call   800640 <syscall>
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  800a1b:	00 
  800a1c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800a23:	00 
  800a24:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800a2b:	00 
  800a2c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800a33:	00 
  800a34:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a38:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800a3f:	00 
  800a40:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  800a47:	e8 f4 fb ff ff       	call   800640 <syscall>
}
  800a4c:	c9                   	leave  
  800a4d:	c3                   	ret    
	...

00800a50 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	89 04 24             	mov    %eax,(%esp)
  800a5c:	e8 0a 00 00 00       	call   800a6b <fd2num>
  800a61:	05 40 03 00 00       	add    $0x340,%eax
  800a66:	c1 e0 16             	shl    $0x16,%eax
}
  800a69:	c9                   	leave  
  800a6a:	c3                   	ret    

00800a6b <fd2num>:

int
fd2num(struct Fd *fd)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	05 00 00 40 30       	add    $0x30400000,%eax
  800a76:	c1 e8 0c             	shr    $0xc,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  800a81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a88:	eb 49                	jmp    800ad3 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  800a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a8d:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  800a92:	c1 e0 0c             	shl    $0xc,%eax
  800a95:	89 c2                	mov    %eax,%edx
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	c1 e8 16             	shr    $0x16,%eax
  800aa4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800aab:	83 e0 01             	and    $0x1,%eax
  800aae:	85 c0                	test   %eax,%eax
  800ab0:	74 16                	je     800ac8 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	c1 e8 0c             	shr    $0xc,%eax
  800aba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ac1:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  800ac4:	85 c0                	test   %eax,%eax
  800ac6:	75 07                	jne    800acf <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  800acd:	eb 18                	jmp    800ae7 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  800acf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800ad3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  800ad7:	7e b1                	jle    800a8a <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  800ae2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  800aef:	c7 44 24 08 2c 27 80 	movl   $0x80272c,0x8(%esp)
  800af6:	00 
  800af7:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  800afe:	00 
  800aff:	c7 04 24 46 27 80 00 	movl   $0x802746,(%esp)
  800b06:	e8 0d 0e 00 00       	call   801918 <_panic>

00800b0b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	89 04 24             	mov    %eax,(%esp)
  800b17:	e8 4f ff ff ff       	call   800a6b <fd2num>
  800b1c:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800b1f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b23:	89 04 24             	mov    %eax,(%esp)
  800b26:	e8 be ff ff ff       	call   800ae9 <fd_lookup>
  800b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b32:	78 08                	js     800b3c <fd_close+0x31>
	    || fd != fd2)
  800b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b37:	39 45 08             	cmp    %eax,0x8(%ebp)
  800b3a:	74 12                	je     800b4e <fd_close+0x43>
		return (must_exist ? r : 0);
  800b3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b40:	74 05                	je     800b47 <fd_close+0x3c>
  800b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b45:	eb 05                	jmp    800b4c <fd_close+0x41>
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4c:	eb 44                	jmp    800b92 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8b 00                	mov    (%eax),%eax
  800b53:	8d 55 ec             	lea    -0x14(%ebp),%edx
  800b56:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b5a:	89 04 24             	mov    %eax,(%esp)
  800b5d:	e8 32 00 00 00       	call   800b94 <dev_lookup>
  800b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b69:	78 11                	js     800b7c <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  800b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b6e:	8b 50 10             	mov    0x10(%eax),%edx
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	89 04 24             	mov    %eax,(%esp)
  800b77:	ff d2                	call   *%edx
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b8a:	e8 f2 fc ff ff       	call   800881 <sys_page_unmap>
	return r;
  800b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  800b9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ba1:	eb 2b                	jmp    800bce <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  800ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ba6:	8b 04 85 04 50 80 00 	mov    0x805004(,%eax,4),%eax
  800bad:	8b 00                	mov    (%eax),%eax
  800baf:	3b 45 08             	cmp    0x8(%ebp),%eax
  800bb2:	75 16                	jne    800bca <dev_lookup+0x36>
			*dev = devtab[i];
  800bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bb7:	8b 14 85 04 50 80 00 	mov    0x805004(,%eax,4),%edx
  800bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc1:	89 10                	mov    %edx,(%eax)
			return 0;
  800bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc8:	eb 3f                	jmp    800c09 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800bca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd1:	8b 04 85 04 50 80 00 	mov    0x805004(,%eax,4),%eax
  800bd8:	85 c0                	test   %eax,%eax
  800bda:	75 c7                	jne    800ba3 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  800bdc:	a1 44 50 80 00       	mov    0x805044,%eax
  800be1:	8b 40 4c             	mov    0x4c(%eax),%eax
  800be4:	8b 55 08             	mov    0x8(%ebp),%edx
  800be7:	89 54 24 08          	mov    %edx,0x8(%esp)
  800beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bef:	c7 04 24 50 27 80 00 	movl   $0x802750,(%esp)
  800bf6:	e8 51 0e 00 00       	call   801a4c <cprintf>
	*dev = 0;
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800c04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <close>:

int
close(int fdnum)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c11:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	89 04 24             	mov    %eax,(%esp)
  800c1e:	e8 c6 fe ff ff       	call   800ae9 <fd_lookup>
  800c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c2a:	79 05                	jns    800c31 <close+0x26>
		return r;
  800c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2f:	eb 13                	jmp    800c44 <close+0x39>
	else
		return fd_close(fd, 1);
  800c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c34:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800c3b:	00 
  800c3c:	89 04 24             	mov    %eax,(%esp)
  800c3f:	e8 c7 fe ff ff       	call   800b0b <fd_close>
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <close_all>:

void
close_all(void)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800c53:	eb 0f                	jmp    800c64 <close_all+0x1e>
		close(i);
  800c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c58:	89 04 24             	mov    %eax,(%esp)
  800c5b:	e8 ab ff ff ff       	call   800c0b <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800c60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800c64:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  800c68:	7e eb                	jle    800c55 <close_all+0xf>
		close(i);
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800c72:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 04 24             	mov    %eax,(%esp)
  800c7f:	e8 65 fe ff ff       	call   800ae9 <fd_lookup>
  800c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c8b:	79 08                	jns    800c95 <dup+0x29>
		return r;
  800c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c90:	e9 54 01 00 00       	jmp    800de9 <dup+0x17d>
	close(newfdnum);
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	89 04 24             	mov    %eax,(%esp)
  800c9b:	e8 6b ff ff ff       	call   800c0b <close>

	newfd = INDEX2FD(newfdnum);
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  800ca8:	c1 e0 0c             	shl    $0xc,%eax
  800cab:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  800cae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cb1:	89 04 24             	mov    %eax,(%esp)
  800cb4:	e8 97 fd ff ff       	call   800a50 <fd2data>
  800cb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  800cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cbf:	89 04 24             	mov    %eax,(%esp)
  800cc2:	e8 89 fd ff ff       	call   800a50 <fd2data>
  800cc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  800cca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ccd:	c1 e8 0c             	shr    $0xc,%eax
  800cd0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800cd7:	89 c2                	mov    %eax,%edx
  800cd9:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800cdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce2:	89 54 24 10          	mov    %edx,0x10(%esp)
  800ce6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ce9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ced:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800cf4:	00 
  800cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d00:	e8 36 fb ff ff       	call   80083b <sys_page_map>
  800d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d0c:	0f 88 8e 00 00 00    	js     800da0 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  800d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d15:	c1 e8 16             	shr    $0x16,%eax
  800d18:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	74 78                	je     800d9b <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  800d23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d2a:	eb 66                	jmp    800d92 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  800d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d2f:	03 45 e8             	add    -0x18(%ebp),%eax
  800d32:	c1 e8 0c             	shr    $0xc,%eax
  800d35:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  800d3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d42:	83 e0 01             	and    $0x1,%eax
  800d45:	84 c0                	test   %al,%al
  800d47:	74 42                	je     800d8b <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  800d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d4c:	89 c1                	mov    %eax,%ecx
  800d4e:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d57:	89 c2                	mov    %eax,%edx
  800d59:	03 55 e4             	add    -0x1c(%ebp),%edx
  800d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5f:	03 45 e8             	add    -0x18(%ebp),%eax
  800d62:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800d66:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d6a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800d71:	00 
  800d72:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d7d:	e8 b9 fa ff ff       	call   80083b <sys_page_map>
  800d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d89:	78 18                	js     800da3 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  800d8b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800d92:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  800d99:	7e 91                	jle    800d2c <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	eb 49                	jmp    800de9 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  800da0:	90                   	nop
  800da1:	eb 01                	jmp    800da4 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  800da3:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800db2:	e8 ca fa ff ff       	call   800881 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  800db7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800dbe:	eb 1d                	jmp    800ddd <dup+0x171>
		sys_page_unmap(0, nva + i);
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc3:	03 45 e4             	add    -0x1c(%ebp),%eax
  800dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800dd1:	e8 ab fa ff ff       	call   800881 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  800dd6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800ddd:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  800de4:	7e da                	jle    800dc0 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  800de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800df1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 04 24             	mov    %eax,(%esp)
  800dfe:	e8 e6 fc ff ff       	call   800ae9 <fd_lookup>
  800e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e0a:	78 1d                	js     800e29 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0f:	8b 00                	mov    (%eax),%eax
  800e11:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800e14:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e18:	89 04 24             	mov    %eax,(%esp)
  800e1b:	e8 74 fd ff ff       	call   800b94 <dev_lookup>
  800e20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e27:	79 05                	jns    800e2e <read+0x43>
		return r;
  800e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e2c:	eb 75                	jmp    800ea3 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e31:	8b 40 08             	mov    0x8(%eax),%eax
  800e34:	83 e0 03             	and    $0x3,%eax
  800e37:	83 f8 01             	cmp    $0x1,%eax
  800e3a:	75 26                	jne    800e62 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800e3c:	a1 44 50 80 00       	mov    0x805044,%eax
  800e41:	8b 40 4c             	mov    0x4c(%eax),%eax
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e4f:	c7 04 24 6f 27 80 00 	movl   $0x80276f,(%esp)
  800e56:	e8 f1 0b 00 00       	call   801a4c <cprintf>
		return -E_INVAL;
  800e5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e60:	eb 41                	jmp    800ea3 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  800e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e65:	8b 48 08             	mov    0x8(%eax),%ecx
  800e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e6b:	8b 50 04             	mov    0x4(%eax),%edx
  800e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e71:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e75:	8b 55 10             	mov    0x10(%ebp),%edx
  800e78:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7f:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e83:	89 04 24             	mov    %eax,(%esp)
  800e86:	ff d1                	call   *%ecx
  800e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  800e8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e8f:	78 0f                	js     800ea0 <read+0xb5>
		fd->fd_offset += r;
  800e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e97:	8b 52 04             	mov    0x4(%edx),%edx
  800e9a:	03 55 f4             	add    -0xc(%ebp),%edx
  800e9d:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  800ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb2:	eb 3b                	jmp    800eef <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb7:	8b 55 10             	mov    0x10(%ebp),%edx
  800eba:	29 c2                	sub    %eax,%edx
  800ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebf:	03 45 0c             	add    0xc(%ebp),%eax
  800ec2:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 04 24             	mov    %eax,(%esp)
  800ed0:	e8 16 ff ff ff       	call   800deb <read>
  800ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  800ed8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800edc:	79 05                	jns    800ee3 <readn+0x3e>
			return m;
  800ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee1:	eb 1a                	jmp    800efd <readn+0x58>
		if (m == 0)
  800ee3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ee7:	74 10                	je     800ef9 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eec:	01 45 f4             	add    %eax,-0xc(%ebp)
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef5:	72 bd                	jb     800eb4 <readn+0xf>
  800ef7:	eb 01                	jmp    800efa <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  800ef9:	90                   	nop
	}
	return tot;
  800efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	89 04 24             	mov    %eax,(%esp)
  800f12:	e8 d2 fb ff ff       	call   800ae9 <fd_lookup>
  800f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f1e:	78 1d                	js     800f3d <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f23:	8b 00                	mov    (%eax),%eax
  800f25:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800f28:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f2c:	89 04 24             	mov    %eax,(%esp)
  800f2f:	e8 60 fc ff ff       	call   800b94 <dev_lookup>
  800f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800f3b:	79 05                	jns    800f42 <write+0x43>
		return r;
  800f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f40:	eb 74                	jmp    800fb6 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f45:	8b 40 08             	mov    0x8(%eax),%eax
  800f48:	83 e0 03             	and    $0x3,%eax
  800f4b:	85 c0                	test   %eax,%eax
  800f4d:	75 26                	jne    800f75 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  800f4f:	a1 44 50 80 00       	mov    0x805044,%eax
  800f54:	8b 40 4c             	mov    0x4c(%eax),%eax
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f62:	c7 04 24 8b 27 80 00 	movl   $0x80278b,(%esp)
  800f69:	e8 de 0a 00 00       	call   801a4c <cprintf>
		return -E_INVAL;
  800f6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f73:	eb 41                	jmp    800fb6 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  800f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f78:	8b 48 0c             	mov    0xc(%eax),%ecx
  800f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f7e:	8b 50 04             	mov    0x4(%eax),%edx
  800f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f84:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f88:	8b 55 10             	mov    0x10(%ebp),%edx
  800f8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f92:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f96:	89 04 24             	mov    %eax,(%esp)
  800f99:	ff d1                	call   *%ecx
  800f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  800f9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fa2:	7e 0f                	jle    800fb3 <write+0xb4>
		fd->fd_offset += r;
  800fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800faa:	8b 52 04             	mov    0x4(%edx),%edx
  800fad:	03 55 f4             	add    -0xc(%ebp),%edx
  800fb0:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  800fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <seek>:

int
seek(int fdnum, off_t offset)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fbe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	89 04 24             	mov    %eax,(%esp)
  800fcb:	e8 19 fb ff ff       	call   800ae9 <fd_lookup>
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800fd7:	79 05                	jns    800fde <seek+0x26>
		return r;
  800fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdc:	eb 0e                	jmp    800fec <seek+0x34>
	fd->fd_offset = offset;
  800fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ff4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	89 04 24             	mov    %eax,(%esp)
  801001:	e8 e3 fa ff ff       	call   800ae9 <fd_lookup>
  801006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80100d:	78 1d                	js     80102c <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80100f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801012:	8b 00                	mov    (%eax),%eax
  801014:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801017:	89 54 24 04          	mov    %edx,0x4(%esp)
  80101b:	89 04 24             	mov    %eax,(%esp)
  80101e:	e8 71 fb ff ff       	call   800b94 <dev_lookup>
  801023:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801026:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80102a:	79 05                	jns    801031 <ftruncate+0x43>
		return r;
  80102c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102f:	eb 48                	jmp    801079 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801034:	8b 40 08             	mov    0x8(%eax),%eax
  801037:	83 e0 03             	and    $0x3,%eax
  80103a:	85 c0                	test   %eax,%eax
  80103c:	75 26                	jne    801064 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  80103e:	a1 44 50 80 00       	mov    0x805044,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801043:	8b 40 4c             	mov    0x4c(%eax),%eax
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	89 54 24 08          	mov    %edx,0x8(%esp)
  80104d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801051:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  801058:	e8 ef 09 00 00       	call   801a4c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  80105d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801062:	eb 15                	jmp    801079 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801067:	8b 48 1c             	mov    0x1c(%eax),%ecx
  80106a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80106d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801070:	89 54 24 04          	mov    %edx,0x4(%esp)
  801074:	89 04 24             	mov    %eax,(%esp)
  801077:	ff d1                	call   *%ecx
}
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801081:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801084:	89 44 24 04          	mov    %eax,0x4(%esp)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 04 24             	mov    %eax,(%esp)
  80108e:	e8 56 fa ff ff       	call   800ae9 <fd_lookup>
  801093:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80109a:	78 1d                	js     8010b9 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80109c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109f:	8b 00                	mov    (%eax),%eax
  8010a1:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8010a4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010a8:	89 04 24             	mov    %eax,(%esp)
  8010ab:	e8 e4 fa ff ff       	call   800b94 <dev_lookup>
  8010b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8010b7:	79 05                	jns    8010be <fstat+0x43>
		return r;
  8010b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bc:	eb 41                	jmp    8010ff <fstat+0x84>
	stat->st_name[0] = 0;
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  8010ce:	00 00 00 
	stat->st_isdir = 0;
  8010d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  8010db:	00 00 00 
	stat->st_dev = dev;
  8010de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  8010ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ed:	8b 48 14             	mov    0x14(%eax),%ecx
  8010f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010fa:	89 04 24             	mov    %eax,(%esp)
  8010fd:	ff d1                	call   *%ecx
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801107:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80110e:	00 
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 04 24             	mov    %eax,(%esp)
  801115:	e8 36 00 00 00       	call   801150 <open>
  80111a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80111d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801121:	79 05                	jns    801128 <stat+0x27>
		return fd;
  801123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801126:	eb 23                	jmp    80114b <stat+0x4a>
	r = fstat(fd, stat);
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	89 04 24             	mov    %eax,(%esp)
  801135:	e8 41 ff ff ff       	call   80107b <fstat>
  80113a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	89 04 24             	mov    %eax,(%esp)
  801143:	e8 c3 fa ff ff       	call   800c0b <close>
	return r;
  801148:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    
  80114d:	00 00                	add    %al,(%eax)
	...

00801150 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801156:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801159:	89 04 24             	mov    %eax,(%esp)
  80115c:	e8 1a f9 ff ff       	call   800a7b <fd_alloc>
  801161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801164:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801168:	79 05                	jns    80116f <open+0x1f>
  80116a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116d:	eb 73                	jmp    8011e2 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  80116f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801172:	89 44 24 08          	mov    %eax,0x8(%esp)
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	89 04 24             	mov    %eax,(%esp)
  801183:	e8 54 05 00 00       	call   8016dc <fsipc_open>
  801188:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80118f:	79 05                	jns    801196 <open+0x46>
  801191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801194:	eb 4c                	jmp    8011e2 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801199:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80119f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8011a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011ad:	00 
  8011ae:	89 04 24             	mov    %eax,(%esp)
  8011b1:	e8 25 03 00 00       	call   8014db <fmap>
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011bd:	79 18                	jns    8011d7 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  8011bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011c9:	00 
  8011ca:	89 04 24             	mov    %eax,(%esp)
  8011cd:	e8 39 f9 ff ff       	call   800b0b <fd_close>
  8011d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d5:	eb 0b                	jmp    8011e2 <open+0x92>
	return fd2num(fd);
  8011d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011da:	89 04 24             	mov    %eax,(%esp)
  8011dd:	e8 89 f8 ff ff       	call   800a6b <fd2num>
	//panic("open() unimplemented!");
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8011f3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  8011fa:	00 
  8011fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801202:	00 
  801203:	89 44 24 04          	mov    %eax,0x4(%esp)
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	89 04 24             	mov    %eax,(%esp)
  80120d:	e8 72 03 00 00       	call   801584 <funmap>
  801212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801219:	79 05                	jns    801220 <file_close+0x3c>
  80121b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80121e:	eb 21                	jmp    801241 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8b 40 0c             	mov    0xc(%eax),%eax
  801226:	89 04 24             	mov    %eax,(%esp)
  801229:	e8 e3 05 00 00       	call   801811 <fsipc_close>
  80122e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801231:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801235:	79 05                	jns    80123c <file_close+0x58>
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	eb 05                	jmp    801241 <file_close+0x5d>
	return 0;
  80123c:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80125b:	76 07                	jbe    801264 <file_read+0x21>
		return 0;
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
  801262:	eb 43                	jmp    8012a7 <file_read+0x64>
	if (offset + n > size)
  801264:	8b 45 14             	mov    0x14(%ebp),%eax
  801267:	03 45 10             	add    0x10(%ebp),%eax
  80126a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80126d:	76 0f                	jbe    80127e <file_read+0x3b>
		n = size - offset;
  80126f:	8b 45 14             	mov    0x14(%ebp),%eax
  801272:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801275:	89 d1                	mov    %edx,%ecx
  801277:	29 c1                	sub    %eax,%ecx
  801279:	89 c8                	mov    %ecx,%eax
  80127b:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 04 24             	mov    %eax,(%esp)
  801284:	e8 c7 f7 ff ff       	call   800a50 <fd2data>
  801289:	8b 55 14             	mov    0x14(%ebp),%edx
  80128c:	01 c2                	add    %eax,%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	89 44 24 08          	mov    %eax,0x8(%esp)
  801295:	89 54 24 04          	mov    %edx,0x4(%esp)
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	89 04 24             	mov    %eax,(%esp)
  80129f:	e8 0c f1 ff ff       	call   8003b0 <memmove>
	return n;
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
}
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012af:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	89 04 24             	mov    %eax,(%esp)
  8012bc:	e8 28 f8 ff ff       	call   800ae9 <fd_lookup>
  8012c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012c8:	79 05                	jns    8012cf <read_map+0x26>
		return r;
  8012ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cd:	eb 74                	jmp    801343 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  8012cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012d2:	8b 10                	mov    (%eax),%edx
  8012d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8012d9:	39 c2                	cmp    %eax,%edx
  8012db:	74 07                	je     8012e4 <read_map+0x3b>
		return -E_INVAL;
  8012dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e2:	eb 5f                	jmp    801343 <read_map+0x9a>
	va = fd2data(fd) + offset;
  8012e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e7:	89 04 24             	mov    %eax,(%esp)
  8012ea:	e8 61 f7 ff ff       	call   800a50 <fd2data>
  8012ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  8012f7:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  8012fe:	7e 07                	jle    801307 <read_map+0x5e>
		return -E_NO_DISK;
  801300:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801305:	eb 3c                	jmp    801343 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130a:	c1 e8 16             	shr    $0x16,%eax
  80130d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801314:	83 e0 01             	and    $0x1,%eax
  801317:	85 c0                	test   %eax,%eax
  801319:	74 14                	je     80132f <read_map+0x86>
  80131b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131e:	c1 e8 0c             	shr    $0xc,%eax
  801321:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801328:	83 e0 01             	and    $0x1,%eax
  80132b:	85 c0                	test   %eax,%eax
  80132d:	75 07                	jne    801336 <read_map+0x8d>
		return -E_NO_DISK;
  80132f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801334:	eb 0d                	jmp    801343 <read_map+0x9a>
	*blk = (void*) va;
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80133c:	89 10                	mov    %edx,(%eax)
	return 0;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	03 45 10             	add    0x10(%ebp),%eax
  801351:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  801354:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  80135b:	76 07                	jbe    801364 <file_write+0x1f>
		return -E_NO_DISK;
  80135d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801362:	eb 57                	jmp    8013bb <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80136d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801370:	73 20                	jae    801392 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  801372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801375:	89 44 24 04          	mov    %eax,0x4(%esp)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 04 24             	mov    %eax,(%esp)
  80137f:	e8 88 00 00 00       	call   80140c <file_trunc>
  801384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801387:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138b:	79 05                	jns    801392 <file_write+0x4d>
			return r;
  80138d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801390:	eb 29                	jmp    8013bb <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	89 04 24             	mov    %eax,(%esp)
  801398:	e8 b3 f6 ff ff       	call   800a50 <fd2data>
  80139d:	8b 55 14             	mov    0x14(%ebp),%edx
  8013a0:	01 c2                	add    %eax,%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b0:	89 14 24             	mov    %edx,(%esp)
  8013b3:	e8 f8 ef ff ff       	call   8003b0 <memmove>
	return n;
  8013b8:	8b 45 10             	mov    0x10(%ebp),%eax
}
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8d 50 10             	lea    0x10(%eax),%edx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013d0:	89 04 24             	mov    %eax,(%esp)
  8013d3:	e8 e6 ed ff ff       	call   8001be <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  8013f3:	83 f8 01             	cmp    $0x1,%eax
  8013f6:	0f 94 c0             	sete   %al
  8013f9:	0f b6 d0             	movzbl %al,%edx
  8013fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ff:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  801412:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  801419:	7e 0a                	jle    801425 <file_trunc+0x19>
		return -E_NO_DISK;
  80141b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801420:	e9 b4 00 00 00       	jmp    8014d9 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8b 40 0c             	mov    0xc(%eax),%eax
  80142b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801437:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  80143a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801440:	89 54 24 04          	mov    %edx,0x4(%esp)
  801444:	89 04 24             	mov    %eax,(%esp)
  801447:	e8 82 03 00 00       	call   8017ce <fsipc_set_size>
  80144c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80144f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801453:	79 05                	jns    80145a <file_trunc+0x4e>
		return r;
  801455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801458:	eb 7f                	jmp    8014d9 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801463:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801466:	74 24                	je     80148c <file_trunc+0x80>
  801468:	c7 44 24 0c d4 27 80 	movl   $0x8027d4,0xc(%esp)
  80146f:	00 
  801470:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  801477:	00 
  801478:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80147f:	00 
  801480:	c7 04 24 0c 28 80 00 	movl   $0x80280c,(%esp)
  801487:	e8 8c 04 00 00       	call   801918 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  80148c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	89 04 24             	mov    %eax,(%esp)
  8014a0:	e8 36 00 00 00       	call   8014db <fmap>
  8014a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014ac:	79 05                	jns    8014b3 <file_trunc+0xa7>
		return r;
  8014ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014b1:	eb 26                	jmp    8014d9 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  8014b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8014ba:	00 
  8014bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	89 04 24             	mov    %eax,(%esp)
  8014cf:	e8 b0 00 00 00       	call   801584 <funmap>

	return 0;
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 04 24             	mov    %eax,(%esp)
  8014e7:	e8 64 f5 ff ff       	call   800a50 <fd2data>
  8014ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  8014ef:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f9:	03 45 ec             	add    -0x14(%ebp),%eax
  8014fc:	83 e8 01             	sub    $0x1,%eax
  8014ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801502:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801505:	ba 00 00 00 00       	mov    $0x0,%edx
  80150a:	f7 75 ec             	divl   -0x14(%ebp)
  80150d:	89 d0                	mov    %edx,%eax
  80150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801512:	89 d1                	mov    %edx,%ecx
  801514:	29 c1                	sub    %eax,%ecx
  801516:	89 c8                	mov    %ecx,%eax
  801518:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151b:	eb 58                	jmp    801575 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  80151d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801520:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801523:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8b 40 0c             	mov    0xc(%eax),%eax
  80152f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801533:	89 54 24 04          	mov    %edx,0x4(%esp)
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	e8 04 02 00 00       	call   801743 <fsipc_map>
  80153f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801542:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801546:	79 26                	jns    80156e <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  801548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801552:	00 
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	89 54 24 08          	mov    %edx,0x8(%esp)
  80155a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	89 04 24             	mov    %eax,(%esp)
  801564:	e8 1b 00 00 00       	call   801584 <funmap>
			return r;
  801569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80156c:	eb 14                	jmp    801582 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80156e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801575:	8b 45 10             	mov    0x10(%ebp),%eax
  801578:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80157b:	77 a0                	ja     80151d <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	89 04 24             	mov    %eax,(%esp)
  801590:	e8 bb f4 ff ff       	call   800a50 <fd2data>
  801595:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  801598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159b:	c1 e8 16             	shr    $0x16,%eax
  80159e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015a5:	83 e0 01             	and    $0x1,%eax
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	75 0a                	jne    8015b6 <funmap+0x32>
		return 0;
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b1:	e9 bf 00 00 00       	jmp    801675 <funmap+0xf1>

	ret = 0;
  8015b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8015bd:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8015c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c7:	03 45 e8             	add    -0x18(%ebp),%eax
  8015ca:	83 e8 01             	sub    $0x1,%eax
  8015cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d8:	f7 75 e8             	divl   -0x18(%ebp)
  8015db:	89 d0                	mov    %edx,%eax
  8015dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015e0:	89 d1                	mov    %edx,%ecx
  8015e2:	29 c1                	sub    %eax,%ecx
  8015e4:	89 c8                	mov    %ecx,%eax
  8015e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015e9:	eb 7b                	jmp    801666 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  8015eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	c1 e8 0c             	shr    $0xc,%eax
  8015f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015fd:	83 e0 01             	and    $0x1,%eax
  801600:	84 c0                	test   %al,%al
  801602:	74 5b                	je     80165f <funmap+0xdb>
			if (dirty
  801604:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801608:	74 3d                	je     801647 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  80160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801610:	01 d0                	add    %edx,%eax
  801612:	c1 e8 0c             	shr    $0xc,%eax
  801615:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80161c:	83 e0 40             	and    $0x40,%eax
  80161f:	85 c0                	test   %eax,%eax
  801621:	74 24                	je     801647 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  801623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8b 40 0c             	mov    0xc(%eax),%eax
  80162c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801630:	89 04 24             	mov    %eax,(%esp)
  801633:	e8 13 02 00 00       	call   80184b <fsipc_dirty>
  801638:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80163b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80163f:	79 06                	jns    801647 <funmap+0xc3>
				ret = r;
  801641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801644:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  801647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80164d:	01 d0                	add    %edx,%eax
  80164f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801653:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165a:	e8 22 f2 ff ff       	call   800881 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  80165f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80166c:	0f 87 79 ff ff ff    	ja     8015eb <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <remove>:

// Delete a file
int
remove(const char *path)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	89 04 24             	mov    %eax,(%esp)
  801683:	e8 06 02 00 00       	call   80188e <fsipc_remove>
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801690:	e8 56 02 00 00       	call   8018eb <fsipc_sync>
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    
	...

00801698 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80169e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  8016a3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016aa:	00 
  8016ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016b9:	89 04 24             	mov    %eax,(%esp)
  8016bc:	e8 d3 0c 00 00       	call   802394 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  8016c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d2:	89 04 24             	mov    %eax,(%esp)
  8016d5:	e8 2e 0c 00 00       	call   802308 <ipc_recv>
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  8016e2:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	89 04 24             	mov    %eax,(%esp)
  8016ef:	e8 74 ea ff ff       	call   800168 <strlen>
  8016f4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016f9:	7e 07                	jle    801702 <fsipc_open+0x26>
		return -E_BAD_PATH;
  8016fb:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801700:	eb 3f                	jmp    801741 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	8b 55 08             	mov    0x8(%ebp),%edx
  801708:	89 54 24 04          	mov    %edx,0x4(%esp)
  80170c:	89 04 24             	mov    %eax,(%esp)
  80170f:	e8 aa ea ff ff       	call   8001be <strcpy>
	req->req_omode = omode;
  801714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171a:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801720:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801723:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801731:	89 44 24 04          	mov    %eax,0x4(%esp)
  801735:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80173c:	e8 57 ff ff ff       	call   801698 <fsipc>
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  801749:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  801750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801753:	8b 55 08             	mov    0x8(%ebp),%edx
  801756:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  801758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  801761:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801764:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801768:	8b 45 10             	mov    0x10(%ebp),%eax
  80176b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801772:	89 44 24 04          	mov    %eax,0x4(%esp)
  801776:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80177d:	e8 16 ff ff ff       	call   801698 <fsipc>
  801782:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801785:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801789:	79 05                	jns    801790 <fsipc_map+0x4d>
		return r;
  80178b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178e:	eb 3c                	jmp    8017cc <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  801790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801793:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  801798:	83 f8 05             	cmp    $0x5,%eax
  80179b:	74 2a                	je     8017c7 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  80179d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a0:	8b 55 10             	mov    0x10(%ebp),%edx
  8017a3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ab:	c7 44 24 08 18 28 80 	movl   $0x802818,0x8(%esp)
  8017b2:	00 
  8017b3:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  8017ba:	00 
  8017bb:	c7 04 24 4e 28 80 00 	movl   $0x80284e,(%esp)
  8017c2:	e8 51 01 00 00       	call   801918 <_panic>
	return 0;
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  8017d4:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  8017db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017de:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e1:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e9:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  8017ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8017f3:	00 
  8017f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017fb:	00 
  8017fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801803:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80180a:	e8 89 fe ff ff       	call   801698 <fsipc>
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  801817:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  80181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801821:	8b 55 08             	mov    0x8(%ebp),%edx
  801824:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801826:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80182d:	00 
  80182e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801835:	00 
  801836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801839:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  801844:	e8 4f fe ff ff       	call   801698 <fsipc>
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  801851:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	req->req_fileid = fileid;
  801858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185b:	8b 55 08             	mov    0x8(%ebp),%edx
  80185e:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  801860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801869:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801870:	00 
  801871:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801878:	00 
  801879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801880:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  801887:	e8 0c fe ff ff       	call   801698 <fsipc>
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801894:	c7 45 f4 00 30 80 00 	movl   $0x803000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	89 04 24             	mov    %eax,(%esp)
  8018a1:	e8 c2 e8 ff ff       	call   800168 <strlen>
  8018a6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018ab:	7e 07                	jle    8018b4 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  8018ad:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8018b2:	eb 35                	jmp    8018e9 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  8018b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018be:	89 04 24             	mov    %eax,(%esp)
  8018c1:	e8 f8 e8 ff ff       	call   8001be <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8018c6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018cd:	00 
  8018ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018d5:	00 
  8018d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dd:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  8018e4:	e8 af fd ff ff       	call   801698 <fsipc>
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8018f1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018f8:	00 
  8018f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801900:	00 
  801901:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801908:	00 
  801909:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801910:	e8 83 fd ff ff       	call   801698 <fsipc>
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    
	...

00801918 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  80191e:	8d 45 10             	lea    0x10(%ebp),%eax
  801921:	83 c0 04             	add    $0x4,%eax
  801924:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  801927:	a1 48 50 80 00       	mov    0x805048,%eax
  80192c:	85 c0                	test   %eax,%eax
  80192e:	74 15                	je     801945 <_panic+0x2d>
		cprintf("%s: ", argv0);
  801930:	a1 48 50 80 00       	mov    0x805048,%eax
  801935:	89 44 24 04          	mov    %eax,0x4(%esp)
  801939:	c7 04 24 5a 28 80 00 	movl   $0x80285a,(%esp)
  801940:	e8 07 01 00 00       	call   801a4c <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801945:	a1 00 50 80 00       	mov    0x805000,%eax
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801951:	8b 55 08             	mov    0x8(%ebp),%edx
  801954:	89 54 24 08          	mov    %edx,0x8(%esp)
  801958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195c:	c7 04 24 5f 28 80 00 	movl   $0x80285f,(%esp)
  801963:	e8 e4 00 00 00       	call   801a4c <cprintf>
	vcprintf(fmt, ap);
  801968:	8b 45 10             	mov    0x10(%ebp),%eax
  80196b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	e8 6e 00 00 00       	call   8019e8 <vcprintf>
	cprintf("\n");
  80197a:	c7 04 24 7b 28 80 00 	movl   $0x80287b,(%esp)
  801981:	e8 c6 00 00 00       	call   801a4c <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801986:	cc                   	int3   
  801987:	eb fd                	jmp    801986 <_panic+0x6e>
  801989:	00 00                	add    %al,(%eax)
	...

0080198c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  801992:	8b 45 0c             	mov    0xc(%ebp),%eax
  801995:	8b 00                	mov    (%eax),%eax
  801997:	8b 55 08             	mov    0x8(%ebp),%edx
  80199a:	89 d1                	mov    %edx,%ecx
  80199c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  8019a3:	8d 50 01             	lea    0x1(%eax),%edx
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  8019ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ae:	8b 00                	mov    (%eax),%eax
  8019b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8019b5:	75 20                	jne    8019d7 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bf:	83 c2 08             	add    $0x8,%edx
  8019c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c6:	89 14 24             	mov    %edx,(%esp)
  8019c9:	e8 db ec ff ff       	call   8006a9 <sys_cputs>
		b->idx = 0;
  8019ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8019d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019da:	8b 40 04             	mov    0x4(%eax),%eax
  8019dd:	8d 50 01             	lea    0x1(%eax),%edx
  8019e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8019f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019f8:	00 00 00 
	b.cnt = 0;
  8019fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801a02:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a08:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1d:	c7 04 24 8c 19 80 00 	movl   $0x80198c,(%esp)
  801a24:	e8 f7 01 00 00       	call   801c20 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801a29:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a33:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a39:	83 c0 08             	add    $0x8,%eax
  801a3c:	89 04 24             	mov    %eax,(%esp)
  801a3f:	e8 65 ec ff ff       	call   8006a9 <sys_cputs>

	return b.cnt;
  801a44:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a52:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a62:	89 04 24             	mov    %eax,(%esp)
  801a65:	e8 7e ff ff ff       	call   8019e8 <vcprintf>
  801a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    
	...

00801a74 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	53                   	push   %ebx
  801a78:	83 ec 34             	sub    $0x34,%esp
  801a7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a81:	8b 45 14             	mov    0x14(%ebp),%eax
  801a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801a87:	8b 45 18             	mov    0x18(%ebp),%eax
  801a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801a92:	77 72                	ja     801b06 <printnum+0x92>
  801a94:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801a97:	72 05                	jb     801a9e <printnum+0x2a>
  801a99:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a9c:	77 68                	ja     801b06 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801a9e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801aa1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  801aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aac:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ab0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aba:	89 04 24             	mov    %eax,(%esp)
  801abd:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ac1:	e8 6a 09 00 00       	call   802430 <__udivdi3>
  801ac6:	8b 4d 20             	mov    0x20(%ebp),%ecx
  801ac9:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  801acd:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  801ad1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801ad4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801ad8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801adc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	89 04 24             	mov    %eax,(%esp)
  801aed:	e8 82 ff ff ff       	call   801a74 <printnum>
  801af2:	eb 1c                	jmp    801b10 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afb:	8b 45 20             	mov    0x20(%ebp),%eax
  801afe:	89 04 24             	mov    %eax,(%esp)
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801b06:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  801b0a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801b0e:	7f e4                	jg     801af4 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b10:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b13:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b22:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b26:	89 04 24             	mov    %eax,(%esp)
  801b29:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b2d:	e8 2e 0a 00 00       	call   802560 <__umoddi3>
  801b32:	05 dc 29 80 00       	add    $0x8029dc,%eax
  801b37:	0f b6 00             	movzbl (%eax),%eax
  801b3a:	0f be c0             	movsbl %al,%eax
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b44:	89 04 24             	mov    %eax,(%esp)
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	ff d0                	call   *%eax
}
  801b4c:	83 c4 34             	add    $0x34,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5d                   	pop    %ebp
  801b51:	c3                   	ret    

00801b52 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b55:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b59:	7e 1c                	jle    801b77 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	8b 00                	mov    (%eax),%eax
  801b60:	8d 50 08             	lea    0x8(%eax),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	89 10                	mov    %edx,(%eax)
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	8b 00                	mov    (%eax),%eax
  801b6d:	83 e8 08             	sub    $0x8,%eax
  801b70:	8b 50 04             	mov    0x4(%eax),%edx
  801b73:	8b 00                	mov    (%eax),%eax
  801b75:	eb 40                	jmp    801bb7 <getuint+0x65>
	else if (lflag)
  801b77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b7b:	74 1e                	je     801b9b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	8b 00                	mov    (%eax),%eax
  801b82:	8d 50 04             	lea    0x4(%eax),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	89 10                	mov    %edx,(%eax)
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	8b 00                	mov    (%eax),%eax
  801b8f:	83 e8 04             	sub    $0x4,%eax
  801b92:	8b 00                	mov    (%eax),%eax
  801b94:	ba 00 00 00 00       	mov    $0x0,%edx
  801b99:	eb 1c                	jmp    801bb7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	8b 00                	mov    (%eax),%eax
  801ba0:	8d 50 04             	lea    0x4(%eax),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	89 10                	mov    %edx,(%eax)
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	8b 00                	mov    (%eax),%eax
  801bad:	83 e8 04             	sub    $0x4,%eax
  801bb0:	8b 00                	mov    (%eax),%eax
  801bb2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    

00801bb9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801bbc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bc0:	7e 1c                	jle    801bde <getint+0x25>
		return va_arg(*ap, long long);
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	8b 00                	mov    (%eax),%eax
  801bc7:	8d 50 08             	lea    0x8(%eax),%edx
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	89 10                	mov    %edx,(%eax)
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	8b 00                	mov    (%eax),%eax
  801bd4:	83 e8 08             	sub    $0x8,%eax
  801bd7:	8b 50 04             	mov    0x4(%eax),%edx
  801bda:	8b 00                	mov    (%eax),%eax
  801bdc:	eb 40                	jmp    801c1e <getint+0x65>
	else if (lflag)
  801bde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801be2:	74 1e                	je     801c02 <getint+0x49>
		return va_arg(*ap, long);
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	8b 00                	mov    (%eax),%eax
  801be9:	8d 50 04             	lea    0x4(%eax),%edx
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	89 10                	mov    %edx,(%eax)
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	8b 00                	mov    (%eax),%eax
  801bf6:	83 e8 04             	sub    $0x4,%eax
  801bf9:	8b 00                	mov    (%eax),%eax
  801bfb:	89 c2                	mov    %eax,%edx
  801bfd:	c1 fa 1f             	sar    $0x1f,%edx
  801c00:	eb 1c                	jmp    801c1e <getint+0x65>
	else
		return va_arg(*ap, int);
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	8b 00                	mov    (%eax),%eax
  801c07:	8d 50 04             	lea    0x4(%eax),%edx
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	89 10                	mov    %edx,(%eax)
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	8b 00                	mov    (%eax),%eax
  801c14:	83 e8 04             	sub    $0x4,%eax
  801c17:	8b 00                	mov    (%eax),%eax
  801c19:	89 c2                	mov    %eax,%edx
  801c1b:	c1 fa 1f             	sar    $0x1f,%edx
}
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    

00801c20 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	56                   	push   %esi
  801c24:	53                   	push   %ebx
  801c25:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c28:	eb 17                	jmp    801c41 <vprintfmt+0x21>
			if (ch == '\0')
  801c2a:	85 db                	test   %ebx,%ebx
  801c2c:	0f 84 d1 05 00 00    	je     802203 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  801c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c39:	89 1c 24             	mov    %ebx,(%esp)
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c41:	8b 45 10             	mov    0x10(%ebp),%eax
  801c44:	0f b6 00             	movzbl (%eax),%eax
  801c47:	0f b6 d8             	movzbl %al,%ebx
  801c4a:	83 fb 25             	cmp    $0x25,%ebx
  801c4d:	0f 95 c0             	setne  %al
  801c50:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  801c54:	84 c0                	test   %al,%al
  801c56:	75 d2                	jne    801c2a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801c58:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801c5c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801c63:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801c6a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801c71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801c78:	eb 04                	jmp    801c7e <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  801c7a:	90                   	nop
  801c7b:	eb 01                	jmp    801c7e <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  801c7d:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c81:	0f b6 00             	movzbl (%eax),%eax
  801c84:	0f b6 d8             	movzbl %al,%ebx
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  801c8d:	83 e8 23             	sub    $0x23,%eax
  801c90:	83 f8 55             	cmp    $0x55,%eax
  801c93:	0f 87 39 05 00 00    	ja     8021d2 <vprintfmt+0x5b2>
  801c99:	8b 04 85 24 2a 80 00 	mov    0x802a24(,%eax,4),%eax
  801ca0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801ca2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801ca6:	eb d6                	jmp    801c7e <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ca8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801cac:	eb d0                	jmp    801c7e <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801cae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801cb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb8:	89 d0                	mov    %edx,%eax
  801cba:	c1 e0 02             	shl    $0x2,%eax
  801cbd:	01 d0                	add    %edx,%eax
  801cbf:	01 c0                	add    %eax,%eax
  801cc1:	01 d8                	add    %ebx,%eax
  801cc3:	83 e8 30             	sub    $0x30,%eax
  801cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	0f b6 00             	movzbl (%eax),%eax
  801ccf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801cd2:	83 fb 2f             	cmp    $0x2f,%ebx
  801cd5:	7e 43                	jle    801d1a <vprintfmt+0xfa>
  801cd7:	83 fb 39             	cmp    $0x39,%ebx
  801cda:	7f 3e                	jg     801d1a <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801cdc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ce0:	eb d3                	jmp    801cb5 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ce2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce5:	83 c0 04             	add    $0x4,%eax
  801ce8:	89 45 14             	mov    %eax,0x14(%ebp)
  801ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cee:	83 e8 04             	sub    $0x4,%eax
  801cf1:	8b 00                	mov    (%eax),%eax
  801cf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801cf6:	eb 23                	jmp    801d1b <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  801cf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cfc:	0f 89 78 ff ff ff    	jns    801c7a <vprintfmt+0x5a>
				width = 0;
  801d02:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801d09:	e9 6c ff ff ff       	jmp    801c7a <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  801d0e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801d15:	e9 64 ff ff ff       	jmp    801c7e <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801d1a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801d1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d1f:	0f 89 58 ff ff ff    	jns    801c7d <vprintfmt+0x5d>
				width = precision, precision = -1;
  801d25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d2b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d32:	e9 46 ff ff ff       	jmp    801c7d <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d37:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  801d3b:	e9 3e ff ff ff       	jmp    801c7e <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801d40:	8b 45 14             	mov    0x14(%ebp),%eax
  801d43:	83 c0 04             	add    $0x4,%eax
  801d46:	89 45 14             	mov    %eax,0x14(%ebp)
  801d49:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4c:	83 e8 04             	sub    $0x4,%eax
  801d4f:	8b 00                	mov    (%eax),%eax
  801d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d54:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d58:	89 04 24             	mov    %eax,(%esp)
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	ff d0                	call   *%eax
			break;
  801d60:	e9 98 04 00 00       	jmp    8021fd <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  801d65:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  801d6c:	00 
  801d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d74:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801d77:	89 04 24             	mov    %eax,(%esp)
  801d7a:	e8 31 e6 ff ff       	call   8003b0 <memmove>
            sel_c[3] = '\0';
  801d7f:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  801d83:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  801d87:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  801d8b:	3c 2f                	cmp    $0x2f,%al
  801d8d:	7e 4c                	jle    801ddb <vprintfmt+0x1bb>
  801d8f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  801d93:	3c 39                	cmp    $0x39,%al
  801d95:	7f 44                	jg     801ddb <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  801d97:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  801d9b:	0f be d0             	movsbl %al,%edx
  801d9e:	89 d0                	mov    %edx,%eax
  801da0:	c1 e0 02             	shl    $0x2,%eax
  801da3:	01 d0                	add    %edx,%eax
  801da5:	01 c0                	add    %eax,%eax
  801da7:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  801dad:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  801db1:	0f be c0             	movsbl %al,%eax
  801db4:	01 c2                	add    %eax,%edx
  801db6:	89 d0                	mov    %edx,%eax
  801db8:	c1 e0 02             	shl    $0x2,%eax
  801dbb:	01 d0                	add    %edx,%eax
  801dbd:	01 c0                	add    %eax,%eax
  801dbf:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  801dc5:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  801dc9:	0f be c0             	movsbl %al,%eax
  801dcc:	01 d0                	add    %edx,%eax
  801dce:	83 e8 30             	sub    $0x30,%eax
  801dd1:	a3 40 50 80 00       	mov    %eax,0x805040
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801dd6:	e9 22 04 00 00       	jmp    8021fd <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  801ddb:	c7 44 24 04 ed 29 80 	movl   $0x8029ed,0x4(%esp)
  801de2:	00 
  801de3:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801de6:	89 04 24             	mov    %eax,(%esp)
  801de9:	e8 96 e4 ff ff       	call   800284 <strcmp>
  801dee:	85 c0                	test   %eax,%eax
  801df0:	75 0f                	jne    801e01 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  801df2:	c7 05 40 50 80 00 07 	movl   $0x7,0x805040
  801df9:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801dfc:	e9 fc 03 00 00       	jmp    8021fd <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  801e01:	c7 44 24 04 f1 29 80 	movl   $0x8029f1,0x4(%esp)
  801e08:	00 
  801e09:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801e0c:	89 04 24             	mov    %eax,(%esp)
  801e0f:	e8 70 e4 ff ff       	call   800284 <strcmp>
  801e14:	85 c0                	test   %eax,%eax
  801e16:	75 0f                	jne    801e27 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  801e18:	c7 05 40 50 80 00 01 	movl   $0x1,0x805040
  801e1f:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801e22:	e9 d6 03 00 00       	jmp    8021fd <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  801e27:	c7 44 24 04 f5 29 80 	movl   $0x8029f5,0x4(%esp)
  801e2e:	00 
  801e2f:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801e32:	89 04 24             	mov    %eax,(%esp)
  801e35:	e8 4a e4 ff ff       	call   800284 <strcmp>
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	75 0f                	jne    801e4d <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  801e3e:	c7 05 40 50 80 00 02 	movl   $0x2,0x805040
  801e45:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801e48:	e9 b0 03 00 00       	jmp    8021fd <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  801e4d:	c7 44 24 04 f9 29 80 	movl   $0x8029f9,0x4(%esp)
  801e54:	00 
  801e55:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801e58:	89 04 24             	mov    %eax,(%esp)
  801e5b:	e8 24 e4 ff ff       	call   800284 <strcmp>
  801e60:	85 c0                	test   %eax,%eax
  801e62:	75 0f                	jne    801e73 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  801e64:	c7 05 40 50 80 00 04 	movl   $0x4,0x805040
  801e6b:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801e6e:	e9 8a 03 00 00       	jmp    8021fd <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  801e73:	c7 44 24 04 fd 29 80 	movl   $0x8029fd,0x4(%esp)
  801e7a:	00 
  801e7b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801e7e:	89 04 24             	mov    %eax,(%esp)
  801e81:	e8 fe e3 ff ff       	call   800284 <strcmp>
  801e86:	85 c0                	test   %eax,%eax
  801e88:	75 0f                	jne    801e99 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  801e8a:	c7 05 40 50 80 00 08 	movl   $0x8,0x805040
  801e91:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801e94:	e9 64 03 00 00       	jmp    8021fd <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  801e99:	c7 44 24 04 01 2a 80 	movl   $0x802a01,0x4(%esp)
  801ea0:	00 
  801ea1:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801ea4:	89 04 24             	mov    %eax,(%esp)
  801ea7:	e8 d8 e3 ff ff       	call   800284 <strcmp>
  801eac:	85 c0                	test   %eax,%eax
  801eae:	75 0f                	jne    801ebf <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  801eb0:	c7 05 40 50 80 00 0f 	movl   $0xf,0x805040
  801eb7:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801eba:	e9 3e 03 00 00       	jmp    8021fd <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  801ebf:	c7 44 24 04 05 2a 80 	movl   $0x802a05,0x4(%esp)
  801ec6:	00 
  801ec7:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801eca:	89 04 24             	mov    %eax,(%esp)
  801ecd:	e8 b2 e3 ff ff       	call   800284 <strcmp>
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	75 0f                	jne    801ee5 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  801ed6:	c7 05 40 50 80 00 0c 	movl   $0xc,0x805040
  801edd:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801ee0:	e9 18 03 00 00       	jmp    8021fd <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  801ee5:	c7 44 24 04 09 2a 80 	movl   $0x802a09,0x4(%esp)
  801eec:	00 
  801eed:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801ef0:	89 04 24             	mov    %eax,(%esp)
  801ef3:	e8 8c e3 ff ff       	call   800284 <strcmp>
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	75 0f                	jne    801f0b <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  801efc:	c7 05 40 50 80 00 06 	movl   $0x6,0x805040
  801f03:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801f06:	e9 f2 02 00 00       	jmp    8021fd <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  801f0b:	c7 44 24 04 0d 2a 80 	movl   $0x802a0d,0x4(%esp)
  801f12:	00 
  801f13:	8d 45 d7             	lea    -0x29(%ebp),%eax
  801f16:	89 04 24             	mov    %eax,(%esp)
  801f19:	e8 66 e3 ff ff       	call   800284 <strcmp>
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	75 0f                	jne    801f31 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  801f22:	c7 05 40 50 80 00 0b 	movl   $0xb,0x805040
  801f29:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801f2c:	e9 cc 02 00 00       	jmp    8021fd <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  801f31:	c7 05 40 50 80 00 07 	movl   $0x7,0x805040
  801f38:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  801f3b:	e9 bd 02 00 00       	jmp    8021fd <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801f40:	8b 45 14             	mov    0x14(%ebp),%eax
  801f43:	83 c0 04             	add    $0x4,%eax
  801f46:	89 45 14             	mov    %eax,0x14(%ebp)
  801f49:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4c:	83 e8 04             	sub    $0x4,%eax
  801f4f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801f51:	85 db                	test   %ebx,%ebx
  801f53:	79 02                	jns    801f57 <vprintfmt+0x337>
				err = -err;
  801f55:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801f57:	83 fb 0e             	cmp    $0xe,%ebx
  801f5a:	7f 0b                	jg     801f67 <vprintfmt+0x347>
  801f5c:	8b 34 9d a0 29 80 00 	mov    0x8029a0(,%ebx,4),%esi
  801f63:	85 f6                	test   %esi,%esi
  801f65:	75 23                	jne    801f8a <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  801f67:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f6b:	c7 44 24 08 11 2a 80 	movl   $0x802a11,0x8(%esp)
  801f72:	00 
  801f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	89 04 24             	mov    %eax,(%esp)
  801f80:	e8 86 02 00 00       	call   80220b <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801f85:	e9 73 02 00 00       	jmp    8021fd <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801f8a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f8e:	c7 44 24 08 1a 2a 80 	movl   $0x802a1a,0x8(%esp)
  801f95:	00 
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	89 04 24             	mov    %eax,(%esp)
  801fa3:	e8 63 02 00 00       	call   80220b <printfmt>
			break;
  801fa8:	e9 50 02 00 00       	jmp    8021fd <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801fad:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb0:	83 c0 04             	add    $0x4,%eax
  801fb3:	89 45 14             	mov    %eax,0x14(%ebp)
  801fb6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb9:	83 e8 04             	sub    $0x4,%eax
  801fbc:	8b 30                	mov    (%eax),%esi
  801fbe:	85 f6                	test   %esi,%esi
  801fc0:	75 05                	jne    801fc7 <vprintfmt+0x3a7>
				p = "(null)";
  801fc2:	be 1d 2a 80 00       	mov    $0x802a1d,%esi
			if (width > 0 && padc != '-')
  801fc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fcb:	7e 73                	jle    802040 <vprintfmt+0x420>
  801fcd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801fd1:	74 6d                	je     802040 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  801fd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fda:	89 34 24             	mov    %esi,(%esp)
  801fdd:	e8 ac e1 ff ff       	call   80018e <strnlen>
  801fe2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801fe5:	eb 17                	jmp    801ffe <vprintfmt+0x3de>
					putch(padc, putdat);
  801fe7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fee:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ff2:	89 04 24             	mov    %eax,(%esp)
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801ffa:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801ffe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802002:	7f e3                	jg     801fe7 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802004:	eb 3a                	jmp    802040 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  802006:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80200a:	74 1f                	je     80202b <vprintfmt+0x40b>
  80200c:	83 fb 1f             	cmp    $0x1f,%ebx
  80200f:	7e 05                	jle    802016 <vprintfmt+0x3f6>
  802011:	83 fb 7e             	cmp    $0x7e,%ebx
  802014:	7e 15                	jle    80202b <vprintfmt+0x40b>
					putch('?', putdat);
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	ff d0                	call   *%eax
  802029:	eb 0f                	jmp    80203a <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802032:	89 1c 24             	mov    %ebx,(%esp)
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80203a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80203e:	eb 01                	jmp    802041 <vprintfmt+0x421>
  802040:	90                   	nop
  802041:	0f b6 06             	movzbl (%esi),%eax
  802044:	0f be d8             	movsbl %al,%ebx
  802047:	85 db                	test   %ebx,%ebx
  802049:	0f 95 c0             	setne  %al
  80204c:	83 c6 01             	add    $0x1,%esi
  80204f:	84 c0                	test   %al,%al
  802051:	74 29                	je     80207c <vprintfmt+0x45c>
  802053:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802057:	78 ad                	js     802006 <vprintfmt+0x3e6>
  802059:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80205d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802061:	79 a3                	jns    802006 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802063:	eb 17                	jmp    80207c <vprintfmt+0x45c>
				putch(' ', putdat);
  802065:	8b 45 0c             	mov    0xc(%ebp),%eax
  802068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802078:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80207c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802080:	7f e3                	jg     802065 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  802082:	e9 76 01 00 00       	jmp    8021fd <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  802087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80208a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208e:	8d 45 14             	lea    0x14(%ebp),%eax
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 20 fb ff ff       	call   801bb9 <getint>
  802099:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80209c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80209f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a5:	85 d2                	test   %edx,%edx
  8020a7:	79 26                	jns    8020cf <vprintfmt+0x4af>
				putch('-', putdat);
  8020a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	ff d0                	call   *%eax
				num = -(long long) num;
  8020bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c2:	f7 d8                	neg    %eax
  8020c4:	83 d2 00             	adc    $0x0,%edx
  8020c7:	f7 da                	neg    %edx
  8020c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8020cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8020d6:	e9 ae 00 00 00       	jmp    802189 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8020db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8020e5:	89 04 24             	mov    %eax,(%esp)
  8020e8:	e8 65 fa ff ff       	call   801b52 <getuint>
  8020ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8020f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8020fa:	e9 8a 00 00 00       	jmp    802189 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  8020ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802102:	89 44 24 04          	mov    %eax,0x4(%esp)
  802106:	8d 45 14             	lea    0x14(%ebp),%eax
  802109:	89 04 24             	mov    %eax,(%esp)
  80210c:	e8 41 fa ff ff       	call   801b52 <getuint>
  802111:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802114:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  802117:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  80211e:	eb 69                	jmp    802189 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	89 44 24 04          	mov    %eax,0x4(%esp)
  802127:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	ff d0                	call   *%eax
			putch('x', putdat);
  802133:	8b 45 0c             	mov    0xc(%ebp),%eax
  802136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  802146:	8b 45 14             	mov    0x14(%ebp),%eax
  802149:	83 c0 04             	add    $0x4,%eax
  80214c:	89 45 14             	mov    %eax,0x14(%ebp)
  80214f:	8b 45 14             	mov    0x14(%ebp),%eax
  802152:	83 e8 04             	sub    $0x4,%eax
  802155:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802157:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80215a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  802161:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  802168:	eb 1f                	jmp    802189 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80216a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80216d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802171:	8d 45 14             	lea    0x14(%ebp),%eax
  802174:	89 04 24             	mov    %eax,(%esp)
  802177:	e8 d6 f9 ff ff       	call   801b52 <getuint>
  80217c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80217f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802182:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802189:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80218d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802190:	89 54 24 18          	mov    %edx,0x18(%esp)
  802194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802197:	89 54 24 14          	mov    %edx,0x14(%esp)
  80219b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	89 04 24             	mov    %eax,(%esp)
  8021ba:	e8 b5 f8 ff ff       	call   801a74 <printnum>
			break;
  8021bf:	eb 3c                	jmp    8021fd <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8021c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c8:	89 1c 24             	mov    %ebx,(%esp)
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	ff d0                	call   *%eax
			break;
  8021d0:	eb 2b                	jmp    8021fd <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8021d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8021e5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8021e9:	eb 04                	jmp    8021ef <vprintfmt+0x5cf>
  8021eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8021ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f2:	83 e8 01             	sub    $0x1,%eax
  8021f5:	0f b6 00             	movzbl (%eax),%eax
  8021f8:	3c 25                	cmp    $0x25,%al
  8021fa:	75 ef                	jne    8021eb <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  8021fc:	90                   	nop
		}
	}
  8021fd:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8021fe:	e9 3e fa ff ff       	jmp    801c41 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  802203:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802204:	83 c4 50             	add    $0x50,%esp
  802207:	5b                   	pop    %ebx
  802208:	5e                   	pop    %esi
  802209:	5d                   	pop    %ebp
  80220a:	c3                   	ret    

0080220b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  802211:	8d 45 10             	lea    0x10(%ebp),%eax
  802214:	83 c0 04             	add    $0x4,%eax
  802217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80221a:	8b 45 10             	mov    0x10(%ebp),%eax
  80221d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802220:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802224:	89 44 24 08          	mov    %eax,0x8(%esp)
  802228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	89 04 24             	mov    %eax,(%esp)
  802235:	e8 e6 f9 ff ff       	call   801c20 <vprintfmt>
	va_end(ap);
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80223f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802242:	8b 40 08             	mov    0x8(%eax),%eax
  802245:	8d 50 01             	lea    0x1(%eax),%edx
  802248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80224e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802251:	8b 10                	mov    (%eax),%edx
  802253:	8b 45 0c             	mov    0xc(%ebp),%eax
  802256:	8b 40 04             	mov    0x4(%eax),%eax
  802259:	39 c2                	cmp    %eax,%edx
  80225b:	73 12                	jae    80226f <sprintputch+0x33>
		*b->buf++ = ch;
  80225d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802260:	8b 00                	mov    (%eax),%eax
  802262:	8b 55 08             	mov    0x8(%ebp),%edx
  802265:	88 10                	mov    %dl,(%eax)
  802267:	8d 50 01             	lea    0x1(%eax),%edx
  80226a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226d:	89 10                	mov    %edx,(%eax)
}
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    

00802271 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80227d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802280:	83 e8 01             	sub    $0x1,%eax
  802283:	03 45 08             	add    0x8(%ebp),%eax
  802286:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802289:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802294:	74 06                	je     80229c <vsnprintf+0x2b>
  802296:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80229a:	7f 07                	jg     8022a3 <vsnprintf+0x32>
		return -E_INVAL;
  80229c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022a1:	eb 2a                	jmp    8022cd <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8022a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b8:	c7 04 24 3c 22 80 00 	movl   $0x80223c,(%esp)
  8022bf:	e8 5c f9 ff ff       	call   801c20 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8022c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8022d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8022d8:	83 c0 04             	add    $0x4,%eax
  8022db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8022de:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	89 04 24             	mov    %eax,(%esp)
  8022f9:	e8 73 ff ff ff       	call   802271 <vsnprintf>
  8022fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802301:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    
	...

00802308 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  80230e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802312:	75 11                	jne    802325 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  802314:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  80231b:	e8 eb e6 ff ff       	call   800a0b <sys_ipc_recv>
  802320:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802323:	eb 0e                	jmp    802333 <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  802325:	8b 45 0c             	mov    0xc(%ebp),%eax
  802328:	89 04 24             	mov    %eax,(%esp)
  80232b:	e8 db e6 ff ff       	call   800a0b <sys_ipc_recv>
  802330:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  802333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802337:	79 1c                	jns    802355 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  802339:	c7 44 24 08 7c 2b 80 	movl   $0x802b7c,0x8(%esp)
  802340:	00 
  802341:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  802348:	00 
  802349:	c7 04 24 92 2b 80 00 	movl   $0x802b92,(%esp)
  802350:	e8 c3 f5 ff ff       	call   801918 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  802355:	e8 18 e4 ff ff       	call   800772 <sys_getenvid>
  80235a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80235f:	c1 e0 07             	shl    $0x7,%eax
  802362:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802367:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  80236a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236e:	74 0b                	je     80237b <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 50 74             	mov    0x74(%eax),%edx
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  80237b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80237f:	74 0b                	je     80238c <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  802381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802384:	8b 50 78             	mov    0x78(%eax),%edx
  802387:	8b 45 10             	mov    0x10(%ebp),%eax
  80238a:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  80238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238f:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  80239a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80239e:	75 26                	jne    8023c6 <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  8023a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023a7:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  8023ae:	ee 
  8023af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	89 04 24             	mov    %eax,(%esp)
  8023bc:	e8 0a e6 ff ff       	call   8009cb <sys_ipc_try_send>
  8023c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c4:	eb 23                	jmp    8023e9 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  8023c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	89 04 24             	mov    %eax,(%esp)
  8023e1:	e8 e5 e5 ff ff       	call   8009cb <sys_ipc_try_send>
  8023e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  8023e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ed:	79 29                	jns    802418 <ipc_send+0x84>
  8023ef:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  8023f3:	74 23                	je     802418 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023fc:	c7 44 24 08 9c 2b 80 	movl   $0x802b9c,0x8(%esp)
  802403:	00 
  802404:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80240b:	00 
  80240c:	c7 04 24 92 2b 80 00 	movl   $0x802b92,(%esp)
  802413:	e8 00 f5 ff ff       	call   801918 <_panic>
	    sys_yield();
  802418:	e8 99 e3 ff ff       	call   8007b6 <sys_yield>
	}while(r < 0);
  80241d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802421:	0f 88 73 ff ff ff    	js     80239a <ipc_send+0x6>
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    
  802429:	00 00                	add    %al,(%eax)
  80242b:	00 00                	add    %al,(%eax)
  80242d:	00 00                	add    %al,(%eax)
	...

00802430 <__udivdi3>:
  802430:	83 ec 1c             	sub    $0x1c,%esp
  802433:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802437:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80243b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80243f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802443:	89 74 24 10          	mov    %esi,0x10(%esp)
  802447:	8b 74 24 24          	mov    0x24(%esp),%esi
  80244b:	85 ff                	test   %edi,%edi
  80244d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802451:	89 44 24 08          	mov    %eax,0x8(%esp)
  802455:	89 cd                	mov    %ecx,%ebp
  802457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245b:	75 33                	jne    802490 <__udivdi3+0x60>
  80245d:	39 f1                	cmp    %esi,%ecx
  80245f:	77 57                	ja     8024b8 <__udivdi3+0x88>
  802461:	85 c9                	test   %ecx,%ecx
  802463:	75 0b                	jne    802470 <__udivdi3+0x40>
  802465:	b8 01 00 00 00       	mov    $0x1,%eax
  80246a:	31 d2                	xor    %edx,%edx
  80246c:	f7 f1                	div    %ecx
  80246e:	89 c1                	mov    %eax,%ecx
  802470:	89 f0                	mov    %esi,%eax
  802472:	31 d2                	xor    %edx,%edx
  802474:	f7 f1                	div    %ecx
  802476:	89 c6                	mov    %eax,%esi
  802478:	8b 44 24 04          	mov    0x4(%esp),%eax
  80247c:	f7 f1                	div    %ecx
  80247e:	89 f2                	mov    %esi,%edx
  802480:	8b 74 24 10          	mov    0x10(%esp),%esi
  802484:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802488:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80248c:	83 c4 1c             	add    $0x1c,%esp
  80248f:	c3                   	ret    
  802490:	31 d2                	xor    %edx,%edx
  802492:	31 c0                	xor    %eax,%eax
  802494:	39 f7                	cmp    %esi,%edi
  802496:	77 e8                	ja     802480 <__udivdi3+0x50>
  802498:	0f bd cf             	bsr    %edi,%ecx
  80249b:	83 f1 1f             	xor    $0x1f,%ecx
  80249e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024a2:	75 2c                	jne    8024d0 <__udivdi3+0xa0>
  8024a4:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  8024a8:	76 04                	jbe    8024ae <__udivdi3+0x7e>
  8024aa:	39 f7                	cmp    %esi,%edi
  8024ac:	73 d2                	jae    802480 <__udivdi3+0x50>
  8024ae:	31 d2                	xor    %edx,%edx
  8024b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b5:	eb c9                	jmp    802480 <__udivdi3+0x50>
  8024b7:	90                   	nop
  8024b8:	89 f2                	mov    %esi,%edx
  8024ba:	f7 f1                	div    %ecx
  8024bc:	31 d2                	xor    %edx,%edx
  8024be:	8b 74 24 10          	mov    0x10(%esp),%esi
  8024c2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8024c6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	c3                   	ret    
  8024ce:	66 90                	xchg   %ax,%ax
  8024d0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024d5:	b8 20 00 00 00       	mov    $0x20,%eax
  8024da:	89 ea                	mov    %ebp,%edx
  8024dc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8024e0:	d3 e7                	shl    %cl,%edi
  8024e2:	89 c1                	mov    %eax,%ecx
  8024e4:	d3 ea                	shr    %cl,%edx
  8024e6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024eb:	09 fa                	or     %edi,%edx
  8024ed:	89 f7                	mov    %esi,%edi
  8024ef:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024f3:	89 f2                	mov    %esi,%edx
  8024f5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8024f9:	d3 e5                	shl    %cl,%ebp
  8024fb:	89 c1                	mov    %eax,%ecx
  8024fd:	d3 ef                	shr    %cl,%edi
  8024ff:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802504:	d3 e2                	shl    %cl,%edx
  802506:	89 c1                	mov    %eax,%ecx
  802508:	d3 ee                	shr    %cl,%esi
  80250a:	09 d6                	or     %edx,%esi
  80250c:	89 fa                	mov    %edi,%edx
  80250e:	89 f0                	mov    %esi,%eax
  802510:	f7 74 24 0c          	divl   0xc(%esp)
  802514:	89 d7                	mov    %edx,%edi
  802516:	89 c6                	mov    %eax,%esi
  802518:	f7 e5                	mul    %ebp
  80251a:	39 d7                	cmp    %edx,%edi
  80251c:	72 22                	jb     802540 <__udivdi3+0x110>
  80251e:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802522:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802527:	d3 e5                	shl    %cl,%ebp
  802529:	39 c5                	cmp    %eax,%ebp
  80252b:	73 04                	jae    802531 <__udivdi3+0x101>
  80252d:	39 d7                	cmp    %edx,%edi
  80252f:	74 0f                	je     802540 <__udivdi3+0x110>
  802531:	89 f0                	mov    %esi,%eax
  802533:	31 d2                	xor    %edx,%edx
  802535:	e9 46 ff ff ff       	jmp    802480 <__udivdi3+0x50>
  80253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802540:	8d 46 ff             	lea    -0x1(%esi),%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	8b 74 24 10          	mov    0x10(%esp),%esi
  802549:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80254d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802551:	83 c4 1c             	add    $0x1c,%esp
  802554:	c3                   	ret    
	...

00802560 <__umoddi3>:
  802560:	83 ec 1c             	sub    $0x1c,%esp
  802563:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802567:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  80256b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80256f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802573:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802577:	8b 74 24 24          	mov    0x24(%esp),%esi
  80257b:	85 ed                	test   %ebp,%ebp
  80257d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802581:	89 44 24 08          	mov    %eax,0x8(%esp)
  802585:	89 cf                	mov    %ecx,%edi
  802587:	89 04 24             	mov    %eax,(%esp)
  80258a:	89 f2                	mov    %esi,%edx
  80258c:	75 1a                	jne    8025a8 <__umoddi3+0x48>
  80258e:	39 f1                	cmp    %esi,%ecx
  802590:	76 4e                	jbe    8025e0 <__umoddi3+0x80>
  802592:	f7 f1                	div    %ecx
  802594:	89 d0                	mov    %edx,%eax
  802596:	31 d2                	xor    %edx,%edx
  802598:	8b 74 24 10          	mov    0x10(%esp),%esi
  80259c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025a0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025a4:	83 c4 1c             	add    $0x1c,%esp
  8025a7:	c3                   	ret    
  8025a8:	39 f5                	cmp    %esi,%ebp
  8025aa:	77 54                	ja     802600 <__umoddi3+0xa0>
  8025ac:	0f bd c5             	bsr    %ebp,%eax
  8025af:	83 f0 1f             	xor    $0x1f,%eax
  8025b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b6:	75 60                	jne    802618 <__umoddi3+0xb8>
  8025b8:	3b 0c 24             	cmp    (%esp),%ecx
  8025bb:	0f 87 07 01 00 00    	ja     8026c8 <__umoddi3+0x168>
  8025c1:	89 f2                	mov    %esi,%edx
  8025c3:	8b 34 24             	mov    (%esp),%esi
  8025c6:	29 ce                	sub    %ecx,%esi
  8025c8:	19 ea                	sbb    %ebp,%edx
  8025ca:	89 34 24             	mov    %esi,(%esp)
  8025cd:	8b 04 24             	mov    (%esp),%eax
  8025d0:	8b 74 24 10          	mov    0x10(%esp),%esi
  8025d4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8025d8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8025dc:	83 c4 1c             	add    $0x1c,%esp
  8025df:	c3                   	ret    
  8025e0:	85 c9                	test   %ecx,%ecx
  8025e2:	75 0b                	jne    8025ef <__umoddi3+0x8f>
  8025e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e9:	31 d2                	xor    %edx,%edx
  8025eb:	f7 f1                	div    %ecx
  8025ed:	89 c1                	mov    %eax,%ecx
  8025ef:	89 f0                	mov    %esi,%eax
  8025f1:	31 d2                	xor    %edx,%edx
  8025f3:	f7 f1                	div    %ecx
  8025f5:	8b 04 24             	mov    (%esp),%eax
  8025f8:	f7 f1                	div    %ecx
  8025fa:	eb 98                	jmp    802594 <__umoddi3+0x34>
  8025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802600:	89 f2                	mov    %esi,%edx
  802602:	8b 74 24 10          	mov    0x10(%esp),%esi
  802606:	8b 7c 24 14          	mov    0x14(%esp),%edi
  80260a:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	c3                   	ret    
  802612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802618:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80261d:	89 e8                	mov    %ebp,%eax
  80261f:	bd 20 00 00 00       	mov    $0x20,%ebp
  802624:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802628:	89 fa                	mov    %edi,%edx
  80262a:	d3 e0                	shl    %cl,%eax
  80262c:	89 e9                	mov    %ebp,%ecx
  80262e:	d3 ea                	shr    %cl,%edx
  802630:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802635:	09 c2                	or     %eax,%edx
  802637:	8b 44 24 08          	mov    0x8(%esp),%eax
  80263b:	89 14 24             	mov    %edx,(%esp)
  80263e:	89 f2                	mov    %esi,%edx
  802640:	d3 e7                	shl    %cl,%edi
  802642:	89 e9                	mov    %ebp,%ecx
  802644:	d3 ea                	shr    %cl,%edx
  802646:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80264b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80264f:	d3 e6                	shl    %cl,%esi
  802651:	89 e9                	mov    %ebp,%ecx
  802653:	d3 e8                	shr    %cl,%eax
  802655:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80265a:	09 f0                	or     %esi,%eax
  80265c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802660:	f7 34 24             	divl   (%esp)
  802663:	d3 e6                	shl    %cl,%esi
  802665:	89 74 24 08          	mov    %esi,0x8(%esp)
  802669:	89 d6                	mov    %edx,%esi
  80266b:	f7 e7                	mul    %edi
  80266d:	39 d6                	cmp    %edx,%esi
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	89 d7                	mov    %edx,%edi
  802673:	72 3f                	jb     8026b4 <__umoddi3+0x154>
  802675:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802679:	72 35                	jb     8026b0 <__umoddi3+0x150>
  80267b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80267f:	29 c8                	sub    %ecx,%eax
  802681:	19 fe                	sbb    %edi,%esi
  802683:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802688:	89 f2                	mov    %esi,%edx
  80268a:	d3 e8                	shr    %cl,%eax
  80268c:	89 e9                	mov    %ebp,%ecx
  80268e:	d3 e2                	shl    %cl,%edx
  802690:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802695:	09 d0                	or     %edx,%eax
  802697:	89 f2                	mov    %esi,%edx
  802699:	d3 ea                	shr    %cl,%edx
  80269b:	8b 74 24 10          	mov    0x10(%esp),%esi
  80269f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8026a3:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8026a7:	83 c4 1c             	add    $0x1c,%esp
  8026aa:	c3                   	ret    
  8026ab:	90                   	nop
  8026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	39 d6                	cmp    %edx,%esi
  8026b2:	75 c7                	jne    80267b <__umoddi3+0x11b>
  8026b4:	89 d7                	mov    %edx,%edi
  8026b6:	89 c1                	mov    %eax,%ecx
  8026b8:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  8026bc:	1b 3c 24             	sbb    (%esp),%edi
  8026bf:	eb ba                	jmp    80267b <__umoddi3+0x11b>
  8026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	39 f5                	cmp    %esi,%ebp
  8026ca:	0f 82 f1 fe ff ff    	jb     8025c1 <__umoddi3+0x61>
  8026d0:	e9 f8 fe ff ff       	jmp    8025cd <__umoddi3+0x6d>
