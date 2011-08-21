//:://///////////////////////////////////////////////
//:: Level 6 Arcane Spell: Disintegrate
//:: nw_s0_disngrt.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/16/05
//::////////////////////////////////////////////////
/*
		5.1.6.3.2 Disintegrate (B)
		PHB, pg. 222
		School:     Transmutation
		Components:  Verbal, Somatic
		Range:   Medium
		Target:     Ray
		Duration:   Instantaneous
		Saving Throw:   Fortitude partial
		Spell Resist:   Yes

		This requires a ranged touch attack to hit. Any creature hit takes 2d6
		hit points of damage per caster level (to a maximum of 40d6). Any creature
		reduced to 0 hit points or less is entirely disintegrated. If the target
		makes their fortitude saves, they only take 5d6 damage.
		[Art] For this spell to work we need a disintegration effect or some sort
		of procedural effect that would mimic it. It would have to work for any hostile target.

		[Rules Note] In 3.5 you can also disintegrate objects, but that's not really possible in NWN2.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
// following only for SCRIPT_DEFAULT_DAMAGE constant which is// const string SCRIPT_DEFAULT_DAMAGE    = "nw_c2_default6";   // 6
#include "_SCInclude_Events"




//int CREATURE_SCRIPT_ON_DAMAGED                = 4;


void main()
{
	//scSpellMetaData = SCMeta_SP_disintegrate();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DISINTEGRATE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
	if (iTouch!=TOUCH_ATTACK_RESULT_MISS)
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
			if (HkResistSpell(oCaster, oTarget)) return;
			int iSave = FortitudeSave(oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster); // SAVING_THROW_TYPE_DEATH?
			if (iSave==2) return; // Target is immune
			int iSpellPower = HkGetSpellPower( oCaster, 20 ); // OldGetCasterLevel(oCaster);
			int iDice = (iSave) ? 5 : ( iSpellPower * 2);
			
			int iDamage = HkApplyMetamagicVariableMods( d6(iDice), 6 * iDice );	
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
			
			//iDice = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, iDice, SC_TOUCHSPELL_RAY );
			//int iDamage = HkApplyMetamagicVariableMods(d6(iDice), 6 * iDice);
			if (iDamage)
			{
				string sEventHandler = GetEventHandler(oTarget, CREATURE_SCRIPT_ON_DAMAGED);
				if ((iDamage>=GetCurrentHitPoints(oTarget)) && sEventHandler=="gb_troll_dmg") { // FOR TROLLS ONLY
				// error with variable on this line
					SetEventHandler(oTarget,CREATURE_SCRIPT_ON_DAMAGED, SCRIPT_DEFAULT_DAMAGE);
					SetImmortal(oTarget, FALSE);
				}
				effect eHit = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
				if (GetCurrentHitPoints(oTarget)<=0) { // If they are at or below 0 hit points, disintegrate them!
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDisintegrate(oTarget), oTarget);
				}
				else if (sEventHandler=="gb_troll_dmg") // FOR TROLLS ONLY
				{
					SetEventHandler(oTarget,CREATURE_SCRIPT_ON_DAMAGED, sEventHandler);
					SetImmortal(oTarget, TRUE);
				}
			}
		}
	}
	effect eBeam   = EffectBeam(VFX_BEAM_TRANSMUTATION, oCaster, BODY_NODE_HAND);   // NWN2 VFX
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7);
	
	HkPostCast(oCaster);
}

