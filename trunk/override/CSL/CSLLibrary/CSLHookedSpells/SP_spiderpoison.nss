//::///////////////////////////////////////////////
//:: Spider Poison
//:: sg_s0_spidpois.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Necromancy
     Level: Asn 3, Sor/Wiz 3
     Components: V,S
     Casting Time: 1 action
     Range: Touch
     Target: Creature Touched
     Duration: Instantaneous (see text)
     Saving Throw: Fortitude negates (see text)
     Spell Resistance: Yes

     Similar to the divine spell Poison, you inflict a
     paralyzing poison up the subject by making a
     successfuly melee touch attack.  The poison deals
     1d6 points of temporary Strength damage immediately
     and another 1d6 points of temporary Strength damage
     1 minute later.  Each instance of damage can be
     negated by a Fortitude save (DC 10 + one-half
     caster level + caster's Intelligence or Charisma
     modifier, for wizards and sorcerers, respectively).
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 4, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
//
// 
// 
//     //--------------------------------------------------------------------------
//     // Spellcast Hook Code
//     // Added 2003-06-20 by Georg
//     // If you want to make changes to all spells, check x2_inc_spellhook.nss to
//     // find out more
//     //--------------------------------------------------------------------------
//     if (!X2PreSpellCastCode())
//     {
//         return;
//     }
    // End of Spell Cast Hook
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
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect ePoison = EffectPoison(POISON_LARGE_SPIDER_VENOM);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SPIDER_POISON));
    int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
        if(!HkResistSpell(oCaster, oTarget))
        {
            HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
        }
    }

    HkPostCast(oCaster);
}


