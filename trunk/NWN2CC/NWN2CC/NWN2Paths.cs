using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace NWN2CC
{
    public abstract class NWN2Paths
    {
        private static string nwn2mainpath;
        private static string nwn2documentspath;
        private static bool loaded = GetNWN2Paths();        

        private static bool GetNWN2Paths()
        {
            try
            {
                FileInfo fi = new FileInfo("NWN2Paths.txt");
                if (fi.Exists)
                {
                    StreamReader sr = fi.OpenText();
                    nwn2mainpath = sr.ReadLine();
                    nwn2documentspath = sr.ReadLine();
                    sr.Close();
                    return true;
                }
                else
                {
                    nwn2mainpath = null;
                    nwn2documentspath = null;                    
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return false;
        }

        public static string NWN2MainPath { get { return nwn2mainpath; } }
        public static string NWN2DocumentsPath { get { return nwn2documentspath; } }
        public static bool Loaded { get { return loaded; } }
    }
}
