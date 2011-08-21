//::///////////////////////////////////////////////
//:: Drowned Aura Heartbeat
//:: NX2_S1_drwnaurab.nss
//:: Copyright (c) 2008 Obsidian Entertainment
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Chapman
//:: Created On: March 17, 2008
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
    //--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetFirstInPersistentObject();
	int nDamage;
	effect eDam;
	effect eStun = EffectStunned();
	effect eVis = EffectVisualEffect( VFX_HIT_DROWN );
	
    while(GetIsObjectValid(oTarget))
	{
		if( CSLGetIsDrownable(oTarget, TRUE ) )
        {
			//Make a saving throw check
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, 14, SAVING_THROW_TYPE_NONE))
            {
				if(GetGameDifficulty() == GAME_DIFFICULTY_DIFFICULT)
				{
                	nDamage = FloatToInt(GetCurrentHitPoints(oTarget) * 0.9);
				}
				else if (GetGameDifficulty() == GAME_DIFFICULTY_CORE_RULES)
				{
					nDamage = FloatToInt(GetCurrentHitPoints(oTarget) * 0.3);
                }
				else
				{
					nDamage = FloatToInt(GetCurrentHitPoints(oTarget) * 0.1);
				}
				eDam = EffectDamage(nDamage);
				
				//Apply the VFX impact and effects for Nausea
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0f);
            }
		}
		
		oTarget = GetNextInPersistentObject();
    }
}