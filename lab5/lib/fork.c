// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;
	//cprintf("%x \n", utf->utf_err);
	//err = 14;
	//cprintf("%x \n", (uintptr_t)addr);
	//cprintf("%x \n", (uint32_t)(*addr));
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//FEC_WR pf caused by a write
	//
	//if((err & FEC_WR)==0) cprintf("err : %08x\n", err);
	//if((vpt[VPN(addr)] & PTE_COW) == 0) cprintf("pte : %x\n", vpt[VPN(addr)]);
    if((err & FEC_WR) == 0 || (vpd[VPD(addr)] & PTE_P) == 0 || (vpt[VPN(addr)] & PTE_COW) == 0){
		//cprintf("\n%e %e %e\n",(err & FEC_WR), (vpd[VPD(addr)] & PTE_P), (vpt[VPN(addr)] & PTE_COW));
		panic("pgfault: not a write or attempting to access a non_COW page\n");
	}
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if((r = sys_page_alloc(0, (void *)PFTEMP, PTE_U|PTE_P|PTE_W)) < 0){
		panic("pgfault page allocation failed : %e\n", r);
	}
	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, addr, PGSIZE);
	
	if((r = sys_page_map(0, PFTEMP, 0, addr, PTE_U|PTE_P|PTE_W)) < 0){
		panic("pgfault: page mapping failed %e\n", r);
	}
	//panic("pgfault not implemented");
}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why mark ours copy-on-write again
// if it was already copy-on-write?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
// COW's copy
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	void *addr;
	pte_t pte;
    addr = (void *)((uint32_t)pn * PGSIZE);
    pte = vpt[VPN(addr)];//the pt
    
    if((pte & PTE_W) > 0||(pte & PTE_COW) > 0){
		//two change ok
		if((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0){
			panic("sys page map envid --> 0 failed ,parent copy to child\n");
			}
		if((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0){
			panic("sys page map 0 --> 0 failed ,parent copy it self\n");
			}
	}
	else{//the read, can't change  |PTE_COW
		if((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U)) < 0){
			panic("sys page map envid --> 0 failed ,parent copy to child\n");
			}
	}
	// LAB 4: Your code here.
	//panic("duppage not implemented");
	return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use vpd, vpt, and duppage.
//   Remember to fix "env" and the user exception stack in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	//
	//set_pgfault_handler
	set_pgfault_handler(pgfault);
	
	//cprintf("finish set pgfault handler\n");
	//new a child
	envid_t newenv;
	uint32_t addr;
	int r;
	
	newenv = sys_exofork();//new envid
	//cprintf("finish create a env %d\n", newenv);
	if(newenv < 0) panic("envid < 0 ,failed in exofork\n");
	if(newenv == 0){
		//ENVX get the id's low 10 bit
		env = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
		/*pte = vpt[VPN(addr)];
		pde = vpd[VPD(addr)];
		if((pde & PTE_P) > 0 && (pte & PTE_P) > 0 && (pte & PTE_U) > 0){
			duppage(newenv, VPN(addr));
			}*/
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
	        duppage (newenv, VPN(addr));
		}
	//cprintf("finish map PGSIZE\n");
	//user exception stack
	if((r = sys_page_alloc(newenv, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0){
		panic("fork alloc page failed\n");
		}
	//
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(newenv, _pgfault_upcall);
	//panic("fork not implemented");
	//set it runable
	if((r = sys_env_set_status(newenv, ENV_RUNNABLE)) < 0){
		panic("set runnable failed\n");
		}
	
	return newenv;
}

// Challenge!

static int
sduppage(envid_t envid, unsigned pn, int need_cow)
{
	int r;
	void * addr = (void *) ((uint32_t) pn * PGSIZE);
	pte_t pte = vpt[VPN(addr)];
	if(need_cow || (pte & PTE_COW) > 0) {
		if((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P|PTE_COW)) < 0)
		    panic ("duppage: page re-mapping failed at 1 : %e", r);
        if((r = sys_page_map (0, addr, 0, addr, PTE_U|PTE_P|PTE_COW)) < 0)
            panic ("duppage: page re-mapping failed at 2 : %e", r);
    }else if ((pte & PTE_W) > 0) {
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_W|PTE_P)) < 0)
		    panic ("duppage: page re-mapping failed at 3 : %e", r);
    }else {
		if ((r = sys_page_map (0, addr, envid, addr, PTE_U|PTE_P)) < 0)
		    panic ("duppage: page re-mapping failed at 4 : %e", r);
    }
    return 0;
}


int
sfork(void)
{
	//panic("sfork not implemented");
	//set_pgfault_handler
	set_pgfault_handler(pgfault);
	
	//cprintf("finish set pgfault handler\n");
	//new a child
	envid_t newenv;
	uint32_t addr;
	int r;
	
	newenv = sys_exofork();//new envid
	//cprintf("finish create a env %d\n", newenv);
	if(newenv < 0) panic("envid < 0 ,failed in exofork\n");
	if(newenv == 0){
		//ENVX get the id's low 10 bit
		env = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	//map all the page (W or COW) to COW
	//duppage(newenv, 1);
	//pte_t pte;
	//pde_t pde;
	//scan from UTEXT to UXSTACKTOP - PGSIZE
	int mark_COW = 1;
	for(addr = UTEXT; addr < UXSTACKTOP - PGSIZE; addr += PGSIZE){
		/*pte = vpt[VPN(addr)];
		pde = vpd[VPD(addr)];
		if((pde & PTE_P) > 0 && (pte & PTE_P) > 0 && (pte & PTE_U) > 0){
			duppage(newenv, VPN(addr));
			}*/
	    if((vpd[VPD(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_P) > 0 && (vpt[VPN(addr)] & PTE_U) > 0)
	        sduppage (newenv, VPN(addr), mark_COW);
		else mark_COW = 0;
	}
	//cprintf("finish map PGSIZE\n");
	//user exception stack
	if((r = sys_page_alloc(newenv, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0){
		panic("fork alloc page failed\n");
		}
	//
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(newenv, _pgfault_upcall);
	//panic("fork not implemented");
	//set it runable
	if((r = sys_env_set_status(newenv, ENV_RUNNABLE)) < 0){
		panic("set runnable failed\n");
		}
	
	return newenv;
}
