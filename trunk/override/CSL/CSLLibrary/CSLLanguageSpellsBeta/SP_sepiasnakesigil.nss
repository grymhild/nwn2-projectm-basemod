//::///////////////////////////////////////////////
//:: Sepia Snake Sigil
//:: SP_sepiasnakesigil.nss
//:: 2010 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
	Conjuration (Creation) [Force]
	Level:	Brd 3, Sor/Wiz 3
	Components:	V, S, M
	Casting Time:	10 minutes
	Range:	Touch
	Target:	One touched book or written work
	Duration:	Permanent or until discharged; until released or 1d4 days + one day/level; see text
	Saving Throw:	Reflex negates
	Spell Resistance:	No
	When you cast sepia snake sigil, a small symbol appears in the text of one written work such as a book, scroll, or map. The text containing the symbol must be at least twenty-five words long. When anyone reads the text containing the symbol, the sepia snake springs into being and strikes the reader, provided there is line of effect between the symbol and the reader.
	
	Simply seeing the enspelled text is not sufficient to trigger the spell; the subject must deliberately read it. The target is entitled to a save to evade the snake's strike. If it succeeds, the sepia snake dissipates in a flash of brown light accompanied by a puff of dun-colored smoke and a loud noise. If the target fails its save, it is engulfed in a shimmering amber field of force and immobilized until released, either at your command or when 1d4 days + one day per caster level have elapsed.
	
	While trapped in the amber field of force, the subject does not age, breathe, grow hungry, sleep, or regain spells. It is preserved in a state of suspended animation, unaware of its surroundings. It can be damaged by outside forces (and perhaps even killed), since the field provides no protection against physical injury. However, a dying subject does not lose hit points or become stable until the spell ends.
	
	The hidden sigil cannot be detected by normal observation, and detect magic reveals only that the entire text is magical.
	
	A dispel magic can remove the sigil. An erase spell destroys the entire page of text.
	
	Sepia snake sigil can be cast in combination with other spells that hide or garble text, such as secret page.
	
	Material Component
	500 gp worth of powdered amber, a scale from any snake, and a pinch of mushroom spores.
*/

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SEPIA_SNAKE_SIGIL; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eDurVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  // Duration effect
    effect eImpVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
    SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurVis, oCaster, fDuration);

    HkPostCast(oCaster);
}


