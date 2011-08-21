//::///////////////////////////////////////////////
//:: Contagion, Mass
//:: NX_s0_mascont.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Contagion, Mass
	Necromancy [Evil]
	Level: Cleric 5, druid 5, sorceror/wizard 6
	Components: V, S
	Range: Medium
	Area: 20-ft.-radius
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	
	As contagion except that it effects all targets within the prescribed area.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills, based on nw_s0_contagion (06.06.01 Preston Watamaniuk)
//:: Created On: 11.30.06
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
	//scSpellMetaData = SCMeta_SP_mscontagion();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_CONTAGION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DISEASE|SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
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
	effect eDisease = SupernaturalEffect(EffectDisease(nDisease));
	
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//Signal spell cast at event
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1017));
			
			if (!HkResistSpell(oCaster, oTarget))
			{
				//disease resistance and saves are handled by the EffectDisease function automatically
				effect eHit = EffectVisualEffect( VFX_HIT_SPELL_NECROMANCY );
				//eDisease = EffectLinkEffects( eDisease, eHit );
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);

			}
		}
		//find my next victim
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

