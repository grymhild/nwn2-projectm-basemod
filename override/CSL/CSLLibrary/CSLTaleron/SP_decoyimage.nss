////////////////////////////////////
//::Decoy Image
//::Reduced to a copy of just the caster due to instability issues
//////////////////////////////////////


#include "_HkSpell"

void main()
{	
	
object 		oPC 		= OBJECT_SELF;
location	lTarget		= GetSpellTargetLocation();
int			nDuration	= HkGetCasterLevel(oPC);
if 	(HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
	{nDuration = nDuration * 2;}
effect		eSpellFailure = EffectArcaneSpellFailure(100);
effect		eAttack		= EffectAttackDecrease(40);
effect		eArmor		= EffectACDecrease(40);
object		oArea		= GetArea(oPC);
object 		oCopy		= CopyObject(oPC,lTarget);
object		oClone		= oCopy;

	ResetCreatureLevelForXP(oClone,1,FALSE);

////////////////////Make Sure none of the clones items drop////////////////
object	oItem = GetFirstItemInInventory(oClone);
	while (GetIsObjectValid(oItem))
		{
		SetDroppableFlag(oItem,FALSE);
		oItem = GetNextItemInInventory(oClone);
		}

int nInventorySlot = 0;
while (nInventorySlot < 18)
	{
	oItem = GetItemInSlot(nInventorySlot,oClone);
	SetDroppableFlag(oItem,FALSE);
	nInventorySlot = nInventorySlot +1;
	}

///////////////////////////////////////////////////////////////////////////


////////////////////Get Rid of All Gold on Creature///////////////////////
int nGold = GetGold(oClone);
	TakeGoldFromCreature(nGold,oClone,TRUE,FALSE);
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
DelayCommand(RoundsToSeconds(nDuration),DestroyObject(oClone)); ///////////end the spell
//////////////////////////////////////////////////////////////////////////

object	oInvent	= GetFirstItemInInventory(oClone);
	DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oClone));
	DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oClone));
	DestroyObject(GetItemInSlot(INVENTORY_SLOT_NECK,oClone));
	DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTRING,oClone));
	DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oClone));
	DestroyObject(GetItemInSlot(INVENTORY_SLOT_BELT,oClone));
	DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARMS,oClone));
while (GetIsObjectValid(oInvent))
	{
	DestroyObject(oInvent,0.0);
	oInvent = GetNextItemInInventory(oClone);
	}
	int 		nDamage		= GetCurrentHitPoints(oClone) -1;
effect		eDamage		= EffectDamage(nDamage,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_NORMAL,TRUE);

	ChangeToStandardFaction(oClone,STANDARD_FACTION_COMMONER); //change it to a commoner so it doesn't attack the party
	AssignCommand(oArea,HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oClone)); //have the area do damage so as not to spam the log box
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT,eSpellFailure,oClone);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT,eAttack,oClone);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT,eArmor,oClone);

}