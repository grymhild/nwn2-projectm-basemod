//::///////////////////////////////////////////////
//:: Sacred Flames
//:: nx_s2_sacredflames.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At 4th level, a sacred fist may use a
	standard action to invoke sacred flames around his hands and
	feet. These flames add to the sacred fist's unarmed damage.
	The additional damage is equal to the sacred fistâ€™s class level
	plus his Wisdom modifier (if any). Half the damage is fire
	damage (round up), and the rest is sacred energy and thus
	not subject to effects that reduce fire damage. The sacred
	flames last 1 minute and can be invoked once per day. At 8th
	level, a sacred fist can invoke sacred flames twice per day.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/01/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/28/2007: Flamey fist VFX.

#include "_HkSpell"
#include "_CSLCore_Items"
#include "_HkSpell"
 // for spell id constant


void main()
{
	//scSpellMetaData = SCMeta_FT_sacredflames();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	
	
	// Cancels if wielding a weapon, need to add sheilds later
	object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
	if (CSLItemGetIsAWeapon(oWeapon1))
	{   // holding weapon, do not allow this to work
		SendMessageToPC(oCaster, "As what you carry, breaks your oath, so too do your sacred flame fizzle");
			return;
	}
	object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	if (CSLItemGetIsAWeapon(oWeapon2))
	{   // holding weapon, do not allow this to work
		SendMessageToPC(oCaster, "As what you carry, breaks your oath, so too do your sacred flame fizzle");
			return;
	}
	

		
	int nTotalDamage  = GetLevelByClass(CLASS_TYPE_SACREDFIST);
	int nWisdomBonus  = GetAbilityModifier(ABILITY_WISDOM);
	if (nWisdomBonus > 0)
	{
		nTotalDamage += nWisdomBonus;
	}
	
	int nDivineDamage = nTotalDamage/2; // Half of bonus (rounded down) is divine damage.
	int nFireDamage   = nTotalDamage - nDivineDamage; // The rest (half rounded up) is fire damage.
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_SACRED_FLAMES, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	/* This damage section is being commented out, when obsidian fixes, just remove this comment
	effect eDivineDamage = EffectDamageIncrease(CSLGetDamageBonusConstantFromNumber(nDivineDamage), DAMAGE_TYPE_DIVINE );
	effect eFireDamage   = EffectDamageIncrease(CSLGetDamageBonusConstantFromNumber(nFireDamage), iDamageType );
	effect eFists = EffectVisualEffect(VFX_DUR_SACRED_FLAMES);
	
	effect eLink = EffectLinkEffects(eDivineDamage, eFireDamage);
	eLink = EffectLinkEffects(eLink, eFists);
	*/
	// Begin sacred fist damage fix
		effect eFireDamage   = EffectDamageIncrease(CSLGetDamageBonusConstantFromNumber(nFireDamage), iDamageType );
		effect eFists = EffectVisualEffect( iShapeEffect );
		effect eLink = EffectLinkEffects(eFists, eFireDamage);
		eLink = SetEffectSpellId(eLink, SPELLABILITY_SACRED_FLAMES);
	// End sacred fist damage fix
	//Fire cast spell at event for the specified target
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	// Spell does not stack
	if (GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
		//SCRemoveSpellEffects(GetSpellId(), OBJECT_SELF, OBJECT_SELF);
	}

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(10)); // Lasts 10 rounds = 1 minute.
	
	HkPostCast(oCaster);
}