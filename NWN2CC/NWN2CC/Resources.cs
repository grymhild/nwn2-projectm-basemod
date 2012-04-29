using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.IO;

namespace NWN2CC
{
    public abstract class Resources
    {
        public static Stream GetEmbeddedResource(string resourceFileName)
        {
            Assembly _assembly = Assembly.GetExecutingAssembly();

            string[] names = _assembly.GetManifestResourceNames();


            Stream _stream = _assembly.GetManifestResourceStream(resourceFileName);
            if (_stream != null)
                return _stream;
            else
                throw new Exception(resourceFileName + " was not found as an embedded resource.");
        }
    }
}
