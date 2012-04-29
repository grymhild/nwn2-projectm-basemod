using System.Drawing;
using AvengersUTD.Odyssey.UserInterface.Style;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using Font = Microsoft.DirectX.Direct3D.Font;

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{
    public class Button : DefaultShapeControl, ISpriteControl
    {
        protected static ColorArray defaultColors = new ColorArray(
            Color.RoyalBlue,
            Color.Blue,
            Color.Navy,
            Color.Gray,
            Color.Red,
            Color.Yellow,
            Color.Gray,
            Color.Gray
            );

        protected Label label;
        Texture currentTexture, textureNormal, textureHover, texturePressed;                

        public string Label
        {
            get { return label.Text; }
            set { label.Text = value; }
        }

        public Texture TextureNormal
        {
            get { return textureNormal; }
            set { textureNormal = value; currentTexture = textureNormal;  }
        }

        public Texture TextureHover
        {
            get { return textureHover; }
            set { textureHover = value; }
        }

        public Texture TexturePressed
        {
            get { return texturePressed; }
            set { texturePressed = value; }
        }

        public Font Font
        {
            get { return label.Font; }
            set { label.Font = value; }
        }

        public Color TextColor
        {
            get { return label.Color; }
            set { label.Color = value; }
        }

        #region Constructors

        /// <summary>
        /// Creates a button with default appearance.
        /// </summary>
        /// <param name="id">Id of the control</param>
        /// <param name="text">String to be displayed</param>
        /// <param name="position">Position vector in screen coordinates</param>
        /// <param name="size">Size of the control</param>
        public Button(string id, string text, Vector2 position, Size size) :
            this(id, text, position, size, Shape.Rectangle, Shapes.ShadeTopToBottom, defaultColors)
        {
        }

        /// <summary>
        /// Creates a button, allowing users to specify the control's appearance.
        /// </summary>
        /// <param name="id">Id of the control</param>
        /// <param name="text">String to be displayed</param>
        /// <param name="position">Position vector in screen coordinates</param>
        /// <param name="size">Size of the control</param>
        /// <param name="shape">The shape of the control</param>
        public Button(string id, string text, Vector2 position, Size size, Shape shape)
            : this(id, text, position, size, shape, Shapes.ShadeTopToBottom, defaultColors)
        {
        }

        /// <summary>
        /// Creates a button control
        /// </summary>
        /// <param name="id">Id of the control</param>
        /// <param name="text">String to be displayed</param>
        /// <param name="position">Position vector in screen coordinates</param>
        /// <param name="size">Size of the control</param>
        /// <param name="shape">Shape of the control</param>
        /// <param name="colorArray">Color array to be used</param>
        public Button(string id, string text, Vector2 position, Size size, Shape shape, Shapes.ShadingMode shadeMode,
                      ColorArray colorArray)
            : base(id, position, size, shape, BorderStyle.Raised, shadeMode, colorArray)
        {
            Vector2 labelPosition;
            switch (shape)
            {
                default:
                case Shape.Rectangle:
                case Shape.RightTrapezoidDownside:
                case Shape.RightTrapezoidUpside:
                    labelPosition = Vector2.Empty;
                    break;

                case Shape.LeftTrapezoidDownside:
                case Shape.LeftTrapezoidUpside:
                    labelPosition = new Vector2(TabPanel.DefaultTabTriangleWidth, 0);
                    break;
            }

            label = new Label(id + "_Label",
                              text,
                              LabelSize.Normal,
                              Alignment.Center,
                              Alignment.Center,
                              labelPosition,
                              RenderableControls.Label.DefaultColor
                );
            label.Outline = true;
            label.OutlineColor = Color.Black;
            IsFocusable = false;
           
        }

        #endregion

        public void Render()
        {
            if (currentTexture != null)
                UI.CurrentHud.SpriteManager.Draw(currentTexture, Rectangle.Empty, Vector3.Empty,
                                             new Vector3(absolutePosition.X, absolutePosition.Y, 0), Color.White);
            label.Render();
        }

        public override bool IntersectTest(Point cursorLocation)
        {
            return Intersection.RectangleTest(absolutePosition, size, cursorLocation);
        }

        public override void ComputeAbsolutePosition()
        {
            base.ComputeAbsolutePosition();
            label.Parent = this;
        }

        protected override void OnMouseDown(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {
            currentTexture = texturePressed;
            base.OnMouseDown(ctl, args);
        }

        protected override void OnMouseEnter(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {
            currentTexture = textureHover;
            base.OnMouseEnter(ctl, args);
        }

        protected override void OnMouseLeave(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {
            currentTexture = textureNormal;
            base.OnMouseLeave(ctl, args);
        }

        protected override void OnMouseUp(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {
            currentTexture = textureHover;
            base.OnMouseUp(ctl, args);
        }
             
    }
}