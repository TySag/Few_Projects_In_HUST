// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/trap.h>
#include <kern/kdebug.h>
#include <kern/pmap.h>
#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

//str -> num based also can use strtol ?
int StrToNum(char *str,int base){
        int i,sum = 0;
        for(i=0;str[i]!='\0';i++){
        	if(base != 10&&i<2) continue;
              sum *= base;
              if(str[i]>='0'&&str[i]<='9') sum += (str[i]-'0');
              else if(str[i]>='a'&&str[i]<='f') sum += (str[i]+10-'a');
              else {cprintf("wrong input num ! \n");return 0;}
        }
        //cprintf(" set to be %d\n",sum);
        return sum;
}
//
static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "setcolor", "set the back color of the Os, Remember to add '0x'", mon_setcolor },
	{ "add", "add all num followed", mon_add },
	{ "produce", "mul all num followed", mon_mul },
	{ "backtrace", "show the function in the stack", mon_backtrace},
    { "showmappings", "Display in a useful format all of the physical page mappings", mon_showmappings},
    { "setmappings", " contents of memory given either a virtual or physical address", mon_setmappings}
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

unsigned read_eip();

int
mon_add(int argc, char **argv, struct Trapframe *tf){
       int sum = 0;
       int i;
       for(i=1;i<argc;i++){
       	sum += StrToNum(argv[i],10);
       }
       cprintf("the sum is %d\n",sum);
       return 0;
}
int
mon_mul(int argc, char **argv, struct Trapframe *tf){
       int sum = 1;
       int i;
       for(i=1;i<argc;i++){
       	sum *= StrToNum(argv[i],10);
       }
       cprintf("the produce is %d\n",sum);
       return 0;
}

int
mon_setcolor(int argc, char **argv, struct Trapframe *tf){
       if(argc<2||argc>2) cprintf("the argc wrong!\n");
       else {
            cprintf("set color to %s\n",argv[1]); 
            SetBackColor(StrToNum(argv[1],16));//test for strtol(argv,0,0)
            }
       return 0;
}

void 
showmappings(int32_t lva, int32_t hva){
	pte_t *pte;
	while(lva < hva){
		pte = pgdir_walk(boot_pgdir, (void *)lva, 0);
		cprintf("va : 0x%x -- 0x%x : ",lva, lva + PGSIZE);
		if(pte == NULL||!(*pte & PTE_P)) cprintf("Not Mapped\n");
		else{
			cprintf("pa: 0x%x  ",PTE_ADDR(*pte));
			if(*pte & PTE_U) cprintf("User ");
			else cprintf("Kernel ");
			if(*pte & PTE_W) cprintf("Read/Write");
			else cprintf("Read Only");
			cprintf("\n");
		}
		lva += PGSIZE;
	}
}
int
mon_showmappings(int argc, char **argv, struct Trapframe *tf){
	if(argc != 3){
		cprintf("Hit: showmappings [LOWER_ADDR] [HIGHER_ADDER]\n");
		return 0;
	}
	uint32_t lva = strtol(argv[1], 0, 0);
	uint32_t hva = strtol(argv[2], 0, 0);
	
	if(lva != ROUNDUP(lva, PGSIZE)||
	   hva != ROUNDUP(hva, PGSIZE)||
	   lva > hva){
		cprintf("showmappings : Invalid address\n");
		cprintf("Both address must be aligned in 4KB\n");
		return 0;
	}
	showmappings(lva, hva);
	return 0;
}

void setmappings(uint32_t va, uint32_t memsize, uint32_t pa, int perm){
	uint32_t offset;
	for(offset = 0; offset < memsize; offset += PGSIZE){
		page_insert(boot_pgdir, pa2page(pa + offset), (void *)va + offset, perm);
	}
}
int 
mon_setmappings(int argc, char **argv, struct Trapframe *tf){
	if (argc != 5) {
		cprintf ("Usage: setmappings [VIRTUAL_ADDR] [PAGE_NUM] [PHYSICAL_ADDR] [PERMISSION]\n");
		cprintf ("Both virtual address and physical address must be aligned in 4KB\n");
		cprintf ("Permission is one of 4 options ('ur', 'uw', 'kr', 'kw')\n");
		cprintf ("u stands for user mode, k for kernel mode\n");
		cprintf ("\nMake sure that the physical memory space has already been mounted before\n");
		return 0;
	}
	uint32_t va = strtol(argv[1], 0, 0);
	uint32_t pa = strtol(argv[3], 0, 0);
	uint32_t perm = 0;
	uint32_t memsize = strtol(argv[2], 0, 0) * PGSIZE;
	
	if(va != ROUNDUP(va, PGSIZE)||
	   pa != ROUNDUP(pa, PGSIZE)||
	   va > ~0 - memsize
	  ){
		  cprintf("argc error\n");
		  return 0;
	}
	uint32_t offset;
	struct Page *pp;
	for(offset = 0;offset < memsize; offset += PGSIZE){
		pp = pa2page(pa + offset);
		if(pp->pp_ref == 0){
			cprintf("unmounted physical page: %x - %x\n",pa + offset, pa + offset + PGSIZE);
			return 0;
		}
	}
	if(argv[4][0] == 'u'){
		perm |= PTE_U;
	}
	if(argv[4][1] == 'w'){
		perm |= PTE_W;
	}
	setmappings(va, memsize, pa, perm);
	cprintf("set memory mapping ok\n");
	showmappings(va, va + memsize);
	return 0;
}


/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		(end-_start+1023)/1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	uint32_t ebp = read_ebp(), *p, eip, i;
    struct Eipdebuginfo bug;
    while (ebp > 0) {
        p = (uint32_t *)ebp;
        eip = p[1];
        cprintf("ebp %x ,eip %x args", ebp, eip);
        for (i = 2; i < 6; i++) {
             cprintf(" %08x,  ", p[i]);
        }
        debuginfo_eip(eip, &bug);
        cprintf("\n\t%s : %d : ", bug.eip_file, bug.eip_line);
        for (i = 0; i < bug.eip_fn_namelen; i++)
            cputchar(bug.eip_fn_name[i]);//the same to the name 
        //cprintf(" %s ",bug.eip_fn_name);
        cprintf("+%d\n", eip - bug.eip_fn_addr);
        ebp = *p;
    }
    return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	//cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("%CredWelcome %Cwhtto %Cgrnthe %CorgJOS %Cgrykernel %Cpurmonitor!\n");
	//cprintf("%x %CredWelcome\n",BackColor);
	//cprintf("%x %Cwhtto\n",BackColor);
	//cprintf("%x %Cgrnthe\n",BackColor);
	//cprintf("%x %CorgJOS\n",BackColor);
	
	cprintf("%CwhtType 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}

// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
	return callerpc;
}
