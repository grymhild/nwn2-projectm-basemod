using System.Drawing;
using AvengersUTD.Odyssey.UserInterface.Style;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{
    public class PictureBox : DefaultShapeControl, ISpriteControl
    {
        Texture texture;

        protected static ColorArray defaultColors = new ColorArray(
            Color.Transparent,
            Color.Transparent,
            Color.Transparent,
            Color.DarkGray,
            Color.Transparent,
            Color.Transparent,
            ColorOperator.Scale(Color.Gray, 1.15f),
            Color.LightGray
            );

        public PictureBox(string id, Vector2 position, Size size, Texture texture)
            : base(id, position, size, Shape.Rectangle, BorderStyle.None, Shapes.ShadeNone, defaultColors)
        {
            this.texture = texture;
        }

        public override bool IntersectTest(Point cursorLocation)
        {
            return Intersection.RectangleTest(absolutePosition, size, cursorLocation);
        }

        public Texture Texture
        {
            get { return texture; }
            set { texture = value; }
        }


        #region ISpriteControl Members

        public void Render()
        {
            if (texture != null)
                UI.CurrentHud.SpriteManager.Draw(texture, Rectangle.Empty, Vector3.Empty, new Vector3(absolutePosition.X, absolutePosition.Y, 0), Color.White);

            //SurfaceDescription sd = texture.GetLevelDescription(0);
            //UI.CurrentHud.SpriteManager.Draw2D(texture, new Rectangle(0, 0, sd.Width, sd.Height), new SizeF(size.Width, size.Height), new PointF(absolutePosition.X, absolutePosition.Y), Color.White);
        }

        public override void Update()
        {
            base.Update();
        }

        #endregion
    }
}