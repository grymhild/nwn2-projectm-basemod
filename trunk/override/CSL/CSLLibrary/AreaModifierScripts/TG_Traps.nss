///////////////////////////////////////////////////////
// The Depths Custom Traps
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// Determines the Base Save DC for a Trap

#include "_SCInclude_Trap"

int DEP_GetBaseSave(int TrapType);


void main()
{
	int nBaseType = GetTrapBaseType(OBJECT_SELF);
	int nSaveDC;
	
	// SPIKE TRAPS //
	if (nBaseType == DTRAP_MINOR_SPIKE)		{nSaveDC = DEP_GetBaseSave(1); DEP_DoTrapSpike(d6(3), nSaveDC); return;}
	if (nBaseType == DTRAP_AVERAGE_SPIKE)	{nSaveDC = DEP_GetBaseSave(2); DEP_DoTrapSpike(d6(5), nSaveDC); return;}
	if (nBaseType == DTRAP_STRONG_SPIKE)	{nSaveDC = DEP_GetBaseSave(3); DEP_DoTrapSpike(d6(10), nSaveDC); return;}
	if (nBaseType == DTRAP_DEADLY_SPIKE)	{nSaveDC = DEP_GetBaseSave(4); DEP_DoTrapSpike(d6(25), nSaveDC); return;}
	
	// ELECTRICAL TRAPS //
	// 15 Ft Radius AoE
	if (nBaseType == DTRAP_MINOR_ELECT)		{nSaveDC = DEP_GetBaseSave(1); DEP_TrapDoElectricalDamage(d6(3) ,nSaveDC,3); return;}
	if (nBaseType == DTRAP_AVERAGE_ELECT) 	{nSaveDC = DEP_GetBaseSave(2); DEP_TrapDoElectricalDamage(d6(15),nSaveDC,4); return;}
	if (nBaseType == DTRAP_STRONG_ELECT)	{nSaveDC = DEP_GetBaseSave(3); DEP_TrapDoElectricalDamage(d6(20),nSaveDC,5); return;}
	if (nBaseType == DTRAP_DEADLY_ELECT)	{nSaveDC = DEP_GetBaseSave(4); DEP_TrapDoElectricalDamage(d6(30),nSaveDC,6); return;}
	if (nBaseType == DTRAP_FATAL_ELECT)		{nSaveDC = DEP_GetBaseSave(5); DEP_TrapDoElectricalDamage(d6(40),nSaveDC,6); return;}
	if (nBaseType == DTRAP_EPIC_ELECT)		{nSaveDC = DEP_GetBaseSave(6); DEP_TrapDoElectricalDamage(d6(60),nSaveDC,6); return;}
	if (nBaseType == DTRAP_EPIC_ELECT2)		{nSaveDC = DEP_GetBaseSave(6); DEP_TrapDoElectricalDamage(d6(60),nSaveDC,6); return;}
	// FIRE TRAPS //
	// 10 Ft Radius AoE
	if (nBaseType == DTRAP_MINOR_FIRE)		{nSaveDC = DEP_GetBaseSave(1); DEP_TrapDoFireDamage(d6(3), nSaveDC); return;}
	if (nBaseType == DTRAP_AVERAGE_FIRE)	{nSaveDC = DEP_GetBaseSave(2); DEP_TrapDoFireDamage(d6(8), nSaveDC); return;}
	if (nBaseType == DTRAP_STRONG_FIRE)		{nSaveDC = DEP_GetBaseSave(3); DEP_TrapDoFireDamage(d6(15), nSaveDC); return;}
	if (nBaseType == DTRAP_DEADLY_FIRE)		{nSaveDC = DEP_GetBaseSave(4); DEP_TrapDoFireDamage(d6(25), nSaveDC); return;}
	if (nBaseType == DTRAP_FATAL_FIRE)		{nSaveDC = DEP_GetBaseSave(5); DEP_TrapDoFireDamage(d6(30), nSaveDC); return;}
	if (nBaseType == DTRAP_EPIC_FIRE)		{nSaveDC = DEP_GetBaseSave(6); DEP_TrapDoFireDamage(d6(50), nSaveDC); return;}
	if (nBaseType == DTRAP_EPIC_FIRE2)		{nSaveDC = DEP_GetBaseSave(6); DEP_TrapDoFireDamage(d6(50), nSaveDC); return;}
	
	
	// COLD TRAPS //
	// DEP_TrapDoColdDamage(nDamage, nSaveDC, nPara_Duration)
	if (nBaseType == DTRAP_MINOR_COLD)		{nSaveDC = DEP_GetBaseSave(1); DEP_TrapDoColdDamage(d4(2), nSaveDC, 1); return;}
	if (nBaseType == DTRAP_AVERAGE_COLD)	{nSaveDC = DEP_GetBaseSave(2); DEP_TrapDoColdDamage(d4(3), nSaveDC, 2); return;}
	if (nBaseType == DTRAP_STRONG_COLD)		{nSaveDC = DEP_GetBaseSave(3); DEP_TrapDoColdDamage(d4(5), nSaveDC, 2); return;}
	if (nBaseType == DTRAP_DEADLY_COLD)		{nSaveDC = DEP_GetBaseSave(4); DEP_TrapDoColdDamage(d4(20), nSaveDC, 4); return;}
	if (nBaseType == DTRAP_EPIC_COLD)		{nSaveDC = DEP_GetBaseSave(6); DEP_TrapDoColdDamage(d4(40), nSaveDC, 4); return;}
	
	// HOLY TRAPS //
	// DEP_TrapDoColdDamage(nDamage, UndeadDam)
	// No Save in current script.  Has some type of attack roll that's not even used.
	if (nBaseType == DTRAP_MINOR_HOLY)		{DEP_TrapDoHolyDamage(d4(2), d10(4)); return;}
	if (nBaseType == DTRAP_AVERAGE_HOLY)	{DEP_TrapDoHolyDamage(d4(3), d10(5)); return;}
	if (nBaseType == DTRAP_STRONG_HOLY)		{DEP_TrapDoHolyDamage(d4(6), d10(8)); return;}
	if (nBaseType == DTRAP_DEADLY_HOLY)		{DEP_TrapDoHolyDamage(d4(9), d10(12)); return;}
	if (nBaseType == DTRAP_FATAL_HOLY)		{DEP_TrapDoHolyDamage(d4(12), d10(16)); return;}
	if (nBaseType == DTRAP_EPIC_HOLY)		{DEP_TrapDoHolyDamage(d4(16), d10(20)); return;}
	
	// TANGLE TRAPS //
	// Targets within 10ft of the entering character are slowed
	// DEP_TrapDoTangleDamage(nSaveDC, nDuration)
	if (nBaseType == DTRAP_MINOR_TANGLE)	{DEP_TrapDoTangleDamage(20, 3); return;}
	if (nBaseType == DTRAP_AVERAGE_TANGLE)	{DEP_TrapDoTangleDamage(25, 4); return;}
	if (nBaseType == DTRAP_STRONG_TANGLE)	{DEP_TrapDoTangleDamage(30, 4); return;}
	if (nBaseType == DTRAP_DEADLY_TANGLE)	{DEP_TrapDoTangleDamage(35, 5); return;}
	
	// ACID BLOD TRAPS //
	// Target is hit with a blob of acid that does damage & holds the target.  Can make a Reflex save to avoid the hold effect only.
	// DEP_TrapDoAcidDamage(int nDamage, int nSaveDC, int nDuration)
	if (nBaseType == DTRAP_MINOR_ACID)		{nSaveDC = DEP_GetBaseSave(1); DEP_TrapDoAcidDamage(d6(3), nSaveDC, 2); return;}
	if (nBaseType == DTRAP_AVERAGE_ACID)	{nSaveDC = DEP_GetBaseSave(2); DEP_TrapDoAcidDamage(d6(6), nSaveDC, 3); return;}
	if (nBaseType == DTRAP_STRONG_ACID)		{nSaveDC = DEP_GetBaseSave(3); DEP_TrapDoAcidDamage(d6(12), nSaveDC, 4); return;}
	if (nBaseType == DTRAP_DEADLY_ACID)		{nSaveDC = DEP_GetBaseSave(4); DEP_TrapDoAcidDamage(d6(18), nSaveDC, 5); return;}
	if (nBaseType == DTRAP_FATAL_ACID)		{nSaveDC = DEP_GetBaseSave(5); DEP_TrapDoAcidDamage(d6(22), nSaveDC, 5); return;}
	if (nBaseType == DTRAP_EPIC_ACID)		{nSaveDC = DEP_GetBaseSave(6); DEP_TrapDoAcidDamage(d6(30), nSaveDC, 5); return;}
	
	// ACID SPLASH TRAPS //
	// Target is hit with a blob of acid that does damage & holds the target.  Can make a Reflex save to avoid the hold effect only.
	// DEP_TrapDoAcidSplash(int nDamage, int nSaveDC)
	if (nBaseType == DTRAP_MINOR_ACIDSPLH)		{nSaveDC = DEP_GetBaseSave(1); DEP_TrapDoAcidSplash(d8(2), nSaveDC); return;}
	if (nBaseType == DTRAP_AVERAGE_ACIDSPLH)	{nSaveDC = DEP_GetBaseSave(2); DEP_TrapDoAcidSplash(d8(3), nSaveDC); return;}
	if (nBaseType == DTRAP_STRONG_ACIDSPLH)		{nSaveDC = DEP_GetBaseSave(3); DEP_TrapDoAcidSplash(d8(5), nSaveDC); return;}
	if (nBaseType == DTRAP_DEADLY_ACIDSPLH)		{nSaveDC = DEP_GetBaseSave(4); DEP_TrapDoAcidSplash(d8(15), nSaveDC); return;}
	
	// Sonic Traps  //
	// Damage Plus Stun, Will Save vrs Stun only
	// DEP_TrapDoSonicDamage(int nDamage, int nSaveDC, int nDuration)
	if (nBaseType == DTRAP_MINOR_SONIC)		{nSaveDC = DEP_GetBaseSave(1); DEP_TrapDoSonicDamage(d6(2), nSaveDC, 2); return;}
	if (nBaseType == DTRAP_AVERAGE_SONIC) 	{nSaveDC = DEP_GetBaseSave(2); DEP_TrapDoSonicDamage(d4(3), nSaveDC, 2); return;}
	if (nBaseType == DTRAP_STRONG_SONIC)	{nSaveDC = DEP_GetBaseSave(3); DEP_TrapDoSonicDamage(d4(5), nSaveDC, 3); return;}
	if (nBaseType == DTRAP_DEADLY_SONIC)	{nSaveDC = DEP_GetBaseSave(4); DEP_TrapDoSonicDamage(d4(8), nSaveDC, 4); return;}
	if (nBaseType == DTRAP_FATAL_SONIC)		{nSaveDC = DEP_GetBaseSave(5); DEP_TrapDoSonicDamage(d4(12), nSaveDC, 2); return;}
	if (nBaseType == DTRAP_EPIC_SONIC)		{nSaveDC = DEP_GetBaseSave(6); DEP_TrapDoSonicDamage(d4(40), nSaveDC, 4); return;}
	if (nBaseType == DTRAP_EPIC_SONIC2)		{nSaveDC = DEP_GetBaseSave(6); DEP_TrapDoSonicDamage(d4(40), nSaveDC, 4); return;}
	
	// Negative Traps //
	//DEP_TrapDoNegativeDamage(int nDamage, int nSaveDC, int nStr_Reduction
	if (nBaseType == DTRAP_MINOR_NEGATIVE)	{nSaveDC = DEP_GetBaseSave(1); DEP_TrapDoNegativeDamage(d6(2), nSaveDC, 1); return;}
	if (nBaseType == DTRAP_AVERAGE_NEGATIVE){nSaveDC = DEP_GetBaseSave(2); DEP_TrapDoNegativeDamage(d6(3), nSaveDC, 1); return;}
	if (nBaseType == DTRAP_STRONG_NEGATIVE) {nSaveDC = DEP_GetBaseSave(3); DEP_TrapDoNegativeDamage(d6(5), nSaveDC, 2); return;}
	if (nBaseType == DTRAP_DEADLY_NEGATIVE) {nSaveDC = DEP_GetBaseSave(4); DEP_TrapDoNegativeDamage(d6(12), nSaveDC, 3); return;}
}

///////////////////////////////////////////////////////////////////////
// Determines the Base Save DC for a Trap
// Minor = 1, Average = 2, Strong = 3, Deadly = 4, Fatal = 5, Epic = 6
int DEP_GetBaseSave(int TrapType)
{
	int nSaveDC = (TrapType * 4) + 10;
	int nSaveDC2 = GetLocalInt(OBJECT_SELF, "TrapEffectDC");
	if (nSaveDC2 > 0) nSaveDC = nSaveDC2;
	return nSaveDC;
}