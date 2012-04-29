using System;
using System.Collections.Generic;
using AvengersUTD.Odyssey.UserInterface.RenderableControls;

namespace AvengersUTD.Odyssey.UserInterface
{
    public class WindowManager
    {
        List<Window> windowList;

        public WindowManager()
        {
            windowList = new List<Window>();
        }

        public Window this[int index]
        {
            get
            {
                return windowList[index];
            }
        }

        public int Count
        {
            get { return windowList.Count; }
        }

        public Window Foremost
        {
            get
            {
                if (windowList.Count == 0)
                    return null;
                else
                    return windowList[windowList.Count - 1];
            }
        }

        public int RegisterWindow(Window window)
        {
            windowList.Add(window);
            return windowList.Count;
        }

        public void BringToFront(int windowId)
        {
            if (windowId == 0)
            {
                if (Count > 0 && Foremost.IsSelected)
                    Foremost.IsSelected = false;
                return;
            }

            BringToFront(windowList[windowId - 1]);
        }

        public void BringToFront(Window window)
        {
            if (window.Depth.WindowLayer == windowList.Count)
            {
                if (!Foremost.IsSelected)
                    Foremost.IsSelected = true;
                return;
            }


            UI.CurrentHud.BeginDesign();
            int windowOrder = windowList.Count;
            windowList.Remove(window);
            for (int i = 0; i < windowList.Count; i++)
            {
                Window currentWindow = windowList[i];
                currentWindow.Depth = new Depth(i + 1, currentWindow.Depth.ComponentLayer, currentWindow.Depth.ZOrder, currentWindow.Depth.UserDepth);
                currentWindow.IsSelected = false;
            }


            window.Depth = new Depth(windowOrder, window.Depth.ComponentLayer, window.Depth.ZOrder, window.Depth.UserDepth);
            window.IsSelected = true;
            //window.Focus();
            windowList.Add(window);
            //UI.CurrentHud.InternalControls.Sort();
            UI.CurrentHud.EndDesign();
        }

        public void Remove(Window window)
        {

            if (windowList.Contains(window))
            {
                windowList.Remove(window);
                for (int i = 0; i < windowList.Count; i++)
                {
                    Window currentWindow = windowList[i];
                    currentWindow.Depth = new Depth(i + 1, currentWindow.Depth.ComponentLayer, currentWindow.Depth.ZOrder, currentWindow.Depth.UserDepth);
                }
            }
        }
    }
}