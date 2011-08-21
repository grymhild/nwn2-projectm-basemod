//:://///////////////////////////////////////////////
//:: Level 0 Arcane Spell: Disrupt Undead
//:: SP_disruptundead.nss
//::////////////////////////////////////////////////
/*
Level:	Sor/Wiz 0
Components:	V, S
Casting Time:	1 standard action
Range:	Close (25 ft. + 5 ft./2 levels)
Effect:	Ray
Duration:	Instantaneous
Saving Throw:	None
Spell Resistance:	Yes

You direct a ray of positive energy. You must make a ranged 
touch attack to hit, and if the ray hits an undead creature, 
it deals 1d6 points of damage to it.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
// following only for SCRIPT_DEFAULT_DAMAGE constant which is// const string SCRIPT_DEFAULT_DAMAGE    = "nw_c2_default6";   // 6
#include "_SCInclude_Events"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DISRUPT_UNDEAD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 0;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	
	int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS)
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && CSLGetIsUndead(oTarget, TRUE ) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
			if (HkResistSpell(oCaster, oTarget)) 
			{
				return;
			}

			//int iSpellPower = HkGetSpellPower( oCaster );
			
			int iDamage = HkApplyMetamagicVariableMods( d6(), 6 );	
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );

			if ( iDamage )
			{
				string sEventHandler = GetEventHandler(oTarget, CREATURE_SCRIPT_ON_DAMAGED);
				
				effect eHit = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			}
		}
	}
	effect eBeam = EffectBeam(VFX_BEAM_TRANSMUTATION, oCaster, BODY_NODE_HAND);   // NWN2 VFX
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7);
	
	HkPostCast(oCaster);
}

