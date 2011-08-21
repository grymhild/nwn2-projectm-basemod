/*
The_Puppeteer 11-26-10

sod_dor_unlockod

This script is intended for doors that are designed to be unlocked by bashing yet
reset for another player at a later time.  It will unlock and open doors when they
drop below 100 HP and heal them.
*/

void main()
{
	object oDoor = OBJECT_SELF;
	object oPC = GetLastDamager(oDoor);
	
	int nDoorMaxHP = GetMaxHitPoints(oDoor);
	int nDoorHP = GetCurrentHitPoints(oDoor);
	int nHPDiff = nDoorMaxHP - nDoorHP;
	
	if (nDoorHP < 100)
	{
		ActionUnlockObject(oDoor);
		ActionOpenDoor(oDoor);
		EffectHeal(nHPDiff);
	}
}