//::///////////////////////////////////////////////////////////////////////////
//::
//::	ga_lock.nss
//::
//::	Change the lock status of a door.  If bLock is false, the door will 
//::	be unlocked.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: EPF
//::	Created on: 3/7/06
//::
//::///////////////////////////////////////////////////////////////////////////

#include "_CSLCore_Messages"

void main(string sDoorTag, int bLock)
{
	object oDoor = CSLGetTarget(sDoorTag);

	SetLocked(oDoor, bLock);
}