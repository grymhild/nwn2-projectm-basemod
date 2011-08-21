//::///////////////////////////////////////////////
//:: Reaving Dispel
//:://////////////////////////////////////////////
//::Reaving Dispel (Beta)
//::Abjuration 
//::Level: Sorcerer/wizard 9 
//::Saving Throw: See text 
//::Spell Resistance: No 
//::
//::Bringing to your lips some of the most elemental words
//::of arcane power, you feel stirring within you the
//::spirits of ancient mages as you prepare to absorb the
//::spell energies you have targeted. Your body shakes
//::uncontrollably, as if eagerly anticipating the power
//::behind those spells. This spell functions like dispel
//::magic, except that your caster level for your dispel
//::check is a maximum of +20 instead of +10, and (as with
//::greater dispel magic) you have a chance to dispel any
//::effect that remove curse can remove, even if dispel
//::magic can't dispel that effect. When casting a targeted
//::dispel or counterspell, you can choose to reave each
//::spell you successfully dispel, stealing its power and
//::effect for yourself. When making a targeted dispel,
//::make a Spellcraft check (DC 25 + spell level) to
//::identify the target spell or each ongoing spell
//::currently in effect on the target creature or object.
//::
//::Each spell you dispel with a targeted dispel can be
//::reaved if you so desire, and the spell's effects are
//::redirected to you, continuing as if cast on you by the
//::original caster with no interruption to or extension of
//::duration. Once you reave the spell, you identify it if
//::you haven't done so already (see below). If the subject
//::was the caster and the spell is dismissible, you can
//::dismiss it as if you had cast it yourself. Likewise, if
//::the subject was the caster and the spell requires
//::concentration, you must concentrate to maintain the
//::spell's effect as if you had cast it yourself.
//::
//::You can still attempt to reave a spell you didn't
//::identify with your Spellcraft check, but doing so can
//::be risky if you don't know the specifics of the spell's
//::effect. For example, if you fail to identity an ongoing
//::spell effect on an enemy character and choose to reave
//::anyway, you might find yourself under the influence of
//::the dominate person effect that character was suffering
//::from. Any spell resistance you might have has no effect
//::against harmful spells you might inadvertently reave,
//::but you get the same chance to save against those spell
//::effects as the original target.
//::
//::If you choose to reave a spell you have successfully
//::counterspelled with reaving dispel, you seize control
//::of the spell after the enemy caster completes it, and
//::you can redirect the spell to whatever targets or area
//::you wish (including the original caster, if
//::appropriate). Again, you must make a Spellcraft check
//::(DC 25 + spell level) to identify the spell you intend
//::to reave, but you are free to choose to redirect a
//::spell whose effect, range, and area you don't know. If
//::the redirected spell's correct casting conditions
//::aren't met (because you guess at an improper target or
//::range, for example), the spell fails. Reaving dispel
//::can be used to cast an area dispel with the increased
//::maximum caster level, but any magical effects so
//::dispelled cannot be reaved.


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_dispmagic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REAVING_DISPEL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_FNF_DISPEL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (  GetIsObjectValid(oTarget)  )
	{
		DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, SCGetDispellCount(iSpellId, TRUE), SPELL_REAVING_DISPEL, TRUE ) );
	}
	else
	{
		location lLocal = HkGetSpellTargetLocation();
		int nStripCnt = SCGetDispellCount(iSpellId, FALSE);
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		while (GetIsObjectValid(oTarget) && nStripCnt > 0)
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT)
			{
				SCDispelAoE(oTarget, oCaster, SPELL_REAVING_DISPEL );
			}
			else
			{
				DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELL_REAVING_DISPEL ) );
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		}
	}
	HkPostCast(oCaster);	
}

