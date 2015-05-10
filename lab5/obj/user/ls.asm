
obj/user/ls:     file format elf32-i386


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
  80002c:	e8 13 04 00 00       	call   800444 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80003d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800043:	89 44 24 04          	mov    %eax,0x4(%esp)
  800047:	8b 45 08             	mov    0x8(%ebp),%eax
  80004a:	89 04 24             	mov    %eax,(%esp)
  80004d:	e8 df 1d 00 00       	call   801e31 <stat>
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800059:	79 2a                	jns    800085 <ls+0x51>
		panic("stat %s: %e", path, r);
  80005b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80005e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800062:	8b 45 08             	mov    0x8(%ebp),%eax
  800065:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800069:	c7 44 24 08 c0 2b 80 	movl   $0x802bc0,0x8(%esp)
  800070:	00 
  800071:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800078:	00 
  800079:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  800080:	e8 23 04 00 00       	call   8004a8 <_panic>
	if (st.st_isdir && !flag['d'])
  800085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800088:	85 c0                	test   %eax,%eax
  80008a:	74 1d                	je     8000a9 <ls+0x75>
  80008c:	a1 d0 61 80 00       	mov    0x8061d0,%eax
  800091:	85 c0                	test   %eax,%eax
  800093:	75 14                	jne    8000a9 <ls+0x75>
		lsdir(path, prefix);
  800095:	8b 45 0c             	mov    0xc(%ebp),%eax
  800098:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009c:	8b 45 08             	mov    0x8(%ebp),%eax
  80009f:	89 04 24             	mov    %eax,(%esp)
  8000a2:	e8 25 00 00 00       	call   8000cc <lsdir>
  8000a7:	eb 21                	jmp    8000ca <ls+0x96>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000b2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8000b6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c5:	e8 12 01 00 00       	call   8001dc <ls1>
}
  8000ca:	c9                   	leave  
  8000cb:	c3                   	ret    

008000cc <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	81 ec 38 01 00 00    	sub    $0x138,%esp
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  8000d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000dc:	00 
  8000dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8000e0:	89 04 24             	mov    %eax,(%esp)
  8000e3:	e8 98 1d 00 00       	call   801e80 <open>
  8000e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8000ef:	79 67                	jns    800158 <lsdir+0x8c>
		panic("open %s: %e", path, fd);
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000ff:	c7 44 24 08 d6 2b 80 	movl   $0x802bd6,0x8(%esp)
  800106:	00 
  800107:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80010e:	00 
  80010f:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  800116:	e8 8d 03 00 00       	call   8004a8 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  80011b:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%ebp),%eax
  800122:	84 c0                	test   %al,%al
  800124:	74 32                	je     800158 <lsdir+0x8c>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800126:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  80012c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800132:	83 f8 01             	cmp    $0x1,%eax
  800135:	0f 94 c0             	sete   %al
  800138:	0f b6 c0             	movzbl %al,%eax
  80013b:	8d 8d f0 fe ff ff    	lea    -0x110(%ebp),%ecx
  800141:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800145:	89 54 24 08          	mov    %edx,0x8(%esp)
  800149:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800150:	89 04 24             	mov    %eax,(%esp)
  800153:	e8 84 00 00 00       	call   8001dc <ls1>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800158:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  80015f:	00 
  800160:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016d:	89 04 24             	mov    %eax,(%esp)
  800170:	e8 60 1a 00 00       	call   801bd5 <readn>
  800175:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800178:	81 7d f0 00 01 00 00 	cmpl   $0x100,-0x10(%ebp)
  80017f:	74 9a                	je     80011b <lsdir+0x4f>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  800181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800185:	7e 23                	jle    8001aa <lsdir+0xde>
		panic("short read in directory %s", path);
  800187:	8b 45 08             	mov    0x8(%ebp),%eax
  80018a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018e:	c7 44 24 08 e2 2b 80 	movl   $0x802be2,0x8(%esp)
  800195:	00 
  800196:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80019d:	00 
  80019e:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  8001a5:	e8 fe 02 00 00       	call   8004a8 <_panic>
	if (n < 0)
  8001aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001ae:	79 2a                	jns    8001da <lsdir+0x10e>
		panic("error reading directory %s: %e", path, n);
  8001b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001be:	c7 44 24 08 00 2c 80 	movl   $0x802c00,0x8(%esp)
  8001c5:	00 
  8001c6:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001cd:	00 
  8001ce:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  8001d5:	e8 ce 02 00 00       	call   8004a8 <_panic>
}
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    

008001dc <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 28             	sub    $0x28,%esp
	char *sep;

	if(flag['l'])
  8001e2:	a1 f0 61 80 00       	mov    0x8061f0,%eax
  8001e7:	85 c0                	test   %eax,%eax
  8001e9:	74 31                	je     80021c <ls1+0x40>
		fprintf(1, "%11d %c ", size, isdir ? 'd' : '-');
  8001eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8001ef:	74 07                	je     8001f8 <ls1+0x1c>
  8001f1:	b8 64 00 00 00       	mov    $0x64,%eax
  8001f6:	eb 05                	jmp    8001fd <ls1+0x21>
  8001f8:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8001fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800201:	8b 45 10             	mov    0x10(%ebp),%eax
  800204:	89 44 24 08          	mov    %eax,0x8(%esp)
  800208:	c7 44 24 04 1f 2c 80 	movl   $0x802c1f,0x4(%esp)
  80020f:	00 
  800210:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800217:	e8 ec 22 00 00       	call   802508 <fprintf>
	if(prefix) {
  80021c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800220:	74 54                	je     800276 <ls1+0x9a>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800222:	8b 45 08             	mov    0x8(%ebp),%eax
  800225:	0f b6 00             	movzbl (%eax),%eax
  800228:	84 c0                	test   %al,%al
  80022a:	74 21                	je     80024d <ls1+0x71>
  80022c:	8b 45 08             	mov    0x8(%ebp),%eax
  80022f:	89 04 24             	mov    %eax,(%esp)
  800232:	e8 61 0c 00 00       	call   800e98 <strlen>
  800237:	83 e8 01             	sub    $0x1,%eax
  80023a:	03 45 08             	add    0x8(%ebp),%eax
  80023d:	0f b6 00             	movzbl (%eax),%eax
  800240:	3c 2f                	cmp    $0x2f,%al
  800242:	74 09                	je     80024d <ls1+0x71>
			sep = "/";
  800244:	c7 45 f4 28 2c 80 00 	movl   $0x802c28,-0xc(%ebp)
  80024b:	eb 07                	jmp    800254 <ls1+0x78>
		else
			sep = "";
  80024d:	c7 45 f4 2a 2c 80 00 	movl   $0x802c2a,-0xc(%ebp)
		fprintf(1, "%s%s", prefix, sep);
  800254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800257:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800262:	c7 44 24 04 2b 2c 80 	movl   $0x802c2b,0x4(%esp)
  800269:	00 
  80026a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800271:	e8 92 22 00 00       	call   802508 <fprintf>
	}
	fprintf(1, "%s", name);
  800276:	8b 45 14             	mov    0x14(%ebp),%eax
  800279:	89 44 24 08          	mov    %eax,0x8(%esp)
  80027d:	c7 44 24 04 30 2c 80 	movl   $0x802c30,0x4(%esp)
  800284:	00 
  800285:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80028c:	e8 77 22 00 00       	call   802508 <fprintf>
	if(flag['F'] && isdir)
  800291:	a1 58 61 80 00       	mov    0x806158,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 1a                	je     8002b4 <ls1+0xd8>
  80029a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80029e:	74 14                	je     8002b4 <ls1+0xd8>
		fprintf(1, "/");
  8002a0:	c7 44 24 04 28 2c 80 	movl   $0x802c28,0x4(%esp)
  8002a7:	00 
  8002a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8002af:	e8 54 22 00 00       	call   802508 <fprintf>
	fprintf(1, "\n");
  8002b4:	c7 44 24 04 33 2c 80 	movl   $0x802c33,0x4(%esp)
  8002bb:	00 
  8002bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8002c3:	e8 40 22 00 00       	call   802508 <fprintf>
}
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <usage>:

void
usage(void)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	83 ec 18             	sub    $0x18,%esp
	fprintf(1, "usage: ls [-dFl] [file...]\n");
  8002d0:	c7 44 24 04 35 2c 80 	movl   $0x802c35,0x4(%esp)
  8002d7:	00 
  8002d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8002df:	e8 24 22 00 00       	call   802508 <fprintf>
	exit();
  8002e4:	e8 a3 01 00 00       	call   80048c <exit>
}
  8002e9:	c9                   	leave  
  8002ea:	c3                   	ret    

008002eb <umain>:

void
umain(int argc, char **argv)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	83 ec 28             	sub    $0x28,%esp
	int i;

	ARGBEGIN{
  8002f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8002f5:	75 06                	jne    8002fd <umain+0x12>
  8002f7:	8d 45 08             	lea    0x8(%ebp),%eax
  8002fa:	89 45 0c             	mov    %eax,0xc(%ebp)
  8002fd:	a1 44 64 80 00       	mov    0x806444,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	75 0a                	jne    800310 <umain+0x25>
  800306:	8b 45 0c             	mov    0xc(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	a3 44 64 80 00       	mov    %eax,0x806444
  800310:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
  800314:	8b 45 08             	mov    0x8(%ebp),%eax
  800317:	83 e8 01             	sub    $0x1,%eax
  80031a:	89 45 08             	mov    %eax,0x8(%ebp)
  80031d:	e9 a1 00 00 00       	jmp    8003c3 <umain+0xd8>
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	83 c0 01             	add    $0x1,%eax
  80032a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	0f b6 00             	movzbl (%eax),%eax
  800333:	3c 2d                	cmp    $0x2d,%al
  800335:	75 1f                	jne    800356 <umain+0x6b>
  800337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033a:	83 c0 01             	add    $0x1,%eax
  80033d:	0f b6 00             	movzbl (%eax),%eax
  800340:	84 c0                	test   %al,%al
  800342:	75 12                	jne    800356 <umain+0x6b>
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	83 e8 01             	sub    $0x1,%eax
  80034a:	89 45 08             	mov    %eax,0x8(%ebp)
  80034d:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
  800351:	e9 95 00 00 00       	jmp    8003eb <umain+0x100>
  800356:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
  80035a:	eb 31                	jmp    80038d <umain+0xa2>
  80035c:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800360:	83 f8 64             	cmp    $0x64,%eax
  800363:	74 0f                	je     800374 <umain+0x89>
  800365:	83 f8 6c             	cmp    $0x6c,%eax
  800368:	74 0a                	je     800374 <umain+0x89>
  80036a:	83 f8 46             	cmp    $0x46,%eax
  80036d:	74 05                	je     800374 <umain+0x89>
	default:
		usage();
  80036f:	e8 56 ff ff ff       	call   8002ca <usage>
	case 'd':
	case 'F':
	case 'l':
		flag[(uint8_t)ARGC()]++;
  800374:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  800378:	0f b6 c0             	movzbl %al,%eax
  80037b:	8b 14 85 40 60 80 00 	mov    0x806040(,%eax,4),%edx
  800382:	83 c2 01             	add    $0x1,%edx
  800385:	89 14 85 40 60 80 00 	mov    %edx,0x806040(,%eax,4)
		break;
  80038c:	90                   	nop
void
umain(int argc, char **argv)
{
	int i;

	ARGBEGIN{
  80038d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800390:	0f b6 00             	movzbl (%eax),%eax
  800393:	84 c0                	test   %al,%al
  800395:	74 18                	je     8003af <umain+0xc4>
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	0f b6 00             	movzbl (%eax),%eax
  80039d:	88 45 ef             	mov    %al,-0x11(%ebp)
  8003a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8003a4:	0f 95 c0             	setne  %al
  8003a7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8003ab:	84 c0                	test   %al,%al
  8003ad:	75 ad                	jne    80035c <umain+0x71>
	case 'd':
	case 'F':
	case 'l':
		flag[(uint8_t)ARGC()]++;
		break;
	}ARGEND
  8003af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
void
umain(int argc, char **argv)
{
	int i;

	ARGBEGIN{
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	83 e8 01             	sub    $0x1,%eax
  8003bc:	89 45 08             	mov    %eax,0x8(%ebp)
  8003bf:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
  8003c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	85 c0                	test   %eax,%eax
  8003ca:	74 1f                	je     8003eb <umain+0x100>
  8003cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cf:	8b 00                	mov    (%eax),%eax
  8003d1:	0f b6 00             	movzbl (%eax),%eax
  8003d4:	3c 2d                	cmp    $0x2d,%al
  8003d6:	75 13                	jne    8003eb <umain+0x100>
  8003d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003db:	8b 00                	mov    (%eax),%eax
  8003dd:	83 c0 01             	add    $0x1,%eax
  8003e0:	0f b6 00             	movzbl (%eax),%eax
  8003e3:	84 c0                	test   %al,%al
  8003e5:	0f 85 37 ff ff ff    	jne    800322 <umain+0x37>
	case 'l':
		flag[(uint8_t)ARGC()]++;
		break;
	}ARGEND

	if (argc == 0)
  8003eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	75 16                	jne    800408 <umain+0x11d>
		ls("/", "");
  8003f2:	c7 44 24 04 2a 2c 80 	movl   $0x802c2a,0x4(%esp)
  8003f9:	00 
  8003fa:	c7 04 24 28 2c 80 00 	movl   $0x802c28,(%esp)
  800401:	e8 2e fc ff ff       	call   800034 <ls>
  800406:	eb 37                	jmp    80043f <umain+0x154>
	else {
		for (i=0; i<argc; i++)
  800408:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80040f:	eb 26                	jmp    800437 <umain+0x14c>
			ls(argv[i], argv[i]);
  800411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800414:	c1 e0 02             	shl    $0x2,%eax
  800417:	03 45 0c             	add    0xc(%ebp),%eax
  80041a:	8b 10                	mov    (%eax),%edx
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	c1 e0 02             	shl    $0x2,%eax
  800422:	03 45 0c             	add    0xc(%ebp),%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	89 54 24 04          	mov    %edx,0x4(%esp)
  80042b:	89 04 24             	mov    %eax,(%esp)
  80042e:	e8 01 fc ff ff       	call   800034 <ls>
	}ARGEND

	if (argc == 0)
		ls("/", "");
	else {
		for (i=0; i<argc; i++)
  800433:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80043d:	7c d2                	jl     800411 <umain+0x126>
			ls(argv[i], argv[i]);
	}
}
  80043f:	c9                   	leave  
  800440:	c3                   	ret    
  800441:	00 00                	add    %al,(%eax)
	...

00800444 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	83 ec 18             	sub    $0x18,%esp
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
	//env = 0;
    env = envs + ENVX(sys_getenvid());
  80044a:	e8 53 10 00 00       	call   8014a2 <sys_getenvid>
  80044f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800454:	c1 e0 07             	shl    $0x7,%eax
  800457:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80045c:	a3 40 64 80 00       	mov    %eax,0x806440
    //cprintf("%d\n",env);
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800461:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800465:	7e 0a                	jle    800471 <libmain+0x2d>
		binaryname = argv[0];
  800467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800471:	8b 45 0c             	mov    0xc(%ebp),%eax
  800474:	89 44 24 04          	mov    %eax,0x4(%esp)
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	89 04 24             	mov    %eax,(%esp)
  80047e:	e8 68 fe ff ff       	call   8002eb <umain>

	// exit gracefully
	exit();
  800483:	e8 04 00 00 00       	call   80048c <exit>
}
  800488:	c9                   	leave  
  800489:	c3                   	ret    
	...

0080048c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800492:	e8 df 14 00 00       	call   801976 <close_all>
	sys_env_destroy(0);
  800497:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80049e:	e8 bc 0f 00 00       	call   80145f <sys_env_destroy>
}
  8004a3:	c9                   	leave  
  8004a4:	c3                   	ret    
  8004a5:	00 00                	add    %al,(%eax)
	...

008004a8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a8:	55                   	push   %ebp
  8004a9:	89 e5                	mov    %esp,%ebp
  8004ab:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  8004ae:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b1:	83 c0 04             	add    $0x4,%eax
  8004b4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	if (argv0)
  8004b7:	a1 44 64 80 00       	mov    0x806444,%eax
  8004bc:	85 c0                	test   %eax,%eax
  8004be:	74 15                	je     8004d5 <_panic+0x2d>
		cprintf("%s: ", argv0);
  8004c0:	a1 44 64 80 00       	mov    0x806444,%eax
  8004c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c9:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  8004d0:	e8 07 01 00 00       	call   8005dc <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 60 80 00       	mov    0x806000,%eax
  8004da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ec:	c7 04 24 6d 2c 80 00 	movl   $0x802c6d,(%esp)
  8004f3:	e8 e4 00 00 00       	call   8005dc <cprintf>
	vcprintf(fmt, ap);
  8004f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  800502:	89 04 24             	mov    %eax,(%esp)
  800505:	e8 6e 00 00 00       	call   800578 <vcprintf>
	cprintf("\n");
  80050a:	c7 04 24 89 2c 80 00 	movl   $0x802c89,(%esp)
  800511:	e8 c6 00 00 00       	call   8005dc <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800516:	cc                   	int3   
  800517:	eb fd                	jmp    800516 <_panic+0x6e>
  800519:	00 00                	add    %al,(%eax)
	...

0080051c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	83 ec 18             	sub    $0x18,%esp
	b->buf[b->idx++] = ch;
  800522:	8b 45 0c             	mov    0xc(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8b 55 08             	mov    0x8(%ebp),%edx
  80052a:	89 d1                	mov    %edx,%ecx
  80052c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
  800533:	8d 50 01             	lea    0x1(%eax),%edx
  800536:	8b 45 0c             	mov    0xc(%ebp),%eax
  800539:	89 10                	mov    %edx,(%eax)
	if (b->idx == 256-1) {
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	3d ff 00 00 00       	cmp    $0xff,%eax
  800545:	75 20                	jne    800567 <putch+0x4b>
		sys_cputs(b->buf, b->idx);
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	8b 00                	mov    (%eax),%eax
  80054c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054f:	83 c2 08             	add    $0x8,%edx
  800552:	89 44 24 04          	mov    %eax,0x4(%esp)
  800556:	89 14 24             	mov    %edx,(%esp)
  800559:	e8 7b 0e 00 00       	call   8013d9 <sys_cputs>
		b->idx = 0;
  80055e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056a:	8b 40 04             	mov    0x4(%eax),%eax
  80056d:	8d 50 01             	lea    0x1(%eax),%edx
  800570:	8b 45 0c             	mov    0xc(%ebp),%eax
  800573:	89 50 04             	mov    %edx,0x4(%eax)
}
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800581:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800588:	00 00 00 
	b.cnt = 0;
  80058b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800592:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ad:	c7 04 24 1c 05 80 00 	movl   $0x80051c,(%esp)
  8005b4:	e8 f7 01 00 00       	call   8007b0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005b9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8005bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c9:	83 c0 08             	add    $0x8,%eax
  8005cc:	89 04 24             	mov    %eax,(%esp)
  8005cf:	e8 05 0e 00 00       	call   8013d9 <sys_cputs>

	return b.cnt;
  8005d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005e2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005f2:	89 04 24             	mov    %eax,(%esp)
  8005f5:	e8 7e ff ff ff       	call   800578 <vcprintf>
  8005fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    
	...

00800604 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	53                   	push   %ebx
  800608:	83 ec 34             	sub    $0x34,%esp
  80060b:	8b 45 10             	mov    0x10(%ebp),%eax
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800617:	8b 45 18             	mov    0x18(%ebp),%eax
  80061a:	ba 00 00 00 00       	mov    $0x0,%edx
  80061f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800622:	77 72                	ja     800696 <printnum+0x92>
  800624:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800627:	72 05                	jb     80062e <printnum+0x2a>
  800629:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80062c:	77 68                	ja     800696 <printnum+0x92>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80062e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800631:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800634:	8b 45 18             	mov    0x18(%ebp),%eax
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800640:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800647:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064a:	89 04 24             	mov    %eax,(%esp)
  80064d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800651:	e8 ba 22 00 00       	call   802910 <__udivdi3>
  800656:	8b 4d 20             	mov    0x20(%ebp),%ecx
  800659:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  80065d:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  800661:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800664:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800668:	89 44 24 08          	mov    %eax,0x8(%esp)
  80066c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800670:	8b 45 0c             	mov    0xc(%ebp),%eax
  800673:	89 44 24 04          	mov    %eax,0x4(%esp)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	89 04 24             	mov    %eax,(%esp)
  80067d:	e8 82 ff ff ff       	call   800604 <printnum>
  800682:	eb 1c                	jmp    8006a0 <printnum+0x9c>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800684:	8b 45 0c             	mov    0xc(%ebp),%eax
  800687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068b:	8b 45 20             	mov    0x20(%ebp),%eax
  80068e:	89 04 24             	mov    %eax,(%esp)
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800696:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  80069a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80069e:	7f e4                	jg     800684 <printnum+0x80>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006b2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006b6:	89 04 24             	mov    %eax,(%esp)
  8006b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006bd:	e8 7e 23 00 00       	call   802a40 <__umoddi3>
  8006c2:	05 fc 2d 80 00       	add    $0x802dfc,%eax
  8006c7:	0f b6 00             	movzbl (%eax),%eax
  8006ca:	0f be c0             	movsbl %al,%eax
  8006cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006d4:	89 04 24             	mov    %eax,(%esp)
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	ff d0                	call   *%eax
}
  8006dc:	83 c4 34             	add    $0x34,%esp
  8006df:	5b                   	pop    %ebx
  8006e0:	5d                   	pop    %ebp
  8006e1:	c3                   	ret    

008006e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e9:	7e 1c                	jle    800707 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 08             	lea    0x8(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 08             	sub    $0x8,%eax
  800700:	8b 50 04             	mov    0x4(%eax),%edx
  800703:	8b 00                	mov    (%eax),%eax
  800705:	eb 40                	jmp    800747 <getuint+0x65>
	else if (lflag)
  800707:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070b:	74 1e                	je     80072b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	8d 50 04             	lea    0x4(%eax),%edx
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	89 10                	mov    %edx,(%eax)
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	83 e8 04             	sub    $0x4,%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	ba 00 00 00 00       	mov    $0x0,%edx
  800729:	eb 1c                	jmp    800747 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800747:	5d                   	pop    %ebp
  800748:	c3                   	ret    

00800749 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800750:	7e 1c                	jle    80076e <getint+0x25>
		return va_arg(*ap, long long);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	8d 50 08             	lea    0x8(%eax),%edx
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	89 10                	mov    %edx,(%eax)
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 e8 08             	sub    $0x8,%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	eb 40                	jmp    8007ae <getint+0x65>
	else if (lflag)
  80076e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800772:	74 1e                	je     800792 <getint+0x49>
		return va_arg(*ap, long);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8d 50 04             	lea    0x4(%eax),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	89 10                	mov    %edx,(%eax)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	83 e8 04             	sub    $0x4,%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	c1 fa 1f             	sar    $0x1f,%edx
  800790:	eb 1c                	jmp    8007ae <getint+0x65>
	else
		return va_arg(*ap, int);
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	89 10                	mov    %edx,(%eax)
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	83 e8 04             	sub    $0x4,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	89 c2                	mov    %eax,%edx
  8007ab:	c1 fa 1f             	sar    $0x1f,%edx
}
  8007ae:	5d                   	pop    %ebp
  8007af:	c3                   	ret    

008007b0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	56                   	push   %esi
  8007b4:	53                   	push   %ebx
  8007b5:	83 ec 50             	sub    $0x50,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b8:	eb 17                	jmp    8007d1 <vprintfmt+0x21>
			if (ch == '\0')
  8007ba:	85 db                	test   %ebx,%ebx
  8007bc:	0f 84 d1 05 00 00    	je     800d93 <vprintfmt+0x5e3>
				return;
			putch(ch, putdat);
  8007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c9:	89 1c 24             	mov    %ebx,(%esp)
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d4:	0f b6 00             	movzbl (%eax),%eax
  8007d7:	0f b6 d8             	movzbl %al,%ebx
  8007da:	83 fb 25             	cmp    $0x25,%ebx
  8007dd:	0f 95 c0             	setne  %al
  8007e0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8007e4:	84 c0                	test   %al,%al
  8007e6:	75 d2                	jne    8007ba <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800808:	eb 04                	jmp    80080e <vprintfmt+0x5e>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80080a:	90                   	nop
  80080b:	eb 01                	jmp    80080e <vprintfmt+0x5e>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80080d:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080e:	8b 45 10             	mov    0x10(%ebp),%eax
  800811:	0f b6 00             	movzbl (%eax),%eax
  800814:	0f b6 d8             	movzbl %al,%ebx
  800817:	89 d8                	mov    %ebx,%eax
  800819:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  80081d:	83 e8 23             	sub    $0x23,%eax
  800820:	83 f8 55             	cmp    $0x55,%eax
  800823:	0f 87 39 05 00 00    	ja     800d62 <vprintfmt+0x5b2>
  800829:	8b 04 85 44 2e 80 00 	mov    0x802e44(,%eax,4),%eax
  800830:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800832:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800836:	eb d6                	jmp    80080e <vprintfmt+0x5e>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800838:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80083c:	eb d0                	jmp    80080e <vprintfmt+0x5e>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800845:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800848:	89 d0                	mov    %edx,%eax
  80084a:	c1 e0 02             	shl    $0x2,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d8                	add    %ebx,%eax
  800853:	83 e8 30             	sub    $0x30,%eax
  800856:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	0f b6 00             	movzbl (%eax),%eax
  80085f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800862:	83 fb 2f             	cmp    $0x2f,%ebx
  800865:	7e 43                	jle    8008aa <vprintfmt+0xfa>
  800867:	83 fb 39             	cmp    $0x39,%ebx
  80086a:	7f 3e                	jg     8008aa <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80086c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800870:	eb d3                	jmp    800845 <vprintfmt+0x95>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 c0 04             	add    $0x4,%eax
  800878:	89 45 14             	mov    %eax,0x14(%ebp)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	83 e8 04             	sub    $0x4,%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800886:	eb 23                	jmp    8008ab <vprintfmt+0xfb>

		case '.':
			if (width < 0)
  800888:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088c:	0f 89 78 ff ff ff    	jns    80080a <vprintfmt+0x5a>
				width = 0;
  800892:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800899:	e9 6c ff ff ff       	jmp    80080a <vprintfmt+0x5a>

		case '#':
			altflag = 1;
  80089e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a5:	e9 64 ff ff ff       	jmp    80080e <vprintfmt+0x5e>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008aa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	0f 89 58 ff ff ff    	jns    80080d <vprintfmt+0x5d>
				width = precision, precision = -1;
  8008b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c2:	e9 46 ff ff ff       	jmp    80080d <vprintfmt+0x5d>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c7:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			goto reswitch;
  8008cb:	e9 3e ff ff ff       	jmp    80080e <vprintfmt+0x5e>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008e8:	89 04 24             	mov    %eax,(%esp)
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
			break;
  8008f0:	e9 98 04 00 00       	jmp    800d8d <vprintfmt+0x5dd>

        //Color
        case 'C'://memmove defined in inc/string.h to memcpy
        {
            char sel_c[4];
            memmove(sel_c, fmt, sizeof(unsigned char) * 3);
  8008f5:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  8008fc:	00 
  8008fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800900:	89 44 24 04          	mov    %eax,0x4(%esp)
  800904:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800907:	89 04 24             	mov    %eax,(%esp)
  80090a:	e8 d1 07 00 00       	call   8010e0 <memmove>
            sel_c[3] = '\0';
  80090f:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            fmt += 3;
  800913:	83 45 10 03          	addl   $0x3,0x10(%ebp)
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
  800917:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80091b:	3c 2f                	cmp    $0x2f,%al
  80091d:	7e 4c                	jle    80096b <vprintfmt+0x1bb>
  80091f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  800923:	3c 39                	cmp    $0x39,%al
  800925:	7f 44                	jg     80096b <vprintfmt+0x1bb>
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
  800927:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  80092b:	0f be d0             	movsbl %al,%edx
  80092e:	89 d0                	mov    %edx,%eax
  800930:	c1 e0 02             	shl    $0x2,%eax
  800933:	01 d0                	add    %edx,%eax
  800935:	01 c0                	add    %eax,%eax
  800937:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  80093d:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  800941:	0f be c0             	movsbl %al,%eax
  800944:	01 c2                	add    %eax,%edx
  800946:	89 d0                	mov    %edx,%eax
  800948:	c1 e0 02             	shl    $0x2,%eax
  80094b:	01 d0                	add    %edx,%eax
  80094d:	01 c0                	add    %eax,%eax
  80094f:	8d 90 20 fe ff ff    	lea    -0x1e0(%eax),%edx
  800955:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  800959:	0f be c0             	movsbl %al,%eax
  80095c:	01 d0                	add    %edx,%eax
  80095e:	83 e8 30             	sub    $0x30,%eax
  800961:	a3 04 60 80 00       	mov    %eax,0x806004
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800966:	e9 22 04 00 00       	jmp    800d8d <vprintfmt+0x5dd>
            sel_c[3] = '\0';
            fmt += 3;
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
  80096b:	c7 44 24 04 0d 2e 80 	movl   $0x802e0d,0x4(%esp)
  800972:	00 
  800973:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800976:	89 04 24             	mov    %eax,(%esp)
  800979:	e8 36 06 00 00       	call   800fb4 <strcmp>
  80097e:	85 c0                	test   %eax,%eax
  800980:	75 0f                	jne    800991 <vprintfmt+0x1e1>
                    ch_color = COLOR_WHT;
  800982:	c7 05 04 60 80 00 07 	movl   $0x7,0x806004
  800989:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  80098c:	e9 fc 03 00 00       	jmp    800d8d <vprintfmt+0x5dd>
            if(sel_c[0] >= '0' && sel_c[0] <= '9')
                ch_color = ((sel_c[0] - '0') * 10 + sel_c[1] - '0') * 10 + sel_c[2] - '0';
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
  800991:	c7 44 24 04 11 2e 80 	movl   $0x802e11,0x4(%esp)
  800998:	00 
  800999:	8d 45 d7             	lea    -0x29(%ebp),%eax
  80099c:	89 04 24             	mov    %eax,(%esp)
  80099f:	e8 10 06 00 00       	call   800fb4 <strcmp>
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	75 0f                	jne    8009b7 <vprintfmt+0x207>
                    ch_color = COLOR_BLK;
  8009a8:	c7 05 04 60 80 00 01 	movl   $0x1,0x806004
  8009af:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8009b2:	e9 d6 03 00 00       	jmp    800d8d <vprintfmt+0x5dd>
            else{
                if(strcmp (sel_c, "wht") == 0) 
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
  8009b7:	c7 44 24 04 15 2e 80 	movl   $0x802e15,0x4(%esp)
  8009be:	00 
  8009bf:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8009c2:	89 04 24             	mov    %eax,(%esp)
  8009c5:	e8 ea 05 00 00       	call   800fb4 <strcmp>
  8009ca:	85 c0                	test   %eax,%eax
  8009cc:	75 0f                	jne    8009dd <vprintfmt+0x22d>
                    ch_color = COLOR_GRN;
  8009ce:	c7 05 04 60 80 00 02 	movl   $0x2,0x806004
  8009d5:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8009d8:	e9 b0 03 00 00       	jmp    800d8d <vprintfmt+0x5dd>
                    ch_color = COLOR_WHT;
                else if(strcmp (sel_c, "blk") == 0) 
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
  8009dd:	c7 44 24 04 19 2e 80 	movl   $0x802e19,0x4(%esp)
  8009e4:	00 
  8009e5:	8d 45 d7             	lea    -0x29(%ebp),%eax
  8009e8:	89 04 24             	mov    %eax,(%esp)
  8009eb:	e8 c4 05 00 00       	call   800fb4 <strcmp>
  8009f0:	85 c0                	test   %eax,%eax
  8009f2:	75 0f                	jne    800a03 <vprintfmt+0x253>
                    ch_color = COLOR_RED;
  8009f4:	c7 05 04 60 80 00 04 	movl   $0x4,0x806004
  8009fb:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  8009fe:	e9 8a 03 00 00       	jmp    800d8d <vprintfmt+0x5dd>
                    ch_color = COLOR_BLK;
                else if(strcmp (sel_c, "grn") == 0) 
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
  800a03:	c7 44 24 04 1d 2e 80 	movl   $0x802e1d,0x4(%esp)
  800a0a:	00 
  800a0b:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800a0e:	89 04 24             	mov    %eax,(%esp)
  800a11:	e8 9e 05 00 00       	call   800fb4 <strcmp>
  800a16:	85 c0                	test   %eax,%eax
  800a18:	75 0f                	jne    800a29 <vprintfmt+0x279>
                    ch_color = COLOR_GRY;
  800a1a:	c7 05 04 60 80 00 08 	movl   $0x8,0x806004
  800a21:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800a24:	e9 64 03 00 00       	jmp    800d8d <vprintfmt+0x5dd>
                    ch_color = COLOR_GRN;
                else if(strcmp (sel_c, "red") == 0) 
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
  800a29:	c7 44 24 04 21 2e 80 	movl   $0x802e21,0x4(%esp)
  800a30:	00 
  800a31:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800a34:	89 04 24             	mov    %eax,(%esp)
  800a37:	e8 78 05 00 00       	call   800fb4 <strcmp>
  800a3c:	85 c0                	test   %eax,%eax
  800a3e:	75 0f                	jne    800a4f <vprintfmt+0x29f>
                    ch_color = COLOR_YLW;
  800a40:	c7 05 04 60 80 00 0f 	movl   $0xf,0x806004
  800a47:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800a4a:	e9 3e 03 00 00       	jmp    800d8d <vprintfmt+0x5dd>
                    ch_color = COLOR_RED;
                else if(strcmp (sel_c, "gry") == 0) 
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
  800a4f:	c7 44 24 04 25 2e 80 	movl   $0x802e25,0x4(%esp)
  800a56:	00 
  800a57:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800a5a:	89 04 24             	mov    %eax,(%esp)
  800a5d:	e8 52 05 00 00       	call   800fb4 <strcmp>
  800a62:	85 c0                	test   %eax,%eax
  800a64:	75 0f                	jne    800a75 <vprintfmt+0x2c5>
                    ch_color = COLOR_ORG;
  800a66:	c7 05 04 60 80 00 0c 	movl   $0xc,0x806004
  800a6d:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800a70:	e9 18 03 00 00       	jmp    800d8d <vprintfmt+0x5dd>
                    ch_color = COLOR_GRY;
                else if(strcmp (sel_c, "ylw") == 0) 
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
  800a75:	c7 44 24 04 29 2e 80 	movl   $0x802e29,0x4(%esp)
  800a7c:	00 
  800a7d:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800a80:	89 04 24             	mov    %eax,(%esp)
  800a83:	e8 2c 05 00 00       	call   800fb4 <strcmp>
  800a88:	85 c0                	test   %eax,%eax
  800a8a:	75 0f                	jne    800a9b <vprintfmt+0x2eb>
                    ch_color = COLOR_PUR;
  800a8c:	c7 05 04 60 80 00 06 	movl   $0x6,0x806004
  800a93:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800a96:	e9 f2 02 00 00       	jmp    800d8d <vprintfmt+0x5dd>
                    ch_color = COLOR_YLW;
                else if(strcmp (sel_c, "org") == 0) 
                    ch_color = COLOR_ORG;
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
  800a9b:	c7 44 24 04 2d 2e 80 	movl   $0x802e2d,0x4(%esp)
  800aa2:	00 
  800aa3:	8d 45 d7             	lea    -0x29(%ebp),%eax
  800aa6:	89 04 24             	mov    %eax,(%esp)
  800aa9:	e8 06 05 00 00       	call   800fb4 <strcmp>
  800aae:	85 c0                	test   %eax,%eax
  800ab0:	75 0f                	jne    800ac1 <vprintfmt+0x311>
                    ch_color = COLOR_CYN;
  800ab2:	c7 05 04 60 80 00 0b 	movl   $0xb,0x806004
  800ab9:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800abc:	e9 cc 02 00 00       	jmp    800d8d <vprintfmt+0x5dd>
                else if(strcmp (sel_c, "pur") == 0) 
                    ch_color = COLOR_PUR;
                else if(strcmp (sel_c, "cyn") == 0) 
                    ch_color = COLOR_CYN;
                else 
                    ch_color = COLOR_WHT;
  800ac1:	c7 05 04 60 80 00 07 	movl   $0x7,0x806004
  800ac8:	00 00 00 
            //BackWord(ch_color);
            //cprintf("%x %x\n",BackColor&0xf0ff, ch_color);
            //BackColor = (BackColor&0xf0ff)|(ch_color << 8);//((BackColor & 0xF0FF) | (ch_color << 8));
            //cprintf("%x\n",BackColor);
        }
        break;
  800acb:	e9 bd 02 00 00       	jmp    800d8d <vprintfmt+0x5dd>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 c0 04             	add    $0x4,%eax
  800ad6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	83 e8 04             	sub    $0x4,%eax
  800adf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ae1:	85 db                	test   %ebx,%ebx
  800ae3:	79 02                	jns    800ae7 <vprintfmt+0x337>
				err = -err;
  800ae5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ae7:	83 fb 0e             	cmp    $0xe,%ebx
  800aea:	7f 0b                	jg     800af7 <vprintfmt+0x347>
  800aec:	8b 34 9d c0 2d 80 00 	mov    0x802dc0(,%ebx,4),%esi
  800af3:	85 f6                	test   %esi,%esi
  800af5:	75 23                	jne    800b1a <vprintfmt+0x36a>
				printfmt(putch, putdat, "error %d", err);
  800af7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800afb:	c7 44 24 08 31 2e 80 	movl   $0x802e31,0x8(%esp)
  800b02:	00 
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	89 04 24             	mov    %eax,(%esp)
  800b10:	e8 86 02 00 00       	call   800d9b <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b15:	e9 73 02 00 00       	jmp    800d8d <vprintfmt+0x5dd>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b1a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b1e:	c7 44 24 08 3a 2e 80 	movl   $0x802e3a,0x8(%esp)
  800b25:	00 
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	89 04 24             	mov    %eax,(%esp)
  800b33:	e8 63 02 00 00       	call   800d9b <printfmt>
			break;
  800b38:	e9 50 02 00 00       	jmp    800d8d <vprintfmt+0x5dd>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	83 c0 04             	add    $0x4,%eax
  800b43:	89 45 14             	mov    %eax,0x14(%ebp)
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 30                	mov    (%eax),%esi
  800b4e:	85 f6                	test   %esi,%esi
  800b50:	75 05                	jne    800b57 <vprintfmt+0x3a7>
				p = "(null)";
  800b52:	be 3d 2e 80 00       	mov    $0x802e3d,%esi
			if (width > 0 && padc != '-')
  800b57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5b:	7e 73                	jle    800bd0 <vprintfmt+0x420>
  800b5d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b61:	74 6d                	je     800bd0 <vprintfmt+0x420>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b6a:	89 34 24             	mov    %esi,(%esp)
  800b6d:	e8 4c 03 00 00       	call   800ebe <strnlen>
  800b72:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b75:	eb 17                	jmp    800b8e <vprintfmt+0x3de>
					putch(padc, putdat);
  800b77:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b82:	89 04 24             	mov    %eax,(%esp)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800b8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b92:	7f e3                	jg     800b77 <vprintfmt+0x3c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b94:	eb 3a                	jmp    800bd0 <vprintfmt+0x420>
				if (altflag && (ch < ' ' || ch > '~'))
  800b96:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b9a:	74 1f                	je     800bbb <vprintfmt+0x40b>
  800b9c:	83 fb 1f             	cmp    $0x1f,%ebx
  800b9f:	7e 05                	jle    800ba6 <vprintfmt+0x3f6>
  800ba1:	83 fb 7e             	cmp    $0x7e,%ebx
  800ba4:	7e 15                	jle    800bbb <vprintfmt+0x40b>
					putch('?', putdat);
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bad:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	ff d0                	call   *%eax
  800bb9:	eb 0f                	jmp    800bca <vprintfmt+0x41a>
				else
					putch(ch, putdat);
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc2:	89 1c 24             	mov    %ebx,(%esp)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bca:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800bce:	eb 01                	jmp    800bd1 <vprintfmt+0x421>
  800bd0:	90                   	nop
  800bd1:	0f b6 06             	movzbl (%esi),%eax
  800bd4:	0f be d8             	movsbl %al,%ebx
  800bd7:	85 db                	test   %ebx,%ebx
  800bd9:	0f 95 c0             	setne  %al
  800bdc:	83 c6 01             	add    $0x1,%esi
  800bdf:	84 c0                	test   %al,%al
  800be1:	74 29                	je     800c0c <vprintfmt+0x45c>
  800be3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be7:	78 ad                	js     800b96 <vprintfmt+0x3e6>
  800be9:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800bed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf1:	79 a3                	jns    800b96 <vprintfmt+0x3e6>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf3:	eb 17                	jmp    800c0c <vprintfmt+0x45c>
				putch(' ', putdat);
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bfc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c08:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	7f e3                	jg     800bf5 <vprintfmt+0x445>
				putch(' ', putdat);
			break;
  800c12:	e9 76 01 00 00       	jmp    800d8d <vprintfmt+0x5dd>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c1e:	8d 45 14             	lea    0x14(%ebp),%eax
  800c21:	89 04 24             	mov    %eax,(%esp)
  800c24:	e8 20 fb ff ff       	call   800749 <getint>
  800c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c35:	85 d2                	test   %edx,%edx
  800c37:	79 26                	jns    800c5f <vprintfmt+0x4af>
				putch('-', putdat);
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c40:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
				num = -(long long) num;
  800c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c52:	f7 d8                	neg    %eax
  800c54:	83 d2 00             	adc    $0x0,%edx
  800c57:	f7 da                	neg    %edx
  800c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c5f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c66:	e9 ae 00 00 00       	jmp    800d19 <vprintfmt+0x569>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c72:	8d 45 14             	lea    0x14(%ebp),%eax
  800c75:	89 04 24             	mov    %eax,(%esp)
  800c78:	e8 65 fa ff ff       	call   8006e2 <getuint>
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c83:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c8a:	e9 8a 00 00 00       	jmp    800d19 <vprintfmt+0x569>
		case 'o':
			// Replace this with your code.
			//putch('X', putdat);
			//putch('X', putdat);
			//putch('X', putdat);
			num = getuint(&ap, lflag);
  800c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c92:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c96:	8d 45 14             	lea    0x14(%ebp),%eax
  800c99:	89 04 24             	mov    %eax,(%esp)
  800c9c:	e8 41 fa ff ff       	call   8006e2 <getuint>
  800ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 8;
  800ca7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
			goto number;
  800cae:	eb 69                	jmp    800d19 <vprintfmt+0x569>
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cb7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	ff d0                	call   *%eax
			putch('x', putdat);
  800cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cca:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 c0 04             	add    $0x4,%eax
  800cdc:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 e8 04             	sub    $0x4,%eax
  800ce5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800cf1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cf8:	eb 1f                	jmp    800d19 <vprintfmt+0x569>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d01:	8d 45 14             	lea    0x14(%ebp),%eax
  800d04:	89 04 24             	mov    %eax,(%esp)
  800d07:	e8 d6 f9 ff ff       	call   8006e2 <getuint>
  800d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d12:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d19:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d20:	89 54 24 18          	mov    %edx,0x18(%esp)
  800d24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d27:	89 54 24 14          	mov    %edx,0x14(%esp)
  800d2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d39:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	89 04 24             	mov    %eax,(%esp)
  800d4a:	e8 b5 f8 ff ff       	call   800604 <printnum>
			break;
  800d4f:	eb 3c                	jmp    800d8d <vprintfmt+0x5dd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d58:	89 1c 24             	mov    %ebx,(%esp)
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	ff d0                	call   *%eax
			break;
  800d60:	eb 2b                	jmp    800d8d <vprintfmt+0x5dd>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d69:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d75:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d79:	eb 04                	jmp    800d7f <vprintfmt+0x5cf>
  800d7b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	83 e8 01             	sub    $0x1,%eax
  800d85:	0f b6 00             	movzbl (%eax),%eax
  800d88:	3c 25                	cmp    $0x25,%al
  800d8a:	75 ef                	jne    800d7b <vprintfmt+0x5cb>
				/* do nothing */;
			break;
  800d8c:	90                   	nop
		}
	}
  800d8d:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d8e:	e9 3e fa ff ff       	jmp    8007d1 <vprintfmt+0x21>
			if (ch == '\0')
				return;
  800d93:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d94:	83 c4 50             	add    $0x50,%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 28             	sub    $0x28,%esp
	va_list ap;

	va_start(ap, fmt);
  800da1:	8d 45 10             	lea    0x10(%ebp),%eax
  800da4:	83 c0 04             	add    $0x4,%eax
  800da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800daa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800db4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	89 04 24             	mov    %eax,(%esp)
  800dc5:	e8 e6 f9 ff ff       	call   8007b0 <vprintfmt>
	va_end(ap);
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8b 40 08             	mov    0x8(%eax),%eax
  800dd5:	8d 50 01             	lea    0x1(%eax),%edx
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	8b 10                	mov    (%eax),%edx
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	8b 40 04             	mov    0x4(%eax),%eax
  800de9:	39 c2                	cmp    %eax,%edx
  800deb:	73 12                	jae    800dff <sprintputch+0x33>
		*b->buf++ = ch;
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	88 10                	mov    %dl,(%eax)
  800df7:	8d 50 01             	lea    0x1(%eax),%edx
  800dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfd:	89 10                	mov    %edx,(%eax)
}
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 28             	sub    $0x28,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	83 e8 01             	sub    $0x1,%eax
  800e13:	03 45 08             	add    0x8(%ebp),%eax
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e24:	74 06                	je     800e2c <vsnprintf+0x2b>
  800e26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e2a:	7f 07                	jg     800e33 <vsnprintf+0x32>
		return -E_INVAL;
  800e2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e31:	eb 2a                	jmp    800e5d <vsnprintf+0x5c>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e33:	8b 45 14             	mov    0x14(%ebp),%eax
  800e36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e41:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e48:	c7 04 24 cc 0d 80 00 	movl   $0x800dcc,(%esp)
  800e4f:	e8 5c f9 ff ff       	call   8007b0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e57:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e65:	8d 45 10             	lea    0x10(%ebp),%eax
  800e68:	83 c0 04             	add    $0x4,%eax
  800e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e74:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e78:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 04 24             	mov    %eax,(%esp)
  800e89:	e8 73 ff ff ff       	call   800e01 <vsnprintf>
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    
	...

00800e98 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea5:	eb 08                	jmp    800eaf <strlen+0x17>
		n++;
  800ea7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	0f b6 00             	movzbl (%eax),%eax
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 ee                	jne    800ea7 <strlen+0xf>
		n++;
	return n;
  800eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ecb:	eb 0c                	jmp    800ed9 <strnlen+0x1b>
		n++;
  800ecd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ed5:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800ed9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800edd:	74 0a                	je     800ee9 <strnlen+0x2b>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	0f b6 00             	movzbl (%eax),%eax
  800ee5:	84 c0                	test   %al,%al
  800ee7:	75 e4                	jne    800ecd <strnlen+0xf>
		n++;
	return n;
  800ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800efa:	90                   	nop
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 10             	movzbl (%eax),%edx
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	88 10                	mov    %dl,(%eax)
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	0f b6 00             	movzbl (%eax),%eax
  800f0c:	84 c0                	test   %al,%al
  800f0e:	0f 95 c0             	setne  %al
  800f11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f15:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  800f19:	84 c0                	test   %al,%al
  800f1b:	75 de                	jne    800efb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f20:	c9                   	leave  
  800f21:	c3                   	ret    

00800f22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f35:	eb 21                	jmp    800f58 <strncpy+0x36>
		*dst++ = *src;
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	0f b6 10             	movzbl (%eax),%edx
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	88 10                	mov    %dl,(%eax)
  800f42:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	0f b6 00             	movzbl (%eax),%eax
  800f4c:	84 c0                	test   %al,%al
  800f4e:	74 04                	je     800f54 <strncpy+0x32>
			src++;
  800f50:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f54:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f5e:	72 d7                	jb     800f37 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 2f                	je     800fa6 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  800f77:	eb 13                	jmp    800f8c <strlcpy+0x27>
			*dst++ = *src++;
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	0f b6 10             	movzbl (%eax),%edx
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	88 10                	mov    %dl,(%eax)
  800f84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f88:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f8c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	74 0a                	je     800fa0 <strlcpy+0x3b>
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	0f b6 00             	movzbl (%eax),%eax
  800f9c:	84 c0                	test   %al,%al
  800f9e:	75 d9                	jne    800f79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fac:	89 d1                	mov    %edx,%ecx
  800fae:	29 c1                	sub    %eax,%ecx
  800fb0:	89 c8                	mov    %ecx,%eax
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fb7:	eb 08                	jmp    800fc1 <strcmp+0xd>
		p++, q++;
  800fb9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fbd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	0f b6 00             	movzbl (%eax),%eax
  800fc7:	84 c0                	test   %al,%al
  800fc9:	74 10                	je     800fdb <strcmp+0x27>
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	0f b6 10             	movzbl (%eax),%edx
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	0f b6 00             	movzbl (%eax),%eax
  800fd7:	38 c2                	cmp    %al,%dl
  800fd9:	74 de                	je     800fb9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	0f b6 00             	movzbl (%eax),%eax
  800fe1:	0f b6 d0             	movzbl %al,%edx
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	0f b6 00             	movzbl (%eax),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	89 d1                	mov    %edx,%ecx
  800fef:	29 c1                	sub    %eax,%ecx
  800ff1:	89 c8                	mov    %ecx,%eax
}
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ff8:	eb 0c                	jmp    801006 <strncmp+0x11>
		n--, p++, q++;
  800ffa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800ffe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801002:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801006:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100a:	74 1a                	je     801026 <strncmp+0x31>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	0f b6 00             	movzbl (%eax),%eax
  801012:	84 c0                	test   %al,%al
  801014:	74 10                	je     801026 <strncmp+0x31>
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	0f b6 10             	movzbl (%eax),%edx
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	0f b6 00             	movzbl (%eax),%eax
  801022:	38 c2                	cmp    %al,%dl
  801024:	74 d4                	je     800ffa <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801026:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102a:	75 07                	jne    801033 <strncmp+0x3e>
		return 0;
  80102c:	b8 00 00 00 00       	mov    $0x0,%eax
  801031:	eb 18                	jmp    80104b <strncmp+0x56>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	0f b6 00             	movzbl (%eax),%eax
  801039:	0f b6 d0             	movzbl %al,%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	0f b6 00             	movzbl (%eax),%eax
  801042:	0f b6 c0             	movzbl %al,%eax
  801045:	89 d1                	mov    %edx,%ecx
  801047:	29 c1                	sub    %eax,%ecx
  801049:	89 c8                	mov    %ecx,%eax
}
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 04             	sub    $0x4,%esp
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801059:	eb 14                	jmp    80106f <strchr+0x22>
		if (*s == c)
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	0f b6 00             	movzbl (%eax),%eax
  801061:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801064:	75 05                	jne    80106b <strchr+0x1e>
			return (char *) s;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	eb 13                	jmp    80107e <strchr+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80106b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	0f b6 00             	movzbl (%eax),%eax
  801075:	84 c0                	test   %al,%al
  801077:	75 e2                	jne    80105b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801079:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80108c:	eb 0f                	jmp    80109d <strfind+0x1d>
		if (*s == c)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	0f b6 00             	movzbl (%eax),%eax
  801094:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801097:	74 10                	je     8010a9 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801099:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	0f b6 00             	movzbl (%eax),%eax
  8010a3:	84 c0                	test   %al,%al
  8010a5:	75 e7                	jne    80108e <strfind+0xe>
  8010a7:	eb 01                	jmp    8010aa <strfind+0x2a>
		if (*s == c)
			break;
  8010a9:	90                   	nop
	return (char *) s;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <memset>:


void *
memset(void *v, int c, size_t n)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010c1:	eb 0e                	jmp    8010d1 <memset+0x22>
		*p++ = c;
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	89 c2                	mov    %eax,%edx
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	88 10                	mov    %dl,(%eax)
  8010cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010d1:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  8010d5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010d9:	79 e8                	jns    8010c3 <memset+0x14>
		*p++ = c;

	return v;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <memmove>:

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;
	
	s = src;
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f8:	73 54                	jae    80114e <memmove+0x6e>
  8010fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801100:	01 d0                	add    %edx,%eax
  801102:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801105:	76 47                	jbe    80114e <memmove+0x6e>
		s += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801113:	eb 13                	jmp    801128 <memmove+0x48>
			*--d = *--s;
  801115:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  801119:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  80111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801120:	0f b6 10             	movzbl (%eax),%edx
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801126:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801128:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112c:	0f 95 c0             	setne  %al
  80112f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  801133:	84 c0                	test   %al,%al
  801135:	75 de                	jne    801115 <memmove+0x35>
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801137:	eb 25                	jmp    80115e <memmove+0x7e>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801139:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113c:	0f b6 10             	movzbl (%eax),%edx
  80113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801142:	88 10                	mov    %dl,(%eax)
  801144:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  801148:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  80114c:	eb 01                	jmp    80114f <memmove+0x6f>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80114e:	90                   	nop
  80114f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801153:	0f 95 c0             	setne  %al
  801156:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80115a:	84 c0                	test   %al,%al
  80115c:	75 db                	jne    801139 <memmove+0x59>
			*d++ = *s++;

	return dst;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	89 44 24 04          	mov    %eax,0x4(%esp)
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	89 04 24             	mov    %eax,(%esp)
  80117d:	e8 5e ff ff ff       	call   8010e0 <memmove>
}
  801182:	c9                   	leave  
  801183:	c3                   	ret    

00801184 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801196:	eb 32                	jmp    8011ca <memcmp+0x46>
		if (*s1 != *s2)
  801198:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119b:	0f b6 10             	movzbl (%eax),%edx
  80119e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a1:	0f b6 00             	movzbl (%eax),%eax
  8011a4:	38 c2                	cmp    %al,%dl
  8011a6:	74 1a                	je     8011c2 <memcmp+0x3e>
			return (int) *s1 - (int) *s2;
  8011a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ab:	0f b6 00             	movzbl (%eax),%eax
  8011ae:	0f b6 d0             	movzbl %al,%edx
  8011b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b4:	0f b6 00             	movzbl (%eax),%eax
  8011b7:	0f b6 c0             	movzbl %al,%eax
  8011ba:	89 d1                	mov    %edx,%ecx
  8011bc:	29 c1                	sub    %eax,%ecx
  8011be:	89 c8                	mov    %ecx,%eax
  8011c0:	eb 1c                	jmp    8011de <memcmp+0x5a>
		s1++, s2++;
  8011c2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8011c6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8011ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ce:	0f 95 c0             	setne  %al
  8011d1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8011d5:	84 c0                	test   %al,%al
  8011d7:	75 bf                	jne    801198 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ec:	01 d0                	add    %edx,%eax
  8011ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011f1:	eb 11                	jmp    801204 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	0f b6 10             	movzbl (%eax),%edx
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	38 c2                	cmp    %al,%dl
  8011fe:	74 0e                	je     80120e <memfind+0x2e>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801200:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80120a:	72 e7                	jb     8011f3 <memfind+0x13>
  80120c:	eb 01                	jmp    80120f <memfind+0x2f>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80120e:	90                   	nop
	return (void *) s;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801221:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801228:	eb 04                	jmp    80122e <strtol+0x1a>
		s++;
  80122a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	0f b6 00             	movzbl (%eax),%eax
  801234:	3c 20                	cmp    $0x20,%al
  801236:	74 f2                	je     80122a <strtol+0x16>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	0f b6 00             	movzbl (%eax),%eax
  80123e:	3c 09                	cmp    $0x9,%al
  801240:	74 e8                	je     80122a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	0f b6 00             	movzbl (%eax),%eax
  801248:	3c 2b                	cmp    $0x2b,%al
  80124a:	75 06                	jne    801252 <strtol+0x3e>
		s++;
  80124c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801250:	eb 15                	jmp    801267 <strtol+0x53>
	else if (*s == '-')
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	0f b6 00             	movzbl (%eax),%eax
  801258:	3c 2d                	cmp    $0x2d,%al
  80125a:	75 0b                	jne    801267 <strtol+0x53>
		s++, neg = 1;
  80125c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801260:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801267:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126b:	74 06                	je     801273 <strtol+0x5f>
  80126d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801271:	75 24                	jne    801297 <strtol+0x83>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	0f b6 00             	movzbl (%eax),%eax
  801279:	3c 30                	cmp    $0x30,%al
  80127b:	75 1a                	jne    801297 <strtol+0x83>
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	83 c0 01             	add    $0x1,%eax
  801283:	0f b6 00             	movzbl (%eax),%eax
  801286:	3c 78                	cmp    $0x78,%al
  801288:	75 0d                	jne    801297 <strtol+0x83>
		s += 2, base = 16;
  80128a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80128e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801295:	eb 2a                	jmp    8012c1 <strtol+0xad>
	else if (base == 0 && s[0] == '0')
  801297:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80129b:	75 17                	jne    8012b4 <strtol+0xa0>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	0f b6 00             	movzbl (%eax),%eax
  8012a3:	3c 30                	cmp    $0x30,%al
  8012a5:	75 0d                	jne    8012b4 <strtol+0xa0>
		s++, base = 8;
  8012a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8012ab:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012b2:	eb 0d                	jmp    8012c1 <strtol+0xad>
	else if (base == 0)
  8012b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b8:	75 07                	jne    8012c1 <strtol+0xad>
		base = 10;
  8012ba:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	0f b6 00             	movzbl (%eax),%eax
  8012c7:	3c 2f                	cmp    $0x2f,%al
  8012c9:	7e 1b                	jle    8012e6 <strtol+0xd2>
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	0f b6 00             	movzbl (%eax),%eax
  8012d1:	3c 39                	cmp    $0x39,%al
  8012d3:	7f 11                	jg     8012e6 <strtol+0xd2>
			dig = *s - '0';
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	0f b6 00             	movzbl (%eax),%eax
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 30             	sub    $0x30,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e4:	eb 48                	jmp    80132e <strtol+0x11a>
		else if (*s >= 'a' && *s <= 'z')
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	0f b6 00             	movzbl (%eax),%eax
  8012ec:	3c 60                	cmp    $0x60,%al
  8012ee:	7e 1b                	jle    80130b <strtol+0xf7>
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	0f b6 00             	movzbl (%eax),%eax
  8012f6:	3c 7a                	cmp    $0x7a,%al
  8012f8:	7f 11                	jg     80130b <strtol+0xf7>
			dig = *s - 'a' + 10;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	0f b6 00             	movzbl (%eax),%eax
  801300:	0f be c0             	movsbl %al,%eax
  801303:	83 e8 57             	sub    $0x57,%eax
  801306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801309:	eb 23                	jmp    80132e <strtol+0x11a>
		else if (*s >= 'A' && *s <= 'Z')
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	0f b6 00             	movzbl (%eax),%eax
  801311:	3c 40                	cmp    $0x40,%al
  801313:	7e 38                	jle    80134d <strtol+0x139>
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	0f b6 00             	movzbl (%eax),%eax
  80131b:	3c 5a                	cmp    $0x5a,%al
  80131d:	7f 2e                	jg     80134d <strtol+0x139>
			dig = *s - 'A' + 10;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	0f b6 00             	movzbl (%eax),%eax
  801325:	0f be c0             	movsbl %al,%eax
  801328:	83 e8 37             	sub    $0x37,%eax
  80132b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80132e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801331:	3b 45 10             	cmp    0x10(%ebp),%eax
  801334:	7d 16                	jge    80134c <strtol+0x138>
			break;
		s++, val = (val * base) + dig;
  801336:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80133a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801341:	03 45 f4             	add    -0xc(%ebp),%eax
  801344:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801347:	e9 75 ff ff ff       	jmp    8012c1 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80134c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80134d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801351:	74 08                	je     80135b <strtol+0x147>
		*endptr = (char *) s;
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8b 55 08             	mov    0x8(%ebp),%edx
  801359:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80135b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80135f:	74 07                	je     801368 <strtol+0x154>
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	f7 d8                	neg    %eax
  801366:	eb 03                	jmp    80136b <strtol+0x157>
  801368:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    
  80136d:	00 00                	add    %al,(%eax)
	...

00801370 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	57                   	push   %edi
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	83 ec 4c             	sub    $0x4c,%esp
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80137f:	8b 55 10             	mov    0x10(%ebp),%edx
  801382:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801385:	8b 5d 18             	mov    0x18(%ebp),%ebx
  801388:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  80138b:	8b 75 20             	mov    0x20(%ebp),%esi
  80138e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801391:	cd 30                	int    $0x30
  801393:	89 c3                	mov    %eax,%ebx
  801395:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 30                	je     8013ce <syscall+0x5e>
  80139e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013a2:	7e 2a                	jle    8013ce <syscall+0x5e>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b2:	c7 44 24 08 9c 2f 80 	movl   $0x802f9c,0x8(%esp)
  8013b9:	00 
  8013ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013c1:	00 
  8013c2:	c7 04 24 b9 2f 80 00 	movl   $0x802fb9,(%esp)
  8013c9:	e8 da f0 ff ff       	call   8004a8 <_panic>

	return ret;
  8013ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8013d1:	83 c4 4c             	add    $0x4c,%esp
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5f                   	pop    %edi
  8013d7:	5d                   	pop    %ebp
  8013d8:	c3                   	ret    

008013d9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8013e9:	00 
  8013ea:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013f1:	00 
  8013f2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8013f9:	00 
  8013fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801401:	89 44 24 08          	mov    %eax,0x8(%esp)
  801405:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80140c:	00 
  80140d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801414:	e8 57 ff ff ff       	call   801370 <syscall>
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_cgetc>:

int
sys_cgetc(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801421:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801428:	00 
  801429:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801430:	00 
  801431:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801438:	00 
  801439:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801440:	00 
  801441:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801448:	00 
  801449:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801450:	00 
  801451:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801458:	e8 13 ff ff ff       	call   801370 <syscall>
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  801494:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80149b:	e8 d0 fe ff ff       	call   801370 <syscall>
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 28             	sub    $0x28,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8014a8:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8014af:	00 
  8014b0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8014b7:	00 
  8014b8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8014bf:	00 
  8014c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8014c7:	00 
  8014c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014cf:	00 
  8014d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014d7:	00 
  8014d8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8014df:	e8 8c fe ff ff       	call   801370 <syscall>
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_yield>:

void
sys_yield(void)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 28             	sub    $0x28,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8014ec:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8014f3:	00 
  8014f4:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8014fb:	00 
  8014fc:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801503:	00 
  801504:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80150b:	00 
  80150c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801513:	00 
  801514:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80151b:	00 
  80151c:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  801523:	e8 48 fe ff ff       	call   801370 <syscall>
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801530:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801533:	8b 55 0c             	mov    0xc(%ebp),%edx
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801540:	00 
  801541:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801548:	00 
  801549:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80154d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801551:	89 44 24 08          	mov    %eax,0x8(%esp)
  801555:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80155c:	00 
  80155d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  801564:	e8 07 fe ff ff       	call   801370 <syscall>
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	56                   	push   %esi
  80156f:	53                   	push   %ebx
  801570:	83 ec 20             	sub    $0x20,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  801573:	8b 75 18             	mov    0x18(%ebp),%esi
  801576:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801579:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80157c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	89 74 24 18          	mov    %esi,0x18(%esp)
  801586:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  80158a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80158e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801592:	89 44 24 08          	mov    %eax,0x8(%esp)
  801596:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80159d:	00 
  80159e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  8015a5:	e8 c6 fd ff ff       	call   801370 <syscall>
}
  8015aa:	83 c4 20             	add    $0x20,%esp
  8015ad:	5b                   	pop    %ebx
  8015ae:	5e                   	pop    %esi
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    

008015b1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8015b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8015c4:	00 
  8015c5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8015cc:	00 
  8015cd:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8015d4:	00 
  8015d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015e4:	00 
  8015e5:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  8015ec:	e8 7f fd ff ff       	call   801370 <syscall>
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_env_set_priority>:

// sys_exofork is inlined in lib.h

int 
sys_env_set_priority(envid_t envid, int priority)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
  8015f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801606:	00 
  801607:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80160e:	00 
  80160f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801616:	00 
  801617:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80161b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80161f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801626:	00 
  801627:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  80162e:	e8 3d fd ff ff       	call   801370 <syscall>
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_env_set_status>:

int
sys_env_set_status(envid_t envid, int status)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80163b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801648:	00 
  801649:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801650:	00 
  801651:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  801658:	00 
  801659:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80165d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801661:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801668:	00 
  801669:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  801670:	e8 fb fc ff ff       	call   801370 <syscall>
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80168a:	00 
  80168b:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801692:	00 
  801693:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80169a:	00 
  80169b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80169f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016aa:	00 
  8016ab:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
  8016b2:	e8 b9 fc ff ff       	call   801370 <syscall>
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8016bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  8016cc:	00 
  8016cd:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8016d4:	00 
  8016d5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8016dc:	00 
  8016dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016ec:	00 
  8016ed:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  8016f4:	e8 77 fc ff ff       	call   801370 <syscall>
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  801701:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801704:	8b 55 10             	mov    0x10(%ebp),%edx
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  801711:	00 
  801712:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  801716:	89 54 24 10          	mov    %edx,0x10(%esp)
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801721:	89 44 24 08          	mov    %eax,0x8(%esp)
  801725:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80172c:	00 
  80172d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  801734:	e8 37 fc ff ff       	call   801370 <syscall>
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 28             	sub    $0x28,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  80174b:	00 
  80174c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  801753:	00 
  801754:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  80175b:	00 
  80175c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801763:	00 
  801764:	89 44 24 08          	mov    %eax,0x8(%esp)
  801768:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80176f:	00 
  801770:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
  801777:	e8 f4 fb ff ff       	call   801370 <syscall>
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    
	...

00801780 <fd2data>:
 *                              *
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 18             	sub    $0x18,%esp
	return INDEX2DATA(fd2num(fd));
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	89 04 24             	mov    %eax,(%esp)
  80178c:	e8 0a 00 00 00       	call   80179b <fd2num>
  801791:	05 40 03 00 00       	add    $0x340,%eax
  801796:	c1 e0 16             	shl    $0x16,%eax
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <fd2num>:

int
fd2num(struct Fd *fd)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	05 00 00 40 30       	add    $0x30400000,%eax
  8017a6:	c1 e8 0c             	shr    $0xc,%eax
}
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    

008017ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  8017b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b8:	eb 49                	jmp    801803 <fd_alloc+0x58>
		*fd_store = INDEX2FD(i);
  8017ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017bd:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  8017c2:	c1 e0 0c             	shl    $0xc,%eax
  8017c5:	89 c2                	mov    %eax,%edx
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	89 10                	mov    %edx,(%eax)
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	8b 00                	mov    (%eax),%eax
  8017d1:	c1 e8 16             	shr    $0x16,%eax
  8017d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017db:	83 e0 01             	and    $0x1,%eax
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	74 16                	je     8017f8 <fd_alloc+0x4d>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8b 00                	mov    (%eax),%eax
  8017e7:	c1 e8 0c             	shr    $0xc,%eax
  8017ea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017f1:	83 e0 01             	and    $0x1,%eax
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	75 07                	jne    8017ff <fd_alloc+0x54>
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fd:	eb 18                	jmp    801817 <fd_alloc+0x6c>
int
fd_alloc(struct Fd **fd_store)
{
	// LAB 5: Your code here.
	int i;
	for(i=0;i<MAXFD;i++){
  8017ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801803:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  801807:	7e b1                	jle    8017ba <fd_alloc+0xf>
		*fd_store = INDEX2FD(i);
		if((vpt[PDX(*fd_store)] & PTE_P) == 0||
		     (vpt[VPN(*fd_store)] & PTE_P) == 0){
				 return 0;}
		}
	*fd_store = 0;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	//panic("fd_alloc not implemented");
	return -E_MAX_OPEN;
  801812:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 18             	sub    $0x18,%esp
	// LAB 5: Your code here.

	panic("fd_lookup not implemented");
  80181f:	c7 44 24 08 c8 2f 80 	movl   $0x802fc8,0x8(%esp)
  801826:	00 
  801827:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80182e:	00 
  80182f:	c7 04 24 e2 2f 80 00 	movl   $0x802fe2,(%esp)
  801836:	e8 6d ec ff ff       	call   8004a8 <_panic>

0080183b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 04 24             	mov    %eax,(%esp)
  801847:	e8 4f ff ff ff       	call   80179b <fd2num>
  80184c:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80184f:	89 54 24 04          	mov    %edx,0x4(%esp)
  801853:	89 04 24             	mov    %eax,(%esp)
  801856:	e8 be ff ff ff       	call   801819 <fd_lookup>
  80185b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801862:	78 08                	js     80186c <fd_close+0x31>
	    || fd != fd2)
  801864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801867:	39 45 08             	cmp    %eax,0x8(%ebp)
  80186a:	74 12                	je     80187e <fd_close+0x43>
		return (must_exist ? r : 0);
  80186c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801870:	74 05                	je     801877 <fd_close+0x3c>
  801872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801875:	eb 05                	jmp    80187c <fd_close+0x41>
  801877:	b8 00 00 00 00       	mov    $0x0,%eax
  80187c:	eb 44                	jmp    8018c2 <fd_close+0x87>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	8b 00                	mov    (%eax),%eax
  801883:	8d 55 ec             	lea    -0x14(%ebp),%edx
  801886:	89 54 24 04          	mov    %edx,0x4(%esp)
  80188a:	89 04 24             	mov    %eax,(%esp)
  80188d:	e8 32 00 00 00       	call   8018c4 <dev_lookup>
  801892:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801899:	78 11                	js     8018ac <fd_close+0x71>
		r = (*dev->dev_close)(fd);
  80189b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189e:	8b 50 10             	mov    0x10(%eax),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	89 04 24             	mov    %eax,(%esp)
  8018a7:	ff d2                	call   *%edx
  8018a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ba:	e8 f2 fc ff ff       	call   8015b1 <sys_page_unmap>
	return r;
  8018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; devtab[i]; i++)
  8018ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8018d1:	eb 2b                	jmp    8018fe <dev_lookup+0x3a>
		if (devtab[i]->dev_id == dev_id) {
  8018d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d6:	8b 04 85 08 60 80 00 	mov    0x806008(,%eax,4),%eax
  8018dd:	8b 00                	mov    (%eax),%eax
  8018df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018e2:	75 16                	jne    8018fa <dev_lookup+0x36>
			*dev = devtab[i];
  8018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e7:	8b 14 85 08 60 80 00 	mov    0x806008(,%eax,4),%edx
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	89 10                	mov    %edx,(%eax)
			return 0;
  8018f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f8:	eb 3f                	jmp    801939 <dev_lookup+0x75>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801901:	8b 04 85 08 60 80 00 	mov    0x806008(,%eax,4),%eax
  801908:	85 c0                	test   %eax,%eax
  80190a:	75 c7                	jne    8018d3 <dev_lookup+0xf>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80190c:	a1 40 64 80 00       	mov    0x806440,%eax
  801911:	8b 40 4c             	mov    0x4c(%eax),%eax
  801914:	8b 55 08             	mov    0x8(%ebp),%edx
  801917:	89 54 24 08          	mov    %edx,0x8(%esp)
  80191b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191f:	c7 04 24 ec 2f 80 00 	movl   $0x802fec,(%esp)
  801926:	e8 b1 ec ff ff       	call   8005dc <cprintf>
	*dev = 0;
  80192b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801934:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <close>:

int
close(int fdnum)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801941:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801944:	89 44 24 04          	mov    %eax,0x4(%esp)
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	89 04 24             	mov    %eax,(%esp)
  80194e:	e8 c6 fe ff ff       	call   801819 <fd_lookup>
  801953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80195a:	79 05                	jns    801961 <close+0x26>
		return r;
  80195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195f:	eb 13                	jmp    801974 <close+0x39>
	else
		return fd_close(fd, 1);
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801964:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80196b:	00 
  80196c:	89 04 24             	mov    %eax,(%esp)
  80196f:	e8 c7 fe ff ff       	call   80183b <fd_close>
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <close_all>:

void
close_all(void)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 28             	sub    $0x28,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80197c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801983:	eb 0f                	jmp    801994 <close_all+0x1e>
		close(i);
  801985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801988:	89 04 24             	mov    %eax,(%esp)
  80198b:	e8 ab ff ff ff       	call   80193b <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801990:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  801994:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
  801998:	7e eb                	jle    801985 <close_all+0xf>
		close(i);
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 48             	sub    $0x48,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8019a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	89 04 24             	mov    %eax,(%esp)
  8019af:	e8 65 fe ff ff       	call   801819 <fd_lookup>
  8019b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019bb:	79 08                	jns    8019c5 <dup+0x29>
		return r;
  8019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c0:	e9 54 01 00 00       	jmp    801b19 <dup+0x17d>
	close(newfdnum);
  8019c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c8:	89 04 24             	mov    %eax,(%esp)
  8019cb:	e8 6b ff ff ff       	call   80193b <close>

	newfd = INDEX2FD(newfdnum);
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	05 00 fc 0c 00       	add    $0xcfc00,%eax
  8019d8:	c1 e0 0c             	shl    $0xc,%eax
  8019db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ova = fd2data(oldfd);
  8019de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019e1:	89 04 24             	mov    %eax,(%esp)
  8019e4:	e8 97 fd ff ff       	call   801780 <fd2data>
  8019e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nva = fd2data(newfd);
  8019ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ef:	89 04 24             	mov    %eax,(%esp)
  8019f2:	e8 89 fd ff ff       	call   801780 <fd2data>
  8019f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8019fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019fd:	c1 e8 0c             	shr    $0xc,%eax
  801a00:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a07:	89 c2                	mov    %eax,%edx
  801a09:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a12:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a19:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a1d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a24:	00 
  801a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a30:	e8 36 fb ff ff       	call   80156b <sys_page_map>
  801a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a3c:	0f 88 8e 00 00 00    	js     801ad0 <dup+0x134>
		goto err;
	if (vpd[PDX(ova)]) {
  801a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a45:	c1 e8 16             	shr    $0x16,%eax
  801a48:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	74 78                	je     801acb <dup+0x12f>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801a5a:	eb 66                	jmp    801ac2 <dup+0x126>
			pte = vpt[VPN(ova + i)];
  801a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5f:	03 45 e8             	add    -0x18(%ebp),%eax
  801a62:	c1 e8 0c             	shr    $0xc,%eax
  801a65:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (pte&PTE_P) {
  801a6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a72:	83 e0 01             	and    $0x1,%eax
  801a75:	84 c0                	test   %al,%al
  801a77:	74 42                	je     801abb <dup+0x11f>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7c:	89 c1                	mov    %eax,%ecx
  801a7e:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a87:	89 c2                	mov    %eax,%edx
  801a89:	03 55 e4             	add    -0x1c(%ebp),%edx
  801a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8f:	03 45 e8             	add    -0x18(%ebp),%eax
  801a92:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801a96:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aa1:	00 
  801aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aad:	e8 b9 fa ff ff       	call   80156b <sys_page_map>
  801ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ab5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ab9:	78 18                	js     801ad3 <dup+0x137>
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
	if (vpd[PDX(ova)]) {
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801abb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801ac2:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801ac9:	7e 91                	jle    801a5c <dup+0xc0>
					goto err;
			}
		}
	}

	return newfdnum;
  801acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ace:	eb 49                	jmp    801b19 <dup+0x17d>
	newfd = INDEX2FD(newfdnum);
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
		goto err;
  801ad0:	90                   	nop
  801ad1:	eb 01                	jmp    801ad4 <dup+0x138>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
			pte = vpt[VPN(ova + i)];
			if (pte&PTE_P) {
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
					goto err;
  801ad3:	90                   	nop
	}

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae2:	e8 ca fa ff ff       	call   8015b1 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801ae7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801aee:	eb 1d                	jmp    801b0d <dup+0x171>
		sys_page_unmap(0, nva + i);
  801af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af3:	03 45 e4             	add    -0x1c(%ebp),%eax
  801af6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b01:	e8 ab fa ff ff       	call   8015b1 <sys_page_unmap>

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801b06:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  801b0d:	81 7d f4 ff ff 3f 00 	cmpl   $0x3fffff,-0xc(%ebp)
  801b14:	7e da                	jle    801af0 <dup+0x154>
		sys_page_unmap(0, nva + i);
	return r;
  801b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b21:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	89 04 24             	mov    %eax,(%esp)
  801b2e:	e8 e6 fc ff ff       	call   801819 <fd_lookup>
  801b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b3a:	78 1d                	js     801b59 <read+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3f:	8b 00                	mov    (%eax),%eax
  801b41:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b44:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b48:	89 04 24             	mov    %eax,(%esp)
  801b4b:	e8 74 fd ff ff       	call   8018c4 <dev_lookup>
  801b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b57:	79 05                	jns    801b5e <read+0x43>
		return r;
  801b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5c:	eb 75                	jmp    801bd3 <read+0xb8>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b61:	8b 40 08             	mov    0x8(%eax),%eax
  801b64:	83 e0 03             	and    $0x3,%eax
  801b67:	83 f8 01             	cmp    $0x1,%eax
  801b6a:	75 26                	jne    801b92 <read+0x77>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801b6c:	a1 40 64 80 00       	mov    0x806440,%eax
  801b71:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b74:	8b 55 08             	mov    0x8(%ebp),%edx
  801b77:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7f:	c7 04 24 0b 30 80 00 	movl   $0x80300b,(%esp)
  801b86:	e8 51 ea ff ff       	call   8005dc <cprintf>
		return -E_INVAL;
  801b8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b90:	eb 41                	jmp    801bd3 <read+0xb8>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b95:	8b 48 08             	mov    0x8(%eax),%ecx
  801b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9b:	8b 50 04             	mov    0x4(%eax),%edx
  801b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ba5:	8b 55 10             	mov    0x10(%ebp),%edx
  801ba8:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bb3:	89 04 24             	mov    %eax,(%esp)
  801bb6:	ff d1                	call   *%ecx
  801bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r >= 0)
  801bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bbf:	78 0f                	js     801bd0 <read+0xb5>
		fd->fd_offset += r;
  801bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bc7:	8b 52 04             	mov    0x4(%edx),%edx
  801bca:	03 55 f4             	add    -0xc(%ebp),%edx
  801bcd:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 28             	sub    $0x28,%esp
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801be2:	eb 3b                	jmp    801c1f <readn+0x4a>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be7:	8b 55 10             	mov    0x10(%ebp),%edx
  801bea:	29 c2                	sub    %eax,%edx
  801bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bef:	03 45 0c             	add    0xc(%ebp),%eax
  801bf2:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	89 04 24             	mov    %eax,(%esp)
  801c00:	e8 16 ff ff ff       	call   801b1b <read>
  801c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (m < 0)
  801c08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c0c:	79 05                	jns    801c13 <readn+0x3e>
			return m;
  801c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c11:	eb 1a                	jmp    801c2d <readn+0x58>
		if (m == 0)
  801c13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c17:	74 10                	je     801c29 <readn+0x54>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1c:	01 45 f4             	add    %eax,-0xc(%ebp)
  801c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c22:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c25:	72 bd                	jb     801be4 <readn+0xf>
  801c27:	eb 01                	jmp    801c2a <readn+0x55>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  801c29:	90                   	nop
	}
	return tot;
  801c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	89 04 24             	mov    %eax,(%esp)
  801c42:	e8 d2 fb ff ff       	call   801819 <fd_lookup>
  801c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c4e:	78 1d                	js     801c6d <write+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c53:	8b 00                	mov    (%eax),%eax
  801c55:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801c58:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c5c:	89 04 24             	mov    %eax,(%esp)
  801c5f:	e8 60 fc ff ff       	call   8018c4 <dev_lookup>
  801c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c6b:	79 05                	jns    801c72 <write+0x43>
		return r;
  801c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c70:	eb 74                	jmp    801ce6 <write+0xb7>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c75:	8b 40 08             	mov    0x8(%eax),%eax
  801c78:	83 e0 03             	and    $0x3,%eax
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	75 26                	jne    801ca5 <write+0x76>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801c7f:	a1 40 64 80 00       	mov    0x806440,%eax
  801c84:	8b 40 4c             	mov    0x4c(%eax),%eax
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c92:	c7 04 24 27 30 80 00 	movl   $0x803027,(%esp)
  801c99:	e8 3e e9 ff ff       	call   8005dc <cprintf>
		return -E_INVAL;
  801c9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ca3:	eb 41                	jmp    801ce6 <write+0xb7>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	8b 48 0c             	mov    0xc(%eax),%ecx
  801cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cae:	8b 50 04             	mov    0x4(%eax),%edx
  801cb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cb8:	8b 55 10             	mov    0x10(%ebp),%edx
  801cbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cc6:	89 04 24             	mov    %eax,(%esp)
  801cc9:	ff d1                	call   *%ecx
  801ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (r > 0)
  801cce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd2:	7e 0f                	jle    801ce3 <write+0xb4>
		fd->fd_offset += r;
  801cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cda:	8b 52 04             	mov    0x4(%edx),%edx
  801cdd:	03 55 f4             	add    -0xc(%ebp),%edx
  801ce0:	89 50 04             	mov    %edx,0x4(%eax)
	return r;
  801ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	89 04 24             	mov    %eax,(%esp)
  801cfb:	e8 19 fb ff ff       	call   801819 <fd_lookup>
  801d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d07:	79 05                	jns    801d0e <seek+0x26>
		return r;
  801d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0c:	eb 0e                	jmp    801d1c <seek+0x34>
	fd->fd_offset = offset;
  801d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d14:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d24:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	89 04 24             	mov    %eax,(%esp)
  801d31:	e8 e3 fa ff ff       	call   801819 <fd_lookup>
  801d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3d:	78 1d                	js     801d5c <ftruncate+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d42:	8b 00                	mov    (%eax),%eax
  801d44:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801d47:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d4b:	89 04 24             	mov    %eax,(%esp)
  801d4e:	e8 71 fb ff ff       	call   8018c4 <dev_lookup>
  801d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5a:	79 05                	jns    801d61 <ftruncate+0x43>
		return r;
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	eb 48                	jmp    801da9 <ftruncate+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d64:	8b 40 08             	mov    0x8(%eax),%eax
  801d67:	83 e0 03             	and    $0x3,%eax
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	75 26                	jne    801d94 <ftruncate+0x76>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801d6e:	a1 40 64 80 00       	mov    0x806440,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d73:	8b 40 4c             	mov    0x4c(%eax),%eax
  801d76:	8b 55 08             	mov    0x8(%ebp),%edx
  801d79:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d81:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  801d88:	e8 4f e8 ff ff       	call   8005dc <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801d8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d92:	eb 15                	jmp    801da9 <ftruncate+0x8b>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d97:	8b 48 1c             	mov    0x1c(%eax),%ecx
  801d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	89 54 24 04          	mov    %edx,0x4(%esp)
  801da4:	89 04 24             	mov    %eax,(%esp)
  801da7:	ff d1                	call   *%ecx
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801db1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	89 04 24             	mov    %eax,(%esp)
  801dbe:	e8 56 fa ff ff       	call   801819 <fd_lookup>
  801dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dca:	78 1d                	js     801de9 <fstat+0x3e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcf:	8b 00                	mov    (%eax),%eax
  801dd1:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801dd4:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dd8:	89 04 24             	mov    %eax,(%esp)
  801ddb:	e8 e4 fa ff ff       	call   8018c4 <dev_lookup>
  801de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de7:	79 05                	jns    801dee <fstat+0x43>
		return r;
  801de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dec:	eb 41                	jmp    801e2f <fstat+0x84>
	stat->st_name[0] = 0;
  801dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df1:	c6 00 00             	movb   $0x0,(%eax)
	stat->st_size = 0;
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801dfe:	00 00 00 
	stat->st_isdir = 0;
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
  801e0b:	00 00 00 
	stat->st_dev = dev;
  801e0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e14:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	return (*dev->dev_stat)(fd, stat);
  801e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1d:	8b 48 14             	mov    0x14(%eax),%ecx
  801e20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e26:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e2a:	89 04 24             	mov    %eax,(%esp)
  801e2d:	ff d1                	call   *%ecx
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 28             	sub    $0x28,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e3e:	00 
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	89 04 24             	mov    %eax,(%esp)
  801e45:	e8 36 00 00 00       	call   801e80 <open>
  801e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e51:	79 05                	jns    801e58 <stat+0x27>
		return fd;
  801e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e56:	eb 23                	jmp    801e7b <stat+0x4a>
	r = fstat(fd, stat);
  801e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	89 04 24             	mov    %eax,(%esp)
  801e65:	e8 41 ff ff ff       	call   801dab <fstat>
  801e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	close(fd);
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	89 04 24             	mov    %eax,(%esp)
  801e73:	e8 c3 fa ff ff       	call   80193b <close>
	return r;
  801e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    
  801e7d:	00 00                	add    %al,(%eax)
	...

00801e80 <open>:

// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 28             	sub    $0x28,%esp
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0) return r;//alloc a fd
  801e86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e89:	89 04 24             	mov    %eax,(%esp)
  801e8c:	e8 1a f9 ff ff       	call   8017ab <fd_alloc>
  801e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e98:	79 05                	jns    801e9f <open+0x1f>
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	eb 73                	jmp    801f12 <open+0x92>
	if((r = fsipc_open(path, mode, fd)) < 0) return r;//
  801e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	89 04 24             	mov    %eax,(%esp)
  801eb3:	e8 f4 06 00 00       	call   8025ac <fsipc_open>
  801eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebf:	79 05                	jns    801ec6 <open+0x46>
  801ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec4:	eb 4c                	jmp    801f12 <open+0x92>
	if((r = fmap(fd, 0, fd->fd_file.file.f_size)) < 0){
  801ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed2:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ed6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801edd:	00 
  801ede:	89 04 24             	mov    %eax,(%esp)
  801ee1:	e8 25 03 00 00       	call   80220b <fmap>
  801ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eed:	79 18                	jns    801f07 <open+0x87>
		fd_close(fd, 1); return r;}//close the file if map failed
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ef9:	00 
  801efa:	89 04 24             	mov    %eax,(%esp)
  801efd:	e8 39 f9 ff ff       	call   80183b <fd_close>
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	eb 0b                	jmp    801f12 <open+0x92>
	return fd2num(fd);
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	89 04 24             	mov    %eax,(%esp)
  801f0d:	e8 89 f8 ff ff       	call   80179b <fd2num>
	//panic("open() unimplemented!");
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 28             	sub    $0x28,%esp
	// (to free up its resources).

	// LAB 5: Your code here.
	int r;
	// fd -> unmap
	if((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) return r;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801f23:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  801f2a:	00 
  801f2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f32:	00 
  801f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	89 04 24             	mov    %eax,(%esp)
  801f3d:	e8 72 03 00 00       	call   8022b4 <funmap>
  801f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f49:	79 05                	jns    801f50 <file_close+0x3c>
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	eb 21                	jmp    801f71 <file_close+0x5d>
	//close the file
	if((r = fsipc_close(fd->fd_file.id)) < 0) return r;
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	8b 40 0c             	mov    0xc(%eax),%eax
  801f56:	89 04 24             	mov    %eax,(%esp)
  801f59:	e8 83 07 00 00       	call   8026e1 <fsipc_close>
  801f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f65:	79 05                	jns    801f6c <file_close+0x58>
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	eb 05                	jmp    801f71 <file_close+0x5d>
	return 0;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("close() unimplemented!");
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <file_read>:
// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 28             	sub    $0x28,%esp
	size_t size;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (offset > size)
  801f85:	8b 45 14             	mov    0x14(%ebp),%eax
  801f88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f8b:	76 07                	jbe    801f94 <file_read+0x21>
		return 0;
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	eb 43                	jmp    801fd7 <file_read+0x64>
	if (offset + n > size)
  801f94:	8b 45 14             	mov    0x14(%ebp),%eax
  801f97:	03 45 10             	add    0x10(%ebp),%eax
  801f9a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f9d:	76 0f                	jbe    801fae <file_read+0x3b>
		n = size - offset;
  801f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa5:	89 d1                	mov    %edx,%ecx
  801fa7:	29 c1                	sub    %eax,%ecx
  801fa9:	89 c8                	mov    %ecx,%eax
  801fab:	89 45 10             	mov    %eax,0x10(%ebp)

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	89 04 24             	mov    %eax,(%esp)
  801fb4:	e8 c7 f7 ff ff       	call   801780 <fd2data>
  801fb9:	8b 55 14             	mov    0x14(%ebp),%edx
  801fbc:	01 c2                	add    %eax,%edx
  801fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcc:	89 04 24             	mov    %eax,(%esp)
  801fcf:	e8 0c f1 ff ff       	call   8010e0 <memmove>
	return n;
  801fd4:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 28             	sub    $0x28,%esp
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fdf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801fe2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	89 04 24             	mov    %eax,(%esp)
  801fec:	e8 28 f8 ff ff       	call   801819 <fd_lookup>
  801ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff8:	79 05                	jns    801fff <read_map+0x26>
		return r;
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	eb 74                	jmp    802073 <read_map+0x9a>
	if (fd->fd_dev_id != devfile.dev_id)
  801fff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802002:	8b 10                	mov    (%eax),%edx
  802004:	a1 20 60 80 00       	mov    0x806020,%eax
  802009:	39 c2                	cmp    %eax,%edx
  80200b:	74 07                	je     802014 <read_map+0x3b>
		return -E_INVAL;
  80200d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802012:	eb 5f                	jmp    802073 <read_map+0x9a>
	va = fd2data(fd) + offset;
  802014:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802017:	89 04 24             	mov    %eax,(%esp)
  80201a:	e8 61 f7 ff ff       	call   801780 <fd2data>
  80201f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802022:	01 d0                	add    %edx,%eax
  802024:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (offset >= MAXFILESIZE)
  802027:	81 7d 0c ff ff 3f 00 	cmpl   $0x3fffff,0xc(%ebp)
  80202e:	7e 07                	jle    802037 <read_map+0x5e>
		return -E_NO_DISK;
  802030:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802035:	eb 3c                	jmp    802073 <read_map+0x9a>
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  802037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203a:	c1 e8 16             	shr    $0x16,%eax
  80203d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802044:	83 e0 01             	and    $0x1,%eax
  802047:	85 c0                	test   %eax,%eax
  802049:	74 14                	je     80205f <read_map+0x86>
  80204b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204e:	c1 e8 0c             	shr    $0xc,%eax
  802051:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802058:	83 e0 01             	and    $0x1,%eax
  80205b:	85 c0                	test   %eax,%eax
  80205d:	75 07                	jne    802066 <read_map+0x8d>
		return -E_NO_DISK;
  80205f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802064:	eb 0d                	jmp    802073 <read_map+0x9a>
	*blk = (void*) va;
  802066:	8b 45 10             	mov    0x10(%ebp),%eax
  802069:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80206c:	89 10                	mov    %edx,(%eax)
	return 0;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 28             	sub    $0x28,%esp
	int r;
	size_t tot;

	// don't write past the maximum file size
	tot = offset + n;
  80207b:	8b 45 14             	mov    0x14(%ebp),%eax
  80207e:	03 45 10             	add    0x10(%ebp),%eax
  802081:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (tot > MAXFILESIZE)
  802084:	81 7d f4 00 00 40 00 	cmpl   $0x400000,-0xc(%ebp)
  80208b:	76 07                	jbe    802094 <file_write+0x1f>
		return -E_NO_DISK;
  80208d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802092:	eb 57                	jmp    8020eb <file_write+0x76>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80209d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020a0:	73 20                	jae    8020c2 <file_write+0x4d>
		if ((r = file_trunc(fd, tot)) < 0)
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	89 04 24             	mov    %eax,(%esp)
  8020af:	e8 88 00 00 00       	call   80213c <file_trunc>
  8020b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020bb:	79 05                	jns    8020c2 <file_write+0x4d>
			return r;
  8020bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c0:	eb 29                	jmp    8020eb <file_write+0x76>
	}

	// write the data
	memmove(fd2data(fd) + offset, buf, n);
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	89 04 24             	mov    %eax,(%esp)
  8020c8:	e8 b3 f6 ff ff       	call   801780 <fd2data>
  8020cd:	8b 55 14             	mov    0x14(%ebp),%edx
  8020d0:	01 c2                	add    %eax,%edx
  8020d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e0:	89 14 24             	mov    %edx,(%esp)
  8020e3:	e8 f8 ef ff ff       	call   8010e0 <memmove>
	return n;
  8020e8:	8b 45 10             	mov    0x10(%ebp),%eax
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 18             	sub    $0x18,%esp
	strcpy(st->st_name, fd->fd_file.file.f_name);
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	8d 50 10             	lea    0x10(%eax),%edx
  8020f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  802100:	89 04 24             	mov    %eax,(%esp)
  802103:	e8 e6 ed ff ff       	call   800eee <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  802111:	8b 45 0c             	mov    0xc(%ebp),%eax
  802114:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
  802123:	83 f8 01             	cmp    $0x1,%eax
  802126:	0f 94 c0             	sete   %al
  802129:	0f b6 d0             	movzbl %al,%edx
  80212c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212f:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
	return 0;
  802135:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 28             	sub    $0x28,%esp
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
  802142:	81 7d 0c 00 00 40 00 	cmpl   $0x400000,0xc(%ebp)
  802149:	7e 0a                	jle    802155 <file_trunc+0x19>
		return -E_NO_DISK;
  80214b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802150:	e9 b4 00 00 00       	jmp    802209 <file_trunc+0xcd>

	fileid = fd->fd_file.id;
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	8b 40 0c             	mov    0xc(%eax),%eax
  80215b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	oldsize = fd->fd_file.file.f_size;
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  802167:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802170:	89 54 24 04          	mov    %edx,0x4(%esp)
  802174:	89 04 24             	mov    %eax,(%esp)
  802177:	e8 22 05 00 00       	call   80269e <fsipc_set_size>
  80217c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80217f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802183:	79 05                	jns    80218a <file_trunc+0x4e>
		return r;
  802185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802188:	eb 7f                	jmp    802209 <file_trunc+0xcd>
	assert(fd->fd_file.file.f_size == newsize);
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  802193:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802196:	74 24                	je     8021bc <file_trunc+0x80>
  802198:	c7 44 24 0c 70 30 80 	movl   $0x803070,0xc(%esp)
  80219f:	00 
  8021a0:	c7 44 24 08 93 30 80 	movl   $0x803093,0x8(%esp)
  8021a7:	00 
  8021a8:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8021af:	00 
  8021b0:	c7 04 24 a8 30 80 00 	movl   $0x8030a8,(%esp)
  8021b7:	e8 ec e2 ff ff       	call   8004a8 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  8021bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	89 04 24             	mov    %eax,(%esp)
  8021d0:	e8 36 00 00 00       	call   80220b <fmap>
  8021d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021dc:	79 05                	jns    8021e3 <file_trunc+0xa7>
		return r;
  8021de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e1:	eb 26                	jmp    802209 <file_trunc+0xcd>
	funmap(fd, oldsize, newsize, 0);
  8021e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021ea:	00 
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	89 04 24             	mov    %eax,(%esp)
  8021ff:	e8 b0 00 00 00       	call   8022b4 <funmap>

	return 0;
  802204:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <fmap>:
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	89 04 24             	mov    %eax,(%esp)
  802217:	e8 64 f5 ff ff       	call   801780 <fd2data>
  80221c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80221f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	03 45 ec             	add    -0x14(%ebp),%eax
  80222c:	83 e8 01             	sub    $0x1,%eax
  80222f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802235:	ba 00 00 00 00       	mov    $0x0,%edx
  80223a:	f7 75 ec             	divl   -0x14(%ebp)
  80223d:	89 d0                	mov    %edx,%eax
  80223f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802242:	89 d1                	mov    %edx,%ecx
  802244:	29 c1                	sub    %eax,%ecx
  802246:	89 c8                	mov    %ecx,%eax
  802248:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224b:	eb 58                	jmp    8022a5 <fmap+0x9a>
		if ((r = fsipc_map(fd->fd_file.id, i, va + i)) < 0) {
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802253:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8b 40 0c             	mov    0xc(%eax),%eax
  80225f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802263:	89 54 24 04          	mov    %edx,0x4(%esp)
  802267:	89 04 24             	mov    %eax,(%esp)
  80226a:	e8 a4 03 00 00       	call   802613 <fsipc_map>
  80226f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802272:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802276:	79 26                	jns    80229e <fmap+0x93>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802282:	00 
  802283:	8b 55 0c             	mov    0xc(%ebp),%edx
  802286:	89 54 24 08          	mov    %edx,0x8(%esp)
  80228a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	89 04 24             	mov    %eax,(%esp)
  802294:	e8 1b 00 00 00       	call   8022b4 <funmap>
			return r;
  802299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80229c:	eb 14                	jmp    8022b2 <fmap+0xa7>
	size_t i;
	char *va;
	int r;

	va = fd2data(fd);
	for (i = ROUNDUP(oldsize, PGSIZE); i < newsize; i += PGSIZE) {
  80229e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8022a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022ab:	77 a0                	ja     80224d <fmap+0x42>
			// unmap anything we may have mapped so far
			funmap(fd, i, oldsize, 0);
			return r;
		}
	}
	return 0;
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <funmap>:
// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	83 ec 38             	sub    $0x38,%esp
	size_t i;
	char *va;
	int r, ret;

	va = fd2data(fd);
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	89 04 24             	mov    %eax,(%esp)
  8022c0:	e8 bb f4 ff ff       	call   801780 <fd2data>
  8022c5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
  8022c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cb:	c1 e8 16             	shr    $0x16,%eax
  8022ce:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8022d5:	83 e0 01             	and    $0x1,%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	75 0a                	jne    8022e6 <funmap+0x32>
		return 0;
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e1:	e9 bf 00 00 00       	jmp    8023a5 <funmap+0xf1>

	ret = 0;
  8022e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  8022ed:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8022f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f7:	03 45 e8             	add    -0x18(%ebp),%eax
  8022fa:	83 e8 01             	sub    $0x1,%eax
  8022fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802303:	ba 00 00 00 00       	mov    $0x0,%edx
  802308:	f7 75 e8             	divl   -0x18(%ebp)
  80230b:	89 d0                	mov    %edx,%eax
  80230d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802310:	89 d1                	mov    %edx,%ecx
  802312:	29 c1                	sub    %eax,%ecx
  802314:	89 c8                	mov    %ecx,%eax
  802316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802319:	eb 7b                	jmp    802396 <funmap+0xe2>
		if (vpt[VPN(va + i)] & PTE_P) {
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802321:	01 d0                	add    %edx,%eax
  802323:	c1 e8 0c             	shr    $0xc,%eax
  802326:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80232d:	83 e0 01             	and    $0x1,%eax
  802330:	84 c0                	test   %al,%al
  802332:	74 5b                	je     80238f <funmap+0xdb>
			if (dirty
  802334:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  802338:	74 3d                	je     802377 <funmap+0xc3>
			    && (vpt[VPN(va + i)] & PTE_D)
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802340:	01 d0                	add    %edx,%eax
  802342:	c1 e8 0c             	shr    $0xc,%eax
  802345:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80234c:	83 e0 40             	and    $0x40,%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	74 24                	je     802377 <funmap+0xc3>
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
  802353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	8b 40 0c             	mov    0xc(%eax),%eax
  80235c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802360:	89 04 24             	mov    %eax,(%esp)
  802363:	e8 b3 03 00 00       	call   80271b <fsipc_dirty>
  802368:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80236b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80236f:	79 06                	jns    802377 <funmap+0xc3>
				ret = r;
  802371:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802374:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_page_unmap(0, va + i);
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80237d:	01 d0                	add    %edx,%eax
  80237f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802383:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80238a:	e8 22 f2 ff ff       	call   8015b1 <sys_page_unmap>
	// Check vpd to see if anything is mapped.
	if (!(vpd[VPD(va)] & PTE_P))
		return 0;

	ret = 0;
	for (i = ROUNDUP(newsize, PGSIZE); i < oldsize; i += PGSIZE)
  80238f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80239c:	0f 87 79 ff ff ff    	ja     80231b <funmap+0x67>
			    && (vpt[VPN(va + i)] & PTE_D)
			    && (r = fsipc_dirty(fd->fd_file.id, i)) < 0)
				ret = r;
			sys_page_unmap(0, va + i);
		}
  	return ret;
  8023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <remove>:

// Delete a file
int
remove(const char *path)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 18             	sub    $0x18,%esp
	return fsipc_remove(path);
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	89 04 24             	mov    %eax,(%esp)
  8023b3:	e8 a6 03 00 00       	call   80275e <fsipc_remove>
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  8023c0:	e8 f6 03 00 00       	call   8027bb <fsipc_sync>
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    
	...

008023c8 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 28             	sub    $0x28,%esp
	if (b->error > 0) {
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	7e 5d                	jle    802435 <writebuf+0x6d>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	8b 40 04             	mov    0x4(%eax),%eax
  8023de:	89 c2                	mov    %eax,%edx
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	8d 48 10             	lea    0x10(%eax),%ecx
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	8b 00                	mov    (%eax),%eax
  8023eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023f3:	89 04 24             	mov    %eax,(%esp)
  8023f6:	e8 34 f8 ff ff       	call   801c2f <write>
  8023fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (result > 0)
  8023fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802402:	7e 11                	jle    802415 <writebuf+0x4d>
			b->result += result;
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	8b 40 08             	mov    0x8(%eax),%eax
  80240a:	89 c2                	mov    %eax,%edx
  80240c:	03 55 f4             	add    -0xc(%ebp),%edx
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	89 50 08             	mov    %edx,0x8(%eax)
		if (result != b->idx) // error, or wrote less than supplied
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	8b 40 04             	mov    0x4(%eax),%eax
  80241b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80241e:	74 15                	je     802435 <writebuf+0x6d>
			b->error = (result < 0 ? result : 0);
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
  802425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802429:	89 c2                	mov    %eax,%edx
  80242b:	0f 4e 55 f4          	cmovle -0xc(%ebp),%edx
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	89 50 0c             	mov    %edx,0xc(%eax)
	}
}
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <putch>:

static void
putch(int ch, void *thunk)
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
  80243a:	83 ec 28             	sub    $0x28,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  80243d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802440:	89 45 f4             	mov    %eax,-0xc(%ebp)
	b->buf[b->idx++] = ch;
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 04             	mov    0x4(%eax),%eax
  802449:	8b 55 08             	mov    0x8(%ebp),%edx
  80244c:	89 d1                	mov    %edx,%ecx
  80244e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802451:	88 4c 02 10          	mov    %cl,0x10(%edx,%eax,1)
  802455:	8d 50 01             	lea    0x1(%eax),%edx
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	89 50 04             	mov    %edx,0x4(%eax)
	if (b->idx == 256) {
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	3d 00 01 00 00       	cmp    $0x100,%eax
  802469:	75 15                	jne    802480 <putch+0x49>
		writebuf(b);
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	89 04 24             	mov    %eax,(%esp)
  802471:	e8 52 ff ff ff       	call   8023c8 <writebuf>
		b->idx = 0;
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	}
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802494:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80249b:	00 00 00 
	b.result = 0;
  80249e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8024a5:	00 00 00 
	b.error = 1;
  8024a8:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8024af:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8024b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c0:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8024c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ca:	c7 04 24 37 24 80 00 	movl   $0x802437,(%esp)
  8024d1:	e8 da e2 ff ff       	call   8007b0 <vprintfmt>
	if (b.idx > 0)
  8024d6:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8024dc:	85 c0                	test   %eax,%eax
  8024de:	7e 0e                	jle    8024ee <vfprintf+0x6c>
		writebuf(&b);
  8024e0:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8024e6:	89 04 24             	mov    %eax,(%esp)
  8024e9:	e8 da fe ff ff       	call   8023c8 <writebuf>

	return (b.result ? b.result : b.error);
  8024ee:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	74 08                	je     802500 <vfprintf+0x7e>
  8024f8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8024fe:	eb 06                	jmp    802506 <vfprintf+0x84>
  802500:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80250e:	8d 45 0c             	lea    0xc(%ebp),%eax
  802511:	83 c0 04             	add    $0x4,%eax
  802514:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vfprintf(fd, fmt, ap);
  802517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802521:	89 44 24 04          	mov    %eax,0x4(%esp)
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	89 04 24             	mov    %eax,(%esp)
  80252b:	e8 52 ff ff ff       	call   802482 <vfprintf>
  802530:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <printf>:

int
printf(const char *fmt, ...)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 28             	sub    $0x28,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80253e:	8d 45 0c             	lea    0xc(%ebp),%eax
  802541:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vfprintf(1, fmt, ap);
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80254e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802552:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802559:	e8 24 ff ff ff       	call   802482 <vfprintf>
  80255e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  802561:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    
	...

00802568 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 28             	sub    $0x28,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  80256e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  802573:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80257a:	00 
  80257b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802582:	8b 55 08             	mov    0x8(%ebp),%edx
  802585:	89 54 24 04          	mov    %edx,0x4(%esp)
  802589:	89 04 24             	mov    %eax,(%esp)
  80258c:	e8 e3 02 00 00       	call   802874 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  802591:	8b 45 14             	mov    0x14(%ebp),%eax
  802594:	89 44 24 08          	mov    %eax,0x8(%esp)
  802598:	8b 45 10             	mov    0x10(%ebp),%eax
  80259b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80259f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025a2:	89 04 24             	mov    %eax,(%esp)
  8025a5:	e8 3e 02 00 00       	call   8027e8 <ipc_recv>
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <fsipc_open>:
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 28             	sub    $0x28,%esp
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  8025b2:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	89 04 24             	mov    %eax,(%esp)
  8025bf:	e8 d4 e8 ff ff       	call   800e98 <strlen>
  8025c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8025c9:	7e 07                	jle    8025d2 <fsipc_open+0x26>
		return -E_BAD_PATH;
  8025cb:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8025d0:	eb 3f                	jmp    802611 <fsipc_open+0x65>
	strcpy(req->req_path, path);
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025dc:	89 04 24             	mov    %eax,(%esp)
  8025df:	e8 0a e9 ff ff       	call   800eee <strcpy>
	req->req_omode = omode;
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ea:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8025f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	89 44 24 04          	mov    %eax,0x4(%esp)
  802605:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80260c:	e8 57 ff ff ff       	call   802568 <fsipc>
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <fsipc_map>:
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	83 ec 38             	sub    $0x38,%esp
	int r, perm;
	struct Fsreq_map *req;

	req = (struct Fsreq_map*) fsipcbuf;
  802619:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 55 08             	mov    0x8(%ebp),%edx
  802626:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262e:	89 50 04             	mov    %edx,0x4(%eax)
	if ((r = fsipc(FSREQ_MAP, req, dstva, &perm)) < 0)
  802631:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802634:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802638:	8b 45 10             	mov    0x10(%ebp),%eax
  80263b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	89 44 24 04          	mov    %eax,0x4(%esp)
  802646:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80264d:	e8 16 ff ff ff       	call   802568 <fsipc>
  802652:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802655:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802659:	79 05                	jns    802660 <fsipc_map+0x4d>
		return r;
  80265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265e:	eb 3c                	jmp    80269c <fsipc_map+0x89>
	if ((perm & ~(PTE_W | PTE_SHARE)) != (PTE_U | PTE_P))
  802660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802663:	25 fd fb ff ff       	and    $0xfffffbfd,%eax
  802668:	83 f8 05             	cmp    $0x5,%eax
  80266b:	74 2a                	je     802697 <fsipc_map+0x84>
		panic("fsipc_map: unexpected permissions %08x for dstva %08x", perm, dstva);
  80266d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802670:	8b 55 10             	mov    0x10(%ebp),%edx
  802673:	89 54 24 10          	mov    %edx,0x10(%esp)
  802677:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80267b:	c7 44 24 08 b4 30 80 	movl   $0x8030b4,0x8(%esp)
  802682:	00 
  802683:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  80268a:	00 
  80268b:	c7 04 24 ea 30 80 00 	movl   $0x8030ea,(%esp)
  802692:	e8 11 de ff ff       	call   8004a8 <_panic>
	return 0;
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
  8026a4:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b1:	89 10                	mov    %edx,(%eax)
	req->req_size = size;
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b9:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  8026bc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026c3:	00 
  8026c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026cb:	00 
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d3:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8026da:	e8 89 fe ff ff       	call   802568 <fsipc>
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
  8026e7:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f4:	89 10                	mov    %edx,(%eax)
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  8026f6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026fd:	00 
  8026fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802705:	00 
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	89 44 24 04          	mov    %eax,0x4(%esp)
  80270d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  802714:	e8 4f fe ff ff       	call   802568 <fsipc>
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_dirty *req;

	req = (struct Fsreq_dirty*) fsipcbuf;
  802721:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	req->req_fileid = fileid;
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 55 08             	mov    0x8(%ebp),%edx
  80272e:	89 10                	mov    %edx,(%eax)
	req->req_offset = offset;
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 55 0c             	mov    0xc(%ebp),%edx
  802736:	89 50 04             	mov    %edx,0x4(%eax)
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  802739:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802740:	00 
  802741:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802748:	00 
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802750:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  802757:	e8 0c fe ff ff       	call   802568 <fsipc>
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	83 ec 28             	sub    $0x28,%esp
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802764:	c7 45 f4 00 40 80 00 	movl   $0x804000,-0xc(%ebp)
	if (strlen(path) >= MAXPATHLEN)
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	89 04 24             	mov    %eax,(%esp)
  802771:	e8 22 e7 ff ff       	call   800e98 <strlen>
  802776:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80277b:	7e 07                	jle    802784 <fsipc_remove+0x26>
		return -E_BAD_PATH;
  80277d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802782:	eb 35                	jmp    8027b9 <fsipc_remove+0x5b>
	strcpy(req->req_path, path);
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 55 08             	mov    0x8(%ebp),%edx
  80278a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80278e:	89 04 24             	mov    %eax,(%esp)
  802791:	e8 58 e7 ff ff       	call   800eee <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  802796:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80279d:	00 
  80279e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027a5:	00 
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ad:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
  8027b4:	e8 af fd ff ff       	call   802568 <fsipc>
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	83 ec 18             	sub    $0x18,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8027c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8027c8:	00 
  8027c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027d0:	00 
  8027d1:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  8027d8:	00 
  8027d9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8027e0:	e8 83 fd ff ff       	call   802568 <fsipc>
}
  8027e5:	c9                   	leave  
  8027e6:	c3                   	ret    
	...

008027e8 <ipc_recv>:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
  8027ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027f2:	75 11                	jne    802805 <ipc_recv+0x1d>
	    r = sys_ipc_recv((void *)UTOP);
  8027f4:	c7 04 24 00 00 c0 ee 	movl   $0xeec00000,(%esp)
  8027fb:	e8 3b ef ff ff       	call   80173b <sys_ipc_recv>
  802800:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802803:	eb 0e                	jmp    802813 <ipc_recv+0x2b>
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
  802805:	8b 45 0c             	mov    0xc(%ebp),%eax
  802808:	89 04 24             	mov    %eax,(%esp)
  80280b:	e8 2b ef ff ff       	call   80173b <sys_ipc_recv>
  802810:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	if(r < 0) {
  802813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802817:	79 1c                	jns    802835 <ipc_recv+0x4d>
		panic("send ipc_recv failed\n");
  802819:	c7 44 24 08 f6 30 80 	movl   $0x8030f6,0x8(%esp)
  802820:	00 
  802821:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  802828:	00 
  802829:	c7 04 24 0c 31 80 00 	movl   $0x80310c,(%esp)
  802830:	e8 73 dc ff ff       	call   8004a8 <_panic>
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
  802835:	e8 68 ec ff ff       	call   8014a2 <sys_getenvid>
  80283a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80283f:	c1 e0 07             	shl    $0x7,%eax
  802842:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802847:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(from_env_store != NULL) {
  80284a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80284e:	74 0b                	je     80285b <ipc_recv+0x73>
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
  802850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802853:	8b 50 74             	mov    0x74(%eax),%edx
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	89 10                	mov    %edx,(%eax)
	}
	if(perm_store != NULL){
  80285b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80285f:	74 0b                	je     80286c <ipc_recv+0x84>
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	8b 50 78             	mov    0x78(%eax),%edx
  802867:	8b 45 10             	mov    0x10(%ebp),%eax
  80286a:	89 10                	mov    %edx,(%eax)
	}
	return env_n->env_ipc_value;
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	8b 40 70             	mov    0x70(%eax),%eax
	//return 0;
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 28             	sub    $0x28,%esp
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
  80287a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80287e:	75 26                	jne    8028a6 <ipc_send+0x32>
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
  802880:	8b 45 14             	mov    0x14(%ebp),%eax
  802883:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802887:	c7 44 24 08 00 00 c0 	movl   $0xeec00000,0x8(%esp)
  80288e:	ee 
  80288f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802892:	89 44 24 04          	mov    %eax,0x4(%esp)
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	89 04 24             	mov    %eax,(%esp)
  80289c:	e8 5a ee ff ff       	call   8016fb <sys_ipc_try_send>
  8028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a4:	eb 23                	jmp    8028c9 <ipc_send+0x55>
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
  8028a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8028a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	89 04 24             	mov    %eax,(%esp)
  8028c1:	e8 35 ee ff ff       	call   8016fb <sys_ipc_try_send>
  8028c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
  8028c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cd:	79 29                	jns    8028f8 <ipc_send+0x84>
  8028cf:	83 7d f4 f9          	cmpl   $0xfffffff9,-0xc(%ebp)
  8028d3:	74 23                	je     8028f8 <ipc_send+0x84>
	        panic(" %d Msg Rec Error!\n", r);
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028dc:	c7 44 24 08 16 31 80 	movl   $0x803116,0x8(%esp)
  8028e3:	00 
  8028e4:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8028eb:	00 
  8028ec:	c7 04 24 0c 31 80 00 	movl   $0x80310c,(%esp)
  8028f3:	e8 b0 db ff ff       	call   8004a8 <_panic>
	    sys_yield();
  8028f8:	e8 e9 eb ff ff       	call   8014e6 <sys_yield>
	}while(r < 0);
  8028fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802901:	0f 88 73 ff ff ff    	js     80287a <ipc_send+0x6>
}
  802907:	c9                   	leave  
  802908:	c3                   	ret    
  802909:	00 00                	add    %al,(%eax)
  80290b:	00 00                	add    %al,(%eax)
  80290d:	00 00                	add    %al,(%eax)
	...

00802910 <__udivdi3>:
  802910:	83 ec 1c             	sub    $0x1c,%esp
  802913:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802917:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  80291b:	8b 44 24 20          	mov    0x20(%esp),%eax
  80291f:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802923:	89 74 24 10          	mov    %esi,0x10(%esp)
  802927:	8b 74 24 24          	mov    0x24(%esp),%esi
  80292b:	85 ff                	test   %edi,%edi
  80292d:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802931:	89 44 24 08          	mov    %eax,0x8(%esp)
  802935:	89 cd                	mov    %ecx,%ebp
  802937:	89 44 24 04          	mov    %eax,0x4(%esp)
  80293b:	75 33                	jne    802970 <__udivdi3+0x60>
  80293d:	39 f1                	cmp    %esi,%ecx
  80293f:	77 57                	ja     802998 <__udivdi3+0x88>
  802941:	85 c9                	test   %ecx,%ecx
  802943:	75 0b                	jne    802950 <__udivdi3+0x40>
  802945:	b8 01 00 00 00       	mov    $0x1,%eax
  80294a:	31 d2                	xor    %edx,%edx
  80294c:	f7 f1                	div    %ecx
  80294e:	89 c1                	mov    %eax,%ecx
  802950:	89 f0                	mov    %esi,%eax
  802952:	31 d2                	xor    %edx,%edx
  802954:	f7 f1                	div    %ecx
  802956:	89 c6                	mov    %eax,%esi
  802958:	8b 44 24 04          	mov    0x4(%esp),%eax
  80295c:	f7 f1                	div    %ecx
  80295e:	89 f2                	mov    %esi,%edx
  802960:	8b 74 24 10          	mov    0x10(%esp),%esi
  802964:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802968:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  80296c:	83 c4 1c             	add    $0x1c,%esp
  80296f:	c3                   	ret    
  802970:	31 d2                	xor    %edx,%edx
  802972:	31 c0                	xor    %eax,%eax
  802974:	39 f7                	cmp    %esi,%edi
  802976:	77 e8                	ja     802960 <__udivdi3+0x50>
  802978:	0f bd cf             	bsr    %edi,%ecx
  80297b:	83 f1 1f             	xor    $0x1f,%ecx
  80297e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802982:	75 2c                	jne    8029b0 <__udivdi3+0xa0>
  802984:	3b 6c 24 08          	cmp    0x8(%esp),%ebp
  802988:	76 04                	jbe    80298e <__udivdi3+0x7e>
  80298a:	39 f7                	cmp    %esi,%edi
  80298c:	73 d2                	jae    802960 <__udivdi3+0x50>
  80298e:	31 d2                	xor    %edx,%edx
  802990:	b8 01 00 00 00       	mov    $0x1,%eax
  802995:	eb c9                	jmp    802960 <__udivdi3+0x50>
  802997:	90                   	nop
  802998:	89 f2                	mov    %esi,%edx
  80299a:	f7 f1                	div    %ecx
  80299c:	31 d2                	xor    %edx,%edx
  80299e:	8b 74 24 10          	mov    0x10(%esp),%esi
  8029a2:	8b 7c 24 14          	mov    0x14(%esp),%edi
  8029a6:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  8029aa:	83 c4 1c             	add    $0x1c,%esp
  8029ad:	c3                   	ret    
  8029ae:	66 90                	xchg   %ax,%ax
  8029b0:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029b5:	b8 20 00 00 00       	mov    $0x20,%eax
  8029ba:	89 ea                	mov    %ebp,%edx
  8029bc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8029c0:	d3 e7                	shl    %cl,%edi
  8029c2:	89 c1                	mov    %eax,%ecx
  8029c4:	d3 ea                	shr    %cl,%edx
  8029c6:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029cb:	09 fa                	or     %edi,%edx
  8029cd:	89 f7                	mov    %esi,%edi
  8029cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8029d3:	89 f2                	mov    %esi,%edx
  8029d5:	8b 74 24 08          	mov    0x8(%esp),%esi
  8029d9:	d3 e5                	shl    %cl,%ebp
  8029db:	89 c1                	mov    %eax,%ecx
  8029dd:	d3 ef                	shr    %cl,%edi
  8029df:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029e4:	d3 e2                	shl    %cl,%edx
  8029e6:	89 c1                	mov    %eax,%ecx
  8029e8:	d3 ee                	shr    %cl,%esi
  8029ea:	09 d6                	or     %edx,%esi
  8029ec:	89 fa                	mov    %edi,%edx
  8029ee:	89 f0                	mov    %esi,%eax
  8029f0:	f7 74 24 0c          	divl   0xc(%esp)
  8029f4:	89 d7                	mov    %edx,%edi
  8029f6:	89 c6                	mov    %eax,%esi
  8029f8:	f7 e5                	mul    %ebp
  8029fa:	39 d7                	cmp    %edx,%edi
  8029fc:	72 22                	jb     802a20 <__udivdi3+0x110>
  8029fe:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  802a02:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a07:	d3 e5                	shl    %cl,%ebp
  802a09:	39 c5                	cmp    %eax,%ebp
  802a0b:	73 04                	jae    802a11 <__udivdi3+0x101>
  802a0d:	39 d7                	cmp    %edx,%edi
  802a0f:	74 0f                	je     802a20 <__udivdi3+0x110>
  802a11:	89 f0                	mov    %esi,%eax
  802a13:	31 d2                	xor    %edx,%edx
  802a15:	e9 46 ff ff ff       	jmp    802960 <__udivdi3+0x50>
  802a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a20:	8d 46 ff             	lea    -0x1(%esi),%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	8b 74 24 10          	mov    0x10(%esp),%esi
  802a29:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802a2d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802a31:	83 c4 1c             	add    $0x1c,%esp
  802a34:	c3                   	ret    
	...

00802a40 <__umoddi3>:
  802a40:	83 ec 1c             	sub    $0x1c,%esp
  802a43:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  802a47:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  802a4b:	8b 44 24 20          	mov    0x20(%esp),%eax
  802a4f:	89 74 24 10          	mov    %esi,0x10(%esp)
  802a53:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  802a57:	8b 74 24 24          	mov    0x24(%esp),%esi
  802a5b:	85 ed                	test   %ebp,%ebp
  802a5d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  802a61:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a65:	89 cf                	mov    %ecx,%edi
  802a67:	89 04 24             	mov    %eax,(%esp)
  802a6a:	89 f2                	mov    %esi,%edx
  802a6c:	75 1a                	jne    802a88 <__umoddi3+0x48>
  802a6e:	39 f1                	cmp    %esi,%ecx
  802a70:	76 4e                	jbe    802ac0 <__umoddi3+0x80>
  802a72:	f7 f1                	div    %ecx
  802a74:	89 d0                	mov    %edx,%eax
  802a76:	31 d2                	xor    %edx,%edx
  802a78:	8b 74 24 10          	mov    0x10(%esp),%esi
  802a7c:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802a80:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802a84:	83 c4 1c             	add    $0x1c,%esp
  802a87:	c3                   	ret    
  802a88:	39 f5                	cmp    %esi,%ebp
  802a8a:	77 54                	ja     802ae0 <__umoddi3+0xa0>
  802a8c:	0f bd c5             	bsr    %ebp,%eax
  802a8f:	83 f0 1f             	xor    $0x1f,%eax
  802a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a96:	75 60                	jne    802af8 <__umoddi3+0xb8>
  802a98:	3b 0c 24             	cmp    (%esp),%ecx
  802a9b:	0f 87 07 01 00 00    	ja     802ba8 <__umoddi3+0x168>
  802aa1:	89 f2                	mov    %esi,%edx
  802aa3:	8b 34 24             	mov    (%esp),%esi
  802aa6:	29 ce                	sub    %ecx,%esi
  802aa8:	19 ea                	sbb    %ebp,%edx
  802aaa:	89 34 24             	mov    %esi,(%esp)
  802aad:	8b 04 24             	mov    (%esp),%eax
  802ab0:	8b 74 24 10          	mov    0x10(%esp),%esi
  802ab4:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802ab8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802abc:	83 c4 1c             	add    $0x1c,%esp
  802abf:	c3                   	ret    
  802ac0:	85 c9                	test   %ecx,%ecx
  802ac2:	75 0b                	jne    802acf <__umoddi3+0x8f>
  802ac4:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac9:	31 d2                	xor    %edx,%edx
  802acb:	f7 f1                	div    %ecx
  802acd:	89 c1                	mov    %eax,%ecx
  802acf:	89 f0                	mov    %esi,%eax
  802ad1:	31 d2                	xor    %edx,%edx
  802ad3:	f7 f1                	div    %ecx
  802ad5:	8b 04 24             	mov    (%esp),%eax
  802ad8:	f7 f1                	div    %ecx
  802ada:	eb 98                	jmp    802a74 <__umoddi3+0x34>
  802adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ae0:	89 f2                	mov    %esi,%edx
  802ae2:	8b 74 24 10          	mov    0x10(%esp),%esi
  802ae6:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802aea:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802aee:	83 c4 1c             	add    $0x1c,%esp
  802af1:	c3                   	ret    
  802af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802af8:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802afd:	89 e8                	mov    %ebp,%eax
  802aff:	bd 20 00 00 00       	mov    $0x20,%ebp
  802b04:	2b 6c 24 04          	sub    0x4(%esp),%ebp
  802b08:	89 fa                	mov    %edi,%edx
  802b0a:	d3 e0                	shl    %cl,%eax
  802b0c:	89 e9                	mov    %ebp,%ecx
  802b0e:	d3 ea                	shr    %cl,%edx
  802b10:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b15:	09 c2                	or     %eax,%edx
  802b17:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b1b:	89 14 24             	mov    %edx,(%esp)
  802b1e:	89 f2                	mov    %esi,%edx
  802b20:	d3 e7                	shl    %cl,%edi
  802b22:	89 e9                	mov    %ebp,%ecx
  802b24:	d3 ea                	shr    %cl,%edx
  802b26:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b2f:	d3 e6                	shl    %cl,%esi
  802b31:	89 e9                	mov    %ebp,%ecx
  802b33:	d3 e8                	shr    %cl,%eax
  802b35:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b3a:	09 f0                	or     %esi,%eax
  802b3c:	8b 74 24 08          	mov    0x8(%esp),%esi
  802b40:	f7 34 24             	divl   (%esp)
  802b43:	d3 e6                	shl    %cl,%esi
  802b45:	89 74 24 08          	mov    %esi,0x8(%esp)
  802b49:	89 d6                	mov    %edx,%esi
  802b4b:	f7 e7                	mul    %edi
  802b4d:	39 d6                	cmp    %edx,%esi
  802b4f:	89 c1                	mov    %eax,%ecx
  802b51:	89 d7                	mov    %edx,%edi
  802b53:	72 3f                	jb     802b94 <__umoddi3+0x154>
  802b55:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802b59:	72 35                	jb     802b90 <__umoddi3+0x150>
  802b5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b5f:	29 c8                	sub    %ecx,%eax
  802b61:	19 fe                	sbb    %edi,%esi
  802b63:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b68:	89 f2                	mov    %esi,%edx
  802b6a:	d3 e8                	shr    %cl,%eax
  802b6c:	89 e9                	mov    %ebp,%ecx
  802b6e:	d3 e2                	shl    %cl,%edx
  802b70:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b75:	09 d0                	or     %edx,%eax
  802b77:	89 f2                	mov    %esi,%edx
  802b79:	d3 ea                	shr    %cl,%edx
  802b7b:	8b 74 24 10          	mov    0x10(%esp),%esi
  802b7f:	8b 7c 24 14          	mov    0x14(%esp),%edi
  802b83:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  802b87:	83 c4 1c             	add    $0x1c,%esp
  802b8a:	c3                   	ret    
  802b8b:	90                   	nop
  802b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b90:	39 d6                	cmp    %edx,%esi
  802b92:	75 c7                	jne    802b5b <__umoddi3+0x11b>
  802b94:	89 d7                	mov    %edx,%edi
  802b96:	89 c1                	mov    %eax,%ecx
  802b98:	2b 4c 24 0c          	sub    0xc(%esp),%ecx
  802b9c:	1b 3c 24             	sbb    (%esp),%edi
  802b9f:	eb ba                	jmp    802b5b <__umoddi3+0x11b>
  802ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	39 f5                	cmp    %esi,%ebp
  802baa:	0f 82 f1 fe ff ff    	jb     802aa1 <__umoddi3+0x61>
  802bb0:	e9 f8 fe ff ff       	jmp    802aad <__umoddi3+0x6d>
