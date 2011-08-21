//::///////////////////////////////////////////////
//:: Stone To Flesh
//:: x0_s0_stoflesh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target is freed of any petrify effect
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Oct 16 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//UPDATE - Do a check to make sure that the creature being cast on
//          has not been set up to be a permanent statue.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_stonetoflesh();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_STONE_TO_FLESH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	object oTarget = HkGetSpellTarget();

	//Check to make sure the creature has not been set up to be a statue.
	if (GetLocalInt(oTarget, "NW_STATUE") != 1)
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 486, FALSE));

			//Search for and remove the above negative effects
			effect eLook = GetFirstEffect(oTarget);

			while(GetIsEffectValid(eLook))
			{
				if(GetEffectType(eLook) == EFFECT_TYPE_PETRIFY)
				{
					SetCommandable(TRUE, oTarget);
					RemoveEffect(oTarget, eLook);
				}
				eLook = GetNextEffect(oTarget);
			}

			//Apply Linked Effect
		effect eHit = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	}
	HkPostCast(oCaster);
}

