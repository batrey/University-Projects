//Authors:  Niall Smith

#include "VirtualMachine.h"
#include "Machine.h"
#include "string.h"
#include "stdlib.h"
#include <vector>
#include <queue>
#include <iostream>
using namespace std;

class TCB
{
    	public:
	TCB(TVMThreadEntry entry, void *param, TVMMemorySize memsize, TVMThreadPriority prio,TVMThreadID id)
	{
		tentry = entry;
		tparam = param;
		tmsize = memsize;
		tprio  = prio;
		tid    = id;
		tticks = 0;
	}


	TVMThreadID 		tid;		// to hold the threads ID, may be redundant, but might be easier to get
	TVMThreadPriority	tprio;		// for the threads priority
	TVMThreadState 		tstate;		// for thread stack
	TVMMemorySize 		tmsize;		// for stack size
	uint8_t * 		tstackPtr;	// this or another byte size type pointer for base of stack
	TVMThreadEntry 		tentry;		// for the threads entry function
	void * 			tparam;		// for the threads entry parameter
	SMachineContext 	tcontext;	// for the context to switch to/from the threadT
	TVMTick 		tticks;		// for the ticks that thread needs to wait
	int			result;		// Possibly need something to hold file return type
						// Possibly hold a pointer or ID of mutex waiting on
						// Possibly hold a list of held mutexes
};


extern "C" {TVMMainEntry VMLoadModule(const char *module);}
extern "C" {void VMUnloadModule(void);}
extern "C" {TVMStatus VMFilePrint(int filedescriptor, const char *format, ...);}
extern "C" {void alarmCallBack(void *param);}
extern "C" {void SkeletonEntry(void *param);}
extern "C" {void idle(void *param);}
extern "C" {void scheduler();}
extern "C" {void whichReadyQueue(TVMThreadID tid);}
extern "C" {void output();}

volatile unsigned int globalTick;
int runningThread;
TCB *idleThread;

#define VM_THREAD_PRIORITY_IDLE                  ((TVMThreadPriority)0x00)

std::vector <TCB*> threads;
std::queue<TVMThreadID> readyHigh;   
std::queue<TVMThreadID> readyNormal;   
std::queue<TVMThreadID> readyLow;   


extern "C"{

TVMStatus VMStart(int tickms, int machinetickms, int argc, char *argv[])
{

	TVMMainEntry entry = VMLoadModule( argv[0] );
	if (!entry)
		return VM_STATUS_FAILURE;

	
	MachineInitialize(machinetickms);
	MachineRequestAlarm(tickms *1000, alarmCallBack, NULL);
	MachineEnableSignals();

	TCB *mainThread = new TCB(NULL,NULL,0, VM_THREAD_PRIORITY_NORMAL, 0);
	threads.push_back(mainThread);
	threads[0]->tstate = VM_THREAD_STATE_RUNNING;
	runningThread = 0;

	idleThread = new TCB(NULL, NULL, 0x100000, VM_THREAD_PRIORITY_IDLE, 1);
	idleThread->tstate = VM_THREAD_STATE_READY;
	idleThread->tstackPtr = new uint8_t[idleThread->tmsize];
	MachineContextCreate(&(idleThread->tcontext), idle, idleThread->tparam, idleThread->tstackPtr, idleThread->tmsize);
	threads.push_back(idleThread);

	entry( argc, argv );
	MachineTerminate();

	return VM_STATUS_SUCCESS;
}

void alarmCallBack(void *param)
{

	if(globalTick > 0)
		--globalTick;
	
	int threads_size = threads.size();
	for(int i = 0; i < threads_size; i++)
	{	
		if(threads[i]->tticks > 0) 
		{
			threads[i]->tticks--;
			if (threads[i]->tticks == 0)
			{
				threads[i]->tstate = VM_THREAD_STATE_READY;
				whichReadyQueue(threads[i]->tid);
				scheduler();			
			}
		} 
	}
}




TVMStatus VMThreadCreate(TVMThreadEntry entry, void *param, TVMMemorySize memsize, TVMThreadPriority prio, TVMThreadIDRef tid)
{
	TMachineSignalState OldState;
    	MachineSuspendSignals(&OldState);

	if ((!entry) || (!tid))
	{
		return VM_STATUS_ERROR_INVALID_PARAMETER;
	}

	TCB* tcb = new TCB(entry,param,memsize,prio, threads.size());
	tcb->tstackPtr = new uint8_t[memsize];
	tcb->tstate = VM_THREAD_STATE_DEAD;
	*tid = tcb->tid;

	     

	MachineContextCreate(&(tcb->tcontext), tcb->tentry, tcb->tparam, tcb->tstackPtr, tcb->tmsize);

	threads.push_back(tcb);
	
	MachineResumeSignals(&OldState);
	return VM_STATUS_SUCCESS;
}
TVMStatus VMTThreadDelete(TVMThreadID thread)
{
	TMachineSignalState OldState;
	MachineSuspendSignals(&OldState);

	if (!threads[thread])
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_ID;
	}
	else if (threads[thread]->tstate !=  VM_THREAD_STATE_DEAD)
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_STATE;
	}

	delete threads[thread];
	threads[thread] = NULL;

	MachineResumeSignals(&OldState);
	return VM_STATUS_SUCCESS;
		
}
TVMStatus VMThreadActivate(TVMThreadID thread)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);

	


	if (!threads[thread])
	{
		return VM_STATUS_ERROR_INVALID_ID;
	}

	if (threads[thread] && threads[thread]->tstate != VM_THREAD_STATE_DEAD)
	{
		return VM_STATUS_ERROR_INVALID_STATE;
	}

	MachineContextCreate(&(threads[thread]->tcontext), SkeletonEntry, threads[thread]->tparam, 
	threads[thread]->tstackPtr, threads[thread]->tmsize);

	threads[thread]->tstate = VM_THREAD_STATE_READY;

	whichReadyQueue(thread);
	scheduler();

	MachineResumeSignals(&OldState);
	return VM_STATUS_SUCCESS;

}
TVMStatus VMThreadTerminate(TVMThreadID thread)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);

	if (!threads[thread])
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_ID;
	}
	else if (threads[thread] && (threads[thread]->tstate == VM_THREAD_STATE_DEAD))
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_STATE;
	}

	threads[thread]->tstate = VM_THREAD_STATE_DEAD;


	std::queue<TVMThreadID> copy;   
	if (threads[thread]->tprio == VM_THREAD_PRIORITY_HIGH)
	{
		int size = readyHigh.size();
		for (int i = 0; i < size; i++)
		{
			if (readyHigh.front() != thread)
			{
				copy.push(readyHigh.front());
				readyHigh.pop();
			}
			else
			{
				readyHigh.pop();
			}
			
			int size2 = copy.size();
			for (int j = 0; j < size2; j++)
			{
				readyHigh.push(copy.front());
				copy.pop();
			}
		}
	}
	else if (threads[thread]->tprio == VM_THREAD_PRIORITY_NORMAL)
	{
		int size = readyNormal.size();
		for (int i = 0; i < size; i++)
		{
			if (readyNormal.front() != thread)
			{
				copy.push(readyNormal.front());
				readyNormal.pop();
			}
			else
			{
				readyNormal.pop();
			}
			
			int size2 = copy.size();
			for (int j = 0; j < size2; j++)
			{
				readyNormal.push(copy.front());
				copy.pop();
			}
		}
	}
	else if (threads[thread]->tprio == VM_THREAD_PRIORITY_LOW)
	{
		int size = readyLow.size();
		for (int i = 0; i < size; i++)
		{
			if (readyLow.front() != thread)
			{
				copy.push(readyLow.front());
				readyLow.pop();
			}
			else
			{
				readyLow.pop();
			}
			
			int size2 = copy.size();
			for (int j = 0; j < size2; j++)
			{
				readyLow.push(copy.front());
				copy.pop();
			}
		}	
	}
	scheduler();
	
	MachineResumeSignals(&OldState);
	return VM_STATUS_SUCCESS;
}
TVMStatus VMThreadID(TVMThreadIDRef threadref)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);

	if (!threadref)
	{
		return VM_STATUS_ERROR_INVALID_PARAMETER;
	}

	threadref = (TVMThreadIDRef)runningThread;
	MachineResumeSignals(&OldState);
	return VM_STATUS_SUCCESS;
		
}

TVMStatus VMThreadDelete(TVMThreadID thread)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);

	if (!threads[thread])
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_ID;
	}
	else if (threads[thread] && threads[thread]->tstate != VM_THREAD_STATE_DEAD)
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_STATE;
	}

	//cout << "in VMThreadDelete. Deleting thread " << thread << endl;

	delete threads[thread];
	threads[thread] = NULL;

	MachineResumeSignals(&OldState);
	return VM_STATUS_SUCCESS;
}

TVMStatus VMThreadState(TVMThreadID thread, TVMThreadStateRef stateref)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);

	if (!threads[thread])
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_ID;
	}

	*stateref = threads[thread]->tstate;

	if (!stateref)
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_STATE;
	}
	
	MachineResumeSignals(&OldState);
	return VM_STATUS_SUCCESS;

}
TVMStatus VMThreadSleep(TVMTick tick)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);

	if (tick == VM_TIMEOUT_IMMEDIATE)
	{
		MachineResumeSignals(&OldState);
		//Yields remainder of quantum to equal priority program.
	}

	if (tick == VM_TIMEOUT_INFINITE)
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_ERROR_INVALID_PARAMETER;
	}

	globalTick = tick;

	//cout << "in vmthreadsleep."<<endl;

	threads[runningThread]->tstate = VM_THREAD_STATE_WAITING;
	threads[runningThread]->tticks = tick;

	//cout << "Running thread sleeping for " << tick << "ticks." << endl;

	scheduler();
	
	MachineResumeSignals(&OldState);
	return VM_STATUS_SUCCESS;
}
TVMStatus VMMutexCreate(TVMMutexIDRef mutexref)
{
	return VM_STATUS_SUCCESS;
}
TVMStatus VMMutexDelete(TVMMutexID mutex)
{
	return VM_STATUS_SUCCESS;
}
TVMStatus VMMutexQuery(TVMMutexID mutex, TVMThreadIDRef ownerref)
{	
	return VM_STATUS_SUCCESS;
}
TVMStatus VMMutexAcquire(TVMMutexID mutex, TVMTick timeout)
{
	return VM_STATUS_SUCCESS;
}   
TVMStatus VMMutexRelease(TVMMutexID mutex)
{
	return VM_STATUS_SUCCESS;
}

void MyFileCallback(void *calldata, int result)
{
 	TCB* temp = (TCB*)calldata;
    	temp->tstate = VM_THREAD_STATE_READY;
    	whichReadyQueue(temp->tid);
    	temp->result = result;
    	
		scheduler();
}

TVMStatus VMFileOpen(const char *filename, int flags, int mode, int *filedescriptor)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);


	if (filename == NULL || filedescriptor == NULL) 
	{
       		 return VM_STATUS_ERROR_INVALID_PARAMETER;
    	}

	threads[runningThread]->tstate = VM_THREAD_STATE_WAITING;
	MachineFileOpen(filename, flags, mode, MyFileCallback, threads[runningThread]);
	scheduler();

	*filedescriptor = threads[runningThread]->result;
        if (*filedescriptor == -1) 
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_FAILURE;
        }
        else 
	{
		MachineResumeSignals(&OldState);
        	return VM_STATUS_SUCCESS;
        }

}
TVMStatus VMFileClose(int filedescriptor)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);


	threads[runningThread]->tstate = VM_THREAD_STATE_WAITING;
	MachineFileClose(filedescriptor, MyFileCallback, threads[runningThread]);
	
	scheduler();

	if (threads[runningThread]->result == -1) 
	{
		MachineResumeSignals(&OldState);
       		return VM_STATUS_FAILURE;
   	}
   	else 
	{
		MachineResumeSignals(&OldState);
       		return VM_STATUS_SUCCESS;
   	}


}

TVMStatus VMFileRead(int filedescriptor, void *data, int *length)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);


	//cout << "In VMfileRead" << endl;

	threads[runningThread]->tstate = VM_THREAD_STATE_WAITING;
	MachineFileRead(filedescriptor, data, *length, MyFileCallback, threads[runningThread]);
	scheduler();
	*length = threads[runningThread]->result;

	if(*length > 0)
	{
		MachineResumeSignals(&OldState);
        	return VM_STATUS_SUCCESS;
    	}
    	else 
	{
		MachineResumeSignals(&OldState);
        	return VM_STATUS_FAILURE;
    	}


}
TVMStatus VMFileWrite(int filedescriptor, void *data, int *length)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);


	threads[runningThread]->tstate = VM_THREAD_STATE_WAITING;
	MachineFileWrite(filedescriptor, data, *length, MyFileCallback, threads[runningThread]);
	scheduler();

	if (threads[runningThread]->result != -1) 
	{
		MachineResumeSignals(&OldState);
        	return VM_STATUS_SUCCESS;
    	}
    	else 
	{
		MachineResumeSignals(&OldState);
       		return VM_STATUS_FAILURE;
    	}	

}
TVMStatus VMFileSeek(int filedescriptor, int offset, int whence, int *newoffset)
{
	TMachineSignalState OldState;
   	MachineSuspendSignals(&OldState);


	//cout << "In VMFileSeek" << endl;

	threads[runningThread]->tstate = VM_THREAD_STATE_WAITING;
	MachineFileSeek(filedescriptor, offset, whence, MyFileCallback, &(threads[runningThread]->tid));	
	scheduler();

	if(newoffset)
	{
       		*newoffset = threads[runningThread]->result;
		MachineResumeSignals(&OldState); 
		return VM_STATUS_SUCCESS;
	}
	else
	{
		MachineResumeSignals(&OldState);
		return VM_STATUS_FAILURE;
	}
       
}
   
void SkeletonEntry(void *param)
{

	TMachineSignalState OldState;
    	MachineSuspendSignals(&OldState);

	//cout << "skeleton" << endl;

    	MachineEnableSignals();
    	threads[runningThread]->tentry(threads[runningThread]->tparam);
    	
	VMThreadTerminate(threads[runningThread]->tid); // This will allow you to gain control back if the ActualThreadEntry returns
	MachineResumeSignals(&OldState);
}

void idle(void *param)
{	
	TMachineSignalState OldState;
    	MachineSuspendSignals(&OldState);

	//cout << "in idle function" << endl;

	MachineEnableSignals();

	while(1)
	{
		//cout << "idle" << endl;
	}

	//cout << "leaving idle function" << endl;
	MachineResumeSignals(&OldState);
}

void scheduler()
{
	TVMThreadPriority prio = threads[runningThread]->tprio;
	TVMThreadState state = threads[runningThread]->tstate;
	TVMThreadID thread;
	TVMThreadID oldThread;
	bool switching = false;

	//cout << "IN SCHEDULER" << endl;
	output();

	if ((prio == VM_THREAD_PRIORITY_IDLE) && (readyHigh.size() == 0 && readyNormal.size() == 0 && readyLow.size() == 0))
		return;

	else if((state == VM_THREAD_STATE_WAITING || state == VM_THREAD_STATE_DEAD) 
		&& (readyHigh.size() == 0 && readyNormal.size() == 0 && readyLow.size() == 0))
	{
		//cout << "Dead or waiting. Idle thread being swapped in." << endl;

		idleThread->tstate = VM_THREAD_STATE_RUNNING;
		oldThread = runningThread;
		runningThread = 1; //Idle Thread
		MachineContextSwitch(&(threads[oldThread]->tcontext), &(idleThread->tcontext));
	}
	
	else if ((state == VM_THREAD_STATE_WAITING || state == VM_THREAD_STATE_DEAD)
		&& (readyHigh.size() > 0 || readyNormal.size() > 0 || readyLow.size() > 0))
	{
		//cout << "Dead or waiting. Ready thread being swapped in." << endl;

		if(readyHigh.size() > 0)
		{
			thread = readyHigh.front();
			readyHigh.pop();
		}
		else if(readyNormal.size() > 0)
		{
			thread = readyNormal.front();
			readyNormal.pop();
		}
		else
		{
			thread = readyLow.front();
			readyLow.pop();
		}
		oldThread = runningThread;
		runningThread = thread;
		threads[runningThread]->tstate = VM_THREAD_STATE_RUNNING;
		MachineContextSwitch(&(threads[oldThread]->tcontext), &(threads[runningThread]->tcontext));
	}

	else if (prio == VM_THREAD_PRIORITY_IDLE)
	{
		//cout << "Idle thread being swapped for ready thread." << endl;

		if(readyHigh.size() > 0)
		{
			thread = readyHigh.front();
			readyHigh.pop();
		}
		else if(readyNormal.size() > 0)
		{
			thread = readyNormal.front();
			readyNormal.pop();
		}
		else
		{
			thread = readyLow.front();
			readyLow.pop();
		}
		
		runningThread = thread;
		threads[runningThread]->tstate = VM_THREAD_STATE_RUNNING;
		idleThread->tstate = VM_THREAD_STATE_READY;
		MachineContextSwitch(&(idleThread->tcontext), &(threads[runningThread]->tcontext));
	}

	else if (VM_THREAD_PRIORITY_HIGH > prio && readyHigh.size() > 0)
	{
		//cout << "High thread being swapped in for lower priority thread." << endl;

		threads[runningThread]->tstate = VM_THREAD_STATE_READY;
		thread = readyHigh.front();
		readyHigh.pop();
		switching = true;	
	}	
	else if (VM_THREAD_PRIORITY_NORMAL > prio && readyNormal.size() > 0)
	{
		//cout << "Normal thread being swapped in for lower priority thread." << endl;

		threads[runningThread]->tstate = VM_THREAD_STATE_READY;
		thread = readyNormal.front();	
		readyNormal.pop();
		switching = true;
	}

	if (switching)
	{
		//cout << "Switching" << endl;

		whichReadyQueue(runningThread);
		oldThread = runningThread;
		runningThread = thread;
		
		MachineContextSwitch(&(threads[oldThread]->tcontext), &(threads[runningThread]->tcontext));
		threads[runningThread]->tstate = VM_THREAD_STATE_RUNNING;

		
	}

	output();
}

void whichReadyQueue(TVMThreadID thread)
{
	//cout << "Which ready queue....threadID = " << thread << endl;

	if (threads[thread]->tprio == VM_THREAD_PRIORITY_HIGH)
		readyHigh.push(thread);
	else if (threads[thread]->tprio == VM_THREAD_PRIORITY_NORMAL)
		readyNormal.push(thread);
	else if (threads[thread]->tprio == VM_THREAD_PRIORITY_LOW)
		readyLow.push(thread);

	output();
}


void output()
{
	//cout << "**************************************************"<<endl;
	//cout << "output:" << endl;
	//cout << "Number Threads: "<< threads.size() << endl;
	//cout << "RunningThread: " << threads[runningThread]->tid << endl;
	//cout << "W/ Priority " << threads[runningThread]->tprio << " state: " << threads[runningThread]->tstate << endl;
	//cout << "Queues: "<< endl <<"readyHigh: " << readyHigh.size() << endl <<"readyNorm: " << readyNormal.size() << endl <<"readyLow:  " << readyLow.size() << endl<< "**************************************************"<<endl;
}


} //extern "C"