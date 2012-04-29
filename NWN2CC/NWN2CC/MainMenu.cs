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
    public class MainMenu : BaseScreen
    {        
        public MainMenu(ContainerControl owner) : base(owner)           
        {                       
            buttonFont = FontManager.GetFont("TitleB 10");
            btnTextureNormal     = AssetManager.GetTexture("b_main_normal");
            btnTextureHover = AssetManager.GetTexture("b_main_hover");
            btnTexturePressed = AssetManager.GetTexture("b_main_hover_pressed");            
        }

        public override void Show()
        {            
            myWindow = new Window("MainMenuWnd", "MainMenuWnd", new Vector2(415f, 423f), new Size(194, 273), ColorArray.Transparent, false);
            UI.CurrentHud.BeginDesign();
            myOwner.Add(myWindow);
            myWindow.BorderStyle = BorderStyle.None;
            myWindow.BringToFront();

            AddButton("New Game", "New Game", 0f, 0f, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            AddButton("Load Game", "Load Game", 0, 46 * 1, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            AddButton("Multiplayer", "Multiplayer", 0f, 46 * 2, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            AddButton("Options", "Options", 0f, 46 * 3, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            AddButton("Credits", "Credits", 0f, 46 * 4, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            AddButton("Exit Game", "Exit Game", 0f, 46 * 5, 194, 43, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);
            UI.CurrentHud.EndDesign();
        }
    }
}
