//::///////////////////////////////////////////////
//:: Evil Blight
//:: x2_s0_EvilBlight
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Any enemies within the area of effect will
	suffer a curse effect
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////
//:: Updated by: Andrew Nobbs
//:: Updated on: March 28, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller


#include "_HkSpell"
#include "_HkSpell"

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_evilblight();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget;
	effect eImpact = EffectVisualEffect(VFX_IMP_DOOM);
	effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
	effect eCurse = SupernaturalEffect(EffectCurse(3,3,3,3,3,3));

	//Apply Spell Effects
	location lLoc = GetLocation(OBJECT_SELF);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);

	//Get first target in the area of effect
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	float fDelay;

	while(GetIsObjectValid(oTarget))
	{
			//Check faction of oTarget
			if (GetIsEnemy(oTarget))
			{
				//Signal spell cast at event
				SignalEvent(oTarget, EventSpellCastAt(oCaster,  GetSpellId()));
				//Make SR Check
				if (!HkResistSpell(OBJECT_SELF, oTarget))
				{
							//Make Will Save
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC()))
					{
							// wont stack
							if (!GetHasSpellEffect(GetSpellId(), oTarget))
								{
										HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
										HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget);
								}
					}
				}
			}
			//Get next spell target
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}