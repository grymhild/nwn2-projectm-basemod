//::///////////////////////////////////////////////
//:: Stormsingers Storm of Vengeance
//:: cmi_s2_stormveng
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 16, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//Based on Storm of Vengeance by OEI

#include "_HkSpell"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_ssstormofven();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iImpactSEF = VFX_HIT_AOE_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	int iCasterLevel = GetStormSongCasterLevel(OBJECT_SELF);
	if (iCasterLevel < 18) //Short circuit
	{
		SendMessageToPC(OBJECT_SELF, "Insufficient Perform skill, you need 15 or more to use this ability.");
		return;
	}
	if (!GetHasFeat(257))
	{
		SpeakString("No uses of the Bard Song ability are available");
		return;
	}
	else
	{
		DecrementRemainingFeatUses(OBJECT_SELF, 257);
		DecrementRemainingFeatUses(OBJECT_SELF, 257);
		DecrementRemainingFeatUses(OBJECT_SELF, 257);
		DecrementRemainingFeatUses(OBJECT_SELF, 257);				
	}	
	
	float fDuration = RoundsToSeconds(10);
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(VFX_PER_STORMSINGER_STORM, "", "", "", sAOETag);
	location lTarget = HkGetSpellTargetLocation();
	//Create an instance of the AOE Object using the Apply Effect function
	DelayCommand( 0.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration ) );
	
	HkPostCast(oCaster);
}

