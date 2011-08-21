//::///////////////////////////////////////////////
//:: Level 9 Arcane Spell: Shades
//:: shades.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/19/05
//:://////////////////////////////////////////////
/*
	Greater Shadow Conjuration
	
	If the opponent is clicked on Delayed Blast Fireball is cast.
	If the caster clicks on himself he will cast Premonition, Protection from Spells, and Shield.
	If they click on the ground they will call Summon Creature VIII

*/
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//:: Update creature blueprints.
//:: Change summon durations from hours to 3 + CL rounds.
//:: BDF-OEI 06/21/2006:
//:: Modified to make use of new NWN2 data

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"



	
const int CONTEXT_SELF = 1;
const int CONTEXT_TARGET = 2;
const int CONTEXT_GROUND = 3;

void HandleCastOnSelf( object oSelf, int iDuration );
void HandleCastOnTarget( object oTarget, int iDuration );
void HandleCastOnGround( location lTarget, int iDuration );




void main()
{
	//scSpellMetaData = SCMeta_SP_shad();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHADES;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_SHADOW, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	//string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration( OBJECT_SELF ); // Duration is 1 hr per level of the caster
	int nSummonDuration = iDuration + 3; // Summon duration 3 + caster level rounds

	if ( GetMetaMagicFeat() & METAMAGIC_EXTEND )
	{
		iDuration = iDuration *2; //Duration is +100%
		nSummonDuration = nSummonDuration * 2;
	}

	object oTarget = HkGetSpellTarget();
	int nCast = CONTEXT_GROUND;
	if (GetIsObjectValid(oTarget))
	{
			if (oTarget == OBJECT_SELF)
			{
				nCast = CONTEXT_SELF;
			}
			else
			{
				nCast = CONTEXT_TARGET;
			}
	}
	else
	{
			nCast = CONTEXT_GROUND;
	}
	
	switch (nCast)
	{
		case CONTEXT_SELF: HandleCastOnSelf( oTarget, iDuration ); break;
		case CONTEXT_TARGET: HandleCastOnTarget( oTarget, iDuration ); break;
		case CONTEXT_GROUND: HandleCastOnGround( HkGetSpellTargetLocation(), nSummonDuration ); break;
	}
	HkPostCast(oCaster);
}

///////////////////////////////////////////////////////////////////////////////
// HandleCastOnSelf
// Get Premonition, Protection from Spells, and Mage Armor effects
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnSelf( object oSelf, int iDuration )
{
	//Fire cast spell at event for the specified target
	SignalEvent(oSelf, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	// Get rid of effects from similar spells
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oSelf, SPELL_PROTECTION_FROM_SPELLS, SPELL_PREMONITION, SPELL_MAGE_ARMOR);
	
	effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oSelf, oSelf, SPELL_PREMONITION) );
	
	// Premonition
	int nLimit = HkGetSpellPower(oSelf) * 10;
	effect ePremonition = EffectDamageReduction( 30, GMATERIAL_METAL_ADAMANTINE, nLimit, DR_TYPE_GMATERIAL );
	ePremonition = EffectLinkEffects(ePremonition, EffectVisualEffect( VFX_DUR_SPELL_PREMONITION ) );
	ePremonition = EffectLinkEffects(ePremonition, eOnDispell );

	// Protection from Spells
	effect eLink = EffectVisualEffect( VFX_DUR_SPELL_PROTECTION_FROM_SPELLS );
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 8, SAVING_THROW_TYPE_SPELL) );
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE) );
	
	// Shield
	eLink = EffectLinkEffects(eLink, EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS) );
	eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_MAGIC_MISSILE) );
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_SHIELD) );
	eLink = EffectLinkEffects(eLink, eOnDispell );

	//Apply the armor bonuses and the VFX impact
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePremonition, oSelf, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS), HkGetSpellId());
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oSelf, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_DUR_SPELL_PROTECTION_FROM_SPELLS ), oSelf);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_DUR_SPELL_SHIELD ), oSelf);
}

///////////////////////////////////////////////////////////////////////////////
// HandleCastOnTarget
// Casts a "Delayed Blast Fireball" at the target's location
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnTarget( object oTarget, int iDuration )
{
	
	object oCaster = OBJECT_SELF;
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);
	int iSpellPower = HkGetSpellPower( oCaster, 15 );
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_DELAY_BLAST_FIREBALL, "", "", "", sAOETag);
	location lTarget = GetLocation( oTarget );

	//Create an instance of the AOE Object using the Apply Effect function
	DelayCommand( 0.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration ) );
}


///////////////////////////////////////////////////////////////////////////////
// HandleCastOnGround
// Runs identical to the "Creature Summoning VIII" Spell
// This was copied from the nw_s0_summon8.nss script
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnGround( location lTarget, int iDuration )
{
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	effect eSummon;
	int iRoll = d4();
	if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
	{
			switch (iRoll)
			{
				case 1: eSummon = EffectSummonCreature("csl_sum_sh_elem_air_24elder");            break;
				case 2: eSummon = EffectSummonCreature("csl_sum_sh_elem_eart_24elde");          break;
				case 3: eSummon = EffectSummonCreature("csl_sum_sh_elem_fire_24elde"); break;
				case 4: eSummon = EffectSummonCreature("csl_sum_sh_elem_wat_24elder");          break;
			}
	}
	else
	{
			switch (iRoll)
			{
				case 1: eSummon = EffectSummonCreature("csl_sum_sh_elem_air_21great");              break;
				case 2: eSummon = EffectSummonCreature("csl_sum_sh_elem_eart_21grea");            break;
				case 3: eSummon = EffectSummonCreature("csl_sum_sh_elem_fire_21grea");             break;
				case 4: eSummon = EffectSummonCreature("csl_sum_sh_elem_wat_21great");            break;
			}
	}

	//effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3); // no longer using the NWN1 VFX
	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SUMMON_CREATURE ); // makes use of the NWN2 VFX
	//Make metamagic check for extend
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Apply the VFX impact and summon effect
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, HkGetSpellTargetLocation());
	HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fDuration );
	
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
}

