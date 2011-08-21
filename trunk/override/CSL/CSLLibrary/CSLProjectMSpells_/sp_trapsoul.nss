//::///////////////////////////////////////////////
//:: Spell Template
//:: sp_template.nss
//:: 2009 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
Conjuration (Summoning)
Level:	Sor/Wiz 8
Components:	V, S, M, (F); see text
Casting Time:	1 standard action or see text
Range:	Close (25 ft. + 5 ft./2 levels)
Target:	One creature
Duration:	Permanent; see text
Saving Throw:	See text
Spell Resistance:	Yes; see text
Trap the soul forces a creature’s life force (and its material body) into a gem. The gem holds the trapped entity indefinitely or until the gem is broken and the life force is released, which allows the material body to reform. If the trapped creature is a powerful creature from another plane it can be required to perform a service immediately upon being freed. Otherwise, the creature can go free once the gem imprisoning it is broken.
Depending on the version selected, the spell can be triggered in one of two ways.
Spell Completion
First, the spell can be completed by speaking its final word as a standard action as if you were casting a regular spell at the subject. This allows spell resistance (if any) and a Will save to avoid the effect. If the creature’s name is spoken as well, any spell resistance is ignored and the save DC increases by 2. If the save or spell resistance is successful, the gem shatters.
Trigger Object
The second method is far more insidious, for it tricks the subject into accepting a trigger object inscribed with the final spell word, automatically placing the creature’s soul in the trap. To use this method, both the creature’s name and the trigger word must be inscribed on the trigger object when the gem is enspelled. A sympathy spell can also be placed on the trigger object. As soon as the subject picks up or accepts the trigger object, its life force is automatically transferred to the gem without the benefit of spell resistance or a save.
Material Component
Before the actual casting of trap the soul, you must procure a gem of at least 1,000 gp value for every Hit Die possessed by the creature to be trapped. If the gem is not valuable enough, it shatters when the entrapment is attempted. (While creatures have no concept of level or Hit Dice as such, the value of the gem needed to trap an individual can be researched. Remember that this value can change over time as creatures gain more Hit Dice.)
Focus (Trigger Object Only)
If the trigger object method is used, a special trigger object, prepared as described above, is needed.



Implementation notes:
need a powerful gem, so check for tag and gold piece value, instant level restriction to value of hte gem

Make it not work on PC's at least at first. Also check for Plot, and for "boss" var being set.

Casting on a target changes the Gem to a specific tagged item, it contains a tag with the tag of the creature appened to it.

Store the creature in the bioware DB with that tag, and put the real creature in limbo ( so it works over resets )

Then implement a  tag based script, for on use of gem which recalls the creature, sets them hostile to the caster and immediately attacks. Might have some custom code here to handle module specific cases.

*/
//:://////////////////////////////////////////////
//:: Based on Work of: Author
//:: Created On:
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	CSLSpellEvilShift( oCaster )
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	
	location lTarget = HkGetSpellTargetLocation();

	int iDuration = HkGetSpellDuration(oCaster);
	int iSpellPower = HkGetSpellPower(oCaster, 10);
	
	int iSaveDC = HkGetSpellSaveDC();
	
	int iDamageType = HkGetDamageType(DAMAGE_TYPE_FIRE);
	int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_FIRE);
	
	float fTargetSize = HkApplySizeMods( RADIUS_SIZE_HUGE );
	int iTargetShape = HkApplyShapeMods( SHAPE_SPHERE );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	int iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect( HkGetHitEffect(VFX_IMP_FLAME_M) );
	effect eHit;
	
	//--------------------------------------------------------------------------
	// AOE
	//--------------------------------------------------------------------------
	//string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	//effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "", "", "", sAOETag);
	//DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	
	//--------------------------------------------------------------------------
	// Remove Previous Versions of this spell
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	
	
	//--------------------------------------------------------------------------
	// Apply effects
	//--------------------------------------------------------------------------
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	// Visual
	effect eExplode = EffectVisualEffect( HkGetShapeEffect( VFX_FNF_FIREBALL ) );
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}