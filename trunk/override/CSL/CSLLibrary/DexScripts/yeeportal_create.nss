#include "_SCInclude_Graves"

void main()
{
   object oPC = OBJECT_SELF;
   object oTree = GetObjectByTag("GNOLL_TREE");
   location lTarget = GetLocation(GetObjectByTag("WP_PORT_YEENOGHU"));
   if (oTree!=OBJECT_INVALID) {
      PlaySound("sff_rainmeteor");
      DestroyObject(oTree, 1.0);
   }
  // effect ePortal = EffectNWN2SpecialEffectFile("fx_kos_portal_small.sef");
  // ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePortal, lTarget, HoursToSeconds(4));

   effect eAOE = EffectAreaOfEffect(AOE_PER_FOGKILL, "****", "****", "****", "PORT_YEENOGHU");
   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, HoursToSeconds(4));
   
   effect ePortalAppear = EffectNWN2SpecialEffectFile("fx_magical_explosion.sef");
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePortalAppear, lTarget);
   object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, "yeeportal", lTarget);
   SetLocalInt(oPortal, "USES", 10);
   SetLocalString(oPortal, "DESTINATION", "wp_yeerealm");
   effect ePortal = EffectNWN2SpecialEffectFile("fx_kos_portal_small.sef");
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePortal, oPortal);
   DelayCommand(HoursToSeconds(4), DestroyPortal(oPortal));
} 