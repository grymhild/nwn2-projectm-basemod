//::///////////////////////////////////////////////
//:: Vine Mine, Entangle C
//:: X2_S0_VineMEntC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the AOE the target must make
    a reflex save or be entangled by vegitation
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, 14/08/2003

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_VINE_MINE_ENTANGLE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    //Link Entangle and Hold effects
    effect eLink = EffectLinkEffects(EffectEntangle(), EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION));
	int nSpellDC = HkGetSpellSaveDC();

	object oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{ 
		if ( !CSLGetIsIncorporeal( oTarget ) )
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster ))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_VINE_MINE));
				//Make SR check
				if(!GetHasSpellEffect(SPELL_VINE_MINE_ENTANGLE, oTarget))
				{
					//if(!HkResistSpell(oCaster, oTarget))
					//{
						if( !HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellDC, SAVING_THROW_TYPE_NONE, oCaster ) )
						{
							//Apply linked effects
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
						}
					//}
				}
			}
		}
		//Get next target in the AOE
		oTarget = GetNextInPersistentObject();
	}
}