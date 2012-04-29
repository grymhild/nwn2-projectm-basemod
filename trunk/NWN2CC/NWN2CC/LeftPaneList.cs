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
    public class LeftPaneList : BaseScreen
    {
        Texture bkgrdTexture, selectedbtnTexture, btnScrollUpTexture, btnScrollDownTexture, scrollMarkerTexture;
        string myID;

        public LeftPaneList(string id, ContainerControl owner) : base(owner)       
        {
            myID = id;
            buttonFont = FontManager.GetFont("TitleB 10");
            btnTextureNormal = AssetManager.GetTexture("b_main_sm_normal");
            btnTextureHover = AssetManager.GetTexture("b_main_sm_hover");
            btnTexturePressed = AssetManager.GetTexture("b_main_sm_hover_pressed");
            bkgrdTexture = AssetManager.GetTexture("module_list");            
        }

        public override void Show()
        {
            myWindow = new Window(myID, myID, new Vector2(9f, 386f), new Size(614, 333), ColorArray.Transparent, false);
            myWindow.BackgroundTexture = bkgrdTexture;

            UI.CurrentHud.BeginDesign();
            myOwner.Add(myWindow);
            myWindow.BringToFront();


            UI.CurrentHud.EndDesign();
        }
    }
}
