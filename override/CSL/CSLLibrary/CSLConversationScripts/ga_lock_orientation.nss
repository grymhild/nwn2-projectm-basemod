// ga_lock_orientation
//
// Lock orientation of sTarget.  bLock = FALSE will unlock.
	
// EPF 7/11/07
	
#include "_CSLCore_Messages"
	
void main(string sTarget, int bLock)
{
	SetOrientOnDialog(CSLGetTarget(sTarget), !bLock);
}
