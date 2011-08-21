//::///////////////////////////////////////////////
//:: Detect Spirits
//:: nx_s0_detectspirits
//:://////////////////////////////////////////////
/*
	Allows the caster to sense spirit creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/14/2007
//:://////////////////////////////////////////////


#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_detectspirit();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	object oTarget  = HkGetSpellTarget();
	float fDuration = TurnsToSeconds(10);  // Fixed duration of 10 minutes
	int iDurType    = DURATION_TYPE_TEMPORARY;

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	effect eDur   = EffectVisualEffect( VFX_DUR_SPELL_DETECT_SPIRITS );
	effect eSight = EffectDetectSpirits();
	effect eLink  = EffectLinkEffects(eDur, eSight);

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}