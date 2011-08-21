//#include "_SCUtility"

//* int nReserved -- reserved for future use, ignore */
//* int nObjectTypeMask -- Bitmask of interested objects */
//* object AreaObjectId -- area object to query */

void main( int nReserved, int nObjectTypeMask, object oArea )
{

	object oDM = OBJECT_SELF;
	
	// use my permissions system later for own use
	if ( !GetIsDM( oDM ) && !GetIsDMPossessed( oDM ) )
	{
		return;
	}
	
	if ( GetLocalInt(oDM,"SCLIENTEXTENDER" ) != TRUE )
	{
		return; // they are not flagged as having the client extender
	}
	
	int iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	int iWidth = GetAreaSize( AREA_WIDTH, oArea );
	
	if ( iHeight == 0 )
	{
		// invalid area
		return;
	}
	float fHeight;
	float fWidth;
	float fSize;
	location lCenterOfArea;
	
	if ( GetIsAreaInterior( oArea ) ) // interiors and exteriors are different sizes, did not add the size of half a square which may or may not be correct, not really material
	{
		fHeight = iHeight*9.0f;
		fWidth = iWidth*9.0f;
	}
	else
	{
		fHeight = iHeight*10.0f;
		fWidth = iWidth*10.0f;
	}
	
	lCenterOfArea = Location(oArea, Vector(fHeight/2, fWidth/2, 0.0), 0.0f );
	
	if ( fHeight > fWidth )
	{
		fSize = fHeight/2;
	}
	else
	{
		fSize = fWidth/2;
	}
	
	object oTarget = GetFirstObjectInShape(SHAPE_CUBE, fSize, lCenterOfArea, FALSE, nObjectTypeMask );
	
	while( GetIsObjectValid(oTarget) )
	{ 
		vector vPosition = GetPosition(oTarget);
   		float fOrientation = GetFacing(oTarget);
		
		SendMessageToPC( oDM, "SCliExt11"+ObjectToString(oTarget)+" "+FloatToString(vPosition.x)+" "+FloatToString(vPosition.y)+" "+FloatToString(vPosition.z)+" "+FloatToString(fOrientation)+"");
		
		oTarget = GetNextObjectInShape(SHAPE_CUBE, fSize, lCenterOfArea, FALSE, nObjectTypeMask );
	}
	
	SendMessageToPC( oDM, "SCliExt12"+ObjectToString( oArea ) );
	

	
	/*
	// Get the first object in oArea.
// If no valid area is specified, it will use the caller's area.
// * Return value on error: OBJECT_INVALID
object GetFirstObjectInArea(object oArea=OBJECT_INVALID);

// Get the next object in oArea.
// If no valid area is specified, it will use the caller's area.
// * Return value on error: OBJECT_INVALID
object GetNextObjectInArea(object oArea=OBJECT_INVALID);

// Get the first object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetPosition(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. Line of sight check is done from origin to target object
//   at a height 1m above the ground
//   (This can be used to ensure that spell effects do not go through walls.)
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or".
//   For example, to return only creatures and doors, the value for this
//   parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the
//   origin of the effect(normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
object GetFirstObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);

// Get the next object in nShape
// - nShape: SHAPE_*
// - fSize:
//   -> If nShape == SHAPE_SPHERE, this is the radius of the sphere
//   -> If nShape == SHAPE_SPELLCYLINDER, this is the length of the cylinder
//   -> If nShape == SHAPE_CONE, this is the widest radius of the cone
//   -> If nShape == SHAPE_CUBE, this is half the length of one of the sides of
//      the cube
// - lTarget: This is the centre of the effect, usually GetSpellTargetPosition(),
//   or the end of a cylinder or cone.
// - bLineOfSight: This controls whether to do a line-of-sight check on the
//   object returned. (This can be used to ensure that spell effects do not go
//   through walls.) Line of sight check is done from origin to target object
//   at a height 1m above the ground
// - nObjectFilter: This allows you to filter out undesired object types, using
//   bitwise "or". For example, to return only creatures and doors, the value for
//   this parameter would be OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR
// - vOrigin: This is only used for cylinders and cones, and specifies the origin
//   of the effect (normally the spell-caster's position).
// Return value on error: OBJECT_INVALID
object GetNextObjectInShape(int nShape, float fSize, location lTarget, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, vector vOrigin=[0.0,0.0,0.0]);


*/
	
	
	
}