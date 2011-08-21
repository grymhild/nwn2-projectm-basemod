
void main()
{
	int Level, SpawnCount;
	object Area, oPC;
	string AreaTag;
	
	oPC=GetEnteringObject();
	ExploreAreaForPlayer(OBJECT_SELF, oPC);
	RecomputeStaticLighting(GetArea(OBJECT_SELF));
}
