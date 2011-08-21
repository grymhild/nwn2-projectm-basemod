//::///////////////////////////////////////////////
//:: Deadly Lahar
//:: cmi_s0_deadlahar
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: May 6, 2009
//:://////////////////////////////////////////////
//:: Deadly Lahar
//:: Conjuration (Earth, Fire)
//:: Level: Druid 8, Sorcerer/Wizard 8
//:: Components: V,S
//:: Range: 60 ft.
//:: Area: Cone
//:: Duration: Instant
//:: Saving Throw: Reflex partial
//:: Spell Resistance: No
//:: You create a liquid landslide of molten-hot volcanic material. All
//:: creatures in the area of the spell take 10d6 points of fire damage.
//:: Additionally, those creatures are coated in a thick layer of viscous
//:: substance, slowing them for the next 3 rounds and dealing an additional 5d6
//:: points of dire damage per round. A successful Reflex save reduces the
//:: initial damage by half and prevents the slow effect and the additional
//:: damage.
//:: 
//:: A rushing torrent of liquid rock bursts from the ground, washing over
//:: your foes.
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nMetaMagic = HkGetMetaMagicFeat();
	float fDelay;
	location lTargetLocation = HkGetSpellTargetLocation();
	float fMaxDelay = 0.0f;
	int iDamage;
	int iOrigDmg;
	//int iSpellPower = HkGetSpellPower( oCaster, 10  );
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------		
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_CONE_FIRE, SC_SHAPE_BREATHCONE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(FeetToMeters(60.0f));
	float fDuration = HkApplyMetamagicDurationMods( 18.0f );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect(iHitEffect);
	effect eFire;
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId()));
			fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
			if(oTarget != oCaster)
			{
				iDamage = HkApplyMetamagicVariableMods(d6(10), 60);
				iOrigDmg = iDamage;
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType ) ;
				
				if ( iOrigDmg == iDamage )
				{
					effect eLink = EffectSlow();
					eLink = EffectLinkEffects(eLink, EffectDamageOverTime(iDamage/2, 5.5f, iDamageType));
					eFire = EffectDamage(iDamage, iDamageType );
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				}
				else if ( iDamage > 0 )
				{
					eFire = EffectDamage(iDamage, iDamageType );
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE);
	}
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_FIRE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, fMaxDelay);
}