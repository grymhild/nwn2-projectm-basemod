//#include "_inc_helper_functions"
#include "_CSLCore_Items"
#include "_CSLCore_Position"
#include "_SCInclude_MagicStone"

const int KEG_COST_ABILITY       = 25;
const int KEG_COST_BLESSWEAPON   = 50;
const int KEG_COST_GRMAGICWEAPON = 50;
const int KEG_COST_DEAFCLANG     = 75;
const int KEG_COST_FLAMEWEAPON   = 75;
const int KEG_COST_HASTE         = 0;

void ApplyBoost(object oUser, int iSpellId, string sFloatText = "")
{
	object oCaster = GetObjectByTag("BABA_YAGA");
	
	//AssignCommand(oUser, ActionPlayAnimation(ANIMATION_FIREFORGET_ACTIVATE));
	
	AssignCommand(oCaster, ActionCastSpellAtObject(iSpellId, oUser, METAMAGIC_PERSISTENT, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	//ActionCastSpellAtObject(iSpellId, oUser, METAMAGIC_PERSISTENT, TRUE); // nice! METAMAGIC_PERSISTENT sets fDuration = 24 hours
	//ActionCastSpellAtObject(iSpellId, oUser, METAMAGIC_PERSISTENT, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	// ActionCastSpellAtObject(iSpellId, oUser, METAMAGIC_ANY, TRUE);
	if (sFloatText != "") FloatingTextStringOnCreature(sFloatText, oUser, TRUE);
	DeleteLocalInt(oUser, "BUFFING");
}

void BoostBuddy(object oUser, int iSpellId, int iBeam = 0)
{
   object oFam = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oUser);
   if (!GetIsObjectValid(oFam)) oFam = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oUser);
   if (!GetIsObjectValid(oFam)) oFam = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser);
   if (GetIsObjectValid(oFam))
   {
      if (iBeam !=0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oUser, BODY_NODE_CHEST), oFam, 0.75);
      DelayCommand(0.5, ApplyBoost(oFam, iSpellId));
      object oSum = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser);
      if (GetIsObjectValid(oSum) && oFam!=GetAssociate(ASSOCIATE_TYPE_SUMMONED, oUser))
      {
         if (iBeam !=0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oFam, BODY_NODE_CHEST), oSum, 0.75);
         DelayCommand(0.5, ApplyBoost(oSum, iSpellId));
      }
   }
}

int PayPiper(object oUser, int nCost)
{
   object oFish = GetItemPossessedBy(oUser, "slimemoss"); // SHE LOVES FISHHEADS
   if (GetIsObjectValid(oFish))
   {
      DestroyObject(oFish);
      SendMessageToPC(oUser, "Baba Yaga eats your Green Slime Moss.");
      PlaySound(CSLPickOne("as_pl_x2rghtav1","as_pl_x2rghtav2","as_pl_x2rghtav3"));
      return TRUE;
   }
   if (nCost == 0) return TRUE; // FREEBIE
   nCost *= GetHitDice(oUser);
   if (nCost > GetGold(oUser))
   {
      FloatingTextStringOnCreature("Sorry, no credit.", oUser, TRUE);
      return FALSE;
   }
   TakeGoldFromCreature(nCost, oUser);
   PlaySound("it_coins");
   return TRUE;
}

int AlreadyBuffed(object oUser, int iSpellId)
{
   if (GetHasSpellEffect(iSpellId, oUser))
   {
      FloatingTextStringOnCreature("Already buffed.", oUser, TRUE);
      return TRUE;
   }
   if (GetLocalInt(oUser, "BUFFING"))
   {
      FloatingTextStringOnCreature("Waiting for buff...", oUser, TRUE);
      return TRUE;
   }
   return FALSE;

}

void KegDrink(object oUser, int iSpellId, int nCost, string sFloatText = "")
{
	if (AlreadyBuffed(oUser, iSpellId)) return;
	if (!PayPiper(oUser, nCost)) return;
	SetLocalInt(oUser, "BUFFING", TRUE);
	AssignCommand(oUser, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
	DelayCommand(1.0, ApplyBoost(oUser, iSpellId, sFloatText));
	DelayCommand(1.1, BoostBuddy(oUser, iSpellId));
}

void EquipLR(object oUser, object oRight, object oLeft)
{
	AssignCommand(oUser, ActionEquipItem(oRight, INVENTORY_SLOT_RIGHTHAND));
	AssignCommand(oUser, ActionEquipItem(oLeft, INVENTORY_SLOT_LEFTHAND));
	// SendMessageToPC(oUser, "Left is " + GetName(oLeft) + " Right is " + GetName(oRight) + " self="+GetTag(OBJECT_SELF));   
}

void DoLeft(object oUser, int iSpellId, object oLeft, object oRight)
{
	AssignCommand(oUser, ClearAllActions());
	AssignCommand(oUser, ActionUnequipItem(oRight));
	DelayCommand(1.0, ApplyBoost(oUser, iSpellId));
	DelayCommand(2.0, EquipLR(oUser, oRight, oLeft));
} 

void GemUse(object oUser, int iSpellId, int nCost, int iBeam)
{
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser);
	if (oRight==OBJECT_INVALID)
	{
		FloatingTextStringOnCreature("No Weapon Held.", oUser, TRUE);
		return;
	}
	if (AlreadyBuffed(oUser, iSpellId)) return;
	object oCaster = GetObjectByTag("BABA_YAGA");
	if ( GetLocalInt(oCaster, "BUFFING" ) == TRUE  )
	{
		if ( d100() > 80 )
		{
			FloatingTextStringOnCreature("Don't Bother me, I should just turn you into a frog.", oCaster, TRUE);
		}
		else
		{
			FloatingTextStringOnCreature("Ok that's it, i'll buff you, but i'll tell everyone where you go hide.", oCaster, TRUE);
		}
		return;
	}
	if (!PayPiper(oUser, nCost)) return;
	SetLocalInt(oUser, "BUFFING", TRUE);
	DelayCommand( 6.0f, SetLocalInt(oCaster, "BUFFING", FALSE ) );
	
	SetLocalInt(oCaster, "BUFFING", TRUE);
	AssignCommand(oCaster, ClearAllActions());
	AssignCommand(oCaster, SetFacingPoint(GetPosition(oUser)));
	AssignCommand(oCaster, PlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 2.5));
	DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(iBeam, oCaster, BODY_NODE_HAND), OBJECT_SELF, 2.20));
	DelayCommand(0.9, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
	DelayCommand(1.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ELDRITCH), OBJECT_SELF));
	DelayCommand(2.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_MAGIC), oCaster));
	DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_SONIC), OBJECT_SELF));
	DelayCommand(2.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DUST_EXPLOSION), oCaster));
	DelayCommand(2.4, AssignCommand(oCaster, PlayAnimation(CSLPickOneInt(ANIMATION_FIREFORGET_KNEELDAMAGE,ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD,ANIMATION_FIREFORGET_TAUNT,ANIMATION_FIREFORGET_BOW,ANIMATION_FIREFORGET_SALUTE,ANIMATION_FIREFORGET_VICTORY1))));
	DelayCommand(2.5, ApplyBoost(oUser, iSpellId));
	DelayCommand(2.6, BoostBuddy(oUser, iSpellId, iBeam));
	object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oUser);
	if (oLeft!=OBJECT_INVALID)
	{
		if (CSLItemGetIsMeleeWeapon(oLeft))
		{
			if (PayPiper(oUser, nCost))
			{
				DelayCommand(4.0, DoLeft(oUser, iSpellId, oLeft, oRight));
				//            DelayCommand(2.7, AssignCommand(oUser, ClearAllActions()));
				//            DelayCommand(2.8, AssignCommand(oUser, ActionUnequipItem(oRight)));
				//            DelayCommand(2.9, ApplyBoost(oUser, iSpellId));
				//            DelayCommand(3.0, AssignCommand(oUser, ActionEquipItem(oRight, INVENTORY_SLOT_RIGHTHAND)));
				//            DelayCommand(3.1, AssignCommand(oUser, ActionEquipItem(oLeft, INVENTORY_SLOT_LEFTHAND)));
			}
		}
	}
	DelayCommand(6.5, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}


void main()
{
   object oLocator;
   location lTarget;
   int iSpellId;
   string sTxt="";
   int nCost;
   int nVFX;
   effect eEffect;
   string sTag=GetTag(OBJECT_SELF);

   object oUser = GetLastUsedBy();
  
   if (CSLStringStartsWith(sTag, "KEG_"))
   {
      object oMug = GetItemPossessedBy(oUser, "bottomless_mug"); // Bonus
      if (GetIsObjectValid(oMug)) nCost = 0;
      else nCost = KEG_COST_ABILITY;
   }
   if (GetIsObjectValid(oUser) && GetIsPC(oUser))
   {
      if (sTag=="KEG_STR") {
         KegDrink(oUser, SPELL_BULLS_STRENGTH, nCost, "<color=green>+4 Str</color>");
         return;
      } else if (sTag=="KEG_CON") {
         KegDrink(oUser, SPELL_BEARS_ENDURANCE, nCost, "<color=green>+4 Con</color>");
         return;
      } else if (sTag=="KEG_DEX") {
         KegDrink(oUser, SPELL_CATS_GRACE, nCost, "<color=green>+4 Dex</color>");
         return;
      } else if (sTag=="KEG_WIS") {
         KegDrink(oUser, SPELL_OWLS_WISDOM, nCost, "<color=green>+4 Wis</color>");
         return;
      } else if (sTag=="KEG_INT") {
         KegDrink(oUser, SPELL_FOXS_CUNNING, nCost, "<color=green>+4 Int</color>");
         return;
      } else if (sTag=="KEG_CHA") {
         KegDrink(oUser, SPELL_EAGLES_SPLENDOR, nCost, "<color=green>+4 Cha</color>");
         return;
      } else if (sTag=="GEM_HASTE") {
         if (CSLGetHasEffectType( oUser, EFFECT_TYPE_MOVEMENT_SPEED_INCREASE )) {
            SendMessageToPC(oUser, "You are already moving too fast...");
            return;
         }
         //GemUse(oUser, SPELL_EXPEDITIOUS_RETREAT, KEG_COST_HASTE, VFX_BEAM_ABJURATION);
         object oQuick = GetItemPossessedBy(oUser, "quickstone"); // Bonus
         if (GetIsObjectValid(oQuick)) KegDrink(oUser, SPELL_HASTE, KEG_COST_HASTE, "<color=limegreen>Haste!!</color>");
         else KegDrink(oUser, SPELL_EXPEDITIOUS_RETREAT, KEG_COST_HASTE, "Speed!");
         return;
      } else if (sTag=="GEM_BLESSWEAPON") {
         iSpellId = SPELL_BLESS_WEAPON;
         nCost = KEG_COST_BLESSWEAPON;
         nVFX = VFX_BEAM_HOLY;
      } else if (sTag=="GEM_CLANG") {
         iSpellId = SPELL_DEAFENING_CLANG;
         nCost = KEG_COST_DEAFCLANG;
         nVFX = VFX_BEAM_LIGHTNING;
      } else if (sTag=="GEM_FLAMEWEAPON") {
         iSpellId = SPELL_FLAME_WEAPON;
         nCost = KEG_COST_FLAMEWEAPON;
         nVFX = VFX_BEAM_FIRE;
      } else if (sTag=="GEM_GMW") {
         iSpellId = SPELL_GREATER_MAGIC_WEAPON;
         nCost = KEG_COST_GRMAGICWEAPON;
         nVFX = VFX_BEAM_ELDRITCH;
      }
      if (GetIsObjectValid(GetItemPossessedBy(oUser, "sealichidol"))) nCost = 0;
      GemUse(oUser, iSpellId, nCost, nVFX);
   } else  {
      SendMessageToPC(oUser,"Doh! OnUsedBonusElse!");
   }
}

/*
void refundMoney( oUser, iSpellId, nAmount )
{
	if (GetHasSpellEffect(iSpellId, oUser))
	{
	
	}
}
*/