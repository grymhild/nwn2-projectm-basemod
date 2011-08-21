//::///////////////////////////////////////////////
//:: Contagion
//:: NW_S0_Contagion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target must save or be struck down with
	Blidning Sickness, Cackle Fever, Filth Fever
	Mind Fire, Red Ache, the Shakes or Slimy Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 6, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 07/16/2007: Do not link duration VFX to disease,
//:: as resting will remove the VFX, which will also remove
//:: the linked disease.


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
 


void main()
{
	//scSpellMetaData = SCMeta_SP_contagion();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CONTAGION;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_BG_Contagion || GetSpellId() == SPELL_BG_Spellbook_3  )
	{
		int iClass = CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DISEASE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int nRand = Random(7)+1;
	int nDisease;
	//Use a random seed to determine the disease that will be delivered.
	switch (nRand)
	{
			case 1:
				nDisease = DISEASE_BLINDING_SICKNESS;
			break;
			case 2:
				nDisease = DISEASE_CACKLE_FEVER;
			break;
			case 3:
				nDisease = DISEASE_FILTH_FEVER;
			break;
			case 4:
				nDisease = DISEASE_MINDFIRE;
			break;
			case 5:
				nDisease = DISEASE_RED_ACHE;
			break;
			case 6:
				nDisease = DISEASE_SHAKES;
			break;
			case 7:
				nDisease = DISEASE_SLIMY_DOOM;
			break;
	}
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTAGION));
			effect eDisease = SupernaturalEffect(EffectDisease(nDisease));
			//Make SR check
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//The effect is permament because the disease subsystem has its own internal resolution
				//system in place.
			//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_POISON); // NWN1 VFX
			effect eHit = EffectVisualEffect( VFX_HIT_SPELL_NECROMANCY ); // NWN2 VFX
			//eDisease = EffectLinkEffects( eDisease, eHit );
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget ); // NWN2 VFX
			}
	}
	
	HkPostCast(oCaster);
}

