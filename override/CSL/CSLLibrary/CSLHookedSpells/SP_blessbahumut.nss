//::///////////////////////////////////////////////
//:: Blessing of Bahumut
//:: cmi_s0_blessbahumut
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: June 28, 2007
//:://////////////////////////////////////////////
//:: Blessing of Bahumut
//:: Caster Level(s): Paladin 3
//:: Innate Level: 3
//:: School: Abjuration
//:: Descriptor(s): Good
//:: Component(s): Verbal, Somatic, Material
//:: Range: Personal
//:: Area of Effect / Target: Self
//:: Duration: 1 round/level
//:: Save: None
//:: Spell Resistance: No
//:: You gain damage reduction 10/Adamantine for the spell's duration.
//:: 
//:: You hear a distant dragon's roar that no one else detects, and your skin
//:: takes on a platinum sheen.
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_blessbahumut();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Blessing_Bahumut;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);    	
	effect eDR = EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
    //effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  OBJECT_SELF, GetSpellId() ) );
	
	effect eLink = EffectLinkEffects(eDR, eVis);
	//eLink = EffectLinkEffects(eLink,eDR);	
	
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  OBJECT_SELF, GetSpellId() );
    	
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
	
	HkPostCast(oCaster);
}

