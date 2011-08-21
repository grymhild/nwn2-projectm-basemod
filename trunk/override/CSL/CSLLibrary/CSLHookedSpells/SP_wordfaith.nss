//::///////////////////////////////////////////////
//:: Word of Faith
//:: [NW_S0_WordFaith.nss]
//:://////////////////////////////////////////////
/*
	A 30ft blast of divine energy rushs out from the
	Cleric blasting all enemies with varying effects
	depending on their HD.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_wordfaith();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WORD_OF_FAITH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_HOLY;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster );
	if (GetSpellId()==SPELLABILITY_WORD_OF_FAITH) iSpellPower = GetHitDice(oCaster);
	location lTarget = HkGetSpellTargetLocation();
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	object oMaster;

	effect eBlind = EffectBlindness();
	effect eStun = EffectStunned();
	effect eConfuse = EffectConfused();
	effect eDeath = EffectDeath();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	effect eKill;
	effect eLink;
	int iHD;
	float fDelay;
	float fDuration = RoundsToSeconds(iDuration/2);
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);	
	
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_FEAT_TURN_UNDEAD), lTarget);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while (GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster)) {
			fDelay = CSLRandomBetweenFloat(0.5, 2.0);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WORD_OF_FAITH));
			if (!HkResistSpell(oCaster, oTarget, fDelay)) {
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				oMaster = GetMaster(oTarget);
				//if (GetIsObjectValid(GetMaster(oTarget)) && (GetAssociateType(oTarget)==ASSOCIATE_TYPE_SUMMONED)) {
				if (GetIsObjectValid(oMaster) && GetAssociateType(oTarget)==ASSOCIATE_TYPE_SUMMONED) {
					if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH)) {
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
					} else {
						eKill = EffectDamage(GetCurrentHitPoints(oTarget)+10);
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
					}
				} else {
					iHD = GetHitDice(oTarget);
					if (GetLocalObject(oTarget, "DOMINATED")!=OBJECT_INVALID) iHD /= 2; // IF PM CREATED UNDEAD, CONSIDER HD TO BE 1/2
					if (iHD<=4) {
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
					} else if (iHD<=7) {
						eLink = EffectLinkEffects(eStun, eConfuse);
						eLink = EffectLinkEffects(eLink, eBlind);
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
					} else if (iHD<=11) {
						eLink = EffectLinkEffects(eStun, eBlind);
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
					} else { // 12+
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, fDuration));
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}
	
	HkPostCast(oCaster);
}