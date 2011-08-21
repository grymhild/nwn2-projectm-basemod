//::///////////////////////////////////////////////
//:: Searing Light
//:: s_SearLght.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Focusing holy power like a ray of the sun, you project
//:: a blast of light from your open palm. You must succeed
//:: at a ranged touch attack to strike your target. A creature
//:: struck by this ray of light suffers 1d8 points of damage
//:: per two caster levels (maximum 5d8). Undead creatures suffer
//:: 1d6 points of damage per caster level (maximum 10d6), and
//:: undead creatures particularly vulnerable to sunlight, such
//:: as vampires, suffer 1d8 points of damage per caster level
//:: (maximum 10d8). Constructs and inanimate objects suffer only
//:: 1d6 points of damage per two caster levels (maximum 5d6).

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SEARING_LIGHT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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
	int iCasterLevel = CSLGetMin(10, HkGetSpellPower(oCaster)); // CAP AT 10
	object oTarget = HkGetSpellTarget();
	int iTouch     = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SEARING_LIGHT));
		if (iTouch != TOUCH_ATTACK_RESULT_MISS) //Make an SR Check
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
				int iDamage;
				int nMax;
				if ( CSLGetIsUndead( oTarget ) )
				{ //Check for racial type undead
					iDamage = HkApplyMetamagicVariableMods(d6(iCasterLevel), iCasterLevel*6);
				} 
				else if ( CSLGetIsConstruct(oTarget) ) 
				{ //Check for racial type construct
					iDamage = HkApplyMetamagicVariableMods(d3(iCasterLevel), iCasterLevel*3);        
				} 
				else
				{
					iDamage = HkApplyMetamagicVariableMods(d4(iCasterLevel), iCasterLevel*4);
					iDamage = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, iDamage, SC_TOUCHSPELL_RAY);
				}
				effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SEARING_LIGHT );
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_DIVINE), oTarget);
				DelayCommand(0.5, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
		}
	}
	effect eRay = EffectBeam(VFX_BEAM_HOLY, oCaster, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
	HkPostCast(oCaster);
}

