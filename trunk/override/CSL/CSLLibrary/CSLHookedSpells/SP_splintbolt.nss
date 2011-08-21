//::///////////////////////////////////////////////
//:: Splinterbolt
//:: cmi_s0_splintbolt
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:: Splinterbolt
//:: Caster Level(s): Druid 2
//:: Innate Level: 2
//:: School: Conjuration
//:: Component(s): Verbal, Somatic, Material
//:: Range: Short
//:: Area of Effect / Target: One creature
//:: Duration: Instantaneous
//:: Save: None
//:: Spell Resistance: No
//:: You must make a ranged attack to hit the target. If you hit, the
//:: splinterbolt deals 4d6 points of magic damage. You can fire one additional
//:: splinterbolt for every 4 levels beyond 3rd (to a maximum of three at 11th
//:: level).
//:: 
//:: This spell gains the benefit of Sneak Attack or Death Attack when
//:: appropriate.
//:: 
//:: You extend your hand toward your foe, flicking a single sliver of wood
//:: into the air, and a splinter larger than a titan's javelin whistles through
//:: the air.
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPLINTERBOLT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP| SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	int iSpellPower = HkGetSpellPower( oCaster, 12 );
	int nMissiles = (iSpellPower + 1)/4;

	effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
	float fDelay;
	int nSpell = HkGetSpellId();
	int nPathType = PROJECTILE_PATH_TYPE_ACCELERATING;
	location lSourceLoc = GetLocation( oCaster );
	location lTarget = GetLocation( oTarget );
	int nCnt;
	float fTravelTime;
	int nTouch;
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{

		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));
		//Apply a single damage hit for each missile instead of as a single mass
		for (nCnt = 1; nCnt <= nMissiles; nCnt++)
		{
			int iTouch = CSLTouchAttackRanged(oTarget, TRUE);
			if (nTouch != TOUCH_ATTACK_RESULT_MISS)
			{
				fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
				fDelay = 0.1f * IntToFloat(nCnt);

				int iDamage = HkApplyMetamagicVariableMods(d6(4), 24);
				iDamage = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, iDamage, SC_TOUCH_RANGED );

				
				//Set damage effect
				effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
				//Apply the MIRV and damage effect
				DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, SpawnSpellProjectile(oCaster, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
			}
		}
	}
	HkPostCast(oCaster);
}