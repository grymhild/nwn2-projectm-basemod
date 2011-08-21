//::///////////////////////////////////////////////
//:: Warp Wood
//:: LK_S0_WarpWood.nss
//:: Copyright (c) 2004 Dennis Dollins
//:://////////////////////////////////////////////
/*
    This spell affects the wielded wooden hafted weapons
    and worn quivers of bolts and arrows of the targeted
    creature. Items affected by the spell become warped
    and splintered and useless.

    The affected items have to make a saving throw to
    avoid being destroyed.  This is against a DC thats
    equal to the caster's level * 2.  Items get a bonus
    to their saving throw roll based on their value / 300.
    The higher the value the higher the bonus.

    The spell can be Empowered or Maximized to enable it
    to affect a higher range of items and affect
    items more easily.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001
//
// 
//
//
// 
// void main()
// {
// 
// 
//     float   fDuration;       //= RoundsToSeconds(iCasterLevel);
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    //int     iDieType        = 0;
    //int     iNumDice        = 0;
    //int     iBonus          = 0;
    int     iDamage         = 0;

    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
    int iGoldValue = GetGoldPieceValue(oWeapon);
    int iD20;
    int iSlot = 11;
    int iD=FALSE;
    int iAffectMagic = FALSE;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	int iDC = HkApplyMetamagicVariableMods( iCasterLevel*2, iCasterLevel * 4 );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpact = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WARP_WOOD));
    if(!HkResistSpell(oCaster, oTarget)) {
        HkApplyEffectToObject(DURATION_TYPE_INSTANT,eImpact,oTarget);
        if((oWeapon!=OBJECT_INVALID) &&
            (!GetPlotFlag(oWeapon)) &&
            ((GetBaseItemType(oWeapon)==BASE_ITEM_HEAVYCROSSBOW)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_LIGHTCROSSBOW)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_LONGSWORD)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_SHORTBOW)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_SHORTSPEAR)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_DIREMACE)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_DOUBLEAXE)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_DWARVENWARAXE)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_GREATAXE)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_HALBERD)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_HANDAXE)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_HEAVYFLAIL)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_KAMA)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_LIGHTFLAIL)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_LIGHTHAMMER)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_LIGHTMACE)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_MAGICSTAFF)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_MORNINGSTAR)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_QUARTERSTAFF)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_SCYTHE)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_SICKLE)||
             (GetBaseItemType(oWeapon)==BASE_ITEM_WARHAMMER)))
        {
            iD20 = d20();
            iD20=iD20+(iGoldValue/300);
            if(iD20<iDC) {
                iD=TRUE;
                DestroyObject(oWeapon);
                if(!GetIsPC(oTarget)) {
                    FloatingTextStringOnCreature("*"+GetName(oTarget)+"'s weapon warps and shatters!*",oTarget,FALSE);
                } else {
                    FloatingTextStringOnCreature("*Your weapon warps and shatters!*",oTarget,FALSE);
                }
            }
        }
        while(iSlot!=15) {
            oWeapon = GetItemInSlot(iSlot,oTarget);
            iGoldValue = GetGoldPieceValue(oWeapon);
            if((oWeapon!=OBJECT_INVALID) && (!GetPlotFlag(oWeapon))) {
                iD20 = d20();
                iD20=iD20+(iGoldValue/300);
                if(iD20<iDC) {
                    iD=TRUE;
                    DestroyObject(oWeapon);
                    if(!GetIsPC(oTarget))                     {
                        FloatingTextStringOnCreature("*"+GetName(oTarget)+"'s ammo warps and shatters!*",oTarget,FALSE);
                    } else {
                        FloatingTextStringOnCreature("*Your ammo warps and shatters!*",oTarget,FALSE);
                    }
                }
            }
            iSlot=iSlot+2;
        }
        if(iD) HkApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_COM_CHUNK_STONE_SMALL),oTarget);
    }

    HkPostCast(oCaster);
}
