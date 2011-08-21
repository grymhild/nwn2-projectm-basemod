//::///////////////////////////////////////////////
//:: Wall of Ice: Heartbeat
//:: SG_S0_WallIceA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Person within the AoE take 1d6 fire damage
	per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels
//:: Created On: September 23, 2004
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_elements"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


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
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget; 		//= HkGetSpellTarget();
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC; 			//= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 6;
	int 	iNumDice 		= 1;
	int 	iBonus 		= iCasterLevel;
	int 	iDamage 		= 0;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis 	= EffectVisualEffect(iHitEffect);
	effect eDam;

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE );
	//Declare the spell shape, size and the location.
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_ICE));
			if(!HkResistSpell(oCaster, oTarget))
			{
				if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, iSaveType, oCaster))
				{
					iDamage = HkApplyMetamagicVariableMods(d6(1), 6) + iCasterLevel;
					eDam = EffectDamage(iDamage, iDamageType);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
		}
		oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE );
	}
}
