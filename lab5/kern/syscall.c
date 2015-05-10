/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/syscall.h>
#include <kern/console.h>
#include <kern/sched.h>

// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
	
	// LAB 3: Your code here.
    user_mem_assert(curenv, s, len, PTE_U);//env s.begin s.len power
	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
}

// Read a character from the system console.
// Returns the character.
static int
sys_cgetc(void)
{
	int c;

	// The cons_getc() primitive doesn't wait for a character,
	// but the sys_cgetc() system call does.
	while ((c = cons_getc()) == 0)
		/* do nothing */;

	return c;
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
}

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;
	env_destroy(e);
	return 0;
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.
	
	// LAB 4: Your code here.
	struct Env *newenv;
	int r;
	if((r = env_alloc(&newenv, sys_getenvid())) < 0) return r;
	
	//set not runnable
	newenv->env_status = ENV_NOT_RUNNABLE;
	//copy tf
	newenv->env_tf = curenv->env_tf;
	//copy the page fault hander
	//newenv->env_pgfault_upcall = curenv->env_pgfault_upcall;
	//make the child env's return to 0
	newenv->env_tf.tf_regs.reg_eax = 0;	
	return newenv->env_id;
	//panic("sys_exofork not implemented");
}

//set the SYS_env_set_priority
static int
sys_env_set_priority(envid_t envid, int priority)
{
	/*
	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE){
		return -E_INVAL;
	}*/
	struct Env *env_pri;
	int r;
	//look for envs by id
	if((r = envid2env(envid, &env_pri, 1)) < 0) return r;
	
	env_pri->env_priority = priority;
	
	return 0;
}

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
  	// Hint: Use the 'envid2env' function from kern/env.c to translate an
  	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.
	
	// LAB 4: Your code here.
	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE){
		return -E_INVAL;
	}
	struct Env *env_sta;
	int r;
	//look for envs by id
	if((r = envid2env(envid, &env_sta, 1)) < 0) return r;
	
	env_sta->env_status = status;
	
	return 0;
	//panic("sys_env_set_status not implemented");
}

// Set envid's trap frame to 'tf'.
// tf is modified to make sure that user environments always run at code
// protection level 3 (CPL 3) with interrupts enabled.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	// LAB 4: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	struct Env *env_tf;
	int r;
	if((r = envid2env(envid, &env_tf, 1)) < 0) return -E_BAD_ENV;
	user_mem_assert (env_tf, tf, sizeof (struct Trapframe), PTE_U);
	env_tf->env_tf.tf_cs = GD_UT | 3;
    env_tf->env_tf.tf_eflags |= FL_IF;
	env_tf->env_tf = *tf;
	return 0;
	//panic("sys_set_trapframe not implemented");
}

// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	struct Env *env;
	if(envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
	
	env->env_pgfault_upcall = func;
	return 0;
	
	//panic("sys_env_set_pgfault_upcall not implemented");
}

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
	if(va >= (void *)UTOP) return -E_INVAL;//beyond
	if(ROUNDUP(va, PGSIZE) != va) return -E_INVAL;//page-aligned
	if((perm & PTE_U)==0||(perm & PTE_P)==0) return -E_INVAL;//power
	if((perm & ~PTE_USER) > 0) return -E_INVAL;//?
	
	struct Env *e;
	if(envid2env(envid, &e, 1) < 0) return -E_BAD_ENV;//environment envid doesn't currently
	
	struct Page *pg;
	if(page_alloc(&pg) < 0) return -E_NO_MEM;
	if(page_insert(e->env_pgdir, pg, va, perm) < 0){
		page_free(pg);//free it
		return -E_NO_MEM;
	}
	memset(page2kva(pg), 0, PGSIZE);
	return 0;
	//panic("sys_page_alloc not implemented");
}

// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
	if(srcva >= (void *)UTOP) return -E_INVAL;
	if(ROUNDUP(srcva, PGSIZE) != srcva) return -E_INVAL;
	if(dstva >= (void *)UTOP) return -E_INVAL;
	if(ROUNDUP(dstva, PGSIZE) != dstva) return -E_INVAL;
	if((perm & PTE_U)==0&&(perm & PTE_P)==0) return -E_INVAL;
	if((perm & ~PTE_USER) > 0) return -E_INVAL;
	
	struct Env *srcenv;
	if(envid2env(srcenvid, &srcenv, 1) < 0) return -E_BAD_ENV;
	struct Env *dstenv;
	if(envid2env(dstenvid, &dstenv, 1) < 0) return -E_BAD_ENV;
	
	pte_t *pte;
	struct Page *pg;
	pg = page_lookup(srcenv->env_pgdir, srcva, &pte);
	if(pg == NULL||((perm & PTE_W)&&((*pte & PTE_W)==0))) return -E_INVAL;
	
	if(page_insert(dstenv->env_pgdir, pg, dstva, perm) < 0)
	   return -E_NO_MEM;
	
	return 0;
	//panic("sys_page_map not implemented");
}

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().
	// LAB 4: Your code here.
	if(va >= (void *)UTOP) return -E_INVAL;
	if(ROUNDUP(va, PGSIZE) != va) return -E_INVAL;
	
	struct Env *env;
	if(envid2env(envid, &env, 1) < 0) return -E_BAD_ENV;
	
	page_remove(env->env_pgdir, va);
	
	return 0;
	//panic("sys_page_unmap not implemented");
}

// Try to send 'value' to the target env 'envid'.
// If va != 0, then also send page currently mapped at 'va',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target has not requested IPC with sys_ipc_recv.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused ipc_recv system call.
//
// If the sender sends a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc doesn't happen unless no errors occur.
//
// Returns 0 on success where no page mapping occurs,
// 1 on success where a page mapping occurs, and < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.
	struct Env *dstenv;
	int r;
	if((r = envid2env(envid, &dstenv, 0)) < 0) return -E_BAD_ENV;
	if(!dstenv->env_ipc_recving || dstenv->env_ipc_from != 0) return -E_IPC_NOT_RECV;
	if((srcva < (void *)UTOP) && ROUNDDOWN(srcva, PGSIZE) != srcva){//receive a page of data
	    //cprintf("this page is not page-aligned\n");
	    return -E_INVAL;
	     //panic("this page is not page-aligned\n");
	}
	//cprintf("this page is page-aligned\n");
	if(srcva < (void *)UTOP){
		if((perm & PTE_U) == 0 && (perm & PTE_P) == 0) return -E_INVAL;
		if((perm & ~PTE_USER) > 0) return -E_INVAL;
	}
	//cprintf("perm normol\n");
	pte_t *pte;
	struct Page *pg;
	//not mapped in current env
	if(srcva < (void *)UTOP){
		if((pg = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL) return -E_INVAL;
		if((*pte & PTE_W) == 0 && (perm & PTE_W) > 0) return -E_INVAL;
	}
	//if env_ipc_dstva != 0 , send a page
	if(srcva >= (void *)UTOP) dstenv->env_ipc_perm = 0;
	if(srcva < (void *)UTOP && dstenv->env_ipc_dstva <(void *)UTOP){//!= 0
		if(page_insert(dstenv->env_pgdir, pg, dstenv->env_ipc_dstva, perm) < 0) return -E_NO_MEM;
		dstenv->env_ipc_perm = perm;
	}
	dstenv->env_ipc_recving = 0;
	dstenv->env_ipc_from = curenv->env_id;
	dstenv->env_ipc_value = value;
	dstenv->env_status = ENV_RUNNABLE;
	//dstenv->env_tf.tf_regs.reg_eax = 0;
	return 0;
	//panic("sys_ipc_try_send not implemented");
}

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
	if((dstva < (void *)UTOP) && ROUNDDOWN(dstva, PGSIZE) != dstva){//receive a page of data
	     panic("this page is not page-aligned\n");
	     return -E_INVAL;
	     //panic("this page is not page-aligned\n");
	}
	curenv->env_ipc_dstva = dstva;
	curenv->env_ipc_recving = 1;//wait for recv
	curenv->env_ipc_from = 0;
	curenv->env_status = ENV_NOT_RUNNABLE;
	curenv->env_tf.tf_regs.reg_eax = 0;
	//why from is 0;
	sched_yield();
	//panic("sys_ipc_recv not implemented");
	return 0;
}


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
    int32_t r = 0;
    switch(syscallno){//choose different no
        //output 1
        case SYS_cputs:
            sys_cputs((const char*)a1, (size_t)a2); break;
        //input 2
        case SYS_cgetc:
            r = sys_cgetc(); break;
        //get pid 3
        case SYS_getenvid:
            r = sys_getenvid(); break;
        //distroy a env 4
        case SYS_env_destroy:
            r = sys_env_destroy((envid_t)a1); break;
        //make another one 5
        case SYS_yield: sys_yield(); return 0;
        //fork a env 6
        case SYS_exofork:
            r = sys_exofork(); break;
        //set status 7
        case SYS_env_set_status: 
            r = sys_env_set_status((envid_t)a1, (int)a2); 
            break;
        //set trapframe 8
        case SYS_env_set_trapframe: 
            r = sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2); 
            break;
        //set pgfault call 9
        case SYS_env_set_pgfault_upcall:
            r = sys_env_set_pgfault_upcall((envid_t)a1, (void *)a2);
            break;
        //page alloc 10
        case SYS_page_alloc: 
            r = sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
            break;
        //page map 11
        case SYS_page_map: 
            r = sys_page_map((envid_t)a1, (void *)a2, (envid_t)a3, (void *)a4, (int)a5);
            break;
        //page unmap 12
        case SYS_page_unmap: 
            r = sys_page_unmap((envid_t)a1, (void *)a2);
            break;
        // 13
        case SYS_ipc_try_send: 
            r = sys_ipc_try_send((envid_t)a1, (uint32_t)a2, (void *)a3, (unsigned)a4);
            break;
        // 14
        case SYS_ipc_recv:
            r = sys_ipc_recv((void *)a1);
            break;
        // 15
        case SYS_env_set_priority:
            r = sys_env_set_priority((envid_t)a1, (int)a2);
            break;
        default: r = -E_INVAL;
    }
    return r;
	//panic("syscall not implemented");
}

