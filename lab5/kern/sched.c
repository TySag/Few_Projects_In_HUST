#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>


// Choose a user environment to run and run it.
void
sched_yield(void)
{
	// Implement simple round-robin scheduling.
	// Search through 'envs' for a runnable environment,
	// in circular fashion starting after the previously running env,
	// and switch to the first such environment found.
	// It's OK to choose the previously running env if no other env
	// is runnable.
	// But never choose envs[0], the idle environment,
	// unless NOTHING else is runnable.

	// LAB 4: Your code here.
	struct Env *able;// = NULL;
    struct Env *run = curenv;
    if(curenv == NULL){
        run = envs;
    }
    int round = 0;
    int level = 21;//the highest
    /*
    for(run = run+1; round<NENV; run++,round++){
        if(run >= envs+NENV){
            run = envs+1;
        }
        if(run->env_status == ENV_RUNNABLE){
			env_run(run);
        }
    }
    */
    for(able = run+1; round<NENV; able++,round++){
        if(able >= envs+NENV){
            able = envs+1;
        }
        if(able->env_status == ENV_RUNNABLE){
			if(level > able->env_priority){
				run = able;//decide to run
				level = able->env_priority;
			}
        }
	}
	if(level<21){//there must be some one can be run
	    env_run(run);
	}
	// Run the special idle environment when nothing else is runnable.
	if (envs[0].env_status == ENV_RUNNABLE)
		env_run(&envs[0]);
	else {
		cprintf("Destroyed all environments - nothing more to do!\n");
		while (1)
			monitor(NULL);
	}
}
