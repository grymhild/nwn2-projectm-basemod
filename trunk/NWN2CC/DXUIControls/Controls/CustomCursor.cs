using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.IO;
using AvengersUTD.Odyssey.UserInterface.Helpers;

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{
    public static class CustomCursor
    {
        static Dictionary<string, IntPtr> myCursors = new Dictionary<string, IntPtr>();

        //IntPtr defaultCursor;
        //IntPtr downCursor;
        //IntPtr waitCursor;

        [DllImport("user32.dll")]
        private static extern IntPtr LoadCursorFromFile(string filename);

        public static void LoadCustomCursor(string cursorName, Stream cursorData)
        {
            try
            {
                if (!myCursors.ContainsKey(cursorName))
                {
                    string tempfile = Path.GetTempFileName();
                    Stream file = File.OpenWrite(tempfile);
                    cursorData.CopyTo(file);
                    file.Flush();
                    file.Close();                    
                    IntPtr cursor = LoadCursorFromFile(tempfile); //Why write it to a file? Because this function can't read from an embedded resource.
                    myCursors.Add(cursorName, cursor);
                    File.Delete(tempfile);
                }
                else
                    throw new Exception("Cursor name: " + cursorName + " must be unique.");
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to load cursor");
            }
        }

        public static void RemoveCustomCursor(string cursorName)
        {
            myCursors.Remove(cursorName);
        }

        public static System.Windows.Forms.Cursor GetCursor(string cursorName)
        {            
            IntPtr customCursorHandle;
            if (myCursors.TryGetValue(cursorName, out customCursorHandle))
            {
                System.Windows.Forms.Cursor formCursor = new System.Windows.Forms.Cursor(System.Windows.Forms.Cursor.Current.Handle);
                formCursor.GetType().InvokeMember("handle", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.SetField, null, formCursor, new object[] { customCursorHandle });
                return formCursor;
            }
            throw new Exception("Invalid cursor name: " + cursorName);
        }
    }
}
