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
    
    public class NewGameMenu : BaseScreen
    {

        public NewGameMenu(ContainerControl owner)  : base(owner)          
        {
            buttonFont = FontManager.GetFont("TitleB 10");
            btnTextureNormal = AssetManager.GetTexture("b_main_normal");
            btnTextureHover = AssetManager.GetTexture("b_main_hover");
            btnTexturePressed = AssetManager.GetTexture("b_main_hover_pressed");             
        }

        public override void Show()
        {
            myWindow = new Window("NewGameWnd", "NewGameWnd", new Vector2(415f, 443f), new Size(194, 135), ColorArray.Transparent, false);
            UI.CurrentHud.BeginDesign();
            myOwner.Add(myWindow);
            myWindow.BorderStyle = BorderStyle.None;
            myWindow.BringToFront();

            AddButton("New Campaign", "New Campaign", 0f, 0f, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            AddButton("New Module", "New Module", 0, 46 * 1, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            AddButton("NewGameCancel", "Cancel", 0f, 46 * 2, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            UI.CurrentHud.EndDesign();
        }
    }
}
