//::///////////////////////////////////////////////
//:: Blade Barrier, Self
//:: NW_S0_BladeBarSelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a curtain of blades 10m in diameter around the caster
	that hack and slice anything moving into it.  Anything
	caught in the blades takes 2d6 per caster level.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_bladebarself();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLADE_BARRIER_SELF;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iImpactSEF = VFX_HIT_SPELL_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	// 6 * 15 = 90
	
	
	int iSpellPower = HkGetSpellPower( oCaster, 15 );
	
	
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(HkGetSpellDuration( oCaster )/2));
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, TRUE  );
	
	
	// string sAOETag = ObjectToString(oCaster) + IntToString(GetSpellId()); //First we need to generate the string that serves as the object ID for this AOE object
	
	
	
	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_MOB_BLADE_BARRIER, "", "", "", sAOETag); // SP_bladebarselfB
	eAOE = EffectLinkEffects(eAOE, EffectCutsceneImmobilize());
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	DelayCommand( 0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration) );
	
	HkPostCast(oCaster);
}

