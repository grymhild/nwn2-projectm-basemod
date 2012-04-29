using System.Drawing;
using AvengersUTD.Odyssey.UserInterface.Style;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{
    public class Window : Panel
    {
        const int DefaultBarPaddingY = 0;
        public const int DefaultBorderPadding = 0;

        protected CaptionBar captionBar;
        protected Panel containerPanel;
        protected PictureBox background;
        protected bool isModal;

        #region Default Colors

        protected new static ColorArray defaultColors = new ColorArray(
            Color.FromArgb(170, 0, 90, 120),
            Color.FromArgb(170, 0, 90, 120),
            //Color.FromArgb(170, 0, 150, 200),
            Color.FromArgb(170, 65, 105, 225),
            Color.Red,
            Color.FromArgb(170, 65, 105, 225),
            Color.FromArgb(170, 65, 105, 225),
            Color.Gray,
            Color.Gray);

        protected static ColorArray containerColors = new ColorArray(
            Color.FromArgb(170, 0, 90, 120),
            Color.MediumBlue,
            Color.FromArgb(170, 0, 150, 200),
            Color.Gray,
            Color.BlueViolet,
            Color.FromArgb(170, 0, 150, 200),
            Color.Gray,
            Color.Gray
            ); 
        #endregion

        #region Properties
        public bool IsModal 
        {
            get { return isModal;}
        }


        public Texture BackgroundTexture
        {
            get { return background.Texture; }
            set { background.Texture = value; }
        }

        public override ControlCollection Controls
        {
            get { return containerPanel.Controls; }
        }

        public string Title {
            get { return captionBar.TitleLabel.Text; }
            set { captionBar.TitleLabel.Text = value;}
        }

        internal Size InternalSize
        {
            get
            {
                return containerPanel.Size;
            }
            set
            {
                containerPanel.Size = value;
            }
        }

        internal CaptionBar CaptionBar
        {
            get { return captionBar; }
        }
        #endregion

        public event ControlEventHandler Closed;
        protected virtual void OnClosed(BaseControl ctl)
        {
            if (Closed != null)
                Closed(ctl);
        }

        public Window(string id, string title, Vector2 position, Size size) :
            this(id, title, position, size, defaultColors)
        {
        }

        public Window(string id, string title, Vector2 position, Size size, ColorArray colorArray) :
            this(id, title, position, size, colorArray, true)
        {
        }

        public Window(string id, string title, Vector2 position, Size size, ColorArray colorArray, bool showCaptionBar) :
            base(id, position, size, Shape.Rectangle, BorderStyle.None, Shapes.ShadeNone, colorArray)
        {
            isFocusable = true;
            applyStatusChanges = true;
            

            Size panelSize = new Size(size.Width - DefaultBorderPadding*2, size.Height - DefaultBorderPadding);
            Vector2 panelPos = new Vector2(DefaultBorderPadding, DefaultBarPaddingY);
            if (showCaptionBar)
            {
                captionBar = new CaptionBar(id + "_Caption", Vector2.Empty, title, size.Width);
                panelSize = new Size(size.Width - DefaultBorderPadding * 2, size.Height - captionBar.Size.Height - DefaultBarPaddingY - DefaultBorderPadding);
                panelPos = new Vector2(DefaultBorderPadding, captionBar.Size.Height + DefaultBarPaddingY);
            }
            containerPanel = new Panel(id + "_Container", panelPos, panelSize, Shape.Rectangle, BorderStyle.None, Shapes.ShadeNone, ColorArray.Transparent);
            containerPanel.CanRaiseEvents = false;
            containerPanel.IsSubComponent = true;

            background = new PictureBox(id + "_bkgrd", new Vector2(), size, null);
            //background.CanRaiseEvents = false;
            background.IsSubComponent = true;


            if (showCaptionBar)
            {
                captionBar.IsSubComponent = true;            
                Add(captionBar);
            }

            controls.Owner = containerPanel;
            Add(containerPanel);
            Add(background);
        }

        public override void Add(BaseControl ctl)
        {
            if (!ctl.IsSubComponent)
                containerPanel.Add(ctl);
            else
                base.Add(ctl);
        }

        public void BringToFront()
        {
            UI.CurrentHud.WindowManager.BringToFront(this);
        }

        public void Close()
        {
            HUD hud = UI.CurrentHud;
            hud.BeginDesign();
            hud.Remove(this);
            hud.EndDesign();
            OnClosed(this);
        }

        #region Overriden inherited events

        protected override void OnLostFocus(BaseControl ctl)
        {
            if (!IsChildControl(ctl))
                isSelected = false;

            base.OnLostFocus(ctl);
        }

        #endregion
    }
}