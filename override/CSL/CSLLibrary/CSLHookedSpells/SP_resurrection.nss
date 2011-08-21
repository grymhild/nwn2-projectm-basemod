//::///////////////////////////////////////////////
//:: [Ressurection]
//:: [NW_S0_Ressurec.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Brings a character back to life with full
//:: health.
//:: When cast on placeables, you get a default error message.
//::   * You can specify a different message in
//::      X2_L_RESURRECT_SPELL_MSG_RESREF
//::   * You can turn off the message by setting the variable
//::     to -1
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Z on 2003-07-31
//:: VFX Pass By: Preston W, On: June 22, 2001


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_resurrection();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RESURRECTION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Get the spell target
	object oTarget = HkGetSpellTarget();
	//Check to make sure the target is dead first
	//Fire cast spell at event for the specified target
	if (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESURRECTION, FALSE));
		if (GetIsDead(oTarget))
		{
			//Declare major variables
			int nHealed = GetMaxHitPoints(oTarget);
			effect eRaise = EffectResurrection();
			effect eHeal = EffectHeal(nHealed + 10);
			effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
			//Apply the heal, raise dead and VFX impact effect
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
			CloseGUIScreen( oTarget, GUI_DEATH );
			CloseGUIScreen(oTarget, GUI_DEATH_HIDDEN);
			CSLEnviroRemoveEffects( oTarget );
		}
		else
		{
			if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
			{
				int nStrRef = GetLocalInt(oTarget,"X2_L_RESURRECT_SPELL_MSG_RESREF");
				if (nStrRef == 0)
				{
						nStrRef = 83861;
				}
				if (nStrRef != -1)
				{
						FloatingTextStrRefOnCreature(nStrRef,OBJECT_SELF);
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

