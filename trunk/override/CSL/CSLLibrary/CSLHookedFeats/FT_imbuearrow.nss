//::///////////////////////////////////////////////
//:: x1_s2_imbuearrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Imbue Arrow
	- creates a fireball arrow that when it explodes acts like a fireball.
	- Must have shortbow or longbow in hand.
*/
#include "_HkSpell"
#include "_SCInclude_ArcaneArcher"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	//Declare major variables
	object oCaster = OBJECT_SELF;
	int iCasterLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oCaster);
	int iBonus = (iCasterLevel/2)+1;
	int iDC = 10 + iCasterLevel + HkGetBestCasterModifier(oCaster, TRUE, FALSE);
	if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oCaster))         iDC++;
	if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster)) iDC++;
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster))    iDC+=4;

	location lTarget = HkGetSpellTargetLocation();
	location lSource = GetLocation(oCaster);
	float fTravelTime = GetProjectileTravelTime(lSource, lTarget, PROJECTILE_PATH_TYPE_HOMING);
	object oTarget = HkGetSpellTarget();

	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			int iTouch = CSLTouchAttackRanged(oTarget, TRUE, iBonus);
			SCArcaneArcherArrowLaunch(oCaster, oTarget, fTravelTime, iTouch, PROJECTILE_PATH_TYPE_HOMING, DAMAGE_TYPE_SONIC); // HARD CODE TO SONIC SINCE ALL TYPES ARE NOT AVAILABLE
		}
	}
	else
	{ // SpawnItemProjectile() needs a destination - create a waypoint to shoot at, then destroy it
		oTarget = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lTarget);
		lTarget = GetLocation(oTarget);
		SpawnItemProjectile(oCaster, oTarget, lSource, lTarget, BASE_ITEM_LONGBOW, PROJECTILE_PATH_TYPE_HOMING, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, DAMAGE_TYPE_FIRE);
		DestroyObject(oTarget); // clean it up!
	}
	
	int iDamageType = DAMAGE_TYPE_FIRE;
	object oArrow = GetItemInSlot(INVENTORY_SLOT_ARROWS);
	if (oArrow!=OBJECT_INVALID) {
		iDamageType = 0;
		itemproperty ipLoop=GetFirstItemProperty(oArrow);
		while (GetIsItemPropertyValid(ipLoop) && iDamageType==0) {
			if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_DAMAGE_BONUS) {
				iDamageType = CSLGetDamageTypeByIPConstDamageType(GetItemPropertySubType(ipLoop));
			}
			ipLoop=GetNextItemProperty(oArrow);
		}
	}
	int nDamageEffect = CSLGetImpactEffectByDamageType(iDamageType);
	int nDamageAOE = CSLGetAOEEffectByDamageType(iDamageType);
	int nDamgeSave = CSLGetSaveTypeByDamageType(iDamageType);

	// BEGIN FIRE BALL EXPLOSION
	float fDelay;
	int iDice = 10;
	if (iCasterLevel>10) iDice += (iCasterLevel-10)/2;
	int iDamage;
	effect eDam;
	effect eExplode = EffectVisualEffect(nDamageAOE);
	effect eVis = EffectVisualEffect(nDamageEffect);
	float fRadius = RADIUS_SIZE_HUGE + (iCasterLevel / 5.0);
	DelayCommand(fTravelTime, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) / 20.0;
			if (!HkResistSpell(oCaster, oTarget, fDelay)) {
				iDamage = d6(iDice);
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, nDamgeSave);
				eDam = EffectDamage(iDamage, iDamageType);
				if (iDamage) {
					DelayCommand(fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}