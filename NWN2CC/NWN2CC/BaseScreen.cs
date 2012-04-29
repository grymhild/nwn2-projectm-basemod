using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using AvengersUTD.Odyssey.UserInterface.RenderableControls;
using AvengersUTD.Odyssey.UserInterface;
using AvengersUTD.Odyssey.UserInterface.Helpers;
using Font = Microsoft.DirectX.Direct3D.Font;

namespace NWN2CC
{
    public abstract class BaseScreen
    {
        public delegate void ButtonEventHandler(string buttonID);
        public event ButtonEventHandler ButtonPress;
        public event ButtonEventHandler ButtonDown;
        public event MouseEventHandler MouseMove;
        
        protected Window myWindow;
        protected ContainerControl myOwner;
        protected Font buttonFont;
        protected Texture btnTextureNormal, btnTextureHover, btnTexturePressed;
        
        public BaseScreen(ContainerControl owner)            
        {
            myOwner = owner; 
        }

        protected virtual void AddButton(string id, string text, float x, float y, int width, int height, Font font, Texture textureNormal, Texture textureHover, Texture texturePressed)
        {
            Button btn1 = new Button(id, text, new Vector2(x, y), new Size(width, height), Shape.Rectangle);
            
            btn1.BorderStyle = BorderStyle.None;
            btn1.TextureNormal = textureNormal;
            btn1.TextureHover = textureHover;
            btn1.TexturePressed = texturePressed;
            btn1.Font = font;
            btn1.TextColor = Color.FromArgb(255, 219, 231, 242);
            btn1.MouseUp += new MouseEventHandler(btn1_MouseUp);
            btn1.MouseDown += new MouseEventHandler(btn1_MouseDown);
            btn1.MouseMove += new MouseEventHandler(btn1_MouseMove);
            myWindow.Add(btn1);
            btn1.UserDepth = 2;
        }

        protected virtual void btn1_MouseDown(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {
            if (ButtonDown != null)
                ButtonDown(ctl.ID);
        }

        protected virtual void btn1_MouseMove(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {            
            if (MouseMove != null)
                MouseMove(ctl, args);            
        }

        protected virtual void btn1_MouseUp(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {            
            if (ButtonPress != null)
                ButtonPress(ctl.ID);
        }

        public abstract void Show();

        public virtual void Close()
        {
            if (myWindow != null)
                myWindow.Close();
        }
    }
}
