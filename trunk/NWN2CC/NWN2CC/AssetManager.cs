using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace NWN2CC
{
    public abstract class AssetManager
    {

        private static Dictionary<string, Texture> textureAssets = new Dictionary<string,Texture>();
        public static Device Device;

        public static void ClearAll()
        {
            textureAssets.Clear();
        }

        public static void LoadTextureFromFile(string ID, string filename)
        {
            if (Device == null)
                throw new Exception("Device is null");

            if (textureAssets.ContainsKey(ID))
                throw new Exception("Texture key already exists");

            ImageInformation iminfo = TextureLoader.ImageInformationFromFile(filename);
            Texture texture = TextureLoader.FromFile(Device, filename, iminfo.Width, iminfo.Height, iminfo.MipLevels, Usage.None,  iminfo.Format, Pool.Default, Filter.None, Filter.None, 0);
            textureAssets.Add(ID, texture);
        }

        public static void LoadTextureFromStream(string ID, Stream stream)
        {
            if (Device == null)
                throw new Exception("Device is null");

            if (textureAssets.ContainsKey(ID))
                throw new Exception("Texture key already exists");

            ImageInformation iminfo = TextureLoader.ImageInformationFromStream(stream);
            stream.Seek(0, SeekOrigin.Begin);
            Texture texture = TextureLoader.FromStream(Device, stream, iminfo.Width, iminfo.Height, iminfo.MipLevels, Usage.None,  iminfo.Format, Pool.Default, Filter.None, Filter.None, 0);
            textureAssets.Add(ID, texture);
        }

        public static Texture GetTexture(string ID)
        {
            return textureAssets[ID];
        }
    }
}
