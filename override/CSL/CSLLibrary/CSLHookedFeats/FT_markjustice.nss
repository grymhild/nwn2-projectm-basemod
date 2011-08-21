//::///////////////////////////////////////////////
//:: Mark of Justice
//:: cmi_s0_markjust.nss
//:://////////////////////////////////////////////\

//Based on Bestow Curse by OEI

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 

void main()
{	
	//scSpellMetaData = SCMeta_FT_markjustice();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
    object oTarget = HkGetSpellTarget();
    effect eCurse = EffectCurse(4, 4, 4, 4, 4, 4);
	eCurse = EffectLinkEffects( eCurse, EffectVisualEffect( VFX_DUR_SPELL_BESTOW_CURSE ) );
	eCurse = SupernaturalEffect(eCurse);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BESTOW_CURSE));
         //Make SR Check
         if (!HkResistSpell(OBJECT_SELF, oTarget))
         {
            //Make Will Save
            if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC()))
            {
                //Apply Effect and VFX
                HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget);
                //HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
            }
        }
    }
    HkPostCast(oCaster);
}