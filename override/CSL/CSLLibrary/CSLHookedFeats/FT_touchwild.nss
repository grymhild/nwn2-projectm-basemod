#include "_HkSpell"
//#include "NW_I0_SPELLS"
//#include "cmi_includes"

/*----  Kaedrin PRC Content ---------*/


void main()
{	
	//scSpellMetaData = SCMeta_FT_touchwild();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


    object oTarget = HkGetSpellTarget();
    int nChr = GetAbilityModifier(ABILITY_CHARISMA);
    if (nChr <= 0)
    {
        //nChr = 0;
		return;		// AFW-OEI 06/13/2006: Lay on Hands does nothing if you don't have a positive Cha mod. 
    }
    int iLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
    iLevel = iLevel + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION);
	iLevel = iLevel + GetLevelByClass(CLASS_HOSPITALER);
	iLevel = iLevel + GetLevelByClass(CLASS_CHAMPION_WILD);	

	int nHeal = iLevel * nChr;
    if(nHeal <= 0)
    {
        nHeal = 1;
    }
	
    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eDam;
    int iTouch;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkPostCast(oCaster);
}