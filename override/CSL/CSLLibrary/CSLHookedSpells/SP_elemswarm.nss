//::///////////////////////////////////////////////
//:: Elemental Swarm
//:: NW_S0_EleSwarm.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spell creates a conduit from the caster
	to the elemental planes.  The first elemental
	summoned is a 24 HD Air elemental.  Whenever an
	elemental dies it is replaced by the next
	elemental in the chain Air, Earth, Water, Fire
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 30, 2001
//:: AFW-OEI 05/31/2006:
//:: Update to new creature blueprints.
//:: Change duration from 24 hours to CL minutes.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"


void main()
{
	//scSpellMetaData = SCMeta_SP_elemswarm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ELEMENTAL_SWARM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	// the descriptor can be scMetaData.sElement="Earth/Fire/Air/Water";, it is based on what is summoned 
	int iDescriptor = SCMETA_DESCRIPTOR_AIR|SCMETA_DESCRIPTOR_EARTH|SCMETA_DESCRIPTOR_WATER|SCMETA_DESCRIPTOR_FIRE;
	int iImpactSEF = VFX_HIT_AOE_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	float fDuration = HkGetSpellDuration(OBJECT_SELF) * 60.0f; // 1 minute/caster level
	//iDuration = 24;
	effect eSummon;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE);
	
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Set the summoning effect
	eSummon = EffectSwarm(FALSE, "c_elmairgreater", "c_elmearthgreater","c_elmwatergreater","c_elmfiregreater");
	//Apply the summon effect
	if (GetHasFeat(FEAT_ASHBOUND, OBJECT_SELF))
	{
		fDuration = fDuration * 2;
	}
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, fDuration);
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF,1,1));
	
	HkPostCast(oCaster);
}

